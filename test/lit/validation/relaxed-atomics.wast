;; Test the feature flag for --relaxed-atomics
;; The below tests set --enable-threads since it's required for shared memories.

;; text
;; RUN: wasm-opt --enable-threads --enable-relaxed-atomics %s 2>&1
;; RUN: not wasm-opt --enable-threads --disable-relaxed-atomics %s 2>&1 | filecheck %s

;; binary
;; RUN: wasm-opt --enable-threads --enable-relaxed-atomics %s -o %t.wasm
;; RUN: not wasm-opt --enable-threads --disable-relaxed-atomics %t.wasm 2>&1 | filecheck %s

(module
  (memory 1 1 shared)
  (func $acqrel (result i32)
    ;; CHECK: Acquire/release operations require relaxed atomics [--enable-relaxed-atomics]
    (i32.atomic.load acqrel
      (i32.const 1)
    )
  )
)