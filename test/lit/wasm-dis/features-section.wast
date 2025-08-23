;; RUN: wasm-opt %s --disable-mutable-globals --disable-sign-ext --enable-reference-types --enable-gc --emit-target-features -o %t.wasm
;; RUN: wasm-dis %t.wasm | filecheck %s --check-prefix FEATURES-SEC
;; RUN: wasm-opt %s --disable-mutable-globals --disable-sign-ext --enable-reference-types --enable-gc -o %t.wasm
;; RUN: wasm-dis %t.wasm | filecheck %s --check-prefix NO-FEATURES-SEC

;; FEATURES-SEC: ;; features section: reference-types, gc
;; NO-FEATURES-SEC-NOT: ;; features section

(module)
