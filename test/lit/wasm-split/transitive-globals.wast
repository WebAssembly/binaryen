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

  ;; This dead global is referring to a global ($a) that's moved to the
  ;; secondary module. This should be deleted.
  (global $dead i32 (global.get $a))

  (func $keep
    (drop
      (global.get $e)
    )
  )

  ;; Exclusively uses $a and $d, causing them to move to the secondary module
  (func $split
    (drop
      (global.get $a)
    )
    (drop
      (global.get $d)
    )
  )
)

;; PRIMARY:      (module
;; PRIMARY-NEXT:  (type $0 (func))
;; PRIMARY-NEXT:  (global $f i32 (i32.const 42))
;; PRIMARY-NEXT:  (global $e i32 (global.get $f))
;; PRIMARY-NEXT:  (export "global" (global $e))
;; PRIMARY-NEXT:  (func $keep
;; PRIMARY-NEXT:   (drop
;; PRIMARY-NEXT:    (global.get $e)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT: )

;; SECONDARY:      (module
;; SECONDARY-NEXT:  (type $0 (func))
;; SECONDARY-NEXT:  (import "primary" "global" (global $e i32))
;; SECONDARY-NEXT:  (global $c i32 (i32.const 42))
;; SECONDARY-NEXT:  (global $b i32 (global.get $c))
;; SECONDARY-NEXT:  (global $a i32 (global.get $b))
;; SECONDARY-NEXT:  (global $d i32 (global.get $e))
;; SECONDARY-NEXT:  (func $split
;; SECONDARY-NEXT:   (drop
;; SECONDARY-NEXT:    (global.get $a)
;; SECONDARY-NEXT:   )
;; SECONDARY-NEXT:   (drop
;; SECONDARY-NEXT:    (global.get $d)
;; SECONDARY-NEXT:   )
;; SECONDARY-NEXT:  )
;; SECONDARY-NEXT: )
