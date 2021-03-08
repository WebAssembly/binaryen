;; Test that types can be used before they are defined

;; RUN: wasm-opt %s -all -S -o - | filecheck %s

;; CHECK: (type $func (func))
;; CHECK: (type $none_=>_ref?|$struct| (func (result (ref null $struct))))
;; CHECK: (type $struct (struct (field (ref null $array)) (field (ref null $func))))
;; CHECK: (type $array (array (rtt 2 $func)))

(module
  (type $struct (struct
    (field (ref $array))
    (field (ref null $func))
  ))
  (type $array (array (field (rtt 2 $func))))
  (type $func (func))

  (func (result (ref null $struct))
    (unreachable)
  )
)
