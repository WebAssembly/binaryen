(module
  (memory 1 1 shared)
  (memory 1 1 shared)

  (func $no_ordering_without_memid
    (drop (i32.atomic.load (i32.const 51)))
    (i32.atomic.store (i32.const 51) (i32.const 51))
    (drop (i32.atomic.rmw.add (i32.const 51) (i32.const 51)))
  )

  (func $acqrel_without_memid
    (drop (i32.atomic.load acqrel (i32.const 51)))
    (i32.atomic.store acqrel (i32.const 51) (i32.const 51))
    (drop (i32.atomic.rmw.add acqrel (i32.const 51) (i32.const 51)))
  )

  (func $seqcst_without_memid
    (drop (i32.atomic.load seqcst (i32.const 51)))
    (i32.atomic.store seqcst (i32.const 51) (i32.const 51))
    (drop (i32.atomic.rmw.add seqcst (i32.const 51) (i32.const 51)))
  )

  (func $no_ordering_with_memid
    (drop (i32.atomic.load 1 (i32.const 51)))
    (i32.atomic.store 1 (i32.const 51) (i32.const 51))
    (drop (i32.atomic.rmw.add 1 (i32.const 51) (i32.const 51)))
  )

  (func $acqrel_with_memid
    (drop (i32.atomic.load 1 acqrel (i32.const 51)))
    (i32.atomic.store 1 acqrel (i32.const 51) (i32.const 51))
    (drop (i32.atomic.rmw.add 1 acqrel (i32.const 51) (i32.const 51)))
  )

  (func $seqcst_with_memid
    (drop (i32.atomic.load 1 seqcst (i32.const 51)))
    (i32.atomic.store 1 seqcst (i32.const 51) (i32.const 51))
    (drop (i32.atomic.rmw.add 1 seqcst (i32.const 51) (i32.const 51)))
  )
)

(module binary
  "\00asm\01\00\00\00" ;; header + version
  "\01\05\01\60\00\01\7f\03\02\01\00\05\05\01\03\17\80\02" ;; other sections
  "\0a\0c\01" ;; code section
    "\0a\00" ;; func size + decl count
    "\41\33" ;; i32.const 51
    "\fe\10" ;; i32.atomic.load
    "\62" ;; 2 | (1<<5) | (1<<6):  Alignment of 2 (32-bit load), with bit 5 set indicating that the next byte is a memory ordering
    "\00" ;; memory index
    "\01" ;; acqrel ordering
    "\00" ;; offset
    "\0b" ;; end
)

(module binary
  "\00\61\73\6d\01\00\00\00\01\04\01\60\00\00\03\07\06\00\00\00\00\00\00\05\07\02\03\01\01\03\01\01"
  "\0a\b8\01\06" ;; code section
  "\1a\00" ;; func
  "\41\33\fe\10\02\00\1a" ;; (drop (i32.atomic.load (i32.const 51)))
  "\41\33\41\33\fe\17\02\00" ;; (i32.atomic.store (i32.const 51) (i32.const 51))
  "\41\33\41\33\fe\1e\02\00\1a\0b" ;; (drop (i32.atomic.rmw.add (i32.const 51) (i32.const 51)))
  "\1d\00" ;; func
  "\41\33\fe\10\22\00\00\1a" ;; (drop (i32.atomic.load seqcst (i32.const 51)))
  "\41\33\41\33\fe\17\22\00\00" ;; (i32.atomic.store seqcst (i32.const 51) (i32.const 51))
  "\41\33\41\33\fe\1e\22\00\00\1a\0b" ;; (drop (i32.atomic.rmw.add seqcst (i32.const 51) (i32.const 51)))
  "\1d\00" ;; func
  "\41\33\fe\10\22\01\00\1a" ;; (drop (i32.atomic.load acqrel (i32.const 51)))
  "\41\33\41\33\fe\17\22\01\00" ;; (i32.atomic.store acqrel (i32.const 51) (i32.const 51))
  "\41\33\41\33\fe\1e\22\11\00\1a\0b" ;; (drop (i32.atomic.rmw.add acqrel (i32.const 51) (i32.const 51)))
  "\1d\00" ;; func
  "\41\33\fe\10\42\01\00\1a" ;; (drop (i32.atomic.load 1 (i32.const 51)))
  "\41\33\41\33\fe\17\42\01\00" ;; (i32.atomic.store 1 (i32.const 51) (i32.const 51))
  "\41\33\41\33\fe\1e\42\01\00\1a\0b" ;; (drop (i32.atomic.rmw.add 1 (i32.const 51) (i32.const 51)))
  "\20\00" ;; func
  "\41\33\fe\10\62\01\00\00\1a" ;; (drop (i32.atomic.load 1 seqcst (i32.const 51)))
  "\41\33\41\33\fe\17\62\01\00\00" ;; (i32.atomic.store 1 seqcst (i32.const 51) (i32.const 51))
  "\41\33\41\33\fe\1e\62\01\00\00\1a\0b" ;; (drop (i32.atomic.rmw.add 1 seqcst (i32.const 51) (i32.const 51)))
  "\20\00" ;; func
  "\41\33\fe\10\62\01\01\00\1a" ;; (drop (i32.atomic.load 1 acqrel (i32.const 51)))
  "\41\33\41\33\fe\17\62\01\01\00" ;; (i32.atomic.store 1 acqrel (i32.const 51) (i32.const 51))
  "\41\33\41\33\fe\1e\62\01\11\00\1a\0b" ;; (drop (i32.atomic.rmw.add 1 acqrel (i32.const 51) (i32.const 51)))
)

(assert_invalid (module
  (memory 1 1 shared)

  (func $i32load (drop (i32.load acqrel (i32.const 51))))
) "Can't set memory ordering for non-atomic i32.load")

