;; RUN: wasm-split %s -all -g -o1 %t.1.wasm -o2 %t.2.wasm --split-funcs=split1,split2
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY

;; Global $g1 is used (exported) in the primary module so it can't move, and
;; global $g2 is only used in the secondary module so it will move there.

(module
  (global $g1 funcref (ref.func $split1))
  (global $g2 funcref (ref.func $split2))
  (export "g1" (global $g1))

  (func $split1
    (unreachable)
  )

  (func $split2
    (drop
      (global.get $g2)
    )
  )
)

;; PRIMARY-NEXT: (module
;; PRIMARY-NEXT:  (type $0 (func))
;; PRIMARY-NEXT:  (import "placeholder.deferred" "0" (func $placeholder_0))
;; PRIMARY-NEXT:  (import "placeholder.deferred" "1" (func $placeholder_1))
;; PRIMARY-NEXT:  (global $g1 funcref (ref.func $trampoline_split1))
;; PRIMARY-NEXT:  (table $0 2 funcref)
;; PRIMARY-NEXT:  (elem $0 (i32.const 0) $placeholder_0 $placeholder_1)
;; PRIMARY-NEXT:  (export "g1" (global $g1))
;; PRIMARY-NEXT:  (export "table" (table $0))
;; PRIMARY-NEXT:  (func $trampoline_split1
;; PRIMARY-NEXT:   (call_indirect (type $0)
;; PRIMARY-NEXT:    (i32.const 0)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT: )

;; SECONDARY-NEXT: (module
;; SECONDARY-NEXT:  (type $0 (func))
;; SECONDARY-NEXT:  (import "primary" "table" (table $timport$0 2 funcref))
;; SECONDARY-NEXT:  (global $g2 funcref (ref.func $split2))
;; SECONDARY-NEXT:  (elem $0 (i32.const 0) $split1 $split2)
;; SECONDARY-NEXT:  (func $split1
;; SECONDARY-NEXT:   (unreachable)
;; SECONDARY-NEXT:  )
;; SECONDARY-NEXT:  (func $split2
;; SECONDARY-NEXT:   (drop
;; SECONDARY-NEXT:    (global.get $g2)
;; SECONDARY-NEXT:   )
;; SECONDARY-NEXT:  )
;; SECONDARY-NEXT: )
