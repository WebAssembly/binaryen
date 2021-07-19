
;; Test table section structure

(module (table 0 funcref))
(module (table 0 (ref null func)))
(module (table 1 funcref))
(module (table 0 0 funcref))
(module (table 0 1 funcref))
(module (table 0 1 (ref null func)))
(module (table 1 256 funcref))
(module (table 0 65536 externref))
;; (module (table 0 0xffff_ffff funcref))

(module (table 0 funcref) (table 0 funcref))
(module (table (import "spectest" "table") 0 funcref) (table 0 funcref))

(assert_invalid (module (elem (i32.const 0))) "unknown table")
(assert_invalid (module (elem (i32.const 0) $f) (func $f)) "unknown table")


(assert_invalid
  (module (table 1 0 funcref))
  "size minimum must not be greater than maximum"
)
