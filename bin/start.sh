#! /usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ROOT_DIR=$PWD
export BIN_DIR=${ROOT_DIR}/bin
export SERVER_HOST=127.0.0.1
export SERVER_PORT=${SERVER_PORT-8080}
source ${DIR}/nvm.sh

nvm use 0.10.10 >> /dev/null 2>&1

if [ "$1x" == "x" ]; then
  ./node_modules/.bin/forever \
    start \
    -l $ROOT_DIR/var/log/server.log \
    -a \
    --watch --watchDirectory ${ROOT_DIR}/src \
    -c ./node_modules/.bin/coffee ${ROOT_DIR}/src/server.coffee
elif [ "$1" == "managed" ]; then
    ./node_modules/.bin/coffee ${ROOT_DIR}/src/server.coffee
else
  COMMAND_TO_RUN="$@"
  ${COMMAND_TO_RUN}
fi
