;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --simplify-locals -all -S -o - | filecheck %s

(module
  ;; CHECK:      (table $table 10 funcref)
  (table $table 10 funcref)

  ;; CHECK:      (elem $zero (i32.const 0) $zero)
  (elem $zero (i32.const 0) $zero)

  ;; CHECK:      (elem $one func $one)
  (elem $one $one)

  ;; CHECK:      (func $move (type $0) (result funcref)
  ;; CHECK-NEXT:  (local $temp funcref)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (table.get $table
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $move (result funcref)
    (local $temp funcref)
    (local.set $temp
      (table.get $table
        (i32.const 0)
      )
    )
    ;; We can move the table.get past the nop.
    (nop)
    (local.get $temp)
  )

  ;; CHECK:      (func $no-move (type $0) (result funcref)
  ;; CHECK-NEXT:  (local $temp funcref)
  ;; CHECK-NEXT:  (local.set $temp
  ;; CHECK-NEXT:   (table.get $table
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (table.init $table
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.get $temp)
  ;; CHECK-NEXT: )
  (func $no-move (result funcref)
    (local $temp funcref)
    (local.set $temp
      (table.get $table
        (i32.const 0)
      )
    )
    ;; table.init writes to the table, so table reads cannot cross it.
    (table.init $table $one (i32.const 0) (i32.const 0) (i32.const 1))
    (local.get $temp)
  )

  ;; CHECK:      (func $zero (type $1) (result i32)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT: )
  (func $zero (result i32)
    (i32.const 0)
  )

  ;; CHECK:      (func $one (type $1) (result i32)
  ;; CHECK-NEXT:  (i32.const 1)
  ;; CHECK-NEXT: )
  (func $one (result i32)
    (i32.const 1)
  )
)
