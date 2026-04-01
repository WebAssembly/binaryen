;; RUN: not wasm-opt %s -all 2>&1 | filecheck %s

(module
  ;; Shared types
  (type $struct-any (shared (struct (field (mut (ref null (shared any)))))))
  (type $array-any (shared (array (mut (ref null (shared any))))))

  ;; Negative cases for struct.atomic.rmw.cmpxchg
  ;; Use eqref for expected and replacement to isolate the error to the field type.
  (func $struct-cmpxchg-anyref (param $ref (ref $struct-any)) (param $eq (ref null (shared eq)))
    (drop
      (struct.atomic.rmw.cmpxchg $struct-any 0
        (local.get $ref)
        (local.get $eq)
        (local.get $eq)
      )
    )
  )
  ;; CHECK: [wasm-validator error in function struct-cmpxchg-anyref] struct.atomic.rmw field type invalid for operation

  ;; Negative case for array.atomic.rmw.cmpxchg
  (func $array-cmpxchg-anyref (param $ref (ref $array-any)) (param $eq (ref null (shared eq)))
    (drop
      (array.atomic.rmw.cmpxchg $array-any
        (local.get $ref)
        (i32.const 0)
        (local.get $eq)
        (local.get $eq)
      )
    )
  )
  ;; CHECK: [wasm-validator error in function array-cmpxchg-anyref] array.atomic.rmw element type invalid for operation

  ;; Unshared types
  (type $struct-unshared-any (struct (field (mut anyref))))
  (func $struct-cmpxchg-unshared-anyref (param $ref (ref $struct-unshared-any)) (param $eq eqref)
    (drop
      (struct.atomic.rmw.cmpxchg $struct-unshared-any 0
        (local.get $ref)
        (local.get $eq)
        (local.get $eq)
      )
    )
  )
  ;; CHECK: [wasm-validator error in function struct-cmpxchg-unshared-anyref] struct.atomic.rmw field type invalid for operation

  ;; Check that it still fails for non-i32/i64/reference types.
  (type $struct-v128 (struct (field (mut v128))))
  (func $struct-cmpxchg-v128 (param $ref (ref $struct-v128)) (param $eq v128)
    (drop
      (struct.atomic.rmw.cmpxchg $struct-v128 0
        (local.get $ref)
        (local.get $eq)
        (local.get $eq)
      )
    )
  )
  ;; CHECK: [wasm-validator error in function struct-cmpxchg-v128] unexpected false: struct.atomic.rmw field type invalid for operation
)
