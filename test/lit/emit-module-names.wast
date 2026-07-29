;; Check that --emit-module-names without -g strips function names but generates
;; and keeps the module name.

;; RUN: wasm-opt %s --emit-module-names -o %t.wasm
;; RUN: wasm-dis %t.wasm -o - | filecheck %s

;; CHECK: (module $module-name
;; CHECK:   (func $0
;; CHECK-NOT: $foo

(module $module-name
  (func $foo
    (nop)
  )
)
