(module
  (rec
    ;; The funcref field can be optimized away with --gto.
    (type $A (struct (field (mut i32)) (field funcref)))
    ;; This type can be optimized away.
    (type $unused (struct))
  )

  (global $A (ref null $A) (struct.new $A
    ;; These particular values are not used, and can be removed, leaving the
    ;; struct.new as struct.new_default.
    (i32.const 0)
    (ref.func $use-global)
  ))

  (func $use-global (export "use-global") (result i32)
    ;; This function stores 42 in the global struct, then reads and returns
    ;; that. We don't manage to optimize away anything in this function, which
    ;; only serves to keep alive the type and the global for the above testing.
    (struct.set $A 0
      (global.get $A)
      (i32.const 42)
    )
    (struct.get $A 0
      (global.get $A)
    )
  )
)

