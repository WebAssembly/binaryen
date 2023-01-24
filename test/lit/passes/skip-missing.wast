;; We should warn on a pass called "waka" not having been run and skipped.

;; RUN:  not wasm-opt %s --skip-pass=waka 2>&1 | filecheck %s

;; CHECK: waka

(module
)
