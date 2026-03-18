;; RUN: not wasm-opt %s --enable-gc --enable-shared-everything --enable-reference-types --disable-threads 2>&1 | filecheck %s
;; RUN: wasm-opt %s --enable-gc --enable-shared-everything --enable-reference-types --enable-threads

(module
  (type $struct (struct (field (mut i32))))
  (type $array (array (mut i32)))

  (func $struct-cmpxchg (param $ref (ref $struct)) (param $expected i32) (param $replacement i32)
    (drop
      (struct.atomic.rmw.cmpxchg $struct 0
        (local.get $ref)
        (local.get $expected)
        (local.get $replacement)
      )
    )
  )

  (func $struct-rmw (param $ref (ref $struct)) (param $value i32)
    (drop
      (struct.atomic.rmw.add $struct 0
        (local.get $ref)
        (local.get $value)
      )
    )
  )

  (func $array-cmpxchg (param $ref (ref $array)) (param $expected i32) (param $replacement i32)
    (drop
      (array.atomic.rmw.cmpxchg $array
        (local.get $ref)
        (i32.const 0)
        (local.get $expected)
        (local.get $replacement)
      )
    )
  )

  (func $array-rmw (param $ref (ref $array)) (param $value i32)
    (drop
      (array.atomic.rmw.add $array
        (local.get $ref)
        (i32.const 0)
        (local.get $value)
      )
    )
  )
)

;; CHECK: [wasm-validator error in function struct-cmpxchg] unexpected false: struct.atomic.rmw requires additional features , on 
;; CHECK: [--enable-threads]

;; CHECK: [wasm-validator error in function struct-rmw] unexpected false: struct.atomic.rmw requires additional features , on 
;; CHECK: [--enable-threads]

;; CHECK: [wasm-validator error in function array-cmpxchg] unexpected false: array.atomic.rmw requires additional features , on 
;; CHECK: [--enable-threads]

;; CHECK: [wasm-validator error in function array-rmw] unexpected false: array.atomic.rmw requires additional features , on 
;; CHECK: [--enable-threads]
