;; RUN: wasm-split %s -all -g -o1 %t.1.wasm -o2 %t.2.wasm --keep-funcs=keep
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY

;; Check that transitive dependencies in global initializers are correctly
;; analyzed and moved to the secondary module.

(module
  ;; SECONDARY:      (global $c i32 (i32.const 42))
  (global $c i32 (i32.const 42))

  ;; $b depends on $c.
  ;; SECONDARY:      (global $b i32 (global.get $c))
  (global $b i32 (global.get $c))

  ;; $a depends on $b. since $a is exclusively used by the secondary module,
  ;; it will be moved there. The transitive dependency must ensure that $b (and
  ;; $c) are moved to the secondary module too, because they are not used in the
  ;; primary module.
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
