;; RUN: wasm-opt %s -all --nominal -S -o - | filecheck %s
;; RUN: wasm-opt %s -all --nominal --roundtrip -S -o - | filecheck %s

;; Check that intermediate types in subtype chains are also included in the
;; output module, even if there are no other references to those intermediate
;; types.

(module

  ;; CHECK:      (type $root (struct ))
  ;; CHECK-NEXT: (type $none_=>_ref?|$root| (func (result (ref null $root))))
  ;; CHECK-NEXT: (type $leaf (struct (field i32) (field i64) (field f32) (field f64)) (extends $twig))
  ;; CHECK-NEXT: (type $twig (struct (field i32) (field i64) (field f32)) (extends $branch))
  ;; CHECK-NEXT: (type $branch (struct (field i32) (field i64)) (extends $trunk))
  ;; CHECK-NEXT: (type $trunk (struct (field i32)) (extends $root))

  (type $leaf (struct i32 i64 f32 f64) (extends $twig))
  (type $twig (struct i32 i64 f32) (extends $branch))
  (type $branch (struct i32 i64) (extends $trunk))
  (type $trunk (struct i32) (extends $root))
  (type $root (struct))

  (func $make-root (result (ref null $root))
    (ref.null $leaf)
  )
)