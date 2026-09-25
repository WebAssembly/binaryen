;; RUN: wasm-split %s -all -g -o1 %t.1.wasm -o2 %t.2.wasm --keep-funcs=keep
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY

;; Check that transitive dependencies in global initializers are correctly
;; analyzed and copied to the secondary module.

(module
  ;; There are two dependency chains: $a->$b->$c and $d->$e->$f. Because these
  ;; are immutable globals, globals are copied to whichever module they are
  ;; used. The secondary module uses $a and $d, so it will have all globals
  ;; copied to it. The primary module only uses $e, so it will have $e and its
  ;; dependency $f.

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
;; PRIMARY-NEXT:  (func $keep
;; PRIMARY-NEXT:   (drop
;; PRIMARY-NEXT:    (global.get $e)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT: )

;; SECONDARY:      (module
;; SECONDARY-NEXT:  (type $0 (func))
;; SECONDARY-NEXT:  (global $c i32 (i32.const 42))
;; SECONDARY-NEXT:  (global $b i32 (global.get $c))
;; SECONDARY-NEXT:  (global $a i32 (global.get $b))
;; SECONDARY-NEXT:  (global $f i32 (i32.const 42))
;; SECONDARY-NEXT:  (global $e i32 (global.get $f))
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
