;; Maximum memory sizes.
;;
;; These modules are valid, but instantiating them is unnecessary
;; and would only allocate very large memories and slow down running
;; the spec tests. Therefore, add a missing import so that it cannot
;; be instantiated and use `assert_unlinkable`. This approach
;; enforces that the module itself is still valid, but that its
;; instantiation fails early (hopefully before any memories are
;; actually allocated).

;; i32 (pagesize 1)
(assert_unlinkable
  (module
    (import "test" "unknown" (func))
    (memory 0xFFFF_FFFF (pagesize 1)))
  "unknown import")

;; i32 (default pagesize)
(assert_unlinkable
  (module
    (import "test" "unknown" (func))
    (memory 65536 (pagesize 65536)))
  "unknown import")

;; Memory size just over the maximum.

;; i32 (pagesize 1)
(assert_invalid
  (module
    (memory 0x1_0000_0000 (pagesize 1)))
  "memory size must be at most")

;; i32 (default pagesize)
(assert_invalid
  (module
    (memory 65537 (pagesize 65536)))
  "memory size must be at most")
