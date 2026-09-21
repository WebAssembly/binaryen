;; Binary spec test for declarative element segments with GC reftypes.
;; Before the fix, parsing this module failed with "invalid tag index".
;; See https://github.com/WebAssembly/binaryen/issues/8540

(module binary
  "\00asm" "\01\00\00\00"    ;; magic + version

  "\01\1b"                   ;; Type section, 27 bytes
  "\01"                      ;;   1 rec group
  "\4e\06"                   ;;   rec group of size 6
  "\5e\77\00"                ;;   type 0: (array i16)
  "\50\00\5f\00"             ;;   type 1: (sub (struct))
  "\5e\72\01"                ;;   type 2: (array (mut nullexternref))
  "\50\00\60\01\7e\00"       ;;   type 3: (sub (func (param i64)))
  "\5e\7d\01"                ;;   type 4: (array (mut f32))
  "\50\00\5e\7b\01"          ;;   type 5: (sub (array (mut v128)))

  "\03\03\02\03\03"          ;; Function section: 2 funcs, both type 3

  "\09\0f\03"                ;; Element section, 15 bytes
  "\07\63\02\00"             ;;   segment 0: declare (ref null 2), 0 exprs
  "\07\63\03\01\d0\03\0b"    ;;   segment 1: declare (ref null 3) (ref.null 3)
  "\07\71\00"                ;;   segment 2: declare nullref, 0 exprs

  "\0a\07\02"                ;; Code section, 7 bytes
  "\02\00\0b"                ;;   function 0: empty body
  "\02\00\0b"                ;;   function 1: empty body
)
