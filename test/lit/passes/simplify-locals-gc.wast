;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --simplify-locals -all -S -o - \
;; RUN:   | filecheck %s

(module
  ;; CHECK:      (type $struct (struct (field (mut i32))))
  (type $struct (struct (field (mut i32))))

  ;; Writes to heap objects cannot be reordered with reads.
  ;; CHECK:      (func $no-reorder-past-write (param $x (ref $struct)) (result i32)
  ;; CHECK-NEXT:  (local $temp i32)
  ;; CHECK-NEXT:  (local.set $temp
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (struct.set $struct 0
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:   (i32.const 42)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.get $temp)
  ;; CHECK-NEXT: )
  (func $no-reorder-past-write (param $x (ref $struct)) (result i32)
    (local $temp i32)
    (local.set $temp
      (struct.get $struct 0
        (local.get $x)
      )
    )
    (struct.set $struct 0
      (local.get $x)
      (i32.const 42)
    )
    (local.get $temp)
  )

  ;; CHECK:      (func $no-block-values-if-br_on
  ;; CHECK-NEXT:  (local $temp anyref)
  ;; CHECK-NEXT:  (block $block
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (br_on_null $block
  ;; CHECK-NEXT:     (ref.null any)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (local.set $temp
  ;; CHECK-NEXT:    (ref.null any)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (br $block)
  ;; CHECK-NEXT:   (local.set $temp
  ;; CHECK-NEXT:    (ref.null any)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.as_non_null
  ;; CHECK-NEXT:    (local.get $temp)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $no-block-values-if-br_on
   (local $temp (ref null any))
   (block $block
    (drop
     ;; This br_on should inhibit trying to create a block return value for
     ;; this block. Aside from the br_on, it looks correct, i.e., we have a
     ;; break with a set before it, and a set before the end of the block. Due
     ;; to the br_on's presence, the pass should not do anything to this
     ;; function.
     ;;
     ;; TODO: support br_on in this optimization eventually, but the variable
     ;;       possible return values and sent values make that nontrivial.
     (br_on_null $block
      (ref.null any)
     )
    )
    (local.set $temp
     (ref.null any)
    )
    (br $block)
    (local.set $temp
     (ref.null any)
    )
   )
   ;; Attempt to use the local that the pass will try to move to a block return
   ;; value, to cause the optimization to try to run.
   (drop
    (ref.as_non_null
     (local.get $temp)
    )
   )
  )
)
