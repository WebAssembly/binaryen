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
