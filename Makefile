DEPLOY_PATH = /tmp/
DEPLOY_SYMLINK = .content
DIRECTORY_ALPHA = .alpha
DIRECTORY_BETA = .beta

SHELL = /bin/bash
FILES = $(shell find * -maxdepth 1 | egrep -v "^(_site|Makefile)")

.PHONY: update

build: _site

_site: ${FILES}
	jekyll build

update:
	git pull

ifeq ($(shell readlink ${DEPLOY_PATH}${DEPLOY_SYMLINK}), ${DEPLOY_PATH}${DIRECTORY_ALPHA})
deploy: ${DEPLOY_PATH}${DIRECTORY_BETA}
else
deploy: ${DEPLOY_PATH}${DIRECTORY_ALPHA}
endif

${DEPLOY_PATH}${DIRECTORY_ALPHA} ${DEPLOY_PATH}${DIRECTORY_BETA}: ${FILES}
	mkdir -p "$@"
	jekyll build --destination "$@"
	ln -fns "$(notdir $@)" "${DEPLOY_PATH}${DEPLOY_SYMLINK}"