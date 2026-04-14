(module
  ;; CHECK:      (type $t (func (param i32)))
  (type $t (func (param i32)))

  ;; CHECK:      (import "" "" (func $imported-func (type $t) (param i32)))
  ;; (import "" "" (func $imported-func (type $t)))
  (import "" "" (func $imported-func (type $t)))

  (elem declare $imported-func)

  ;; CHECK:      (func $nop (type $t) (param $0 i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $nop (param i32)
  )

  ;; CHECK:      (func $indirect-calls (type $1) (param $ref (ref $t))
  ;; CHECK-NEXT:  (call_ref $t
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:   (local.get $ref)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $indirect-calls (param $ref (ref $t))
    (call_ref $t (i32.const 1) (local.get $ref))
  )

  ;; CHECK:      (func $f (type $1) (param $ref (ref $t))
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $f (param $ref (ref $t))
    ;; $indirect-calls might end up calling an imported function,
    ;; so we don't know anything about effects here
    (call $indirect-calls (local.get $ref))
  )
)