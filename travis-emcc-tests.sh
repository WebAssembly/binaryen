set -e
echo "travis-test build"
emconfigure cmake -DCMAKE_BUILD_TYPE=Release
emmake make -j4 binaryen_js
cp bin/binaryen_js.js out/binaryen.js
echo "travis-test test"
python -m scripts.test.binaryenjs
echo "travis-test yay!"
