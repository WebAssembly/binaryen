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

(assert_invalid
  (module
    (func (drop (ref.cast contref (unreachable))))
  )
  "invalid cast"
)
(assert_invalid
  (module
    (func (drop (ref.cast nullcontref (unreachable))))
  )
  "invalid cast"
)
(assert_invalid
  (module
    (type $f (func))
    (type $c (cont $f))
    (func (drop (ref.cast (ref $c) (unreachable))))
  )
  "invalid cast"
)

(assert_invalid
  (module
    (func
      (block (result contref) (br_on_cast 0 contref contref (unreachable)))
      (drop)
    )
  )
  "invalid cast"
)
(assert_invalid
  (module
    (func
      (block (result contref) (br_on_cast 0 nullcontref nullcontref (unreachable)))
      (drop)
    )
  )
  "invalid cast"
)
(assert_invalid
  (module
    (type $f (func))
    (type $c (cont $f))
    (func
      (block (result contref) (br_on_cast 0 (ref $c) (ref $c) (unreachable)))
      (drop)
    )
  )
  "invalid cast"
)

(assert_invalid
  (module
    (func
      (block (result contref) (br_on_cast_fail 0 contref contref (unreachable)))
      (drop)
    )
  )
  "invalid cast"
)
(assert_invalid
  (module
    (func
      (block (result contref) (br_on_cast_fail 0 nullcontref nullcontref (unreachable)))
      (drop)
    )
  )
  "invalid cast"
)
(assert_invalid
  (module
    (type $f (func))
    (type $c (cont $f))
    (func
      (block (result contref) (br_on_cast_fail 0 (ref $c) (ref $c) (unreachable)))
      (drop)
    )
  )
  "invalid cast"
)
