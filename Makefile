.PHONY: all compile clean ct test_deps

all: compile

compile:
	@echo "Fetching dependencies..."
	@rebar3 get-deps
	@echo "Compiling..."
	@rebar3 compile

ct: compile test_deps
	@echo "Running common tests..."
	-@ct_run -noshell -pa ebin \
		-pa deps/*/ebin \
		-pa test/deps/*/ebin \
		-name test \
		-logdir ./logs \
		-env TEST_DIR ./test \
		-spec ./test/test_specs.spec \
		-dir test >> ./logs/raw.log 2>&1
	@grep -h "TEST COMPLETE" logs/raw.log | tail -1

test_deps:
	@echo "Checking dependencies for test..."
	@cd test && rebar get-deps && rebar compile && cd ..

clean:
	@rebar3 clean
	@cd test && rebar clean && cd ..

distclean: clean
	@rm -rf ./deps/ && rm -rf ./test/deps/
