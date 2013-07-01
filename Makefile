.PHONY: start stop test clean

var/log: 
	mkdir -p var/log

start: node_modules var/log
	./bin/start.sh

exec_start: node_modules var/log
	exec ./bin/start.sh managed

stop:
	./bin/stop.sh

test: node_modules src/server.coffee
	-@$(MAKE) stop
	$(MAKE) start -e STORAGE_ROOT=${PWD}/storage
	./test/run.sh
	-@$(MAKE) stop

node_modules:
	npm install .

clean: 
	rm -rf ./node_modules/
