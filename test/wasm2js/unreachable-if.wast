;; Regression test for bad assertion in autodrop that did not expect the if to
;; be finalized to unreachable.
(module
 (func $test (result i32)
  (block $l (result i32)
   (drop
    (br_if $l
     (if (result i32)
      (unreachable)
      (then
       (i32.const 0)
      )
      (else
       (i32.const 0)
      )
     )
    )
    (i32.const 0)
   )
  )
 )
)
