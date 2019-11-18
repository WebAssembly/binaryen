set -e
echo "travis-test build"
echo `pwd`
cd js
echo `pwd`
emmake make binaryen.debug.js -j4
cd ..
cp out/binaryen.debug.js out/binaryen.js
echo "travis-test test"
python -m scripts.test.binaryenjs
echo "travis-test yay!"
