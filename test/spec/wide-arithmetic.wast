(module
  (func (export "i64.add128") (param i64 i64 i64 i64) (result i64 i64)
    local.get 0
    local.get 1
    local.get 2
    local.get 3
    i64.add128)
  (func (export "i64.sub128") (param i64 i64 i64 i64) (result i64 i64)
    local.get 0
    local.get 1
    local.get 2
    local.get 3
    i64.sub128)
)

;; simple addition
(assert_return (invoke "i64.add128"
                  (i64.const 0) (i64.const 0)
                  (i64.const 0) (i64.const 0))
               (i64.const 0) (i64.const 0))
(assert_return (invoke "i64.add128"
                  (i64.const 0) (i64.const 1)
                  (i64.const 1) (i64.const 0))
               (i64.const 1) (i64.const 1))
(assert_return (invoke "i64.add128"
                  (i64.const 1) (i64.const 0)
                  (i64.const -1) (i64.const 0))
               (i64.const 0) (i64.const 1))
(assert_return (invoke "i64.add128"
                  (i64.const 1) (i64.const 1)
                  (i64.const -1) (i64.const -1))
               (i64.const 0) (i64.const 1))

;; 20 randomly generated test cases for i64.add128
(assert_return (invoke "i64.add128"
                   (i64.const -2418420703207364752) (i64.const -1)
                   (i64.const -1) (i64.const -1))
               (i64.const -2418420703207364753) (i64.const -1))
(assert_return (invoke "i64.add128"
                   (i64.const 0) (i64.const 0)
                   (i64.const -4579433644172935106) (i64.const -1))
               (i64.const -4579433644172935106) (i64.const -1))
(assert_return (invoke "i64.add128"
                   (i64.const 0) (i64.const 0)
                   (i64.const 1) (i64.const -1))
               (i64.const 1) (i64.const -1))
(assert_return (invoke "i64.add128"
                   (i64.const 1) (i64.const 0)
                   (i64.const 1) (i64.const 0))
               (i64.const 2) (i64.const 0))
(assert_return (invoke "i64.add128"
                   (i64.const -1) (i64.const -1)
                   (i64.const -1) (i64.const -1))
               (i64.const -2) (i64.const -1))
(assert_return (invoke "i64.add128"
                   (i64.const 0) (i64.const -1)
                   (i64.const 1) (i64.const 0))
               (i64.const 1) (i64.const -1))
(assert_return (invoke "i64.add128"
                   (i64.const 0) (i64.const 0)
                   (i64.const 0) (i64.const -1))
               (i64.const 0) (i64.const -1))
(assert_return (invoke "i64.add128"
                   (i64.const 1) (i64.const 0)
                   (i64.const -1) (i64.const -1))
               (i64.const 0) (i64.const 0))
(assert_return (invoke "i64.add128"
                   (i64.const 0) (i64.const 6184727276166606191)
                   (i64.const 0) (i64.const 1))
               (i64.const 0) (i64.const 6184727276166606192))
(assert_return (invoke "i64.add128"
                   (i64.const -8434911321912688222) (i64.const -1)
                   (i64.const 1) (i64.const -1))
               (i64.const -8434911321912688221) (i64.const -2))
(assert_return (invoke "i64.add128"
                   (i64.const 1) (i64.const -1)
                   (i64.const 0) (i64.const -1))
               (i64.const 1) (i64.const -2))
(assert_return (invoke "i64.add128"
                   (i64.const 1) (i64.const -5148941131328838092)
                   (i64.const 0) (i64.const 0))
               (i64.const 1) (i64.const -5148941131328838092))
(assert_return (invoke "i64.add128"
                   (i64.const 1) (i64.const 1)
                   (i64.const 1) (i64.const 0))
               (i64.const 2) (i64.const 1))
(assert_return (invoke "i64.add128"
                   (i64.const -1) (i64.const -1)
                   (i64.const -3636740005180858631) (i64.const -1))
               (i64.const -3636740005180858632) (i64.const -1))
(assert_return (invoke "i64.add128"
                   (i64.const -5529682780229988275) (i64.const -1)
                   (i64.const 0) (i64.const 0))
               (i64.const -5529682780229988275) (i64.const -1))
(assert_return (invoke "i64.add128"
                   (i64.const 1) (i64.const -5381447440966559717)
                   (i64.const 1020031372481336745) (i64.const 1))
               (i64.const 1020031372481336746) (i64.const -5381447440966559716))
(assert_return (invoke "i64.add128"
                   (i64.const 1) (i64.const 1)
                   (i64.const 0) (i64.const 0))
               (i64.const 1) (i64.const 1))
(assert_return (invoke "i64.add128"
                   (i64.const -9133888546939907356) (i64.const -1)
                   (i64.const 1) (i64.const 1))
               (i64.const -9133888546939907355) (i64.const 0))
(assert_return (invoke "i64.add128"
                   (i64.const -4612047512704241719) (i64.const -1)
                   (i64.const 0) (i64.const -1))
               (i64.const -4612047512704241719) (i64.const -2))
(assert_return (invoke "i64.add128"
                   (i64.const 414720966820876428) (i64.const -1)
                   (i64.const 1) (i64.const 0))
               (i64.const 414720966820876429) (i64.const -1))

;; assert overlong encodings for each instruction's binary encoding are accepted
(module binary
  "\00asm" "\01\00\00\00"

  "\01\0a"                  ;; type section, 10 bytes
  "\01"                     ;; 1 count
  "\60"                     ;; type0 = function
  "\04\7e\7e\7e\7e"         ;;  4 params - all i64
  "\02\7e\7e"               ;;  2 results - both i64

  "\03\02"                  ;; function section, 2 byte
  "\01"                     ;; 1 count
  "\00"                     ;; types of each function (0)

  "\07\0e"                  ;; export section 0x0e bytes
  "\01"                     ;; 1 count
  "\0ai64.add128\00\00"     ;; "i64.add128" which is function 0

  "\0a\10"                  ;; code section, 16 bytes
  "\01"                     ;; 1 count

  "\0e"                     ;; byte length
  "\00"                     ;; no locals
  "\20\00"                  ;; local.get 0
  "\20\01"                  ;; local.get 1
  "\20\02"                  ;; local.get 2
  "\20\03"                  ;; local.get 3
  "\fc\93\80\00"            ;; i64.add128 (overlong)
  "\0b"                     ;; end
)

(assert_return (invoke "i64.add128"
                  (i64.const 1) (i64.const 2)
                  (i64.const 3) (i64.const 4))
               (i64.const 4) (i64.const 6))

;; some invalid types for these instructions

(assert_invalid
  (module
    (func (param i64 i64 i64 i64) (result i64)
      local.get 0
      local.get 1
      local.get 2
      local.get 3
      i64.add128)
  )
  "type mismatch")
(assert_invalid
  (module
    (func (param i64 i64 i64) (result i64 i64)
      local.get 0
      local.get 1
      local.get 2
      i64.add128)
  )
  "type mismatch")

;; simple subtraction
(assert_return (invoke "i64.sub128"
                  (i64.const 0) (i64.const 0)
                  (i64.const 0) (i64.const 0))
               (i64.const 0) (i64.const 0))
(assert_return (invoke "i64.sub128"
                  (i64.const 1) (i64.const 0)
                  (i64.const 1) (i64.const 0))
               (i64.const 0) (i64.const 0))
(assert_return (invoke "i64.sub128"
                  (i64.const 0) (i64.const 0)
                  (i64.const 1) (i64.const 0))
               (i64.const 0xffffffffffffffff) (i64.const 0xffffffffffffffff))
(assert_return (invoke "i64.sub128"
                  (i64.const 0) (i64.const 1)
                  (i64.const 1) (i64.const 0))
               (i64.const 0xffffffffffffffff) (i64.const 0))
(assert_return (invoke "i64.sub128"
                  (i64.const 1) (i64.const 2)
                  (i64.const 3) (i64.const 4))
               (i64.const 0xfffffffffffffffe) (i64.const 0xfffffffffffffffd))
