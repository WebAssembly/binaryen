;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt -all --string-lifting -S -o - | filecheck %s

(module
  (import "\'" "foo" (global $string1 (ref extern)))
  (import "\'" "bar" (global $string1 (ref extern)))

  (func $func
    (drop
      (global.get $foo)
    )
    ;; Test multiple uses of the same constant.
    (drop
      (global.get $bar)
    )
    (drop
      (global.get $bar)
    )
  )
)
