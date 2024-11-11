;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --pick-load-signs -all -S -o - | filecheck %s

(module
 (memory $0 16 17 shared)

 (func $load (result i32)
  (local $temp i32)
  ;; The load here is unsigned, while the value in the local is used in two
  ;; ways: it is sign-extended, and it is sent on a branch by a br_if. We must
  ;; not ignore the branch, as if we did then we'd think the only use is signed,
  ;; and we'd optimize load8_u => load8_s.
  (block $label (result i32)
   (local.set $temp
    (i32.load8_u
     (i32.const 22)
    )
   )
   (drop
    (i32.extend8_s
     (br_if $label
      (local.get $temp)
      (i32.const 1)
     )
    )
   )
   (unreachable)
  )
 )
)

