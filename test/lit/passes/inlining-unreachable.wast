;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt --inlining -S -o - | filecheck %s

;; Test that we inline functions with unreachable bodies. This is important to
;; propagate the trap to the caller (where it might lead to DCE).

(module
  (func $trap
    (unreachable)
  )
  (func $call-trap
    (call $trap)
  )

  (func $trap-result (result i32)
    ;; As above, but now there is a declared result.
    (unreachable)
  )

  (func $call-trap-result (result i32)
    (call $trap-result)
  )

  (func $contents-then-trap
    ;; Add some contents in addition to the trap.
    (nop)
    (drop
      (i32.const 1337)
    )
    (nop)
    (unreachable)
  )
  (func $call-contents-then-trap
    (call $contents-then-trap)
  )
)
