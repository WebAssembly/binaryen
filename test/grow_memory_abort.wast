(module
  (memory 1)
  (func $rust::page::alloc::h2bf29ae9b5d0f320E (export "rust::page::alloc::h2bf29ae9b5d0f320E") (result i32)
    (local $0 i32)
    (block $label$0
      (br_if $label$0
        (i32.eqz
          (tee_local $0
            (i32.load offset=12
              (i32.const 0)
            )
          )
        )
      )
      (i32.store offset=12
        (i32.const 0)
        (i32.load
          (get_local $0)
        )
      )
      (return
        (get_local $0)
      )
    )
    (set_local $0
      (current_memory)
    )
    (drop
      (grow_memory
        (i32.const 1)
      )
    )
    (block $label$1
      (br_if $label$1
        (i32.eq
          (get_local $0)
          (current_memory)
        )
      )
      (return
        (i32.shl
          (get_local $0)
          (i32.const 16)
        )
      )
    )
    ;;@ /checkout/src/liballoc/allocator.rs:581:0
    (unreachable)
    (unreachable)
  )
)
