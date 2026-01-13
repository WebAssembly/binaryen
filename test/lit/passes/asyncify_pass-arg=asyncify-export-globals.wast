;; RUN: wasm-opt --enable-mutable-globals --asyncify --pass-arg=asyncify-export-globals -S -o - | filecheck %s

(module
)
;; CHECK:      (global $__asyncify_state (mut i32) (i32.const 0))

;; CHECK:      (global $__asyncify_data (mut i32) (i32.const 0))

;; CHECK:      (export "__asyncify_state" (global $__asyncify_state))

;; CHECK:      (export "__asyncify_data" (global $__asyncify_data))
