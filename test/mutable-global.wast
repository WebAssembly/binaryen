(module
  (type $0 (func))
  (import "env" "global-mut" (global $global-mut (mut i32)))
  (func $foo (type $0)
    (global.set $global-mut
      (i32.add
        (global.get $global-mut)
        (i32.const 1)
      )
    )
  )
)
