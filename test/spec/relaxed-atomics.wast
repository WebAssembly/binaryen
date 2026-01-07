(module
  (memory 1 1 shared)
  (memory 1 1 shared)

  (func $no_immediate_without_memid
    (drop (i32.atomic.load (i32.const 51)))
    (i32.atomic.store (i32.const 51) (i32.const 51))
  )

  (func $acqrel_without_memid
    (drop (i32.atomic.load acqrel (i32.const 51)))
    (i32.atomic.store acqrel (i32.const 51) (i32.const 51))
  )

  (func $seqcst_without_memid
    (drop (i32.atomic.load seqcst (i32.const 51)))
    (i32.atomic.store seqcst (i32.const 51) (i32.const 51))
  )

  (func $no_immediate_with_memid
    (drop (i32.atomic.load 1 (i32.const 51)))
    (i32.atomic.store 1 (i32.const 51) (i32.const 51))
  )

  (func $acqrel_with_memid
    (drop (i32.atomic.load 1 acqrel (i32.const 51)))
    (i32.atomic.store 1 acqrel (i32.const 51) (i32.const 51))
  )

  (func $seqcst_with_memid
    (drop (i32.atomic.load 1 seqcst (i32.const 51)))
    (i32.atomic.store 1 seqcst (i32.const 51) (i32.const 51))
  )
)
(module binary
  "\00\61\73\6d\01\00\00\00\01\04\01\60\00\00\03\07\06\00\00\00\00\00\00\05\07\02\03\01\01\03\01\01" ;; other sections
  "\0a\7b\06" ;; code section
  "\11\00" ;; func $no_immediate_without_memid
  "\41\33\fe\10\02\00\1a" ;; drop (i32.atomic.load (i32.const 51))
  "\41\33\41\33\fe\17\02\00\0b" ;; (i32.atomic.store (i32.const 51) (i32.const 51))
  "\13\00" ;; func $acqrel_without_memid
  "\41\33\fe\10\22\01\00\1a" ;; (drop (i32.atomic.load acqrel (i32.const 51)))
  "\41\33\41\33\fe\17\22\01\00\0b" ;; (i32.atomic.store acqrel (i32.const 51) (i32.const 51))
  "\13\00" ;; func $seqcst_without_memid
  "\41\33\fe\10\22\00\00\1a" ;; (drop (i32.atomic.load seqcst (i32.const 51)))
  "\41\33\41\33\fe\17\22\00\00\0b" ;; (i32.atomic.store seqcst (i32.const 51) (i32.const 51))
  "\13\00" ;; func $no_immediate_with_memid
  "\41\33\fe\10\42\01\00\1a" ;; (drop (i32.atomic.load 1 (i32.const 51)))
  "\41\33\41\33\fe\17\42\01\00\0b" ;; (i32.atomic.store 1 (i32.const 51) (i32.const 51))
  "\15\00" ;; func $acqrel_with_memid
  "\41\33\fe\10\62\01\01\00\1a" ;; (drop (i32.atomic.load 1 acqrel (i32.const 51)))
  "\41\33\41\33\fe\17\62\01\01\00\0b" ;; (i32.atomic.store 1 acqrel (i32.const 51) (i32.const 51))
  "\15\00" ;; func $seqcst_with_memid
  "\41\33\fe\10\62\01\00\00\1a" ;; (drop (i32.atomic.load 1 seqcst (i32.const 51)))
  "\41\33\41\33\fe\17\62\01\00\00\0b" ;; (i32.atomic.store 1 seqcst (i32.const 51) (i32.const 51))
  )

(assert_invalid (module
  (memory 1 1 shared)

  (func $i32load (drop (i32.load acqrel (i32.const 51))))
) "Can't set memory ordering for non-atomic i32.load")
