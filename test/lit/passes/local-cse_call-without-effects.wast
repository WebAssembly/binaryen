;; RUN: foreach %s %t wasm-opt --local-cse --intrinsic-lowering -S -o - | filecheck %s

(module
 (import "binaryen-intrinsics" "call.without.effects" (func $cwe-ii-i (param i32 i32 funcref) (result i32)))

 (func $add (param $0 i32) (param $1 i32) (result i32)
  (i32.add (local.get $0) (local.get $1))
 )

 (func $test (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  (local $3 i32)
  (local.set $2
   (call $cwe-ii-i
    (local.get $0)
    (local.get $1)
    (ref.func $add)
   )
  )
  (local.set $3
   (call $cwe-ii-i
    (local.get $0)
    (local.get $1)
    (ref.func $add)
   )
  )
  (return (i32.add (local.get $2) (local.get $3)))
 )
)