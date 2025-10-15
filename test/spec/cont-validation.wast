;; Part of stack-switching/validation.wast

;; Illegal casts

(assert_invalid
  (module
    (func (drop (ref.test contref (unreachable))))
  )
  "invalid cast"
)
(assert_invalid
  (module
    (func (drop (ref.test nullcontref (unreachable))))
  )
  "invalid cast"
)
(assert_invalid
  (module
    (type $f (func))
    (type $c (cont $f))
    (func (drop (ref.test (ref $c) (unreachable))))
  )
  "invalid cast"
)

