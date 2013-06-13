.PHONY: start stop test

var/log: 
	mkdir -p var/log

start:
	./bin/start.sh

stop:
	./bin/stop.sh

test:
	./test/run.sh
