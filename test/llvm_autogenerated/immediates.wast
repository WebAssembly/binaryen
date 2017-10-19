(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "zero_i32" (func $zero_i32))
 (export "one_i32" (func $one_i32))
 (export "max_i32" (func $max_i32))
 (export "min_i32" (func $min_i32))
 (export "zero_i64" (func $zero_i64))
 (export "one_i64" (func $one_i64))
 (export "max_i64" (func $max_i64))
 (export "min_i64" (func $min_i64))
 (export "negzero_f32" (func $negzero_f32))
 (export "zero_f32" (func $zero_f32))
 (export "one_f32" (func $one_f32))
 (export "two_f32" (func $two_f32))
 (export "nan_f32" (func $nan_f32))
 (export "negnan_f32" (func $negnan_f32))
 (export "inf_f32" (func $inf_f32))
 (export "neginf_f32" (func $neginf_f32))
 (export "custom_nan_f32" (func $custom_nan_f32))
 (export "custom_nans_f32" (func $custom_nans_f32))
 (export "negzero_f64" (func $negzero_f64))
 (export "zero_f64" (func $zero_f64))
 (export "one_f64" (func $one_f64))
 (export "two_f64" (func $two_f64))
 (export "nan_f64" (func $nan_f64))
 (export "negnan_f64" (func $negnan_f64))
 (export "inf_f64" (func $inf_f64))
 (export "neginf_f64" (func $neginf_f64))
 (export "custom_nan_f64" (func $custom_nan_f64))
 (export "custom_nans_f64" (func $custom_nans_f64))
 (func $zero_i32 (result i32) ;; 0
  (return
   (i32.const 0)
  )
 )
 (func $one_i32 (result i32) ;; 1
  (return
   (i32.const 1)
  )
 )
 (func $max_i32 (result i32) ;; 2
  (return
   (i32.const 2147483647)
  )
 )
 (func $min_i32 (result i32) ;; 3
  (return
   (i32.const -2147483648)
  )
 )
 (func $zero_i64 (result i64) ;; 4
  (return
   (i64.const 0)
  )
 )
 (func $one_i64 (result i64) ;; 5
  (return
   (i64.const 1)
  )
 )
 (func $max_i64 (result i64) ;; 6
  (return
   (i64.const 9223372036854775807)
  )
 )
 (func $min_i64 (result i64) ;; 7
  (return
   (i64.const -9223372036854775808)
  )
 )
 (func $negzero_f32 (result f32) ;; 8
  (return
   (f32.const -0)
  )
 )
 (func $zero_f32 (result f32) ;; 9
  (return
   (f32.const 0)
  )
 )
 (func $one_f32 (result f32) ;; 10
  (return
   (f32.const 1)
  )
 )
 (func $two_f32 (result f32) ;; 11
  (return
   (f32.const 2)
  )
 )
 (func $nan_f32 (result f32) ;; 12
  (return
   (f32.const nan:0x400000)
  )
 )
 (func $negnan_f32 (result f32) ;; 13
  (return
   (f32.const -nan:0x400000)
  )
 )
 (func $inf_f32 (result f32) ;; 14
  (return
   (f32.const inf)
  )
 )
 (func $neginf_f32 (result f32) ;; 15
  (return
   (f32.const -inf)
  )
 )
 (func $custom_nan_f32 (result f32) ;; 16
  (return
   (f32.const -nan:0x6bcdef)
  )
 )
 (func $custom_nans_f32 (result f32) ;; 17
  (return
   (f32.const -nan:0x6bcdef)
  )
 )
 (func $negzero_f64 (result f64) ;; 18
  (return
   (f64.const -0)
  )
 )
 (func $zero_f64 (result f64) ;; 19
  (return
   (f64.const 0)
  )
 )
 (func $one_f64 (result f64) ;; 20
  (return
   (f64.const 1)
  )
 )
 (func $two_f64 (result f64) ;; 21
  (return
   (f64.const 2)
  )
 )
 (func $nan_f64 (result f64) ;; 22
  (return
   (f64.const nan:0x8000000000000)
  )
 )
 (func $negnan_f64 (result f64) ;; 23
  (return
   (f64.const -nan:0x8000000000000)
  )
 )
 (func $inf_f64 (result f64) ;; 24
  (return
   (f64.const inf)
  )
 )
 (func $neginf_f64 (result f64) ;; 25
  (return
   (f64.const -inf)
  )
 )
 (func $custom_nan_f64 (result f64) ;; 26
  (return
   (f64.const -nan:0xabcdef0123456)
  )
 )
 (func $custom_nans_f64 (result f64) ;; 27
  (return
   (f64.const -nan:0x2bcdef0123456)
  )
 )
 (func $stackSave (result i32) ;; 28
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (param $0 i32) (result i32) ;; 29
  (local $1 i32)
  (set_local $1
   (i32.load offset=4
    (i32.const 0)
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.and
    (i32.sub
     (get_local $1)
     (get_local $0)
    )
    (i32.const -16)
   )
  )
  (get_local $1)
 )
 (func $stackRestore (param $0 i32) ;; 30
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
