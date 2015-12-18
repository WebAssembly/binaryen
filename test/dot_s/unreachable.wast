(module
  (memory 0 4294967295)
  (import $abort "env" "abort")
  (export "f1" $f1)
  (export "f2" $f2)
  (export "f3" $f3)
  (func $f1 (result i32)
    (block
      (call_import $abort)
      (unreachable)
    )
  )
  (func $f2
    (block $fake_return_waka123
      (block
        (unreachable)
        (br $fake_return_waka123)
      )
    )
  )
  (func $f3
    (block $fake_return_waka123
      (block
        (unreachable)
        (br $fake_return_waka123)
      )
    )
  )
)
;; METADATA: { "asmConsts": {} }