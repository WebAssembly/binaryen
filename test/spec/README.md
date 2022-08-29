This directory contains tests for the core WebAssembly semantics, as described in [Semantics.md](https://github.com/WebAssembly/design/blob/master/Semantics.md) and specified by the [spec interpreter](https://github.com/WebAssembly/spec/blob/master/interpreter).

Tests are written in the [S-Expression script format](https://github.com/WebAssembly/spec/blob/master/interpreter/README.md#s-expression-syntax) defined by the interpreter.

To execute all spec tests, run the following command from the binaryen top-level directory:
```
./check.py spec
```

Individual spec tests may be executed by running the following command from the binaryen top-level directory:
```
bin/wasm-shell [path to spec test]
```
