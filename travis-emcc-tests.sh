set -e
echo "travis-test build"
cd js
emmake make -j4 WasmIntrinsics.cpp binaryen.debug.js
cd ..
cp out/binaryen.debug.js out/binaryen.js
echo "travis-test test"
python -m scripts.test.binaryenjs
echo "travis-test yay!"
