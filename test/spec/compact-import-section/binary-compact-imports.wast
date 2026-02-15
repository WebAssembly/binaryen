;; Auxiliary modules to import

(module
  (func (export "b") (result i32) (i32.const 0x0f))
  (func (export "c") (result i32) (i32.const 0xf0))
)
(register "a")
(module
  (func (export "") (result i32) (i32.const 0xab))
)
(register "")


;; Valid compact encodings

(module binary
  "\00asm" "\01\00\00\00"
  "\01\05\01\60\00\01\7f"     ;; Type section: (type (func (result i32)))
  "\02\0e"                    ;; Import section
  "\01"                       ;;   1 group
  "\01a"                      ;;     "a"
  "\00" "\7f"                 ;;     "" + 0x7f (compact encoding)
  "\02"                       ;;     2 items
  "\01b" "\00\00"             ;;       "b" (func (type 0))
  "\01c" "\00\00"             ;;       "c" (func (type 0))
  "\03\02" "\01"              ;; Function section, 1 func
  "\00"                       ;;   func 2: type 0
  "\07\08" "\01"              ;; Export section, 1 export
  "\04test" "\00\02"          ;;   "test" func 2
  "\0a\09" "\01"              ;; Code section, 1 func
  "\07" "\00"                 ;;   len, 0 locals
  "\10\00"                    ;;   call 0
  "\10\01"                    ;;   call 1
  "\6a"                       ;;   i32.add
  "\0b"                       ;;   end
)
(assert_return (invoke "test") (i32.const 0xff))

(module binary
  "\00asm" "\01\00\00\00"
  "\01\05\01\60\00\01\7f"     ;; Type section: (type (func (result i32)))
  "\02\0c"                    ;; Import section
  "\01"                       ;;   1 group
  "\01a"                      ;;     "a"
  "\00" "\7e"                 ;;     "" + 0x7e (compact encoding)
  "\00\00"                    ;;     (func (type 0))
  "\02"                       ;;     2 items
  "\01b"                      ;;       "b"
  "\01c"                      ;;       "c"
  "\03\02" "\01"              ;; Function section, 1 func
  "\00"                       ;;   func 2: type 0
  "\07\08" "\01"              ;; Export section, 1 export
  "\04test" "\00\02"          ;;   "test" func 2
  "\0a\09" "\01"              ;; Code section, 1 func
  "\07" "\00"                 ;;   len, 0 locals
  "\10\00"                    ;;   call 0
  "\10\01"                    ;;   call 1
  "\6a"                       ;;   i32.add
  "\0b"                       ;;   end
)
(assert_return (invoke "test") (i32.const 0xff))


;; Overly-long empty name encodings are valid

(module binary
  "\00asm" "\01\00\00\00"
  "\01\05\01\60\00\01\7f"     ;; Type section: (type (func (result i32)))
  "\02\11"                    ;; Import section
  "\01"                       ;;   1 group
  "\01a"                      ;;     "a"
  "\80\80\80\00" "\7f"        ;;     "" (long encoding) + 0x7f
  "\02"                       ;;     2 items
  "\01b" "\00\00"             ;;       "b" (func (type 0))
  "\01c" "\00\00"             ;;       "c" (func (type 0))
)
(module binary
  "\00asm" "\01\00\00\00"
  "\01\05\01\60\00\01\7f"     ;; Type section: (type (func (result i32)))
  "\02\0f"                    ;; Import section
  "\01"                       ;;   1 group
  "\01a"                      ;;     "a"
  "\80\80\80\00" "\7e"        ;;     "" (long encoding) + 0x7e
  "\00\00"                    ;;     (func (type 0))
  "\02"                       ;;     2 items
  "\01b"                      ;;       "b"
  "\01c"                      ;;       "c"
)


;; Discriminator is not valid except after empty names

(assert_malformed
  (module binary
    "\00asm" "\01\00\00\00"
    "\01\05\01\60\00\01\7f"   ;; Type section: (type (func (result i32)))
    "\02\12"                  ;; Import section
    "\01"                     ;;   1 group
    "\01a"                    ;;     "a"
    "\01b" "\7f"              ;;     "b" + 0x7f
    "\02"                     ;;     2 items
    "\01b" "\00\00"           ;;       "b" (func (type 0))
    "\01c" "\00\00"           ;;       "c" (func (type 0))
  )
  "malformed import kind"
)
(assert_malformed
  (module binary
    "\00asm" "\01\00\00\00"
    "\01\05\01\60\00\01\7f"   ;; Type section: (type (func (result i32)))
    "\02\10"                  ;; Import section
    "\01"                     ;;   1 group
    "\01a"                    ;;     "a"
    "\01b" "\7e"              ;;     "" + 0x7e (long encoding)
    "\00\00"                  ;;     (func (type 0))
    "\02"                     ;;     2 items
    "\01b"                    ;;       "b"
    "\01c"                    ;;       "c"
  )
  "malformed import kind"
)


;; Discriminator is not to be interpreted as LEB128

(assert_malformed
  (module binary
    "\00asm" "\01\00\00\00"
    "\01\05\01\60\00\01\7f"   ;; Type section: (type (func (result i32)))
    "\02\11"                  ;; Import section
    "\01"                     ;;   1 group
    "\01a"                    ;;     "a"
    "\00\ff\80\80\00"         ;;     "" + 0x7f (long encoding)
    "\02"                     ;;     2 items
    "\01b" "\00\00"           ;;       "b" (func (type 0))
    "\01c" "\00\00"           ;;       "c" (func (type 0))
  )
  "malformed import kind"
)
(assert_malformed
  (module binary
    "\00asm" "\01\00\00\00"
    "\01\05\01\60\00\01\7f"   ;; Type section: (type (func (result i32)))
    "\02\0f"                  ;; Import section
    "\01"                     ;;   1 group
    "\01a"                    ;;     "a"
    "\00\fe\80\80\00"         ;;     "" + 0x7e (long encoding)
    "\00\00"                  ;;     (func (type 0))
    "\02"                     ;;     2 items
    "\01b"                    ;;       "b"
    "\01c"                    ;;       "c"
  )
  "malformed import kind"
)


;; Empty names are still valid if not followed by a discriminator

(module binary
  "\00asm" "\01\00\00\00"
  "\01\05\01\60\00\01\7f"     ;; Type section: (type (func (result i32)))
  "\02\05"                    ;; Import section
  "\01"                       ;;   1 group
  "\00\00\00\00"              ;;     "" "" (func (type 0))
  "\03\02" "\01"              ;; Function section, 1 func
  "\00"                       ;;   func 1: type 0
  "\07\08" "\01"              ;; Export section, 1 export
  "\04test" "\00\01"          ;;   "test" func 1
  "\0a\06" "\01"              ;; Code section, 1 func
  "\04" "\00"                 ;;   len, 0 locals
  "\10\00"                    ;;   call 0
  "\0b"                       ;;   end
)
(assert_return (invoke "test") (i32.const 0xab))
