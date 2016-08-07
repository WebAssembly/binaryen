(module
  (memory 1)
  (data (i32.const 4) "\10\04\00\00")
  (export "memory" memory)
  (type $FUNCSIG$v (func))
  (type $FUNCSIG$i (func (result i32)))
  (type $FUNCSIG$iiii (func (param i32 i32 i32) (result i32)))
  (type $3 (func (param i32 i32 i32)))
  (type $4 (func (param i32 i32 i32 i32 i32) (result i32)))
  (import $block_tail_dup "env" "block_tail_dup")
  (import $def "env" "def" (result i32))
  (import $memcpy "env" "memcpy" (param i32 i32 i32) (result i32))
  (import $memmove "env" "memmove" (param i32 i32 i32) (result i32))
  (import $memset "env" "memset" (param i32 i32 i32) (result i32))
  (export "copy_yes" $copy_yes)
  (export "copy_no" $copy_no)
  (export "move_yes" $move_yes)
  (export "move_no" $move_no)
  (export "set_yes" $set_yes)
  (export "set_no" $set_no)
  (export "frame_index" $frame_index)
  (export "drop_result" $drop_result)
  (export "tail_dup_to_reuse_result" $tail_dup_to_reuse_result)
  (func $copy_yes (type $FUNCSIG$iiii) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (return
      (call_import $memcpy
        (get_local $0)
        (get_local $1)
        (get_local $2)
      )
    )
  )
  (func $copy_no (type $3) (param $0 i32) (param $1 i32) (param $2 i32)
    (drop
      (call_import $memcpy
        (get_local $0)
        (get_local $1)
        (get_local $2)
      )
    )
    (return)
  )
  (func $move_yes (type $FUNCSIG$iiii) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (return
      (call_import $memmove
        (get_local $0)
        (get_local $1)
        (get_local $2)
      )
    )
  )
  (func $move_no (type $3) (param $0 i32) (param $1 i32) (param $2 i32)
    (drop
      (call_import $memmove
        (get_local $0)
        (get_local $1)
        (get_local $2)
      )
    )
    (return)
  )
  (func $set_yes (type $FUNCSIG$iiii) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (return
      (call_import $memset
        (get_local $0)
        (get_local $1)
        (get_local $2)
      )
    )
  )
  (func $set_no (type $3) (param $0 i32) (param $1 i32) (param $2 i32)
    (drop
      (call_import $memset
        (get_local $0)
        (get_local $1)
        (get_local $2)
      )
    )
    (return)
  )
  (func $frame_index (type $FUNCSIG$v)
    (local $0 i32)
    (local $1 i32)
    (drop
      (call_import $memset
        (i32.add
          (tee_local $0
            (block
              (block
                (set_local $1
                  (i32.sub
                    (i32.load
                      (i32.const 4)
                    )
                    (i32.const 4096)
                  )
                )
                (i32.store
                  (i32.const 4)
                  (get_local $1)
                )
              )
              (get_local $1)
            )
          )
          (i32.const 2048)
        )
        (i32.const 0)
        (i32.const 1024)
      )
    )
    (i32.store
      (i32.const 4)
      (i32.add
        (call_import $memset
          (get_local $0)
          (i32.const 0)
          (i32.const 1024)
        )
        (i32.const 4096)
      )
    )
    (return)
  )
  (func $drop_result (type $4) (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (param $4 i32) (result i32)
    (block $label$0
      (block $label$1
        (block $label$2
          (br_if $label$2
            (i32.eqz
              (get_local $3)
            )
          )
          (set_local $0
            (call_import $def)
          )
          (br $label$1)
        )
        (br_if $label$0
          (i32.eqz
            (get_local $4)
          )
        )
      )
      (call_import $block_tail_dup)
      (return
        (get_local $0)
      )
    )
    (drop
      (call_import $memset
        (get_local $0)
        (get_local $1)
        (get_local $2)
      )
    )
    (call_import $block_tail_dup)
    (return
      (get_local $0)
    )
  )
  (func $tail_dup_to_reuse_result (type $4) (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (param $4 i32) (result i32)
    (block $label$0
      (block $label$1
        (block $label$2
          (br_if $label$2
            (i32.eqz
              (get_local $3)
            )
          )
          (set_local $0
            (call_import $def)
          )
          (br $label$1)
        )
        (br_if $label$0
          (i32.eqz
            (get_local $4)
          )
        )
      )
      (return
        (get_local $0)
      )
    )
    (return
      (call_import $memset
        (get_local $0)
        (get_local $1)
        (get_local $2)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
