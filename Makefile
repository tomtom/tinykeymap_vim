PLUGIN=tinykeymap
VIMFILES=~/vimfiles
VIMBALLS=${VIMFILES}/vimballs
TVIM=${VIMFILES}/tvim
HOSTNAME=`hostname`

setup:
	cd ..; ./setup_dir.rb ${PLUGIN}_vim

tags:
	rm doc/tags || echo ignore
	ctags `git ls-files`
	vim -c 'helptags doc'

docs:
	mkdir -p doc
	cd ${VIMFILES}; ./make_dedoc.rb -u -v ${PLUGIN}
	vim -u NONE -U NONE -c "helptags doc" -c q
	git status

yaml:
	vimscriptdef.rb --format vba --config ${TVIM}/vsd_config.yml \
        --recipe ${VIMBALLS}/${PLUGIN}.recipe
	cat ${VIMBALLS}/${PLUGIN}.yml || echo No YAML file was created

build: docs
	if HOSTNAME=${HOSTNAME} vimball.rb -u -- vba ${VIMBALLS}/${PLUGIN}.recipe | grep "vimball: Save as:"; then \
        make -B yaml; \
    fi

gg:
	git gui

changes:
	# echo ------------------------------------------------- >> CHANGES.TXT
	# date >> CHANGES.TXT
	grep -v -E '^(file:|id:|message:|---)' ${VIMBALLS}/${PLUGIN}.yml >> CHANGES.TXT
	echo >> CHANGES.TXT
	git add CHANGES.TXT && git commit -m docs CHANGES.TXT

gittag:
	export VERSION=`vimscriptdef.rb --recipe ${VIMBALLS}/${PLUGIN}.recipe --print-version ${PLUGIN}`; \
	if ! git tag | grep -q $${VERSION}; then \
	git tag $${VERSION}; \
	else \
	echo Version tag already exists $${VERSION}; \
	exit 5; \
	fi

repo:
	git push --thin --tags origin master
	touch .last_push_origin

vim.org:
	vimscriptuploader.rb --config ${TVIM}/vsu_config.yml \
		${VIMBALLS}/${PLUGIN}.yml

upload: gittag changes repo vim.org

