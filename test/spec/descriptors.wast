(module
  (rec
    (type (descriptor 1 (struct)))
    (type (describes 0 (struct)))
  )
)

(assert_invalid
  (module
    (rec
      (type (descriptor 1 (struct)))
      (type (struct))
    )
  )
  "descriptor with no matching describes"
)


(assert_invalid
  (module
    (rec
      (type (struct))
      (type (describes 0 (struct)))
    )
  )
  "describes with no matching descriptor"
)

(assert_invalid
  (module
    (rec
      (type (describes 1 (struct)))
      (type (descriptor 0 (struct)))
    )
  )
  "forward describes reference"
)

(assert_invalid
  (module
    (rec
      (type (descriptor 1 (array i8)))
      (type (describes 0 (struct)))
    )
  )
  "descriptor clause on non-struct type"
)

(assert_invalid
  (module
    (rec
      (type (descriptor 1 (struct)))
      (type (describes 0 (array i8)))
    )
  )
  "describes clause on non-struct type"
)

(module
  (rec
    (type (shared (descriptor 1 (struct))))
    (type (shared (describes 0 (struct))))
  )
)

(assert_invalid
  (module
    (rec
      (type (shared (descriptor 1 (struct))))
      (type (describes 0 (struct)))
    )
  )
  "unshared descriptor type"
)

;; TODO: allow this?
(assert_invalid
  (module
    (rec
      (type (descriptor 1 (struct)))
      (type (shared (describes 0 (struct))))
    )
  )
  "unshared described types"
)

(module
  (rec
    (type $super (sub (descriptor $super-desc (struct))))
    (type $super-desc (sub (describes $super (struct))))
  )
  (rec
    (type $sub (sub $super (descriptor $sub-desc (struct))))
    (type $sub-desc (sub $super-desc (describes $sub (struct))))
  )
)

(module
  (type $super (sub (struct)))
  (rec
    (type $other (sub (descriptor $super-desc (struct))))
    (type $super-desc (sub (describes $other (struct))))
  )
  (rec
    (type $sub (sub $super (descriptor $sub-desc (struct))))
    (type $sub-desc (sub $super-desc (describes $sub (struct))))
  )
)

(assert_invalid
  (module
    (type $super (sub (struct)))
    (type $super-desc (sub (struct)))
    (rec
      (type $sub (sub $super (descriptor $sub-desc (struct))))
      (type $sub-desc (sub $super-desc (describes $sub (struct))))
    )
  )
  "supertype of descriptor must be a descriptor"
)

(assert_invalid
  (module
    (rec
      (type $other (sub (descriptor $super-desc (struct))))
      (type $super-desc (sub (describes $other (struct))))
      (type $super (sub (descriptor $other-desc (struct))))
      (type $other-desc (sub (describes $super (struct))))
    )
    (rec
      (type $sub (sub $super (descriptor $sub-desc (struct))))
      (type $sub-desc (sub $super-desc (describes $sub (struct))))
    )
  )
  "supertype of described type must be described by supertype of descriptor"
)

(assert_invalid
  (module
    (rec
      (type $super (sub (descriptor $super-desc (struct))))
      (type $super-desc (sub (describes $super (struct))))
    )
    (type $sub (sub $super (struct)))
  )
  "supertype of type without descriptor cannot have descriptor"
)

(assert_invalid
  (module
    (rec
      (type $super (sub (descriptor $super-desc (struct))))
      (type $super-desc (sub (describes $super (struct))))
    )
    (type $sub (sub $super-desc (struct)))
  )
  "supertype of non-descriptor type cannot be a descriptor"
)
