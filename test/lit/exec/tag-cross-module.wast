;; RUN: wasm-opt %s -all --fuzz-exec-before --fuzz-exec-second=%s.second -q -o /dev/null 2>&1 | filecheck %s

;; Define a tag in this module, and another tag in the secondary module, with
;; the same name but different (incompatible) contents. The second module will
;; call our export, and when we throw our tag, it should not catch it.

(module
 (tag $tag (param structref))

 (func $func (export "func") (result i32)
  (throw $tag
   (ref.null struct)
  )
 )
)

;; CHECK: [fuzz-exec] calling func
;; CHECK-NEXT: [exception thrown: tag nullref]
;; CHECK-NEXT: [fuzz-exec] calling func2
;; CHECK-NEXT: [exception thrown: tag nullref]

