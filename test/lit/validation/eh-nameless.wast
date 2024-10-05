;; Test for a nameless block containing a pop, which is allowed.

;; XXXXXXXXXXXXXXX RUN: not wasm-opt --enable-reference-types %s -o - -S 2>&1 | filecheck %s --check-prefix NO-GC
;; RUN:     wasm-opt --enable-reference-types --enable-gc %s -o - -S | filecheck %s --check-prefix GC

;; NO-GC: all used types should be allowed

;; GC:   (func $foo (type $0) (param $x eqref)

(module
 (tag $tag (param i32))

 (func $0
  (try
   (do
    (nop)
   )
   (catch $tag
    (drop
     (block (result i32)
      (pop i32)
     )
    )
   )
  )
 )
)

;; TODO: test two nested blocks
