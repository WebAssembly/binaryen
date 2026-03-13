;; RUN: foreach %s %t not wasm-opt -all 2>&1 | filecheck %s

;; CHECK: tables with non-nullable types require an initializer expression
(module
 (type $0 (func (param i32)))
 (table $0 0 (ref $0))
 (func $0 (param $0 i32)
 )
)

;; non-nullable table initialization expression type is validated
;; CHECK: init expression must be a subtype of the table type
(module
 (type $0 (func (param i32)))
 (table $0 0 (ref $0) (i32.const 0))
 (func $0 (param $0 i32)
 )
)

;; nullable table initialization expression type is validated
;; CHECK: init expression must be a subtype of the table type
(module
 (type $0 (func (param i32)))
 (table $0 0 funcref (i32.const 0))
 (func $0 (param $0 i32)
 )
)