;; TODO: enable validation
;; RUN: wasm-opt %s --poppify --no-validation -all -S -o - | filecheck %s

(module
  ;; CHECK: (global $foo (mut i32) (i32.const 0))
  (global $foo (mut i32) (i32.const 0))

  ;; CHECK: (global $tuple$1 f64 (f64.const 0))
  (global $tuple$1 f64 (f64.const 0)) ;; interfering name!

  ;; CHECK: (global $tuple$2 (mut f32) (f32.const 2))
  ;; CHECK: (global $tuple$1_0 (mut i64) (i64.const 1))
  ;; CHECK: (global $tuple$0 (mut i32) (global.get $foo))
  (global $tuple (mut (i32 i64 f32))
    (tuple.make (global.get $foo) (i64.const 1) (f32.const 2))
  )

  ;; CHECK: (global $other-tuple$2 f32 (global.get $tuple$2))
  ;; CHECK: (global $other-tuple$1 i64 (global.get $tuple$1_0))
  ;; CHECK: (global $other-tuple$0 i32 (global.get $tuple$0))
  (global $other-tuple (i32 i64 f32) (global.get $tuple))

  ;; CHECK:      (func $global-get-tuple
  ;; CHECK-NEXT:  (global.get $tuple$0)
  ;; CHECK-NEXT:  (global.get $tuple$1_0)
  ;; CHECK-NEXT:  (global.get $tuple$2)
  ;; CHECK-NEXT: )
  (func $global-get-tuple (result i32 i64 f32)
    (global.get $tuple)
  )

  ;; CHECK:      (func $global-set-tuple
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT:  (i64.const 1)
  ;; CHECK-NEXT:  (f32.const 2)
  ;; CHECK-NEXT:  (global.set $tuple$2
  ;; CHECK-NEXT:   (pop f32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (global.set $tuple$1_0
  ;; CHECK-NEXT:   (pop i64)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (global.set $tuple$0
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $global-set-tuple
    (global.set $tuple
      (tuple.make
        (i32.const 0)
        (i64.const 1)
        (f32.const 2)
      )
    )
  )
)
