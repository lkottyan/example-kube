#!/usr/bin/env bash


SCRIPT_ROOT=$(dirname "${BASH_SOURCE}")
cd $SCRIPT_ROOT

test_request () {
    docker exec -it kind-control-plane curl -fisS http://localhost:$1 >> log 2>>err.log
    docker exec -it kind-control-plane echo -e '\n' >> log
}

docker exec -it kind-control-plane rm -f log err.log 

# Test apps listening on different ports
echo -e '\nTesting started'

test_request 30500
test_request 30400
test_request 30300

echo -e '\nTesting finished'

docker exec -it kind-control-plane test -s "log")
if [ $(echo $?) -eq 0 ]; then
  echo -e "\nRESPONSES:\n"
  docker exec -it kind-control-plane cat "log")
fi

docker exec -it kind-control-plane test -s "err.log")
if [ $(echo $?) -eq 0 ]; then
  echo -e "\nERRORS:\n"
  docker exec -it kind-control-plane cat "err.log")
fi

docker exec -it kind-control-plane test -s "err.log")
[ $(echo $?) -eq 0 ] && exit 1 || exit 0 