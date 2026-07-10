;; Test that tables with initialization expressions or non-nullable types require GC to be enabled.

;; RUN: foreach %s %t not wasm-opt -all --disable-gc 2>&1 | filecheck %s

;; non-nullable table with initialization expression
;; CHECK: tables must have a nullable type in MVP
(module
 (type $0 (func (param i32)))
 (table $0 0 (ref $0) (ref.func $0))
 (func $0 (param $0 i32)
 )
)

;; nullable table with initialization expression
;; CHECK: tables cannot have an initializer expression in MVP
(module
 (type $0 (func (param i32)))
 (table $0 0 funcref (ref.func $0))
 (func $0 (type $0) (param $0 i32)
 )
)

;; imported table of non-nullable type (no initialization expression)
;; CHECK: tables must have a nullable type in MVP
(module
 (type $0 (func (param i32)))
 (table $0 (import "env" "table") 0 (ref $0))
)
