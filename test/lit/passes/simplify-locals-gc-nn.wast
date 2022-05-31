;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --simplify-locals -all --enable-gc-nn-locals -S -o - | filecheck %s

(module
  ;; CHECK:      (func $test
  ;; CHECK-NEXT:  (local $nn (ref any))
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (try $try
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (local.set $nn
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (ref.null any)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch_all
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $nn)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test
    (local $nn (ref any))
    ;; We should not sink this set into the try, as we want to avoid the risk of
    ;; changing dominance. TODO This try has no extra branches to the
    (local.set $nn
      (ref.as_non_null
        (ref.null any)
      )
    )
    (try
      ;;(call $test)
      (do
        (drop
          (local.get $nn)
        )
      )
      (catch_all
        (drop
          (local.get $nn)
        )
      )
    )
  )
)
