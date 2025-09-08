;; Test that shared memory requires atomics

;; RUN: not wasm-opt %s 2>&1 | filecheck %s --check-prefix NO-ATOMICS
;; RUN: wasm-opt %s --enable-threads -o - -S | filecheck %s --check-prefix ATOMICS

;; NO-ATOMICS: shared memory requires threads [--enable-threads]
;; ATOMICS: (memory $0 10 20 shared)

(module
  (memory 10 20 shared)
)
