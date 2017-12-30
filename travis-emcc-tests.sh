set -e
echo "travis-test pre-test"
python -c "import check ; check.run_binaryen_js_tests() ; check.run_emscripten_tests()"
echo "travis-test build"
ls -al bin/
./build-js.sh -g
ls -al bin/
echo "travis-test post-test"
python -c "import check ; check.run_binaryen_js_tests() ; check.run_emscripten_tests()"
echo "travis-test yay!"

