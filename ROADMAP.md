
# Binaryen Roadmap

## Planned Work

* Code annotations (inlining hints, etc.)

## Ongoing Work

* [Improve compile times]
* New interpreter (avoid exceptions, enable stack switching)

## Completed Work

* Wasm features support:
  * Atomics
  * MutableGlobals
  * TruncSat
  * SIMD
  * BulkMemory
  * SignExt
  * ExceptionHandling
  * TailCall
  * ReferenceTypes
  * Multivalue
  * GC
  * Memory64
  * RelaxedSIMD
  * ExtendedConst
  * Strings
  * MultiMemory
  * StackSwitching
  * SharedEverything
  * FP16
  * BulkMemory
* Tools:
  * wasm-opt
  * wasm2js
  * wasm-ctor-eval
  * wasm-emscripten-finalize
  * wasm-fuzz-types
  * wasm-metadce
  * wasm-reduce
  * wasm-as
  * wasm-dis
  * wasm-fuzz-lattices
  * wasm-merge
  * wasm-shell
* [Fuzzing]
  * [ClusterFuzz integration]

[Improve compile times]: https://github.com/WebAssembly/binaryen/issues/4165
[Fuzzing]: https://github.com/WebAssembly/binaryen/wiki/Fuzzing
[ClusterFuzz integration]: https://github.com/WebAssembly/binaryen/blob/main/scripts/bundle_clusterfuzz.py

