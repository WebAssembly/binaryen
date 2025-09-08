# Contributing to WebAssembly

Interested in participating? Please follow
[the same contributing guidelines as the design repository][].

  [the same contributing guidelines as the design repository]: https://github.com/WebAssembly/design/blob/main/Contributing.md

Also, please be sure to read [the README.md](README.md) for this repository.

## Adding support for new instructions

Use this handy checklist to make sure your new instructions are fully supported:

 - [ ] Instruction class or opcode added to src/wasm.h
 - [ ] Instruction class added to src/wasm-builder.h
 - [ ] Instruction class added to src/wasm-traversal.h
 - [ ] Validation added to src/wasm/wasm-validator.cpp
 - [ ] Interpretation added to src/wasm-interpreter.h
 - [ ] Effects handled in src/ir/effects.h
 - [ ] Precomputing handled in src/passes/Precompute.cpp
 - [ ] Parsing added in scripts/gen-s-parser.py, src/parser/parsers.h, src/parser/contexts.h, src/wasm-ir-builder.h, and src/wasm/wasm-ir-builder.cpp
 - [ ] Printing added in src/passes/Print.cpp
 - [ ] Decoding added in src/wasm-binary.h and src/wasm/wasm-binary.cpp
 - [ ] Binary writing added in src/wasm-stack.h and src/wasm/wasm-stack.cpp
 - [ ] Support added in various classes inheriting OverriddenVisitor (and possibly other non-OverriddenVisitor classes as necessary)
 - [ ] Support added to src/tools/fuzzing.h
 - [ ] C API support added in src/binaryen-c.h and src/binaryen-c.cpp
 - [ ] JS API support added in src/js/binaryen.js-post.js
 - [ ] C API tested in test/example/c-api-kitchen-sink.c
 - [ ] JS API tested in test/binaryen.js/kitchen-sink.js
 - [ ] Tests added in test/spec
 - [ ] Tests added in test/lit
