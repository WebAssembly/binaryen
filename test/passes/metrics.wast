(module
  (memory 256 256)
  (table 256 256 anyfunc)
  (elem (i32.const 0) $ifs $ifs $ifs)
  (data (i32.const 0) "\ff\ef\0f\1f\20\30\40\50\99")
  (type $0 (func (param i32)))
  (global $glob i32 (i32.const 1337))
  (func $ifs (type $0) (param $x i32)
    (local $y f32)
    (block $block0
      (if
        (i32.const 0)
        (drop
          (i32.const 1)
        )
      )
      (if
        (i32.const 0)
        (drop
          (i32.const 1)
        )
        (drop
          (i32.const 2)
        )
      )
      (if
        (i32.const 4)
        (drop
          (i32.const 5)
        )
        (drop
          (i32.const 6)
        )
      )
      (drop
        (i32.eq
          (if (result i32)
            (i32.const 4)
            (i32.const 5)
            (i32.const 6)
          )
          (i32.const 177)
        )
      )
    )
  )
)
;; module with no table or memory or anything for that matter
(module
)
