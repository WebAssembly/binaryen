;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt --outlining -S -o - | filecheck %s

(module
	;; CHECK:      (type $0 (func (result i32)))

	;; CHECK:      (type $1 (func (param i32)))

	;; CHECK:      (func $a (result i32)
	;; CHECK-NEXT:  (call $outline$5
	;; CHECK-NEXT:   (i32.const 7)
	;; CHECK-NEXT:  )
	;; CHECK-NEXT:  (return
	;; CHECK-NEXT:   (i32.const 4)
	;; CHECK-NEXT:  )
	;; CHECK-NEXT: )
	(func $a (result i32)
	  (drop (i32.const 7))
	  (drop (i32.const 1))
	  (drop (i32.const 2))
	  (return (i32.const 4))
	)
	;; CHECK:      (func $b (result i32)
	;; CHECK-NEXT:  (call $outline$5
	;; CHECK-NEXT:   (i32.const 0)
	;; CHECK-NEXT:  )
	;; CHECK-NEXT:  (return
	;; CHECK-NEXT:   (i32.const 5)
	;; CHECK-NEXT:  )
	;; CHECK-NEXT: )
	(func $b (result i32)
	  (drop (i32.const 0))
	  (drop (i32.const 1))
	  (drop (i32.const 2))
	  (return (i32.const 5))
	)
)

;; CHECK:      (func $outline$5 (param $0 i32)
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (local.get $0)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (i32.const 1)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (i32.const 2)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )
(module
	;; CHECK:      (type $0 (func))

	;; CHECK:      (type $1 (func (param i32)))

	;; CHECK:      (func $a
	;; CHECK-NEXT:  (drop
	;; CHECK-NEXT:   (i32.const 7)
	;; CHECK-NEXT:  )
	;; CHECK-NEXT:  (call $outline$7
	;; CHECK-NEXT:   (i32.const 4)
	;; CHECK-NEXT:  )
	;; CHECK-NEXT: )
	(func $a
	  (drop (i32.const 7))
	  (drop (i32.const 4))
	  (drop (i32.const 1))
	  (drop (i32.const 2))
	)
	;; CHECK:      (func $b
	;; CHECK-NEXT:  (drop
	;; CHECK-NEXT:   (i32.const 0)
	;; CHECK-NEXT:  )
	;; CHECK-NEXT:  (call $outline$7
	;; CHECK-NEXT:   (i32.const 5)
	;; CHECK-NEXT:  )
	;; CHECK-NEXT: )
	(func $b
	  (drop (i32.const 0))
	  (drop (i32.const 5))
	  (drop (i32.const 1))
	  (drop (i32.const 2))
	)
)
;; CHECK:      (func $outline$7 (param $0 i32)
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (local.get $0)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (i32.const 1)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (i32.const 2)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )