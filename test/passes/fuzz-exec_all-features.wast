(module
 (export "a" (func $a))
 (export "b" (func $b))
 (export "c" (func $c))
 (export "d" (func $d))
 (export "e" (func $e))
 (func $a (result i32)
  (i32.extend8_s
   (i32.const 187)
  )
 )
 (func $b (result i32)
  (i32.extend16_s
   (i32.const 33768)
  )
 )
 (func $c (result i64)
  (i64.extend8_s
   (i64.const 187)
  )
 )
 (func $d (result i64)
  (i64.extend16_s
   (i64.const 33768)
  )
 )
 (func $e (result i64)
  (i64.extend32_s
   (i64.const 2148318184)
  )
 )
)
(module
 (import "fuzzing-support" "log-i32" (func $fimport$0 (param i32)))
 (memory $0 (shared 1 1))
 (func "unaligned_load" (result i32)
  (i32.atomic.load
   (i32.const 1) ;; unaligned ptr
   (i32.const 1)
  )
 )
 (func "unaligned_load_offset" (result i32)
  (i32.atomic.load offset=1 ;; unaligned with offset
   (i32.const 0)
   (i32.const 1)
  )
 )
 (func "aligned_for_size" (result i32)
  (i32.atomic.load16_u offset=2 ;; just 2 bytes loaded, so size is ok
   (i32.const 0)
  )
 )
 (func "unaligned_notify" (result i32)
  (atomic.notify
   (i32.const 1) ;; unaligned
   (i32.const 1)
  )
 )
 (func "wrap_cmpxchg" (param $0 i32) (param $1 i32)
  (drop
   (i32.atomic.rmw8.cmpxchg_u
    (i32.const 0)
    (i32.const 256) ;; 0x100, lower byte is 0 - should be wrapped to that
    (i32.const 42)
   )
  )
  (call $fimport$0
   (i32.load (i32.const 0))
  )
 )
 (func "oob_notify"
  (drop
   (atomic.notify offset=22
    (i32.const -104) ;; illegal address
    (i32.const -72)
   )
  )
 )
)
