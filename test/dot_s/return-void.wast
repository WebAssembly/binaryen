(module
  (memory 0 4294967295)
  (export "return_void" $return_void)
  (func $return_void
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123)
      )
    )
  )
)
;; METADATA: { "asmConsts": {} }
