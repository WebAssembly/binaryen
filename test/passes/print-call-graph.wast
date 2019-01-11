(module
  (type $FUNCSIG$iiii (func (param i32 i32 i32) (result i32)))
  (type $FUNCSIG$v (func))
  (type $FUNCSIG$ii (func (param i32) (result i32)))
  (type $FUNCSIG$vi (func (param i32)))
  (type $FUNCSIG$iii (func (param i32 i32) (result i32)))
  (type $FUNCSIG$vii (func (param i32 i32)))
  (import "env" "STACKTOP" (global $STACKTOP$asm2wasm$import i32))
  (import "env" "STACK_MAX" (global $STACK_MAX$asm2wasm$import i32))
  (import "env" "DYNAMICTOP_PTR" (global $DYNAMICTOP_PTR$asm2wasm$import i32))
  (import "env" "tempDoublePtr" (global $tempDoublePtr$asm2wasm$import i32))
  (import "env" "ABORT" (global $ABORT$asm2wasm$import i32))
  (import "global" "NaN" (global $nan$asm2wasm$import f64))
  (import "global" "Infinity" (global $inf$asm2wasm$import f64))
  (import "env" "abort" (func $abort (param i32)))
  (import "env" "_pthread_cleanup_pop" (func $_pthread_cleanup_pop (param i32)))
  (import "env" "___lock" (func $___lock (param i32)))
  (import "env" "___syscall6" (func $___syscall6 (param i32 i32) (result i32)))
  (import "env" "_pthread_cleanup_push" (func $_pthread_cleanup_push (param i32 i32)))
  (import "env" "___syscall140" (func $___syscall140 (param i32 i32) (result i32)))
  (import "env" "_emscripten_memcpy_big" (func $_emscripten_memcpy_big (param i32 i32 i32) (result i32)))
  (import "env" "___syscall54" (func $___syscall54 (param i32 i32) (result i32)))
  (import "env" "___unlock" (func $___unlock (param i32)))
  (import "env" "___syscall146" (func $___syscall146 (param i32 i32) (result i32)))
  (import "env" "memory" (memory $0 256 256))
  (import "env" "table" (table 9 9 funcref))
  (import "env" "memoryBase" (global $memoryBase i32))
  (import "env" "tableBase" (global $tableBase i32))
  (elem (i32.const 0) $b0 $___stdio_close $b1 $___stdout_write $___stdio_seek $___stdio_write $b2 $_cleanup_387 $b3)
  (data (global.get $memoryBase) "\05\00\00\00\00\00\00\00\00\00\00\00\01\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\01\00\00\00\02\00\00\00\b0\04\00\00\00\04\00\00\00\00\00\00\00\00\00\00\01\00\00\00\00\00\00\00\00\00\00\00\00\00\00\n\ff\ff\ff\ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04")
  (global $STACKTOP (mut i32) (global.get $STACKTOP$asm2wasm$import))
  (global $STACK_MAX (mut i32) (global.get $STACK_MAX$asm2wasm$import))
  (global $DYNAMICTOP_PTR (mut i32) (global.get $DYNAMICTOP_PTR$asm2wasm$import))
  (global $tempDoublePtr (mut i32) (global.get $tempDoublePtr$asm2wasm$import))
  (global $ABORT (mut i32) (global.get $ABORT$asm2wasm$import))
  (global $__THREW__ (mut i32) (i32.const 0))
  (global $threwValue (mut i32) (i32.const 0))
  (global $setjmpId (mut i32) (i32.const 0))
  (global $undef (mut i32) (i32.const 0))
  (global $nan (mut f64) (global.get $nan$asm2wasm$import))
  (global $inf (mut f64) (global.get $inf$asm2wasm$import))
  (global $tempInt (mut i32) (i32.const 0))
  (global $tempBigInt (mut i32) (i32.const 0))
  (global $tempBigIntP (mut i32) (i32.const 0))
  (global $tempBigIntS (mut i32) (i32.const 0))
  (global $tempBigIntR (mut f64) (f64.const 0))
  (global $tempBigIntI (mut i32) (i32.const 0))
  (global $tempBigIntD (mut i32) (i32.const 0))
  (global $tempValue (mut i32) (i32.const 0))
  (global $tempDouble (mut f64) (f64.const 0))
  (global $tempRet0 (mut i32) (i32.const 0))
  (global $tempFloat (mut f32) (f32.const 0))
  (global $f0 (mut f32) (f32.const 0))
  (export "_fflush" (func $_fflush))
  (export "_main" (func $_main))
  (export "_pthread_self" (func $_pthread_self))
  (export "_memset" (func $_memset))
  (export "_malloc" (func $_malloc))
  (export "_memcpy" (func $_memcpy))
  (export "_free" (func $_free))
  (export "___errno_location" (func $___errno_location))
  (export "runPostSets" (func $runPostSets))
  (export "stackAlloc" (func $stackAlloc))
  (export "stackSave" (func $stackSave))
  (export "stackRestore" (func $stackRestore))
  (export "establishStackSpace" (func $establishStackSpace))
  (export "setThrew" (func $setThrew))
  (export "setTempRet0" (func $setTempRet0))
  (export "getTempRet0" (func $getTempRet0))
  (export "dynCall_ii" (func $dynCall_ii))
  (export "dynCall_iiii" (func $dynCall_iiii))
  (export "dynCall_vi" (func $dynCall_vi))
  (export "dynCall_v" (func $dynCall_v))
  (func $stackAlloc (param $0 i32) (result i32)
    (local $1 i32)
    (local.set $1
      (global.get $STACKTOP)
    )
    (global.set $STACKTOP
      (i32.add
        (global.get $STACKTOP)
        (local.get $0)
      )
    )
    (global.set $STACKTOP
      (i32.and
        (i32.add
          (global.get $STACKTOP)
          (i32.const 15)
        )
        (i32.const -16)
      )
    )
    (local.get $1)
  )
  (func $stackSave (result i32)
    (global.get $STACKTOP)
  )
  (func $stackRestore (param $0 i32)
    (global.set $STACKTOP
      (local.get $0)
    )
  )
  (func $establishStackSpace (param $0 i32) (param $1 i32)
    (global.set $STACKTOP
      (local.get $0)
    )
    (global.set $STACK_MAX
      (local.get $1)
    )
  )
  (func $setThrew (param $0 i32) (param $1 i32)
    (if
      (i32.eqz
        (global.get $__THREW__)
      )
      (block
        (global.set $__THREW__
          (local.get $0)
        )
        (global.set $threwValue
          (local.get $1)
        )
      )
    )
  )
  (func $setTempRet0 (param $0 i32)
    (global.set $tempRet0
      (local.get $0)
    )
  )
  (func $getTempRet0 (result i32)
    (global.get $tempRet0)
  )
  (func $_malloc (param $0 i32) (result i32)
    (i32.const 0)
  )
  (func $_free (param $0 i32)
    (nop)
  )
  (func $_main (result i32)
    (local $0 i32)
    (i64.store align=4
      (local.tee $0
        (call $__Znwj
          (i32.const 8)
        )
      )
      (i64.const 0)
    )
    (local.get $0)
  )
  (func $___stdio_close (param $0 i32) (result i32)
    (local $1 i32)
    (local $2 i32)
    (local.set $1
      (global.get $STACKTOP)
    )
    (global.set $STACKTOP
      (i32.add
        (global.get $STACKTOP)
        (i32.const 16)
      )
    )
    (i32.store
      (local.tee $2
        (local.get $1)
      )
      (i32.load offset=60
        (local.get $0)
      )
    )
    (local.set $0
      (call $___syscall_ret
        (call $___syscall6
          (i32.const 6)
          (local.get $2)
        )
      )
    )
    (global.set $STACKTOP
      (local.get $1)
    )
    (local.get $0)
  )
  (func $___stdio_write (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (local $3 i32)
    (local $4 i32)
    (local $5 i32)
    (local $6 i32)
    (local $7 i32)
    (local $8 i32)
    (local $9 i32)
    (local $10 i32)
    (local $11 i32)
    (local $12 i32)
    (local $13 i32)
    (local $14 i32)
    (local.set $7
      (global.get $STACKTOP)
    )
    (global.set $STACKTOP
      (i32.add
        (global.get $STACKTOP)
        (i32.const 48)
      )
    )
    (local.set $8
      (i32.add
        (local.get $7)
        (i32.const 16)
      )
    )
    (local.set $9
      (local.get $7)
    )
    (i32.store
      (local.tee $3
        (i32.add
          (local.get $7)
          (i32.const 32)
        )
      )
      (local.tee $5
        (i32.load
          (local.tee $6
            (i32.add
              (local.get $0)
              (i32.const 28)
            )
          )
        )
      )
    )
    (i32.store offset=4
      (local.get $3)
      (local.tee $4
        (i32.sub
          (i32.load
            (local.tee $10
              (i32.add
                (local.get $0)
                (i32.const 20)
              )
            )
          )
          (local.get $5)
        )
      )
    )
    (i32.store offset=8
      (local.get $3)
      (local.get $1)
    )
    (i32.store offset=12
      (local.get $3)
      (local.get $2)
    )
    (local.set $13
      (i32.add
        (local.get $0)
        (i32.const 60)
      )
    )
    (local.set $14
      (i32.add
        (local.get $0)
        (i32.const 44)
      )
    )
    (local.set $1
      (local.get $3)
    )
    (local.set $5
      (i32.const 2)
    )
    (local.set $11
      (i32.add
        (local.get $4)
        (local.get $2)
      )
    )
    (local.set $0
      (block $jumpthreading$outer$1 (result i32)
        (block $jumpthreading$inner$1
          (block $jumpthreading$inner$0
            (loop $while-in
              (br_if $jumpthreading$inner$0
                (i32.eq
                  (local.get $11)
                  (local.tee $4
                    (if (result i32)
                      (i32.load
                        (i32.const 1140)
                      )
                      (block (result i32)
                        (call $_pthread_cleanup_push
                          (i32.const 1)
                          (local.get $0)
                        )
                        (i32.store
                          (local.get $9)
                          (i32.load
                            (local.get $13)
                          )
                        )
                        (i32.store offset=4
                          (local.get $9)
                          (local.get $1)
                        )
                        (i32.store offset=8
                          (local.get $9)
                          (local.get $5)
                        )
                        (local.set $3
                          (call $___syscall_ret
                            (call $___syscall146
                              (i32.const 146)
                              (local.get $9)
                            )
                          )
                        )
                        (call $_pthread_cleanup_pop
                          (i32.const 0)
                        )
                        (local.get $3)
                      )
                      (block (result i32)
                        (i32.store
                          (local.get $8)
                          (i32.load
                            (local.get $13)
                          )
                        )
                        (i32.store offset=4
                          (local.get $8)
                          (local.get $1)
                        )
                        (i32.store offset=8
                          (local.get $8)
                          (local.get $5)
                        )
                        (call $___syscall_ret
                          (call $___syscall146
                            (i32.const 146)
                            (local.get $8)
                          )
                        )
                      )
                    )
                  )
                )
              )
              (br_if $jumpthreading$inner$1
                (i32.lt_s
                  (local.get $4)
                  (i32.const 0)
                )
              )
              (local.set $11
                (i32.sub
                  (local.get $11)
                  (local.get $4)
                )
              )
              (local.set $1
                (if (result i32)
                  (i32.gt_u
                    (local.get $4)
                    (local.tee $12
                      (i32.load offset=4
                        (local.get $1)
                      )
                    )
                  )
                  (block (result i32)
                    (i32.store
                      (local.get $6)
                      (local.tee $3
                        (i32.load
                          (local.get $14)
                        )
                      )
                    )
                    (i32.store
                      (local.get $10)
                      (local.get $3)
                    )
                    (local.set $4
                      (i32.sub
                        (local.get $4)
                        (local.get $12)
                      )
                    )
                    (local.set $3
                      (i32.add
                        (local.get $1)
                        (i32.const 8)
                      )
                    )
                    (local.set $5
                      (i32.add
                        (local.get $5)
                        (i32.const -1)
                      )
                    )
                    (i32.load offset=12
                      (local.get $1)
                    )
                  )
                  (if (result i32)
                    (i32.eq
                      (local.get $5)
                      (i32.const 2)
                    )
                    (block (result i32)
                      (i32.store
                        (local.get $6)
                        (i32.add
                          (i32.load
                            (local.get $6)
                          )
                          (local.get $4)
                        )
                      )
                      (local.set $3
                        (local.get $1)
                      )
                      (local.set $5
                        (i32.const 2)
                      )
                      (local.get $12)
                    )
                    (block (result i32)
                      (local.set $3
                        (local.get $1)
                      )
                      (local.get $12)
                    )
                  )
                )
              )
              (i32.store
                (local.get $3)
                (i32.add
                  (i32.load
                    (local.get $3)
                  )
                  (local.get $4)
                )
              )
              (i32.store offset=4
                (local.get $3)
                (i32.sub
                  (local.get $1)
                  (local.get $4)
                )
              )
              (local.set $1
                (local.get $3)
              )
              (br $while-in)
            )
          )
          (i32.store offset=16
            (local.get $0)
            (i32.add
              (local.tee $1
                (i32.load
                  (local.get $14)
                )
              )
              (i32.load offset=48
                (local.get $0)
              )
            )
          )
          (i32.store
            (local.get $6)
            (local.tee $0
              (local.get $1)
            )
          )
          (i32.store
            (local.get $10)
            (local.get $0)
          )
          (br $jumpthreading$outer$1
            (local.get $2)
          )
        )
        (i32.store offset=16
          (local.get $0)
          (i32.const 0)
        )
        (i32.store
          (local.get $6)
          (i32.const 0)
        )
        (i32.store
          (local.get $10)
          (i32.const 0)
        )
        (i32.store
          (local.get $0)
          (i32.or
            (i32.load
              (local.get $0)
            )
            (i32.const 32)
          )
        )
        (select
          (i32.const 0)
          (i32.sub
            (local.get $2)
            (i32.load offset=4
              (local.get $1)
            )
          )
          (i32.eq
            (local.get $5)
            (i32.const 2)
          )
        )
      )
    )
    (global.set $STACKTOP
      (local.get $7)
    )
    (local.get $0)
  )
  (func $___stdio_seek (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (local $3 i32)
    (local $4 i32)
    (local.set $4
      (global.get $STACKTOP)
    )
    (global.set $STACKTOP
      (i32.add
        (global.get $STACKTOP)
        (i32.const 32)
      )
    )
    (i32.store
      (local.tee $3
        (local.get $4)
      )
      (i32.load offset=60
        (local.get $0)
      )
    )
    (i32.store offset=4
      (local.get $3)
      (i32.const 0)
    )
    (i32.store offset=8
      (local.get $3)
      (local.get $1)
    )
    (i32.store offset=12
      (local.get $3)
      (local.tee $0
        (i32.add
          (local.get $4)
          (i32.const 20)
        )
      )
    )
    (i32.store offset=16
      (local.get $3)
      (local.get $2)
    )
    (local.set $0
      (if (result i32)
        (i32.lt_s
          (call $___syscall_ret
            (call $___syscall140
              (i32.const 140)
              (local.get $3)
            )
          )
          (i32.const 0)
        )
        (block (result i32)
          (i32.store
            (local.get $0)
            (i32.const -1)
          )
          (i32.const -1)
        )
        (i32.load
          (local.get $0)
        )
      )
    )
    (global.set $STACKTOP
      (local.get $4)
    )
    (local.get $0)
  )
  (func $___syscall_ret (param $0 i32) (result i32)
    (if (result i32)
      (i32.gt_u
        (local.get $0)
        (i32.const -4096)
      )
      (block (result i32)
        (i32.store
          (call $___errno_location)
          (i32.sub
            (i32.const 0)
            (local.get $0)
          )
        )
        (i32.const -1)
      )
      (local.get $0)
    )
  )
  (func $___errno_location (result i32)
    (if (result i32)
      (i32.load
        (i32.const 1140)
      )
      (i32.load offset=64
        (call $_pthread_self)
      )
      (i32.const 1184)
    )
  )
  (func $_cleanup_387 (param $0 i32)
    (if
      (i32.eqz
        (i32.load offset=68
          (local.get $0)
        )
      )
      (call $_free
        (local.get $0)
      )
    )
  )
  (func $___stdout_write (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (local $3 i32)
    (local $4 i32)
    (local $5 i32)
    (local.set $4
      (global.get $STACKTOP)
    )
    (global.set $STACKTOP
      (i32.add
        (global.get $STACKTOP)
        (i32.const 80)
      )
    )
    (local.set $3
      (local.get $4)
    )
    (local.set $5
      (i32.add
        (local.get $4)
        (i32.const 12)
      )
    )
    (i32.store offset=36
      (local.get $0)
      (i32.const 3)
    )
    (if
      (i32.eqz
        (i32.and
          (i32.load
            (local.get $0)
          )
          (i32.const 64)
        )
      )
      (block
        (i32.store
          (local.get $3)
          (i32.load offset=60
            (local.get $0)
          )
        )
        (i32.store offset=4
          (local.get $3)
          (i32.const 21505)
        )
        (i32.store offset=8
          (local.get $3)
          (local.get $5)
        )
        (if
          (call $___syscall54
            (i32.const 54)
            (local.get $3)
          )
          (i32.store8 offset=75
            (local.get $0)
            (i32.const -1)
          )
        )
      )
    )
    (local.set $0
      (call $___stdio_write
        (local.get $0)
        (local.get $1)
        (local.get $2)
      )
    )
    (global.set $STACKTOP
      (local.get $4)
    )
    (local.get $0)
  )
  (func $_fflush (param $0 i32) (result i32)
    (local $1 i32)
    (local $2 i32)
    (block $do-once (result i32)
      (if (result i32)
        (local.get $0)
        (block (result i32)
          (if
            (i32.le_s
              (i32.load offset=76
                (local.get $0)
              )
              (i32.const -1)
            )
            (br $do-once
              (call $___fflush_unlocked
                (local.get $0)
              )
            )
          )
          (local.set $2
            (i32.eqz
              (call $_malloc
                (local.get $0)
              )
            )
          )
          (local.set $1
            (call $___fflush_unlocked
              (local.get $0)
            )
          )
          (if (result i32)
            (local.get $2)
            (local.get $1)
            (block (result i32)
              (call $_free
                (local.get $0)
              )
              (local.get $1)
            )
          )
        )
        (block (result i32)
          (local.set $0
            (if (result i32)
              (i32.load
                (i32.const 1136)
              )
              (call $_fflush
                (i32.load
                  (i32.const 1136)
                )
              )
              (i32.const 0)
            )
          )
          (call $___lock
            (i32.const 1168)
          )
          (if
            (local.tee $1
              (i32.load
                (i32.const 1164)
              )
            )
            (loop $while-in
              (local.set $2
                (if (result i32)
                  (i32.gt_s
                    (i32.load offset=76
                      (local.get $1)
                    )
                    (i32.const -1)
                  )
                  (call $_malloc
                    (local.get $1)
                  )
                  (i32.const 0)
                )
              )
              (local.set $0
                (if (result i32)
                  (i32.gt_u
                    (i32.load offset=20
                      (local.get $1)
                    )
                    (i32.load offset=28
                      (local.get $1)
                    )
                  )
                  (i32.or
                    (call $___fflush_unlocked
                      (local.get $1)
                    )
                    (local.get $0)
                  )
                  (local.get $0)
                )
              )
              (if
                (local.get $2)
                (call $_free
                  (local.get $1)
                )
              )
              (br_if $while-in
                (local.tee $1
                  (i32.load offset=56
                    (local.get $1)
                  )
                )
              )
            )
          )
          (call $___unlock
            (i32.const 1168)
          )
          (local.get $0)
        )
      )
    )
  )
  (func $___fflush_unlocked (param $0 i32) (result i32)
    (local $1 i32)
    (local $2 i32)
    (local $3 i32)
    (local $4 i32)
    (local $5 i32)
    (local $6 i32)
    (block $jumpthreading$outer$0 (result i32)
      (block $jumpthreading$inner$0
        (br_if $jumpthreading$inner$0
          (i32.le_u
            (i32.load
              (local.tee $1
                (i32.add
                  (local.get $0)
                  (i32.const 20)
                )
              )
            )
            (i32.load
              (local.tee $2
                (i32.add
                  (local.get $0)
                  (i32.const 28)
                )
              )
            )
          )
        )
        (drop
          (call_indirect (type $FUNCSIG$iiii)
            (local.get $0)
            (i32.const 0)
            (i32.const 0)
            (i32.add
              (i32.and
                (i32.load offset=36
                  (local.get $0)
                )
                (i32.const 3)
              )
              (i32.const 2)
            )
          )
        )
        (br_if $jumpthreading$inner$0
          (i32.load
            (local.get $1)
          )
        )
        (br $jumpthreading$outer$0
          (i32.const -1)
        )
      )
      (if
        (i32.lt_u
          (local.tee $4
            (i32.load
              (local.tee $3
                (i32.add
                  (local.get $0)
                  (i32.const 4)
                )
              )
            )
          )
          (local.tee $6
            (i32.load
              (local.tee $5
                (i32.add
                  (local.get $0)
                  (i32.const 8)
                )
              )
            )
          )
        )
        (drop
          (call_indirect (type $FUNCSIG$iiii)
            (local.get $0)
            (i32.sub
              (local.get $4)
              (local.get $6)
            )
            (i32.const 1)
            (i32.add
              (i32.and
                (i32.load offset=40
                  (local.get $0)
                )
                (i32.const 3)
              )
              (i32.const 2)
            )
          )
        )
      )
      (i32.store offset=16
        (local.get $0)
        (i32.const 0)
      )
      (i32.store
        (local.get $2)
        (i32.const 0)
      )
      (i32.store
        (local.get $1)
        (i32.const 0)
      )
      (i32.store
        (local.get $5)
        (i32.const 0)
      )
      (i32.store
        (local.get $3)
        (i32.const 0)
      )
      (i32.const 0)
    )
  )
  (func $__Znwj (param $0 i32) (result i32)
    (local $1 i32)
    (local.set $1
      (select
        (local.get $0)
        (i32.const 1)
        (local.get $0)
      )
    )
    (loop $while-in
      (block $while-out
        (br_if $while-out
          (local.tee $0
            (call $_malloc
              (local.get $1)
            )
          )
        )
        (if
          (local.tee $0
            (call $__ZSt15get_new_handlerv)
          )
          (block
            (call_indirect (type $FUNCSIG$v)
              (i32.add
                (i32.and
                  (local.get $0)
                  (i32.const 0)
                )
                (i32.const 8)
              )
            )
            (br $while-in)
          )
          (local.set $0
            (i32.const 0)
          )
        )
      )
    )
    (local.get $0)
  )
  (func $__ZSt15get_new_handlerv (result i32)
    (local $0 i32)
    (i32.store
      (i32.const 1188)
      (i32.add
        (local.tee $0
          (i32.load
            (i32.const 1188)
          )
        )
        (i32.const 0)
      )
    )
    (local.get $0)
  )
  (func $runPostSets
    (nop)
  )
  (func $_memset (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (local $3 i32)
    (local $4 i32)
    (local $5 i32)
    (local $6 i32)
    (local.set $4
      (i32.add
        (local.get $0)
        (local.get $2)
      )
    )
    (if
      (i32.ge_s
        (local.get $2)
        (i32.const 20)
      )
      (block
        (local.set $5
          (i32.or
            (i32.or
              (i32.or
                (local.tee $1
                  (i32.and
                    (local.get $1)
                    (i32.const 255)
                  )
                )
                (i32.shl
                  (local.get $1)
                  (i32.const 8)
                )
              )
              (i32.shl
                (local.get $1)
                (i32.const 16)
              )
            )
            (i32.shl
              (local.get $1)
              (i32.const 24)
            )
          )
        )
        (local.set $6
          (i32.and
            (local.get $4)
            (i32.const -4)
          )
        )
        (if
          (local.tee $3
            (i32.and
              (local.get $0)
              (i32.const 3)
            )
          )
          (block
            (local.set $3
              (i32.sub
                (i32.add
                  (local.get $0)
                  (i32.const 4)
                )
                (local.get $3)
              )
            )
            (loop $while-in
              (if
                (i32.lt_s
                  (local.get $0)
                  (local.get $3)
                )
                (block
                  (i32.store8
                    (local.get $0)
                    (local.get $1)
                  )
                  (local.set $0
                    (i32.add
                      (local.get $0)
                      (i32.const 1)
                    )
                  )
                  (br $while-in)
                )
              )
            )
          )
        )
        (loop $while-in1
          (if
            (i32.lt_s
              (local.get $0)
              (local.get $6)
            )
            (block
              (i32.store
                (local.get $0)
                (local.get $5)
              )
              (local.set $0
                (i32.add
                  (local.get $0)
                  (i32.const 4)
                )
              )
              (br $while-in1)
            )
          )
        )
      )
    )
    (loop $while-in3
      (if
        (i32.lt_s
          (local.get $0)
          (local.get $4)
        )
        (block
          (i32.store8
            (local.get $0)
            (local.get $1)
          )
          (local.set $0
            (i32.add
              (local.get $0)
              (i32.const 1)
            )
          )
          (br $while-in3)
        )
      )
    )
    (i32.sub
      (local.get $0)
      (local.get $2)
    )
  )
  (func $_memcpy (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (local $3 i32)
    (if
      (i32.ge_s
        (local.get $2)
        (i32.const 4096)
      )
      (return
        (call $_emscripten_memcpy_big
          (local.get $0)
          (local.get $1)
          (local.get $2)
        )
      )
    )
    (local.set $3
      (local.get $0)
    )
    (if
      (i32.eq
        (i32.and
          (local.get $0)
          (i32.const 3)
        )
        (i32.and
          (local.get $1)
          (i32.const 3)
        )
      )
      (block
        (loop $while-in
          (block $while-out
            (br_if $while-out
              (i32.eqz
                (i32.and
                  (local.get $0)
                  (i32.const 3)
                )
              )
            )
            (if
              (i32.eqz
                (local.get $2)
              )
              (return
                (local.get $3)
              )
            )
            (i32.store8
              (local.get $0)
              (i32.load8_s
                (local.get $1)
              )
            )
            (local.set $0
              (i32.add
                (local.get $0)
                (i32.const 1)
              )
            )
            (local.set $1
              (i32.add
                (local.get $1)
                (i32.const 1)
              )
            )
            (local.set $2
              (i32.sub
                (local.get $2)
                (i32.const 1)
              )
            )
            (br $while-in)
          )
        )
        (loop $while-in1
          (if
            (i32.ge_s
              (local.get $2)
              (i32.const 4)
            )
            (block
              (i32.store
                (local.get $0)
                (i32.load
                  (local.get $1)
                )
              )
              (local.set $0
                (i32.add
                  (local.get $0)
                  (i32.const 4)
                )
              )
              (local.set $1
                (i32.add
                  (local.get $1)
                  (i32.const 4)
                )
              )
              (local.set $2
                (i32.sub
                  (local.get $2)
                  (i32.const 4)
                )
              )
              (br $while-in1)
            )
          )
        )
      )
    )
    (loop $while-in3
      (if
        (i32.gt_s
          (local.get $2)
          (i32.const 0)
        )
        (block
          (i32.store8
            (local.get $0)
            (i32.load8_s
              (local.get $1)
            )
          )
          (local.set $0
            (i32.add
              (local.get $0)
              (i32.const 1)
            )
          )
          (local.set $1
            (i32.add
              (local.get $1)
              (i32.const 1)
            )
          )
          (local.set $2
            (i32.sub
              (local.get $2)
              (i32.const 1)
            )
          )
          (br $while-in3)
        )
      )
    )
    (local.get $3)
  )
  (func $_pthread_self (result i32)
    (i32.const 0)
  )
  (func $dynCall_ii (param $0 i32) (param $1 i32) (result i32)
    (call_indirect (type $FUNCSIG$ii)
      (local.get $1)
      (i32.add
        (i32.and
          (local.get $0)
          (i32.const 1)
        )
        (i32.const 0)
      )
    )
  )
  (func $dynCall_iiii (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (result i32)
    (call_indirect (type $FUNCSIG$iiii)
      (local.get $1)
      (local.get $2)
      (local.get $3)
      (i32.add
        (i32.and
          (local.get $0)
          (i32.const 3)
        )
        (i32.const 2)
      )
    )
  )
  (func $dynCall_vi (param $0 i32) (param $1 i32)
    (call_indirect (type $FUNCSIG$vi)
      (local.get $1)
      (i32.add
        (i32.and
          (local.get $0)
          (i32.const 1)
        )
        (i32.const 6)
      )
    )
  )
  (func $dynCall_v (param $0 i32)
    (call_indirect (type $FUNCSIG$v)
      (i32.add
        (i32.and
          (local.get $0)
          (i32.const 0)
        )
        (i32.const 8)
      )
    )
  )
  (func $b0 (param $0 i32) (result i32)
    (call $abort
      (i32.const 0)
    )
    (i32.const 0)
  )
  (func $b1 (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (call $abort
      (i32.const 1)
    )
    (i32.const 0)
  )
  (func $b2 (param $0 i32)
    (call $abort
      (i32.const 2)
    )
  )
  (func $b3
    (call $abort
      (i32.const 3)
    )
  )
)
