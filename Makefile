.PHONY: start stop test clean

var/log: 
	mkdir -p var/log

start: node_modules var/log
	./bin/start.sh

exec_start: node_modules var/log
	exec ./bin/start.sh managed

stop:
	./bin/stop.sh

test: node_modules src/server.coffee var/log
	-@$(MAKE) stop > test/test.log 2>&1
	$(MAKE) start -e DEBUG=true -e STORAGE_ROOT=${PWD}/test/test_storage >> test/test.log 2>&1
	./test/run.sh ${TEST_NAME}| tee test/test.log 2>&1
	-@$(MAKE) stop > test/test.log 2>&1

node_modules:
	npm install .

clean: 
	rm -rf ./node_modules/
