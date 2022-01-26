(module
  (type $struct (struct_subtype (field i32) data))

  (global $global1 (ref $struct)
    (struct.new $struct
      (i32.const 1337)
    )
  )

  (func "test1"
    (drop
      (struct.new $struct
        (i32.const 42)
      )
    )
  )

  (func "keepalive"
    (drop
      (global.get $global1)
    )
  )
)

