;; RUN: wasm-opt %s --enable-sign-ext --print-features --print --signext-lowering --print-features | filecheck %s

;; Check that the --signext-lowering pass disables the signext feature.

;; CHECK: --enable-sign-ext
;; CHECK: (module
;; CHECK-NOT: --enable-sign-ext

(module)
