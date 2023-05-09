;; RUN: wasm-opt %s --enable-memory64 --print-features --print --memory64-lowering --print-features | filecheck %s

;; Check that the --memory64-lowering pass disables the signext feature.

;; CHECK: --enable-memory64
;; CHECK: (module
;; CHECK-NOT: --enable-memory64

(module)
