(module
 (import "fuzzing-support" "log-f32" (func $logf32 (param f32)))
 (import "fuzzing-support" "log-f64" (func $logf64 (param f64)))
 (func "test32"
  (call $logf32
   (f32.add
    (f32.const -nan:0xffff82)
    (f32.neg
     (f32.const -nan:0xfff622)
    )
   )
  )
  (call $logf32
   (f32.sub
    (f32.const -nan:0xffff82)
    (f32.neg
     (f32.const -nan:0xfff622)
    )
   )
  )
  (call $logf32
   (f32.mul
    (f32.const -nan:0xffff82)
    (f32.neg
     (f32.const -nan:0xfff622)
    )
   )
  )
  (call $logf32
   (f32.div
    (f32.const -nan:0xffff82)
    (f32.neg
     (f32.const -nan:0xfff622)
    )
   )
  )
  (call $logf32
   (f32.copysign
    (f32.const -nan:0xffff82)
    (f32.neg
     (f32.const -nan:0xfff622)
    )
   )
  )
  (call $logf32
   (f32.min
    (f32.const -nan:0xffff82)
    (f32.neg
     (f32.const -nan:0xfff622)
    )
   )
  )
  (call $logf32
   (f32.max
    (f32.const -nan:0xffff82)
    (f32.neg
     (f32.const -nan:0xfff622)
    )
   )
  )
 )
 (func "test64"
  (call $logf64
   (f64.add
    (f64.const -nan:0xfffffffffff82)
    (f64.neg
     (f64.const -nan:0xfffffffffa622)
    )
   )
  )
  (call $logf64
   (f64.sub
    (f64.const -nan:0xfffffffffff82)
    (f64.neg
     (f64.const -nan:0xfffffffffa622)
    )
   )
  )
  (call $logf64
   (f64.mul
    (f64.const -nan:0xfffffffffff82)
    (f64.neg
     (f64.const -nan:0xfffffffffa622)
    )
   )
  )
  (call $logf64
   (f64.div
    (f64.const -nan:0xfffffffffff82)
    (f64.neg
     (f64.const -nan:0xfffffffffa622)
    )
   )
  )
  (call $logf64
   (f64.copysign
    (f64.const -nan:0xfffffffffff82)
    (f64.neg
     (f64.const -nan:0xfffffffffa622)
    )
   )
  )
  (call $logf64
   (f64.min
    (f64.const -nan:0xfffffffffff82)
    (f64.neg
     (f64.const -nan:0xfffffffffa622)
    )
   )
  )
  (call $logf64
   (f64.max
    (f64.const -nan:0xfffffffffff82)
    (f64.neg
     (f64.const -nan:0xfffffffffa622)
    )
   )
  )
 )
 (func "just-one-nan"
  (call $logf32
   (f32.add
    (f32.const 0)
    (f32.neg
     (f32.const -nan:0xfff622)
    )
   )
  )
  (call $logf32
   (f32.add
    (f32.const -nan:0xfff622)
    (f32.neg
     (f32.const 0)
    )
   )
  )
  (call $logf32
   (f32.add
    (f32.const -0)
    (f32.neg
     (f32.const -nan:0xfff622)
    )
   )
  )
  (call $logf32
   (f32.add
    (f32.const -nan:0xfff622)
    (f32.neg
     (f32.const -0)
    )
   )
  )
  (call $logf32
   (f32.add
    (f32.const 0)
    (f32.neg
     (f32.const nan:0xfff622)
    )
   )
  )
  (call $logf32
   (f32.add
    (f32.const nan:0xfff622)
    (f32.neg
     (f32.const 0)
    )
   )
  )
 )
 (func "ignore"
  ;; none of these are nan inputs, so the interpreter must not change the sign
  (call $logf32
   (f32.div
    (f32.const 0)
    (f32.neg
     (f32.const 0)
    )
   )
  )
  (call $logf32
   (f32.div
    (f32.const -0)
    (f32.neg
     (f32.const 0)
    )
   )
  )
  (call $logf32
   (f32.div
    (f32.const 0)
    (f32.neg
     (f32.const -0)
    )
   )
  )
  (call $logf32
   (f32.div
    (f32.const -0)
    (f32.neg
     (f32.const -0)
    )
   )
  )
 )
)
(module
 (import "fuzzing-support" "log-i32" (func $log (param i32)))
 (func $signed-comparison-to-unsigned
  (call $log
   (i32.eq               ;; should be false
    (i32.shr_s           ;; 0x0000006b after the sign-extend
     (i32.shl
      (i32.const -25749) ;; 0xffff9b6b
      (i32.const 24)
     )
     (i32.const 24)
    )
    (i32.const -149)     ;; 0xffffff6b - high bits are set, but not sign bit
   )
  )
  ;; the same, with mixed high bits. mixed bits mean the two sides can never be
  ;; equal, so the eq is always false
  (call $log
   (i32.eq
    (i32.shr_s
     (i32.shl
      (i32.const -25749)
      (i32.const 24)
     )
     (i32.const 24)
    )
    (i32.const 0xffffeb)
   )
  )
  ;; the same, with !=, so the result is always true
  (call $log
   (i32.ne
    (i32.shr_s
     (i32.shl
      (i32.const -25749)
      (i32.const 24)
     )
     (i32.const 24)
    )
    (i32.const 0xffffeb)
   )
  )
 )
 (func "foo" (param $0 i32)
  ;; 8 - 0x80000000 < 0
  ;;
  ;; is not the same as
  ;;
  ;; 8 < 0x80000000
  ;;
  ;; because of overflow. the former is true, the latter is false
  (call $log
   (i32.le_s
    (i32.sub
     (i32.const 8)
     (block $label$1 (result i32) ;; the block prevents us from optimizing this
                                  ;; which would avoid the issue. a global or a
                                  ;; call would do the same, all would make the
                                  ;; value only visible at runtime
      (i32.const 0x80000000)
     )
    )
    (i32.const 0)
   )
  )
  ;; for comparison, without the block.
  (call $log
   (i32.le_s
    (i32.sub
     (i32.const 8)
     (i32.const 0x80000000)
    )
    (i32.const 0)
   )
  )
  ;; for comparison, what X - Y < 0 => X < Y would lead to, which has a
  ;; different value
  (call $log
   (i32.le_s
    (i32.const 8)
    (i32.const 0x80000000)
   )
  )
 )
 (func $shift (param $0 i32)
  (call $log
   ;; x << 24 >> 24 << 30 >> 24 - the extra shifts make it invalid to do the
   ;; optimization of not repeating a sign-extend. That is, this would be valid
   ;; if the 30 were replaced by a 24.
   (i32.shr_s
    (i32.shl
     (i32.shr_s
      (i32.shl
       (local.get $0)
       (i32.const 24)
      )
      (i32.const 24)
     )
     (i32.const 30)
    )
    (i32.const 24)
   )
  )
 )
 (func "do-shift"
  (call $shift
   (i32.const 65419)
  )
 )
 ;; similar, but with the value compared to having the sign bit set but no
 ;; upper bits
 (func $compare-maybe-signed-eq (param $0 i32) (result i32)
  (i32.eq
   (i32.shr_s
    (i32.shl
     (local.get $0)
     (i32.const 24)
    )
    (i32.const 24)
   )
   (i32.const 128)
  )
 )
 (func "call-compare-maybe-signed-eq" (result i32)
  (call $compare-maybe-signed-eq
   (i32.const 128)
  )
 )
 ;; the same with !=
 (func $compare-maybe-signed-ne (param $0 i32) (result i32)
  (i32.ne
   (i32.shr_s
    (i32.shl
     (local.get $0)
     (i32.const 24)
    )
    (i32.const 24)
   )
   (i32.const 128)
  )
 )
 (func "call-compare-maybe-signed-ne" (result i32)
  (call $compare-maybe-signed-ne
   (i32.const 128)
  )
 )
)
