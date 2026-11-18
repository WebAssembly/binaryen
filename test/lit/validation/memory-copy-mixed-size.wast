;; RUN: not wasm-opt %s -all 2>&1 | filecheck %s

;; CHECK: memory.copy size must be valid

;; Between a 32-bit and a 64-bit memory the size is i32, not i64.
(module
  (memory $m32 1)
  (memory $m64 i64 1)

  (func $copy (param $dest i32) (param $src i64) (param $size i64)
    (memory.copy $m32 $m64
      (local.get $dest)
      (local.get $src)
      (local.get $size)
    )
  )
)
