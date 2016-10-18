(module
  (memory 256 256)
  (type $0 (func (param i32)))
  (type $1 (func))
  (type $2 (func (result i32)))
  (func $b14 (type $2) (result i32)
    (block $topmost i32
      (if i32 ;; with shrinking, this can become a select
        (i32.const 1)
        (block $block1 i32
          (i32.const 12)
        )
        (block $block3 i32
          (i32.const 27)
        )
      )
    )
  )
)

