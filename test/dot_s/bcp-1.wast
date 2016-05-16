(module
  (memory 1
    (segment 16 "\00\00\00\00\01\00\00\00\02\00\00\00\03\00\00\00\04\00\00\00\05\00\00\00")
    (segment 40 "\06\00\00\00\07\00\00\00\08\00\00\00")
    (segment 52 "\t\00\00\00\n\00\00\00")
    (segment 60 "\0b\00\00\00\0c\00\00\00\0d\00\00\00")
    (segment 72 "\0e\00\00\00\0f\00\00\00\10\00\00\00")
    (segment 96 "hi\00")
    (segment 100 "\00\00\00\00")
  )
  (export "memory" memory)
  (type $FUNCSIG$i (func (result i32)))
  (type $FUNCSIG$ii (func (param i32) (result i32)))
  (type $FUNCSIG$v (func))
  (type $FUNCSIG$vi (func (param i32)))
  (import $abort "env" "abort")
  (import $exit "env" "exit" (param i32))
  (export "bad0" $bad0)
  (export "bad1" $bad1)
  (export "bad2" $bad2)
  (export "bad3" $bad3)
  (export "bad4" $bad4)
  (export "bad5" $bad5)
  (export "bad6" $bad6)
  (export "bad7" $bad7)
  (export "bad8" $bad8)
  (export "bad9" $bad9)
  (export "bad10" $bad10)
  (export "good0" $good0)
  (export "good1" $good1)
  (export "good2" $good2)
  (export "opt0" $opt0)
  (export "opt1" $opt1)
  (export "opt2" $opt2)
  (export "main" $main)
  (export "dynCall_i" $dynCall_i)
  (export "dynCall_ii" $dynCall_ii)
  (table $bad0 $bad1 $bad5 $bad7 $bad8 $bad10 $bad2 $bad3 $bad6 $bad4 $bad9 $good0 $good1 $good2 $opt0 $opt1 $opt2)
  (func $bad0 (type $FUNCSIG$i) (result i32)
    (return
      (i32.const 0)
    )
  )
  (func $bad1 (type $FUNCSIG$i) (result i32)
    (return
      (i32.const 0)
    )
  )
  (func $bad2 (type $FUNCSIG$ii) (param $$0 i32) (result i32)
    (return
      (i32.const 0)
    )
  )
  (func $bad3 (type $FUNCSIG$ii) (param $$0 i32) (result i32)
    (return
      (i32.const 0)
    )
  )
  (func $bad4 (type $FUNCSIG$ii) (param $$0 i32) (result i32)
    (return
      (i32.const 0)
    )
  )
  (func $bad5 (type $FUNCSIG$i) (result i32)
    (return
      (i32.const 0)
    )
  )
  (func $bad6 (type $FUNCSIG$ii) (param $$0 i32) (result i32)
    (return
      (i32.const 0)
    )
  )
  (func $bad7 (type $FUNCSIG$i) (result i32)
    (return
      (i32.const 0)
    )
  )
  (func $bad8 (type $FUNCSIG$i) (result i32)
    (return
      (i32.const 0)
    )
  )
  (func $bad9 (type $FUNCSIG$ii) (param $$0 i32) (result i32)
    (return
      (i32.const 0)
    )
  )
  (func $bad10 (type $FUNCSIG$i) (result i32)
    (return
      (i32.const 0)
    )
  )
  (func $good0 (type $FUNCSIG$i) (result i32)
    (return
      (i32.const 1)
    )
  )
  (func $good1 (type $FUNCSIG$i) (result i32)
    (return
      (i32.const 1)
    )
  )
  (func $good2 (type $FUNCSIG$i) (result i32)
    (return
      (i32.const 1)
    )
  )
  (func $opt0 (type $FUNCSIG$i) (result i32)
    (return
      (i32.const 0)
    )
  )
  (func $opt1 (type $FUNCSIG$i) (result i32)
    (return
      (i32.const 0)
    )
  )
  (func $opt2 (type $FUNCSIG$i) (result i32)
    (return
      (i32.const 1)
    )
  )
  (func $main (result i32)
    (local $$0 i32)
    (local $$1 i32)
    (local $$2 i32)
    (set_local $$0
      (i32.const 0)
    )
    (block $label$0
      (br_if $label$0
        (call_indirect $FUNCSIG$i
          (i32.load offset=16
            (get_local $$0)
          )
        )
      )
      (br_if $label$0
        (call_indirect $FUNCSIG$i
          (i32.load offset=20
            (get_local $$0)
          )
        )
      )
      (br_if $label$0
        (call_indirect $FUNCSIG$i
          (i32.load offset=24
            (get_local $$0)
          )
        )
      )
      (br_if $label$0
        (call_indirect $FUNCSIG$i
          (i32.load offset=28
            (get_local $$0)
          )
        )
      )
      (br_if $label$0
        (call_indirect $FUNCSIG$i
          (i32.load offset=32
            (get_local $$0)
          )
        )
      )
      (br_if $label$0
        (call_indirect $FUNCSIG$i
          (i32.load offset=36
            (get_local $$0)
          )
        )
      )
      (set_local $$1
        (i32.load offset=40
          (get_local $$0)
        )
      )
      (set_local $$2
        (i32.const 1)
      )
      (block $label$1
        (br_if $label$1
          (call_indirect $FUNCSIG$ii
            (get_local $$1)
            (get_local $$2)
          )
        )
        (br_if $label$1
          (call_indirect $FUNCSIG$ii
            (i32.load offset=44
              (get_local $$0)
            )
            (get_local $$2)
          )
        )
        (br_if $label$1
          (call_indirect $FUNCSIG$ii
            (i32.load offset=48
              (get_local $$0)
            )
            (get_local $$2)
          )
        )
        (set_local $$1
          (i32.load offset=52
            (get_local $$0)
          )
        )
        (set_local $$2
          (i32.const 96)
        )
        (block $label$2
          (br_if $label$2
            (call_indirect $FUNCSIG$ii
              (get_local $$1)
              (get_local $$2)
            )
          )
          (br_if $label$2
            (call_indirect $FUNCSIG$ii
              (i32.load offset=56
                (get_local $$0)
              )
              (get_local $$2)
            )
          )
          (block $label$3
            (br_if $label$3
              (i32.eq
                (call_indirect $FUNCSIG$i
                  (i32.load offset=60
                    (get_local $$0)
                  )
                )
                (i32.const 0)
              )
            )
            (br_if $label$3
              (i32.eq
                (call_indirect $FUNCSIG$i
                  (i32.load offset=64
                    (get_local $$0)
                  )
                )
                (i32.const 0)
              )
            )
            (br_if $label$3
              (i32.eq
                (call_indirect $FUNCSIG$i
                  (i32.load offset=68
                    (get_local $$0)
                  )
                )
                (i32.const 0)
              )
            )
            (block $label$4
              (br_if $label$4
                (i32.eq
                  (call_indirect $FUNCSIG$i
                    (i32.load offset=72
                      (get_local $$0)
                    )
                  )
                  (i32.const 0)
                )
              )
              (br_if $label$4
                (i32.eq
                  (call_indirect $FUNCSIG$i
                    (i32.load offset=76
                      (get_local $$0)
                    )
                  )
                  (i32.const 0)
                )
              )
              (br_if $label$4
                (i32.eq
                  (call_indirect $FUNCSIG$i
                    (i32.load offset=80
                      (get_local $$0)
                    )
                  )
                  (i32.const 0)
                )
              )
              (call_import $exit
                (get_local $$0)
              )
              (unreachable)
            )
            (call_import $abort)
            (unreachable)
          )
          (call_import $abort)
          (unreachable)
        )
        (call_import $abort)
        (unreachable)
      )
      (call_import $abort)
      (unreachable)
    )
    (call_import $abort)
    (unreachable)
  )
  (func $dynCall_i (param $fptr i32) (result i32)
    (return
      (call_indirect $FUNCSIG$i
        (get_local $fptr)
      )
    )
  )
  (func $dynCall_ii (param $fptr i32) (param $$0 i32) (result i32)
    (return
      (call_indirect $FUNCSIG$ii
        (get_local $fptr)
        (get_local $$0)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 104, "initializers": [] }