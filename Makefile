PROJECT = lfeysession
ROOT_DIR = $(shell pwd)
REPO = $(shell git config --get remote.origin.url)
LFE_DIR = _build/default/lib/lfe
LFE = $(LFE_DIR)/bin/lfe
EBIN_DIRS = $(ERL_LIBS):$(shell rebar3 path -s:)

compile:
	@rebar3 compile

repl: compile
	@ERL_LIBS=$(EBIN_DIRS) $(LFE)

shell:
	@rebar3 shell

clean:
	@rebar3 clean
	@rm -rf ebin/* _build/default/lib/$(PROJECT)

clean-all: clean
	@rebar3 as dev lfe clean
