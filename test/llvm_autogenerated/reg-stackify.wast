(module
 (type $FUNCSIG$iii (func (param i32 i32) (result i32)))
 (type $FUNCSIG$i (func (result i32)))
 (type $FUNCSIG$ii (func (param i32) (result i32)))
 (type $FUNCSIG$v (func))
 (type $FUNCSIG$vii (func (param i32 i32)))
 (type $FUNCSIG$vi (func (param i32)))
 (import "env" "blue" (func $blue (result i32)))
 (import "env" "callee" (func $callee (param i32) (result i32)))
 (import "env" "evoke_side_effects" (func $evoke_side_effects))
 (import "env" "green" (func $green (result i32)))
 (import "env" "readnone_callee" (func $readnone_callee (result i32)))
 (import "env" "readonly_callee" (func $readonly_callee (result i32)))
 (import "env" "red" (func $red (result i32)))
 (import "env" "stackpointer_callee" (func $stackpointer_callee (param i32 i32) (result i32)))
 (import "env" "use_2" (func $use_2 (param i32 i32)))
 (import "env" "use_a" (func $use_a (param i32)))
 (import "env" "use_b" (func $use_b (param i32)))
 (import "env" "use_memory" (func $use_memory (param i32) (result i32)))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (data (i32.const 12) "\00\00\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "no0" (func $no0))
 (export "no1" (func $no1))
 (export "yes0" (func $yes0))
 (export "yes1" (func $yes1))
 (export "sink_trap" (func $sink_trap))
 (export "sink_readnone_call" (func $sink_readnone_call))
 (export "no_sink_readonly_call" (func $no_sink_readonly_call))
 (export "stack_uses" (func $stack_uses))
 (export "multiple_uses" (func $multiple_uses))
 (export "stackify_store_across_side_effects" (func $stackify_store_across_side_effects))
 (export "div_tree" (func $div_tree))
 (export "simple_multiple_use" (func $simple_multiple_use))
 (export "multiple_uses_in_same_insn" (func $multiple_uses_in_same_insn))
 (export "commute" (func $commute))
 (export "no_stackify_past_use" (func $no_stackify_past_use))
 (export "commute_to_fix_ordering" (func $commute_to_fix_ordering))
 (export "multiple_defs" (func $multiple_defs))
 (export "no_stackify_call_past_load" (func $no_stackify_call_past_load))
 (export "no_stackify_store_past_load" (func $no_stackify_store_past_load))
 (export "store_past_invar_load" (func $store_past_invar_load))
 (export "ignore_dbg_value" (func $ignore_dbg_value))
 (export "no_stackify_past_epilogue" (func $no_stackify_past_epilogue))
 (export "stackify_indvar" (func $stackify_indvar))
 (export "stackpointer_dependency" (func $stackpointer_dependency))
 (export "call_indirect_stackify" (func $call_indirect_stackify))
 (func $no0 (param $0 i32) (param $1 i32) (result i32)
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
 (func $no1 (param $0 i32) (param $1 i32) (result i32)
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
 (func $yes0 (param $0 i32) (param $1 i32) (result i32)
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
 (func $yes1 (param $0 i32) (result i32)
  (return
   (i32.load
    (get_local $0)
   )
  )
 )
 (func $sink_trap (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
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
 (func $sink_readnone_call (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (i32.store
   (get_local $2)
   (i32.const 0)
  )
  (return
   (call $readnone_callee)
  )
 )
 (func $no_sink_readonly_call (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (local $3 i32)
  (set_local $3
   (call $readonly_callee)
  )
  (i32.store
   (get_local $2)
   (i32.const 0)
  )
  (return
   (get_local $3)
  )
 )
 (func $stack_uses (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (result i32)
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
 (func $multiple_uses (param $0 i32) (param $1 i32) (param $2 i32)
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
 (func $stackify_store_across_side_effects (param $0 i32)
  (i64.store
   (get_local $0)
   (i64.const 4611686018427387904)
  )
  (call $evoke_side_effects)
  (i64.store
   (get_local $0)
   (i64.const 4611686018427387904)
  )
  (call $evoke_side_effects)
  (return)
 )
 (func $div_tree (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (param $4 i32) (param $5 i32) (param $6 i32) (param $7 i32) (param $8 i32) (param $9 i32) (param $10 i32) (param $11 i32) (param $12 i32) (param $13 i32) (param $14 i32) (param $15 i32) (result i32)
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
 (func $simple_multiple_use (param $0 i32) (param $1 i32)
  (call $use_a
   (tee_local $1
    (i32.mul
     (get_local $1)
     (get_local $0)
    )
   )
  )
  (call $use_b
   (get_local $1)
  )
  (return)
 )
 (func $multiple_uses_in_same_insn (param $0 i32) (param $1 i32)
  (call $use_2
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
 (func $commute (result i32)
  (return
   (i32.add
    (i32.add
     (call $red)
     (call $green)
    )
    (call $blue)
   )
  )
 )
 (func $no_stackify_past_use (param $0 i32) (result i32)
  (local $1 i32)
  (set_local $1
   (call $callee
    (get_local $0)
   )
  )
  (return
   (i32.div_s
    (i32.sub
     (call $callee
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
 (func $commute_to_fix_ordering (param $0 i32) (result i32)
  (local $1 i32)
  (return
   (i32.mul
    (tee_local $1
     (call $callee
      (get_local $0)
     )
    )
    (i32.add
     (get_local $1)
     (call $callee
      (i32.add
       (get_local $0)
       (i32.const 1)
      )
     )
    )
   )
  )
 )
 (func $multiple_defs (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (param $4 i32)
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
  (loop $label$0
   (block $label$1
    (br_if $label$1
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
    (loop $label$2
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
     (block $label$3
      (br_if $label$3
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
     (br_if $label$2
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
 (func $no_stackify_call_past_load (result i32)
  (local $0 i32)
  (local $1 i32)
  (set_local $0
   (call $red)
  )
  (set_local $1
   (i32.load offset=12
    (i32.const 0)
   )
  )
  (drop
   (call $callee
    (get_local $0)
   )
  )
  (return
   (get_local $1)
  )
 )
 (func $no_stackify_store_past_load (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (i32.store
   (get_local $1)
   (get_local $0)
  )
  (set_local $2
   (i32.load
    (get_local $2)
   )
  )
  (drop
   (call $callee
    (get_local $0)
   )
  )
  (return
   (get_local $2)
  )
 )
 (func $store_past_invar_load (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (i32.store
   (get_local $1)
   (get_local $0)
  )
  (drop
   (call $callee
    (get_local $0)
   )
  )
  (return
   (i32.load
    (get_local $2)
   )
  )
 )
 (func $ignore_dbg_value
  (unreachable)
 )
 (func $no_stackify_past_epilogue (result i32)
  (local $0 i32)
  (local $1 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $1
    (i32.sub
     (i32.load offset=4
      (i32.const 0)
     )
     (i32.const 16)
    )
   )
  )
  (set_local $0
   (call $use_memory
    (i32.add
     (get_local $1)
     (i32.const 12)
    )
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.add
    (get_local $1)
    (i32.const 16)
   )
  )
  (return
   (get_local $0)
  )
 )
 (func $stackify_indvar (param $0 i32) (param $1 i32)
  (local $2 i32)
  (set_local $2
   (i32.const 0)
  )
  (loop $label$0
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
 (func $stackpointer_dependency (param $0 i32) (result i32)
  (local $1 i32)
  (set_local $0
   (call $stackpointer_callee
    (get_local $0)
    (tee_local $1
     (i32.load offset=4
      (i32.const 0)
     )
    )
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (get_local $1)
  )
  (return
   (get_local $0)
  )
 )
 (func $call_indirect_stackify (param $0 i32) (param $1 i32) (result i32)
  (return
   (call_indirect $FUNCSIG$iii
    (tee_local $0
     (i32.load
      (get_local $0)
     )
    )
    (get_local $1)
    (i32.load
     (i32.load
      (get_local $0)
     )
    )
   )
  )
 )
 (func $stackSave (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (param $0 i32) (result i32)
  (local $1 i32)
  (set_local $1
   (i32.load offset=4
    (i32.const 0)
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.and
    (i32.add
     (i32.add
      (get_local $1)
      (get_local $0)
     )
     (i32.const 15)
    )
    (i32.const -16)
   )
  )
  (get_local $1)
 )
 (func $stackRestore (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
