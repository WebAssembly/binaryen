;; A local ref of a function type with multiple results requires multivalue.
;; RUN: not wasm-opt %s 2>&1 | filecheck %s

;; CHECK: all used types should be allowed

(module
  (type $T (func (param i32 i32) (result i32 i32 i32)))

  (func $foo
    (local $t (ref null $T))
  )
)

;; Still fails with just reference types or multivalue.
;; RUN: not wasm-opt --enable-reference-types %s 2>&1 | filecheck %s
;; RUN: not wasm-opt --enable-multivalue %s 2>&1 | filecheck %s

;; But it passes with both.
;; RUN: wasm-opt --enable-reference-types --enable-multivalue %s
