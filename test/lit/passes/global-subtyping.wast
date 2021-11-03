;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt --nominal --global-subtyping -all -S -o - | filecheck %s

(module
  ;; A struct with three fields. The first will have no writes, the second one
  ;; write of the same type, and the last a write of a subtype, which will allow
  ;; us to specialize that one.
  (type $struct (struct (field (mut anyref)) (field (mut anyref)) (field (mut anyref))))

  (func $work (param $x (ref $struct))
    (struct.set $struct 1
      (ref.null any)
    )
    (struct.set $struct 2
      (ref.func $work)
    )
  )
)
