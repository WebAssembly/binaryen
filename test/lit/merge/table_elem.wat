;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: wasm-merge %s first %s.second second -all -S -o - | filecheck %s

;; Test we rename tables and element segments properly at the module scope.
;; Table $foo has a name collision, and both of the element segments' names do
;; as well.

(module
  ;; CHECK:      (type $vec (array funcref))
  (type $vec (array funcref))

  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (table $foo 1 funcref)
  (table $foo 1 funcref)

  ;; CHECK:      (table $bar 10 funcref)
  (table $bar 10 funcref)

  ;; CHECK:      (table $foo_2 100 funcref)

  ;; CHECK:      (table $other 1000 funcref)

  ;; CHECK:      (elem $a (table $foo) (i32.const 0) func)
  (elem $a (table $foo) (i32.const 0) func)

  ;; CHECK:      (elem $b (table $bar) (i32.const 0) func)
  (elem $b (table $bar) (i32.const 0) func)

  (func "keepalive2"
    (drop
      (table.get $foo
        (i32.const 1)
      )
    )
    (drop
      (table.get $bar
        (i32.const 1)
      )
    )
    ;; GC operations are the only things that can keep alive an elem segment.
    (drop
      (array.new_elem $vec $a
        (i32.const 1)
        (i32.const 2)
      )
    )
    (drop
      (array.new_elem $vec $b
        (i32.const 3)
        (i32.const 4)
      )
    )
  )
)
;; CHECK:      (elem $a_2 (table $foo_2) (i32.const 0) func)

;; CHECK:      (elem $b_2 (table $other) (i32.const 0) func)

;; CHECK:      (export "keepalive2" (func $0))

;; CHECK:      (export "keepalive2_1" (func $0_1))

;; CHECK:      (func $0 (type $none_=>_none)
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (table.get $foo
;; CHECK-NEXT:    (i32.const 1)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (table.get $bar
;; CHECK-NEXT:    (i32.const 1)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (array.new_elem $vec $a
;; CHECK-NEXT:    (i32.const 1)
;; CHECK-NEXT:    (i32.const 2)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (array.new_elem $vec $b
;; CHECK-NEXT:    (i32.const 3)
;; CHECK-NEXT:    (i32.const 4)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

;; CHECK:      (func $0_1 (type $none_=>_none)
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (table.get $foo_2
;; CHECK-NEXT:    (i32.const 1)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (table.get $other
;; CHECK-NEXT:    (i32.const 1)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (array.new_elem $vec $a_2
;; CHECK-NEXT:    (i32.const 5)
;; CHECK-NEXT:    (i32.const 6)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (array.new_elem $vec $b_2
;; CHECK-NEXT:    (i32.const 7)
;; CHECK-NEXT:    (i32.const 8)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT: )
