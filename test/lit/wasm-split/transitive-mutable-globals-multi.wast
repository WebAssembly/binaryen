;; RUN: wasm-split -all -g --multi-split %s --manifest %S/transitive-globals-multi.wast.manifest --out-prefix=%t -o %t.wasm
;; RUN: wasm-dis -all %t.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis -all %t1.wasm | filecheck %s --check-prefix SECONDARY1
;; RUN: wasm-dis -all %t2.wasm | filecheck %s --check-prefix SECONDARY2

;; Because global $e is used in both module1 ($split1) and module2 ($split2), $e
;; will be exported / imported, but we don't need to export $f.

(module
  (global $f i32 (i32.const 42))
  (global $e (mut i32) (global.get $f))

  (func $keep
    (nop)
  )

  (func $split1
    (drop (global.get $e))
  )

  (func $split2
    (drop (global.get $e))
  )
)

;; PRIMARY:      (module
;; PRIMARY-NEXT:  (type $0 (func))
;; PRIMARY-NEXT:  (global $f i32 (i32.const 42))
;; PRIMARY-NEXT:  (global $e (mut i32) (global.get $f))
;; PRIMARY-NEXT:  (export "global" (global $e))
;; PRIMARY-NEXT:  (func $keep (type $0)
;; PRIMARY-NEXT:   (nop)
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT: )

;; SECONDARY1:      (module
;; SECONDARY1-NEXT:  (type $0 (func))
;; SECONDARY1-NEXT:  (import "primary" "global" (global $e (mut i32)))
;; SECONDARY1-NEXT:  (func $split1 (type $0)
;; SECONDARY1-NEXT:   (drop
;; SECONDARY1-NEXT:    (global.get $e)
;; SECONDARY1-NEXT:   )
;; SECONDARY1-NEXT:  )
;; SECONDARY1-NEXT: )

;; SECONDARY2:      (module
;; SECONDARY2-NEXT:  (type $0 (func))
;; SECONDARY2-NEXT:  (import "primary" "global" (global $e (mut i32)))
;; SECONDARY2-NEXT:  (func $split2 (type $0)
;; SECONDARY2-NEXT:   (drop
;; SECONDARY2-NEXT:    (global.get $e)
;; SECONDARY2-NEXT:   )
;; SECONDARY2-NEXT:  )
;; SECONDARY2-NEXT: )
