;; Shared struct declaration syntax
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

;; Shared structs are distinct from non-shared structs
(assert_invalid
  (module
    (type (shared (struct)))
    (type (struct))

    (global (ref 0) (struct.new 1))
  )
  "not a subtype"
)

(assert_invalid
  (module
    (type (shared (struct)))
    (type (struct))

    (global (ref 1) (struct.new 0))
  )
  "not a subtype"
)

;; Shared structs may not be subtypes of non-shared structs
(assert_invalid
  (module
    (type (sub (struct)))
    (type (sub 0 (shared (struct))))
  )
  "invalid supertype"
)

;; Non-shared structs may not be subtypes of shared structs
(assert_invalid
  (module
    (type (sub (shared (struct))))
    (type (sub 0 (struct)))
  )
  "invalid supertype"
)

;; Shared structs may not contain non-shared references
(assert_invalid
  (module
    (type (shared (struct anyref)))
  )
  "invalid field"
)

;; But they may contain shared references
(module
  (type (shared (struct (ref null (shared any)))))
)

;; Non-shared structs may contain shared references
(module
  (type (struct (ref null (shared any))))
)
