;; Test that incorrect nominal types result in the expected parse errors

;; RUN: foreach %s %t not wasm-opt -all 2>&1 | filecheck %s

;; CHECK: [parse exception: unknown supertype (at 2:35)]
(module
  (type $bad-func (func) (extends $bad))
)

;; CHECK: [parse exception: unknown supertype (at 2:39)]
(module
  (type $bad-struct (struct) (extends $bad))
)

;; CHECK: [parse exception: unknown supertype (at 2:41)]
(module
  (type $bad-array (array i32) (extends $bad))
)

;; CHECK: [parse exception: unknown supertype (at 2:33)]
(module
  (type $bad-func (func_subtype $bad))
)

;; CHECK: [parse exception: unknown supertype (at 2:37)]
(module
  (type $bad-struct (struct_subtype $bad))
)

;; CHECK: [parse exception: unknown supertype (at 2:39)]
(module
  (type $bad-array (array_subtype i32 $bad))
)

;; CHECK: [parse exception: unknown supertype (at 2:32)]
(module
  (type $bad-func (func_subtype any))
)

;; CHECK: [parse exception: unknown supertype (at 2:36)]
(module
  (type $bad-struct (struct_subtype any))
)

;; CHECK: [parse exception: unknown supertype (at 2:38)]
(module
  (type $bad-array (array_subtype i32 any))
)

;; CHECK: [parse exception: unknown supertype (at 2:32)]
(module
  (type $bad-func (func_subtype data))
)

;; CHECK: [parse exception: unknown supertype (at 2:36)]
(module
  (type $bad-struct (struct_subtype func))
)

;; CHECK: [parse exception: unknown supertype (at 2:38)]
(module
  (type $bad-array (array_subtype i32 func))
)
