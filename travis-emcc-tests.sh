# FIXME set -e
echo "install"
apt-get install python3
echo "travis-test build"
./build-js.sh -g
echo "travis-test test"
./scripts/test/binaryenjs.py
echo "travis-test yay!"
