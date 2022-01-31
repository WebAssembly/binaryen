(module
  (type $struct (struct_subtype (field i32) data))

  (import "import" "import" (func $import))

  (global $global1 (ref $struct)
    (struct.new $struct
      (i32.const 1337)
    )
  )

  (global $global2 (mut (ref null $struct)) (ref.null $struct))

  (func "test1" (result anyref)
    (local $temp1 (ref null $struct))
    (local $temp2 (ref null $struct))

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

    ;; Leave one local as null, and write a value to the other
    (local.set $temp2
      (struct.new $struct
        (i32.const 99)
      )
    )

    ;; Stop evalling here at the import.
    (call $import)

    (local.get $temp2)
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

