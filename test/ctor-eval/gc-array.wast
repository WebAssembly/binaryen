(module
  (type $array (array (mut i32)))

  (import "import" "import" (func $import (param anyref)))

  ;; This global will remain as it is.
  (global $global1 (ref $array)
    (array.init_static $array
      (i32.const 10)
      (i32.const 20)
      (i32.const 30)
      (i32.const 40)
    )
  )

  (global $global2 (ref $array)
    (array.init_static $array
      (i32.const 42)
      ;; This location will be written with a new value, 1337
      (i32.const 0)
    )
  )

  (func "test1"
    (array.set $array
      (global.get $global2)
      (i32.const 1)
      (i32.const 1337)
    )
  )

  (func "keepalive" (result i32)
    (i32.add
      (array.get $array
        (global.get $global1)
        (i32.const 0)
      )
      (array.get $array
        (global.get $global2)
        (i32.const 0)
      )
    )
  )
)

