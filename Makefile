.PHONY: start stop test clean

var/log: 
	mkdir -p var/log

start: node_modules var/log
	./bin/start.sh

exec_start:
	./bin/start.sh managed

stop:
	./bin/stop.sh

test: node_modules src/server.coffee
	./test/run.sh

node_modules:
	npm install .

clean: 
	rm -rf ./node_modules/
