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

v105
---
- This release contains binaries for ARM64 MacOS devices (#4397)
- Otherwise, mostly bug fixes and incremental optimization improvements.

v104
----
- Bugfixes only, release created due to incorrect github release artifacts in
  v103 release (#4398).

v103
----

- The EffectAnalyzer now takes advantage of immutability of globals. To achieve
  that it must have access to the module. That is already the case in the C++
  API, but the JS API allowed one to optionally not add a module when calling
  `getSideEffects()`. It is now mandatory to pass in the module.
- JS and Wasm builds now emit ECMAScript modules. New usage is:
  ```js
  import Binaryen from "path/to/binaryen.js";
  const binaryen = await Binaryen();
  ...
  ```
- CallIndirect changed from storing a Signature to storing a HeapType

v102
----

- Add `BinaryenUpdateMaps` to the C API.

- Adds a TrapsNeverHappen mode (#4059). This has many of the benefits of
  IgnoreImplicitTraps, but can be used safely in more cases. IgnoreImplicitTraps
  is now deprecated.

- Adds type argument for BinaryenAddTable method (#4107). For the binaryen.js api
  this parameter is optional and by default is set to funcref type.

- Replace `BinaryenExpressionGetSideEffects`'s features parameter with a module
  parameter.
  
- OptimizeInstructions now lifts identical code in `select`/`if` arms (#3828). This may cause direct `BinaryenTupleExtract(BinaryenTupleMake(...))` to [use multivalue types](https://github.com/grain-lang/grain/pull/1158).

v101
----

- `BinaryenSetFunctionTable` and `module.setFunctionTable` have been removed
  in favor of `BinaryenAddTable` and `module.addTable` respectively.
- `BinaryenIsFunctionTableImported` is removed.
- A new type `BinaryenElementSegmentRef` has been added to the C API with
  new apis in both C & JS:
  - `BinaryenAddActiveElementSegment`
  - `BinaryenAddPassiveElementSegment`
  - `BinaryenRemoveElementSegment`
  - `BinaryenGetElementSegment`
  - `BinaryenGetElementSegmentByIndex`
  - `BinaryenElementSegmentGetName`
  - `BinaryenElementSegmentSetName`
  - `BinaryenElementSegmentGetTable`
  - `BinaryenElementSegmentSetTable`
  - `BinayenElementSegmentIsPassive`
  - `module.addActiveElementSegment`
  - `module.addPassiveElementSegment`
  - `module.removeElementSegment`
  - `module.getElementSegment`
  - `module.getElementSegmentByIndex`
  - `module.getTableSegments`
  - `module.getNumElementSegments`
  - `binaryen.getElementSegmentInfo`
- `BinaryenAddTable` and `module.addTable` no longer take offset and function
    names.
- `BinaryenGetNumFunctionTableSegments` is replaced with
  `BinaryenGetNumElementSegments`.
- `BinaryenGetFunctionTableSegmentOffset` is replaced with
  `BinaryenElementSegmentGetOffset`.
- `BinaryenGetFunctionTableSegmentLength` is replaced with
  `BinaryenElementSegmentGetLength`.
- `BinaryenGetFunctionTableSegmentData` is replaced with
  `BinaryenElementSegmentGetData`.
- Boolean values in the C API now should use `bool` instead of `int`.
- Experimental SIMD instructions have been removed and the names and opcodes of
  the standard instructions have been updated to match the final spec.

v100
----

- `wasm-dis` now supports options to enable or disable Wasm features.
- Reference types support has been improved by allowing multiple tables in a
  module.
- `call_indirect` and `return_call_indirect` now take an additional table name
  parameter. This is necessary for reference types support.
- New getter/setter methods have been introduced for `call_indirect` table name:
  - `BinaryenCallIndirectGetTable`
  - `BinaryenCallIndirectSetTable`
  - JS API `CallIndirect.table`
- New APIs have been added to add and manipulate multiple tables in a module:
  - `BinaryenAddTable`
  - `BinaryenRemoveTable`
  - `BinaryenGetNumTables`
  - `BinaryenGetTable`
  - `BinaryenGetTableByIndex`
  - `BinaryenTableGetName`
  - `BinaryenTableGetInitial`
  - `BinaryenTableHasMax`
  - `BinaryenTableGetMax`
  - `BinaryenTableImportGetModule`
  - `BinaryenTableImportGetBase`
  - `module.addTable`
  - `module.removeTable`
  - `module.getTable`
  - `module.getTableByIndex`
  - `module.getNumTables`
  - `binaryen.getTableInfo`

v99
---

- `RefFunc` C and JS API constructors (`BinaryenRefFunc` and `ref.func`
  respectively) now take an extra `type` parameter, similar to `RefNull`. This
  is necessary for typed function references support.
- JS API functions for atomic notify/wait instructions are renamed.
  - `module.atomic.notify` -> `module.memory.atomic.notify`
  - `module.i32.atomic.wait` -> `module.memory.atomic.wait32`
  - `module.i64.atomic.wait` -> `module.memory.atomic.wait64`
- Remove old/broken SpollPointers pass.  This pass: Spills values that might be
  pointers to the C stack. This allows Boehm-style GC to see them properly.
  This can be revived if needed from git history (#3261).
- Make `NUM_PARAMS` in `FuncCastEmulation` a runtime configuration option named
  `max-func-params`. This defaults to the original value of 16.
- `BinaryenGetFunction`, `BinaryenGetGlobal` and `BinaryenGetEvent` now return
  `NULL` instead of aborting when the respective element does not yet exist.

v98
---

- Add `--fast-math` mode. (#3155)
- Initial implementation of "Memory64" proposal (#3130)
- Lots of changes in support of GC proposal

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
