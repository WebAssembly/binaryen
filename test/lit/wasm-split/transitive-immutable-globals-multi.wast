;; RUN: wasm-split -all -g --multi-split %s --manifest %S/transitive-globals-multi.wast.manifest --out-prefix=%t -o %t.wasm
;; RUN: wasm-dis -all %t.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis -all %t1.wasm | filecheck %s --check-prefix SECONDARY1
;; RUN: wasm-dis -all %t2.wasm | filecheck %s --check-prefix SECONDARY2

;; In case of non-generative immutable globals, they are copied to whichever
;; modules they are used. $e will be copied to both module1 ($split1) and
;; module2 ($split2), and this will also cause $f to be copied to both modules.
;; However, generative immutable globals ($gen) cannot be copied, so $gen and
;; its dependency $gen-dep stay in the primary module, and only $gen is
;; exported/imported.

(module
  (type $struct (struct (field i32)))

  (global $f i32 (i32.const 42))
  (global $e i32 (global.get $f))

  (global $gen-dep i32 (i32.const 10))
  (global $gen (ref $struct) (struct.new $struct (global.get $gen-dep)))

  (func $keep
    (nop)
  )

  (func $split1
    (drop (global.get $e))
    (drop (global.get $gen))
  )

  (func $split2
    (drop (global.get $e))
    (drop (global.get $gen))
  )
)

;; PRIMARY:      (module
;; PRIMARY-NEXT:  (type $struct (struct (field i32)))
;; PRIMARY-NEXT:  (type $1 (func))
;; PRIMARY-NEXT:  (global $gen-dep i32 (i32.const 10))
;; PRIMARY-NEXT:  (global $gen (ref $struct) (struct.new $struct
;; PRIMARY-NEXT:   (global.get $gen-dep)
;; PRIMARY-NEXT:  ))
;; PRIMARY-NEXT:  (export "global" (global $gen))
;; PRIMARY-NEXT:  (func $keep (type $1)
;; PRIMARY-NEXT:   (nop)
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT: )

;; SECONDARY1:      (module
;; SECONDARY1-NEXT:  (type $0 (struct (field i32)))
;; SECONDARY1-NEXT:  (type $1 (func))
;; SECONDARY1-NEXT:  (import "primary" "global" (global $gen (ref $0)))
;; SECONDARY1-NEXT:  (global $f i32 (i32.const 42))
;; SECONDARY1-NEXT:  (global $e i32 (global.get $f))
;; SECONDARY1-NEXT:  (func $split1 (type $1)
;; SECONDARY1-NEXT:   (drop
;; SECONDARY1-NEXT:    (global.get $e)
;; SECONDARY1-NEXT:   )
;; SECONDARY1-NEXT:   (drop
;; SECONDARY1-NEXT:    (global.get $gen)
;; SECONDARY1-NEXT:   )
;; SECONDARY1-NEXT:  )
;; SECONDARY1-NEXT: )

;; SECONDARY2:      (module
;; SECONDARY2-NEXT:  (type $0 (struct (field i32)))
;; SECONDARY2-NEXT:  (type $1 (func))
;; SECONDARY2-NEXT:  (import "primary" "global" (global $gen (ref $0)))
;; SECONDARY2-NEXT:  (global $f i32 (i32.const 42))
;; SECONDARY2-NEXT:  (global $e i32 (global.get $f))
;; SECONDARY2-NEXT:  (func $split2 (type $1)
;; SECONDARY2-NEXT:   (drop
;; SECONDARY2-NEXT:    (global.get $e)
;; SECONDARY2-NEXT:   )
;; SECONDARY2-NEXT:   (drop
;; SECONDARY2-NEXT:    (global.get $gen)
;; SECONDARY2-NEXT:   )
;; SECONDARY2-NEXT:  )
;; SECONDARY2-NEXT: )
