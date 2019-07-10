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

- wasm-emscripten-finalize: For -pie binaries that import a mutable stack
  pointer we internalize this an import it as immutable.

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
