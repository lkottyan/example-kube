#!/usr/bin/env bash


SCRIPT_ROOT=$(dirname "${BASH_SOURCE}")
cd $SCRIPT_ROOT

test_request () {
    curl -fisS http://$(minikube ip):$1 >> log 2>>err.log
    echo -e '\n' >> log
}

rm -f log err.log 

# Test apps listening on different ports
echo -e '\nTesting started'

test_request 30500
test_request 30400
test_request 30300

echo -e '\nTesting finished'

if [ -s "log" ]; then
  echo -e "\nRESPONSES:\n"
  cat log
fi

if [ -s "err.log" ]; then
  echo -e "\nERRORS:\n"
  cat err.log
fi

[ -s err.log ] && exit 1 || exit 0 