(module
  (memory 0 4294967295)
  (export "foo" $foo)
  (func $foo (param $$0 i32) (param $$1 i32) (param $$2 i32)
    (local $$3 i32)
    (local $$4 i32)
    (local $$5 i32)
    (local $$6 i32)
    (local $$7 i32)
    (local $$8 i32)
    (block $label$0
      (br_if
        (i32.lt_s
          (get_local $$2)
          (i32.const 1)
        )
        $label$0
      )
      (set_local $$3
        (i32.shl
          (get_local $$1)
          (i32.const 2)
        )
      )
      (set_local $$5
        (i32.const 0)
      )
      (set_local $$4
        (i32.lt_s
          (get_local $$1)
          (i32.const 1)
        )
      )
      (loop $label$2 $label$1
        (set_local $$6
          (i32.const 0)
        )
        (set_local $$7
          (get_local $$0)
        )
        (set_local $$8
          (get_local $$1)
        )
        (block $label$3
          (br_if
            (get_local $$4)
            $label$3
          )
          (loop $label$5 $label$4
            (i32.store align=4
              (get_local $$7)
              (get_local $$6)
            )
            (set_local $$8
              (i32.add
                (get_local $$8)
                (i32.const -1)
              )
            )
            (set_local $$7
              (i32.add
                (get_local $$7)
                (i32.const 4)
              )
            )
            (set_local $$6
              (i32.add
                (get_local $$6)
                (get_local $$5)
              )
            )
            (br_if
              (get_local $$8)
              $label$4
            )
          )
        )
        (set_local $$5
          (i32.add
            (get_local $$5)
            (i32.const 1)
          )
        )
        (set_local $$0
          (i32.add
            (get_local $$0)
            (get_local $$3)
          )
        )
        (br_if
          (i32.ne
            (get_local $$5)
            (get_local $$2)
          )
          $label$1
        )
      )
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4 }
