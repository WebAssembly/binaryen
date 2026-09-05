;; RUN: wasm-opt %s --remove-unused-module-elements -S -o - | filecheck %s --check-prefix=DEFAULT
;; RUN: wasm-opt %s --remove-unused-module-elements --pass-arg=remove-unused-module-elements-consider-empty-exports-unused -S -o - | filecheck %s --check-prefix=OPTION

(module
  (import "env" "noop" (func $imported))

  (func $empty)
  (func $empty-used)
  (func $call-empty
    (call $empty-used)
  )
  (func $nonempty
    (drop
      (i32.const 0)
    )
  )

  (export "empty" (func $empty))
  (export "empty-used" (func $empty-used))
  (export "call-empty" (func $call-empty))
  (export "nonempty" (func $nonempty))
  (export "imported" (func $imported))
)

;; DEFAULT:      (export "empty" (func $empty))
;; DEFAULT-NEXT: (export "empty-used" (func $empty-used))
;; DEFAULT:      (func $empty
;; DEFAULT:      (func $empty-used

;; OPTION-NOT:   (export "empty"
;; OPTION-NOT:   (export "empty-used"
;; OPTION:       (export "call-empty" (func $call-empty))
;; OPTION-NEXT:  (export "nonempty" (func $nonempty))
;; OPTION-NEXT:  (export "imported" (func $imported))
;; OPTION-NOT:   (func $empty{{[[:space:]]*$}}
;; OPTION:       (func $empty-used
