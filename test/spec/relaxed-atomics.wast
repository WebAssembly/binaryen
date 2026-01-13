(module
 (memory $0 23 256 shared)

 (func $acqrel (result i32)
   (i32.atomic.store acqrel (i32.const 0) (i32.const 0))
   (i32.atomic.load acqrel
    (i32.const 1)
   )
 )
 (func $seqcst (result i32)
   (i32.atomic.store 0 seqcst (i32.const 0) (i32.const 0))
   ;; seqcst may be omitted for atomic loads, it's the default
   (drop (i32.atomic.load seqcst
    (i32.const 1)
   ))
   ;; allows memory index before memory ordering immediate
   (i32.atomic.load 0 seqcst
    (i32.const 1)
   )
 )
)

(assert_malformed
 (module quote
   "(memory $0 23 256 shared)"
   "(func $acqrel (result i32)"
   " (i32.load acqrel"
   "   (i32.const 1)"
   " ) "
   ") "
 )
 "Memory ordering can only be provided for atomic loads."
)

;; Parses acquire-release immediate
;; (module
;;  (memory $0 23 256 shared)
;;  (func $acqrel
;;   (i32.atomic.store (i32.const 0) (i32.const 0))
;;  )
;; )
(module binary
 "\00asm\01\00\00\00"
 "\01\04\01\60\00\00\03\02\01\00\05\05\01\03\17\80\02" ;; other sections
 "\0a\0d\01" ;; code section
   "\0b\00" ;; func $acqrel
   "\41\00\41\00" ;; (i32.const 0) (i32.const 0)
   "\fe\17" ;; i32.atomic.store
   "\22" ;; 2 | (1<<5): Alignment of 2 (32-bit store), with bit 5 set indicating that then next byte is a memory ordering
   "\01" ;; acqrel ordering
   "\00" ;; offset
   "\0b" ;; end
)

;; Parses optional seq-cst immediate
(module binary
 "\00asm\01\00\00\00"
 "\01\04\01\60\00\00\03\02\01\00\05\05\01\03\17\80\02" ;; other sections
 "\0a\0d\01" ;; code section
   "\0b\00" ;; func $seqcst
   "\41\00\41\00" ;; (i32.const 0) (i32.const 0)
   "\fe\17" ;; i32.atomic.store
   "\22" ;; 2 | (1<<5): Alignment of 2 (32-bit store), with bit 5 set indicating that then next byte is a memory ordering
   "\00" ;; seqcst ordering
   "\00" ;; offset
   "\0b" ;; end
)

;; Parses optional seq-cst immediate with memory idx
(module binary
 "\00asm\01\00\00\00"
 "\01\04\01\60\00\00\03\02\01\00\05\05\01\03\17\80\02" ;; other sections
 "\0a\0e\01" ;; code section
   "\0c\00" ;; func $seqcst
   "\41\00\41\00" ;; (i32.const 0) (i32.const 0)
   "\fe\17" ;; i32.atomic.store
   "\62" ;; 2 | (1<<5): Alignment of 2 (32-bit store), with bit 5 set indicating that then next byte is a memory ordering
   "\00" ;; memory index
   "\00" ;; seqcst ordering
   "\00" ;; offset
   "\0b" ;; end
)

;; Parses acquire-release immediate
;; Equivalent to
;; (module
;;  (memory $0 23 256 shared)
;;  (func $load (result i32)
;;    (i32.atomic.load acqrel
;;     (i32.const 1)
;;    )
;;  )
;; )
(module binary
  "\00asm\01\00\00\00" ;; header + version
  "\01\05\01\60\00\01\7f\03\02\01\00\05\05\01\03\17\80\02" ;; other sections
  "\0a\0b\01" ;; code section
    ;; func $load body
    "\09\00" ;; size + decl count
    "\41\01" ;; i32.const 1
    "\fe\10" ;; i32.atomic.load
    "\22" ;; 2 | (1<<5):  Alignment of 2 (32-bit load), with bit 5 set indicating that the next byte is a memory ordering
    "\01" ;; acqrel ordering
    "\00" ;; offset
    "\0b" ;; end
)

;; parses acquire-release immediate after memory index
(module binary
  "\00asm\01\00\00\00" ;; header + version
  "\01\05\01\60\00\01\7f\03\02\01\00\05\05\01\03\17\80\02" ;; other sections
  "\0a\0c\01" ;; code section
    ;; func $load body
    "\0a\00" ;; size + decl count
    "\41\01" ;; i32.const 1
    "\fe\10" ;; i32.atomic.load
    "\62" ;; 2 | (1<<5) | (1<<6):  Alignment of 2 (32-bit load), with bit 5 set indicating that the next byte is a memory ordering
    "\00" ;; memory index
    "\01" ;; acqrel ordering
    "\00" ;; offset
    "\0b" ;; end
)

;; Parses optional seqcst memory ordering for atomic loads
;; This isn't covered by round-trip tests because we omit it by default.
;; Equivalent to
;; (module
;;  (memory $0 23 256 shared)
;;  (func $load (result i32)
;;    (i32.atomic.load seqcst
;;     (i32.const 1)
;;    )
;;  )
;; )
(module binary
  "\00asm\01\00\00\00" ;; header + version
  "\01\05\01\60\00\01\7f\03\02\01\00\05\05\01\03\17\80\02" ;; other sections
  "\0a\0b\01" ;; code section
    ;; func $load body
    "\09\00" ;; size + decl count
    "\41\01" ;; i32.const 1
    "\fe\10" ;; i32.atomic.load
    "\22" ;; 2 | (1<<5):  Alignment of 2 (32-bit load), with bit 5 set indicating that the next byte is a memory ordering
    "\00" ;; seqcst ordering
    "\00" ;; offset
    "\0b" ;; end
)
