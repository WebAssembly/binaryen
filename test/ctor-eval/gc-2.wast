(module
  (type $struct (struct_subtype (field i32) data))

  (import "import" "import" (func $import (param anyref)))

  ;; This struct is created in an immutable global, but it has the wrong type.
  ;; We will create a new defining global for it that has the proper type, and
  ;; read from it here. (This is necessary as when the global is used elsewhere
  ;; we want to get the right type from the global.get.)
  (global $global1 (ref any)
    (struct.new $struct
      (i32.const 1337)
    )
  )

  ;; Test reordering of globals. This global will be written a value that is
  ;; actually defined after it. To handle that, we must create it earlier than
  ;; this global.
  (global $global2 (mut (ref null $struct))
    (ref.null $struct)
  )

  ;; This global is perfect to be a defining global (immutable, right type), but
  ;; because of an earlier use, we will end up defining it earlier on, and
  ;; reading it here.
  (global $global3 (ref $struct)
    (struct.new $struct
      (i32.const 9999)
    )
  )

  (func "test1"
    (global.set $global2
      (global.get $global3)
    )
  )

  (func "keepalive" (result i32)
    (select
      (struct.get $struct 0
        (ref.cast $struct
          (global.get $global1)
        )
      )
      (struct.get $struct 0
        (global.get $global2)
      )
      (struct.get $struct 0
        (global.get $global3)
      )
    )
  )
)
