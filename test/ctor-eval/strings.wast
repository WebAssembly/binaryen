(module
  (type $array16 (array (mut i16)))

  (global $s (mut stringref) (ref.null string))

  (func "const"
    (global.set $s
      (string.const "hello, world")
    )
  )

  (func "get" (result stringref)
    ;; Another export, to keep the global alive.
    (global.get $s)
  )
)
