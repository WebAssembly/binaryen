;; When reference types is disabled, we reuse the existing i64 table
;; RUN: wasm-split %s -g -o1 %t.1.wasm -o2 %t.2.wasm --export-prefix='%' --keep-funcs=foo --enable-memory64 -v 2>&1 | filecheck %s --check-prefix CHECK
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY-NOREF
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY-NOREF
;; Check whether the split files conform to memory64
;; RUN: wasm-opt --enable-memory64 %t.1.wasm
;; RUN: wasm-opt --enable-memory64 %t.2.wasm

;; When reference types is enabled, we create a new table
;; RUN: wasm-split %s -g -o1 %t.1.wasm -o2 %t.2.wasm --export-prefix='%' --keep-funcs=foo --enable-memory64 --enable-reference-types -v 2>&1 | filecheck %s --check-prefix CHECK
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY-REF
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY-REF
;; Check whether the split files conform to memory64
;; RUN: wasm-opt --enable-memory64 --enable-reference-types %t.1.wasm
;; RUN: wasm-opt --enable-memory64 --enable-reference-types %t.2.wasm

;; CHECK: Keeping functions: foo{{$}}
;; CHECK: Splitting out functions: bar{{$}}

;; PRIMARY-NOREF:      (module
;; PRIMARY-NOREF-NEXT:  (type $0 (func (param i32) (result i32)))
;; PRIMARY-NOREF-NEXT:  (import "env" "g" (global $g i64))
;; PRIMARY-NOREF-NEXT:  (import "placeholder" "1" (func $placeholder_1 (param i32) (result i32)))
;; PRIMARY-NOREF-NEXT:  (table $table i64 2 2 funcref)
;; PRIMARY-NOREF-NEXT:  (elem $0 (global.get $g) $foo $placeholder_1)
;; PRIMARY-NOREF-NEXT:  (export "%foo" (func $foo))
;; PRIMARY-NOREF-NEXT:  (export "%table" (table $table))
;; PRIMARY-NOREF-NEXT:  (export "%global" (global $g))
;; PRIMARY-NOREF-NEXT:  (func $foo (param $0 i32) (result i32)
;; PRIMARY-NOREF-NEXT:   (call_indirect (type $0)
;; PRIMARY-NOREF-NEXT:    (i32.const 0)
;; PRIMARY-NOREF-NEXT:    (i64.add
;; PRIMARY-NOREF-NEXT:     (global.get $g)
;; PRIMARY-NOREF-NEXT:     (i64.const 1)
;; PRIMARY-NOREF-NEXT:    )
;; PRIMARY-NOREF-NEXT:   )
;; PRIMARY-NOREF-NEXT:  )
;; PRIMARY-NOREF-NEXT: )

;; SECONDARY-NOREF:      (module
;; SECONDARY-NOREF-NEXT:  (type $0 (func (param i32) (result i32)))
;; SECONDARY-NOREF-NEXT:  (import "primary" "%table" (table $table i64 2 2 funcref))
;; SECONDARY-NOREF-NEXT:  (import "primary" "%global" (global $g i64))
;; SECONDARY-NOREF-NEXT:  (import "primary" "%foo" (func $foo (param i32) (result i32)))
;; SECONDARY-NOREF-NEXT:  (elem $0 (global.get $g) $foo $bar)
;; SECONDARY-NOREF-NEXT:  (func $bar (param $0 i32) (result i32)
;; SECONDARY-NOREF-NEXT:   (call $foo
;; SECONDARY-NOREF-NEXT:    (i32.const 1)
;; SECONDARY-NOREF-NEXT:   )
;; SECONDARY-NOREF-NEXT:  )
;; SECONDARY-NOREF-NEXT: )

;; PRIMARY-REF:      (module
;; PRIMARY-REF-NEXT:  (type $0 (func (param i32) (result i32)))
;; PRIMARY-REF-NEXT:  (import "env" "g" (global $g i64))
;; PRIMARY-REF-NEXT:  (import "placeholder" "0" (func $placeholder_0 (param i32) (result i32)))
;; PRIMARY-REF-NEXT:  (table $table i64 1 1 funcref)
;; PRIMARY-REF-NEXT:  (table $1 1 funcref)
;; PRIMARY-REF-NEXT:  (elem $0 (table $table) (global.get $g) func $foo)
;; PRIMARY-REF-NEXT:  (elem $1 (table $1) (i32.const 0) func $placeholder_0)
;; PRIMARY-REF-NEXT:  (export "%foo" (func $foo))
;; PRIMARY-REF-NEXT:  (export "%table" (table $table))
;; PRIMARY-REF-NEXT:  (export "%table_2" (table $1))
;; PRIMARY-REF-NEXT:  (export "%global" (global $g))
;; PRIMARY-REF-NEXT:  (func $foo (param $0 i32) (result i32)
;; PRIMARY-REF-NEXT:   (call_indirect $1 (type $0)
;; PRIMARY-REF-NEXT:    (i32.const 0)
;; PRIMARY-REF-NEXT:    (i32.const 0)
;; PRIMARY-REF-NEXT:   )
;; PRIMARY-REF-NEXT:  )
;; PRIMARY-REF-NEXT: )

;; SECONDARY-REF:      (module
;; SECONDARY-REF-NEXT:  (type $0 (func (param i32) (result i32)))
;; SECONDARY-REF-NEXT:  (import "primary" "%table_2" (table $timport$0 1 funcref))
;; SECONDARY-REF-NEXT:  (import "primary" "%foo" (func $foo (param i32) (result i32)))
;; SECONDARY-REF-NEXT:  (elem $0 (i32.const 0) $bar)
;; SECONDARY-REF-NEXT:  (func $bar (param $0 i32) (result i32)
;; SECONDARY-REF-NEXT:   (call $foo
;; SECONDARY-REF-NEXT:    (i32.const 1)
;; SECONDARY-REF-NEXT:   )
;; SECONDARY-REF-NEXT:  )
;; SECONDARY-REF-NEXT: )

(module
 (global $g (import "env" "g") i64)
 (table $table i64 1 1 funcref)
 (elem (global.get $g) $foo)
 (func $foo (param i32) (result i32)
  (call $bar (i32.const 0))
 )
 (func $bar (param i32) (result i32)
  (call $foo (i32.const 1))
 )
)
