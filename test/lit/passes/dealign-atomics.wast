;; RUN: wasm-opt %s --enable-threads --dealign -S -o - | filecheck %s

(module
  (memory 1 1 shared)

  (func $test
    (drop (i32.load align=4 (i32.const 0)))
    (drop (i32.atomic.load (i32.const 4)))
    (i32.store align=4 (i32.const 8) (i32.const 0))
    (i32.atomic.store (i32.const 12) (i32.const 0))
  )
)

;; CHECK: (i32.load align=1
;; CHECK: (i32.atomic.load
;; CHECK-NOT: i32.atomic.load align=1
;; CHECK: (i32.store align=1
;; CHECK: (i32.atomic.store
;; CHECK-NOT: i32.atomic.store align=1
