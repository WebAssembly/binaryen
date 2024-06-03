;; Test table section structure

(module (table 0 funcref))
(module (table 1 funcref))
(module (table 0 0 funcref))
(module (table 0 1 funcref))
(module (table 1 256 funcref))
(module (table 0 65536 funcref))
(module (table 0 0xffff_ffff funcref))

(module (table 0 funcref) (table 0 funcref))
(module (table (import "spectest" "table") 0 funcref) (table 0 funcref))

(assert_invalid
  (module (table 1 0 funcref))
  "size minimum must not be greater than maximum"
)
(assert_invalid
  (module (table 0xffff_ffff 0 funcref))
  "size minimum must not be greater than maximum"
)

(assert_invalid
  (module quote "(table 0x1_0000_0000 funcref)")
  "table size must be at most 2^32-1"
)
(assert_invalid
  (module quote "(table 0x1_0000_0000 0x1_0000_0000 funcref)")
  "table size must be at most 2^32-1"
)
(assert_invalid
  (module quote "(table 0 0x1_0000_0000 funcref)")
  "table size must be at most 2^32-1"
)

;; Same as above but with i64 index types

(module (table i64 0 funcref))
(module (table i64 1 funcref))
(module (table i64 0 0 funcref))
(module (table i64 0 1 funcref))
(module (table i64 1 256 funcref))
(module (table i64 0 65536 funcref))
(module (table i64 0 0xffff_ffff funcref))

(module (table i64 0 funcref) (table i64 0 funcref))
(module (table (import "spectest" "table64") i64 0 funcref) (table i64 0 funcref))

(assert_invalid
  (module (table i64 1 0 funcref))
  "size minimum must not be greater than maximum"
)
(assert_invalid
  (module (table i64 0xffff_ffff 0 funcref))
  "size minimum must not be greater than maximum"
)

;; Elem segments with no table

(assert_invalid (module (elem (i32.const 0))) "unknown table")
(assert_invalid (module (elem (i32.const 0) $f) (func $f)) "unknown table")

;; Duplicate table identifiers

(assert_malformed (module quote
  "(table $foo 1 funcref)"
  "(table $foo 1 funcref)")
  "duplicate table")
(assert_malformed (module quote
  "(import \"\" \"\" (table $foo 1 funcref))"
  "(table $foo 1 funcref)")
  "duplicate table")
(assert_malformed (module quote
  "(import \"\" \"\" (table $foo 1 funcref))"
  "(import \"\" \"\" (table $foo 1 funcref))")
  "duplicate table")
