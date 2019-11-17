set -e
echo "travis-test build"
cd js
emmake make WasmIntrinsics.cpp
emmake make binaryen.debug.js -j4
cd ..
cp out/binaryen.debug.js out/binaryen.js
echo "travis-test test"
python -m scripts.test.binaryenjs
echo "travis-test yay!"
