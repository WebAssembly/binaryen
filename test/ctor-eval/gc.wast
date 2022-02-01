(module
  (type $struct (struct_subtype (field i32) data))

  (import "import" "import" (func $import))

  ;; Create a GC object in a global. We can keep the struct.new here even after
  ;; evalling (we should not create an extra, unneeded global, and read from
  ;; that).
  (global $global1 (ref $struct)
    (struct.new $struct
      (i32.const 1337)
    )
  )

  ;; After evalling we should see this refer to a struct with contents 42, and
  ;; not 41, which is overridden, see "test1". We also should not see any code
  ;; that creates an object with 41, as that is no longer live.
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

    ;; Leave one local as null, and write a value to the other. A struct with
    ;; value 99 will be created in a global, and referred to here after
    ;; evalling.
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

