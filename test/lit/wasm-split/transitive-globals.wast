;; RUN: wasm-split %s -all -g -o1 %t.1.wasm -o2 %t.2.wasm --keep-funcs=keep
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY

;; Check that transitive dependencies in global initializers are correctly
;; analyzed and moved to the secondary module.

(module
  ;; There are two dependency chains: $a->$b->$c and $d->$e->$f. While all of
  ;; $a, $b, and $c can be moved to the secondary module because all f them are
  ;; used only there, $e is used in the primary module, preventing $e and $f
  ;; from being moved to the secondary module.

  (global $c i32 (i32.const 42))
  (global $b i32 (global.get $c))
  (global $a i32 (global.get $b))

  (global $f i32 (i32.const 42))
  (global $e i32 (global.get $f))
  (global $d i32 (global.get $e))

  ;; PRIMARY:      (global $f i32 (i32.const 42))
  ;; PRIMARY:      (global $e i32 (global.get $f))

  ;; PRIMARY:      (export "global" (global $f))
  ;; PRIMARY:      (export "global_1" (global $e))

  ;; SECONDARY:      (import "primary" "global" (global $f i32))
  ;; SECONDARY:      (import "primary" "global_1" (global $e i32))

  ;; SECONDARY:      (global $c i32 (i32.const 42))
  ;; SECONDARY:      (global $b i32 (global.get $c))
  ;; SECONDARY:      (global $a i32 (global.get $b))

  ;; SECONDARY:      (global $d i32 (global.get $e))

  ;; PRIMARY:      (func $keep
  ;; PRIMARY-NEXT:  (drop
  ;; PRIMARY-NEXT:   (global.get $e)
  ;; PRIMARY-NEXT:  )
  ;; PRIMARY-NEXT: )
  (func $keep
    (drop
      (global.get $e)
    )
  )

  ;; Exclusively uses $a and $d, causing them to move to the secondary module
  ;; SECONDARY:      (func $split
  ;; SECONDARY-NEXT:  (drop
  ;; SECONDARY-NEXT:   (global.get $a)
  ;; SECONDARY-NEXT:  )
  ;; SECONDARY-NEXT:  (drop
  ;; SECONDARY-NEXT:   (global.get $d)
  ;; SECONDARY-NEXT:  )
  ;; SECONDARY-NEXT: )
  (func $split
    (drop
      (global.get $a)
    )
    (drop
      (global.get $d)
    )
  )
)
