set -e
echo "travis-test build"
./build-js.sh -g
echo "travis-test test"
python -c "import check ; check.run_binaryen_js_tests()"
echo "travis-test yay!"
