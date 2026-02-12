;; RUN: wasm-opt -all --strip-toolchain-annotations %s -S -o - | filecheck %s

(module
  (@metadata.code.inline "\00")
  (func $test-func-a
    ;; This VM annotation is kept.
  )

  (@binaryen.removable.if.unused)
  (func $test-func-b
    ;; Toolchain one is removed.
  )

  (@metadata.code.inline "\00")
  (@binaryen.removable.if.unused)
  (func $test-func-c
    ;; Toolchain one is removed, VM one is kept.
  )

  (@binaryen.removable.if.unused)
  (@metadata.code.inline "\00")
  (func $test-func-d
    ;; Reverse order of above.
  )
)

;; CHECK: (module
;; CHECK-NEXT:  (type $0 (func))
;; CHECK-NEXT:  (@metadata.code.inline "\00")
;; CHECK-NEXT:  (func $test-func-a (type $0)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (func $test-func-b (type $0)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (@metadata.code.inline "\00")
;; CHECK-NEXT:  (func $test-func-c (type $0)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (@metadata.code.inline "\00")
;; CHECK-NEXT:  (func $test-func-d (type $0)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

