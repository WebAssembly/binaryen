;; Shared struct declaration syntax.
(module
  (type (shared (struct)))
  (type (sub final (shared (struct))))
  (rec
    (type (sub final (shared (struct))))
  )

  (global (ref 0) (struct.new 1))
  (global (ref 1) (struct.new 2))
  (global (ref 2) (struct.new 0))
)

;; Shared structs are distinct from non-shared structs.
(assert_invalid
  (module
    (type (shared (struct)))
    (type (struct))

    (global (ref 0) (struct.new 1))
  )
  "type mismatch"
)

(assert_invalid
  (module
    (type (shared (struct)))
    (type (struct))

    (global (ref 1) (struct.new 0))
  )
  "type mismatch"
)

;; Shared structs may not be subtypes of non-shared structs.
(assert_invalid
  (module
    (type (sub (struct)))
    (type (sub 0 (shared (struct))))
  )
  "must match super type"
)

;; Non-shared structs may not be subtypes of shared structs.
(assert_invalid
  (module
    (type (sub (shared (struct))))
    (type (sub 0 (struct)))
  )
  "must match super type"
)

;; Shared structs may not contain non-shared references.
(assert_invalid
  (module
    (type (shared (struct (field anyref))))
  )
  "must contain shared type"
)

;; But they may contain shared references.
(module
  (type (shared (struct (field (ref null (shared any))))))
)

;; Non-shared structs may contain shared references.
(module
  (type (struct (field (ref null (shared any)))))
)

;; Struct instructions work on shared structs.
(module
  (type $i8 (shared (struct (field (mut i8)))))
  (type $i32 (shared (struct (field (mut i32)))))
  (type $unshared (struct (field (mut i8))))

  (func (struct.new $i8 (i32.const 0)) (drop))

  (func (struct.new_default $i8) (drop))

  (func (param (ref null $i8))
    (struct.get_s $i8 0 (local.get 0)) (drop))

  (func (param (ref null $i8))
    (struct.get_u $i8 0 (local.get 0)) (drop))

  (func (param (ref null $i32))
    (struct.get $i32 0 (local.get 0)) (drop))

  (func (param (ref null $i8))
    (struct.set $i8 0 (local.get 0) (i32.const 0)))
)

;; Bottom types can be used as shared structs.
(module
  (type $i8 (shared (struct (field (mut i8)))))
  (func (drop (struct.get_s $i8 0 (ref.null (shared none)))))
  (func (drop (struct.get_u $i8 0 (ref.null (shared none)))))
  (func (struct.set $i8 0 (ref.null (shared none)) (i32.const 0)))
)

;; Check that field-modifying instructions only work on mutable fields.
(assert_invalid
  (module
    (type $s (shared (struct (field (ref (shared any))))))
    (func (param $s (ref $s)) (param $a (ref (shared any))) (result (ref (shared any)))
      (struct.atomic.set seqcst $s 0 (local.get $s) (local.get $a))
    )
  )
  "field is immutable"
)
(assert_invalid
  (module
    (type $s (shared (struct (field i32))))
    (func (param $s (ref $s)) (result i32)
      (struct.atomic.rmw.add seqcst $s 0 (local.get $s) (i32.const 1))
    )
  )
  "field is immutable"
)
(assert_invalid
  (module
    (type $s (shared (struct (field i64))))
    (func (param $s (ref $s)) (result i64)
      (struct.atomic.rmw.sub seqcst $s 0 (local.get $s) (i64.const 1))
    )
  )
  "field is immutable"
)
(assert_invalid
  (module
    (type $s (shared (struct (field i32))))
    (func (param $s (ref $s)) (result i32)
      (struct.atomic.rmw.and acqrel $s 0 (local.get $s) (i32.const 1))
    )
  )
  "field is immutable"
)
(assert_invalid
  (module
    (type $s (shared (struct (field i64))))
    (func (param $s (ref $s)) (result i64)
      (struct.atomic.rmw.or acqrel $s 0 (local.get $s) (i64.const 1))
    )
  )
  "field is immutable"
)
(assert_invalid
  (module
    (type $s (shared (struct (field i32))))
    (func (param $s (ref $s)) (result i32)
      (struct.atomic.rmw.xor seqcst $s 0 (local.get $s) (i32.const 1))
    )
  )
  "field is immutable"
)
(assert_invalid
  (module
    (type $s (shared (struct (field (ref (shared any))))))
    (func (param $s (ref $s)) (param $a (ref (shared any))) (result (ref (shared any)))
      (struct.atomic.rmw.xchg seqcst $s 0 (local.get $s) (local.get $a))
    )
  )
  "field is immutable"
)
(assert_invalid
  (module
    (type $s (shared (struct (field (ref (shared eq))))))
    (func (param $s (ref $s)) (param $e1 (ref (shared eq))) (param $e2 (ref (shared eq))) (result (ref (shared eq)))
      (struct.atomic.rmw.cmpxchg acqrel $s 0 (local.get $s) (local.get $e1) (local.get $e2))
    )
  )
  "field is immutable"
)

;; Exhaustively check `struct.atomic.rmw.*` instructions.
(module
  (type $s (shared (struct
    (field $i8 (mut i8))
    (field $i16 (mut i16))
    (field $i32 (mut i32))
    (field $i64 (mut i64))
    (field $anyref (mut (ref null (shared any))))
    (field $eqref (mut (ref null (shared eq)))))))
  (func (export "struct-atomic-get-i32-seqcst") (param $x (ref null $s)) (result i32)
    local.get $x
    struct.atomic.get seqcst $s $i32)
  (func (export "struct-atomic-get-i64-seqcst") (param $x (ref null $s)) (result i64)
    local.get $x
    struct.atomic.get seqcst $s $i64)
  (func (export "struct-atomic-get-anyref-seqcst") (param $x (ref null $s)) (result (ref null (shared any)))
    local.get $x
    struct.atomic.get seqcst $s $anyref)
  (func (export "struct-atomic-get-i32-acqrel") (param $x (ref null $s)) (result i32)
    local.get $x
    struct.atomic.get acqrel $s $i32)
  (func (export "struct-atomic-get-i64-acqrel") (param $x (ref null $s)) (result i64)
    local.get $x
    struct.atomic.get acqrel $s $i64)
  (func (export "struct-atomic-get-anyref-acqrel") (param $x (ref null $s)) (result (ref null (shared any)))
    local.get $x
    struct.atomic.get acqrel $s $anyref)
  (func (export "struct-atomic-get_s-i8-seqcst") (param $x (ref null $s)) (result i32)
    local.get $x
    struct.atomic.get_s seqcst $s $i8)
  (func (export "struct-atomic-get_s-i16-seqcst") (param $x (ref null $s)) (result i32)
    local.get $x
    struct.atomic.get_s seqcst $s $i16)
  (func (export "struct-atomic-get_s-i8-acqrel") (param $x (ref null $s)) (result i32)
    local.get $x
    struct.atomic.get_s acqrel $s $i8)
  (func (export "struct-atomic-get_s-i16-acqrel") (param $x (ref null $s)) (result i32)
    local.get $x
    struct.atomic.get_s acqrel $s $i16)
  (func (export "struct-atomic-get_u-i8-seqcst") (param $x (ref null $s)) (result i32)
    local.get $x
    struct.atomic.get_u seqcst $s $i8)
  (func (export "struct-atomic-get_u-i16-seqcst") (param $x (ref null $s)) (result i32)
    local.get $x
    struct.atomic.get_u seqcst $s $i16)
  (func (export "struct-atomic-get_u-i8-acqrel") (param $x (ref null $s)) (result i32)
    local.get $x
    struct.atomic.get_u acqrel $s $i8)
  (func (export "struct-atomic-get_u-i16-acqrel") (param $x (ref null $s)) (result i32)
    local.get $x
    struct.atomic.get_u acqrel $s $i16)
  (func (export "struct-atomic-set-i8-seqcst") (param $x (ref null $s)) (param $y i32)
    local.get $x
    local.get $y
    struct.atomic.set seqcst $s $i8)
  (func (export "struct-atomic-set-i16-seqcst") (param $x (ref null $s)) (param $y i32)
    local.get $x
    local.get $y
    struct.atomic.set seqcst $s $i16)
  (func (export "struct-atomic-set-i32-seqcst") (param $x (ref null $s)) (param $y i32)
    local.get $x
    local.get $y
    struct.atomic.set seqcst $s $i32)
  (func (export "struct-atomic-set-i64-seqcst") (param $x (ref null $s)) (param $y i64)
    local.get $x
    local.get $y
    struct.atomic.set seqcst $s $i64)
  (func (export "struct-atomic-set-anyref-seqcst") (param $x (ref null $s)) (param $y (ref null (shared any)))
    local.get $x
    local.get $y
    struct.atomic.set seqcst $s $anyref)
  (func (export "struct-atomic-set-i8-acqrel") (param $x (ref null $s)) (param $y i32)
    local.get $x
    local.get $y
    struct.atomic.set acqrel $s $i8)
  (func (export "struct-atomic-set-i16-acqrel") (param $x (ref null $s)) (param $y i32)
    local.get $x
    local.get $y
    struct.atomic.set acqrel $s $i16)
  (func (export "struct-atomic-set-i32-acqrel") (param $x (ref null $s)) (param $y i32)
    local.get $x
    local.get $y
    struct.atomic.set acqrel $s $i32)
  (func (export "struct-atomic-set-i64-acqrel") (param $x (ref null $s)) (param $y i64)
    local.get $x
    local.get $y
    struct.atomic.set acqrel $s $i64)
  (func (export "struct-atomic-set-anyref-acqrel") (param $x (ref null $s)) (param $y (ref null (shared any)))
    local.get $x
    local.get $y
    struct.atomic.set acqrel $s $anyref)
  (func (export "struct-atomic-rmw.add-i32-seqcst") (param $x (ref null $s)) (param $y i32) (result i32)
    local.get $x
    local.get $y
    struct.atomic.rmw.add seqcst $s $i32)
  (func (export "struct-atomic-rmw.add-i64-seqcst") (param $x (ref null $s)) (param $y i64) (result i64)
    local.get $x
    local.get $y
    struct.atomic.rmw.add seqcst $s $i64)
  (func (export "struct-atomic-rmw.add-i32-acqrel") (param $x (ref null $s)) (param $y i32) (result i32)
    local.get $x
    local.get $y
    struct.atomic.rmw.add acqrel acqrel $s $i32)
  (func (export "struct-atomic-rmw.add-i64-acqrel") (param $x (ref null $s)) (param $y i64) (result i64)
    local.get $x
    local.get $y
    struct.atomic.rmw.add acqrel acqrel $s $i64)
  (func (export "struct-atomic-rmw.sub-i32-seqcst") (param $x (ref null $s)) (param $y i32) (result i32)
    local.get $x
    local.get $y
    struct.atomic.rmw.sub seqcst $s $i32)
  (func (export "struct-atomic-rmw.sub-i64-seqcst") (param $x (ref null $s)) (param $y i64) (result i64)
    local.get $x
    local.get $y
    struct.atomic.rmw.sub seqcst $s $i64)
  (func (export "struct-atomic-rmw.sub-i32-acqrel") (param $x (ref null $s)) (param $y i32) (result i32)
    local.get $x
    local.get $y
    struct.atomic.rmw.sub acqrel acqrel $s $i32)
  (func (export "struct-atomic-rmw.sub-i64-acqrel") (param $x (ref null $s)) (param $y i64) (result i64)
    local.get $x
    local.get $y
    struct.atomic.rmw.sub acqrel acqrel $s $i64)
  (func (export "struct-atomic-rmw.and-i32-seqcst") (param $x (ref null $s)) (param $y i32) (result i32)
    local.get $x
    local.get $y
    struct.atomic.rmw.and seqcst $s $i32)
  (func (export "struct-atomic-rmw.and-i64-seqcst") (param $x (ref null $s)) (param $y i64) (result i64)
    local.get $x
    local.get $y
    struct.atomic.rmw.and seqcst $s $i64)
  (func (export "struct-atomic-rmw.and-i32-acqrel") (param $x (ref null $s)) (param $y i32) (result i32)
    local.get $x
    local.get $y
    struct.atomic.rmw.and acqrel acqrel $s $i32)
  (func (export "struct-atomic-rmw.and-i64-acqrel") (param $x (ref null $s)) (param $y i64) (result i64)
    local.get $x
    local.get $y
    struct.atomic.rmw.and acqrel acqrel $s $i64)
  (func (export "struct-atomic-rmw.or-i32-seqcst") (param $x (ref null $s)) (param $y i32) (result i32)
    local.get $x
    local.get $y
    struct.atomic.rmw.or seqcst $s $i32)
  (func (export "struct-atomic-rmw.or-i64-seqcst") (param $x (ref null $s)) (param $y i64) (result i64)
    local.get $x
    local.get $y
    struct.atomic.rmw.or seqcst $s $i64)
  (func (export "struct-atomic-rmw.or-i32-acqrel") (param $x (ref null $s)) (param $y i32) (result i32)
    local.get $x
    local.get $y
    struct.atomic.rmw.or acqrel acqrel $s $i32)
  (func (export "struct-atomic-rmw.or-i64-acqrel") (param $x (ref null $s)) (param $y i64) (result i64)
    local.get $x
    local.get $y
    struct.atomic.rmw.or acqrel acqrel $s $i64)
  (func (export "struct-atomic-rmw.xor-i32-seqcst") (param $x (ref null $s)) (param $y i32) (result i32)
    local.get $x
    local.get $y
    struct.atomic.rmw.xor seqcst $s $i32)
  (func (export "struct-atomic-rmw.xor-i64-seqcst") (param $x (ref null $s)) (param $y i64) (result i64)
    local.get $x
    local.get $y
    struct.atomic.rmw.xor seqcst $s $i64)
  (func (export "struct-atomic-rmw.xor-i32-acqrel") (param $x (ref null $s)) (param $y i32) (result i32)
    local.get $x
    local.get $y
    struct.atomic.rmw.xor acqrel acqrel $s $i32)
  (func (export "struct-atomic-rmw.xor-i64-acqrel") (param $x (ref null $s)) (param $y i64) (result i64)
    local.get $x
    local.get $y
    struct.atomic.rmw.xor acqrel acqrel $s $i64)
  (func (export "struct-atomic-rmw.xchg-i32-seqcst") (param $x (ref null $s)) (param $y i32) (result i32)
    local.get $x
    local.get $y
    struct.atomic.rmw.xchg seqcst $s $i32)
  (func (export "struct-atomic-rmw.xchg-i64-seqcst") (param $x (ref null $s)) (param $y i64) (result i64)
    local.get $x
    local.get $y
    struct.atomic.rmw.xchg seqcst $s $i64)
  (func (export "struct-atomic-rmw.xchg-anyref-seqcst") (param $x (ref null $s)) (param $y (ref null (shared any))) (result (ref null (shared any)))
    local.get $x
    local.get $y
    struct.atomic.rmw.xchg seqcst $s $anyref)
  (func (export "struct-atomic-rmw.xchg-i32-acqrel") (param $x (ref null $s)) (param $y i32) (result i32)
    local.get $x
    local.get $y
    struct.atomic.rmw.xchg acqrel acqrel $s $i32)
  (func (export "struct-atomic-rmw.xchg-i64-acqrel") (param $x (ref null $s)) (param $y i64) (result i64)
    local.get $x
    local.get $y
    struct.atomic.rmw.xchg acqrel acqrel $s $i64)
  (func (export "struct-atomic-rmw.xchg-anyref-acqrel") (param $x (ref null $s)) (param $y (ref null (shared any))) (result (ref null (shared any)))
    local.get $x
    local.get $y
    struct.atomic.rmw.xchg acqrel acqrel $s $anyref)
  (func (export "struct-atomic-rmw.cmpxchg-i32-seqcst") (param $x (ref null $s)) (param $y i32) (param $z i32) (result i32)
    local.get $x
    local.get $y
    local.get $z
    struct.atomic.rmw.cmpxchg seqcst $s $i32)
  (func (export "struct-atomic-rmw.cmpxchg-i64-seqcst") (param $x (ref null $s)) (param $y i64) (param $z i64) (result i64)
    local.get $x
    local.get $y
    local.get $z
    struct.atomic.rmw.cmpxchg seqcst $s $i64)
  (func (export "struct-atomic-rmw.cmpxchg-eqref-seqcst") (param $x (ref null $s)) (param $y (ref null (shared eq))) (param $z (ref null (shared eq))) (result (ref null (shared eq)))
    local.get $x
    local.get $y
    local.get $z
    struct.atomic.rmw.cmpxchg seqcst $s $eqref)
  (func (export "struct-atomic-rmw.cmpxchg-i32-acqrel") (param $x (ref null $s)) (param $y i32) (param $z i32) (result i32)
    local.get $x
    local.get $y
    local.get $z
    struct.atomic.rmw.cmpxchg acqrel acqrel $s $i32)
  (func (export "struct-atomic-rmw.cmpxchg-i64-acqrel") (param $x (ref null $s)) (param $y i64) (param $z i64) (result i64)
    local.get $x
    local.get $y
    local.get $z
    struct.atomic.rmw.cmpxchg acqrel acqrel $s $i64)
  (func (export "struct-atomic-rmw.cmpxchg-eqref-acqrel") (param $x (ref null $s)) (param $y (ref null (shared eq))) (param $z (ref null (shared eq))) (result (ref null (shared eq)))
    local.get $x
    local.get $y
    local.get $z
    struct.atomic.rmw.cmpxchg acqrel acqrel $s $eqref)
)

;; TODO: Validate use of struct.get_s/u with appropriate fields during parsing.

;; (assert_invalid (; get, i8 ;)
;;   (module
;;     (type $s (shared (struct (field $i8 (mut i8)))))
;;   (func (param $x (ref null $s)) (result i32)
;;     local.get $x
;;     struct.atomic.get seqcst $s $i8)
;;   )
;;   "non-packed storage type"
;; )
;; (assert_invalid (; get_s, i32 ;)
;;   (module
;;     (type $s (shared (struct (field $i32 (mut i32)))))
;;   (func (param $x (ref null $s)) (result i32)
;;     local.get $x
;;     struct.atomic.get_s seqcst $s $i32)
;;   )
;;   "non-packed storage types"
;; )
;; (assert_invalid (; get_s, anyref ;)
;;   (module
;;     (type $s (shared (struct (field $anyref (mut (ref null (shared any)))))))
;;   (func (param $x (ref null $s)) (result (ref null (shared any)))
;;     local.get $x
;;     struct.atomic.get_s seqcst $s $anyref)
;;   )
;;   "non-packed storage types"
;; )
;; (assert_invalid (; get_u, i32 ;)
;;   (module
;;     (type $s (shared (struct (field $i32 (mut i32)))))
;;   (func (param $x (ref null $s)) (result i32)
;;     local.get $x
;;     struct.atomic.get_u seqcst $s $i32)
;;   )
;;   "non-packed storage types"
;; )
;; (assert_invalid (; get_u, anyref ;)
;;   (module
;;     (type $s (shared (struct (field $anyref (mut (ref null (shared any)))))))
;;   (func (param $x (ref null $s)) (result (ref null (shared any)))
;;     local.get $x
;;     struct.atomic.get_u seqcst $s $anyref)
;;   )
;;   "non-packed storage types"
;; )
(assert_invalid (; rmw.add, anyref ;)
  (module
    (type $s (shared (struct (field $anyref (mut (ref null (shared any)))))))
  (func (param $x (ref null $s)) (param $y (ref null (shared any))) (result (ref null (shared any)))
    local.get $x
    local.get $y
    struct.atomic.rmw.add seqcst $s $anyref)
  )
  "invalid type"
)
(assert_invalid (; rmw.sub, anyref ;)
  (module
    (type $s (shared (struct (field $anyref (mut (ref null (shared any)))))))
  (func (param $x (ref null $s)) (param $y (ref null (shared any))) (result (ref null (shared any)))
    local.get $x
    local.get $y
    struct.atomic.rmw.sub seqcst $s $anyref)
  )
  "invalid type"
)
(assert_invalid (; rmw.and, anyref ;)
  (module
    (type $s (shared (struct (field $anyref (mut (ref null (shared any)))))))
  (func (param $x (ref null $s)) (param $y (ref null (shared any))) (result (ref null (shared any)))
    local.get $x
    local.get $y
    struct.atomic.rmw.and seqcst $s $anyref)
  )
  "invalid type"
)
(assert_invalid (; rmw.or, anyref ;)
  (module
    (type $s (shared (struct (field $anyref (mut (ref null (shared any)))))))
  (func (param $x (ref null $s)) (param $y (ref null (shared any))) (result (ref null (shared any)))
    local.get $x
    local.get $y
    struct.atomic.rmw.or seqcst $s $anyref)
  )
  "invalid type"
)
(assert_invalid (; rmw.xor, anyref ;)
  (module
    (type $s (shared (struct (field $anyref (mut (ref null (shared any)))))))
  (func (param $x (ref null $s)) (param $y (ref null (shared any))) (result (ref null (shared any)))
    local.get $x
    local.get $y
    struct.atomic.rmw.xor seqcst $s $anyref)
  )
  "invalid type"
)
(assert_invalid (; rmw.xchg, i8 ;)
  (module
    (type $s (shared (struct (field $i8 (mut i8)))))
  (func (param $x (ref null $s)) (param $y i32) (result i32)
    local.get $x
    local.get $y
    struct.atomic.rmw.xchg seqcst $s $i8)
  )
  "invalid type"
)
(assert_invalid (; rmw.cmpxchg, i8 ;)
  (module
    (type $s (shared (struct (field $i8 (mut i8)))))
  (func (param $x (ref null $s)) (param $y i32) (param $z i32) (result i32)
    local.get $x
    local.get $y
    local.get $z
    struct.atomic.rmw.cmpxchg seqcst $s $i8)
  )
  "invalid type"
)
(assert_invalid (; rmw.cmpxchg, anyref ;)
  (module
    (type $s (shared (struct (field $anyref (mut (ref null (shared any)))))))
  (func (param $x (ref null $s)) (param $y (ref null (shared any))) (param $z (ref null (shared any))) (result (ref null (shared any)))
    local.get $x
    local.get $y
    local.get $z
    struct.atomic.rmw.cmpxchg seqcst $s $anyref)
  )
  "invalid type"
)

;; (assert_invalid
;;   (module
;;     (type $s (shared (struct (field $f f32))))
;;     (func
;;       unreachable
;;       struct.atomic.get seqcst $s $f
;;       drop
;;     ))
;;   "invalid type: `struct.atomic.get` only allows `i32`, `i64` and subtypes of `anyref`"
;; )

;; (assert_invalid
;;   (module
;;     (type $s (shared (struct (field $f (ref (shared func))))))
;;     (func
;;       unreachable
;;       struct.atomic.get seqcst $s $f
;;       drop
;;     ))
;;   "invalid type: `struct.atomic.get` only allows `i32`, `i64` and subtypes of `anyref`"
;; )

;; (assert_invalid
;;   (module
;;     (type $s (shared (struct (field $f i8))))
;;     (func
;;       unreachable
;;       struct.atomic.get seqcst $s $f
;;       drop
;;     ))
;;   "can only use struct `get` with non-packed storage types"
;; )

;; (assert_invalid
;;   (module
;;     (type $s (shared (struct (field $f (mut (ref (shared extern)))))))
;;     (func
;;       unreachable
;;       struct.atomic.set seqcst $s $f
;;     ))
;;   "invalid type: `struct.atomic.set` only allows `i8`, `i16`, `i32`, `i64` and subtypes of `anyref`"
;; )

(module
  (type $i32 (struct (field (mut i32))))
  (type $i64 (struct (field (mut i64))))
  (type $any (struct (field (mut anyref))))
  (type $eq (struct (field (mut eqref))))
  (type $shared-i32 (shared (struct (field (mut i32)))))
  (type $shared-i64 (shared (struct (field (mut i64)))))
  (type $shared-any (shared (struct (field (mut (ref null (shared any)))))))
  (type $shared-eq (shared (struct (field (mut (ref null (shared eq)))))))

  (global $i32 (ref null $i32) (struct.new_default $i32))
  (global $i64 (ref null $i64) (struct.new_default $i64))
  (global $any (ref null $any) (struct.new_default $any))
  (global $eq (ref null $eq) (struct.new_default $eq))
  (global $shared-i32 (ref null $shared-i32) (struct.new_default $shared-i32))
  (global $shared-i64 (ref null $shared-i64) (struct.new_default $shared-i64))
  (global $shared-any (ref null $shared-any) (struct.new_default $shared-any))
  (global $shared-eq (ref null $shared-eq) (struct.new_default $shared-eq))

  (func (export "set-i32") (param i32) (struct.set $i32 0 (global.get $i32) (local.get 0)))
  (func (export "set-i64") (param i64) (struct.set $i64 0 (global.get $i64) (local.get 0)))
  (func (export "set-any") (param i32) (struct.set $any 0 (global.get $any) (struct.new $i32 (local.get 0))))
  (func (export "set-eq") (param i32) (struct.set $eq 0 (global.get $eq) (ref.i31 (local.get 0))))
  (func (export "set-shared-i32") (param i32) (struct.set $shared-i32 0 (global.get $shared-i32) (local.get 0)))
  (func (export "set-shared-i64") (param i64) (struct.set $shared-i64 0 (global.get $shared-i64) (local.get 0)))
  (func (export "set-shared-any") (param i32) (struct.set $shared-any 0 (global.get $shared-any) (struct.new $shared-i32 (local.get 0))))
  (func (export "set-shared-eq") (param i32) (struct.set $shared-eq 0 (global.get $shared-eq) (ref.i31_shared (local.get 0))))

  (func (export "get-i32") (result i32) (struct.get $i32 0 (global.get $i32)))
  (func (export "get-i64") (result i64) (struct.get $i64 0 (global.get $i64)))
  (func (export "get-any") (result i32) (struct.get $i32 0 (ref.cast (ref null $i32) (struct.get $any 0 (global.get $any)))))
  (func (export "get-eq") (result i32) (i31.get_u (ref.cast i31ref (struct.get $eq 0 (global.get $eq)))))
  (func (export "get-shared-i32") (result i32) (struct.get $shared-i32 0 (global.get $shared-i32)))
  (func (export "get-shared-i64") (result i64) (struct.get $shared-i64 0 (global.get $shared-i64)))
  (func (export "get-shared-any") (result i32) (struct.get $shared-i32 0 (ref.cast (ref null $shared-i32) (struct.get $shared-any 0 (global.get $shared-any)))))
  (func (export "get-shared-eq") (result i32) (i31.get_u (ref.cast (ref null (shared i31)) (struct.get $shared-eq 0 (global.get $shared-eq)))))

  (func (export "rmw-add-i32") (param i32) (result i32)
    (struct.atomic.rmw.add $i32 0 (global.get $i32) (local.get 0))
  )
  (func (export "rmw-sub-i32") (param i32) (result i32)
    (struct.atomic.rmw.sub $i32 0 (global.get $i32) (local.get 0))
  )
  (func (export "rmw-and-i32") (param i32) (result i32)
    (struct.atomic.rmw.and $i32 0 (global.get $i32) (local.get 0))
  )
  (func (export "rmw-or-i32") (param i32) (result i32)
    (struct.atomic.rmw.or $i32 0 (global.get $i32) (local.get 0))
  )
  (func (export "rmw-xor-i32") (param i32) (result i32)
    (struct.atomic.rmw.xor $i32 0 (global.get $i32) (local.get 0))
  )
  (func (export "rmw-xchg-i32") (param i32) (result i32)
    (struct.atomic.rmw.xchg $i32 0 (global.get $i32) (local.get 0))
  )
  (func (export "rmw-cmpxchg-i32") (param i32 i32) (result i32)
    (struct.atomic.rmw.cmpxchg $i32 0 (global.get $i32) (local.get 0) (local.get 1))
  )

  (func (export "rmw-add-i64") (param i64) (result i64)
    (struct.atomic.rmw.add $i64 0 (global.get $i64) (local.get 0))
  )
  (func (export "rmw-sub-i64") (param i64) (result i64)
    (struct.atomic.rmw.sub $i64 0 (global.get $i64) (local.get 0))
  )
  (func (export "rmw-and-i64") (param i64) (result i64)
    (struct.atomic.rmw.and $i64 0 (global.get $i64) (local.get 0))
  )
  (func (export "rmw-or-i64") (param i64) (result i64)
    (struct.atomic.rmw.or $i64 0 (global.get $i64) (local.get 0))
  )
  (func (export "rmw-xor-i64") (param i64) (result i64)
    (struct.atomic.rmw.xor $i64 0 (global.get $i64) (local.get 0))
  )
  (func (export "rmw-xchg-i64") (param i64) (result i64)
    (struct.atomic.rmw.xchg $i64 0 (global.get $i64) (local.get 0))
  )
  (func (export "rmw-cmpxchg-i64") (param i64 i64) (result i64)
    (struct.atomic.rmw.cmpxchg $i64 0 (global.get $i64) (local.get 0) (local.get 1))
  )

  (func (export "rmw-xchg-any") (param i32) (result i32)
    (struct.get $i32 0 (ref.cast (ref null $i32)
      (struct.atomic.rmw.xchg $any 0 (global.get $any) (struct.new $i32 (local.get 0)))
    ))
  )

  (func (export "rmw-cmpxchg-eq") (param i32 i32) (result i32)
    (i31.get_u (ref.cast i31ref
      (struct.atomic.rmw.cmpxchg $eq 0 (global.get $eq) (ref.i31 (local.get 0)) (ref.i31 (local.get 1)))
    ))
  )

  (func (export "rmw-add-shared-i32") (param i32) (result i32)
    (struct.atomic.rmw.add $shared-i32 0 (global.get $shared-i32) (local.get 0))
  )
  (func (export "rmw-sub-shared-i32") (param i32) (result i32)
    (struct.atomic.rmw.sub $shared-i32 0 (global.get $shared-i32) (local.get 0))
  )
  (func (export "rmw-and-shared-i32") (param i32) (result i32)
    (struct.atomic.rmw.and $shared-i32 0 (global.get $shared-i32) (local.get 0))
  )
  (func (export "rmw-or-shared-i32") (param i32) (result i32)
    (struct.atomic.rmw.or $shared-i32 0 (global.get $shared-i32) (local.get 0))
  )
  (func (export "rmw-xor-shared-i32") (param i32) (result i32)
    (struct.atomic.rmw.xor $shared-i32 0 (global.get $shared-i32) (local.get 0))
  )
  (func (export "rmw-xchg-shared-i32") (param i32) (result i32)
    (struct.atomic.rmw.xchg $shared-i32 0 (global.get $shared-i32) (local.get 0))
  )
  (func (export "rmw-cmpxchg-shared-i32") (param i32 i32) (result i32)
    (struct.atomic.rmw.cmpxchg $shared-i32 0 (global.get $shared-i32) (local.get 0) (local.get 1))
  )

  (func (export "rmw-add-shared-i64") (param i64) (result i64)
    (struct.atomic.rmw.add $shared-i64 0 (global.get $shared-i64) (local.get 0))
  )
  (func (export "rmw-sub-shared-i64") (param i64) (result i64)
    (struct.atomic.rmw.sub $shared-i64 0 (global.get $shared-i64) (local.get 0))
  )
  (func (export "rmw-and-shared-i64") (param i64) (result i64)
    (struct.atomic.rmw.and $shared-i64 0 (global.get $shared-i64) (local.get 0))
  )
  (func (export "rmw-or-shared-i64") (param i64) (result i64)
    (struct.atomic.rmw.or $shared-i64 0 (global.get $shared-i64) (local.get 0))
  )
  (func (export "rmw-xor-shared-i64") (param i64) (result i64)
    (struct.atomic.rmw.xor $shared-i64 0 (global.get $shared-i64) (local.get 0))
  )
  (func (export "rmw-xchg-shared-i64") (param i64) (result i64)
    (struct.atomic.rmw.xchg $shared-i64 0 (global.get $shared-i64) (local.get 0))
  )
  (func (export "rmw-cmpxchg-shared-i64") (param i64 i64) (result i64)
    (struct.atomic.rmw.cmpxchg $shared-i64 0 (global.get $shared-i64) (local.get 0) (local.get 1))
  )

  (func (export "rmw-xchg-shared-any") (param i32) (result i32)
    (struct.get $shared-i32 0 (ref.cast (ref null $shared-i32)
      (struct.atomic.rmw.xchg $shared-any 0 (global.get $shared-any) (struct.new $shared-i32 (local.get 0)))
    ))
  )

  (func (export "rmw-cmpxchg-shared-eq") (param i32 i32) (result i32)
    (i31.get_u (ref.cast (ref null (shared i31))
      (struct.atomic.rmw.cmpxchg $shared-eq 0 (global.get $shared-eq) (ref.i31_shared (local.get 0)) (ref.i31_shared (local.get 1)))
    ))
  )
)

(assert_return (invoke "set-i32" (i32.const 0)))
(assert_return (invoke "rmw-add-i32" (i32.const 1)) (i32.const 0))
(assert_return (invoke "rmw-add-i32" (i32.const 1)) (i32.const 1))
(assert_return (invoke "get-i32") (i32.const 2))

(assert_return (invoke "set-i32" (i32.const 0)))
(assert_return (invoke "rmw-sub-i32" (i32.const 1)) (i32.const 0))
(assert_return (invoke "rmw-sub-i32" (i32.const 1)) (i32.const -1))
(assert_return (invoke "get-i32") (i32.const -2))

(assert_return (invoke "set-i32" (i32.const 3)))
(assert_return (invoke "rmw-and-i32" (i32.const 1)) (i32.const 3))
(assert_return (invoke "rmw-and-i32" (i32.const 1)) (i32.const 1))
(assert_return (invoke "get-i32") (i32.const 1))

(assert_return (invoke "set-i32" (i32.const 0)))
(assert_return (invoke "rmw-or-i32" (i32.const 1)) (i32.const 0))
(assert_return (invoke "rmw-or-i32" (i32.const 1)) (i32.const 1))
(assert_return (invoke "get-i32") (i32.const 1))

(assert_return (invoke "set-i32" (i32.const 3)))
(assert_return (invoke "rmw-xor-i32" (i32.const 1)) (i32.const 3))
(assert_return (invoke "rmw-xor-i32" (i32.const 3)) (i32.const 2))
(assert_return (invoke "get-i32") (i32.const 1))

(assert_return (invoke "set-i32" (i32.const 1)))
(assert_return (invoke "rmw-xchg-i32" (i32.const 99)) (i32.const 1))
(assert_return (invoke "rmw-xchg-i32" (i32.const 42)) (i32.const 99))
(assert_return (invoke "get-i32") (i32.const 42))

(assert_return (invoke "set-i32" (i32.const 1)))
(assert_return (invoke "rmw-cmpxchg-i32" (i32.const 0) (i32.const 2)) (i32.const 1))
(assert_return (invoke "get-i32") (i32.const 1))
(assert_return (invoke "rmw-cmpxchg-i32" (i32.const 1) (i32.const 2)) (i32.const 1))
(assert_return (invoke "get-i32") (i32.const 2))

(assert_return (invoke "set-i64" (i64.const 0)))
(assert_return (invoke "rmw-add-i64" (i64.const 1)) (i64.const 0))
(assert_return (invoke "rmw-add-i64" (i64.const 1)) (i64.const 1))
(assert_return (invoke "get-i64") (i64.const 2))

(assert_return (invoke "set-i64" (i64.const 0)))
(assert_return (invoke "rmw-sub-i64" (i64.const 1)) (i64.const 0))
(assert_return (invoke "rmw-sub-i64" (i64.const 1)) (i64.const -1))
(assert_return (invoke "get-i64") (i64.const -2))

(assert_return (invoke "set-i64" (i64.const 3)))
(assert_return (invoke "rmw-and-i64" (i64.const 1)) (i64.const 3))
(assert_return (invoke "rmw-and-i64" (i64.const 1)) (i64.const 1))
(assert_return (invoke "get-i64") (i64.const 1))

(assert_return (invoke "set-i64" (i64.const 0)))
(assert_return (invoke "rmw-or-i64" (i64.const 1)) (i64.const 0))
(assert_return (invoke "rmw-or-i64" (i64.const 1)) (i64.const 1))
(assert_return (invoke "get-i64") (i64.const 1))

(assert_return (invoke "set-i64" (i64.const 3)))
(assert_return (invoke "rmw-xor-i64" (i64.const 1)) (i64.const 3))
(assert_return (invoke "rmw-xor-i64" (i64.const 3)) (i64.const 2))
(assert_return (invoke "get-i64") (i64.const 1))

(assert_return (invoke "set-i64" (i64.const 1)))
(assert_return (invoke "rmw-xchg-i64" (i64.const 99)) (i64.const 1))
(assert_return (invoke "rmw-xchg-i64" (i64.const 42)) (i64.const 99))
(assert_return (invoke "get-i64") (i64.const 42))

(assert_return (invoke "set-i64" (i64.const 1)))
(assert_return (invoke "rmw-cmpxchg-i64" (i64.const 0) (i64.const 2)) (i64.const 1))
(assert_return (invoke "get-i64") (i64.const 1))
(assert_return (invoke "rmw-cmpxchg-i64" (i64.const 1) (i64.const 2)) (i64.const 1))
(assert_return (invoke "get-i64") (i64.const 2))

(assert_return (invoke "set-any" (i32.const 1)))
(assert_return (invoke "rmw-xchg-any" (i32.const 99)) (i32.const 1))
(assert_return (invoke "rmw-xchg-any" (i32.const 42)) (i32.const 99))
(assert_return (invoke "get-any") (i32.const 42))

(assert_return (invoke "set-eq" (i32.const 1)))
(assert_return (invoke "rmw-cmpxchg-eq" (i32.const 0) (i32.const 2)) (i32.const 1))
(assert_return (invoke "get-eq") (i32.const 1))
(assert_return (invoke "rmw-cmpxchg-eq" (i32.const 1) (i32.const 2)) (i32.const 1))
(assert_return (invoke "get-eq") (i32.const 2))

(assert_return (invoke "set-shared-i32" (i32.const 0)))
(assert_return (invoke "rmw-add-shared-i32" (i32.const 1)) (i32.const 0))
(assert_return (invoke "rmw-add-shared-i32" (i32.const 1)) (i32.const 1))
(assert_return (invoke "get-shared-i32") (i32.const 2))

(assert_return (invoke "set-shared-i32" (i32.const 0)))
(assert_return (invoke "rmw-sub-shared-i32" (i32.const 1)) (i32.const 0))
(assert_return (invoke "rmw-sub-shared-i32" (i32.const 1)) (i32.const -1))
(assert_return (invoke "get-shared-i32") (i32.const -2))

(assert_return (invoke "set-shared-i32" (i32.const 3)))
(assert_return (invoke "rmw-and-shared-i32" (i32.const 1)) (i32.const 3))
(assert_return (invoke "rmw-and-shared-i32" (i32.const 1)) (i32.const 1))
(assert_return (invoke "get-shared-i32") (i32.const 1))

(assert_return (invoke "set-shared-i32" (i32.const 0)))
(assert_return (invoke "rmw-or-shared-i32" (i32.const 1)) (i32.const 0))
(assert_return (invoke "rmw-or-shared-i32" (i32.const 1)) (i32.const 1))
(assert_return (invoke "get-shared-i32") (i32.const 1))

(assert_return (invoke "set-shared-i32" (i32.const 3)))
(assert_return (invoke "rmw-xor-shared-i32" (i32.const 1)) (i32.const 3))
(assert_return (invoke "rmw-xor-shared-i32" (i32.const 3)) (i32.const 2))
(assert_return (invoke "get-shared-i32") (i32.const 1))

(assert_return (invoke "set-shared-i32" (i32.const 1)))
(assert_return (invoke "rmw-xchg-shared-i32" (i32.const 99)) (i32.const 1))
(assert_return (invoke "rmw-xchg-shared-i32" (i32.const 42)) (i32.const 99))
(assert_return (invoke "get-shared-i32") (i32.const 42))

(assert_return (invoke "set-shared-i32" (i32.const 1)))
(assert_return (invoke "rmw-cmpxchg-shared-i32" (i32.const 0) (i32.const 2)) (i32.const 1))
(assert_return (invoke "get-shared-i32") (i32.const 1))
(assert_return (invoke "rmw-cmpxchg-shared-i32" (i32.const 1) (i32.const 2)) (i32.const 1))
(assert_return (invoke "get-shared-i32") (i32.const 2))

(assert_return (invoke "set-shared-i64" (i64.const 0)))
(assert_return (invoke "rmw-add-shared-i64" (i64.const 1)) (i64.const 0))
(assert_return (invoke "rmw-add-shared-i64" (i64.const 1)) (i64.const 1))
(assert_return (invoke "get-shared-i64") (i64.const 2))

(assert_return (invoke "set-shared-i64" (i64.const 0)))
(assert_return (invoke "rmw-sub-shared-i64" (i64.const 1)) (i64.const 0))
(assert_return (invoke "rmw-sub-shared-i64" (i64.const 1)) (i64.const -1))
(assert_return (invoke "get-shared-i64") (i64.const -2))

(assert_return (invoke "set-shared-i64" (i64.const 3)))
(assert_return (invoke "rmw-and-shared-i64" (i64.const 1)) (i64.const 3))
(assert_return (invoke "rmw-and-shared-i64" (i64.const 1)) (i64.const 1))
(assert_return (invoke "get-shared-i64") (i64.const 1))

(assert_return (invoke "set-shared-i64" (i64.const 0)))
(assert_return (invoke "rmw-or-shared-i64" (i64.const 1)) (i64.const 0))
(assert_return (invoke "rmw-or-shared-i64" (i64.const 1)) (i64.const 1))
(assert_return (invoke "get-shared-i64") (i64.const 1))

(assert_return (invoke "set-shared-i64" (i64.const 3)))
(assert_return (invoke "rmw-xor-shared-i64" (i64.const 1)) (i64.const 3))
(assert_return (invoke "rmw-xor-shared-i64" (i64.const 3)) (i64.const 2))
(assert_return (invoke "get-shared-i64") (i64.const 1))

(assert_return (invoke "set-shared-i64" (i64.const 1)))
(assert_return (invoke "rmw-xchg-shared-i64" (i64.const 99)) (i64.const 1))
(assert_return (invoke "rmw-xchg-shared-i64" (i64.const 42)) (i64.const 99))
(assert_return (invoke "get-shared-i64") (i64.const 42))

(assert_return (invoke "set-shared-i64" (i64.const 1)))
(assert_return (invoke "rmw-cmpxchg-shared-i64" (i64.const 0) (i64.const 2)) (i64.const 1))
(assert_return (invoke "get-shared-i64") (i64.const 1))
(assert_return (invoke "rmw-cmpxchg-shared-i64" (i64.const 1) (i64.const 2)) (i64.const 1))
(assert_return (invoke "get-shared-i64") (i64.const 2))

(assert_return (invoke "set-shared-any" (i32.const 1)))
(assert_return (invoke "rmw-xchg-shared-any" (i32.const 99)) (i32.const 1))
(assert_return (invoke "rmw-xchg-shared-any" (i32.const 42)) (i32.const 99))
(assert_return (invoke "get-shared-any") (i32.const 42))

(assert_return (invoke "set-shared-eq" (i32.const 1)))
(assert_return (invoke "rmw-cmpxchg-shared-eq" (i32.const 0) (i32.const 2)) (i32.const 1))
(assert_return (invoke "get-shared-eq") (i32.const 1))
(assert_return (invoke "rmw-cmpxchg-shared-eq" (i32.const 1) (i32.const 2)) (i32.const 1))
(assert_return (invoke "get-shared-eq") (i32.const 2))
