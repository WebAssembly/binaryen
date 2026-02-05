;; RUN: wasm-opt -all             %s -S -o - | filecheck %s
;; RUN: wasm-opt -all --roundtrip %s -S -o - | filecheck %s

(module
  (@binaryen.dead.if.unused)
  (func $func-annotation
    ;; The annotation here is on the function.
    (drop
      (i32.const 0)
    )
  )
)

;; CHECK: (module
;; CHECK-NEXT:  (type $0 (func))
;; CHECK-NEXT:  (@binaryen.dead.if.unused)
;; CHECK-NEXT:  (func $func-annotation
;; CHECK-NEXT:   (drop
;; CHECK-NEXT:    (i32.const 0)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

