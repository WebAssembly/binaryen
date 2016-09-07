(module
  (memory 1)
  (data (i32.const 4) "\10\04\00\00")
  (data (i32.const 12) "\00\00\00\00")
  (export "memory" memory)
  (type $FUNCSIG$i (func (result i32)))
  (type $FUNCSIG$ii (func (param i32) (result i32)))
  (type $FUNCSIG$v (func))
  (type $FUNCSIG$iii (func (param i32 i32) (result i32)))
  (type $FUNCSIG$vii (func (param i32 i32)))
  (type $FUNCSIG$vi (func (param i32)))
  (type $6 (func (param i32 i32 i32) (result i32)))
  (type $7 (func (param i32 i32 i32 i32) (result i32)))
  (type $8 (func (param i32 i32 i32)))
  (type $9 (func (param i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32) (result i32)))
  (type $10 (func (param i32 i32 i32 i32 i32)))
  (import $blue "env" "blue" (result i32))
  (import $callee "env" "callee" (param i32) (result i32))
  (import $evoke_side_effects "env" "evoke_side_effects")
  (import $green "env" "green" (result i32))
  (import $readnone_callee "env" "readnone_callee" (result i32))
  (import $readonly_callee "env" "readonly_callee" (result i32))
  (import $red "env" "red" (result i32))
  (import $stackpointer_callee "env" "stackpointer_callee" (param i32 i32) (result i32))
  (import $use_2 "env" "use_2" (param i32 i32))
  (import $use_a "env" "use_a" (param i32))
  (import $use_b "env" "use_b" (param i32))
  (import $use_memory "env" "use_memory" (param i32) (result i32))
  (export "no0" $no0)
  (export "no1" $no1)
  (export "yes0" $yes0)
  (export "yes1" $yes1)
  (export "sink_trap" $sink_trap)
  (export "sink_readnone_call" $sink_readnone_call)
  (export "no_sink_readonly_call" $no_sink_readonly_call)
  (export "stack_uses" $stack_uses)
  (export "multiple_uses" $multiple_uses)
  (export "stackify_store_across_side_effects" $stackify_store_across_side_effects)
  (export "div_tree" $div_tree)
  (export "simple_multiple_use" $simple_multiple_use)
  (export "multiple_uses_in_same_insn" $multiple_uses_in_same_insn)
  (export "commute" $commute)
  (export "no_stackify_past_use" $no_stackify_past_use)
  (export "commute_to_fix_ordering" $commute_to_fix_ordering)
  (export "multiple_defs" $multiple_defs)
  (export "no_stackify_call_past_load" $no_stackify_call_past_load)
  (export "no_stackify_store_past_load" $no_stackify_store_past_load)
  (export "store_past_invar_load" $store_past_invar_load)
  (export "ignore_dbg_value" $ignore_dbg_value)
  (export "no_stackify_past_epilogue" $no_stackify_past_epilogue)
  (export "stackify_indvar" $stackify_indvar)
  (export "stackpointer_dependency" $stackpointer_dependency)
  (func $no0 (type $FUNCSIG$iii) (param $0 i32) (param $1 i32) (result i32)
    (set_local $1
      (i32.load
        (get_local $1)
      )
    )
    (i32.store
      (get_local $0)
      (i32.const 0)
    )
    (return
      (get_local $1)
    )
  )
  (func $no1 (type $FUNCSIG$iii) (param $0 i32) (param $1 i32) (result i32)
    (set_local $1
      (i32.load
        (get_local $1)
      )
    )
    (i32.store
      (get_local $0)
      (i32.const 0)
    )
    (return
      (get_local $1)
    )
  )
  (func $yes0 (type $FUNCSIG$iii) (param $0 i32) (param $1 i32) (result i32)
    (i32.store
      (get_local $0)
      (i32.const 0)
    )
    (return
      (i32.load
        (get_local $1)
      )
    )
  )
  (func $yes1 (type $FUNCSIG$ii) (param $0 i32) (result i32)
    (return
      (i32.load
        (get_local $0)
      )
    )
  )
  (func $sink_trap (type $6) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (i32.store
      (get_local $2)
      (i32.const 0)
    )
    (return
      (i32.div_s
        (get_local $0)
        (get_local $1)
      )
    )
  )
  (func $sink_readnone_call (type $6) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (i32.store
      (get_local $2)
      (i32.const 0)
    )
    (return
      (call_import $readnone_callee)
    )
  )
  (func $no_sink_readonly_call (type $6) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (local $3 i32)
    (set_local $3
      (call_import $readonly_callee)
    )
    (i32.store
      (get_local $2)
      (i32.const 0)
    )
    (return
      (get_local $3)
    )
  )
  (func $stack_uses (type $7) (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (result i32)
    (block $label$0
      (br_if $label$0
        (i32.ne
          (i32.xor
            (i32.xor
              (i32.lt_s
                (get_local $0)
                (i32.const 1)
              )
              (i32.lt_s
                (get_local $1)
                (i32.const 2)
              )
            )
            (i32.xor
              (i32.lt_s
                (get_local $2)
                (i32.const 1)
              )
              (i32.lt_s
                (get_local $3)
                (i32.const 2)
              )
            )
          )
          (i32.const 1)
        )
      )
      (return
        (i32.const 0)
      )
    )
    (return
      (i32.const 1)
    )
  )
  (func $multiple_uses (type $8) (param $0 i32) (param $1 i32) (param $2 i32)
    (local $3 i32)
    (block $label$0
      (br_if $label$0
        (i32.ge_u
          (tee_local $3
            (i32.load
              (get_local $2)
            )
          )
          (get_local $1)
        )
      )
      (br_if $label$0
        (i32.lt_u
          (get_local $3)
          (get_local $0)
        )
      )
      (i32.store
        (get_local $2)
        (get_local $3)
      )
    )
    (return)
  )
  (func $stackify_store_across_side_effects (type $FUNCSIG$vi) (param $0 i32)
    (local $1 i64)
    (local $2 i64)
    (set_local $1
      (block
        (block
          (set_local $2
            (i64.const 4611686018427387904)
          )
          (i64.store
            (get_local $0)
            (get_local $2)
          )
        )
        (get_local $2)
      )
    )
    (call_import $evoke_side_effects)
    (i64.store
      (get_local $0)
      (get_local $1)
    )
    (call_import $evoke_side_effects)
    (return)
  )
  (func $div_tree (type $9) (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (param $4 i32) (param $5 i32) (param $6 i32) (param $7 i32) (param $8 i32) (param $9 i32) (param $10 i32) (param $11 i32) (param $12 i32) (param $13 i32) (param $14 i32) (param $15 i32) (result i32)
    (return
      (i32.div_s
        (i32.div_s
          (i32.div_s
            (i32.div_s
              (get_local $0)
              (get_local $1)
            )
            (i32.div_s
              (get_local $2)
              (get_local $3)
            )
          )
          (i32.div_s
            (i32.div_s
              (get_local $4)
              (get_local $5)
            )
            (i32.div_s
              (get_local $6)
              (get_local $7)
            )
          )
        )
        (i32.div_s
          (i32.div_s
            (i32.div_s
              (get_local $8)
              (get_local $9)
            )
            (i32.div_s
              (get_local $10)
              (get_local $11)
            )
          )
          (i32.div_s
            (i32.div_s
              (get_local $12)
              (get_local $13)
            )
            (i32.div_s
              (get_local $14)
              (get_local $15)
            )
          )
        )
      )
    )
  )
  (func $simple_multiple_use (type $FUNCSIG$vii) (param $0 i32) (param $1 i32)
    (call_import $use_a
      (tee_local $1
        (i32.mul
          (get_local $1)
          (get_local $0)
        )
      )
    )
    (call_import $use_b
      (get_local $1)
    )
    (return)
  )
  (func $multiple_uses_in_same_insn (type $FUNCSIG$vii) (param $0 i32) (param $1 i32)
    (call_import $use_2
      (tee_local $1
        (i32.mul
          (get_local $1)
          (get_local $0)
        )
      )
      (get_local $1)
    )
    (return)
  )
  (func $commute (type $FUNCSIG$i) (result i32)
    (return
      (i32.add
        (i32.add
          (call_import $red)
          (call_import $green)
        )
        (call_import $blue)
      )
    )
  )
  (func $no_stackify_past_use (type $FUNCSIG$ii) (param $0 i32) (result i32)
    (local $1 i32)
    (set_local $1
      (call_import $callee
        (get_local $0)
      )
    )
    (return
      (i32.div_s
        (i32.sub
          (call_import $callee
            (i32.add
              (get_local $0)
              (i32.const 1)
            )
          )
          (get_local $1)
        )
        (get_local $1)
      )
    )
  )
  (func $commute_to_fix_ordering (type $FUNCSIG$ii) (param $0 i32) (result i32)
    (local $1 i32)
    (return
      (i32.mul
        (tee_local $1
          (call_import $callee
            (get_local $0)
          )
        )
        (i32.add
          (get_local $1)
          (call_import $callee
            (i32.add
              (get_local $0)
              (i32.const 1)
            )
          )
        )
      )
    )
  )
  (func $multiple_defs (type $10) (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (param $4 i32)
    (local $5 f64)
    (local $6 f64)
    (local $7 f64)
    (local $8 f64)
    (local $9 f64)
    (set_local $6
      (f64.const 0)
    )
    (set_local $2
      (i32.and
        (get_local $2)
        (i32.const 1)
      )
    )
    (set_local $3
      (i32.and
        (get_local $3)
        (i32.const 1)
      )
    )
    (set_local $5
      (select
        (f64.const -11353.57)
        (f64.const -0.23500000000001364)
        (i32.eq
          (i32.or
            (get_local $1)
            (i32.const 2)
          )
          (i32.const 14)
        )
      )
    )
    (set_local $7
      (f64.const 0)
    )
    (loop $label$1 $label$0
      (block $label$2
        (br_if $label$2
          (i32.or
            (f64.ge
              (get_local $7)
              (f64.const 23.2345)
            )
            (f64.ne
              (get_local $7)
              (get_local $7)
            )
          )
        )
        (set_local $8
          (get_local $6)
        )
        (loop $label$4 $label$3
          (set_local $8
            (f64.add
              (select
                (f64.const -11353.57)
                (tee_local $9
                  (f64.add
                    (get_local $7)
                    (f64.const -1)
                  )
                )
                (get_local $2)
              )
              (tee_local $6
                (get_local $8)
              )
            )
          )
          (block $label$5
            (br_if $label$5
              (get_local $3)
            )
            (set_local $9
              (get_local $5)
            )
          )
          (set_local $8
            (f64.add
              (get_local $9)
              (get_local $8)
            )
          )
          (br_if $label$3
            (f64.lt
              (get_local $7)
              (f64.const 23.2345)
            )
          )
        )
      )
      (set_local $7
        (f64.add
          (get_local $7)
          (f64.const 1)
        )
      )
      (br $label$0)
    )
  )
  (func $no_stackify_call_past_load (type $FUNCSIG$i) (result i32)
    (local $0 i32)
    (local $1 i32)
    (set_local $0
      (call_import $red)
    )
    (set_local $1
      (i32.load offset=12
        (i32.const 0)
      )
    )
    (drop
      (call_import $callee
        (get_local $0)
      )
    )
    (return
      (get_local $1)
    )
  )
  (func $no_stackify_store_past_load (type $6) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (local $3 i32)
    (set_local $1
      (block
        (block
          (set_local $3
            (get_local $0)
          )
          (i32.store
            (get_local $1)
            (get_local $3)
          )
        )
        (get_local $3)
      )
    )
    (set_local $2
      (i32.load
        (get_local $2)
      )
    )
    (drop
      (call_import $callee
        (get_local $1)
      )
    )
    (return
      (get_local $2)
    )
  )
  (func $store_past_invar_load (type $6) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (local $3 i32)
    (drop
      (call_import $callee
        (block
          (block
            (set_local $3
              (get_local $0)
            )
            (i32.store
              (get_local $1)
              (get_local $3)
            )
          )
          (get_local $3)
        )
      )
    )
    (return
      (i32.load
        (get_local $2)
      )
    )
  )
  (func $ignore_dbg_value (type $FUNCSIG$v)
    (unreachable)
  )
  (func $no_stackify_past_epilogue (type $FUNCSIG$i) (result i32)
    (local $0 i32)
    (local $1 i32)
    (local $2 i32)
    (set_local $1
      (call_import $use_memory
        (i32.add
          (tee_local $0
            (block
              (block
                (set_local $2
                  (i32.sub
                    (i32.load
                      (i32.const 4)
                    )
                    (i32.const 16)
                  )
                )
                (i32.store
                  (i32.const 4)
                  (get_local $2)
                )
              )
              (get_local $2)
            )
          )
          (i32.const 12)
        )
      )
    )
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $0)
        (i32.const 16)
      )
    )
    (return
      (get_local $1)
    )
  )
  (func $stackify_indvar (type $FUNCSIG$vii) (param $0 i32) (param $1 i32)
    (local $2 i32)
    (set_local $2
      (i32.const 0)
    )
    (loop $label$1 $label$0
      (i32.store
        (get_local $1)
        (i32.add
          (get_local $2)
          (i32.load
            (get_local $1)
          )
        )
      )
      (br_if $label$0
        (i32.ne
          (get_local $0)
          (tee_local $2
            (i32.add
              (get_local $2)
              (i32.const 1)
            )
          )
        )
      )
    )
    (return)
  )
  (func $stackpointer_dependency (type $FUNCSIG$ii) (param $0 i32) (result i32)
    (local $1 i32)
    (set_local $0
      (call_import $stackpointer_callee
        (get_local $0)
        (tee_local $1
          (i32.load
            (i32.const 4)
          )
        )
      )
    )
    (i32.store
      (i32.const 4)
      (get_local $1)
    )
    (return
      (get_local $0)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
