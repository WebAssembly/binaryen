(module
  (memory 0 4294967295)
  (import $printi "env" "printi")
  (import $printf "env" "printf")
  (import $printv "env" "printv")
  (import $split_arg "env" "split_arg")
  (import $expanded_arg "env" "expanded_arg")
  (import $lowered_result "env" "lowered_result")
  (export "f" $f)
  (func $f (param $$0 i32) (param $$1 f32) (param $$2 i64) (param $$3 i64) (param $$4 i32)
    (block $fake_return_waka123
      (block
        (call_import $printi
          (get_local $$0)
        )
        (call_import $printf
          (get_local $$1)
        )
        (call_import $printv)
        (call_import $split_arg
          (get_local $$3)
          (get_local $$2)
        )
        (call_import $expanded_arg
          (get_local $$4)
        )
        (call_import $lowered_result)
        (br $fake_return_waka123)
      )
    )
  )
)
; METADATA: { "asmConsts": {} }