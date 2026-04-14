;; Ported from the upstream proposal's tests.
;; TODO: enable the proposal's testsuite and delete this.

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

;; simple subtraction
(assert_return (invoke "i64.sub128"
                  (i64.const 0) (i64.const 0)
                  (i64.const 0) (i64.const 0))
               (i64.const 0) (i64.const 0))
(assert_return (invoke "i64.sub128"
                  (i64.const 0) (i64.const 0)
                  (i64.const 1) (i64.const 0))
               (i64.const -1) (i64.const -1))
(assert_return (invoke "i64.sub128"
                  (i64.const 0) (i64.const 1)
                  (i64.const 1) (i64.const 1))
               (i64.const -1) (i64.const -1))
(assert_return (invoke "i64.sub128"
                  (i64.const 0) (i64.const 0)
                  (i64.const 1) (i64.const 1))
               (i64.const -1) (i64.const -2))

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


;; 20 randomly generated test cases for i64.sub128
(assert_return (invoke "i64.sub128"
                   (i64.const 0) (i64.const -2459085471354756766)
                   (i64.const -9151153060221070927) (i64.const -1))
               (i64.const 9151153060221070927) (i64.const -2459085471354756766))
(assert_return (invoke "i64.sub128"
                   (i64.const 4566502638724063423) (i64.const -4282658540409485563)
                   (i64.const -6884077310018979971) (i64.const -1))
               (i64.const -6996164124966508222) (i64.const -4282658540409485563))
(assert_return (invoke "i64.sub128"
                   (i64.const 1) (i64.const 3118380319444903041)
                   (i64.const 0) (i64.const 3283115686417695443))
               (i64.const 1) (i64.const -164735366972792402))
(assert_return (invoke "i64.sub128"
                   (i64.const -7208415241680161810) (i64.const -1)
                   (i64.const 1) (i64.const 0))
               (i64.const -7208415241680161811) (i64.const -1))
(assert_return (invoke "i64.sub128"
                   (i64.const 0) (i64.const 3944850126731328706)
                   (i64.const 1) (i64.const 1))
               (i64.const -1) (i64.const 3944850126731328704))
(assert_return (invoke "i64.sub128"
                   (i64.const 1) (i64.const -1)
                   (i64.const -1) (i64.const -1))
               (i64.const 2) (i64.const -1))
(assert_return (invoke "i64.sub128"
                   (i64.const -1) (i64.const -1)
                   (i64.const 4855833073346115923) (i64.const -6826437637438999645))
               (i64.const -4855833073346115924) (i64.const 6826437637438999644))
(assert_return (invoke "i64.sub128"
                   (i64.const 1) (i64.const 0)
                   (i64.const -1) (i64.const -1))
               (i64.const 2) (i64.const 0))
(assert_return (invoke "i64.sub128"
                   (i64.const 1) (i64.const 0)
                   (i64.const 1) (i64.const 0))
               (i64.const 0) (i64.const 0))
(assert_return (invoke "i64.sub128"
                   (i64.const -1) (i64.const -1)
                   (i64.const 0) (i64.const 0))
               (i64.const -1) (i64.const -1))
(assert_return (invoke "i64.sub128"
                   (i64.const 1) (i64.const -1)
                   (i64.const -6365475388498096428) (i64.const -1))
               (i64.const 6365475388498096429) (i64.const -1))
(assert_return (invoke "i64.sub128"
                   (i64.const 6804238617560992346) (i64.const -1)
                   (i64.const 0) (i64.const -1))
               (i64.const 6804238617560992346) (i64.const 0))
(assert_return (invoke "i64.sub128"
                   (i64.const 0) (i64.const 1)
                   (i64.const 1) (i64.const -7756145513466453619))
               (i64.const -1) (i64.const 7756145513466453619))
(assert_return (invoke "i64.sub128"
                   (i64.const 1) (i64.const -1)
                   (i64.const 1) (i64.const 1))
               (i64.const 0) (i64.const -2))
(assert_return (invoke "i64.sub128"
                   (i64.const 0) (i64.const 1)
                   (i64.const 1) (i64.const 0))
               (i64.const -1) (i64.const 0))
(assert_return (invoke "i64.sub128"
                   (i64.const 1) (i64.const 5602881641763648953)
                   (i64.const -2110589244314239080) (i64.const -1))
               (i64.const 2110589244314239081) (i64.const 5602881641763648953))
(assert_return (invoke "i64.sub128"
                   (i64.const 0) (i64.const 1)
                   (i64.const -1) (i64.const -1))
               (i64.const 1) (i64.const 1))
(assert_return (invoke "i64.sub128"
                   (i64.const 0) (i64.const -1)
                   (i64.const 3553816990259121806) (i64.const -2105235417856431622))
               (i64.const -3553816990259121806) (i64.const 2105235417856431620))
(assert_return (invoke "i64.sub128"
                   (i64.const 1861102705894987245) (i64.const 1)
                   (i64.const 3713781778534059871) (i64.const 1))
               (i64.const -1852679072639072626) (i64.const -1))
(assert_return (invoke "i64.sub128"
                   (i64.const 0) (i64.const -1)
                   (i64.const 1) (i64.const 1832524486821761762))
               (i64.const -1) (i64.const -1832524486821761764))

;; assert overlong encodings for each instruction's binary encoding are accepted
(module binary
  "\00asm" "\01\00\00\00"

  "\01\0a"                  ;; type section, 10 bytes
  "\01"                     ;; 1 count
  "\60"                     ;; type0 = function
  "\04\7e\7e\7e\7e"         ;;  4 params - all i64
  "\02\7e\7e"               ;;  2 results - both i64

  "\03\03"                  ;; function section, 3 bytes
  "\02"                     ;; 2 count
  "\00\00"                  ;; types of each function (0, 0)

  "\07\1b"                  ;; export section 0x1b bytes
  "\02"                     ;; 2 count
  "\0ai64.add128\00\00"     ;; "i64.add128" which is function 0
  "\0ai64.sub128\00\01"     ;; "i64.sub128" which is function 1

  "\0a\1e"                  ;; code section + byte length (30 bytes = 0x1e)
  "\02"                     ;; 2 count

  "\0e"                     ;; byte length
  "\00"                     ;; no locals
  "\20\00"                  ;; local.get 0
  "\20\01"                  ;; local.get 1
  "\20\02"                  ;; local.get 2
  "\20\03"                  ;; local.get 3
  "\fc\93\80\00"            ;; i64.add128 (overlong)
  "\0b"                     ;; end

  "\0d"                     ;; byte length
  "\00"                     ;; no locals
  "\20\00"                  ;; local.get 0
  "\20\01"                  ;; local.get 1
  "\20\02"                  ;; local.get 2
  "\20\03"                  ;; local.get 3
  "\fc\94\00"               ;; i64.sub128 (overlong)
  "\0b"                     ;; end
)

(assert_return (invoke "i64.add128"
                  (i64.const 1) (i64.const 2)
                  (i64.const 3) (i64.const 4))
               (i64.const 4) (i64.const 6))
(assert_return (invoke "i64.sub128"
                  (i64.const 2) (i64.const 5)
                  (i64.const 1) (i64.const 2))
               (i64.const 1) (i64.const 3))

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

(assert_invalid
  (module
    (func (param i64 i64 i64 i64) (result i64)
      local.get 0
      local.get 1
      local.get 2
      local.get 3
      i64.sub128)
  )
  "type mismatch")
(assert_invalid
  (module
    (func (param i64 i64 i64) (result i64 i64)
      local.get 0
      local.get 1
      local.get 2
      i64.sub128)
  )
  "type mismatch")
