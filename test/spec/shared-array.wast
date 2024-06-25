;; Shared array declaration syntax
(module
  (type (shared (array i8)))
  (type (sub final (shared (array i8))))
  (rec
    (type (sub final (shared (array i8))))
  )

  (global (ref 0) (array.new_default 1 (i32.const 1)))
  (global (ref 1) (array.new_default 2 (i32.const 1)))
  (global (ref 2) (array.new_default 0 (i32.const 1)))
)

;; Shared arrays are distinct from non-shared arrays
(assert_invalid
  (module
    (type (shared (array i8)))
    (type (array i8))

    (global (ref 0) (array.new_default 1 (i32.const 1)))
  )
  "not a subtype"
)

(assert_invalid
  (module
    (type (shared (array i8)))
    (type (array i8))

    (global (ref 1) (array.new 0))
  )
  "not a subtype"
)

;; Shared arrays may not be subtypes of non-shared arrays
(assert_invalid
  (module
    (type (sub (array i8)))
    (type (sub 0 (shared (array i8))))
  )
  "invalid supertype"
)

;; Non-shared arrays may not be subtypes of shared arrays
(assert_invalid
  (module
    (type (sub (shared (array i8))))
    (type (sub 0 (array i8)))
  )
  "invalid supertype"
)

;; Shared arrays may not contain non-shared references
(assert_invalid
  (module
    (type (shared (array anyref)))
  )
  "invalid field"
)

;; But they may contain shared references
(module
  (type (shared (array (ref null (shared any)))))
)

;; Non-shared arrays may contain shared references
(module
  (type (array (ref null (shared any))))
)

;; Array instructions work on shared arrays.
(module
  (type $i8 (shared (array (mut i8))))
  (type $i32 (shared (array (mut i32))))
  (type $unshared (array (mut i8)))

  (data)
  (elem)

  (func (array.new $i8 (i32.const 0) (i32.const 0)) (drop))

  (func (array.new_default $i8 (i32.const 0)) (drop))

  (func (array.new_fixed $i8 0) (drop))

  (func (param (ref null $i8))
    (array.get_s $i8 (local.get 0) (i32.const 0)) (drop))

  (func (param (ref null $i8))
    (array.get_u $i8 (local.get 0) (i32.const 0)) (drop))

  (func (param (ref null $i32))
    (array.get $i32 (local.get 0) (i32.const 0)) (drop))

  (func (param (ref null $i8))
    (array.set $i8 (local.get 0) (i32.const 0) (i32.const 0)))

  (func (param (ref null $i8) (ref null $i8))
    (array.copy $i8 $i8 (local.get 0) (i32.const 0) (local.get 1) (i32.const 0) (i32.const 0)))

  (func (param (ref null $i8) (ref null $unshared))
    (array.copy $i8 $unshared (local.get 0) (i32.const 0) (local.get 1) (i32.const 0) (i32.const 0)))

  (func (param (ref null $unshared) (ref null $i8))
    (array.copy $unshared $i8 (local.get 0) (i32.const 0) (local.get 1) (i32.const 0) (i32.const 0)))

  (func (param (ref null $i8))
    (array.fill $i8 (local.get 0) (i32.const 0) (i32.const 0) (i32.const 0)))

  (func (param (ref null $i8))
    (array.init_data $i8 0 (local.get 0) (i32.const 0) (i32.const 0) (i32.const 0)))

  (func (param (ref null $i8))
    (array.init_data $i8 0 (local.get 0) (i32.const 0) (i32.const 0) (i32.const 0)))
)
