;; RUN: wasm-opt --enable-mutable-globals --asyncify --pass-arg=asyncify-import-globals -S -o - | filecheck %s

;; Also test asyncify-relocatable which is an alias for asyncify-import-globals
;; RUN: wasm-opt --enable-mutable-globals --asyncify --pass-arg=asyncify-relocatable -S -o - | filecheck %s

(module
)

;; CHECK:      (import "env" "__asyncify_state" (global $__asyncify_state (mut i32)))
;; CHECK:      (import "env" "__asyncify_data" (global $__asyncify_data (mut i32)))
