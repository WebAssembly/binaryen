(module
  (type $struct (struct_subtype (field i32) data))

  (import "import" "import" (func $import (param anyref)))

  (global $global1 (ref $struct)
    (struct.new $struct
      (i32.const 1337)
    )
  )

  (func "test1"
    (local $temp1 (ref null $struct))

    (global.set $global2
      (struct.new $struct
        (i32.const 41)
      )
    )
    (call $import (local.get $temp1))
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

