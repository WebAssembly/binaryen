;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --coalesce-locals -all -S -o - | filecheck %s

(module
  ;; CHECK:      (func $bar (result i32)
  ;; CHECK-NEXT:  (i32.const 1984)
  ;; CHECK-NEXT: )
  (func $bar (result i32)
    (i32.const 1984)
  )

 (event $e (attr 0))
  ;; CHECK:      (func $bug-cfg-traversal (param $0 i32) (result i32)
  ;; CHECK-NEXT:  (try $try
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (local.set $0
  ;; CHECK-NEXT:     (call $bar)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch_all
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.get $0)
  ;; CHECK-NEXT: )
  (func $bug-cfg-traversal (param $0 i32) (result i32)
    (local $x i32)
    ;; This is a regrssion test case for a bug in cfg-traversal for EH.
    ;; See https://github.com/WebAssembly/binaryen/pull/3594
    (try
      (do
        (local.set $x
          ;; the call may or may not throw, so we may reach the get of $x
          (call $bar)
        )
      )
      (catch_all
        (unreachable)
      )
    )
    (local.get $x)
  )
)
