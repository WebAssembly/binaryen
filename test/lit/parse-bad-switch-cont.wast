;; RUN: not wasm-opt %s -all 2>&1 | filecheck %s
;; RUN: not wasm-shell %s 2>&1 | filecheck %s

;; Check that we error properly when the last parameter of a switch continuation
;; is not a continuation type.

(module
  (type $ft (func (param i32)))
  (type $ct (cont $ft))
  (tag $t)

  ;; CHECK: 14:5: error: expected continuation type for last parameter of switch continuation
  (func $f (param $k (ref $ct))
    (switch $ct $t
      (local.get $k)
    )
  )
)
