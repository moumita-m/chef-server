SHELL := /bin/bash

RELX_VERSION = 3.3.2

##PROJ = bifrost
CT_DIR = common_test

REL_HOOK = VERSION compile

CLEAN_HOOK = version_clean

DIALYZER_OPTS =

DIALYZER_SRC = -r apps/bifrost/ebin

ct: clean_ct compile
	time $(REBARC) ct skip_deps=true

ct_fast: clean_ct
	time $(REBARC) compile ct skip_deps=true

# Runs a specific test suite
# e.g. make ct_deliv_hand_user_authn
# supports a regex as argument, as long as it only matches one suite
ct_%: clean_ct
	@ SUITE=$$(if [ -f "$(CT_DIR)/$*_SUITE.erl" ]; then \
		echo "$*"; \
	else \
		FIND_RESULT=$$(find "$(CT_DIR)" -name "*$**_SUITE\.erl"); \
		[ -z "$$FIND_RESULT" ] && echo "No suite found with input '$*'" 1>&2 && exit 1; \
		NB_MACTHES=$$(echo "$$FIND_RESULT" | wc -l) && [[ $$NB_MACTHES != 1 ]] && echo -e "Found $$NB_MACTHES suites matching input:\n$$FIND_RESULT" 1>&2 && exit 1; \
		echo "$$FIND_RESULT" | perl -wlne 'print $$1 if /\/([^\/]+)_SUITE\.erl/'; \
	fi) && COMMAND="time $(REBARC) ct suite=$$SUITE" && echo $$COMMAND && eval $$COMMAND;

clean_ct:
	@rm -f $(CT_DIR)/*.beam
	@rm -rf logs

## Pull in devvm.mk for relxy goodness
include devvm.mk
install: VERSION $(CURDIR)/deps

travis: all

version_clean:
	@rm -f VERSION

## echo -n only works in bash shell
SHELL=bash
REL_VERSION ?= $$(git log --oneline --decorate | grep -v -F "jenkins" | grep -F "tag: " --color=never | head -n 1 | sed  "s/.*tag: \([^,)]*\).*/\1/")-$$(git rev-parse --short HEAD)
VERSION: version_clean
	@echo -n $(REL_VERSION) > VERSION
