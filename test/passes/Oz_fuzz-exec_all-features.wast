(module
 (type $[mut:i8] (array (mut i8)))
 (func "foo" (result i32)
  ;; before opts this will trap on failing to allocate -1 >>> 0 bytes. after
  ;; opts the unused value is removed so there is no trap, and a value is
  ;; returned, which should not confuse the fuzzer.
  (drop
   (array.new_default_with_rtt $[mut:i8]
    (i32.const -1)
    (rtt.canon $[mut:i8])
   )
  )
  (i32.const 0)
 )
)
