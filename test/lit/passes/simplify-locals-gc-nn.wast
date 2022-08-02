;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --simplify-locals -all -S -o - | filecheck %s

(module
  ;; CHECK:      (func $test-nn
  ;; CHECK-NEXT:  (local $nn anyref)
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
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (local.get $nn)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test-nn
    (local $nn (ref any))
    ;; We can not sink this set into the try, but the spec does not allow it to
    ;; remain non-nullable. Even though we are not changing dominance (we are
    ;; not changing it, because there is nothing that can throw in the try's
    ;; body that can reach the catch_all before the local.set that we move
    ;; there). See
    ;; https://github.com/WebAssembly/function-references/issues/44#issuecomment-1083146887
    (local.set $nn
      (ref.as_non_null
        (ref.null any)
      )
    )
    (try
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

  ;; CHECK:      (func $test-nullable
  ;; CHECK-NEXT:  (local $nullable anyref)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (try $try
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (local.set $nullable
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (ref.null any)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch_all
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $nullable)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test-nullable
    ;; As above, but now the local is nullable. Here we can optimize the set
    ;; into the try, with no other necessary changes.
    (local $nullable (ref null any))
    (local.set $nullable
      (ref.as_non_null
        (ref.null any)
      )
    )
    (try
      (do
        (drop
          (local.get $nullable)
        )
      )
      (catch_all
        (drop
          (local.get $nullable)
        )
      )
    )
  )
)
