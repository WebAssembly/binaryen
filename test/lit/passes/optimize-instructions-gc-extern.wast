;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --optimize-instructions -all -S -o - \
;; RUN:   | filecheck %s

(module
  ;; CHECK:      (func $extern.externalize (type $anyref_externref_=>_none) (param $x anyref) (param $y externref)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (extern.externalize
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (extern.externalize
  ;; CHECK-NEXT:    (ref.as_non_null
  ;; CHECK-NEXT:     (local.get $x)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (extern.internalize
  ;; CHECK-NEXT:    (local.get $y)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (extern.internalize
  ;; CHECK-NEXT:    (ref.as_non_null
  ;; CHECK-NEXT:     (local.get $y)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $extern.externalize (export "ext") (param $x (ref null any)) (param $y (ref null extern))
    ;; We should not change anything here, and also not hit an internal error.
    (drop
      (extern.externalize
        (local.get $x)
      )
    )
    (drop
      (extern.externalize
        (ref.as_non_null
          (local.get $x)
        )
      )
    )
    (drop
      (extern.internalize
        (local.get $y)
      )
    )
    (drop
      (extern.internalize
        (ref.as_non_null
          (local.get $y)
        )
      )
    )
  )
)
