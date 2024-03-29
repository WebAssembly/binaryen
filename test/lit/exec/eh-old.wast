;; NOTE: Assertions have been generated by update_lit_checks.py --output=fuzz-exec and should not be edited.

;; RUN: wasm-opt %s -all --fuzz-exec -q -o /dev/null 2>&1 | filecheck %s

(module
  (tag $e-i32 (param i32))

  ;; CHECK:      [fuzz-exec] calling throw
  ;; CHECK-NEXT: [exception thrown: e-i32 1]
  (func $throw (export "throw")
    (throw $e-i32 (i32.const 1))
  )

  ;; CHECK:      [fuzz-exec] calling try-catch
  (func $try-catch (export "try-catch")
    (try
      (do
        (throw $e-i32 (i32.const 2))
      )
      (catch $e-i32
        (drop (pop i32))
      )
    )
  )

  ;; CHECK:      [fuzz-exec] calling catchless-try
  ;; CHECK-NEXT: [exception thrown: e-i32 3]
  (func $catchless-try (export "catchless-try")
    (try
      (do
        (throw $e-i32 (i32.const 3))
      )
    )
  )

  ;; CHECK:      [fuzz-exec] calling try-delegate
  ;; CHECK-NEXT: [exception thrown: e-i32 4]
  (func $try-delegate (export "try-delegate")
    (try $l0
      (do
        (try
          (do
            (throw $e-i32 (i32.const 4))
          )
          (delegate $l0)
        )
      )
    )
  )
)
;; CHECK:      [fuzz-exec] calling throw
;; CHECK-NEXT: [exception thrown: e-i32 1]

;; CHECK:      [fuzz-exec] calling try-catch

;; CHECK:      [fuzz-exec] calling catchless-try
;; CHECK-NEXT: [exception thrown: e-i32 3]

;; CHECK:      [fuzz-exec] calling try-delegate
;; CHECK-NEXT: [exception thrown: e-i32 4]
;; CHECK-NEXT: [fuzz-exec] comparing catchless-try
;; CHECK-NEXT: [fuzz-exec] comparing throw
;; CHECK-NEXT: [fuzz-exec] comparing try-catch
;; CHECK-NEXT: [fuzz-exec] comparing try-delegate
