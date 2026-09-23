;; RUN: wasm-opt -all --optimize-instructions %s -S -o - | filecheck %s

;; (i32.gt_s (local.tee $0 X) (local.get $0)) is X compared with itself,
;; always 0. The tee and its load are preserved for trap behavior; the
;; comparison folds to a constant.
;; CHECK:      (drop
;; CHECK-NEXT:  (local.tee $0
;; CHECK-NEXT:   (i32.load
;; CHECK-NEXT:    (i32.const 0)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT: )
;; CHECK-NEXT: (i32.const 0)
;; NOT: i32.gt_s
(module
  (memory 1)
  (func $f (result i32) (local $0 i32)
    (i32.gt_s
      (local.tee $0 (i32.load (i32.const 0)))
      (local.get $0))
  )
)