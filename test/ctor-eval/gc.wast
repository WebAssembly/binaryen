(module
  (type $struct (struct_subtype (field i32) data))

  (global $global1 (ref $struct)
    (struct.new $struct
      (i32.const 1337)
    )
  )

  (global $global2 (mut (ref null $struct)) (ref.null $struct))

  (func "test1"
    (global.set $global2
      (struct.new $struct
        (i32.const 41)
      )
    )
    (global.set $global2
      (struct.new $struct
        (i32.const 42)
      )
    )
  )

  (func "keepalive" (result i32)
    (i32.add
      (struct.get $struct 0
        (global.get $global1)
      )
      (struct.get $struct 0
        (global.get $global2)
      )
    )
  )
)

