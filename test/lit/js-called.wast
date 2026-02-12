;; RUN: wasm-opt -all             %s -S -o - | filecheck %s
;; RUN: wasm-opt -all --roundtrip %s -S -o - | filecheck %s

;; Test text and binary handling of @binaryen.js.called.

(module
  (@binaryen.js.called)
  (func $func-annotation
    (drop
      (i32.const 0)
    )
  )
)

;; CHECK: (module
;; CHECK-NEXT:  (type $0 (func))
;; CHECK-NEXT:  (@binaryen.js.called)
;; CHECK-NEXT:  (func $func-annotation
;; CHECK-NEXT:   (drop
;; CHECK-NEXT:    (i32.const 0)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

