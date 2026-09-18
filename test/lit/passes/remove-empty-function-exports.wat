;; RUN: wasm-opt %s --all-features --remove-empty-function-exports -S -o - | filecheck %s --check-prefix=REMOVE

(module
  (import "env" "noop" (func $imported))

  (func $empty)
  (func $empty-block (block))
  (func $empty-param (param i32) (nop))
  (func $empty-used)
  (func $call-empty
    (call $empty-used)
  )
  (func $nonempty
    (drop
      (i32.const 0)
    )
  )
  (func $returns (return))

  (memory $memory 1)
  (table $table 1 funcref)
  (global $global i32 (i32.const 0))
  (tag $tag)
  (start $nonempty)

  (export "empty" (func $empty))
  (export "empty-alias" (func $empty))
  (export "empty-block" (func $empty-block))
  (export "empty-param" (func $empty-param))
  (export "empty-used" (func $empty-used))
  (export "call-empty" (func $call-empty))
  (export "nonempty" (func $nonempty))
  (export "imported" (func $imported))
  (export "returns" (func $returns))
  (export "memory" (memory $memory))
  (export "table" (table $table))
  (export "global" (global $global))
  (export "tag" (tag $tag))
)

;; REMOVE-NOT:   (export "empty
;; REMOVE:       (export "call-empty" (func $call-empty))
;; REMOVE-NEXT:  (export "nonempty" (func $nonempty))
;; REMOVE-NEXT:  (export "imported" (func $imported))
;; REMOVE-NEXT:  (export "returns" (func $returns))
;; REMOVE-NEXT:  (export "memory" (memory $memory))
;; REMOVE-NEXT:  (export "table" (table $table))
;; REMOVE-NEXT:  (export "global" (global $global))
;; REMOVE-NEXT:  (export "tag" (tag $tag))
;; REMOVE-NOT:   (export
;; REMOVE:       (start $nonempty)
;; REMOVE:       (func $empty (type
;; REMOVE:       (func $empty-block
;; REMOVE:       (func $empty-param
;; REMOVE:       (func $empty-used
