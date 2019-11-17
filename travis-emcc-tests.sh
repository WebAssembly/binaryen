set -e
echo "travis-test build"
cd js
emmake make -j4 binaryen.debug.js
cd ..
echo "travis-test test"
python -m scripts.test.binaryenjs
echo "travis-test yay!"
