;; Test `call.if.used` intrinsic

(assert_invalid
  (module
    (import "binaryen-intrinsics" "call.if.used" (func $ciu-v (param funcref)))
  )
  "call.if.used must return a result"
)

(assert_invalid
  (module
    (import "binaryen-intrinsics" "call.if.used" (func $ciu-v (result i32)))
  )
  "call.if.used's must receive a param"
)

(assert_invalid
  (module
    (import "binaryen-intrinsics" "call.if.used" (func $ciu-v (param i32) (result i32)))
  )
  "call.if.used's last param must be a function"
)
