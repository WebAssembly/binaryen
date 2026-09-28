# Contributing to Binaryen

Interested in participating? Please follow
[the same contributing guidelines as the design repository](https://github.com/WebAssembly/design/blob/main/Contributing.md).

Also, please be sure to read [the README.md](README.md) for this repository.

## AI Contribution Policy

Contributors may use whatever tools they would like to craft their contributions, but there must be a human in the loop. Contributors must self-review and understand all code and documentation updates (with or without AI tooling) before sending them for review to ensure the correctness, design, and style meet the standards of the project. The contributor is always the author and is fully accountable for their contributions. Contributors should be sufficiently confident that the contribution is high enough quality that asking for a review is a good use of scarce maintainer time, and they should be able to answer questions about their work during review. To aid reviewers, contributors should flag areas they are not confident about that had AI assistance. This can be done in PR comments, the PR description, or in code comments.

Contributors must attest that the code they submit is their original creation, regardless of whether AI tooling was used.

When engaged in discussion (code review, bugs, etc), a human reply must get a human reply. Even in cases where an AI agent initiates a conversation (e.g. by filing a bug or writing a PR description), its human operator is responsible for the content of its output, including its correctness and quality.

This policy borrows heavily from the policies of [LLVM](https://llvm.org/docs/AIToolPolicy.html) and [Chromium](https://chromium.googlesource.com/chromium/src/+/main/agents/ai_policy.md).

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
    - [ ] Tests are used as seeds for the fuzzer. If V8 doesn't support the
    test, or if the new instruction isn't guarded by a wasm-validator check,
    then either add the corresponding feature to DISALLOWED_FEATURES_IN_V8 or 
    mark the test as unfuzzable.
