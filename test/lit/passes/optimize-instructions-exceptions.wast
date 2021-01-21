;; NOTE: Assertions have been generated by update_lit_checks.py
;; RUN: wasm-opt %s --optimize-instructions --enable-reference-types \
;; RUN:   --enable-exception-handling -S -o - | filecheck %s

(module
 ;; CHECK: (func $test
 ;; CHECK:  (if
 ;; CHECK:   (try (result i32)
 ;; CHECK:    (do
 ;; CHECK:     (i32.const 123)
 ;; CHECK:    )
 ;; CHECK:    (catch_all
 ;; CHECK:     (i32.const 456)
 ;; CHECK:    )
 ;; CHECK:   )
 ;; CHECK:   (nop)
 ;; CHECK:  )
 ;; CHECK: )
  (func $test
    (if
      (try (result i32)
        (do
          (i32.eqz
            (i32.eqz
              (i32.const 123)
            )
          )
        )
        (catch_all
          (i32.eqz
            (i32.eqz
              (i32.const 456)
            )
          )
        )
      )
      (nop)
    )
  )
)
