(module
  (func $return-i32-but-body-is-unreachable3 (result i32)
    (local $label i32)
    (block ;; without a name here, vaccum had a too-eager bug
      (loop $while-in$1
        (br $while-in$1)
      )
    )
  )
  (func $return-i32-but-body-is-unreachable4 (result i32)
    (local $label i32)
    (block ;; without a name here, vaccum had a too-eager bug
      (loop $while-in$1
        (br $while-in$1)
      )
    )
    (i32.const 0)
  )
  (func $to-drop-unreachable
   (drop
    (block (result i32)
     (unreachable)
    )
   )
  )
  (func $return-i32-but-body-is-unreachable5 (result i32)
    (local $label i32)
    (block ;; without a name here, vaccum had a too-eager bug
      (unreachable)
    )
  )
  (func $return-i32-but-body-is-unreachable6 (result i32)
    (local $label i32)
    (block ;; without a name here, vaccum had a too-eager bug
      (unreachable)
    )
    (i32.const 0)
  )
)

