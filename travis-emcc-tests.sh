set -e
echo "travis-test build"
./build-js.sh -g
echo "travis-test test"
python3 -m scripts.test.binaryenjs
echo "travis-test yay!"
