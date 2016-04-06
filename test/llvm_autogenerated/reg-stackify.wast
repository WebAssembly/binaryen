(module
  (memory 0)
  (export "memory" memory)
  (type $FUNCSIG$v (func))
  (type $FUNCSIG$vi (func (param i32)))
  (type $FUNCSIG$vii (func (param i32 i32)))
  (type $FUNCSIG$i (func (result i32)))
  (type $FUNCSIG$ii (func (param i32) (result i32)))
  (import $evoke_side_effects "env" "evoke_side_effects")
  (import $use_a "env" "use_a" (param i32))
  (import $use_b "env" "use_b" (param i32))
  (import $use_2 "env" "use_2" (param i32 i32))
  (import $red "env" "red" (result i32))
  (import $green "env" "green" (result i32))
  (import $blue "env" "blue" (result i32))
  (import $callee "env" "callee" (param i32) (result i32))
  (export "no0" $no0)
  (export "no1" $no1)
  (export "yes0" $yes0)
  (export "yes1" $yes1)
  (export "stack_uses" $stack_uses)
  (export "multiple_uses" $multiple_uses)
  (export "stackify_store_across_side_effects" $stackify_store_across_side_effects)
  (export "div_tree" $div_tree)
  (export "simple_multiple_use" $simple_multiple_use)
  (export "multiple_uses_in_same_insn" $multiple_uses_in_same_insn)
  (export "commute" $commute)
  (export "no_stackify_past_use" $no_stackify_past_use)
  (func $no0 (param $$0 i32) (param $$1 i32) (result i32)
    (set_local $$1
      (i32.load
        (get_local $$1)
      )
    )
    (i32.store
      (get_local $$0)
      (i32.const 0)
    )
    (return
      (get_local $$1)
    )
  )
  (func $no1 (param $$0 i32) (param $$1 i32) (result i32)
    (set_local $$1
      (i32.load
        (get_local $$1)
      )
    )
    (i32.store
      (get_local $$0)
      (i32.const 0)
    )
    (return
      (get_local $$1)
    )
  )
  (func $yes0 (param $$0 i32) (param $$1 i32) (result i32)
    (i32.store
      (get_local $$0)
      (i32.const 0)
    )
    (return
      (i32.load
        (get_local $$1)
      )
    )
  )
  (func $yes1 (param $$0 i32) (result i32)
    (return
      (i32.load
        (get_local $$0)
      )
    )
  )
  (func $stack_uses (param $$0 i32) (param $$1 i32) (param $$2 i32) (param $$3 i32) (result i32)
    (block $label$0
      (br_if $label$0
        (i32.ne
          (i32.xor
            (i32.xor
              (i32.lt_s
                (get_local $$0)
                (i32.const 1)
              )
              (i32.lt_s
                (get_local $$1)
                (i32.const 2)
              )
            )
            (i32.xor
              (i32.lt_s
                (get_local $$2)
                (i32.const 1)
              )
              (i32.lt_s
                (get_local $$3)
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
  (func $multiple_uses (param $$0 i32) (param $$1 i32) (param $$2 i32)
    (local $$3 i32)
    (block $label$0
      (br_if $label$0
        (i32.ge_u
          (set_local $$3
            (i32.load
              (get_local $$2)
            )
          )
          (get_local $$1)
        )
      )
      (br_if $label$0
        (i32.lt_u
          (get_local $$3)
          (get_local $$0)
        )
      )
      (i32.store
        (get_local $$2)
        (get_local $$3)
      )
    )
    (return)
  )
  (func $stackify_store_across_side_effects (param $$0 i32)
    (local $$1 i64)
    (set_local $$1
      (i64.store
        (get_local $$0)
        (i64.const 4611686018427387904)
      )
    )
    (call_import $evoke_side_effects)
    (i64.store
      (get_local $$0)
      (get_local $$1)
    )
    (call_import $evoke_side_effects)
    (return)
  )
  (func $div_tree (param $$0 i32) (param $$1 i32) (param $$2 i32) (param $$3 i32) (param $$4 i32) (param $$5 i32) (param $$6 i32) (param $$7 i32) (param $$8 i32) (param $$9 i32) (param $$10 i32) (param $$11 i32) (param $$12 i32) (param $$13 i32) (param $$14 i32) (param $$15 i32) (result i32)
    (return
      (i32.div_s
        (i32.div_s
          (i32.div_s
            (i32.div_s
              (get_local $$0)
              (get_local $$1)
            )
            (i32.div_s
              (get_local $$2)
              (get_local $$3)
            )
          )
          (i32.div_s
            (i32.div_s
              (get_local $$4)
              (get_local $$5)
            )
            (i32.div_s
              (get_local $$6)
              (get_local $$7)
            )
          )
        )
        (i32.div_s
          (i32.div_s
            (i32.div_s
              (get_local $$8)
              (get_local $$9)
            )
            (i32.div_s
              (get_local $$10)
              (get_local $$11)
            )
          )
          (i32.div_s
            (i32.div_s
              (get_local $$12)
              (get_local $$13)
            )
            (i32.div_s
              (get_local $$14)
              (get_local $$15)
            )
          )
        )
      )
    )
  )
  (func $simple_multiple_use (param $$0 i32) (param $$1 i32)
    (call_import $use_a
      (set_local $$0
        (i32.mul
          (get_local $$1)
          (get_local $$0)
        )
      )
    )
    (call_import $use_b
      (get_local $$0)
    )
    (return)
  )
  (func $multiple_uses_in_same_insn (param $$0 i32) (param $$1 i32)
    (call_import $use_2
      (set_local $$0
        (i32.mul
          (get_local $$1)
          (get_local $$0)
        )
      )
      (get_local $$0)
    )
    (return)
  )
  (func $commute (result i32)
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
  (func $no_stackify_past_use (param $$0 i32) (result i32)
    (local $$1 i32)
    (set_local $$1
      (call_import $callee
        (get_local $$0)
      )
    )
    (return
      (i32.mul
        (get_local $$1)
        (i32.add
          (get_local $$1)
          (call_import $callee
            (i32.add
              (get_local $$0)
              (i32.const 1)
            )
          )
        )
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4, "initializers": [] }
