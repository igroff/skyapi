#! /usr/bin/env bash

function run_tests(){
  DIR=$1
  for test in $DIR/*;
  do
    if [ -d ${test} ]; then
      run_tests ${test}
    else
      test_file=${test}
      results_file=${test%tests/*}results${test#*/tests}
      expected_file=${test%tests/*}expected${test#*/tests}
      # as a convenience we'll clean up anything in the test_storage
      # directory (below us) and as a convenience this is the only directory
      # we'll do this to to limit the likelihood os screwing things up
      if [ -d ${PWD}/test/test_storage ]; then
        find ${PWD}/test/test_storage/ -type f | xargs rm
      fi
      mkdir -p `dirname $results_file`
      $test_file > $results_file 2>&1
      diff $results_file $expected_file
      if [ $? == 0 ]; then
        echo SUCCESS: $test_file
      else
        echo FAILED: $test_file
      fi
    fi
  done
}

run_tests ./test/tests
