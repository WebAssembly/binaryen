;; Test if tag imports are correctly generated in 'declares'

;; RUN: wasm-emscripten-finalize --enable-exception-handling %s -o out.wasm | filecheck %s

;; CHECK:      "declares": [
;; CHECK-NEXT:   "__cpp_exception",
;; CHECK-NEXT:   "__c_longjmp"
;; CHECK-NEXT: ],

(module
  (import "env" "__cpp_exception" (tag $eimport$0 (param i32)))
  (import "env" "__c_longjmp" (tag $eimport$1 (param i32)))
)
