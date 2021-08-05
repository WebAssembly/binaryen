;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --optimize-for-js -all -S -o - \
;; RUN:  | filecheck %s

(module
 ;; CHECK:      (func $is-power-of-2_32 (param $x i32) (result i32)
 ;; CHECK-NEXT:  (i32.and
 ;; CHECK-NEXT:   (i32.eqz
 ;; CHECK-NEXT:    (i32.eqz
 ;; CHECK-NEXT:     (local.get $x)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (i32.eqz
 ;; CHECK-NEXT:    (i32.and
 ;; CHECK-NEXT:     (local.get $x)
 ;; CHECK-NEXT:     (i32.sub
 ;; CHECK-NEXT:      (local.get $x)
 ;; CHECK-NEXT:      (i32.const 1)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $is-power-of-2_32 (param $x i32) (result i32)
  (i32.eq
   (i32.popcnt (local.get $x))
   (i32.const 1)
  )
 )
 ;; CHECK:      (func $is-power-of-2_64 (param $x i64) (result i32)
 ;; CHECK-NEXT:  (i32.and
 ;; CHECK-NEXT:   (i32.eqz
 ;; CHECK-NEXT:    (i64.eqz
 ;; CHECK-NEXT:     (local.get $x)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (i64.eqz
 ;; CHECK-NEXT:    (i64.and
 ;; CHECK-NEXT:     (local.get $x)
 ;; CHECK-NEXT:     (i64.sub
 ;; CHECK-NEXT:      (local.get $x)
 ;; CHECK-NEXT:      (i64.const 1)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $is-power-of-2_64 (param $x i64) (result i32)
  (i64.eq
   (i64.popcnt (local.get $x))
   (i64.const 1)
  )
 )

 ;; Unsigned div by const

 ;; CHECK:      (func $div-unsigned-by0-i64 (param $x i64) (result i64)
 ;; CHECK-NEXT:  (i64.const 0)
 ;; CHECK-NEXT: )
 (func $div-unsigned-by0-i64 (param $x i64) (result i64)
  (i64.div_u
   (local.get $x)
   (i64.const 0)
  )
 )
 ;; CHECK:      (func $div-unsigned-by-4294967297-i64 (param $x i64) (result i64)
 ;; CHECK-NEXT:  (local $1 i64)
 ;; CHECK-NEXT:  (if (result i64)
 ;; CHECK-NEXT:   (i64.eqz
 ;; CHECK-NEXT:    (i64.shr_u
 ;; CHECK-NEXT:     (local.get $x)
 ;; CHECK-NEXT:     (i64.const 32)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (i64.const 0)
 ;; CHECK-NEXT:   (i64.shr_u
 ;; CHECK-NEXT:    (local.tee $1
 ;; CHECK-NEXT:     (call $__wasm_i64_mulh
 ;; CHECK-NEXT:      (local.get $x)
 ;; CHECK-NEXT:      (i64.const -4294967295)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (i64.const 32)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $div-unsigned-by-4294967297-i64 (param $x i64) (result i64)
  (i64.div_u
   (local.get $x)
   (i64.const 4294967297)
  )
 )
 ;; CHECK:      (func $div-unsigned-by-max32-i64 (param $x i64) (result i64)
 ;; CHECK-NEXT:  (local $1 i64)
 ;; CHECK-NEXT:  (if (result i64)
 ;; CHECK-NEXT:   (i64.eqz
 ;; CHECK-NEXT:    (i64.shr_u
 ;; CHECK-NEXT:     (local.get $x)
 ;; CHECK-NEXT:     (i64.const 32)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (i64.extend_i32_u
 ;; CHECK-NEXT:    (i32.div_u
 ;; CHECK-NEXT:     (i32.wrap_i64
 ;; CHECK-NEXT:      (local.get $x)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:     (i32.const -1)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (i64.shr_u
 ;; CHECK-NEXT:    (local.tee $1
 ;; CHECK-NEXT:     (call $__wasm_i64_mulh
 ;; CHECK-NEXT:      (local.get $x)
 ;; CHECK-NEXT:      (i64.const -9223372034707292159)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (i64.const 31)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $div-unsigned-by-max32-i64 (param $x i64) (result i64)
  (i64.div_u
   (local.get $x)
   (i64.const 0xFFFFFFFF)
  )
 )
 ;; CHECK:      (func $div-unsigned-by5-i64 (param $x i64) (result i64)
 ;; CHECK-NEXT:  (local $1 i64)
 ;; CHECK-NEXT:  (if (result i64)
 ;; CHECK-NEXT:   (i64.eqz
 ;; CHECK-NEXT:    (i64.shr_u
 ;; CHECK-NEXT:     (local.get $x)
 ;; CHECK-NEXT:     (i64.const 32)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (i64.extend_i32_u
 ;; CHECK-NEXT:    (i32.div_u
 ;; CHECK-NEXT:     (i32.wrap_i64
 ;; CHECK-NEXT:      (local.get $x)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:     (i32.const 5)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (i64.shr_u
 ;; CHECK-NEXT:    (local.tee $1
 ;; CHECK-NEXT:     (call $__wasm_i64_mulh
 ;; CHECK-NEXT:      (local.get $x)
 ;; CHECK-NEXT:      (i64.const -3689348814741910323)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (i64.const 2)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $div-unsigned-by5-i64 (param $x i64) (result i64)
  (i64.div_u
   (local.get $x)
   (i64.const 5)
  )
 )
 ;; CHECK:      (func $div-unsigned-by7-i64 (param $x i64) (result i64)
 ;; CHECK-NEXT:  (local $1 i64)
 ;; CHECK-NEXT:  (if (result i64)
 ;; CHECK-NEXT:   (i64.eqz
 ;; CHECK-NEXT:    (i64.shr_u
 ;; CHECK-NEXT:     (local.get $x)
 ;; CHECK-NEXT:     (i64.const 32)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (i64.extend_i32_u
 ;; CHECK-NEXT:    (i32.div_u
 ;; CHECK-NEXT:     (i32.wrap_i64
 ;; CHECK-NEXT:      (local.get $x)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:     (i32.const 7)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (i64.shr_u
 ;; CHECK-NEXT:    (i64.add
 ;; CHECK-NEXT:     (i64.shr_u
 ;; CHECK-NEXT:      (i64.sub
 ;; CHECK-NEXT:       (local.get $x)
 ;; CHECK-NEXT:       (local.tee $1
 ;; CHECK-NEXT:        (call $__wasm_i64_mulh
 ;; CHECK-NEXT:         (local.get $x)
 ;; CHECK-NEXT:         (i64.const 2635249153387078803)
 ;; CHECK-NEXT:        )
 ;; CHECK-NEXT:       )
 ;; CHECK-NEXT:      )
 ;; CHECK-NEXT:      (i64.const 1)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:     (local.get $1)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (i64.const 2)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $div-unsigned-by7-i64 (param $x i64) (result i64)
  (i64.div_u
   (local.get $x)
   (i64.const 7)
  )
 )
 ;; CHECK:      (func $div-unsigned-by-4294967296-i64-skip_POT (param $x i64) (result i64)
 ;; CHECK-NEXT:  (i64.div_u
 ;; CHECK-NEXT:   (local.get $x)
 ;; CHECK-NEXT:   (i64.const 4294967296)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $div-unsigned-by-4294967296-i64-skip_POT (param $x i64) (result i64)
  (i64.div_u
   (local.get $x)
   (i64.const 4294967296)
  )
 )
 ;; CHECK:      (func $div-unsigned-by-1-i64-skip_POT (param $x i64) (result i64)
 ;; CHECK-NEXT:  (i64.div_u
 ;; CHECK-NEXT:   (local.get $x)
 ;; CHECK-NEXT:   (i64.const 1)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $div-unsigned-by-1-i64-skip_POT (param $x i64) (result i64)
  (i64.div_u
   (local.get $x)
   (i64.const 1)
  )
 )

 ;; Signed div by const

 ;; CHECK:      (func $div-signed-by0-i64 (param $x i64) (result i64)
 ;; CHECK-NEXT:  (i64.const 0)
 ;; CHECK-NEXT: )
 (func $div-signed-by0-i64 (param $x i64) (result i64)
  (i64.div_s
   (local.get $x)
   (i64.const 0)
  )
 )
 ;; CHECK:      (func $div-signed-by-minus-1-i64 (param $x i64) (result i64)
 ;; CHECK-NEXT:  (i64.sub
 ;; CHECK-NEXT:   (i64.const 0)
 ;; CHECK-NEXT:   (local.get $x)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $div-signed-by-minus-1-i64 (param $x i64) (result i64)
  (i64.div_s
   (local.get $x)
   (i64.const -1)
  )
 )
 ;; CHECK:      (func $div-signed-by-minus-2-i64 (param $x i64) (result i64)
 ;; CHECK-NEXT:  (i64.sub
 ;; CHECK-NEXT:   (i64.const 0)
 ;; CHECK-NEXT:   (i64.shr_s
 ;; CHECK-NEXT:    (select
 ;; CHECK-NEXT:     (i64.add
 ;; CHECK-NEXT:      (local.get $x)
 ;; CHECK-NEXT:      (i64.const 1)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:     (local.get $x)
 ;; CHECK-NEXT:     (i64.lt_s
 ;; CHECK-NEXT:      (local.get $x)
 ;; CHECK-NEXT:      (i64.const 0)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (i64.const 1)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $div-signed-by-minus-2-i64 (param $x i64) (result i64)
  (i64.div_s
   (local.get $x)
   (i64.const -2)
  )
 )
 ;; CHECK:      (func $div-signed-by-2-i64 (param $x i64) (result i64)
 ;; CHECK-NEXT:  (i64.shr_s
 ;; CHECK-NEXT:   (select
 ;; CHECK-NEXT:    (i64.add
 ;; CHECK-NEXT:     (local.get $x)
 ;; CHECK-NEXT:     (i64.const 1)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:    (i64.lt_s
 ;; CHECK-NEXT:     (local.get $x)
 ;; CHECK-NEXT:     (i64.const 0)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (i64.const 1)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $div-signed-by-2-i64 (param $x i64) (result i64)
  (i64.div_s
   (local.get $x)
   (i64.const 2)
  )
 )
)
