;; Maximum memory sizes.
;;
;; These modules are valid, but instantiating them is unnecessary
;; and would only allocate very large memories and slow down running
;; the spec tests. Therefore, add a missing import so that it cannot
;; be instantiated and use `assert_unlinkable`. This approach
;; enforces that the module itself is still valid, but that its
;; instantiation fails early (hopefully before any memories are
;; actually allocated).

;; i64 (pagesize 1)
(assert_unlinkable
  (module
    (import "test" "import" (func))
    (memory i64 0xFFFF_FFFF_FFFF_FFFF (pagesize 1)))
  "unknown import")

;; i64 (default pagesize)
(assert_unlinkable
  (module
    (import "test" "unknown" (func))
    (memory i64 0x1_0000_0000_0000 (pagesize 65536)))
  "unknown import")

;; Memory size just over the maximum.
;;
;; These are malformed (for pagesize 1)
;; or invalid (for other pagesizes).

;; i64 (pagesize 1)
(assert_malformed
  (module quote "(memory i64 0x1_0000_0000_0000_0000 (pagesize 1))")
  "constant out of range")

;; i64 (default pagesize)
(assert_invalid
  (module
    (memory i64 0x1_0000_0000_0001 (pagesize 65536)))
  "memory size must be at most")
