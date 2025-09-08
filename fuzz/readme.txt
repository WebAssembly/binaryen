The wasm contents of this directory (*.wasm, *.wast, *.wat files) are treated as
important contents by the fuzzer, which will test them with high frequency. This
is useful when you have some local files you want the fuzzer to focus on.
