;; RUN: wasm-split %s -all -g -o1 %t.1.wasm -o2 %t.2.wasm --keep-funcs=keep
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY

;; Check that transitive dependencies in global initializers are correctly
;; analyzed and exported from the primary module to the secondary module.
;; TODO Move $b and $c to the secondary module

(module
  ;; PRIMARY:      (global $c i32 (i32.const 42))
  (global $c i32 (i32.const 42))

  ;; $b depends on $c.
  ;; PRIMARY:      (global $b i32 (global.get $c))
  (global $b i32 (global.get $c))

  ;; Globals $b is exported to the secondary module
  ;; PRIMARY:      (export "global" (global $b))

  ;; Globals $b is imported from the primary module
  ;; SECONDARY:      (import "primary" "global" (global $b i32))

  ;; $a depends on $b. Since $a is exclusively used by the secondary module,
  ;; it will be moved there. Its dependency $b should be exported from the
  ;; primary module and imported into the secondary module.
  ;; SECONDARY:      (global $a i32 (global.get $b))
  (global $a i32 (global.get $b))

  ;; PRIMARY:      (func $keep (result i32)
  ;; PRIMARY-NEXT:  (i32.const 0)
  ;; PRIMARY-NEXT: )
  (func $keep (result i32)
    (i32.const 0)
  )

  ;; Exclusively uses $a, causing $a to move to the secondary module
  ;; SECONDARY:      (func $split (result i32)
  ;; SECONDARY-NEXT:  (global.get $a)
  ;; SECONDARY-NEXT: )
  (func $split (result i32)
    (global.get $a)
  )
)
