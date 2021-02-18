;; Test that types can be used before they are defined

;; RUN: wasm-opt %s -all -S -o - | filecheck %s

;; CHECK: (type $none_=>_none (func))
;; CHECK: (type $[rtt_2_$none_=>_none] (array (rtt 2 $none_=>_none)))
;; CHECK: (type ${ref?|[rtt_2_$none_=>_none]|_ref?|none_->_none|} (struct (field (ref null $[rtt_2_$none_=>_none])) (field (ref null $none_=>_none))))
;; CHECK: (type $none_=>_ref?|{ref?|[rtt_2_$none_=>_none]|_ref?|none_->_none|}| (func (result (ref null ${ref?|[rtt_2_$none_=>_none]|_ref?|none_->_none|}))))

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
