Changelog
=========

This document describes changes between tagged Binaryen versions.

To browse or download snapshots of old tagged versions, visit
https://github.com/WebAssembly/binaryen/releases.

Not all changes are documented here. In particular, new features, user-oriented
fixes, options, command-line parameters, usage changes, deprecations,
significant internal modifications and optimizations etc. generally deserve a
mention. To examine the full set of changes between versions, visit the link to
full changeset diff at the end of each section.

Current Trunk
-------------

- Add `--fast-math` mode. (#3155)

v97
---

- Remove asm2wasm, which supported Emscripten's fastcomp backend, after fastcomp
  was removed.
- The new feature flag `--enable-anyref` enables just the `anyref` type incl.
  basic subtyping of `externref`, `funcref` and `exnref` (if enabled).
- Enabling the exception handling or anyref features without also enabling
  reference types is a validation error now.
- The `Host` expression and its respective APIs have been refactored into
  separate `MemorySize` and `MemoryGrow` expressions to align with other memory
  instructions.

v96
---

- Fuzzing: Compare wasm2js to the interpreter (#3026)
- Fix CountLeadingZeroes on MSVC, which lead to bad optimizations (#3028)
- Asyncify verbose option (#3022)
- wasm2js: Add an "Export" scope for name resolution, avoids annoying
  warnings (#2998)
- Extend the C- and JS-APIs (#2586)

v95
---

- Add Asyncify "add list" that adds to the list of functions to be instrumented.
  Rename old lists to be clearer and more consistent with that, so now there is
  "remove list" to remove, "add list" to add, and "only list" which if set means
  that only those functions should be instrumented and nothing else.
- Renamed various ambiguous C-API functions for consistency:
  - `BinaryenBlockGetChild` to `BinaryenBlockGetChildAt`
  - `BinaryenSwitchGetName` to `BinaryenSwitchGetNameAt`
  - `BinaryenCallGetOperand` to `BinaryenCallGetOperandAt`
  - `BinaryenCallIndirectGetOperand` to `BinaryenCallIndirectGetOperandAt`
  - `BinaryenHostGetOperand` to `BinaryenHostGetOperandAt`
  - `BinaryenThrowGetOperand` to `BinaryenThrowGetOperandAt`
  - `BinaryenTupleMakeGetOperand` to `BinaryenTupleMakeGetOperandAt`

v94
---

- The C-API's `BinaryenSetAPITracing` and the JS-API's `setAPITracing` have been
  removed because this feature was not very useful anymore and had a significant
  maintainance cost.
- wasm-emscripten-finalize will no longer generate `stackSave`, `stackAlloc`,
  `stackRestore` function.  It not expects them to be included in the input
  file.

v93
---

- First release with binaries built with github actions.


v92
---

- The `multivalue` feature has been added. It allows functions and control flow
  structures to return tuples and for locals and globals to have tuple types.
  Tuples are created with the new `tuple.make` pseudoinstruction and their
  elements are retrieved with the new `tuple.extract` pseudoinstruction.
- The internal type interner has been rewritten to avoid taking locks in far
  more situations. Depending on the workload, this may result in large speedups
  and increased parallelism.
- Represent the `dylink` section in Binaryen IR, so we can read, write, and
  update it.

v91
---

- `BinaryenExpressionGetSideEffects` (C API) and `getSideEffects` (JS API) now
  takes an additional `features` parameter.
- Reference type support is added. Supported instructions are `ref.null`,
  `ref.is_null`, `ref.func`, and typed `select`. Table instructions are not
  supported yet. For typed `select`, C/JS API can take an additional 'type'
  parameter.

v90
---

- `local.tee`'s C/Binaryen.js API now takes an additional type parameter for its
  local type, like `local.get`. This is required to handle subtypes.
- Added load_splat SIMD instructions
- Binaryen.js instruction API changes:
  - `notify` -> `atomic.notify`
  - `i32.wait` / `i64.wait` -> `i32.atomic.wait` / `i64.atomic.wait`
- Binaryen.js: `flags` argument in `setMemory` function is removed.
- `atomic.fence` instruction support is added.
- wasm-emscripten-finalize: Don't rely on name section being present in the
  input. Use the exported names for things instead.
- Added `mutable` parameter to BinaryenAddGlobalImport.
- Replace BinaryenSIMDBitselect* with BinaryenSIMDTernary* in the C API and add
  qfma/qfms instructions.
- Added `offset` parameter to BinaryenSetFunctionTable.
- Add the ability to create multivalue Types in the C and JS APIs.
- Remove named function types. They are replaced by `params` and `results` types
  local to each function.
- Binaryen.js can now be compiled to Wasm using the `binaryen_wasm` target.
  Unlike the JS variant, the Wasm variant requires asynchronously awaiting the
  Wasm blob's instantiation and initialization before being usable, using the
  `binaryen.ready` promise, e.g. `binaryen.ready.then(() => ...)`.
- Binaryen.js now uses `binaryen` (was `Binaryen`) as its global name to align
  with the npm package.
- Binaryen.js: The result of `getMemorySegmentInfoByIndex` now has the same
  structure as the respective inputs on creation (`byteOffset` -> `offset`).

v88
---

- wasm-emscripten-finalize: For -pie binaries that import a mutable stack
  pointer we internalize this an import it as immutable.
- The `tail-call` feature including the `return_call` and `return_call_indirect`
  instructions is ready to use.

v87
---

- Rename Bysyncify => Asyncify

v86
---

- The --initial-stack-pointer argument to wasm-emscripten-finalize no longer
  has any effect.  It will be removed completely in future release.

v85
---

- Wast file parsing rules now don't allow a few invalid formats for typeuses
  that were previously allowed. Typeuse entries should follow this format,
  meaning they should have (type) -> (param) -> (result) order if more than one
  of them exist.
  ```
  typeuse ::= (type index|name)+ |
              (type index|name)+ (param ..)* (result ..)* |
              (param ..)* (result ..)*
  ```
  Also, all (local) nodes in function definition should be after all typeuse
  elements.
- Removed APIs related to deprecated instruction names in Binaryen.js:
  - `get_local` / `getLocal`
  - `set_local` / `setLocal`
  - `tee_local` / `teeLocal`
  - `get_global` / `getGlobal`
  - `set_global` / `setGlobal`
  - `current_memory` / `currentMemory`
  - `grow_memory` / `growMemory`
  They are now available as their new instruction names:
  `local.get`, `local.set`, `local.tee`, `global.get`, `global.set`,
  `memory.size`, and `memory.grow`.
- Add feature handling to the C/JS API with no feature enabled by default.

v84
---

- Generate dynCall thunks for any signatures used in "invoke" calls.

v81
---

- Fix AsmConstWalker handling of string address in arg0 with -fPIC code

v80
---

- Change default feature set in the absence of a target features section from
  all features to MVP.

v79
---

- Improve support for side modules

v78
---

- Add `namedGlobals` to metadata output of wasm-emscripten-finalize
- Add support for llvm PIC code.
- Add --side-module option to wasm-emscripten-finalize.
- Add `segmentPassive` argument to `BinaryenSetMemory` for marking segments
  passive.
- Make `-o -` print to stdout instead of a file named "-".

v73
---

- Remove wasm-merge tool.

v73
---

- Remove jsCall generation from wasm-emscripten-finalize.  This is not needed
  as of https://github.com/emscripten-core/emscripten/pull/8255.

v55
---

- `RelooperCreate` in the C API now has a Module parameter, and
  `RelooperRenderAndDispose` does not.
  - The JS API now has the `Relooper` constructor receive the `Module`.
- Relooper: Condition properties on Branches must not have side effects.

older
-----

- `BinaryenSetFunctionTable` in the C API no longer accepts an array of
  functions, instead it accepts an array of function names, `const char**
  funcNames`. Previously, you could not include imported functions because they
  are of type `BinaryenImportRef` instead of `BinaryenFunctionRef`. #1650

- `BinaryenSetFunctionTable` in the C API now expects the initial and maximum
  table size as additional parameters, like `BinaryenSetMemory` does for pages,
  so tables can be grown dynamically. #1687

- Add `shared` parameters to `BinaryenAddMemoryImport` and `BinaryenSetMemory`,
  to support a shared memory. #1686
