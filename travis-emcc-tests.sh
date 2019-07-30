set -e
echo "travis-test build"
./build-js.sh -g
echo "travis-test test"
python3 ./scripts/test/binaryenjs.py
echo "travis-test yay!"
