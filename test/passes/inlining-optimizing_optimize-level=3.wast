;; similar to test/emcc_hello_world.fromasm.clamp ;;
(module
 (type $FUNCSIG$iiii (func (param i32 i32 i32) (result i32)))
 (type $FUNCSIG$ii (func (param i32) (result i32)))
 (type $FUNCSIG$vi (func (param i32)))
 (type $FUNCSIG$v (func))
 (type $FUNCSIG$i (func (result i32)))
 (type $FUNCSIG$iii (func (param i32 i32) (result i32)))
 (type $FUNCSIG$vii (func (param i32 i32)))
 (import "env" "STACKTOP" (global $STACKTOP$asm2wasm$import i32))
 (import "env" "STACK_MAX" (global $STACK_MAX$asm2wasm$import i32))
 (import "env" "tempDoublePtr" (global $tempDoublePtr$asm2wasm$import i32))
 (import "env" "abort" (func $abort))
 (import "env" "nullFunc_ii" (func $nullFunc_ii (param i32)))
 (import "env" "nullFunc_iiii" (func $nullFunc_iiii (param i32)))
 (import "env" "nullFunc_vi" (func $nullFunc_vi (param i32)))
 (import "env" "_pthread_cleanup_pop" (func $_pthread_cleanup_pop (param i32)))
 (import "env" "___lock" (func $___lock (param i32)))
 (import "env" "_pthread_self" (func $_pthread_self (result i32)))
 (import "env" "_abort" (func $_abort))
 (import "env" "___syscall6" (func $___syscall6 (param i32 i32) (result i32)))
 (import "env" "_sbrk" (func $_sbrk (param i32) (result i32)))
 (import "env" "_time" (func $_time (param i32) (result i32)))
 (import "env" "_emscripten_memcpy_big" (func $_emscripten_memcpy_big (param i32 i32 i32) (result i32)))
 (import "env" "___syscall54" (func $___syscall54 (param i32 i32) (result i32)))
 (import "env" "___unlock" (func $___unlock (param i32)))
 (import "env" "___syscall140" (func $___syscall140 (param i32 i32) (result i32)))
 (import "env" "_pthread_cleanup_push" (func $_pthread_cleanup_push (param i32 i32)))
 (import "env" "_sysconf" (func $_sysconf (param i32) (result i32)))
 (import "env" "___syscall146" (func $___syscall146 (param i32 i32) (result i32)))
 (import "env" "memory" (memory $0 256 256))
 (import "env" "table" (table 18 18 funcref))
 (import "env" "memoryBase" (global $memoryBase i32))
 (import "env" "tableBase" (global $tableBase i32))
 (global $STACKTOP (mut i32) (global.get $STACKTOP$asm2wasm$import))
 (global $STACK_MAX (mut i32) (global.get $STACK_MAX$asm2wasm$import))
 (global $tempDoublePtr (mut i32) (global.get $tempDoublePtr$asm2wasm$import))
 (global $__THREW__ (mut i32) (i32.const 0))
 (global $threwValue (mut i32) (i32.const 0))
 (global $tempRet0 (mut i32) (i32.const 0))
 (elem (global.get $tableBase) $b0 $___stdio_close $b1 $b1 $___stdout_write $___stdio_seek $___stdio_write $b1 $b1 $b1 $b2 $b2 $b2 $b2 $b2 $_cleanup $b2 $b2)
 (data (i32.const 1024) "emcc_hello_world.asm.js")
 (export "_i64Subtract" (func $_i64Subtract))
 (export "_free" (func $_free))
 (export "_main" (func $_main))
 (export "_i64Add" (func $_i64Add))
 (export "_memset" (func $_memset))
 (export "_malloc" (func $_malloc))
 (export "_memcpy" (func $_memcpy))
 (export "_bitshift64Lshr" (func $_bitshift64Lshr))
 (export "_fflush" (func $_fflush))
 (export "___errno_location" (func $___errno_location))
 (export "_bitshift64Shl" (func $_bitshift64Shl))
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
 (export "___udivmoddi4" (func $___udivmoddi4))
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
  (if
   (i32.ge_s
    (global.get $STACKTOP)
    (global.get $STACK_MAX)
   )
   (call $abort)
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
 (func $_main (result i32)
  (local $0 i32)
  (local.set $0
   (global.get $STACKTOP)
  )
  (global.set $STACKTOP
   (i32.add
    (global.get $STACKTOP)
    (i32.const 16)
   )
  )
  (if
   (i32.ge_s
    (global.get $STACKTOP)
    (global.get $STACK_MAX)
   )
   (call $abort)
  )
  (drop
   (call $_printf
    (i32.const 672)
    (local.get $0)
   )
  )
  (global.set $STACKTOP
   (local.get $0)
  )
  (i32.const 0)
 )
 (func $_frexp (param $0 f64) (param $1 i32) (result f64)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (f64.store
   (global.get $tempDoublePtr)
   (local.get $0)
  )
  (block $switch
   (block $switch-default
    (block $switch-case0
     (block $switch-case
      (br_table $switch-case $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-case0 $switch-default
       (local.tee $3
        (i32.and
         (local.tee $3
          (call $_bitshift64Lshr
           (local.tee $2
            (i32.load
             (global.get $tempDoublePtr)
            )
           )
           (local.tee $4
            (i32.load offset=4
             (global.get $tempDoublePtr)
            )
           )
           (i32.const 52)
          )
         )
         (i32.const 2047)
        )
       )
      )
     )
     (i32.store
      (local.get $1)
      (local.tee $2
       (if (result i32)
        (f64.ne
         (local.get $0)
         (f64.const 0)
        )
        (block (result i32)
         (local.set $0
          (call $_frexp
           (f64.mul
            (local.get $0)
            (f64.const 18446744073709551615)
           )
           (local.get $1)
          )
         )
         (i32.add
          (i32.load
           (local.get $1)
          )
          (i32.const -64)
         )
        )
        (i32.const 0)
       )
      )
     )
     (br $switch)
    )
    (br $switch)
   )
   (i32.store
    (local.get $1)
    (i32.add
     (local.get $3)
     (i32.const -1022)
    )
   )
   (i32.store
    (global.get $tempDoublePtr)
    (local.get $2)
   )
   (i32.store offset=4
    (global.get $tempDoublePtr)
    (i32.or
     (i32.and
      (local.get $4)
      (i32.const -2146435073)
     )
     (i32.const 1071644672)
    )
   )
   (local.set $0
    (f64.load
     (global.get $tempDoublePtr)
    )
   )
  )
  (local.get $0)
 )
 (func $_strerror (param $0 i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (local.set $1
   (i32.const 0)
  )
  (block $__rjto$1
   (block $__rjti$1
    (block $__rjti$0
     (loop $while-in
      (br_if $__rjti$0
       (i32.eq
        (i32.load8_u offset=687
         (local.get $1)
        )
        (local.get $0)
       )
      )
      (br_if $while-in
       (i32.ne
        (local.tee $1
         (i32.add
          (local.get $1)
          (i32.const 1)
         )
        )
        (i32.const 87)
       )
      )
      (local.set $1
       (i32.const 87)
      )
      (br $__rjti$1)
     )
    )
    (br_if $__rjti$1
     (local.get $1)
    )
    (local.set $0
     (i32.const 775)
    )
    (br $__rjto$1)
   )
   (local.set $0
    (i32.const 775)
   )
   (loop $while-in1
    (loop $while-in3
     (local.set $2
      (i32.add
       (local.get $0)
       (i32.const 1)
      )
     )
     (if
      (i32.load8_s
       (local.get $0)
      )
      (block
       (local.set $0
        (local.get $2)
       )
       (br $while-in3)
      )
      (local.set $0
       (local.get $2)
      )
     )
    )
    (br_if $while-in1
     (local.tee $1
      (i32.add
       (local.get $1)
       (i32.const -1)
      )
     )
    )
   )
  )
  (local.get $0)
 )
 (func $___errno_location (result i32)
  (if (result i32)
   (i32.load
    (i32.const 16)
   )
   (i32.load offset=60
    (call $_pthread_self)
   )
   (i32.const 60)
  )
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
  (if
   (i32.ge_s
    (global.get $STACKTOP)
    (global.get $STACK_MAX)
   )
   (call $abort)
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
  (if
   (i32.ge_s
    (global.get $STACKTOP)
    (global.get $STACK_MAX)
   )
   (call $abort)
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
   (i32.const 4)
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
  (if
   (i32.ge_s
    (global.get $STACKTOP)
    (global.get $STACK_MAX)
   )
   (call $abort)
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
 (func $_fflush (param $0 i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (block $do-once
   (if
    (local.get $0)
    (block
     (if
      (i32.le_s
       (i32.load offset=76
        (local.get $0)
       )
       (i32.const -1)
      )
      (block
       (local.set $0
        (call $___fflush_unlocked
         (local.get $0)
        )
       )
       (br $do-once)
      )
     )
     (local.set $2
      (i32.eqz
       (call $___lockfile
        (local.get $0)
       )
      )
     )
     (local.set $1
      (call $___fflush_unlocked
       (local.get $0)
      )
     )
     (local.set $0
      (if (result i32)
       (local.get $2)
       (local.get $1)
       (block (result i32)
        (call $___unlockfile
         (local.get $0)
        )
        (local.get $1)
       )
      )
     )
    )
    (block
     (local.set $0
      (if (result i32)
       (i32.load
        (i32.const 12)
       )
       (call $_fflush
        (i32.load
         (i32.const 12)
        )
       )
       (i32.const 0)
      )
     )
     (call $___lock
      (i32.const 44)
     )
     (if
      (local.tee $1
       (i32.load
        (i32.const 40)
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
         (call $___lockfile
          (local.get $1)
         )
         (i32.const 0)
        )
       )
       (if
        (i32.gt_u
         (i32.load offset=20
          (local.get $1)
         )
         (i32.load offset=28
          (local.get $1)
         )
        )
        (local.set $0
         (i32.or
          (call $___fflush_unlocked
           (local.get $1)
          )
          (local.get $0)
         )
        )
       )
       (if
        (local.get $2)
        (call $___unlockfile
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
      (i32.const 44)
     )
    )
   )
  )
  (local.get $0)
 )
 (func $_printf (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  (local $3 i32)
  (local.set $2
   (global.get $STACKTOP)
  )
  (global.set $STACKTOP
   (i32.add
    (global.get $STACKTOP)
    (i32.const 16)
   )
  )
  (if
   (i32.ge_s
    (global.get $STACKTOP)
    (global.get $STACK_MAX)
   )
   (call $abort)
  )
  (i32.store
   (local.tee $3
    (local.get $2)
   )
   (local.get $1)
  )
  (local.set $0
   (call $_vfprintf
    (i32.load
     (i32.const 8)
    )
    (local.get $0)
    (local.get $3)
   )
  )
  (global.set $STACKTOP
   (local.get $2)
  )
  (local.get $0)
 )
 (func $___lockfile (param $0 i32) (result i32)
  (i32.const 0)
 )
 (func $___unlockfile (param $0 i32)
  (nop)
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
  (local.set $8
   (global.get $STACKTOP)
  )
  (global.set $STACKTOP
   (i32.add
    (global.get $STACKTOP)
    (i32.const 48)
   )
  )
  (if
   (i32.ge_s
    (global.get $STACKTOP)
    (global.get $STACK_MAX)
   )
   (call $abort)
  )
  (local.set $9
   (i32.add
    (local.get $8)
    (i32.const 16)
   )
  )
  (local.set $10
   (local.get $8)
  )
  (i32.store
   (local.tee $4
    (i32.add
     (local.get $8)
     (i32.const 32)
    )
   )
   (local.tee $3
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
   (local.get $4)
   (local.tee $3
    (i32.sub
     (i32.load
      (local.tee $11
       (i32.add
        (local.get $0)
        (i32.const 20)
       )
      )
     )
     (local.get $3)
    )
   )
  )
  (i32.store offset=8
   (local.get $4)
   (local.get $1)
  )
  (i32.store offset=12
   (local.get $4)
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
   (local.get $4)
  )
  (local.set $4
   (i32.const 2)
  )
  (local.set $12
   (i32.add
    (local.get $3)
    (local.get $2)
   )
  )
  (block $__rjto$1
   (block $__rjti$1
    (block $__rjti$0
     (loop $while-in
      (if
       (i32.load
        (i32.const 16)
       )
       (block
        (call $_pthread_cleanup_push
         (i32.const 5)
         (local.get $0)
        )
        (i32.store
         (local.get $10)
         (i32.load
          (local.get $13)
         )
        )
        (i32.store offset=4
         (local.get $10)
         (local.get $1)
        )
        (i32.store offset=8
         (local.get $10)
         (local.get $4)
        )
        (local.set $3
         (call $___syscall_ret
          (call $___syscall146
           (i32.const 146)
           (local.get $10)
          )
         )
        )
        (call $_pthread_cleanup_pop
         (i32.const 0)
        )
       )
       (block
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
         (local.get $4)
        )
        (local.set $3
         (call $___syscall_ret
          (call $___syscall146
           (i32.const 146)
           (local.get $9)
          )
         )
        )
       )
      )
      (br_if $__rjti$0
       (i32.eq
        (local.get $12)
        (local.get $3)
       )
      )
      (br_if $__rjti$1
       (i32.lt_s
        (local.get $3)
        (i32.const 0)
       )
      )
      (local.set $5
       (if (result i32)
        (i32.gt_u
         (local.get $3)
         (local.tee $5
          (i32.load offset=4
           (local.get $1)
          )
         )
        )
        (block (result i32)
         (i32.store
          (local.get $6)
          (local.tee $7
           (i32.load
            (local.get $14)
           )
          )
         )
         (i32.store
          (local.get $11)
          (local.get $7)
         )
         (local.set $7
          (i32.load offset=12
           (local.get $1)
          )
         )
         (local.set $1
          (i32.add
           (local.get $1)
           (i32.const 8)
          )
         )
         (local.set $4
          (i32.add
           (local.get $4)
           (i32.const -1)
          )
         )
         (i32.sub
          (local.get $3)
          (local.get $5)
         )
        )
        (block (result i32)
         (if
          (i32.eq
           (local.get $4)
           (i32.const 2)
          )
          (block
           (i32.store
            (local.get $6)
            (i32.add
             (i32.load
              (local.get $6)
             )
             (local.get $3)
            )
           )
           (local.set $7
            (local.get $5)
           )
           (local.set $4
            (i32.const 2)
           )
          )
          (local.set $7
           (local.get $5)
          )
         )
         (local.get $3)
        )
       )
      )
      (i32.store
       (local.get $1)
       (i32.add
        (i32.load
         (local.get $1)
        )
        (local.get $5)
       )
      )
      (i32.store offset=4
       (local.get $1)
       (i32.sub
        (local.get $7)
        (local.get $5)
       )
      )
      (local.set $12
       (i32.sub
        (local.get $12)
        (local.get $3)
       )
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
     (local.get $1)
    )
    (i32.store
     (local.get $11)
     (local.get $1)
    )
    (br $__rjto$1)
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
    (local.get $11)
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
   (local.set $2
    (if (result i32)
     (i32.eq
      (local.get $4)
      (i32.const 2)
     )
     (i32.const 0)
     (i32.sub
      (local.get $2)
      (i32.load offset=4
       (local.get $1)
      )
     )
    )
   )
  )
  (global.set $STACKTOP
   (local.get $8)
  )
  (local.get $2)
 )
 (func $_vfprintf (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
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
  (local.set $4
   (global.get $STACKTOP)
  )
  (global.set $STACKTOP
   (i32.add
    (global.get $STACKTOP)
    (i32.const 224)
   )
  )
  (if
   (i32.ge_s
    (global.get $STACKTOP)
    (global.get $STACK_MAX)
   )
   (call $abort)
  )
  (local.set $5
   (i32.add
    (local.get $4)
    (i32.const 120)
   )
  )
  (local.set $7
   (local.get $4)
  )
  (local.set $6
   (i32.add
    (local.get $4)
    (i32.const 136)
   )
  )
  (local.set $9
   (i32.add
    (local.tee $3
     (local.tee $8
      (i32.add
       (local.get $4)
       (i32.const 80)
      )
     )
    )
    (i32.const 40)
   )
  )
  (loop $do-in
   (i32.store
    (local.get $3)
    (i32.const 0)
   )
   (br_if $do-in
    (i32.lt_s
     (local.tee $3
      (i32.add
       (local.get $3)
       (i32.const 4)
      )
     )
     (local.get $9)
    )
   )
  )
  (i32.store
   (local.get $5)
   (i32.load
    (local.get $2)
   )
  )
  (local.set $0
   (if (result i32)
    (i32.lt_s
     (call $_printf_core
      (i32.const 0)
      (local.get $1)
      (local.get $5)
      (local.get $7)
      (local.get $8)
     )
     (i32.const 0)
    )
    (i32.const -1)
    (block (result i32)
     (local.set $14
      (if (result i32)
       (i32.gt_s
        (i32.load offset=76
         (local.get $0)
        )
        (i32.const -1)
       )
       (call $___lockfile
        (local.get $0)
       )
       (i32.const 0)
      )
     )
     (local.set $10
      (i32.load
       (local.get $0)
      )
     )
     (if
      (i32.lt_s
       (i32.load8_s offset=74
        (local.get $0)
       )
       (i32.const 1)
      )
      (i32.store
       (local.get $0)
       (i32.and
        (local.get $10)
        (i32.const -33)
       )
      )
     )
     (if
      (i32.load
       (local.tee $11
        (i32.add
         (local.get $0)
         (i32.const 48)
        )
       )
      )
      (local.set $1
       (call $_printf_core
        (local.get $0)
        (local.get $1)
        (local.get $5)
        (local.get $7)
        (local.get $8)
       )
      )
      (block
       (local.set $13
        (i32.load
         (local.tee $12
          (i32.add
           (local.get $0)
           (i32.const 44)
          )
         )
        )
       )
       (i32.store
        (local.get $12)
        (local.get $6)
       )
       (i32.store
        (local.tee $9
         (i32.add
          (local.get $0)
          (i32.const 28)
         )
        )
        (local.get $6)
       )
       (i32.store
        (local.tee $3
         (i32.add
          (local.get $0)
          (i32.const 20)
         )
        )
        (local.get $6)
       )
       (i32.store
        (local.get $11)
        (i32.const 80)
       )
       (i32.store
        (local.tee $2
         (i32.add
          (local.get $0)
          (i32.const 16)
         )
        )
        (i32.add
         (local.get $6)
         (i32.const 80)
        )
       )
       (local.set $1
        (call $_printf_core
         (local.get $0)
         (local.get $1)
         (local.get $5)
         (local.get $7)
         (local.get $8)
        )
       )
       (if
        (local.get $13)
        (block
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
             (i32.const 7)
            )
            (i32.const 2)
           )
          )
         )
         (local.set $1
          (select
           (local.get $1)
           (i32.const -1)
           (i32.load
            (local.get $3)
           )
          )
         )
         (i32.store
          (local.get $12)
          (local.get $13)
         )
         (i32.store
          (local.get $11)
          (i32.const 0)
         )
         (i32.store
          (local.get $2)
          (i32.const 0)
         )
         (i32.store
          (local.get $9)
          (i32.const 0)
         )
         (i32.store
          (local.get $3)
          (i32.const 0)
         )
        )
       )
      )
     )
     (i32.store
      (local.get $0)
      (i32.or
       (local.tee $2
        (i32.load
         (local.get $0)
        )
       )
       (i32.and
        (local.get $10)
        (i32.const 32)
       )
      )
     )
     (if
      (local.get $14)
      (call $___unlockfile
       (local.get $0)
      )
     )
     (select
      (i32.const -1)
      (local.get $1)
      (i32.and
       (local.get $2)
       (i32.const 32)
      )
     )
    )
   )
  )
  (global.set $STACKTOP
   (local.get $4)
  )
  (local.get $0)
 )
 (func $___fwritex (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (local $6 i32)
  (block $label$break$L5
   (block $__rjti$0
    (br_if $__rjti$0
     (local.tee $3
      (i32.load
       (local.tee $4
        (i32.add
         (local.get $2)
         (i32.const 16)
        )
       )
      )
     )
    )
    (if
     (call $___towrite
      (local.get $2)
     )
     (local.set $3
      (i32.const 0)
     )
     (block
      (local.set $3
       (i32.load
        (local.get $4)
       )
      )
      (br $__rjti$0)
     )
    )
    (br $label$break$L5)
   )
   (if
    (i32.lt_u
     (i32.sub
      (local.get $3)
      (local.tee $4
       (i32.load
        (local.tee $5
         (i32.add
          (local.get $2)
          (i32.const 20)
         )
        )
       )
      )
     )
     (local.get $1)
    )
    (block
     (local.set $3
      (call_indirect (type $FUNCSIG$iiii)
       (local.get $2)
       (local.get $0)
       (local.get $1)
       (i32.add
        (i32.and
         (i32.load offset=36
          (local.get $2)
         )
         (i32.const 7)
        )
        (i32.const 2)
       )
      )
     )
     (br $label$break$L5)
    )
   )
   (local.set $2
    (block $label$break$L10 (result i32)
     (if (result i32)
      (i32.gt_s
       (i32.load8_s offset=75
        (local.get $2)
       )
       (i32.const -1)
      )
      (block (result i32)
       (local.set $3
        (local.get $1)
       )
       (loop $while-in
        (drop
         (br_if $label$break$L10
          (i32.const 0)
          (i32.eqz
           (local.get $3)
          )
         )
        )
        (if
         (i32.ne
          (i32.load8_s
           (i32.add
            (local.get $0)
            (local.tee $6
             (i32.add
              (local.get $3)
              (i32.const -1)
             )
            )
           )
          )
          (i32.const 10)
         )
         (block
          (local.set $3
           (local.get $6)
          )
          (br $while-in)
         )
        )
       )
       (br_if $label$break$L5
        (i32.lt_u
         (call_indirect (type $FUNCSIG$iiii)
          (local.get $2)
          (local.get $0)
          (local.get $3)
          (i32.add
           (i32.and
            (i32.load offset=36
             (local.get $2)
            )
            (i32.const 7)
           )
           (i32.const 2)
          )
         )
         (local.get $3)
        )
       )
       (local.set $4
        (i32.load
         (local.get $5)
        )
       )
       (local.set $1
        (i32.sub
         (local.get $1)
         (local.get $3)
        )
       )
       (local.set $0
        (i32.add
         (local.get $0)
         (local.get $3)
        )
       )
       (local.get $3)
      )
      (i32.const 0)
     )
    )
   )
   (drop
    (call $_memcpy
     (local.get $4)
     (local.get $0)
     (local.get $1)
    )
   )
   (i32.store
    (local.get $5)
    (i32.add
     (i32.load
      (local.get $5)
     )
     (local.get $1)
    )
   )
   (local.set $3
    (i32.add
     (local.get $2)
     (local.get $1)
    )
   )
  )
  (local.get $3)
 )
 (func $___towrite (param $0 i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (local.set $1
   (i32.load8_s
    (local.tee $2
     (i32.add
      (local.get $0)
      (i32.const 74)
     )
    )
   )
  )
  (i32.store8
   (local.get $2)
   (i32.or
    (i32.add
     (local.get $1)
     (i32.const 255)
    )
    (local.get $1)
   )
  )
  (local.tee $0
   (if (result i32)
    (i32.and
     (local.tee $1
      (i32.load
       (local.get $0)
      )
     )
     (i32.const 8)
    )
    (block (result i32)
     (i32.store
      (local.get $0)
      (i32.or
       (local.get $1)
       (i32.const 32)
      )
     )
     (i32.const -1)
    )
    (block (result i32)
     (i32.store offset=8
      (local.get $0)
      (i32.const 0)
     )
     (i32.store offset=4
      (local.get $0)
      (i32.const 0)
     )
     (i32.store offset=28
      (local.get $0)
      (local.tee $1
       (i32.load offset=44
        (local.get $0)
       )
      )
     )
     (i32.store offset=20
      (local.get $0)
      (local.get $1)
     )
     (i32.store offset=16
      (local.get $0)
      (i32.add
       (local.get $1)
       (i32.load offset=48
        (local.get $0)
       )
      )
     )
     (i32.const 0)
    )
   )
  )
 )
 (func $_wcrtomb (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (block $do-once (result i32)
   (if (result i32)
    (local.get $0)
    (block (result i32)
     (if
      (i32.lt_u
       (local.get $1)
       (i32.const 128)
      )
      (block
       (i32.store8
        (local.get $0)
        (local.get $1)
       )
       (br $do-once
        (i32.const 1)
       )
      )
     )
     (if
      (i32.lt_u
       (local.get $1)
       (i32.const 2048)
      )
      (block
       (i32.store8
        (local.get $0)
        (i32.or
         (i32.shr_u
          (local.get $1)
          (i32.const 6)
         )
         (i32.const 192)
        )
       )
       (i32.store8 offset=1
        (local.get $0)
        (i32.or
         (i32.and
          (local.get $1)
          (i32.const 63)
         )
         (i32.const 128)
        )
       )
       (br $do-once
        (i32.const 2)
       )
      )
     )
     (if
      (i32.or
       (i32.lt_u
        (local.get $1)
        (i32.const 55296)
       )
       (i32.eq
        (i32.and
         (local.get $1)
         (i32.const -8192)
        )
        (i32.const 57344)
       )
      )
      (block
       (i32.store8
        (local.get $0)
        (i32.or
         (i32.shr_u
          (local.get $1)
          (i32.const 12)
         )
         (i32.const 224)
        )
       )
       (i32.store8 offset=1
        (local.get $0)
        (i32.or
         (i32.and
          (i32.shr_u
           (local.get $1)
           (i32.const 6)
          )
          (i32.const 63)
         )
         (i32.const 128)
        )
       )
       (i32.store8 offset=2
        (local.get $0)
        (i32.or
         (i32.and
          (local.get $1)
          (i32.const 63)
         )
         (i32.const 128)
        )
       )
       (br $do-once
        (i32.const 3)
       )
      )
     )
     (if (result i32)
      (i32.lt_u
       (i32.add
        (local.get $1)
        (i32.const -65536)
       )
       (i32.const 1048576)
      )
      (block (result i32)
       (i32.store8
        (local.get $0)
        (i32.or
         (i32.shr_u
          (local.get $1)
          (i32.const 18)
         )
         (i32.const 240)
        )
       )
       (i32.store8 offset=1
        (local.get $0)
        (i32.or
         (i32.and
          (i32.shr_u
           (local.get $1)
           (i32.const 12)
          )
          (i32.const 63)
         )
         (i32.const 128)
        )
       )
       (i32.store8 offset=2
        (local.get $0)
        (i32.or
         (i32.and
          (i32.shr_u
           (local.get $1)
           (i32.const 6)
          )
          (i32.const 63)
         )
         (i32.const 128)
        )
       )
       (i32.store8 offset=3
        (local.get $0)
        (i32.or
         (i32.and
          (local.get $1)
          (i32.const 63)
         )
         (i32.const 128)
        )
       )
       (i32.const 4)
      )
      (block (result i32)
       (i32.store
        (call $___errno_location)
        (i32.const 84)
       )
       (i32.const -1)
      )
     )
    )
    (i32.const 1)
   )
  )
 )
 (func $_wctomb (param $0 i32) (param $1 i32) (result i32)
  (if (result i32)
   (local.get $0)
   (call $_wcrtomb
    (local.get $0)
    (local.get $1)
    (i32.const 0)
   )
   (i32.const 0)
  )
 )
 (func $_memchr (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (local.set $5
   (i32.and
    (local.get $1)
    (i32.const 255)
   )
  )
  (block $label$break$L8
   (block $__rjti$2
    (if
     (i32.and
      (local.tee $4
       (i32.ne
        (local.get $2)
        (i32.const 0)
       )
      )
      (i32.ne
       (i32.and
        (local.get $0)
        (i32.const 3)
       )
       (i32.const 0)
      )
     )
     (block
      (local.set $4
       (i32.and
        (local.get $1)
        (i32.const 255)
       )
      )
      (local.set $3
       (local.get $2)
      )
      (local.set $2
       (local.get $0)
      )
      (loop $while-in
       (br_if $__rjti$2
        (i32.eq
         (i32.load8_u
          (local.get $2)
         )
         (i32.and
          (local.get $4)
          (i32.const 255)
         )
        )
       )
       (br_if $while-in
        (i32.and
         (local.tee $0
          (i32.ne
           (local.tee $3
            (i32.add
             (local.get $3)
             (i32.const -1)
            )
           )
           (i32.const 0)
          )
         )
         (i32.ne
          (i32.and
           (local.tee $2
            (i32.add
             (local.get $2)
             (i32.const 1)
            )
           )
           (i32.const 3)
          )
          (i32.const 0)
         )
        )
       )
      )
     )
     (block
      (local.set $3
       (local.get $2)
      )
      (local.set $2
       (local.get $0)
      )
      (local.set $0
       (local.get $4)
      )
     )
    )
    (br_if $__rjti$2
     (local.get $0)
    )
    (local.set $0
     (i32.const 0)
    )
    (br $label$break$L8)
   )
   (local.set $0
    (local.get $3)
   )
   (if
    (i32.ne
     (i32.load8_u
      (local.get $2)
     )
     (local.tee $1
      (i32.and
       (local.get $1)
       (i32.const 255)
      )
     )
    )
    (block
     (local.set $3
      (i32.mul
       (local.get $5)
       (i32.const 16843009)
      )
     )
     (block $__rjto$0
      (block $__rjti$0
       (br_if $__rjti$0
        (i32.le_u
         (local.get $0)
         (i32.const 3)
        )
       )
       (loop $while-in3
        (if
         (i32.eqz
          (i32.and
           (i32.xor
            (i32.and
             (local.tee $4
              (i32.xor
               (i32.load
                (local.get $2)
               )
               (local.get $3)
              )
             )
             (i32.const -2139062144)
            )
            (i32.const -2139062144)
           )
           (i32.add
            (local.get $4)
            (i32.const -16843009)
           )
          )
         )
         (block
          (local.set $2
           (i32.add
            (local.get $2)
            (i32.const 4)
           )
          )
          (br_if $while-in3
           (i32.gt_u
            (local.tee $0
             (i32.add
              (local.get $0)
              (i32.const -4)
             )
            )
            (i32.const 3)
           )
          )
          (br $__rjti$0)
         )
        )
       )
       (br $__rjto$0)
      )
      (if
       (i32.eqz
        (local.get $0)
       )
       (block
        (local.set $0
         (i32.const 0)
        )
        (br $label$break$L8)
       )
      )
     )
     (loop $while-in5
      (br_if $label$break$L8
       (i32.eq
        (i32.load8_u
         (local.get $2)
        )
        (i32.and
         (local.get $1)
         (i32.const 255)
        )
       )
      )
      (local.set $2
       (i32.add
        (local.get $2)
        (i32.const 1)
       )
      )
      (br_if $while-in5
       (local.tee $0
        (i32.add
         (local.get $0)
         (i32.const -1)
        )
       )
      )
      (local.set $0
       (i32.const 0)
      )
     )
    )
   )
  )
  (select
   (local.get $2)
   (i32.const 0)
   (local.get $0)
  )
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
 (func $___fflush_unlocked (param $0 i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (local $6 i32)
  (local.tee $0
   (block $__rjto$0 (result i32)
    (block $__rjti$0
     (br_if $__rjti$0
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
         (i32.const 7)
        )
        (i32.const 2)
       )
      )
     )
     (br_if $__rjti$0
      (i32.load
       (local.get $1)
      )
     )
     (br $__rjto$0
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
         (i32.const 7)
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
 )
 (func $_cleanup (param $0 i32)
  (if
   (i32.eqz
    (i32.load offset=68
     (local.get $0)
    )
   )
   (call $___unlockfile
    (local.get $0)
   )
  )
 )
 (func $f64-to-int (param $0 f64) (result i32)
  (if (result i32)
   (f64.ne
    (local.get $0)
    (local.get $0)
   )
   (i32.const -2147483648)
   (if (result i32)
    (f64.ge
     (local.get $0)
     (f64.const 2147483648)
    )
    (i32.const -2147483648)
    (if (result i32)
     (f64.le
      (local.get $0)
      (f64.const -2147483649)
     )
     (i32.const -2147483648)
     (i32.trunc_f64_s
      (local.get $0)
     )
    )
   )
  )
 )
 (func $i32s-div (param $0 i32) (param $1 i32) (result i32)
  (if (result i32)
   (local.get $1)
   (if (result i32)
    (i32.and
     (i32.eq
      (local.get $0)
      (i32.const -2147483648)
     )
     (i32.eq
      (local.get $1)
      (i32.const -1)
     )
    )
    (i32.const 0)
    (i32.div_s
     (local.get $0)
     (local.get $1)
    )
   )
   (i32.const 0)
  )
 )
 (func $i32u-rem (param $0 i32) (param $1 i32) (result i32)
  (if (result i32)
   (local.get $1)
   (i32.rem_u
    (local.get $0)
    (local.get $1)
   )
   (i32.const 0)
  )
 )
 (func $i32u-div (param $0 i32) (param $1 i32) (result i32)
  (if (result i32)
   (local.get $1)
   (i32.div_u
    (local.get $0)
    (local.get $1)
   )
   (i32.const 0)
  )
 )
 (func $_printf_core (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (param $4 i32) (result i32)
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
  (local $15 f64)
  (local $16 i32)
  (local $17 i32)
  (local $18 i32)
  (local $19 i32)
  (local $20 i32)
  (local $21 i32)
  (local $22 i32)
  (local $23 f64)
  (local $24 i32)
  (local $25 i32)
  (local $26 i32)
  (local $27 i32)
  (local $28 i32)
  (local $29 i32)
  (local $30 i32)
  (local $31 i32)
  (local $32 i32)
  (local $33 i32)
  (local $34 i32)
  (local $35 i32)
  (local $36 i32)
  (local $37 i32)
  (local $38 i32)
  (local $39 i32)
  (local $40 i32)
  (local $41 i32)
  (local $42 i32)
  (local $43 i32)
  (local $44 i32)
  (local $45 i32)
  (local $46 i32)
  (local $47 i32)
  (local $48 i32)
  (local $49 i32)
  (local $50 i32)
  (local $51 i32)
  (local.set $25
   (global.get $STACKTOP)
  )
  (global.set $STACKTOP
   (i32.add
    (global.get $STACKTOP)
    (i32.const 624)
   )
  )
  (if
   (i32.ge_s
    (global.get $STACKTOP)
    (global.get $STACK_MAX)
   )
   (call $abort)
  )
  (local.set $20
   (i32.add
    (local.get $25)
    (i32.const 16)
   )
  )
  (local.set $19
   (local.get $25)
  )
  (local.set $36
   (i32.add
    (local.get $25)
    (i32.const 528)
   )
  )
  (local.set $29
   (i32.ne
    (local.get $0)
    (i32.const 0)
   )
  )
  (local.set $39
   (local.tee $26
    (i32.add
     (local.tee $5
      (i32.add
       (local.get $25)
       (i32.const 536)
      )
     )
     (i32.const 40)
    )
   )
  )
  (local.set $40
   (i32.add
    (local.get $5)
    (i32.const 39)
   )
  )
  (local.set $44
   (i32.add
    (local.tee $41
     (i32.add
      (local.get $25)
      (i32.const 8)
     )
    )
    (i32.const 4)
   )
  )
  (local.set $34
   (i32.add
    (local.tee $5
     (i32.add
      (local.get $25)
      (i32.const 576)
     )
    )
    (i32.const 12)
   )
  )
  (local.set $42
   (i32.add
    (local.get $5)
    (i32.const 11)
   )
  )
  (local.set $45
   (i32.sub
    (local.tee $28
     (local.get $34)
    )
    (local.tee $37
     (local.tee $22
      (i32.add
       (local.get $25)
       (i32.const 588)
      )
     )
    )
   )
  )
  (local.set $46
   (i32.sub
    (i32.const -2)
    (local.get $37)
   )
  )
  (local.set $47
   (i32.add
    (local.get $28)
    (i32.const 2)
   )
  )
  (local.set $49
   (i32.add
    (local.tee $48
     (i32.add
      (local.get $25)
      (i32.const 24)
     )
    )
    (i32.const 288)
   )
  )
  (local.set $43
   (local.tee $30
    (i32.add
     (local.get $22)
     (i32.const 9)
    )
   )
  )
  (local.set $35
   (i32.add
    (local.get $22)
    (i32.const 8)
   )
  )
  (local.set $16
   (i32.const 0)
  )
  (local.set $5
   (local.get $1)
  )
  (local.set $10
   (i32.const 0)
  )
  (local.set $1
   (i32.const 0)
  )
  (block $label$break$L343
   (block $__rjti$9
    (loop $label$continue$L1
     (block $label$break$L1
      (if
       (i32.gt_s
        (local.get $16)
        (i32.const -1)
       )
       (local.set $16
        (if (result i32)
         (i32.gt_s
          (local.get $10)
          (i32.sub
           (i32.const 2147483647)
           (local.get $16)
          )
         )
         (block (result i32)
          (i32.store
           (call $___errno_location)
           (i32.const 75)
          )
          (i32.const -1)
         )
         (i32.add
          (local.get $10)
          (local.get $16)
         )
        )
       )
      )
      (br_if $__rjti$9
       (i32.eqz
        (local.tee $7
         (i32.load8_s
          (local.get $5)
         )
        )
       )
      )
      (local.set $10
       (local.get $5)
      )
      (block $label$break$L12
       (block $__rjti$1
        (loop $label$continue$L9
         (block $label$break$L9
          (block $switch-default
           (block $switch-case0
            (block $switch-case
             (br_table $switch-case0 $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-default $switch-case $switch-default
              (i32.shr_s
               (i32.shl
                (local.get $7)
                (i32.const 24)
               )
               (i32.const 24)
              )
             )
            )
            (local.set $6
             (local.get $10)
            )
            (br $__rjti$1)
           )
           (local.set $6
            (local.get $10)
           )
           (br $label$break$L9)
          )
          (local.set $7
           (i32.load8_s
            (local.tee $10
             (i32.add
              (local.get $10)
              (i32.const 1)
             )
            )
           )
          )
          (br $label$continue$L9)
         )
        )
        (br $label$break$L12)
       )
       (loop $while-in
        (br_if $label$break$L12
         (i32.ne
          (i32.load8_s offset=1
           (local.get $6)
          )
          (i32.const 37)
         )
        )
        (local.set $10
         (i32.add
          (local.get $10)
          (i32.const 1)
         )
        )
        (br_if $while-in
         (i32.eq
          (i32.load8_s
           (local.tee $6
            (i32.add
             (local.get $6)
             (i32.const 2)
            )
           )
          )
          (i32.const 37)
         )
        )
       )
      )
      (local.set $7
       (i32.sub
        (local.get $10)
        (local.get $5)
       )
      )
      (if
       (local.get $29)
       (if
        (i32.eqz
         (i32.and
          (i32.load
           (local.get $0)
          )
          (i32.const 32)
         )
        )
        (drop
         (call $___fwritex
          (local.get $5)
          (local.get $7)
          (local.get $0)
         )
        )
       )
      )
      (if
       (i32.ne
        (local.get $10)
        (local.get $5)
       )
       (block
        (local.set $5
         (local.get $6)
        )
        (local.set $10
         (local.get $7)
        )
        (br $label$continue$L1)
       )
      )
      (local.set $8
       (if (result i32)
        (i32.lt_u
         (local.tee $8
          (i32.add
           (local.tee $11
            (i32.load8_s
             (local.tee $10
              (i32.add
               (local.get $6)
               (i32.const 1)
              )
             )
            )
           )
           (i32.const -48)
          )
         )
         (i32.const 10)
        )
        (block (result i32)
         (local.set $6
          (i32.load8_s
           (local.tee $10
            (select
             (i32.add
              (local.get $6)
              (i32.const 3)
             )
             (local.get $10)
             (local.tee $11
              (i32.eq
               (i32.load8_s offset=2
                (local.get $6)
               )
               (i32.const 36)
              )
             )
            )
           )
          )
         )
         (local.set $17
          (select
           (local.get $8)
           (i32.const -1)
           (local.get $11)
          )
         )
         (select
          (i32.const 1)
          (local.get $1)
          (local.get $11)
         )
        )
        (block (result i32)
         (local.set $6
          (local.get $11)
         )
         (local.set $17
          (i32.const -1)
         )
         (local.get $1)
        )
       )
      )
      (block $label$break$L25
       (if
        (i32.eq
         (i32.and
          (local.tee $11
           (i32.shr_s
            (i32.shl
             (local.get $6)
             (i32.const 24)
            )
            (i32.const 24)
           )
          )
          (i32.const -32)
         )
         (i32.const 32)
        )
        (block
         (local.set $1
          (local.get $6)
         )
         (local.set $6
          (local.get $11)
         )
         (local.set $11
          (i32.const 0)
         )
         (loop $while-in4
          (if
           (i32.eqz
            (i32.and
             (i32.shl
              (i32.const 1)
              (i32.add
               (local.get $6)
               (i32.const -32)
              )
             )
             (i32.const 75913)
            )
           )
           (block
            (local.set $6
             (local.get $1)
            )
            (local.set $1
             (local.get $11)
            )
            (br $label$break$L25)
           )
          )
          (local.set $11
           (i32.or
            (i32.shl
             (i32.const 1)
             (i32.add
              (i32.shr_s
               (i32.shl
                (local.get $1)
                (i32.const 24)
               )
               (i32.const 24)
              )
              (i32.const -32)
             )
            )
            (local.get $11)
           )
          )
          (br_if $while-in4
           (i32.eq
            (i32.and
             (local.tee $6
              (local.tee $1
               (i32.load8_s
                (local.tee $10
                 (i32.add
                  (local.get $10)
                  (i32.const 1)
                 )
                )
               )
              )
             )
             (i32.const -32)
            )
            (i32.const 32)
           )
          )
          (local.set $6
           (local.get $1)
          )
          (local.set $1
           (local.get $11)
          )
         )
        )
        (local.set $1
         (i32.const 0)
        )
       )
      )
      (block $do-once5
       (if
        (i32.eq
         (i32.and
          (local.get $6)
          (i32.const 255)
         )
         (i32.const 42)
        )
        (block
         (local.set $10
          (block $__rjto$0 (result i32)
           (block $__rjti$0
            (br_if $__rjti$0
             (i32.ge_u
              (local.tee $11
               (i32.add
                (i32.load8_s
                 (local.tee $6
                  (i32.add
                   (local.get $10)
                   (i32.const 1)
                  )
                 )
                )
                (i32.const -48)
               )
              )
              (i32.const 10)
             )
            )
            (br_if $__rjti$0
             (i32.ne
              (i32.load8_s offset=2
               (local.get $10)
              )
              (i32.const 36)
             )
            )
            (i32.store
             (i32.add
              (local.get $4)
              (i32.shl
               (local.get $11)
               (i32.const 2)
              )
             )
             (i32.const 10)
            )
            (drop
             (i32.load offset=4
              (local.tee $6
               (i32.add
                (local.get $3)
                (i32.shl
                 (i32.add
                  (i32.load8_s
                   (local.get $6)
                  )
                  (i32.const -48)
                 )
                 (i32.const 3)
                )
               )
              )
             )
            )
            (local.set $8
             (i32.const 1)
            )
            (local.set $14
             (i32.load
              (local.get $6)
             )
            )
            (br $__rjto$0
             (i32.add
              (local.get $10)
              (i32.const 3)
             )
            )
           )
           (if
            (local.get $8)
            (block
             (local.set $16
              (i32.const -1)
             )
             (br $label$break$L1)
            )
           )
           (if
            (i32.eqz
             (local.get $29)
            )
            (block
             (local.set $11
              (local.get $1)
             )
             (local.set $10
              (local.get $6)
             )
             (local.set $1
              (i32.const 0)
             )
             (local.set $14
              (i32.const 0)
             )
             (br $do-once5)
            )
           )
           (local.set $14
            (i32.load
             (local.tee $10
              (i32.and
               (i32.add
                (i32.load
                 (local.get $2)
                )
                (i32.const 3)
               )
               (i32.const -4)
              )
             )
            )
           )
           (i32.store
            (local.get $2)
            (i32.add
             (local.get $10)
             (i32.const 4)
            )
           )
           (local.set $8
            (i32.const 0)
           )
           (local.get $6)
          )
         )
         (local.set $11
          (if (result i32)
           (i32.lt_s
            (local.get $14)
            (i32.const 0)
           )
           (block (result i32)
            (local.set $14
             (i32.sub
              (i32.const 0)
              (local.get $14)
             )
            )
            (i32.or
             (local.get $1)
             (i32.const 8192)
            )
           )
           (local.get $1)
          )
         )
         (local.set $1
          (local.get $8)
         )
        )
        (if
         (i32.lt_u
          (local.tee $6
           (i32.add
            (i32.shr_s
             (i32.shl
              (local.get $6)
              (i32.const 24)
             )
             (i32.const 24)
            )
            (i32.const -48)
           )
          )
          (i32.const 10)
         )
         (block
          (local.set $11
           (i32.const 0)
          )
          (loop $while-in8
           (local.set $6
            (i32.add
             (i32.mul
              (local.get $11)
              (i32.const 10)
             )
             (local.get $6)
            )
           )
           (if
            (i32.lt_u
             (local.tee $9
              (i32.add
               (i32.load8_s
                (local.tee $10
                 (i32.add
                  (local.get $10)
                  (i32.const 1)
                 )
                )
               )
               (i32.const -48)
              )
             )
             (i32.const 10)
            )
            (block
             (local.set $11
              (local.get $6)
             )
             (local.set $6
              (local.get $9)
             )
             (br $while-in8)
            )
           )
          )
          (if
           (i32.lt_s
            (local.get $6)
            (i32.const 0)
           )
           (block
            (local.set $16
             (i32.const -1)
            )
            (br $label$break$L1)
           )
           (block
            (local.set $11
             (local.get $1)
            )
            (local.set $1
             (local.get $8)
            )
            (local.set $14
             (local.get $6)
            )
           )
          )
         )
         (block
          (local.set $11
           (local.get $1)
          )
          (local.set $1
           (local.get $8)
          )
          (local.set $14
           (i32.const 0)
          )
         )
        )
       )
      )
      (local.set $6
       (block $label$break$L46 (result i32)
        (if (result i32)
         (i32.eq
          (i32.load8_s
           (local.get $10)
          )
          (i32.const 46)
         )
         (block (result i32)
          (if
           (i32.ne
            (local.tee $8
             (i32.load8_s
              (local.tee $6
               (i32.add
                (local.get $10)
                (i32.const 1)
               )
              )
             )
            )
            (i32.const 42)
           )
           (block
            (if
             (i32.lt_u
              (local.tee $9
               (i32.add
                (local.get $8)
                (i32.const -48)
               )
              )
              (i32.const 10)
             )
             (block
              (local.set $10
               (local.get $6)
              )
              (local.set $8
               (i32.const 0)
              )
              (local.set $6
               (local.get $9)
              )
             )
             (block
              (local.set $10
               (local.get $6)
              )
              (br $label$break$L46
               (i32.const 0)
              )
             )
            )
            (loop $while-in11
             (drop
              (br_if $label$break$L46
               (local.tee $6
                (i32.add
                 (i32.mul
                  (local.get $8)
                  (i32.const 10)
                 )
                 (local.get $6)
                )
               )
               (i32.ge_u
                (local.tee $9
                 (i32.add
                  (i32.load8_s
                   (local.tee $10
                    (i32.add
                     (local.get $10)
                     (i32.const 1)
                    )
                   )
                  )
                  (i32.const -48)
                 )
                )
                (i32.const 10)
               )
              )
             )
             (local.set $8
              (local.get $6)
             )
             (local.set $6
              (local.get $9)
             )
             (br $while-in11)
            )
           )
          )
          (if
           (i32.lt_u
            (local.tee $8
             (i32.add
              (i32.load8_s
               (local.tee $6
                (i32.add
                 (local.get $10)
                 (i32.const 2)
                )
               )
              )
              (i32.const -48)
             )
            )
            (i32.const 10)
           )
           (if
            (i32.eq
             (i32.load8_s offset=3
              (local.get $10)
             )
             (i32.const 36)
            )
            (block
             (i32.store
              (i32.add
               (local.get $4)
               (i32.shl
                (local.get $8)
                (i32.const 2)
               )
              )
              (i32.const 10)
             )
             (drop
              (i32.load offset=4
               (local.tee $6
                (i32.add
                 (local.get $3)
                 (i32.shl
                  (i32.add
                   (i32.load8_s
                    (local.get $6)
                   )
                   (i32.const -48)
                  )
                  (i32.const 3)
                 )
                )
               )
              )
             )
             (local.set $10
              (i32.add
               (local.get $10)
               (i32.const 4)
              )
             )
             (br $label$break$L46
              (i32.load
               (local.get $6)
              )
             )
            )
           )
          )
          (if
           (local.get $1)
           (block
            (local.set $16
             (i32.const -1)
            )
            (br $label$break$L1)
           )
          )
          (if (result i32)
           (local.get $29)
           (block (result i32)
            (local.set $8
             (i32.load
              (local.tee $10
               (i32.and
                (i32.add
                 (i32.load
                  (local.get $2)
                 )
                 (i32.const 3)
                )
                (i32.const -4)
               )
              )
             )
            )
            (i32.store
             (local.get $2)
             (i32.add
              (local.get $10)
              (i32.const 4)
             )
            )
            (local.set $10
             (local.get $6)
            )
            (local.get $8)
           )
           (block (result i32)
            (local.set $10
             (local.get $6)
            )
            (i32.const 0)
           )
          )
         )
         (i32.const -1)
        )
       )
      )
      (local.set $8
       (local.get $10)
      )
      (local.set $9
       (i32.const 0)
      )
      (loop $while-in13
       (if
        (i32.gt_u
         (local.tee $12
          (i32.add
           (i32.load8_s
            (local.get $8)
           )
           (i32.const -65)
          )
         )
         (i32.const 57)
        )
        (block
         (local.set $16
          (i32.const -1)
         )
         (br $label$break$L1)
        )
       )
       (local.set $10
        (i32.add
         (local.get $8)
         (i32.const 1)
        )
       )
       (if
        (i32.lt_u
         (i32.add
          (local.tee $12
           (i32.and
            (local.tee $13
             (i32.load8_s
              (i32.add
               (i32.add
                (i32.mul
                 (local.get $9)
                 (i32.const 58)
                )
                (i32.const 3611)
               )
               (local.get $12)
              )
             )
            )
            (i32.const 255)
           )
          )
          (i32.const -1)
         )
         (i32.const 8)
        )
        (block
         (local.set $8
          (local.get $10)
         )
         (local.set $9
          (local.get $12)
         )
         (br $while-in13)
        )
        (local.set $18
         (local.get $8)
        )
       )
      )
      (if
       (i32.eqz
        (i32.and
         (local.get $13)
         (i32.const 255)
        )
       )
       (block
        (local.set $16
         (i32.const -1)
        )
        (br $label$break$L1)
       )
      )
      (local.set $8
       (i32.gt_s
        (local.get $17)
        (i32.const -1)
       )
      )
      (block $__rjto$2
       (block $__rjti$2
        (if
         (i32.eq
          (i32.and
           (local.get $13)
           (i32.const 255)
          )
          (i32.const 19)
         )
         (if
          (local.get $8)
          (block
           (local.set $16
            (i32.const -1)
           )
           (br $label$break$L1)
          )
          (br $__rjti$2)
         )
         (block
          (if
           (local.get $8)
           (block
            (i32.store
             (i32.add
              (local.get $4)
              (i32.shl
               (local.get $17)
               (i32.const 2)
              )
             )
             (local.get $12)
            )
            (local.set $13
             (i32.load offset=4
              (local.tee $12
               (i32.add
                (local.get $3)
                (i32.shl
                 (local.get $17)
                 (i32.const 3)
                )
               )
              )
             )
            )
            (i32.store
             (local.tee $8
              (local.get $19)
             )
             (i32.load
              (local.get $12)
             )
            )
            (i32.store offset=4
             (local.get $8)
             (local.get $13)
            )
            (br $__rjti$2)
           )
          )
          (if
           (i32.eqz
            (local.get $29)
           )
           (block
            (local.set $16
             (i32.const 0)
            )
            (br $label$break$L1)
           )
          )
          (call $_pop_arg_336
           (local.get $19)
           (local.get $12)
           (local.get $2)
          )
         )
        )
        (br $__rjto$2)
       )
       (if
        (i32.eqz
         (local.get $29)
        )
        (block
         (local.set $5
          (local.get $10)
         )
         (local.set $10
          (local.get $7)
         )
         (br $label$continue$L1)
        )
       )
      )
      (local.set $11
       (select
        (local.tee $8
         (i32.and
          (local.get $11)
          (i32.const -65537)
         )
        )
        (local.get $11)
        (i32.and
         (local.get $11)
         (i32.const 8192)
        )
       )
      )
      (local.set $5
       (block $__rjto$8 (result i32)
        (block $__rjti$8
         (block $__rjti$7
          (block $__rjti$6
           (block $__rjti$5
            (block $__rjti$4
             (block $__rjti$3
              (block $switch-default120
               (block $switch-case42
                (block $switch-case41
                 (block $switch-case40
                  (block $switch-case39
                   (block $switch-case38
                    (block $switch-case37
                     (block $switch-case36
                      (block $switch-case34
                       (block $switch-case33
                        (block $switch-case29
                         (block $switch-case28
                          (block $switch-case27
                           (br_table $switch-case42 $switch-default120 $switch-case40 $switch-default120 $switch-case42 $switch-case42 $switch-case42 $switch-default120 $switch-default120 $switch-default120 $switch-default120 $switch-default120 $switch-default120 $switch-default120 $switch-default120 $switch-default120 $switch-default120 $switch-default120 $switch-case41 $switch-default120 $switch-default120 $switch-default120 $switch-default120 $switch-case29 $switch-default120 $switch-default120 $switch-default120 $switch-default120 $switch-default120 $switch-default120 $switch-default120 $switch-default120 $switch-case42 $switch-default120 $switch-case37 $switch-case34 $switch-case42 $switch-case42 $switch-case42 $switch-default120 $switch-case34 $switch-default120 $switch-default120 $switch-default120 $switch-case38 $switch-case27 $switch-case33 $switch-case28 $switch-default120 $switch-default120 $switch-case39 $switch-default120 $switch-case36 $switch-default120 $switch-default120 $switch-case29 $switch-default120
                            (i32.sub
                             (local.tee $18
                              (select
                               (i32.and
                                (local.tee $12
                                 (i32.load8_s
                                  (local.get $18)
                                 )
                                )
                                (i32.const -33)
                               )
                               (local.get $12)
                               (i32.and
                                (i32.ne
                                 (local.get $9)
                                 (i32.const 0)
                                )
                                (i32.eq
                                 (i32.and
                                  (local.get $12)
                                  (i32.const 15)
                                 )
                                 (i32.const 3)
                                )
                               )
                              )
                             )
                             (i32.const 65)
                            )
                           )
                          )
                          (block $switch-default26
                           (block $switch-case25
                            (block $switch-case24
                             (block $switch-case23
                              (block $switch-case22
                               (block $switch-case21
                                (block $switch-case20
                                 (block $switch-case19
                                  (br_table $switch-case19 $switch-case20 $switch-case21 $switch-case22 $switch-case23 $switch-default26 $switch-case24 $switch-case25 $switch-default26
                                   (local.get $9)
                                  )
                                 )
                                 (i32.store
                                  (i32.load
                                   (local.get $19)
                                  )
                                  (local.get $16)
                                 )
                                 (local.set $5
                                  (local.get $10)
                                 )
                                 (local.set $10
                                  (local.get $7)
                                 )
                                 (br $label$continue$L1)
                                )
                                (i32.store
                                 (i32.load
                                  (local.get $19)
                                 )
                                 (local.get $16)
                                )
                                (local.set $5
                                 (local.get $10)
                                )
                                (local.set $10
                                 (local.get $7)
                                )
                                (br $label$continue$L1)
                               )
                               (i32.store
                                (local.tee $5
                                 (i32.load
                                  (local.get $19)
                                 )
                                )
                                (local.get $16)
                               )
                               (i32.store offset=4
                                (local.get $5)
                                (i32.shr_s
                                 (i32.shl
                                  (i32.lt_s
                                   (local.get $16)
                                   (i32.const 0)
                                  )
                                  (i32.const 31)
                                 )
                                 (i32.const 31)
                                )
                               )
                               (local.set $5
                                (local.get $10)
                               )
                               (local.set $10
                                (local.get $7)
                               )
                               (br $label$continue$L1)
                              )
                              (i32.store16
                               (i32.load
                                (local.get $19)
                               )
                               (local.get $16)
                              )
                              (local.set $5
                               (local.get $10)
                              )
                              (local.set $10
                               (local.get $7)
                              )
                              (br $label$continue$L1)
                             )
                             (i32.store8
                              (i32.load
                               (local.get $19)
                              )
                              (local.get $16)
                             )
                             (local.set $5
                              (local.get $10)
                             )
                             (local.set $10
                              (local.get $7)
                             )
                             (br $label$continue$L1)
                            )
                            (i32.store
                             (i32.load
                              (local.get $19)
                             )
                             (local.get $16)
                            )
                            (local.set $5
                             (local.get $10)
                            )
                            (local.set $10
                             (local.get $7)
                            )
                            (br $label$continue$L1)
                           )
                           (i32.store
                            (local.tee $5
                             (i32.load
                              (local.get $19)
                             )
                            )
                            (local.get $16)
                           )
                           (i32.store offset=4
                            (local.get $5)
                            (i32.shr_s
                             (i32.shl
                              (i32.lt_s
                               (local.get $16)
                               (i32.const 0)
                              )
                              (i32.const 31)
                             )
                             (i32.const 31)
                            )
                           )
                           (local.set $5
                            (local.get $10)
                           )
                           (local.set $10
                            (local.get $7)
                           )
                           (br $label$continue$L1)
                          )
                          (local.set $5
                           (local.get $10)
                          )
                          (local.set $10
                           (local.get $7)
                          )
                          (br $label$continue$L1)
                         )
                         (local.set $7
                          (i32.or
                           (local.get $11)
                           (i32.const 8)
                          )
                         )
                         (local.set $6
                          (select
                           (local.get $6)
                           (i32.const 8)
                           (i32.gt_u
                            (local.get $6)
                            (i32.const 8)
                           )
                          )
                         )
                         (local.set $18
                          (i32.const 120)
                         )
                         (br $__rjti$3)
                        )
                        (local.set $7
                         (local.get $11)
                        )
                        (br $__rjti$3)
                       )
                       (if
                        (i32.and
                         (i32.eqz
                          (local.tee $7
                           (i32.load
                            (local.tee $5
                             (local.get $19)
                            )
                           )
                          )
                         )
                         (i32.eqz
                          (local.tee $8
                           (i32.load offset=4
                            (local.get $5)
                           )
                          )
                         )
                        )
                        (local.set $8
                         (local.get $26)
                        )
                        (block
                         (local.set $5
                          (local.get $7)
                         )
                         (local.set $7
                          (local.get $8)
                         )
                         (local.set $8
                          (local.get $26)
                         )
                         (loop $while-in32
                          (i32.store8
                           (local.tee $8
                            (i32.add
                             (local.get $8)
                             (i32.const -1)
                            )
                           )
                           (i32.or
                            (i32.and
                             (local.get $5)
                             (i32.const 7)
                            )
                            (i32.const 48)
                           )
                          )
                          (br_if $while-in32
                           (i32.eqz
                            (i32.and
                             (i32.eqz
                              (local.tee $5
                               (call $_bitshift64Lshr
                                (local.get $5)
                                (local.get $7)
                                (i32.const 3)
                               )
                              )
                             )
                             (i32.eqz
                              (local.tee $7
                               (global.get $tempRet0)
                              )
                             )
                            )
                           )
                          )
                         )
                        )
                       )
                       (local.set $5
                        (if (result i32)
                         (i32.and
                          (local.get $11)
                          (i32.const 8)
                         )
                         (block (result i32)
                          (local.set $7
                           (local.get $11)
                          )
                          (local.set $6
                           (select
                            (local.tee $11
                             (i32.add
                              (i32.sub
                               (local.get $39)
                               (local.get $8)
                              )
                              (i32.const 1)
                             )
                            )
                            (local.get $6)
                            (i32.lt_s
                             (local.get $6)
                             (local.get $11)
                            )
                           )
                          )
                          (local.get $8)
                         )
                         (block (result i32)
                          (local.set $7
                           (local.get $11)
                          )
                          (local.get $8)
                         )
                        )
                       )
                       (local.set $8
                        (i32.const 0)
                       )
                       (local.set $9
                        (i32.const 4091)
                       )
                       (br $__rjti$8)
                      )
                      (local.set $5
                       (i32.load
                        (local.tee $7
                         (local.get $19)
                        )
                       )
                      )
                      (if
                       (i32.lt_s
                        (local.tee $7
                         (i32.load offset=4
                          (local.get $7)
                         )
                        )
                        (i32.const 0)
                       )
                       (block
                        (i32.store
                         (local.tee $8
                          (local.get $19)
                         )
                         (local.tee $5
                          (call $_i64Subtract
                           (i32.const 0)
                           (i32.const 0)
                           (local.get $5)
                           (local.get $7)
                          )
                         )
                        )
                        (i32.store offset=4
                         (local.get $8)
                         (local.tee $7
                          (global.get $tempRet0)
                         )
                        )
                        (local.set $8
                         (i32.const 1)
                        )
                        (local.set $9
                         (i32.const 4091)
                        )
                        (br $__rjti$4)
                       )
                      )
                      (local.set $9
                       (if (result i32)
                        (i32.and
                         (local.get $11)
                         (i32.const 2048)
                        )
                        (block (result i32)
                         (local.set $8
                          (i32.const 1)
                         )
                         (i32.const 4092)
                        )
                        (block (result i32)
                         (local.set $8
                          (local.tee $9
                           (i32.and
                            (local.get $11)
                            (i32.const 1)
                           )
                          )
                         )
                         (select
                          (i32.const 4093)
                          (i32.const 4091)
                          (local.get $9)
                         )
                        )
                       )
                      )
                      (br $__rjti$4)
                     )
                     (local.set $5
                      (i32.load
                       (local.tee $7
                        (local.get $19)
                       )
                      )
                     )
                     (local.set $7
                      (i32.load offset=4
                       (local.get $7)
                      )
                     )
                     (local.set $8
                      (i32.const 0)
                     )
                     (local.set $9
                      (i32.const 4091)
                     )
                     (br $__rjti$4)
                    )
                    (drop
                     (i32.load offset=4
                      (local.tee $5
                       (local.get $19)
                      )
                     )
                    )
                    (i32.store8
                     (local.get $40)
                     (i32.load
                      (local.get $5)
                     )
                    )
                    (local.set $7
                     (local.get $40)
                    )
                    (local.set $11
                     (local.get $8)
                    )
                    (local.set $12
                     (i32.const 1)
                    )
                    (local.set $8
                     (i32.const 0)
                    )
                    (local.set $9
                     (i32.const 4091)
                    )
                    (br $__rjto$8
                     (local.get $26)
                    )
                   )
                   (local.set $5
                    (call $_strerror
                     (i32.load
                      (call $___errno_location)
                     )
                    )
                   )
                   (br $__rjti$5)
                  )
                  (local.set $5
                   (select
                    (local.tee $5
                     (i32.load
                      (local.get $19)
                     )
                    )
                    (i32.const 4101)
                    (local.get $5)
                   )
                  )
                  (br $__rjti$5)
                 )
                 (drop
                  (i32.load offset=4
                   (local.tee $5
                    (local.get $19)
                   )
                  )
                 )
                 (i32.store
                  (local.get $41)
                  (i32.load
                   (local.get $5)
                  )
                 )
                 (i32.store
                  (local.get $44)
                  (i32.const 0)
                 )
                 (i32.store
                  (local.get $19)
                  (local.get $41)
                 )
                 (local.set $8
                  (i32.const -1)
                 )
                 (br $__rjti$6)
                )
                (if
                 (local.get $6)
                 (block
                  (local.set $8
                   (local.get $6)
                  )
                  (br $__rjti$6)
                 )
                 (block
                  (call $_pad
                   (local.get $0)
                   (i32.const 32)
                   (local.get $14)
                   (i32.const 0)
                   (local.get $11)
                  )
                  (local.set $7
                   (i32.const 0)
                  )
                  (br $__rjti$7)
                 )
                )
               )
               (local.set $15
                (f64.load
                 (local.get $19)
                )
               )
               (i32.store
                (local.get $20)
                (i32.const 0)
               )
               (f64.store
                (global.get $tempDoublePtr)
                (local.get $15)
               )
               (drop
                (i32.load
                 (global.get $tempDoublePtr)
                )
               )
               (local.set $31
                (if (result i32)
                 (i32.lt_s
                  (i32.load offset=4
                   (global.get $tempDoublePtr)
                  )
                  (i32.const 0)
                 )
                 (block (result i32)
                  (local.set $27
                   (i32.const 1)
                  )
                  (local.set $15
                   (f64.neg
                    (local.get $15)
                   )
                  )
                  (i32.const 4108)
                 )
                 (if (result i32)
                  (i32.and
                   (local.get $11)
                   (i32.const 2048)
                  )
                  (block (result i32)
                   (local.set $27
                    (i32.const 1)
                   )
                   (i32.const 4111)
                  )
                  (block (result i32)
                   (local.set $27
                    (local.tee $5
                     (i32.and
                      (local.get $11)
                      (i32.const 1)
                     )
                    )
                   )
                   (select
                    (i32.const 4114)
                    (i32.const 4109)
                    (local.get $5)
                   )
                  )
                 )
                )
               )
               (f64.store
                (global.get $tempDoublePtr)
                (local.get $15)
               )
               (drop
                (i32.load
                 (global.get $tempDoublePtr)
                )
               )
               (local.set $7
                (block $do-once49 (result i32)
                 (if (result i32)
                  (i32.or
                   (i32.lt_u
                    (local.tee $5
                     (i32.and
                      (i32.load offset=4
                       (global.get $tempDoublePtr)
                      )
                      (i32.const 2146435072)
                     )
                    )
                    (i32.const 2146435072)
                   )
                   (i32.and
                    (i32.eq
                     (local.get $5)
                     (i32.const 2146435072)
                    )
                    (i32.const 0)
                   )
                  )
                  (block (result i32)
                   (if
                    (local.tee $5
                     (f64.ne
                      (local.tee $23
                       (f64.mul
                        (call $_frexp
                         (local.get $15)
                         (local.tee $5
                          (local.get $20)
                         )
                        )
                        (f64.const 2)
                       )
                      )
                      (f64.const 0)
                     )
                    )
                    (i32.store
                     (local.get $20)
                     (i32.add
                      (i32.load
                       (local.get $20)
                      )
                      (i32.const -1)
                     )
                    )
                   )
                   (if
                    (i32.eq
                     (local.tee $24
                      (i32.or
                       (local.get $18)
                       (i32.const 32)
                      )
                     )
                     (i32.const 97)
                    )
                    (block
                     (local.set $9
                      (select
                       (i32.add
                        (local.get $31)
                        (i32.const 9)
                       )
                       (local.get $31)
                       (local.tee $13
                        (i32.and
                         (local.get $18)
                         (i32.const 32)
                        )
                       )
                      )
                     )
                     (local.set $15
                      (if (result f64)
                       (i32.or
                        (i32.gt_u
                         (local.get $6)
                         (i32.const 11)
                        )
                        (i32.eqz
                         (local.tee $5
                          (i32.sub
                           (i32.const 12)
                           (local.get $6)
                          )
                         )
                        )
                       )
                       (local.get $23)
                       (block (result f64)
                        (local.set $15
                         (f64.const 8)
                        )
                        (loop $while-in54
                         (local.set $15
                          (f64.mul
                           (local.get $15)
                           (f64.const 16)
                          )
                         )
                         (br_if $while-in54
                          (local.tee $5
                           (i32.add
                            (local.get $5)
                            (i32.const -1)
                           )
                          )
                         )
                        )
                        (if (result f64)
                         (i32.eq
                          (i32.load8_s
                           (local.get $9)
                          )
                          (i32.const 45)
                         )
                         (f64.neg
                          (f64.add
                           (local.get $15)
                           (f64.sub
                            (f64.neg
                             (local.get $23)
                            )
                            (local.get $15)
                           )
                          )
                         )
                         (f64.sub
                          (f64.add
                           (local.get $23)
                           (local.get $15)
                          )
                          (local.get $15)
                         )
                        )
                       )
                      )
                     )
                     (if
                      (i32.eq
                       (local.tee $5
                        (call $_fmt_u
                         (local.tee $5
                          (select
                           (i32.sub
                            (i32.const 0)
                            (local.tee $7
                             (i32.load
                              (local.get $20)
                             )
                            )
                           )
                           (local.get $7)
                           (i32.lt_s
                            (local.get $7)
                            (i32.const 0)
                           )
                          )
                         )
                         (i32.shr_s
                          (i32.shl
                           (i32.lt_s
                            (local.get $5)
                            (i32.const 0)
                           )
                           (i32.const 31)
                          )
                          (i32.const 31)
                         )
                         (local.get $34)
                        )
                       )
                       (local.get $34)
                      )
                      (block
                       (i32.store8
                        (local.get $42)
                        (i32.const 48)
                       )
                       (local.set $5
                        (local.get $42)
                       )
                      )
                     )
                     (local.set $12
                      (i32.or
                       (local.get $27)
                       (i32.const 2)
                      )
                     )
                     (i32.store8
                      (i32.add
                       (local.get $5)
                       (i32.const -1)
                      )
                      (i32.add
                       (i32.and
                        (i32.shr_s
                         (local.get $7)
                         (i32.const 31)
                        )
                        (i32.const 2)
                       )
                       (i32.const 43)
                      )
                     )
                     (i32.store8
                      (local.tee $8
                       (i32.add
                        (local.get $5)
                        (i32.const -2)
                       )
                      )
                      (i32.add
                       (local.get $18)
                       (i32.const 15)
                      )
                     )
                     (local.set $18
                      (i32.lt_s
                       (local.get $6)
                       (i32.const 1)
                      )
                     )
                     (local.set $17
                      (i32.eqz
                       (i32.and
                        (local.get $11)
                        (i32.const 8)
                       )
                      )
                     )
                     (local.set $5
                      (local.get $22)
                     )
                     (loop $while-in56
                      (i32.store8
                       (local.get $5)
                       (i32.or
                        (i32.load8_u
                         (i32.add
                          (local.tee $7
                           (call $f64-to-int
                            (local.get $15)
                           )
                          )
                          (i32.const 4075)
                         )
                        )
                        (local.get $13)
                       )
                      )
                      (local.set $15
                       (f64.mul
                        (f64.sub
                         (local.get $15)
                         (f64.convert_i32_s
                          (local.get $7)
                         )
                        )
                        (f64.const 16)
                       )
                      )
                      (local.set $5
                       (block $do-once57 (result i32)
                        (if (result i32)
                         (i32.eq
                          (i32.sub
                           (local.tee $7
                            (i32.add
                             (local.get $5)
                             (i32.const 1)
                            )
                           )
                           (local.get $37)
                          )
                          (i32.const 1)
                         )
                         (block (result i32)
                          (drop
                           (br_if $do-once57
                            (local.get $7)
                            (i32.and
                             (local.get $17)
                             (i32.and
                              (local.get $18)
                              (f64.eq
                               (local.get $15)
                               (f64.const 0)
                              )
                             )
                            )
                           )
                          )
                          (i32.store8
                           (local.get $7)
                           (i32.const 46)
                          )
                          (i32.add
                           (local.get $5)
                           (i32.const 2)
                          )
                         )
                         (local.get $7)
                        )
                       )
                      )
                      (br_if $while-in56
                       (f64.ne
                        (local.get $15)
                        (f64.const 0)
                       )
                      )
                     )
                     (call $_pad
                      (local.get $0)
                      (i32.const 32)
                      (local.get $14)
                      (local.tee $7
                       (i32.add
                        (local.tee $6
                         (select
                          (i32.sub
                           (i32.add
                            (local.get $47)
                            (local.get $6)
                           )
                           (local.get $8)
                          )
                          (i32.add
                           (i32.sub
                            (local.get $45)
                            (local.get $8)
                           )
                           (local.get $5)
                          )
                          (i32.and
                           (i32.ne
                            (local.get $6)
                            (i32.const 0)
                           )
                           (i32.lt_s
                            (i32.add
                             (local.get $46)
                             (local.get $5)
                            )
                            (local.get $6)
                           )
                          )
                         )
                        )
                        (local.get $12)
                       )
                      )
                      (local.get $11)
                     )
                     (if
                      (i32.eqz
                       (i32.and
                        (i32.load
                         (local.get $0)
                        )
                        (i32.const 32)
                       )
                      )
                      (drop
                       (call $___fwritex
                        (local.get $9)
                        (local.get $12)
                        (local.get $0)
                       )
                      )
                     )
                     (call $_pad
                      (local.get $0)
                      (i32.const 48)
                      (local.get $14)
                      (local.get $7)
                      (i32.xor
                       (local.get $11)
                       (i32.const 65536)
                      )
                     )
                     (local.set $5
                      (i32.sub
                       (local.get $5)
                       (local.get $37)
                      )
                     )
                     (if
                      (i32.eqz
                       (i32.and
                        (i32.load
                         (local.get $0)
                        )
                        (i32.const 32)
                       )
                      )
                      (drop
                       (call $___fwritex
                        (local.get $22)
                        (local.get $5)
                        (local.get $0)
                       )
                      )
                     )
                     (call $_pad
                      (local.get $0)
                      (i32.const 48)
                      (i32.sub
                       (local.get $6)
                       (i32.add
                        (local.get $5)
                        (local.tee $5
                         (i32.sub
                          (local.get $28)
                          (local.get $8)
                         )
                        )
                       )
                      )
                      (i32.const 0)
                      (i32.const 0)
                     )
                     (if
                      (i32.eqz
                       (i32.and
                        (i32.load
                         (local.get $0)
                        )
                        (i32.const 32)
                       )
                      )
                      (drop
                       (call $___fwritex
                        (local.get $8)
                        (local.get $5)
                        (local.get $0)
                       )
                      )
                     )
                     (call $_pad
                      (local.get $0)
                      (i32.const 32)
                      (local.get $14)
                      (local.get $7)
                      (i32.xor
                       (local.get $11)
                       (i32.const 8192)
                      )
                     )
                     (br $do-once49
                      (select
                       (local.get $14)
                       (local.get $7)
                       (i32.lt_s
                        (local.get $7)
                        (local.get $14)
                       )
                      )
                     )
                    )
                   )
                   (local.set $15
                    (if (result f64)
                     (local.get $5)
                     (block (result f64)
                      (i32.store
                       (local.get $20)
                       (local.tee $5
                        (i32.add
                         (i32.load
                          (local.get $20)
                         )
                         (i32.const -28)
                        )
                       )
                      )
                      (f64.mul
                       (local.get $23)
                       (f64.const 268435456)
                      )
                     )
                     (block (result f64)
                      (local.set $5
                       (i32.load
                        (local.get $20)
                       )
                      )
                      (local.get $23)
                     )
                    )
                   )
                   (local.set $7
                    (local.tee $8
                     (select
                      (local.get $48)
                      (local.get $49)
                      (i32.lt_s
                       (local.get $5)
                       (i32.const 0)
                      )
                     )
                    )
                   )
                   (loop $while-in60
                    (i32.store
                     (local.get $7)
                     (local.tee $5
                      (call $f64-to-int
                       (local.get $15)
                      )
                     )
                    )
                    (local.set $7
                     (i32.add
                      (local.get $7)
                      (i32.const 4)
                     )
                    )
                    (br_if $while-in60
                     (f64.ne
                      (local.tee $15
                       (f64.mul
                        (f64.sub
                         (local.get $15)
                         (f64.convert_i32_u
                          (local.get $5)
                         )
                        )
                        (f64.const 1e9)
                       )
                      )
                      (f64.const 0)
                     )
                    )
                   )
                   (if
                    (i32.gt_s
                     (local.tee $9
                      (i32.load
                       (local.get $20)
                      )
                     )
                     (i32.const 0)
                    )
                    (block
                     (local.set $5
                      (local.get $8)
                     )
                     (loop $while-in62
                      (local.set $13
                       (select
                        (i32.const 29)
                        (local.get $9)
                        (i32.gt_s
                         (local.get $9)
                         (i32.const 29)
                        )
                       )
                      )
                      (block $do-once63
                       (if
                        (i32.ge_u
                         (local.tee $9
                          (i32.add
                           (local.get $7)
                           (i32.const -4)
                          )
                         )
                         (local.get $5)
                        )
                        (block
                         (local.set $12
                          (i32.const 0)
                         )
                         (loop $while-in66
                          (i32.store
                           (local.get $9)
                           (call $___uremdi3
                            (local.tee $12
                             (call $_i64Add
                              (call $_bitshift64Shl
                               (i32.load
                                (local.get $9)
                               )
                               (i32.const 0)
                               (local.get $13)
                              )
                              (global.get $tempRet0)
                              (local.get $12)
                              (i32.const 0)
                             )
                            )
                            (local.tee $17
                             (global.get $tempRet0)
                            )
                            (i32.const 1000000000)
                            (i32.const 0)
                           )
                          )
                          (local.set $12
                           (call $___udivdi3
                            (local.get $12)
                            (local.get $17)
                            (i32.const 1000000000)
                            (i32.const 0)
                           )
                          )
                          (br_if $while-in66
                           (i32.ge_u
                            (local.tee $9
                             (i32.add
                              (local.get $9)
                              (i32.const -4)
                             )
                            )
                            (local.get $5)
                           )
                          )
                         )
                         (br_if $do-once63
                          (i32.eqz
                           (local.get $12)
                          )
                         )
                         (i32.store
                          (local.tee $5
                           (i32.add
                            (local.get $5)
                            (i32.const -4)
                           )
                          )
                          (local.get $12)
                         )
                        )
                       )
                      )
                      (loop $while-in68
                       (if
                        (i32.gt_u
                         (local.get $7)
                         (local.get $5)
                        )
                        (if
                         (i32.eqz
                          (i32.load
                           (local.tee $9
                            (i32.add
                             (local.get $7)
                             (i32.const -4)
                            )
                           )
                          )
                         )
                         (block
                          (local.set $7
                           (local.get $9)
                          )
                          (br $while-in68)
                         )
                        )
                       )
                      )
                      (i32.store
                       (local.get $20)
                       (local.tee $9
                        (i32.sub
                         (i32.load
                          (local.get $20)
                         )
                         (local.get $13)
                        )
                       )
                      )
                      (br_if $while-in62
                       (i32.gt_s
                        (local.get $9)
                        (i32.const 0)
                       )
                      )
                     )
                    )
                    (local.set $5
                     (local.get $8)
                    )
                   )
                   (local.set $17
                    (select
                     (i32.const 6)
                     (local.get $6)
                     (i32.lt_s
                      (local.get $6)
                      (i32.const 0)
                     )
                    )
                   )
                   (if
                    (i32.lt_s
                     (local.get $9)
                     (i32.const 0)
                    )
                    (block
                     (local.set $21
                      (i32.add
                       (call $i32s-div
                        (i32.add
                         (local.get $17)
                         (i32.const 25)
                        )
                        (i32.const 9)
                       )
                       (i32.const 1)
                      )
                     )
                     (local.set $32
                      (i32.eq
                       (local.get $24)
                       (i32.const 102)
                      )
                     )
                     (local.set $6
                      (local.get $5)
                     )
                     (local.set $5
                      (local.get $7)
                     )
                     (loop $while-in70
                      (local.set $13
                       (select
                        (i32.const 9)
                        (local.tee $7
                         (i32.sub
                          (i32.const 0)
                          (local.get $9)
                         )
                        )
                        (i32.gt_s
                         (local.get $7)
                         (i32.const 9)
                        )
                       )
                      )
                      (block $do-once71
                       (if
                        (i32.lt_u
                         (local.get $6)
                         (local.get $5)
                        )
                        (block
                         (local.set $12
                          (i32.add
                           (i32.shl
                            (i32.const 1)
                            (local.get $13)
                           )
                           (i32.const -1)
                          )
                         )
                         (local.set $38
                          (i32.shr_u
                           (i32.const 1000000000)
                           (local.get $13)
                          )
                         )
                         (local.set $9
                          (i32.const 0)
                         )
                         (local.set $7
                          (local.get $6)
                         )
                         (loop $while-in74
                          (i32.store
                           (local.get $7)
                           (i32.add
                            (i32.shr_u
                             (local.tee $33
                              (i32.load
                               (local.get $7)
                              )
                             )
                             (local.get $13)
                            )
                            (local.get $9)
                           )
                          )
                          (local.set $9
                           (i32.mul
                            (i32.and
                             (local.get $33)
                             (local.get $12)
                            )
                            (local.get $38)
                           )
                          )
                          (br_if $while-in74
                           (i32.lt_u
                            (local.tee $7
                             (i32.add
                              (local.get $7)
                              (i32.const 4)
                             )
                            )
                            (local.get $5)
                           )
                          )
                         )
                         (local.set $7
                          (select
                           (local.get $6)
                           (i32.add
                            (local.get $6)
                            (i32.const 4)
                           )
                           (i32.load
                            (local.get $6)
                           )
                          )
                         )
                         (br_if $do-once71
                          (i32.eqz
                           (local.get $9)
                          )
                         )
                         (i32.store
                          (local.get $5)
                          (local.get $9)
                         )
                         (local.set $5
                          (i32.add
                           (local.get $5)
                           (i32.const 4)
                          )
                         )
                        )
                        (local.set $7
                         (select
                          (local.get $6)
                          (i32.add
                           (local.get $6)
                           (i32.const 4)
                          )
                          (i32.load
                           (local.get $6)
                          )
                         )
                        )
                       )
                      )
                      (local.set $12
                       (select
                        (i32.add
                         (local.tee $6
                          (select
                           (local.get $8)
                           (local.get $7)
                           (local.get $32)
                          )
                         )
                         (i32.shl
                          (local.get $21)
                          (i32.const 2)
                         )
                        )
                        (local.get $5)
                        (i32.gt_s
                         (i32.shr_s
                          (i32.sub
                           (local.get $5)
                           (local.get $6)
                          )
                          (i32.const 2)
                         )
                         (local.get $21)
                        )
                       )
                      )
                      (i32.store
                       (local.get $20)
                       (local.tee $9
                        (i32.add
                         (i32.load
                          (local.get $20)
                         )
                         (local.get $13)
                        )
                       )
                      )
                      (if
                       (i32.lt_s
                        (local.get $9)
                        (i32.const 0)
                       )
                       (block
                        (local.set $6
                         (local.get $7)
                        )
                        (local.set $5
                         (local.get $12)
                        )
                        (br $while-in70)
                       )
                       (block
                        (local.set $5
                         (local.get $7)
                        )
                        (local.set $9
                         (local.get $12)
                        )
                       )
                      )
                     )
                    )
                    (local.set $9
                     (local.get $7)
                    )
                   )
                   (local.set $21
                    (local.get $8)
                   )
                   (block $do-once75
                    (if
                     (i32.lt_u
                      (local.get $5)
                      (local.get $9)
                     )
                     (block
                      (local.set $7
                       (i32.mul
                        (i32.shr_s
                         (i32.sub
                          (local.get $21)
                          (local.get $5)
                         )
                         (i32.const 2)
                        )
                        (i32.const 9)
                       )
                      )
                      (br_if $do-once75
                       (i32.lt_u
                        (local.tee $12
                         (i32.load
                          (local.get $5)
                         )
                        )
                        (i32.const 10)
                       )
                      )
                      (local.set $6
                       (i32.const 10)
                      )
                      (loop $while-in78
                       (local.set $7
                        (i32.add
                         (local.get $7)
                         (i32.const 1)
                        )
                       )
                       (br_if $while-in78
                        (i32.ge_u
                         (local.get $12)
                         (local.tee $6
                          (i32.mul
                           (local.get $6)
                           (i32.const 10)
                          )
                         )
                        )
                       )
                      )
                     )
                     (local.set $7
                      (i32.const 0)
                     )
                    )
                   )
                   (local.set $5
                    (if (result i32)
                     (i32.lt_s
                      (local.tee $6
                       (i32.add
                        (i32.sub
                         (local.get $17)
                         (select
                          (local.get $7)
                          (i32.const 0)
                          (i32.ne
                           (local.get $24)
                           (i32.const 102)
                          )
                         )
                        )
                        (i32.shr_s
                         (i32.shl
                          (i32.and
                           (local.tee $32
                            (i32.ne
                             (local.get $17)
                             (i32.const 0)
                            )
                           )
                           (local.tee $38
                            (i32.eq
                             (local.get $24)
                             (i32.const 103)
                            )
                           )
                          )
                          (i32.const 31)
                         )
                         (i32.const 31)
                        )
                       )
                      )
                      (i32.add
                       (i32.mul
                        (i32.shr_s
                         (i32.sub
                          (local.get $9)
                          (local.get $21)
                         )
                         (i32.const 2)
                        )
                        (i32.const 9)
                       )
                       (i32.const -9)
                      )
                     )
                     (block (result i32)
                      (local.set $13
                       (call $i32s-div
                        (local.tee $6
                         (i32.add
                          (local.get $6)
                          (i32.const 9216)
                         )
                        )
                        (i32.const 9)
                       )
                      )
                      (if
                       (i32.lt_s
                        (local.tee $6
                         (i32.add
                          (if (result i32)
                           (local.tee $12
                            (i32.const 9)
                           )
                           (i32.rem_s
                            (local.get $6)
                            (local.get $12)
                           )
                           (i32.const 0)
                          )
                          (i32.const 1)
                         )
                        )
                        (i32.const 9)
                       )
                       (block
                        (local.set $12
                         (i32.const 10)
                        )
                        (loop $while-in80
                         (local.set $12
                          (i32.mul
                           (local.get $12)
                           (i32.const 10)
                          )
                         )
                         (br_if $while-in80
                          (i32.ne
                           (local.tee $6
                            (i32.add
                             (local.get $6)
                             (i32.const 1)
                            )
                           )
                           (i32.const 9)
                          )
                         )
                        )
                       )
                       (local.set $12
                        (i32.const 10)
                       )
                      )
                      (local.set $13
                       (call $i32u-rem
                        (local.tee $24
                         (i32.load
                          (local.tee $6
                           (i32.add
                            (i32.add
                             (local.get $8)
                             (i32.shl
                              (local.get $13)
                              (i32.const 2)
                             )
                            )
                            (i32.const -4092)
                           )
                          )
                         )
                        )
                        (local.get $12)
                       )
                      )
                      (block $do-once81
                       (if
                        (i32.eqz
                         (i32.and
                          (local.tee $33
                           (i32.eq
                            (i32.add
                             (local.get $6)
                             (i32.const 4)
                            )
                            (local.get $9)
                           )
                          )
                          (i32.eqz
                           (local.get $13)
                          )
                         )
                        )
                        (block
                         (local.set $50
                          (call $i32u-div
                           (local.get $24)
                           (local.get $12)
                          )
                         )
                         (local.set $15
                          (if (result f64)
                           (i32.lt_u
                            (local.get $13)
                            (local.tee $51
                             (call $i32s-div
                              (local.get $12)
                              (i32.const 2)
                             )
                            )
                           )
                           (f64.const 0.5)
                           (select
                            (f64.const 1)
                            (f64.const 1.5)
                            (i32.and
                             (local.get $33)
                             (i32.eq
                              (local.get $13)
                              (local.get $51)
                             )
                            )
                           )
                          )
                         )
                         (local.set $23
                          (select
                           (f64.const 9007199254740994)
                           (f64.const 9007199254740992)
                           (i32.and
                            (local.get $50)
                            (i32.const 1)
                           )
                          )
                         )
                         (block $do-once83
                          (if
                           (local.get $27)
                           (block
                            (br_if $do-once83
                             (i32.ne
                              (i32.load8_s
                               (local.get $31)
                              )
                              (i32.const 45)
                             )
                            )
                            (local.set $23
                             (f64.neg
                              (local.get $23)
                             )
                            )
                            (local.set $15
                             (f64.neg
                              (local.get $15)
                             )
                            )
                           )
                          )
                         )
                         (i32.store
                          (local.get $6)
                          (local.tee $13
                           (i32.sub
                            (local.get $24)
                            (local.get $13)
                           )
                          )
                         )
                         (br_if $do-once81
                          (f64.eq
                           (f64.add
                            (local.get $23)
                            (local.get $15)
                           )
                           (local.get $23)
                          )
                         )
                         (i32.store
                          (local.get $6)
                          (local.tee $7
                           (i32.add
                            (local.get $13)
                            (local.get $12)
                           )
                          )
                         )
                         (if
                          (i32.gt_u
                           (local.get $7)
                           (i32.const 999999999)
                          )
                          (loop $while-in86
                           (i32.store
                            (local.get $6)
                            (i32.const 0)
                           )
                           (if
                            (i32.lt_u
                             (local.tee $6
                              (i32.add
                               (local.get $6)
                               (i32.const -4)
                              )
                             )
                             (local.get $5)
                            )
                            (i32.store
                             (local.tee $5
                              (i32.add
                               (local.get $5)
                               (i32.const -4)
                              )
                             )
                             (i32.const 0)
                            )
                           )
                           (i32.store
                            (local.get $6)
                            (local.tee $7
                             (i32.add
                              (i32.load
                               (local.get $6)
                              )
                              (i32.const 1)
                             )
                            )
                           )
                           (br_if $while-in86
                            (i32.gt_u
                             (local.get $7)
                             (i32.const 999999999)
                            )
                           )
                          )
                         )
                         (local.set $7
                          (i32.mul
                           (i32.shr_s
                            (i32.sub
                             (local.get $21)
                             (local.get $5)
                            )
                            (i32.const 2)
                           )
                           (i32.const 9)
                          )
                         )
                         (br_if $do-once81
                          (i32.lt_u
                           (local.tee $13
                            (i32.load
                             (local.get $5)
                            )
                           )
                           (i32.const 10)
                          )
                         )
                         (local.set $12
                          (i32.const 10)
                         )
                         (loop $while-in88
                          (local.set $7
                           (i32.add
                            (local.get $7)
                            (i32.const 1)
                           )
                          )
                          (br_if $while-in88
                           (i32.ge_u
                            (local.get $13)
                            (local.tee $12
                             (i32.mul
                              (local.get $12)
                              (i32.const 10)
                             )
                            )
                           )
                          )
                         )
                        )
                       )
                      )
                      (local.set $12
                       (local.get $5)
                      )
                      (local.set $13
                       (local.get $7)
                      )
                      (select
                       (local.tee $5
                        (i32.add
                         (local.get $6)
                         (i32.const 4)
                        )
                       )
                       (local.get $9)
                       (i32.gt_u
                        (local.get $9)
                        (local.get $5)
                       )
                      )
                     )
                     (block (result i32)
                      (local.set $12
                       (local.get $5)
                      )
                      (local.set $13
                       (local.get $7)
                      )
                      (local.get $9)
                     )
                    )
                   )
                   (local.set $33
                    (i32.sub
                     (i32.const 0)
                     (local.get $13)
                    )
                   )
                   (loop $while-in90
                    (block $while-out89
                     (if
                      (i32.le_u
                       (local.get $5)
                       (local.get $12)
                      )
                      (block
                       (local.set $24
                        (i32.const 0)
                       )
                       (local.set $9
                        (local.get $5)
                       )
                       (br $while-out89)
                      )
                     )
                     (if
                      (i32.load
                       (local.tee $7
                        (i32.add
                         (local.get $5)
                         (i32.const -4)
                        )
                       )
                      )
                      (block
                       (local.set $24
                        (i32.const 1)
                       )
                       (local.set $9
                        (local.get $5)
                       )
                      )
                      (block
                       (local.set $5
                        (local.get $7)
                       )
                       (br $while-in90)
                      )
                     )
                    )
                   )
                   (call $_pad
                    (local.get $0)
                    (i32.const 32)
                    (local.get $14)
                    (local.tee $13
                     (i32.add
                      (i32.add
                       (i32.add
                        (i32.add
                         (local.get $27)
                         (i32.const 1)
                        )
                        (local.tee $5
                         (block $do-once91 (result i32)
                          (if (result i32)
                           (local.get $38)
                           (block (result i32)
                            (local.set $7
                             (if (result i32)
                              (i32.and
                               (i32.gt_s
                                (local.tee $5
                                 (i32.add
                                  (i32.xor
                                   (local.get $32)
                                   (i32.const 1)
                                  )
                                  (local.get $17)
                                 )
                                )
                                (local.get $13)
                               )
                               (i32.gt_s
                                (local.get $13)
                                (i32.const -5)
                               )
                              )
                              (block (result i32)
                               (local.set $17
                                (i32.sub
                                 (i32.add
                                  (local.get $5)
                                  (i32.const -1)
                                 )
                                 (local.get $13)
                                )
                               )
                               (i32.add
                                (local.get $18)
                                (i32.const -1)
                               )
                              )
                              (block (result i32)
                               (local.set $17
                                (i32.add
                                 (local.get $5)
                                 (i32.const -1)
                                )
                               )
                               (i32.add
                                (local.get $18)
                                (i32.const -2)
                               )
                              )
                             )
                            )
                            (if
                             (local.tee $5
                              (i32.and
                               (local.get $11)
                               (i32.const 8)
                              )
                             )
                             (block
                              (local.set $21
                               (local.get $5)
                              )
                              (br $do-once91
                               (local.get $17)
                              )
                             )
                            )
                            (block $do-once93
                             (if
                              (local.get $24)
                              (block
                               (if
                                (i32.eqz
                                 (local.tee $18
                                  (i32.load
                                   (i32.add
                                    (local.get $9)
                                    (i32.const -4)
                                   )
                                  )
                                 )
                                )
                                (block
                                 (local.set $5
                                  (i32.const 9)
                                 )
                                 (br $do-once93)
                                )
                               )
                               (if
                                (call $i32u-rem
                                 (local.get $18)
                                 (i32.const 10)
                                )
                                (block
                                 (local.set $5
                                  (i32.const 0)
                                 )
                                 (br $do-once93)
                                )
                                (block
                                 (local.set $6
                                  (i32.const 10)
                                 )
                                 (local.set $5
                                  (i32.const 0)
                                 )
                                )
                               )
                               (loop $while-in96
                                (local.set $5
                                 (i32.add
                                  (local.get $5)
                                  (i32.const 1)
                                 )
                                )
                                (br_if $while-in96
                                 (i32.eqz
                                  (call $i32u-rem
                                   (local.get $18)
                                   (local.tee $6
                                    (i32.mul
                                     (local.get $6)
                                     (i32.const 10)
                                    )
                                   )
                                  )
                                 )
                                )
                               )
                              )
                              (local.set $5
                               (i32.const 9)
                              )
                             )
                            )
                            (local.set $6
                             (i32.add
                              (i32.mul
                               (i32.shr_s
                                (i32.sub
                                 (local.get $9)
                                 (local.get $21)
                                )
                                (i32.const 2)
                               )
                               (i32.const 9)
                              )
                              (i32.const -9)
                             )
                            )
                            (if (result i32)
                             (i32.eq
                              (i32.or
                               (local.get $7)
                               (i32.const 32)
                              )
                              (i32.const 102)
                             )
                             (block (result i32)
                              (local.set $21
                               (i32.const 0)
                              )
                              (select
                               (local.get $17)
                               (local.tee $5
                                (select
                                 (i32.const 0)
                                 (local.tee $5
                                  (i32.sub
                                   (local.get $6)
                                   (local.get $5)
                                  )
                                 )
                                 (i32.lt_s
                                  (local.get $5)
                                  (i32.const 0)
                                 )
                                )
                               )
                               (i32.lt_s
                                (local.get $17)
                                (local.get $5)
                               )
                              )
                             )
                             (block (result i32)
                              (local.set $21
                               (i32.const 0)
                              )
                              (select
                               (local.get $17)
                               (local.tee $5
                                (select
                                 (i32.const 0)
                                 (local.tee $5
                                  (i32.sub
                                   (i32.add
                                    (local.get $6)
                                    (local.get $13)
                                   )
                                   (local.get $5)
                                  )
                                 )
                                 (i32.lt_s
                                  (local.get $5)
                                  (i32.const 0)
                                 )
                                )
                               )
                               (i32.lt_s
                                (local.get $17)
                                (local.get $5)
                               )
                              )
                             )
                            )
                           )
                           (block (result i32)
                            (local.set $21
                             (i32.and
                              (local.get $11)
                              (i32.const 8)
                             )
                            )
                            (local.set $7
                             (local.get $18)
                            )
                            (local.get $17)
                           )
                          )
                         )
                        )
                       )
                       (i32.ne
                        (local.tee $32
                         (i32.or
                          (local.get $5)
                          (local.get $21)
                         )
                        )
                        (i32.const 0)
                       )
                      )
                      (if (result i32)
                       (local.tee $17
                        (i32.eq
                         (i32.or
                          (local.get $7)
                          (i32.const 32)
                         )
                         (i32.const 102)
                        )
                       )
                       (block (result i32)
                        (local.set $18
                         (i32.const 0)
                        )
                        (select
                         (local.get $13)
                         (i32.const 0)
                         (i32.gt_s
                          (local.get $13)
                          (i32.const 0)
                         )
                        )
                       )
                       (block (result i32)
                        (if
                         (i32.lt_s
                          (i32.sub
                           (local.get $28)
                           (local.tee $6
                            (call $_fmt_u
                             (local.tee $6
                              (select
                               (local.get $33)
                               (local.get $13)
                               (i32.lt_s
                                (local.get $13)
                                (i32.const 0)
                               )
                              )
                             )
                             (i32.shr_s
                              (i32.shl
                               (i32.lt_s
                                (local.get $6)
                                (i32.const 0)
                               )
                               (i32.const 31)
                              )
                              (i32.const 31)
                             )
                             (local.get $34)
                            )
                           )
                          )
                          (i32.const 2)
                         )
                         (loop $while-in98
                          (i32.store8
                           (local.tee $6
                            (i32.add
                             (local.get $6)
                             (i32.const -1)
                            )
                           )
                           (i32.const 48)
                          )
                          (br_if $while-in98
                           (i32.lt_s
                            (i32.sub
                             (local.get $28)
                             (local.get $6)
                            )
                            (i32.const 2)
                           )
                          )
                         )
                        )
                        (i32.store8
                         (i32.add
                          (local.get $6)
                          (i32.const -1)
                         )
                         (i32.add
                          (i32.and
                           (i32.shr_s
                            (local.get $13)
                            (i32.const 31)
                           )
                           (i32.const 2)
                          )
                          (i32.const 43)
                         )
                        )
                        (i32.store8
                         (local.tee $6
                          (i32.add
                           (local.get $6)
                           (i32.const -2)
                          )
                         )
                         (local.get $7)
                        )
                        (local.set $18
                         (local.get $6)
                        )
                        (i32.sub
                         (local.get $28)
                         (local.get $6)
                        )
                       )
                      )
                     )
                    )
                    (local.get $11)
                   )
                   (if
                    (i32.eqz
                     (i32.and
                      (i32.load
                       (local.get $0)
                      )
                      (i32.const 32)
                     )
                    )
                    (drop
                     (call $___fwritex
                      (local.get $31)
                      (local.get $27)
                      (local.get $0)
                     )
                    )
                   )
                   (call $_pad
                    (local.get $0)
                    (i32.const 48)
                    (local.get $14)
                    (local.get $13)
                    (i32.xor
                     (local.get $11)
                     (i32.const 65536)
                    )
                   )
                   (block $do-once99
                    (if
                     (local.get $17)
                     (block
                      (local.set $6
                       (local.tee $12
                        (select
                         (local.get $8)
                         (local.get $12)
                         (i32.gt_u
                          (local.get $12)
                          (local.get $8)
                         )
                        )
                       )
                      )
                      (loop $while-in102
                       (local.set $7
                        (call $_fmt_u
                         (i32.load
                          (local.get $6)
                         )
                         (i32.const 0)
                         (local.get $30)
                        )
                       )
                       (block $do-once103
                        (if
                         (i32.eq
                          (local.get $6)
                          (local.get $12)
                         )
                         (block
                          (br_if $do-once103
                           (i32.ne
                            (local.get $7)
                            (local.get $30)
                           )
                          )
                          (i32.store8
                           (local.get $35)
                           (i32.const 48)
                          )
                          (local.set $7
                           (local.get $35)
                          )
                         )
                         (block
                          (br_if $do-once103
                           (i32.le_u
                            (local.get $7)
                            (local.get $22)
                           )
                          )
                          (loop $while-in106
                           (i32.store8
                            (local.tee $7
                             (i32.add
                              (local.get $7)
                              (i32.const -1)
                             )
                            )
                            (i32.const 48)
                           )
                           (br_if $while-in106
                            (i32.gt_u
                             (local.get $7)
                             (local.get $22)
                            )
                           )
                          )
                         )
                        )
                       )
                       (if
                        (i32.eqz
                         (i32.and
                          (i32.load
                           (local.get $0)
                          )
                          (i32.const 32)
                         )
                        )
                        (drop
                         (call $___fwritex
                          (local.get $7)
                          (i32.sub
                           (local.get $43)
                           (local.get $7)
                          )
                          (local.get $0)
                         )
                        )
                       )
                       (if
                        (i32.le_u
                         (local.tee $7
                          (i32.add
                           (local.get $6)
                           (i32.const 4)
                          )
                         )
                         (local.get $8)
                        )
                        (block
                         (local.set $6
                          (local.get $7)
                         )
                         (br $while-in102)
                        )
                       )
                      )
                      (block $do-once107
                       (if
                        (local.get $32)
                        (block
                         (br_if $do-once107
                          (i32.and
                           (i32.load
                            (local.get $0)
                           )
                           (i32.const 32)
                          )
                         )
                         (drop
                          (call $___fwritex
                           (i32.const 4143)
                           (i32.const 1)
                           (local.get $0)
                          )
                         )
                        )
                       )
                      )
                      (if
                       (i32.and
                        (i32.gt_s
                         (local.get $5)
                         (i32.const 0)
                        )
                        (i32.lt_u
                         (local.get $7)
                         (local.get $9)
                        )
                       )
                       (loop $while-in110
                        (if
                         (i32.gt_u
                          (local.tee $6
                           (call $_fmt_u
                            (i32.load
                             (local.get $7)
                            )
                            (i32.const 0)
                            (local.get $30)
                           )
                          )
                          (local.get $22)
                         )
                         (loop $while-in112
                          (i32.store8
                           (local.tee $6
                            (i32.add
                             (local.get $6)
                             (i32.const -1)
                            )
                           )
                           (i32.const 48)
                          )
                          (br_if $while-in112
                           (i32.gt_u
                            (local.get $6)
                            (local.get $22)
                           )
                          )
                         )
                        )
                        (if
                         (i32.eqz
                          (i32.and
                           (i32.load
                            (local.get $0)
                           )
                           (i32.const 32)
                          )
                         )
                         (drop
                          (call $___fwritex
                           (local.get $6)
                           (select
                            (i32.const 9)
                            (local.get $5)
                            (i32.gt_s
                             (local.get $5)
                             (i32.const 9)
                            )
                           )
                           (local.get $0)
                          )
                         )
                        )
                        (local.set $6
                         (i32.add
                          (local.get $5)
                          (i32.const -9)
                         )
                        )
                        (if
                         (i32.and
                          (i32.gt_s
                           (local.get $5)
                           (i32.const 9)
                          )
                          (i32.lt_u
                           (local.tee $7
                            (i32.add
                             (local.get $7)
                             (i32.const 4)
                            )
                           )
                           (local.get $9)
                          )
                         )
                         (block
                          (local.set $5
                           (local.get $6)
                          )
                          (br $while-in110)
                         )
                         (local.set $5
                          (local.get $6)
                         )
                        )
                       )
                      )
                      (call $_pad
                       (local.get $0)
                       (i32.const 48)
                       (i32.add
                        (local.get $5)
                        (i32.const 9)
                       )
                       (i32.const 9)
                       (i32.const 0)
                      )
                     )
                     (block
                      (local.set $9
                       (select
                        (local.get $9)
                        (i32.add
                         (local.get $12)
                         (i32.const 4)
                        )
                        (local.get $24)
                       )
                      )
                      (if
                       (i32.gt_s
                        (local.get $5)
                        (i32.const -1)
                       )
                       (block
                        (local.set $17
                         (i32.eqz
                          (local.get $21)
                         )
                        )
                        (local.set $6
                         (local.get $12)
                        )
                        (local.set $7
                         (local.get $5)
                        )
                        (loop $while-in114
                         (if
                          (i32.eq
                           (local.tee $5
                            (call $_fmt_u
                             (i32.load
                              (local.get $6)
                             )
                             (i32.const 0)
                             (local.get $30)
                            )
                           )
                           (local.get $30)
                          )
                          (block
                           (i32.store8
                            (local.get $35)
                            (i32.const 48)
                           )
                           (local.set $5
                            (local.get $35)
                           )
                          )
                         )
                         (block $do-once115
                          (if
                           (i32.eq
                            (local.get $6)
                            (local.get $12)
                           )
                           (block
                            (if
                             (i32.eqz
                              (i32.and
                               (i32.load
                                (local.get $0)
                               )
                               (i32.const 32)
                              )
                             )
                             (drop
                              (call $___fwritex
                               (local.get $5)
                               (i32.const 1)
                               (local.get $0)
                              )
                             )
                            )
                            (local.set $5
                             (i32.add
                              (local.get $5)
                              (i32.const 1)
                             )
                            )
                            (br_if $do-once115
                             (i32.and
                              (local.get $17)
                              (i32.lt_s
                               (local.get $7)
                               (i32.const 1)
                              )
                             )
                            )
                            (br_if $do-once115
                             (i32.and
                              (i32.load
                               (local.get $0)
                              )
                              (i32.const 32)
                             )
                            )
                            (drop
                             (call $___fwritex
                              (i32.const 4143)
                              (i32.const 1)
                              (local.get $0)
                             )
                            )
                           )
                           (block
                            (br_if $do-once115
                             (i32.le_u
                              (local.get $5)
                              (local.get $22)
                             )
                            )
                            (loop $while-in118
                             (i32.store8
                              (local.tee $5
                               (i32.add
                                (local.get $5)
                                (i32.const -1)
                               )
                              )
                              (i32.const 48)
                             )
                             (br_if $while-in118
                              (i32.gt_u
                               (local.get $5)
                               (local.get $22)
                              )
                             )
                            )
                           )
                          )
                         )
                         (local.set $8
                          (i32.sub
                           (local.get $43)
                           (local.get $5)
                          )
                         )
                         (if
                          (i32.eqz
                           (i32.and
                            (i32.load
                             (local.get $0)
                            )
                            (i32.const 32)
                           )
                          )
                          (drop
                           (call $___fwritex
                            (local.get $5)
                            (select
                             (local.get $8)
                             (local.get $7)
                             (i32.gt_s
                              (local.get $7)
                              (local.get $8)
                             )
                            )
                            (local.get $0)
                           )
                          )
                         )
                         (br_if $while-in114
                          (i32.and
                           (i32.lt_u
                            (local.tee $6
                             (i32.add
                              (local.get $6)
                              (i32.const 4)
                             )
                            )
                            (local.get $9)
                           )
                           (i32.gt_s
                            (local.tee $7
                             (i32.sub
                              (local.get $7)
                              (local.get $8)
                             )
                            )
                            (i32.const -1)
                           )
                          )
                         )
                         (local.set $5
                          (local.get $7)
                         )
                        )
                       )
                      )
                      (call $_pad
                       (local.get $0)
                       (i32.const 48)
                       (i32.add
                        (local.get $5)
                        (i32.const 18)
                       )
                       (i32.const 18)
                       (i32.const 0)
                      )
                      (br_if $do-once99
                       (i32.and
                        (i32.load
                         (local.get $0)
                        )
                        (i32.const 32)
                       )
                      )
                      (drop
                       (call $___fwritex
                        (local.get $18)
                        (i32.sub
                         (local.get $28)
                         (local.get $18)
                        )
                        (local.get $0)
                       )
                      )
                     )
                    )
                   )
                   (call $_pad
                    (local.get $0)
                    (i32.const 32)
                    (local.get $14)
                    (local.get $13)
                    (i32.xor
                     (local.get $11)
                     (i32.const 8192)
                    )
                   )
                   (select
                    (local.get $14)
                    (local.get $13)
                    (i32.lt_s
                     (local.get $13)
                     (local.get $14)
                    )
                   )
                  )
                  (block (result i32)
                   (call $_pad
                    (local.get $0)
                    (i32.const 32)
                    (local.get $14)
                    (local.tee $7
                     (i32.add
                      (local.tee $9
                       (select
                        (i32.const 0)
                        (local.get $27)
                        (local.tee $6
                         (i32.or
                          (f64.ne
                           (local.get $15)
                           (local.get $15)
                          )
                          (i32.const 0)
                         )
                        )
                       )
                      )
                      (i32.const 3)
                     )
                    )
                    (local.get $8)
                   )
                   (if
                    (i32.eqz
                     (i32.and
                      (local.tee $5
                       (i32.load
                        (local.get $0)
                       )
                      )
                      (i32.const 32)
                     )
                    )
                    (block
                     (drop
                      (call $___fwritex
                       (local.get $31)
                       (local.get $9)
                       (local.get $0)
                      )
                     )
                     (local.set $5
                      (i32.load
                       (local.get $0)
                      )
                     )
                    )
                   )
                   (local.set $6
                    (select
                     (select
                      (i32.const 4135)
                      (i32.const 4139)
                      (local.tee $8
                       (i32.ne
                        (i32.and
                         (local.get $18)
                         (i32.const 32)
                        )
                        (i32.const 0)
                       )
                      )
                     )
                     (select
                      (i32.const 4127)
                      (i32.const 4131)
                      (local.get $8)
                     )
                     (local.get $6)
                    )
                   )
                   (if
                    (i32.eqz
                     (i32.and
                      (local.get $5)
                      (i32.const 32)
                     )
                    )
                    (drop
                     (call $___fwritex
                      (local.get $6)
                      (i32.const 3)
                      (local.get $0)
                     )
                    )
                   )
                   (call $_pad
                    (local.get $0)
                    (i32.const 32)
                    (local.get $14)
                    (local.get $7)
                    (i32.xor
                     (local.get $11)
                     (i32.const 8192)
                    )
                   )
                   (select
                    (local.get $14)
                    (local.get $7)
                    (i32.lt_s
                     (local.get $7)
                     (local.get $14)
                    )
                   )
                  )
                 )
                )
               )
               (local.set $5
                (local.get $10)
               )
               (local.set $10
                (local.get $7)
               )
               (br $label$continue$L1)
              )
              (local.set $7
               (local.get $5)
              )
              (local.set $12
               (local.get $6)
              )
              (local.set $8
               (i32.const 0)
              )
              (local.set $9
               (i32.const 4091)
              )
              (br $__rjto$8
               (local.get $26)
              )
             )
             (local.set $9
              (i32.and
               (local.get $18)
               (i32.const 32)
              )
             )
             (if
              (i32.and
               (i32.eqz
                (local.tee $8
                 (i32.load
                  (local.tee $5
                   (local.get $19)
                  )
                 )
                )
               )
               (i32.eqz
                (local.tee $11
                 (i32.load offset=4
                  (local.get $5)
                 )
                )
               )
              )
              (block
               (local.set $5
                (local.get $26)
               )
               (local.set $8
                (i32.const 0)
               )
               (local.set $9
                (i32.const 4091)
               )
               (br $__rjti$8)
              )
              (block
               (local.set $5
                (local.get $8)
               )
               (local.set $8
                (local.get $26)
               )
               (loop $while-in123
                (i32.store8
                 (local.tee $8
                  (i32.add
                   (local.get $8)
                   (i32.const -1)
                  )
                 )
                 (i32.or
                  (i32.load8_u
                   (i32.add
                    (i32.and
                     (local.get $5)
                     (i32.const 15)
                    )
                    (i32.const 4075)
                   )
                  )
                  (local.get $9)
                 )
                )
                (br_if $while-in123
                 (i32.eqz
                  (i32.and
                   (i32.eqz
                    (local.tee $5
                     (call $_bitshift64Lshr
                      (local.get $5)
                      (local.get $11)
                      (i32.const 4)
                     )
                    )
                   )
                   (i32.eqz
                    (local.tee $11
                     (global.get $tempRet0)
                    )
                   )
                  )
                 )
                )
                (local.set $5
                 (local.get $8)
                )
               )
               (local.set $8
                (if (result i32)
                 (i32.or
                  (i32.eqz
                   (i32.and
                    (local.get $7)
                    (i32.const 8)
                   )
                  )
                  (i32.and
                   (i32.eqz
                    (i32.load
                     (local.tee $11
                      (local.get $19)
                     )
                    )
                   )
                   (i32.eqz
                    (i32.load offset=4
                     (local.get $11)
                    )
                   )
                  )
                 )
                 (block (result i32)
                  (local.set $9
                   (i32.const 4091)
                  )
                  (i32.const 0)
                 )
                 (block (result i32)
                  (local.set $9
                   (i32.add
                    (i32.shr_s
                     (local.get $18)
                     (i32.const 4)
                    )
                    (i32.const 4091)
                   )
                  )
                  (i32.const 2)
                 )
                )
               )
               (br $__rjti$8)
              )
             )
            )
            (local.set $5
             (call $_fmt_u
              (local.get $5)
              (local.get $7)
              (local.get $26)
             )
            )
            (local.set $7
             (local.get $11)
            )
            (br $__rjti$8)
           )
           (local.set $18
            (i32.eqz
             (local.tee $13
              (call $_memchr
               (local.get $5)
               (i32.const 0)
               (local.get $6)
              )
             )
            )
           )
           (local.set $7
            (local.get $5)
           )
           (local.set $11
            (local.get $8)
           )
           (local.set $12
            (select
             (local.get $6)
             (i32.sub
              (local.get $13)
              (local.get $5)
             )
             (local.get $18)
            )
           )
           (local.set $8
            (i32.const 0)
           )
           (local.set $9
            (i32.const 4091)
           )
           (br $__rjto$8
            (select
             (i32.add
              (local.get $5)
              (local.get $6)
             )
             (local.get $13)
             (local.get $18)
            )
           )
          )
          (local.set $5
           (i32.const 0)
          )
          (local.set $7
           (i32.const 0)
          )
          (local.set $6
           (i32.load
            (local.get $19)
           )
          )
          (loop $while-in125
           (block $while-out124
            (br_if $while-out124
             (i32.eqz
              (local.tee $9
               (i32.load
                (local.get $6)
               )
              )
             )
            )
            (br_if $while-out124
             (i32.or
              (i32.lt_s
               (local.tee $7
                (call $_wctomb
                 (local.get $36)
                 (local.get $9)
                )
               )
               (i32.const 0)
              )
              (i32.gt_u
               (local.get $7)
               (i32.sub
                (local.get $8)
                (local.get $5)
               )
              )
             )
            )
            (local.set $6
             (i32.add
              (local.get $6)
              (i32.const 4)
             )
            )
            (br_if $while-in125
             (i32.gt_u
              (local.get $8)
              (local.tee $5
               (i32.add
                (local.get $7)
                (local.get $5)
               )
              )
             )
            )
           )
          )
          (if
           (i32.lt_s
            (local.get $7)
            (i32.const 0)
           )
           (block
            (local.set $16
             (i32.const -1)
            )
            (br $label$break$L1)
           )
          )
          (call $_pad
           (local.get $0)
           (i32.const 32)
           (local.get $14)
           (local.get $5)
           (local.get $11)
          )
          (if
           (local.get $5)
           (block
            (local.set $6
             (i32.const 0)
            )
            (local.set $7
             (i32.load
              (local.get $19)
             )
            )
            (loop $while-in127
             (if
              (i32.eqz
               (local.tee $8
                (i32.load
                 (local.get $7)
                )
               )
              )
              (block
               (local.set $7
                (local.get $5)
               )
               (br $__rjti$7)
              )
             )
             (if
              (i32.gt_s
               (local.tee $6
                (i32.add
                 (local.tee $8
                  (call $_wctomb
                   (local.get $36)
                   (local.get $8)
                  )
                 )
                 (local.get $6)
                )
               )
               (local.get $5)
              )
              (block
               (local.set $7
                (local.get $5)
               )
               (br $__rjti$7)
              )
             )
             (if
              (i32.eqz
               (i32.and
                (i32.load
                 (local.get $0)
                )
                (i32.const 32)
               )
              )
              (drop
               (call $___fwritex
                (local.get $36)
                (local.get $8)
                (local.get $0)
               )
              )
             )
             (local.set $7
              (i32.add
               (local.get $7)
               (i32.const 4)
              )
             )
             (br_if $while-in127
              (i32.lt_u
               (local.get $6)
               (local.get $5)
              )
             )
             (local.set $7
              (local.get $5)
             )
            )
           )
           (local.set $7
            (i32.const 0)
           )
          )
         )
         (call $_pad
          (local.get $0)
          (i32.const 32)
          (local.get $14)
          (local.get $7)
          (i32.xor
           (local.get $11)
           (i32.const 8192)
          )
         )
         (local.set $5
          (local.get $10)
         )
         (local.set $10
          (select
           (local.get $14)
           (local.get $7)
           (i32.gt_s
            (local.get $14)
            (local.get $7)
           )
          )
         )
         (br $label$continue$L1)
        )
        (local.set $11
         (select
          (i32.and
           (local.get $7)
           (i32.const -65537)
          )
          (local.get $7)
          (i32.gt_s
           (local.get $6)
           (i32.const -1)
          )
         )
        )
        (local.set $12
         (if (result i32)
          (i32.or
           (local.get $6)
           (local.tee $12
            (i32.or
             (i32.ne
              (i32.load
               (local.tee $7
                (local.get $19)
               )
              )
              (i32.const 0)
             )
             (i32.ne
              (i32.load offset=4
               (local.get $7)
              )
              (i32.const 0)
             )
            )
           )
          )
          (block (result i32)
           (local.set $7
            (local.get $5)
           )
           (select
            (local.get $6)
            (local.tee $5
             (i32.add
              (i32.xor
               (i32.and
                (local.get $12)
                (i32.const 1)
               )
               (i32.const 1)
              )
              (i32.sub
               (local.get $39)
               (local.get $5)
              )
             )
            )
            (i32.gt_s
             (local.get $6)
             (local.get $5)
            )
           )
          )
          (block (result i32)
           (local.set $7
            (local.get $26)
           )
           (i32.const 0)
          )
         )
        )
        (local.get $26)
       )
      )
      (call $_pad
       (local.get $0)
       (i32.const 32)
       (local.tee $6
        (select
         (local.tee $5
          (i32.add
           (local.get $8)
           (local.tee $12
            (select
             (local.tee $13
              (i32.sub
               (local.get $5)
               (local.get $7)
              )
             )
             (local.get $12)
             (i32.lt_s
              (local.get $12)
              (local.get $13)
             )
            )
           )
          )
         )
         (local.get $14)
         (i32.lt_s
          (local.get $14)
          (local.get $5)
         )
        )
       )
       (local.get $5)
       (local.get $11)
      )
      (if
       (i32.eqz
        (i32.and
         (i32.load
          (local.get $0)
         )
         (i32.const 32)
        )
       )
       (drop
        (call $___fwritex
         (local.get $9)
         (local.get $8)
         (local.get $0)
        )
       )
      )
      (call $_pad
       (local.get $0)
       (i32.const 48)
       (local.get $6)
       (local.get $5)
       (i32.xor
        (local.get $11)
        (i32.const 65536)
       )
      )
      (call $_pad
       (local.get $0)
       (i32.const 48)
       (local.get $12)
       (local.get $13)
       (i32.const 0)
      )
      (if
       (i32.eqz
        (i32.and
         (i32.load
          (local.get $0)
         )
         (i32.const 32)
        )
       )
       (drop
        (call $___fwritex
         (local.get $7)
         (local.get $13)
         (local.get $0)
        )
       )
      )
      (call $_pad
       (local.get $0)
       (i32.const 32)
       (local.get $6)
       (local.get $5)
       (i32.xor
        (local.get $11)
        (i32.const 8192)
       )
      )
      (local.set $5
       (local.get $10)
      )
      (local.set $10
       (local.get $6)
      )
      (br $label$continue$L1)
     )
    )
    (br $label$break$L343)
   )
   (if
    (i32.eqz
     (local.get $0)
    )
    (if
     (local.get $1)
     (block
      (local.set $0
       (i32.const 1)
      )
      (loop $while-in130
       (if
        (local.tee $1
         (i32.load
          (i32.add
           (local.get $4)
           (i32.shl
            (local.get $0)
            (i32.const 2)
           )
          )
         )
        )
        (block
         (call $_pop_arg_336
          (i32.add
           (local.get $3)
           (i32.shl
            (local.get $0)
            (i32.const 3)
           )
          )
          (local.get $1)
          (local.get $2)
         )
         (br_if $while-in130
          (i32.lt_s
           (local.tee $0
            (i32.add
             (local.get $0)
             (i32.const 1)
            )
           )
           (i32.const 10)
          )
         )
         (local.set $16
          (i32.const 1)
         )
         (br $label$break$L343)
        )
       )
      )
      (if
       (i32.lt_s
        (local.get $0)
        (i32.const 10)
       )
       (loop $while-in132
        (if
         (i32.load
          (i32.add
           (local.get $4)
           (i32.shl
            (local.get $0)
            (i32.const 2)
           )
          )
         )
         (block
          (local.set $16
           (i32.const -1)
          )
          (br $label$break$L343)
         )
        )
        (br_if $while-in132
         (i32.lt_s
          (local.tee $0
           (i32.add
            (local.get $0)
            (i32.const 1)
           )
          )
          (i32.const 10)
         )
        )
        (local.set $16
         (i32.const 1)
        )
       )
       (local.set $16
        (i32.const 1)
       )
      )
     )
     (local.set $16
      (i32.const 0)
     )
    )
   )
  )
  (global.set $STACKTOP
   (local.get $25)
  )
  (local.get $16)
 )
 (func $_pop_arg_336 (param $0 i32) (param $1 i32) (param $2 i32)
  (local $3 i32)
  (local $4 f64)
  (local $5 i32)
  (block $label$break$L1
   (if
    (i32.le_u
     (local.get $1)
     (i32.const 20)
    )
    (block $switch-default
     (block $switch-case9
      (block $switch-case8
       (block $switch-case7
        (block $switch-case6
         (block $switch-case5
          (block $switch-case4
           (block $switch-case3
            (block $switch-case2
             (block $switch-case1
              (block $switch-case
               (br_table $switch-case $switch-case1 $switch-case2 $switch-case3 $switch-case4 $switch-case5 $switch-case6 $switch-case7 $switch-case8 $switch-case9 $switch-default
                (i32.sub
                 (local.get $1)
                 (i32.const 9)
                )
               )
              )
              (local.set $3
               (i32.load
                (local.tee $1
                 (i32.and
                  (i32.add
                   (i32.load
                    (local.get $2)
                   )
                   (i32.const 3)
                  )
                  (i32.const -4)
                 )
                )
               )
              )
              (i32.store
               (local.get $2)
               (i32.add
                (local.get $1)
                (i32.const 4)
               )
              )
              (i32.store
               (local.get $0)
               (local.get $3)
              )
              (br $label$break$L1)
             )
             (local.set $1
              (i32.load
               (local.tee $3
                (i32.and
                 (i32.add
                  (i32.load
                   (local.get $2)
                  )
                  (i32.const 3)
                 )
                 (i32.const -4)
                )
               )
              )
             )
             (i32.store
              (local.get $2)
              (i32.add
               (local.get $3)
               (i32.const 4)
              )
             )
             (i32.store
              (local.get $0)
              (local.get $1)
             )
             (i32.store offset=4
              (local.get $0)
              (i32.shr_s
               (i32.shl
                (i32.lt_s
                 (local.get $1)
                 (i32.const 0)
                )
                (i32.const 31)
               )
               (i32.const 31)
              )
             )
             (br $label$break$L1)
            )
            (local.set $3
             (i32.load
              (local.tee $1
               (i32.and
                (i32.add
                 (i32.load
                  (local.get $2)
                 )
                 (i32.const 3)
                )
                (i32.const -4)
               )
              )
             )
            )
            (i32.store
             (local.get $2)
             (i32.add
              (local.get $1)
              (i32.const 4)
             )
            )
            (i32.store
             (local.get $0)
             (local.get $3)
            )
            (i32.store offset=4
             (local.get $0)
             (i32.const 0)
            )
            (br $label$break$L1)
           )
           (local.set $5
            (i32.load
             (local.tee $3
              (local.tee $1
               (i32.and
                (i32.add
                 (i32.load
                  (local.get $2)
                 )
                 (i32.const 7)
                )
                (i32.const -8)
               )
              )
             )
            )
           )
           (local.set $3
            (i32.load offset=4
             (local.get $3)
            )
           )
           (i32.store
            (local.get $2)
            (i32.add
             (local.get $1)
             (i32.const 8)
            )
           )
           (i32.store
            (local.get $0)
            (local.get $5)
           )
           (i32.store offset=4
            (local.get $0)
            (local.get $3)
           )
           (br $label$break$L1)
          )
          (local.set $3
           (i32.load
            (local.tee $1
             (i32.and
              (i32.add
               (i32.load
                (local.get $2)
               )
               (i32.const 3)
              )
              (i32.const -4)
             )
            )
           )
          )
          (i32.store
           (local.get $2)
           (i32.add
            (local.get $1)
            (i32.const 4)
           )
          )
          (i32.store
           (local.get $0)
           (local.tee $1
            (i32.shr_s
             (i32.shl
              (i32.and
               (local.get $3)
               (i32.const 65535)
              )
              (i32.const 16)
             )
             (i32.const 16)
            )
           )
          )
          (i32.store offset=4
           (local.get $0)
           (i32.shr_s
            (i32.shl
             (i32.lt_s
              (local.get $1)
              (i32.const 0)
             )
             (i32.const 31)
            )
            (i32.const 31)
           )
          )
          (br $label$break$L1)
         )
         (local.set $3
          (i32.load
           (local.tee $1
            (i32.and
             (i32.add
              (i32.load
               (local.get $2)
              )
              (i32.const 3)
             )
             (i32.const -4)
            )
           )
          )
         )
         (i32.store
          (local.get $2)
          (i32.add
           (local.get $1)
           (i32.const 4)
          )
         )
         (i32.store
          (local.get $0)
          (i32.and
           (local.get $3)
           (i32.const 65535)
          )
         )
         (i32.store offset=4
          (local.get $0)
          (i32.const 0)
         )
         (br $label$break$L1)
        )
        (local.set $3
         (i32.load
          (local.tee $1
           (i32.and
            (i32.add
             (i32.load
              (local.get $2)
             )
             (i32.const 3)
            )
            (i32.const -4)
           )
          )
         )
        )
        (i32.store
         (local.get $2)
         (i32.add
          (local.get $1)
          (i32.const 4)
         )
        )
        (i32.store
         (local.get $0)
         (local.tee $1
          (i32.shr_s
           (i32.shl
            (i32.and
             (local.get $3)
             (i32.const 255)
            )
            (i32.const 24)
           )
           (i32.const 24)
          )
         )
        )
        (i32.store offset=4
         (local.get $0)
         (i32.shr_s
          (i32.shl
           (i32.lt_s
            (local.get $1)
            (i32.const 0)
           )
           (i32.const 31)
          )
          (i32.const 31)
         )
        )
        (br $label$break$L1)
       )
       (local.set $3
        (i32.load
         (local.tee $1
          (i32.and
           (i32.add
            (i32.load
             (local.get $2)
            )
            (i32.const 3)
           )
           (i32.const -4)
          )
         )
        )
       )
       (i32.store
        (local.get $2)
        (i32.add
         (local.get $1)
         (i32.const 4)
        )
       )
       (i32.store
        (local.get $0)
        (i32.and
         (local.get $3)
         (i32.const 255)
        )
       )
       (i32.store offset=4
        (local.get $0)
        (i32.const 0)
       )
       (br $label$break$L1)
      )
      (local.set $4
       (f64.load
        (local.tee $1
         (i32.and
          (i32.add
           (i32.load
            (local.get $2)
           )
           (i32.const 7)
          )
          (i32.const -8)
         )
        )
       )
      )
      (i32.store
       (local.get $2)
       (i32.add
        (local.get $1)
        (i32.const 8)
       )
      )
      (f64.store
       (local.get $0)
       (local.get $4)
      )
      (br $label$break$L1)
     )
     (local.set $4
      (f64.load
       (local.tee $1
        (i32.and
         (i32.add
          (i32.load
           (local.get $2)
          )
          (i32.const 7)
         )
         (i32.const -8)
        )
       )
      )
     )
     (i32.store
      (local.get $2)
      (i32.add
       (local.get $1)
       (i32.const 8)
      )
     )
     (f64.store
      (local.get $0)
      (local.get $4)
     )
    )
   )
  )
 )
 (func $_fmt_u (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (local $3 i32)
  (local $4 i32)
  (if
   (i32.or
    (i32.gt_u
     (local.get $1)
     (i32.const 0)
    )
    (i32.and
     (i32.eqz
      (local.get $1)
     )
     (i32.gt_u
      (local.get $0)
      (i32.const -1)
     )
    )
   )
   (loop $while-in
    (i32.store8
     (local.tee $2
      (i32.add
       (local.get $2)
       (i32.const -1)
      )
     )
     (i32.or
      (local.tee $3
       (call $___uremdi3
        (local.get $0)
        (local.get $1)
        (i32.const 10)
        (i32.const 0)
       )
      )
      (i32.const 48)
     )
    )
    (local.set $3
     (call $___udivdi3
      (local.get $0)
      (local.get $1)
      (i32.const 10)
      (i32.const 0)
     )
    )
    (local.set $4
     (global.get $tempRet0)
    )
    (if
     (i32.or
      (i32.gt_u
       (local.get $1)
       (i32.const 9)
      )
      (i32.and
       (i32.eq
        (local.get $1)
        (i32.const 9)
       )
       (i32.gt_u
        (local.get $0)
        (i32.const -1)
       )
      )
     )
     (block
      (local.set $0
       (local.get $3)
      )
      (local.set $1
       (local.get $4)
      )
      (br $while-in)
     )
     (local.set $0
      (local.get $3)
     )
    )
   )
  )
  (if
   (local.get $0)
   (loop $while-in1
    (i32.store8
     (local.tee $2
      (i32.add
       (local.get $2)
       (i32.const -1)
      )
     )
     (i32.or
      (call $i32u-rem
       (local.get $0)
       (i32.const 10)
      )
      (i32.const 48)
     )
    )
    (local.set $1
     (call $i32u-div
      (local.get $0)
      (i32.const 10)
     )
    )
    (if
     (i32.ge_u
      (local.get $0)
      (i32.const 10)
     )
     (block
      (local.set $0
       (local.get $1)
      )
      (br $while-in1)
     )
    )
   )
  )
  (local.get $2)
 )
 (func $_pad (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (param $4 i32)
  (local $5 i32)
  (local $6 i32)
  (local $7 i32)
  (local.set $7
   (global.get $STACKTOP)
  )
  (global.set $STACKTOP
   (i32.add
    (global.get $STACKTOP)
    (i32.const 256)
   )
  )
  (if
   (i32.ge_s
    (global.get $STACKTOP)
    (global.get $STACK_MAX)
   )
   (call $abort)
  )
  (local.set $6
   (local.get $7)
  )
  (block $do-once
   (if
    (i32.and
     (i32.gt_s
      (local.get $2)
      (local.get $3)
     )
     (i32.eqz
      (i32.and
       (local.get $4)
       (i32.const 73728)
      )
     )
    )
    (block
     (drop
      (call $_memset
       (local.get $6)
       (local.get $1)
       (select
        (i32.const 256)
        (local.tee $5
         (i32.sub
          (local.get $2)
          (local.get $3)
         )
        )
        (i32.gt_u
         (local.get $5)
         (i32.const 256)
        )
       )
      )
     )
     (local.set $4
      (i32.eqz
       (i32.and
        (local.tee $1
         (i32.load
          (local.get $0)
         )
        )
        (i32.const 32)
       )
      )
     )
     (if
      (i32.gt_u
       (local.get $5)
       (i32.const 255)
      )
      (block
       (loop $while-in
        (if
         (local.get $4)
         (block
          (drop
           (call $___fwritex
            (local.get $6)
            (i32.const 256)
            (local.get $0)
           )
          )
          (local.set $1
           (i32.load
            (local.get $0)
           )
          )
         )
        )
        (local.set $4
         (i32.eqz
          (i32.and
           (local.get $1)
           (i32.const 32)
          )
         )
        )
        (br_if $while-in
         (i32.gt_u
          (local.tee $5
           (i32.add
            (local.get $5)
            (i32.const -256)
           )
          )
          (i32.const 255)
         )
        )
       )
       (br_if $do-once
        (i32.eqz
         (local.get $4)
        )
       )
       (local.set $5
        (i32.and
         (i32.sub
          (local.get $2)
          (local.get $3)
         )
         (i32.const 255)
        )
       )
      )
      (br_if $do-once
       (i32.eqz
        (local.get $4)
       )
      )
     )
     (drop
      (call $___fwritex
       (local.get $6)
       (local.get $5)
       (local.get $0)
      )
     )
    )
   )
  )
  (global.set $STACKTOP
   (local.get $7)
  )
 )
 (func $_malloc (param $0 i32) (result i32)
  (local $1 i32)
  (local $2 i32)
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
  (local $15 i32)
  (local $16 i32)
  (local $17 i32)
  (local $18 i32)
  (block $folding-inner0
   (block $do-once
    (if
     (i32.lt_u
      (local.get $0)
      (i32.const 245)
     )
     (block
      (if
       (i32.and
        (local.tee $5
         (i32.shr_u
          (local.tee $11
           (i32.load
            (i32.const 176)
           )
          )
          (local.tee $13
           (i32.shr_u
            (local.tee $4
             (select
              (i32.const 16)
              (i32.and
               (i32.add
                (local.get $0)
                (i32.const 11)
               )
               (i32.const -8)
              )
              (i32.lt_u
               (local.get $0)
               (i32.const 11)
              )
             )
            )
            (i32.const 3)
           )
          )
         )
        )
        (i32.const 3)
       )
       (block
        (local.set $10
         (i32.load
          (local.tee $1
           (i32.add
            (local.tee $7
             (i32.load
              (local.tee $3
               (i32.add
                (local.tee $2
                 (i32.add
                  (i32.shl
                   (local.tee $4
                    (i32.add
                     (i32.xor
                      (i32.and
                       (local.get $5)
                       (i32.const 1)
                      )
                      (i32.const 1)
                     )
                     (local.get $13)
                    )
                   )
                   (i32.const 3)
                  )
                  (i32.const 216)
                 )
                )
                (i32.const 8)
               )
              )
             )
            )
            (i32.const 8)
           )
          )
         )
        )
        (if
         (i32.eq
          (local.get $2)
          (local.get $10)
         )
         (i32.store
          (i32.const 176)
          (i32.and
           (local.get $11)
           (i32.xor
            (i32.shl
             (i32.const 1)
             (local.get $4)
            )
            (i32.const -1)
           )
          )
         )
         (block
          (if
           (i32.lt_u
            (local.get $10)
            (i32.load
             (i32.const 192)
            )
           )
           (call $_abort)
          )
          (if
           (i32.eq
            (i32.load
             (local.tee $0
              (i32.add
               (local.get $10)
               (i32.const 12)
              )
             )
            )
            (local.get $7)
           )
           (block
            (i32.store
             (local.get $0)
             (local.get $2)
            )
            (i32.store
             (local.get $3)
             (local.get $10)
            )
           )
           (call $_abort)
          )
         )
        )
        (i32.store offset=4
         (local.get $7)
         (i32.or
          (local.tee $0
           (i32.shl
            (local.get $4)
            (i32.const 3)
           )
          )
          (i32.const 3)
         )
        )
        (i32.store
         (local.tee $0
          (i32.add
           (i32.add
            (local.get $7)
            (local.get $0)
           )
           (i32.const 4)
          )
         )
         (i32.or
          (i32.load
           (local.get $0)
          )
          (i32.const 1)
         )
        )
        (return
         (local.get $1)
        )
       )
      )
      (if
       (i32.gt_u
        (local.get $4)
        (local.tee $0
         (i32.load
          (i32.const 184)
         )
        )
       )
       (block
        (if
         (local.get $5)
         (block
          (local.set $10
           (i32.and
            (i32.shr_u
             (local.tee $3
              (i32.add
               (i32.and
                (local.tee $3
                 (i32.and
                  (i32.shl
                   (local.get $5)
                   (local.get $13)
                  )
                  (i32.or
                   (local.tee $3
                    (i32.shl
                     (i32.const 2)
                     (local.get $13)
                    )
                   )
                   (i32.sub
                    (i32.const 0)
                    (local.get $3)
                   )
                  )
                 )
                )
                (i32.sub
                 (i32.const 0)
                 (local.get $3)
                )
               )
               (i32.const -1)
              )
             )
             (i32.const 12)
            )
            (i32.const 16)
           )
          )
          (local.set $9
           (i32.load
            (local.tee $7
             (i32.add
              (local.tee $12
               (i32.load
                (local.tee $3
                 (i32.add
                  (local.tee $10
                   (i32.add
                    (i32.shl
                     (local.tee $5
                      (i32.add
                       (i32.or
                        (i32.or
                         (i32.or
                          (i32.or
                           (local.tee $3
                            (i32.and
                             (i32.shr_u
                              (local.tee $7
                               (i32.shr_u
                                (local.get $3)
                                (local.get $10)
                               )
                              )
                              (i32.const 5)
                             )
                             (i32.const 8)
                            )
                           )
                           (local.get $10)
                          )
                          (local.tee $3
                           (i32.and
                            (i32.shr_u
                             (local.tee $7
                              (i32.shr_u
                               (local.get $7)
                               (local.get $3)
                              )
                             )
                             (i32.const 2)
                            )
                            (i32.const 4)
                           )
                          )
                         )
                         (local.tee $3
                          (i32.and
                           (i32.shr_u
                            (local.tee $7
                             (i32.shr_u
                              (local.get $7)
                              (local.get $3)
                             )
                            )
                            (i32.const 1)
                           )
                           (i32.const 2)
                          )
                         )
                        )
                        (local.tee $3
                         (i32.and
                          (i32.shr_u
                           (local.tee $7
                            (i32.shr_u
                             (local.get $7)
                             (local.get $3)
                            )
                           )
                           (i32.const 1)
                          )
                          (i32.const 1)
                         )
                        )
                       )
                       (i32.shr_u
                        (local.get $7)
                        (local.get $3)
                       )
                      )
                     )
                     (i32.const 3)
                    )
                    (i32.const 216)
                   )
                  )
                  (i32.const 8)
                 )
                )
               )
              )
              (i32.const 8)
             )
            )
           )
          )
          (if
           (i32.eq
            (local.get $10)
            (local.get $9)
           )
           (block
            (i32.store
             (i32.const 176)
             (i32.and
              (local.get $11)
              (i32.xor
               (i32.shl
                (i32.const 1)
                (local.get $5)
               )
               (i32.const -1)
              )
             )
            )
            (local.set $8
             (local.get $0)
            )
           )
           (block
            (if
             (i32.lt_u
              (local.get $9)
              (i32.load
               (i32.const 192)
              )
             )
             (call $_abort)
            )
            (if
             (i32.eq
              (i32.load
               (local.tee $0
                (i32.add
                 (local.get $9)
                 (i32.const 12)
                )
               )
              )
              (local.get $12)
             )
             (block
              (i32.store
               (local.get $0)
               (local.get $10)
              )
              (i32.store
               (local.get $3)
               (local.get $9)
              )
              (local.set $8
               (i32.load
                (i32.const 184)
               )
              )
             )
             (call $_abort)
            )
           )
          )
          (i32.store offset=4
           (local.get $12)
           (i32.or
            (local.get $4)
            (i32.const 3)
           )
          )
          (i32.store offset=4
           (local.tee $10
            (i32.add
             (local.get $12)
             (local.get $4)
            )
           )
           (i32.or
            (local.tee $5
             (i32.sub
              (i32.shl
               (local.get $5)
               (i32.const 3)
              )
              (local.get $4)
             )
            )
            (i32.const 1)
           )
          )
          (i32.store
           (i32.add
            (local.get $10)
            (local.get $5)
           )
           (local.get $5)
          )
          (if
           (local.get $8)
           (block
            (local.set $12
             (i32.load
              (i32.const 196)
             )
            )
            (local.set $4
             (i32.add
              (i32.shl
               (local.tee $0
                (i32.shr_u
                 (local.get $8)
                 (i32.const 3)
                )
               )
               (i32.const 3)
              )
              (i32.const 216)
             )
            )
            (if
             (i32.and
              (local.tee $3
               (i32.load
                (i32.const 176)
               )
              )
              (local.tee $0
               (i32.shl
                (i32.const 1)
                (local.get $0)
               )
              )
             )
             (if
              (i32.lt_u
               (local.tee $0
                (i32.load
                 (local.tee $3
                  (i32.add
                   (local.get $4)
                   (i32.const 8)
                  )
                 )
                )
               )
               (i32.load
                (i32.const 192)
               )
              )
              (call $_abort)
              (block
               (local.set $2
                (local.get $3)
               )
               (local.set $1
                (local.get $0)
               )
              )
             )
             (block
              (i32.store
               (i32.const 176)
               (i32.or
                (local.get $3)
                (local.get $0)
               )
              )
              (local.set $2
               (i32.add
                (local.get $4)
                (i32.const 8)
               )
              )
              (local.set $1
               (local.get $4)
              )
             )
            )
            (i32.store
             (local.get $2)
             (local.get $12)
            )
            (i32.store offset=12
             (local.get $1)
             (local.get $12)
            )
            (i32.store offset=8
             (local.get $12)
             (local.get $1)
            )
            (i32.store offset=12
             (local.get $12)
             (local.get $4)
            )
           )
          )
          (i32.store
           (i32.const 184)
           (local.get $5)
          )
          (i32.store
           (i32.const 196)
           (local.get $10)
          )
          (return
           (local.get $7)
          )
         )
        )
        (if
         (local.tee $0
          (i32.load
           (i32.const 180)
          )
         )
         (block
          (local.set $2
           (i32.and
            (i32.shr_u
             (local.tee $0
              (i32.add
               (i32.and
                (local.get $0)
                (i32.sub
                 (i32.const 0)
                 (local.get $0)
                )
               )
               (i32.const -1)
              )
             )
             (i32.const 12)
            )
            (i32.const 16)
           )
          )
          (local.set $7
           (i32.sub
            (i32.and
             (i32.load offset=4
              (local.tee $0
               (i32.load offset=480
                (i32.shl
                 (i32.add
                  (i32.or
                   (i32.or
                    (i32.or
                     (i32.or
                      (local.tee $0
                       (i32.and
                        (i32.shr_u
                         (local.tee $1
                          (i32.shr_u
                           (local.get $0)
                           (local.get $2)
                          )
                         )
                         (i32.const 5)
                        )
                        (i32.const 8)
                       )
                      )
                      (local.get $2)
                     )
                     (local.tee $0
                      (i32.and
                       (i32.shr_u
                        (local.tee $1
                         (i32.shr_u
                          (local.get $1)
                          (local.get $0)
                         )
                        )
                        (i32.const 2)
                       )
                       (i32.const 4)
                      )
                     )
                    )
                    (local.tee $0
                     (i32.and
                      (i32.shr_u
                       (local.tee $1
                        (i32.shr_u
                         (local.get $1)
                         (local.get $0)
                        )
                       )
                       (i32.const 1)
                      )
                      (i32.const 2)
                     )
                    )
                   )
                   (local.tee $0
                    (i32.and
                     (i32.shr_u
                      (local.tee $1
                       (i32.shr_u
                        (local.get $1)
                        (local.get $0)
                       )
                      )
                      (i32.const 1)
                     )
                     (i32.const 1)
                    )
                   )
                  )
                  (i32.shr_u
                   (local.get $1)
                   (local.get $0)
                  )
                 )
                 (i32.const 2)
                )
               )
              )
             )
             (i32.const -8)
            )
            (local.get $4)
           )
          )
          (local.set $1
           (local.get $0)
          )
          (local.set $2
           (local.get $0)
          )
          (loop $while-in
           (block $while-out
            (if
             (i32.eqz
              (local.tee $0
               (i32.load offset=16
                (local.get $1)
               )
              )
             )
             (if
              (i32.eqz
               (local.tee $0
                (i32.load offset=20
                 (local.get $1)
                )
               )
              )
              (block
               (local.set $10
                (local.get $7)
               )
               (local.set $5
                (local.get $2)
               )
               (br $while-out)
              )
             )
            )
            (local.set $10
             (i32.lt_u
              (local.tee $1
               (i32.sub
                (i32.and
                 (i32.load offset=4
                  (local.get $0)
                 )
                 (i32.const -8)
                )
                (local.get $4)
               )
              )
              (local.get $7)
             )
            )
            (local.set $7
             (select
              (local.get $1)
              (local.get $7)
              (local.get $10)
             )
            )
            (local.set $1
             (local.get $0)
            )
            (local.set $2
             (select
              (local.get $0)
              (local.get $2)
              (local.get $10)
             )
            )
            (br $while-in)
           )
          )
          (if
           (i32.lt_u
            (local.get $5)
            (local.tee $12
             (i32.load
              (i32.const 192)
             )
            )
           )
           (call $_abort)
          )
          (if
           (i32.ge_u
            (local.get $5)
            (local.tee $11
             (i32.add
              (local.get $5)
              (local.get $4)
             )
            )
           )
           (call $_abort)
          )
          (local.set $8
           (i32.load offset=24
            (local.get $5)
           )
          )
          (block $do-once4
           (if
            (i32.eq
             (local.tee $0
              (i32.load offset=12
               (local.get $5)
              )
             )
             (local.get $5)
            )
            (block
             (if
              (i32.eqz
               (local.tee $1
                (i32.load
                 (local.tee $0
                  (i32.add
                   (local.get $5)
                   (i32.const 20)
                  )
                 )
                )
               )
              )
              (if
               (i32.eqz
                (local.tee $1
                 (i32.load
                  (local.tee $0
                   (i32.add
                    (local.get $5)
                    (i32.const 16)
                   )
                  )
                 )
                )
               )
               (block
                (local.set $9
                 (i32.const 0)
                )
                (br $do-once4)
               )
              )
             )
             (loop $while-in7
              (if
               (local.tee $2
                (i32.load
                 (local.tee $7
                  (i32.add
                   (local.get $1)
                   (i32.const 20)
                  )
                 )
                )
               )
               (block
                (local.set $1
                 (local.get $2)
                )
                (local.set $0
                 (local.get $7)
                )
                (br $while-in7)
               )
              )
              (if
               (local.tee $2
                (i32.load
                 (local.tee $7
                  (i32.add
                   (local.get $1)
                   (i32.const 16)
                  )
                 )
                )
               )
               (block
                (local.set $1
                 (local.get $2)
                )
                (local.set $0
                 (local.get $7)
                )
                (br $while-in7)
               )
              )
             )
             (if
              (i32.lt_u
               (local.get $0)
               (local.get $12)
              )
              (call $_abort)
              (block
               (i32.store
                (local.get $0)
                (i32.const 0)
               )
               (local.set $9
                (local.get $1)
               )
              )
             )
            )
            (block
             (if
              (i32.lt_u
               (local.tee $7
                (i32.load offset=8
                 (local.get $5)
                )
               )
               (local.get $12)
              )
              (call $_abort)
             )
             (if
              (i32.ne
               (i32.load
                (local.tee $2
                 (i32.add
                  (local.get $7)
                  (i32.const 12)
                 )
                )
               )
               (local.get $5)
              )
              (call $_abort)
             )
             (if
              (i32.eq
               (i32.load
                (local.tee $1
                 (i32.add
                  (local.get $0)
                  (i32.const 8)
                 )
                )
               )
               (local.get $5)
              )
              (block
               (i32.store
                (local.get $2)
                (local.get $0)
               )
               (i32.store
                (local.get $1)
                (local.get $7)
               )
               (local.set $9
                (local.get $0)
               )
              )
              (call $_abort)
             )
            )
           )
          )
          (block $do-once8
           (if
            (local.get $8)
            (block
             (if
              (i32.eq
               (local.get $5)
               (i32.load
                (local.tee $0
                 (i32.add
                  (i32.shl
                   (local.tee $1
                    (i32.load offset=28
                     (local.get $5)
                    )
                   )
                   (i32.const 2)
                  )
                  (i32.const 480)
                 )
                )
               )
              )
              (block
               (i32.store
                (local.get $0)
                (local.get $9)
               )
               (if
                (i32.eqz
                 (local.get $9)
                )
                (block
                 (i32.store
                  (i32.const 180)
                  (i32.and
                   (i32.load
                    (i32.const 180)
                   )
                   (i32.xor
                    (i32.shl
                     (i32.const 1)
                     (local.get $1)
                    )
                    (i32.const -1)
                   )
                  )
                 )
                 (br $do-once8)
                )
               )
              )
              (block
               (if
                (i32.lt_u
                 (local.get $8)
                 (i32.load
                  (i32.const 192)
                 )
                )
                (call $_abort)
               )
               (if
                (i32.eq
                 (i32.load
                  (local.tee $0
                   (i32.add
                    (local.get $8)
                    (i32.const 16)
                   )
                  )
                 )
                 (local.get $5)
                )
                (i32.store
                 (local.get $0)
                 (local.get $9)
                )
                (i32.store offset=20
                 (local.get $8)
                 (local.get $9)
                )
               )
               (br_if $do-once8
                (i32.eqz
                 (local.get $9)
                )
               )
              )
             )
             (if
              (i32.lt_u
               (local.get $9)
               (local.tee $0
                (i32.load
                 (i32.const 192)
                )
               )
              )
              (call $_abort)
             )
             (i32.store offset=24
              (local.get $9)
              (local.get $8)
             )
             (if
              (local.tee $1
               (i32.load offset=16
                (local.get $5)
               )
              )
              (if
               (i32.lt_u
                (local.get $1)
                (local.get $0)
               )
               (call $_abort)
               (block
                (i32.store offset=16
                 (local.get $9)
                 (local.get $1)
                )
                (i32.store offset=24
                 (local.get $1)
                 (local.get $9)
                )
               )
              )
             )
             (if
              (local.tee $0
               (i32.load offset=20
                (local.get $5)
               )
              )
              (if
               (i32.lt_u
                (local.get $0)
                (i32.load
                 (i32.const 192)
                )
               )
               (call $_abort)
               (block
                (i32.store offset=20
                 (local.get $9)
                 (local.get $0)
                )
                (i32.store offset=24
                 (local.get $0)
                 (local.get $9)
                )
               )
              )
             )
            )
           )
          )
          (if
           (i32.lt_u
            (local.get $10)
            (i32.const 16)
           )
           (block
            (i32.store offset=4
             (local.get $5)
             (i32.or
              (local.tee $0
               (i32.add
                (local.get $10)
                (local.get $4)
               )
              )
              (i32.const 3)
             )
            )
            (i32.store
             (local.tee $0
              (i32.add
               (i32.add
                (local.get $5)
                (local.get $0)
               )
               (i32.const 4)
              )
             )
             (i32.or
              (i32.load
               (local.get $0)
              )
              (i32.const 1)
             )
            )
           )
           (block
            (i32.store offset=4
             (local.get $5)
             (i32.or
              (local.get $4)
              (i32.const 3)
             )
            )
            (i32.store offset=4
             (local.get $11)
             (i32.or
              (local.get $10)
              (i32.const 1)
             )
            )
            (i32.store
             (i32.add
              (local.get $11)
              (local.get $10)
             )
             (local.get $10)
            )
            (if
             (local.tee $0
              (i32.load
               (i32.const 184)
              )
             )
             (block
              (local.set $4
               (i32.load
                (i32.const 196)
               )
              )
              (local.set $2
               (i32.add
                (i32.shl
                 (local.tee $0
                  (i32.shr_u
                   (local.get $0)
                   (i32.const 3)
                  )
                 )
                 (i32.const 3)
                )
                (i32.const 216)
               )
              )
              (if
               (i32.and
                (local.tee $1
                 (i32.load
                  (i32.const 176)
                 )
                )
                (local.tee $0
                 (i32.shl
                  (i32.const 1)
                  (local.get $0)
                 )
                )
               )
               (if
                (i32.lt_u
                 (local.tee $0
                  (i32.load
                   (local.tee $1
                    (i32.add
                     (local.get $2)
                     (i32.const 8)
                    )
                   )
                  )
                 )
                 (i32.load
                  (i32.const 192)
                 )
                )
                (call $_abort)
                (block
                 (local.set $6
                  (local.get $1)
                 )
                 (local.set $3
                  (local.get $0)
                 )
                )
               )
               (block
                (i32.store
                 (i32.const 176)
                 (i32.or
                  (local.get $1)
                  (local.get $0)
                 )
                )
                (local.set $6
                 (i32.add
                  (local.get $2)
                  (i32.const 8)
                 )
                )
                (local.set $3
                 (local.get $2)
                )
               )
              )
              (i32.store
               (local.get $6)
               (local.get $4)
              )
              (i32.store offset=12
               (local.get $3)
               (local.get $4)
              )
              (i32.store offset=8
               (local.get $4)
               (local.get $3)
              )
              (i32.store offset=12
               (local.get $4)
               (local.get $2)
              )
             )
            )
            (i32.store
             (i32.const 184)
             (local.get $10)
            )
            (i32.store
             (i32.const 196)
             (local.get $11)
            )
           )
          )
          (return
           (i32.add
            (local.get $5)
            (i32.const 8)
           )
          )
         )
         (local.set $0
          (local.get $4)
         )
        )
       )
       (local.set $0
        (local.get $4)
       )
      )
     )
     (if
      (i32.gt_u
       (local.get $0)
       (i32.const -65)
      )
      (local.set $0
       (i32.const -1)
      )
      (block
       (local.set $2
        (i32.and
         (local.tee $0
          (i32.add
           (local.get $0)
           (i32.const 11)
          )
         )
         (i32.const -8)
        )
       )
       (if
        (local.tee $18
         (i32.load
          (i32.const 180)
         )
        )
        (block
         (local.set $14
          (if (result i32)
           (local.tee $0
            (i32.shr_u
             (local.get $0)
             (i32.const 8)
            )
           )
           (if (result i32)
            (i32.gt_u
             (local.get $2)
             (i32.const 16777215)
            )
            (i32.const 31)
            (i32.or
             (i32.and
              (i32.shr_u
               (local.get $2)
               (i32.add
                (local.tee $0
                 (i32.add
                  (i32.sub
                   (i32.const 14)
                   (i32.or
                    (i32.or
                     (local.tee $0
                      (i32.and
                       (i32.shr_u
                        (i32.add
                         (local.tee $1
                          (i32.shl
                           (local.get $0)
                           (local.tee $3
                            (i32.and
                             (i32.shr_u
                              (i32.add
                               (local.get $0)
                               (i32.const 1048320)
                              )
                              (i32.const 16)
                             )
                             (i32.const 8)
                            )
                           )
                          )
                         )
                         (i32.const 520192)
                        )
                        (i32.const 16)
                       )
                       (i32.const 4)
                      )
                     )
                     (local.get $3)
                    )
                    (local.tee $0
                     (i32.and
                      (i32.shr_u
                       (i32.add
                        (local.tee $1
                         (i32.shl
                          (local.get $1)
                          (local.get $0)
                         )
                        )
                        (i32.const 245760)
                       )
                       (i32.const 16)
                      )
                      (i32.const 2)
                     )
                    )
                   )
                  )
                  (i32.shr_u
                   (i32.shl
                    (local.get $1)
                    (local.get $0)
                   )
                   (i32.const 15)
                  )
                 )
                )
                (i32.const 7)
               )
              )
              (i32.const 1)
             )
             (i32.shl
              (local.get $0)
              (i32.const 1)
             )
            )
           )
           (i32.const 0)
          )
         )
         (local.set $3
          (i32.sub
           (i32.const 0)
           (local.get $2)
          )
         )
         (block $__rjto$3
          (block $__rjti$3
           (if
            (local.tee $0
             (i32.load offset=480
              (i32.shl
               (local.get $14)
               (i32.const 2)
              )
             )
            )
            (block
             (local.set $6
              (i32.const 0)
             )
             (local.set $8
              (i32.shl
               (local.get $2)
               (select
                (i32.const 0)
                (i32.sub
                 (i32.const 25)
                 (i32.shr_u
                  (local.get $14)
                  (i32.const 1)
                 )
                )
                (i32.eq
                 (local.get $14)
                 (i32.const 31)
                )
               )
              )
             )
             (local.set $1
              (i32.const 0)
             )
             (loop $while-in14
              (if
               (i32.lt_u
                (local.tee $4
                 (i32.sub
                  (local.tee $9
                   (i32.and
                    (i32.load offset=4
                     (local.get $0)
                    )
                    (i32.const -8)
                   )
                  )
                  (local.get $2)
                 )
                )
                (local.get $3)
               )
               (if
                (i32.eq
                 (local.get $9)
                 (local.get $2)
                )
                (block
                 (local.set $1
                  (local.get $4)
                 )
                 (local.set $3
                  (local.get $0)
                 )
                 (br $__rjti$3)
                )
                (block
                 (local.set $3
                  (local.get $4)
                 )
                 (local.set $1
                  (local.get $0)
                 )
                )
               )
              )
              (local.set $0
               (select
                (local.get $6)
                (local.tee $4
                 (i32.load offset=20
                  (local.get $0)
                 )
                )
                (i32.or
                 (i32.eqz
                  (local.get $4)
                 )
                 (i32.eq
                  (local.get $4)
                  (local.tee $9
                   (i32.load
                    (i32.add
                     (i32.add
                      (local.get $0)
                      (i32.const 16)
                     )
                     (i32.shl
                      (i32.shr_u
                       (local.get $8)
                       (i32.const 31)
                      )
                      (i32.const 2)
                     )
                    )
                   )
                  )
                 )
                )
               )
              )
              (local.set $4
               (i32.shl
                (local.get $8)
                (i32.xor
                 (local.tee $6
                  (i32.eqz
                   (local.get $9)
                  )
                 )
                 (i32.const 1)
                )
               )
              )
              (if
               (local.get $6)
               (block
                (local.set $4
                 (local.get $0)
                )
                (local.set $0
                 (local.get $1)
                )
               )
               (block
                (local.set $6
                 (local.get $0)
                )
                (local.set $8
                 (local.get $4)
                )
                (local.set $0
                 (local.get $9)
                )
                (br $while-in14)
               )
              )
             )
            )
            (block
             (local.set $4
              (i32.const 0)
             )
             (local.set $0
              (i32.const 0)
             )
            )
           )
           (if
            (i32.and
             (i32.eqz
              (local.get $4)
             )
             (i32.eqz
              (local.get $0)
             )
            )
            (block
             (if
              (i32.eqz
               (local.tee $1
                (i32.and
                 (local.get $18)
                 (i32.or
                  (local.tee $1
                   (i32.shl
                    (i32.const 2)
                    (local.get $14)
                   )
                  )
                  (i32.sub
                   (i32.const 0)
                   (local.get $1)
                  )
                 )
                )
               )
              )
              (block
               (local.set $0
                (local.get $2)
               )
               (br $do-once)
              )
             )
             (local.set $9
              (i32.and
               (i32.shr_u
                (local.tee $1
                 (i32.add
                  (i32.and
                   (local.get $1)
                   (i32.sub
                    (i32.const 0)
                    (local.get $1)
                   )
                  )
                  (i32.const -1)
                 )
                )
                (i32.const 12)
               )
               (i32.const 16)
              )
             )
             (local.set $4
              (i32.load offset=480
               (i32.shl
                (i32.add
                 (i32.or
                  (i32.or
                   (i32.or
                    (i32.or
                     (local.tee $1
                      (i32.and
                       (i32.shr_u
                        (local.tee $4
                         (i32.shr_u
                          (local.get $1)
                          (local.get $9)
                         )
                        )
                        (i32.const 5)
                       )
                       (i32.const 8)
                      )
                     )
                     (local.get $9)
                    )
                    (local.tee $1
                     (i32.and
                      (i32.shr_u
                       (local.tee $4
                        (i32.shr_u
                         (local.get $4)
                         (local.get $1)
                        )
                       )
                       (i32.const 2)
                      )
                      (i32.const 4)
                     )
                    )
                   )
                   (local.tee $1
                    (i32.and
                     (i32.shr_u
                      (local.tee $4
                       (i32.shr_u
                        (local.get $4)
                        (local.get $1)
                       )
                      )
                      (i32.const 1)
                     )
                     (i32.const 2)
                    )
                   )
                  )
                  (local.tee $1
                   (i32.and
                    (i32.shr_u
                     (local.tee $4
                      (i32.shr_u
                       (local.get $4)
                       (local.get $1)
                      )
                     )
                     (i32.const 1)
                    )
                    (i32.const 1)
                   )
                  )
                 )
                 (i32.shr_u
                  (local.get $4)
                  (local.get $1)
                 )
                )
                (i32.const 2)
               )
              )
             )
            )
           )
           (if
            (local.get $4)
            (block
             (local.set $1
              (local.get $3)
             )
             (local.set $3
              (local.get $4)
             )
             (br $__rjti$3)
            )
            (local.set $4
             (local.get $0)
            )
           )
           (br $__rjto$3)
          )
          (loop $while-in16
           (local.set $9
            (i32.lt_u
             (local.tee $4
              (i32.sub
               (i32.and
                (i32.load offset=4
                 (local.get $3)
                )
                (i32.const -8)
               )
               (local.get $2)
              )
             )
             (local.get $1)
            )
           )
           (local.set $1
            (select
             (local.get $4)
             (local.get $1)
             (local.get $9)
            )
           )
           (local.set $0
            (select
             (local.get $3)
             (local.get $0)
             (local.get $9)
            )
           )
           (if
            (local.tee $4
             (i32.load offset=16
              (local.get $3)
             )
            )
            (block
             (local.set $3
              (local.get $4)
             )
             (br $while-in16)
            )
           )
           (br_if $while-in16
            (local.tee $3
             (i32.load offset=20
              (local.get $3)
             )
            )
           )
           (local.set $3
            (local.get $1)
           )
           (local.set $4
            (local.get $0)
           )
          )
         )
         (if
          (local.get $4)
          (if
           (i32.lt_u
            (local.get $3)
            (i32.sub
             (i32.load
              (i32.const 184)
             )
             (local.get $2)
            )
           )
           (block
            (if
             (i32.lt_u
              (local.get $4)
              (local.tee $12
               (i32.load
                (i32.const 192)
               )
              )
             )
             (call $_abort)
            )
            (if
             (i32.ge_u
              (local.get $4)
              (local.tee $6
               (i32.add
                (local.get $4)
                (local.get $2)
               )
              )
             )
             (call $_abort)
            )
            (local.set $9
             (i32.load offset=24
              (local.get $4)
             )
            )
            (block $do-once17
             (if
              (i32.eq
               (local.tee $0
                (i32.load offset=12
                 (local.get $4)
                )
               )
               (local.get $4)
              )
              (block
               (if
                (i32.eqz
                 (local.tee $1
                  (i32.load
                   (local.tee $0
                    (i32.add
                     (local.get $4)
                     (i32.const 20)
                    )
                   )
                  )
                 )
                )
                (if
                 (i32.eqz
                  (local.tee $1
                   (i32.load
                    (local.tee $0
                     (i32.add
                      (local.get $4)
                      (i32.const 16)
                     )
                    )
                   )
                  )
                 )
                 (block
                  (local.set $11
                   (i32.const 0)
                  )
                  (br $do-once17)
                 )
                )
               )
               (loop $while-in20
                (if
                 (local.tee $7
                  (i32.load
                   (local.tee $10
                    (i32.add
                     (local.get $1)
                     (i32.const 20)
                    )
                   )
                  )
                 )
                 (block
                  (local.set $1
                   (local.get $7)
                  )
                  (local.set $0
                   (local.get $10)
                  )
                  (br $while-in20)
                 )
                )
                (if
                 (local.tee $7
                  (i32.load
                   (local.tee $10
                    (i32.add
                     (local.get $1)
                     (i32.const 16)
                    )
                   )
                  )
                 )
                 (block
                  (local.set $1
                   (local.get $7)
                  )
                  (local.set $0
                   (local.get $10)
                  )
                  (br $while-in20)
                 )
                )
               )
               (if
                (i32.lt_u
                 (local.get $0)
                 (local.get $12)
                )
                (call $_abort)
                (block
                 (i32.store
                  (local.get $0)
                  (i32.const 0)
                 )
                 (local.set $11
                  (local.get $1)
                 )
                )
               )
              )
              (block
               (if
                (i32.lt_u
                 (local.tee $10
                  (i32.load offset=8
                   (local.get $4)
                  )
                 )
                 (local.get $12)
                )
                (call $_abort)
               )
               (if
                (i32.ne
                 (i32.load
                  (local.tee $7
                   (i32.add
                    (local.get $10)
                    (i32.const 12)
                   )
                  )
                 )
                 (local.get $4)
                )
                (call $_abort)
               )
               (if
                (i32.eq
                 (i32.load
                  (local.tee $1
                   (i32.add
                    (local.get $0)
                    (i32.const 8)
                   )
                  )
                 )
                 (local.get $4)
                )
                (block
                 (i32.store
                  (local.get $7)
                  (local.get $0)
                 )
                 (i32.store
                  (local.get $1)
                  (local.get $10)
                 )
                 (local.set $11
                  (local.get $0)
                 )
                )
                (call $_abort)
               )
              )
             )
            )
            (block $do-once21
             (if
              (local.get $9)
              (block
               (if
                (i32.eq
                 (local.get $4)
                 (i32.load
                  (local.tee $0
                   (i32.add
                    (i32.shl
                     (local.tee $1
                      (i32.load offset=28
                       (local.get $4)
                      )
                     )
                     (i32.const 2)
                    )
                    (i32.const 480)
                   )
                  )
                 )
                )
                (block
                 (i32.store
                  (local.get $0)
                  (local.get $11)
                 )
                 (if
                  (i32.eqz
                   (local.get $11)
                  )
                  (block
                   (i32.store
                    (i32.const 180)
                    (i32.and
                     (i32.load
                      (i32.const 180)
                     )
                     (i32.xor
                      (i32.shl
                       (i32.const 1)
                       (local.get $1)
                      )
                      (i32.const -1)
                     )
                    )
                   )
                   (br $do-once21)
                  )
                 )
                )
                (block
                 (if
                  (i32.lt_u
                   (local.get $9)
                   (i32.load
                    (i32.const 192)
                   )
                  )
                  (call $_abort)
                 )
                 (if
                  (i32.eq
                   (i32.load
                    (local.tee $0
                     (i32.add
                      (local.get $9)
                      (i32.const 16)
                     )
                    )
                   )
                   (local.get $4)
                  )
                  (i32.store
                   (local.get $0)
                   (local.get $11)
                  )
                  (i32.store offset=20
                   (local.get $9)
                   (local.get $11)
                  )
                 )
                 (br_if $do-once21
                  (i32.eqz
                   (local.get $11)
                  )
                 )
                )
               )
               (if
                (i32.lt_u
                 (local.get $11)
                 (local.tee $0
                  (i32.load
                   (i32.const 192)
                  )
                 )
                )
                (call $_abort)
               )
               (i32.store offset=24
                (local.get $11)
                (local.get $9)
               )
               (if
                (local.tee $1
                 (i32.load offset=16
                  (local.get $4)
                 )
                )
                (if
                 (i32.lt_u
                  (local.get $1)
                  (local.get $0)
                 )
                 (call $_abort)
                 (block
                  (i32.store offset=16
                   (local.get $11)
                   (local.get $1)
                  )
                  (i32.store offset=24
                   (local.get $1)
                   (local.get $11)
                  )
                 )
                )
               )
               (if
                (local.tee $0
                 (i32.load offset=20
                  (local.get $4)
                 )
                )
                (if
                 (i32.lt_u
                  (local.get $0)
                  (i32.load
                   (i32.const 192)
                  )
                 )
                 (call $_abort)
                 (block
                  (i32.store offset=20
                   (local.get $11)
                   (local.get $0)
                  )
                  (i32.store offset=24
                   (local.get $0)
                   (local.get $11)
                  )
                 )
                )
               )
              )
             )
            )
            (block $do-once25
             (if
              (i32.lt_u
               (local.get $3)
               (i32.const 16)
              )
              (block
               (i32.store offset=4
                (local.get $4)
                (i32.or
                 (local.tee $0
                  (i32.add
                   (local.get $3)
                   (local.get $2)
                  )
                 )
                 (i32.const 3)
                )
               )
               (i32.store
                (local.tee $0
                 (i32.add
                  (i32.add
                   (local.get $4)
                   (local.get $0)
                  )
                  (i32.const 4)
                 )
                )
                (i32.or
                 (i32.load
                  (local.get $0)
                 )
                 (i32.const 1)
                )
               )
              )
              (block
               (i32.store offset=4
                (local.get $4)
                (i32.or
                 (local.get $2)
                 (i32.const 3)
                )
               )
               (i32.store offset=4
                (local.get $6)
                (i32.or
                 (local.get $3)
                 (i32.const 1)
                )
               )
               (i32.store
                (i32.add
                 (local.get $6)
                 (local.get $3)
                )
                (local.get $3)
               )
               (local.set $0
                (i32.shr_u
                 (local.get $3)
                 (i32.const 3)
                )
               )
               (if
                (i32.lt_u
                 (local.get $3)
                 (i32.const 256)
                )
                (block
                 (local.set $3
                  (i32.add
                   (i32.shl
                    (local.get $0)
                    (i32.const 3)
                   )
                   (i32.const 216)
                  )
                 )
                 (if
                  (i32.and
                   (local.tee $1
                    (i32.load
                     (i32.const 176)
                    )
                   )
                   (local.tee $0
                    (i32.shl
                     (i32.const 1)
                     (local.get $0)
                    )
                   )
                  )
                  (if
                   (i32.lt_u
                    (local.tee $0
                     (i32.load
                      (local.tee $1
                       (i32.add
                        (local.get $3)
                        (i32.const 8)
                       )
                      )
                     )
                    )
                    (i32.load
                     (i32.const 192)
                    )
                   )
                   (call $_abort)
                   (block
                    (local.set $13
                     (local.get $1)
                    )
                    (local.set $5
                     (local.get $0)
                    )
                   )
                  )
                  (block
                   (i32.store
                    (i32.const 176)
                    (i32.or
                     (local.get $1)
                     (local.get $0)
                    )
                   )
                   (local.set $13
                    (i32.add
                     (local.get $3)
                     (i32.const 8)
                    )
                   )
                   (local.set $5
                    (local.get $3)
                   )
                  )
                 )
                 (i32.store
                  (local.get $13)
                  (local.get $6)
                 )
                 (i32.store offset=12
                  (local.get $5)
                  (local.get $6)
                 )
                 (i32.store offset=8
                  (local.get $6)
                  (local.get $5)
                 )
                 (i32.store offset=12
                  (local.get $6)
                  (local.get $3)
                 )
                 (br $do-once25)
                )
               )
               (local.set $2
                (i32.add
                 (i32.shl
                  (local.tee $7
                   (if (result i32)
                    (local.tee $0
                     (i32.shr_u
                      (local.get $3)
                      (i32.const 8)
                     )
                    )
                    (if (result i32)
                     (i32.gt_u
                      (local.get $3)
                      (i32.const 16777215)
                     )
                     (i32.const 31)
                     (i32.or
                      (i32.and
                       (i32.shr_u
                        (local.get $3)
                        (i32.add
                         (local.tee $0
                          (i32.add
                           (i32.sub
                            (i32.const 14)
                            (i32.or
                             (i32.or
                              (local.tee $0
                               (i32.and
                                (i32.shr_u
                                 (i32.add
                                  (local.tee $1
                                   (i32.shl
                                    (local.get $0)
                                    (local.tee $2
                                     (i32.and
                                      (i32.shr_u
                                       (i32.add
                                        (local.get $0)
                                        (i32.const 1048320)
                                       )
                                       (i32.const 16)
                                      )
                                      (i32.const 8)
                                     )
                                    )
                                   )
                                  )
                                  (i32.const 520192)
                                 )
                                 (i32.const 16)
                                )
                                (i32.const 4)
                               )
                              )
                              (local.get $2)
                             )
                             (local.tee $0
                              (i32.and
                               (i32.shr_u
                                (i32.add
                                 (local.tee $1
                                  (i32.shl
                                   (local.get $1)
                                   (local.get $0)
                                  )
                                 )
                                 (i32.const 245760)
                                )
                                (i32.const 16)
                               )
                               (i32.const 2)
                              )
                             )
                            )
                           )
                           (i32.shr_u
                            (i32.shl
                             (local.get $1)
                             (local.get $0)
                            )
                            (i32.const 15)
                           )
                          )
                         )
                         (i32.const 7)
                        )
                       )
                       (i32.const 1)
                      )
                      (i32.shl
                       (local.get $0)
                       (i32.const 1)
                      )
                     )
                    )
                    (i32.const 0)
                   )
                  )
                  (i32.const 2)
                 )
                 (i32.const 480)
                )
               )
               (i32.store offset=28
                (local.get $6)
                (local.get $7)
               )
               (i32.store offset=4
                (local.tee $0
                 (i32.add
                  (local.get $6)
                  (i32.const 16)
                 )
                )
                (i32.const 0)
               )
               (i32.store
                (local.get $0)
                (i32.const 0)
               )
               (if
                (i32.eqz
                 (i32.and
                  (local.tee $1
                   (i32.load
                    (i32.const 180)
                   )
                  )
                  (local.tee $0
                   (i32.shl
                    (i32.const 1)
                    (local.get $7)
                   )
                  )
                 )
                )
                (block
                 (i32.store
                  (i32.const 180)
                  (i32.or
                   (local.get $1)
                   (local.get $0)
                  )
                 )
                 (i32.store
                  (local.get $2)
                  (local.get $6)
                 )
                 (i32.store offset=24
                  (local.get $6)
                  (local.get $2)
                 )
                 (i32.store offset=12
                  (local.get $6)
                  (local.get $6)
                 )
                 (i32.store offset=8
                  (local.get $6)
                  (local.get $6)
                 )
                 (br $do-once25)
                )
               )
               (local.set $7
                (i32.shl
                 (local.get $3)
                 (select
                  (i32.const 0)
                  (i32.sub
                   (i32.const 25)
                   (i32.shr_u
                    (local.get $7)
                    (i32.const 1)
                   )
                  )
                  (i32.eq
                   (local.get $7)
                   (i32.const 31)
                  )
                 )
                )
               )
               (local.set $0
                (i32.load
                 (local.get $2)
                )
               )
               (block $__rjto$1
                (block $__rjti$1
                 (loop $while-in28
                  (br_if $__rjti$1
                   (i32.eq
                    (i32.and
                     (i32.load offset=4
                      (local.get $0)
                     )
                     (i32.const -8)
                    )
                    (local.get $3)
                   )
                  )
                  (local.set $2
                   (i32.shl
                    (local.get $7)
                    (i32.const 1)
                   )
                  )
                  (if
                   (local.tee $1
                    (i32.load
                     (local.tee $7
                      (i32.add
                       (i32.add
                        (local.get $0)
                        (i32.const 16)
                       )
                       (i32.shl
                        (i32.shr_u
                         (local.get $7)
                         (i32.const 31)
                        )
                        (i32.const 2)
                       )
                      )
                     )
                    )
                   )
                   (block
                    (local.set $7
                     (local.get $2)
                    )
                    (local.set $0
                     (local.get $1)
                    )
                    (br $while-in28)
                   )
                  )
                 )
                 (if
                  (i32.lt_u
                   (local.get $7)
                   (i32.load
                    (i32.const 192)
                   )
                  )
                  (call $_abort)
                  (block
                   (i32.store
                    (local.get $7)
                    (local.get $6)
                   )
                   (i32.store offset=24
                    (local.get $6)
                    (local.get $0)
                   )
                   (i32.store offset=12
                    (local.get $6)
                    (local.get $6)
                   )
                   (i32.store offset=8
                    (local.get $6)
                    (local.get $6)
                   )
                   (br $do-once25)
                  )
                 )
                 (br $__rjto$1)
                )
                (if
                 (i32.and
                  (i32.ge_u
                   (local.tee $2
                    (i32.load
                     (local.tee $3
                      (i32.add
                       (local.get $0)
                       (i32.const 8)
                      )
                     )
                    )
                   )
                   (local.tee $1
                    (i32.load
                     (i32.const 192)
                    )
                   )
                  )
                  (i32.ge_u
                   (local.get $0)
                   (local.get $1)
                  )
                 )
                 (block
                  (i32.store offset=12
                   (local.get $2)
                   (local.get $6)
                  )
                  (i32.store
                   (local.get $3)
                   (local.get $6)
                  )
                  (i32.store offset=8
                   (local.get $6)
                   (local.get $2)
                  )
                  (i32.store offset=12
                   (local.get $6)
                   (local.get $0)
                  )
                  (i32.store offset=24
                   (local.get $6)
                   (i32.const 0)
                  )
                 )
                 (call $_abort)
                )
               )
              )
             )
            )
            (return
             (i32.add
              (local.get $4)
              (i32.const 8)
             )
            )
           )
           (local.set $0
            (local.get $2)
           )
          )
          (local.set $0
           (local.get $2)
          )
         )
        )
        (local.set $0
         (local.get $2)
        )
       )
      )
     )
    )
   )
   (if
    (i32.ge_u
     (local.tee $1
      (i32.load
       (i32.const 184)
      )
     )
     (local.get $0)
    )
    (block
     (local.set $2
      (i32.load
       (i32.const 196)
      )
     )
     (if
      (i32.gt_u
       (local.tee $3
        (i32.sub
         (local.get $1)
         (local.get $0)
        )
       )
       (i32.const 15)
      )
      (block
       (i32.store
        (i32.const 196)
        (local.tee $1
         (i32.add
          (local.get $2)
          (local.get $0)
         )
        )
       )
       (i32.store
        (i32.const 184)
        (local.get $3)
       )
       (i32.store offset=4
        (local.get $1)
        (i32.or
         (local.get $3)
         (i32.const 1)
        )
       )
       (i32.store
        (i32.add
         (local.get $1)
         (local.get $3)
        )
        (local.get $3)
       )
       (i32.store offset=4
        (local.get $2)
        (i32.or
         (local.get $0)
         (i32.const 3)
        )
       )
      )
      (block
       (i32.store
        (i32.const 184)
        (i32.const 0)
       )
       (i32.store
        (i32.const 196)
        (i32.const 0)
       )
       (i32.store offset=4
        (local.get $2)
        (i32.or
         (local.get $1)
         (i32.const 3)
        )
       )
       (i32.store
        (local.tee $0
         (i32.add
          (i32.add
           (local.get $2)
           (local.get $1)
          )
          (i32.const 4)
         )
        )
        (i32.or
         (i32.load
          (local.get $0)
         )
         (i32.const 1)
        )
       )
      )
     )
     (return
      (i32.add
       (local.get $2)
       (i32.const 8)
      )
     )
    )
   )
   (br_if $folding-inner0
    (i32.gt_u
     (local.tee $1
      (i32.load
       (i32.const 188)
      )
     )
     (local.get $0)
    )
   )
   (if
    (i32.eqz
     (i32.load
      (i32.const 648)
     )
    )
    (if
     (i32.and
      (i32.add
       (local.tee $1
        (call $_sysconf
         (i32.const 30)
        )
       )
       (i32.const -1)
      )
      (local.get $1)
     )
     (call $_abort)
     (block
      (i32.store
       (i32.const 656)
       (local.get $1)
      )
      (i32.store
       (i32.const 652)
       (local.get $1)
      )
      (i32.store
       (i32.const 660)
       (i32.const -1)
      )
      (i32.store
       (i32.const 664)
       (i32.const -1)
      )
      (i32.store
       (i32.const 668)
       (i32.const 0)
      )
      (i32.store
       (i32.const 620)
       (i32.const 0)
      )
      (i32.store
       (i32.const 648)
       (i32.xor
        (i32.and
         (call $_time
          (i32.const 0)
         )
         (i32.const -16)
        )
        (i32.const 1431655768)
       )
      )
     )
    )
   )
   (if
    (i32.le_u
     (local.tee $5
      (i32.and
       (local.tee $6
        (i32.add
         (local.tee $1
          (i32.load
           (i32.const 656)
          )
         )
         (local.tee $8
          (i32.add
           (local.get $0)
           (i32.const 47)
          )
         )
        )
       )
       (local.tee $9
        (i32.sub
         (i32.const 0)
         (local.get $1)
        )
       )
      )
     )
     (local.get $0)
    )
    (return
     (i32.const 0)
    )
   )
   (if
    (local.tee $2
     (i32.load
      (i32.const 616)
     )
    )
    (if
     (i32.or
      (i32.le_u
       (local.tee $1
        (i32.add
         (local.tee $3
          (i32.load
           (i32.const 608)
          )
         )
         (local.get $5)
        )
       )
       (local.get $3)
      )
      (i32.gt_u
       (local.get $1)
       (local.get $2)
      )
     )
     (return
      (i32.const 0)
     )
    )
   )
   (local.set $11
    (i32.add
     (local.get $0)
     (i32.const 48)
    )
   )
   (block $__rjto$13
    (block $__rjti$13
     (if
      (i32.eqz
       (i32.and
        (i32.load
         (i32.const 620)
        )
        (i32.const 4)
       )
      )
      (block
       (block $label$break$L279
        (block $__rjti$5
         (block $__rjti$4
          (br_if $__rjti$4
           (i32.eqz
            (local.tee $4
             (i32.load
              (i32.const 200)
             )
            )
           )
          )
          (local.set $1
           (i32.const 624)
          )
          (loop $while-in34
           (block $while-out33
            (if
             (i32.le_u
              (local.tee $3
               (i32.load
                (local.get $1)
               )
              )
              (local.get $4)
             )
             (if
              (i32.gt_u
               (i32.add
                (local.get $3)
                (i32.load
                 (local.tee $2
                  (i32.add
                   (local.get $1)
                   (i32.const 4)
                  )
                 )
                )
               )
               (local.get $4)
              )
              (block
               (local.set $4
                (local.get $1)
               )
               (br $while-out33)
              )
             )
            )
            (br_if $while-in34
             (local.tee $1
              (i32.load offset=8
               (local.get $1)
              )
             )
            )
            (br $__rjti$4)
           )
          )
          (if
           (i32.lt_u
            (local.tee $3
             (i32.and
              (i32.sub
               (local.get $6)
               (i32.load
                (i32.const 188)
               )
              )
              (local.get $9)
             )
            )
            (i32.const 2147483647)
           )
           (if
            (i32.eq
             (local.tee $1
              (call $_sbrk
               (local.get $3)
              )
             )
             (i32.add
              (i32.load
               (local.get $4)
              )
              (i32.load
               (local.get $2)
              )
             )
            )
            (br_if $__rjti$13
             (i32.ne
              (local.get $1)
              (i32.const -1)
             )
            )
            (block
             (local.set $2
              (local.get $1)
             )
             (br $__rjti$5)
            )
           )
          )
          (br $label$break$L279)
         )
         (if
          (i32.ne
           (local.tee $1
            (call $_sbrk
             (i32.const 0)
            )
           )
           (i32.const -1)
          )
          (block
           (local.set $3
            (if (result i32)
             (i32.and
              (local.tee $2
               (i32.add
                (local.tee $4
                 (i32.load
                  (i32.const 652)
                 )
                )
                (i32.const -1)
               )
              )
              (local.tee $3
               (local.get $1)
              )
             )
             (i32.add
              (i32.sub
               (local.get $5)
               (local.get $3)
              )
              (i32.and
               (i32.add
                (local.get $2)
                (local.get $3)
               )
               (i32.sub
                (i32.const 0)
                (local.get $4)
               )
              )
             )
             (local.get $5)
            )
           )
           (local.set $9
            (i32.add
             (local.tee $4
              (i32.load
               (i32.const 608)
              )
             )
             (local.get $3)
            )
           )
           (if
            (i32.and
             (i32.gt_u
              (local.get $3)
              (local.get $0)
             )
             (i32.lt_u
              (local.get $3)
              (i32.const 2147483647)
             )
            )
            (block
             (if
              (local.tee $2
               (i32.load
                (i32.const 616)
               )
              )
              (br_if $label$break$L279
               (i32.or
                (i32.le_u
                 (local.get $9)
                 (local.get $4)
                )
                (i32.gt_u
                 (local.get $9)
                 (local.get $2)
                )
               )
              )
             )
             (br_if $__rjti$13
              (i32.eq
               (local.tee $2
                (call $_sbrk
                 (local.get $3)
                )
               )
               (local.get $1)
              )
             )
             (br $__rjti$5)
            )
           )
          )
         )
         (br $label$break$L279)
        )
        (local.set $1
         (local.get $3)
        )
        (local.set $4
         (i32.sub
          (i32.const 0)
          (local.get $1)
         )
        )
        (if
         (i32.and
          (i32.gt_u
           (local.get $11)
           (local.get $1)
          )
          (i32.and
           (i32.lt_u
            (local.get $1)
            (i32.const 2147483647)
           )
           (i32.ne
            (local.get $2)
            (i32.const -1)
           )
          )
         )
         (if
          (i32.lt_u
           (local.tee $3
            (i32.and
             (i32.add
              (i32.sub
               (local.get $8)
               (local.get $1)
              )
              (local.tee $3
               (i32.load
                (i32.const 656)
               )
              )
             )
             (i32.sub
              (i32.const 0)
              (local.get $3)
             )
            )
           )
           (i32.const 2147483647)
          )
          (if
           (i32.eq
            (call $_sbrk
             (local.get $3)
            )
            (i32.const -1)
           )
           (block
            (drop
             (call $_sbrk
              (local.get $4)
             )
            )
            (br $label$break$L279)
           )
           (local.set $3
            (i32.add
             (local.get $3)
             (local.get $1)
            )
           )
          )
          (local.set $3
           (local.get $1)
          )
         )
         (local.set $3
          (local.get $1)
         )
        )
        (if
         (i32.ne
          (local.get $2)
          (i32.const -1)
         )
         (block
          (local.set $1
           (local.get $2)
          )
          (br $__rjti$13)
         )
        )
       )
       (i32.store
        (i32.const 620)
        (i32.or
         (i32.load
          (i32.const 620)
         )
         (i32.const 4)
        )
       )
      )
     )
     (if
      (i32.lt_u
       (local.get $5)
       (i32.const 2147483647)
      )
      (if
       (i32.and
        (i32.lt_u
         (local.tee $1
          (call $_sbrk
           (local.get $5)
          )
         )
         (local.tee $3
          (call $_sbrk
           (i32.const 0)
          )
         )
        )
        (i32.and
         (i32.ne
          (local.get $1)
          (i32.const -1)
         )
         (i32.ne
          (local.get $3)
          (i32.const -1)
         )
        )
       )
       (br_if $__rjti$13
        (i32.gt_u
         (local.tee $3
          (i32.sub
           (local.get $3)
           (local.get $1)
          )
         )
         (i32.add
          (local.get $0)
          (i32.const 40)
         )
        )
       )
      )
     )
     (br $__rjto$13)
    )
    (i32.store
     (i32.const 608)
     (local.tee $2
      (i32.add
       (i32.load
        (i32.const 608)
       )
       (local.get $3)
      )
     )
    )
    (if
     (i32.gt_u
      (local.get $2)
      (i32.load
       (i32.const 612)
      )
     )
     (i32.store
      (i32.const 612)
      (local.get $2)
     )
    )
    (block $do-once40
     (if
      (local.tee $6
       (i32.load
        (i32.const 200)
       )
      )
      (block
       (local.set $2
        (i32.const 624)
       )
       (block $__rjto$10
        (block $__rjti$10
         (loop $while-in45
          (br_if $__rjti$10
           (i32.eq
            (local.get $1)
            (i32.add
             (local.tee $11
              (i32.load
               (local.get $2)
              )
             )
             (local.tee $5
              (i32.load
               (local.tee $4
                (i32.add
                 (local.get $2)
                 (i32.const 4)
                )
               )
              )
             )
            )
           )
          )
          (br_if $while-in45
           (local.tee $2
            (i32.load offset=8
             (local.get $2)
            )
           )
          )
         )
         (br $__rjto$10)
        )
        (if
         (i32.eqz
          (i32.and
           (i32.load offset=12
            (local.get $2)
           )
           (i32.const 8)
          )
         )
         (if
          (i32.and
           (i32.lt_u
            (local.get $6)
            (local.get $1)
           )
           (i32.ge_u
            (local.get $6)
            (local.get $11)
           )
          )
          (block
           (i32.store
            (local.get $4)
            (i32.add
             (local.get $5)
             (local.get $3)
            )
           )
           (local.set $2
            (i32.add
             (local.get $6)
             (local.tee $1
              (select
               (i32.and
                (i32.sub
                 (i32.const 0)
                 (local.tee $1
                  (i32.add
                   (local.get $6)
                   (i32.const 8)
                  )
                 )
                )
                (i32.const 7)
               )
               (i32.const 0)
               (i32.and
                (local.get $1)
                (i32.const 7)
               )
              )
             )
            )
           )
           (local.set $1
            (i32.add
             (i32.sub
              (local.get $3)
              (local.get $1)
             )
             (i32.load
              (i32.const 188)
             )
            )
           )
           (i32.store
            (i32.const 200)
            (local.get $2)
           )
           (i32.store
            (i32.const 188)
            (local.get $1)
           )
           (i32.store offset=4
            (local.get $2)
            (i32.or
             (local.get $1)
             (i32.const 1)
            )
           )
           (i32.store offset=4
            (i32.add
             (local.get $2)
             (local.get $1)
            )
            (i32.const 40)
           )
           (i32.store
            (i32.const 204)
            (i32.load
             (i32.const 664)
            )
           )
           (br $do-once40)
          )
         )
        )
       )
       (if
        (i32.lt_u
         (local.get $1)
         (local.tee $4
          (i32.load
           (i32.const 192)
          )
         )
        )
        (block
         (i32.store
          (i32.const 192)
          (local.get $1)
         )
         (local.set $4
          (local.get $1)
         )
        )
       )
       (local.set $11
        (i32.add
         (local.get $1)
         (local.get $3)
        )
       )
       (local.set $2
        (i32.const 624)
       )
       (block $__rjto$11
        (block $__rjti$11
         (loop $while-in47
          (if
           (i32.eq
            (i32.load
             (local.get $2)
            )
            (local.get $11)
           )
           (block
            (local.set $5
             (local.get $2)
            )
            (br $__rjti$11)
           )
          )
          (br_if $while-in47
           (local.tee $2
            (i32.load offset=8
             (local.get $2)
            )
           )
          )
          (local.set $4
           (i32.const 624)
          )
         )
         (br $__rjto$11)
        )
        (if
         (i32.and
          (i32.load offset=12
           (local.get $2)
          )
          (i32.const 8)
         )
         (local.set $4
          (i32.const 624)
         )
         (block
          (i32.store
           (local.get $5)
           (local.get $1)
          )
          (i32.store
           (local.tee $2
            (i32.add
             (local.get $2)
             (i32.const 4)
            )
           )
           (i32.add
            (i32.load
             (local.get $2)
            )
            (local.get $3)
           )
          )
          (local.set $8
           (i32.add
            (local.tee $9
             (i32.add
              (local.get $1)
              (select
               (i32.and
                (i32.sub
                 (i32.const 0)
                 (local.tee $1
                  (i32.add
                   (local.get $1)
                   (i32.const 8)
                  )
                 )
                )
                (i32.const 7)
               )
               (i32.const 0)
               (i32.and
                (local.get $1)
                (i32.const 7)
               )
              )
             )
            )
            (local.get $0)
           )
          )
          (local.set $7
           (i32.sub
            (i32.sub
             (local.tee $5
              (i32.add
               (local.get $11)
               (select
                (i32.and
                 (i32.sub
                  (i32.const 0)
                  (local.tee $1
                   (i32.add
                    (local.get $11)
                    (i32.const 8)
                   )
                  )
                 )
                 (i32.const 7)
                )
                (i32.const 0)
                (i32.and
                 (local.get $1)
                 (i32.const 7)
                )
               )
              )
             )
             (local.get $9)
            )
            (local.get $0)
           )
          )
          (i32.store offset=4
           (local.get $9)
           (i32.or
            (local.get $0)
            (i32.const 3)
           )
          )
          (block $do-once48
           (if
            (i32.eq
             (local.get $5)
             (local.get $6)
            )
            (block
             (i32.store
              (i32.const 188)
              (local.tee $0
               (i32.add
                (i32.load
                 (i32.const 188)
                )
                (local.get $7)
               )
              )
             )
             (i32.store
              (i32.const 200)
              (local.get $8)
             )
             (i32.store offset=4
              (local.get $8)
              (i32.or
               (local.get $0)
               (i32.const 1)
              )
             )
            )
            (block
             (if
              (i32.eq
               (local.get $5)
               (i32.load
                (i32.const 196)
               )
              )
              (block
               (i32.store
                (i32.const 184)
                (local.tee $0
                 (i32.add
                  (i32.load
                   (i32.const 184)
                  )
                  (local.get $7)
                 )
                )
               )
               (i32.store
                (i32.const 196)
                (local.get $8)
               )
               (i32.store offset=4
                (local.get $8)
                (i32.or
                 (local.get $0)
                 (i32.const 1)
                )
               )
               (i32.store
                (i32.add
                 (local.get $8)
                 (local.get $0)
                )
                (local.get $0)
               )
               (br $do-once48)
              )
             )
             (i32.store
              (local.tee $0
               (i32.add
                (local.tee $0
                 (if (result i32)
                  (i32.eq
                   (i32.and
                    (local.tee $0
                     (i32.load offset=4
                      (local.get $5)
                     )
                    )
                    (i32.const 3)
                   )
                   (i32.const 1)
                  )
                  (block (result i32)
                   (local.set $11
                    (i32.and
                     (local.get $0)
                     (i32.const -8)
                    )
                   )
                   (local.set $1
                    (i32.shr_u
                     (local.get $0)
                     (i32.const 3)
                    )
                   )
                   (block $label$break$L331
                    (if
                     (i32.lt_u
                      (local.get $0)
                      (i32.const 256)
                     )
                     (block
                      (local.set $2
                       (i32.load offset=12
                        (local.get $5)
                       )
                      )
                      (block $do-once51
                       (if
                        (i32.ne
                         (local.tee $3
                          (i32.load offset=8
                           (local.get $5)
                          )
                         )
                         (local.tee $0
                          (i32.add
                           (i32.shl
                            (local.get $1)
                            (i32.const 3)
                           )
                           (i32.const 216)
                          )
                         )
                        )
                        (block
                         (if
                          (i32.lt_u
                           (local.get $3)
                           (local.get $4)
                          )
                          (call $_abort)
                         )
                         (br_if $do-once51
                          (i32.eq
                           (i32.load offset=12
                            (local.get $3)
                           )
                           (local.get $5)
                          )
                         )
                         (call $_abort)
                        )
                       )
                      )
                      (if
                       (i32.eq
                        (local.get $2)
                        (local.get $3)
                       )
                       (block
                        (i32.store
                         (i32.const 176)
                         (i32.and
                          (i32.load
                           (i32.const 176)
                          )
                          (i32.xor
                           (i32.shl
                            (i32.const 1)
                            (local.get $1)
                           )
                           (i32.const -1)
                          )
                         )
                        )
                        (br $label$break$L331)
                       )
                      )
                      (block $do-once53
                       (if
                        (i32.eq
                         (local.get $2)
                         (local.get $0)
                        )
                        (local.set $15
                         (i32.add
                          (local.get $2)
                          (i32.const 8)
                         )
                        )
                        (block
                         (if
                          (i32.lt_u
                           (local.get $2)
                           (local.get $4)
                          )
                          (call $_abort)
                         )
                         (if
                          (i32.eq
                           (i32.load
                            (local.tee $0
                             (i32.add
                              (local.get $2)
                              (i32.const 8)
                             )
                            )
                           )
                           (local.get $5)
                          )
                          (block
                           (local.set $15
                            (local.get $0)
                           )
                           (br $do-once53)
                          )
                         )
                         (call $_abort)
                        )
                       )
                      )
                      (i32.store offset=12
                       (local.get $3)
                       (local.get $2)
                      )
                      (i32.store
                       (local.get $15)
                       (local.get $3)
                      )
                     )
                     (block
                      (local.set $6
                       (i32.load offset=24
                        (local.get $5)
                       )
                      )
                      (block $do-once55
                       (if
                        (i32.eq
                         (local.tee $0
                          (i32.load offset=12
                           (local.get $5)
                          )
                         )
                         (local.get $5)
                        )
                        (block
                         (if
                          (i32.eqz
                           (local.tee $1
                            (i32.load
                             (local.tee $0
                              (i32.add
                               (local.tee $3
                                (i32.add
                                 (local.get $5)
                                 (i32.const 16)
                                )
                               )
                               (i32.const 4)
                              )
                             )
                            )
                           )
                          )
                          (if
                           (local.tee $1
                            (i32.load
                             (local.get $3)
                            )
                           )
                           (local.set $0
                            (local.get $3)
                           )
                           (block
                            (local.set $12
                             (i32.const 0)
                            )
                            (br $do-once55)
                           )
                          )
                         )
                         (loop $while-in58
                          (if
                           (local.tee $3
                            (i32.load
                             (local.tee $2
                              (i32.add
                               (local.get $1)
                               (i32.const 20)
                              )
                             )
                            )
                           )
                           (block
                            (local.set $1
                             (local.get $3)
                            )
                            (local.set $0
                             (local.get $2)
                            )
                            (br $while-in58)
                           )
                          )
                          (if
                           (local.tee $3
                            (i32.load
                             (local.tee $2
                              (i32.add
                               (local.get $1)
                               (i32.const 16)
                              )
                             )
                            )
                           )
                           (block
                            (local.set $1
                             (local.get $3)
                            )
                            (local.set $0
                             (local.get $2)
                            )
                            (br $while-in58)
                           )
                          )
                         )
                         (if
                          (i32.lt_u
                           (local.get $0)
                           (local.get $4)
                          )
                          (call $_abort)
                          (block
                           (i32.store
                            (local.get $0)
                            (i32.const 0)
                           )
                           (local.set $12
                            (local.get $1)
                           )
                          )
                         )
                        )
                        (block
                         (if
                          (i32.lt_u
                           (local.tee $2
                            (i32.load offset=8
                             (local.get $5)
                            )
                           )
                           (local.get $4)
                          )
                          (call $_abort)
                         )
                         (if
                          (i32.ne
                           (i32.load
                            (local.tee $3
                             (i32.add
                              (local.get $2)
                              (i32.const 12)
                             )
                            )
                           )
                           (local.get $5)
                          )
                          (call $_abort)
                         )
                         (if
                          (i32.eq
                           (i32.load
                            (local.tee $1
                             (i32.add
                              (local.get $0)
                              (i32.const 8)
                             )
                            )
                           )
                           (local.get $5)
                          )
                          (block
                           (i32.store
                            (local.get $3)
                            (local.get $0)
                           )
                           (i32.store
                            (local.get $1)
                            (local.get $2)
                           )
                           (local.set $12
                            (local.get $0)
                           )
                          )
                          (call $_abort)
                         )
                        )
                       )
                      )
                      (br_if $label$break$L331
                       (i32.eqz
                        (local.get $6)
                       )
                      )
                      (block $do-once59
                       (if
                        (i32.eq
                         (local.get $5)
                         (i32.load
                          (local.tee $0
                           (i32.add
                            (i32.shl
                             (local.tee $1
                              (i32.load offset=28
                               (local.get $5)
                              )
                             )
                             (i32.const 2)
                            )
                            (i32.const 480)
                           )
                          )
                         )
                        )
                        (block
                         (i32.store
                          (local.get $0)
                          (local.get $12)
                         )
                         (br_if $do-once59
                          (local.get $12)
                         )
                         (i32.store
                          (i32.const 180)
                          (i32.and
                           (i32.load
                            (i32.const 180)
                           )
                           (i32.xor
                            (i32.shl
                             (i32.const 1)
                             (local.get $1)
                            )
                            (i32.const -1)
                           )
                          )
                         )
                         (br $label$break$L331)
                        )
                        (block
                         (if
                          (i32.lt_u
                           (local.get $6)
                           (i32.load
                            (i32.const 192)
                           )
                          )
                          (call $_abort)
                         )
                         (if
                          (i32.eq
                           (i32.load
                            (local.tee $0
                             (i32.add
                              (local.get $6)
                              (i32.const 16)
                             )
                            )
                           )
                           (local.get $5)
                          )
                          (i32.store
                           (local.get $0)
                           (local.get $12)
                          )
                          (i32.store offset=20
                           (local.get $6)
                           (local.get $12)
                          )
                         )
                         (br_if $label$break$L331
                          (i32.eqz
                           (local.get $12)
                          )
                         )
                        )
                       )
                      )
                      (if
                       (i32.lt_u
                        (local.get $12)
                        (local.tee $1
                         (i32.load
                          (i32.const 192)
                         )
                        )
                       )
                       (call $_abort)
                      )
                      (i32.store offset=24
                       (local.get $12)
                       (local.get $6)
                      )
                      (if
                       (local.tee $3
                        (i32.load
                         (local.tee $0
                          (i32.add
                           (local.get $5)
                           (i32.const 16)
                          )
                         )
                        )
                       )
                       (if
                        (i32.lt_u
                         (local.get $3)
                         (local.get $1)
                        )
                        (call $_abort)
                        (block
                         (i32.store offset=16
                          (local.get $12)
                          (local.get $3)
                         )
                         (i32.store offset=24
                          (local.get $3)
                          (local.get $12)
                         )
                        )
                       )
                      )
                      (br_if $label$break$L331
                       (i32.eqz
                        (local.tee $0
                         (i32.load offset=4
                          (local.get $0)
                         )
                        )
                       )
                      )
                      (if
                       (i32.lt_u
                        (local.get $0)
                        (i32.load
                         (i32.const 192)
                        )
                       )
                       (call $_abort)
                       (block
                        (i32.store offset=20
                         (local.get $12)
                         (local.get $0)
                        )
                        (i32.store offset=24
                         (local.get $0)
                         (local.get $12)
                        )
                       )
                      )
                     )
                    )
                   )
                   (local.set $7
                    (i32.add
                     (local.get $11)
                     (local.get $7)
                    )
                   )
                   (i32.add
                    (local.get $5)
                    (local.get $11)
                   )
                  )
                  (local.get $5)
                 )
                )
                (i32.const 4)
               )
              )
              (i32.and
               (i32.load
                (local.get $0)
               )
               (i32.const -2)
              )
             )
             (i32.store offset=4
              (local.get $8)
              (i32.or
               (local.get $7)
               (i32.const 1)
              )
             )
             (i32.store
              (i32.add
               (local.get $8)
               (local.get $7)
              )
              (local.get $7)
             )
             (local.set $0
              (i32.shr_u
               (local.get $7)
               (i32.const 3)
              )
             )
             (if
              (i32.lt_u
               (local.get $7)
               (i32.const 256)
              )
              (block
               (local.set $3
                (i32.add
                 (i32.shl
                  (local.get $0)
                  (i32.const 3)
                 )
                 (i32.const 216)
                )
               )
               (block $do-once63
                (if
                 (i32.and
                  (local.tee $1
                   (i32.load
                    (i32.const 176)
                   )
                  )
                  (local.tee $0
                   (i32.shl
                    (i32.const 1)
                    (local.get $0)
                   )
                  )
                 )
                 (block
                  (if
                   (i32.ge_u
                    (local.tee $0
                     (i32.load
                      (local.tee $1
                       (i32.add
                        (local.get $3)
                        (i32.const 8)
                       )
                      )
                     )
                    )
                    (i32.load
                     (i32.const 192)
                    )
                   )
                   (block
                    (local.set $16
                     (local.get $1)
                    )
                    (local.set $10
                     (local.get $0)
                    )
                    (br $do-once63)
                   )
                  )
                  (call $_abort)
                 )
                 (block
                  (i32.store
                   (i32.const 176)
                   (i32.or
                    (local.get $1)
                    (local.get $0)
                   )
                  )
                  (local.set $16
                   (i32.add
                    (local.get $3)
                    (i32.const 8)
                   )
                  )
                  (local.set $10
                   (local.get $3)
                  )
                 )
                )
               )
               (i32.store
                (local.get $16)
                (local.get $8)
               )
               (i32.store offset=12
                (local.get $10)
                (local.get $8)
               )
               (i32.store offset=8
                (local.get $8)
                (local.get $10)
               )
               (i32.store offset=12
                (local.get $8)
                (local.get $3)
               )
               (br $do-once48)
              )
             )
             (local.set $3
              (i32.add
               (i32.shl
                (local.tee $2
                 (block $do-once65 (result i32)
                  (if (result i32)
                   (local.tee $0
                    (i32.shr_u
                     (local.get $7)
                     (i32.const 8)
                    )
                   )
                   (block (result i32)
                    (drop
                     (br_if $do-once65
                      (i32.const 31)
                      (i32.gt_u
                       (local.get $7)
                       (i32.const 16777215)
                      )
                     )
                    )
                    (i32.or
                     (i32.and
                      (i32.shr_u
                       (local.get $7)
                       (i32.add
                        (local.tee $0
                         (i32.add
                          (i32.sub
                           (i32.const 14)
                           (i32.or
                            (i32.or
                             (local.tee $0
                              (i32.and
                               (i32.shr_u
                                (i32.add
                                 (local.tee $1
                                  (i32.shl
                                   (local.get $0)
                                   (local.tee $3
                                    (i32.and
                                     (i32.shr_u
                                      (i32.add
                                       (local.get $0)
                                       (i32.const 1048320)
                                      )
                                      (i32.const 16)
                                     )
                                     (i32.const 8)
                                    )
                                   )
                                  )
                                 )
                                 (i32.const 520192)
                                )
                                (i32.const 16)
                               )
                               (i32.const 4)
                              )
                             )
                             (local.get $3)
                            )
                            (local.tee $0
                             (i32.and
                              (i32.shr_u
                               (i32.add
                                (local.tee $1
                                 (i32.shl
                                  (local.get $1)
                                  (local.get $0)
                                 )
                                )
                                (i32.const 245760)
                               )
                               (i32.const 16)
                              )
                              (i32.const 2)
                             )
                            )
                           )
                          )
                          (i32.shr_u
                           (i32.shl
                            (local.get $1)
                            (local.get $0)
                           )
                           (i32.const 15)
                          )
                         )
                        )
                        (i32.const 7)
                       )
                      )
                      (i32.const 1)
                     )
                     (i32.shl
                      (local.get $0)
                      (i32.const 1)
                     )
                    )
                   )
                   (i32.const 0)
                  )
                 )
                )
                (i32.const 2)
               )
               (i32.const 480)
              )
             )
             (i32.store offset=28
              (local.get $8)
              (local.get $2)
             )
             (i32.store offset=4
              (local.tee $0
               (i32.add
                (local.get $8)
                (i32.const 16)
               )
              )
              (i32.const 0)
             )
             (i32.store
              (local.get $0)
              (i32.const 0)
             )
             (if
              (i32.eqz
               (i32.and
                (local.tee $1
                 (i32.load
                  (i32.const 180)
                 )
                )
                (local.tee $0
                 (i32.shl
                  (i32.const 1)
                  (local.get $2)
                 )
                )
               )
              )
              (block
               (i32.store
                (i32.const 180)
                (i32.or
                 (local.get $1)
                 (local.get $0)
                )
               )
               (i32.store
                (local.get $3)
                (local.get $8)
               )
               (i32.store offset=24
                (local.get $8)
                (local.get $3)
               )
               (i32.store offset=12
                (local.get $8)
                (local.get $8)
               )
               (i32.store offset=8
                (local.get $8)
                (local.get $8)
               )
               (br $do-once48)
              )
             )
             (local.set $2
              (i32.shl
               (local.get $7)
               (select
                (i32.const 0)
                (i32.sub
                 (i32.const 25)
                 (i32.shr_u
                  (local.get $2)
                  (i32.const 1)
                 )
                )
                (i32.eq
                 (local.get $2)
                 (i32.const 31)
                )
               )
              )
             )
             (local.set $0
              (i32.load
               (local.get $3)
              )
             )
             (block $__rjto$7
              (block $__rjti$7
               (loop $while-in68
                (br_if $__rjti$7
                 (i32.eq
                  (i32.and
                   (i32.load offset=4
                    (local.get $0)
                   )
                   (i32.const -8)
                  )
                  (local.get $7)
                 )
                )
                (local.set $3
                 (i32.shl
                  (local.get $2)
                  (i32.const 1)
                 )
                )
                (if
                 (local.tee $1
                  (i32.load
                   (local.tee $2
                    (i32.add
                     (i32.add
                      (local.get $0)
                      (i32.const 16)
                     )
                     (i32.shl
                      (i32.shr_u
                       (local.get $2)
                       (i32.const 31)
                      )
                      (i32.const 2)
                     )
                    )
                   )
                  )
                 )
                 (block
                  (local.set $2
                   (local.get $3)
                  )
                  (local.set $0
                   (local.get $1)
                  )
                  (br $while-in68)
                 )
                )
               )
               (if
                (i32.lt_u
                 (local.get $2)
                 (i32.load
                  (i32.const 192)
                 )
                )
                (call $_abort)
                (block
                 (i32.store
                  (local.get $2)
                  (local.get $8)
                 )
                 (i32.store offset=24
                  (local.get $8)
                  (local.get $0)
                 )
                 (i32.store offset=12
                  (local.get $8)
                  (local.get $8)
                 )
                 (i32.store offset=8
                  (local.get $8)
                  (local.get $8)
                 )
                 (br $do-once48)
                )
               )
               (br $__rjto$7)
              )
              (if
               (i32.and
                (i32.ge_u
                 (local.tee $2
                  (i32.load
                   (local.tee $3
                    (i32.add
                     (local.get $0)
                     (i32.const 8)
                    )
                   )
                  )
                 )
                 (local.tee $1
                  (i32.load
                   (i32.const 192)
                  )
                 )
                )
                (i32.ge_u
                 (local.get $0)
                 (local.get $1)
                )
               )
               (block
                (i32.store offset=12
                 (local.get $2)
                 (local.get $8)
                )
                (i32.store
                 (local.get $3)
                 (local.get $8)
                )
                (i32.store offset=8
                 (local.get $8)
                 (local.get $2)
                )
                (i32.store offset=12
                 (local.get $8)
                 (local.get $0)
                )
                (i32.store offset=24
                 (local.get $8)
                 (i32.const 0)
                )
               )
               (call $_abort)
              )
             )
            )
           )
          )
          (return
           (i32.add
            (local.get $9)
            (i32.const 8)
           )
          )
         )
        )
       )
       (loop $while-in70
        (block $while-out69
         (if
          (i32.le_u
           (local.tee $2
            (i32.load
             (local.get $4)
            )
           )
           (local.get $6)
          )
          (br_if $while-out69
           (i32.gt_u
            (local.tee $2
             (i32.add
              (local.get $2)
              (i32.load offset=4
               (local.get $4)
              )
             )
            )
            (local.get $6)
           )
          )
         )
         (local.set $4
          (i32.load offset=8
           (local.get $4)
          )
         )
         (br $while-in70)
        )
       )
       (local.set $10
        (i32.add
         (local.tee $4
          (i32.add
           (local.get $2)
           (i32.const -47)
          )
         )
         (i32.const 8)
        )
       )
       (local.set $12
        (i32.add
         (local.tee $11
          (select
           (local.get $6)
           (local.tee $4
            (i32.add
             (local.get $4)
             (select
              (i32.and
               (i32.sub
                (i32.const 0)
                (local.get $10)
               )
               (i32.const 7)
              )
              (i32.const 0)
              (i32.and
               (local.get $10)
               (i32.const 7)
              )
             )
            )
           )
           (i32.lt_u
            (local.get $4)
            (local.tee $10
             (i32.add
              (local.get $6)
              (i32.const 16)
             )
            )
           )
          )
         )
         (i32.const 8)
        )
       )
       (i32.store
        (i32.const 200)
        (local.tee $5
         (i32.add
          (local.get $1)
          (local.tee $4
           (select
            (i32.and
             (i32.sub
              (i32.const 0)
              (local.tee $4
               (i32.add
                (local.get $1)
                (i32.const 8)
               )
              )
             )
             (i32.const 7)
            )
            (i32.const 0)
            (i32.and
             (local.get $4)
             (i32.const 7)
            )
           )
          )
         )
        )
       )
       (i32.store
        (i32.const 188)
        (local.tee $4
         (i32.sub
          (i32.add
           (local.get $3)
           (i32.const -40)
          )
          (local.get $4)
         )
        )
       )
       (i32.store offset=4
        (local.get $5)
        (i32.or
         (local.get $4)
         (i32.const 1)
        )
       )
       (i32.store offset=4
        (i32.add
         (local.get $5)
         (local.get $4)
        )
        (i32.const 40)
       )
       (i32.store
        (i32.const 204)
        (i32.load
         (i32.const 664)
        )
       )
       (i32.store
        (local.tee $4
         (i32.add
          (local.get $11)
          (i32.const 4)
         )
        )
        (i32.const 27)
       )
       (i32.store
        (local.get $12)
        (i32.load
         (i32.const 624)
        )
       )
       (i32.store offset=4
        (local.get $12)
        (i32.load
         (i32.const 628)
        )
       )
       (i32.store offset=8
        (local.get $12)
        (i32.load
         (i32.const 632)
        )
       )
       (i32.store offset=12
        (local.get $12)
        (i32.load
         (i32.const 636)
        )
       )
       (i32.store
        (i32.const 624)
        (local.get $1)
       )
       (i32.store
        (i32.const 628)
        (local.get $3)
       )
       (i32.store
        (i32.const 636)
        (i32.const 0)
       )
       (i32.store
        (i32.const 632)
        (local.get $12)
       )
       (local.set $1
        (i32.add
         (local.get $11)
         (i32.const 24)
        )
       )
       (loop $while-in72
        (i32.store
         (local.tee $1
          (i32.add
           (local.get $1)
           (i32.const 4)
          )
         )
         (i32.const 7)
        )
        (br_if $while-in72
         (i32.lt_u
          (i32.add
           (local.get $1)
           (i32.const 4)
          )
          (local.get $2)
         )
        )
       )
       (if
        (i32.ne
         (local.get $11)
         (local.get $6)
        )
        (block
         (i32.store
          (local.get $4)
          (i32.and
           (i32.load
            (local.get $4)
           )
           (i32.const -2)
          )
         )
         (i32.store offset=4
          (local.get $6)
          (i32.or
           (local.tee $5
            (i32.sub
             (local.get $11)
             (local.get $6)
            )
           )
           (i32.const 1)
          )
         )
         (i32.store
          (local.get $11)
          (local.get $5)
         )
         (local.set $1
          (i32.shr_u
           (local.get $5)
           (i32.const 3)
          )
         )
         (if
          (i32.lt_u
           (local.get $5)
           (i32.const 256)
          )
          (block
           (local.set $2
            (i32.add
             (i32.shl
              (local.get $1)
              (i32.const 3)
             )
             (i32.const 216)
            )
           )
           (if
            (i32.and
             (local.tee $3
              (i32.load
               (i32.const 176)
              )
             )
             (local.tee $1
              (i32.shl
               (i32.const 1)
               (local.get $1)
              )
             )
            )
            (if
             (i32.lt_u
              (local.tee $1
               (i32.load
                (local.tee $3
                 (i32.add
                  (local.get $2)
                  (i32.const 8)
                 )
                )
               )
              )
              (i32.load
               (i32.const 192)
              )
             )
             (call $_abort)
             (block
              (local.set $17
               (local.get $3)
              )
              (local.set $7
               (local.get $1)
              )
             )
            )
            (block
             (i32.store
              (i32.const 176)
              (i32.or
               (local.get $3)
               (local.get $1)
              )
             )
             (local.set $17
              (i32.add
               (local.get $2)
               (i32.const 8)
              )
             )
             (local.set $7
              (local.get $2)
             )
            )
           )
           (i32.store
            (local.get $17)
            (local.get $6)
           )
           (i32.store offset=12
            (local.get $7)
            (local.get $6)
           )
           (i32.store offset=8
            (local.get $6)
            (local.get $7)
           )
           (i32.store offset=12
            (local.get $6)
            (local.get $2)
           )
           (br $do-once40)
          )
         )
         (local.set $2
          (i32.add
           (i32.shl
            (local.tee $4
             (if (result i32)
              (local.tee $1
               (i32.shr_u
                (local.get $5)
                (i32.const 8)
               )
              )
              (if (result i32)
               (i32.gt_u
                (local.get $5)
                (i32.const 16777215)
               )
               (i32.const 31)
               (i32.or
                (i32.and
                 (i32.shr_u
                  (local.get $5)
                  (i32.add
                   (local.tee $1
                    (i32.add
                     (i32.sub
                      (i32.const 14)
                      (i32.or
                       (i32.or
                        (local.tee $1
                         (i32.and
                          (i32.shr_u
                           (i32.add
                            (local.tee $3
                             (i32.shl
                              (local.get $1)
                              (local.tee $2
                               (i32.and
                                (i32.shr_u
                                 (i32.add
                                  (local.get $1)
                                  (i32.const 1048320)
                                 )
                                 (i32.const 16)
                                )
                                (i32.const 8)
                               )
                              )
                             )
                            )
                            (i32.const 520192)
                           )
                           (i32.const 16)
                          )
                          (i32.const 4)
                         )
                        )
                        (local.get $2)
                       )
                       (local.tee $1
                        (i32.and
                         (i32.shr_u
                          (i32.add
                           (local.tee $3
                            (i32.shl
                             (local.get $3)
                             (local.get $1)
                            )
                           )
                           (i32.const 245760)
                          )
                          (i32.const 16)
                         )
                         (i32.const 2)
                        )
                       )
                      )
                     )
                     (i32.shr_u
                      (i32.shl
                       (local.get $3)
                       (local.get $1)
                      )
                      (i32.const 15)
                     )
                    )
                   )
                   (i32.const 7)
                  )
                 )
                 (i32.const 1)
                )
                (i32.shl
                 (local.get $1)
                 (i32.const 1)
                )
               )
              )
              (i32.const 0)
             )
            )
            (i32.const 2)
           )
           (i32.const 480)
          )
         )
         (i32.store offset=28
          (local.get $6)
          (local.get $4)
         )
         (i32.store offset=20
          (local.get $6)
          (i32.const 0)
         )
         (i32.store
          (local.get $10)
          (i32.const 0)
         )
         (if
          (i32.eqz
           (i32.and
            (local.tee $3
             (i32.load
              (i32.const 180)
             )
            )
            (local.tee $1
             (i32.shl
              (i32.const 1)
              (local.get $4)
             )
            )
           )
          )
          (block
           (i32.store
            (i32.const 180)
            (i32.or
             (local.get $3)
             (local.get $1)
            )
           )
           (i32.store
            (local.get $2)
            (local.get $6)
           )
           (i32.store offset=24
            (local.get $6)
            (local.get $2)
           )
           (i32.store offset=12
            (local.get $6)
            (local.get $6)
           )
           (i32.store offset=8
            (local.get $6)
            (local.get $6)
           )
           (br $do-once40)
          )
         )
         (local.set $4
          (i32.shl
           (local.get $5)
           (select
            (i32.const 0)
            (i32.sub
             (i32.const 25)
             (i32.shr_u
              (local.get $4)
              (i32.const 1)
             )
            )
            (i32.eq
             (local.get $4)
             (i32.const 31)
            )
           )
          )
         )
         (local.set $1
          (i32.load
           (local.get $2)
          )
         )
         (block $__rjto$9
          (block $__rjti$9
           (loop $while-in74
            (br_if $__rjti$9
             (i32.eq
              (i32.and
               (i32.load offset=4
                (local.get $1)
               )
               (i32.const -8)
              )
              (local.get $5)
             )
            )
            (local.set $2
             (i32.shl
              (local.get $4)
              (i32.const 1)
             )
            )
            (if
             (local.tee $3
              (i32.load
               (local.tee $4
                (i32.add
                 (i32.add
                  (local.get $1)
                  (i32.const 16)
                 )
                 (i32.shl
                  (i32.shr_u
                   (local.get $4)
                   (i32.const 31)
                  )
                  (i32.const 2)
                 )
                )
               )
              )
             )
             (block
              (local.set $4
               (local.get $2)
              )
              (local.set $1
               (local.get $3)
              )
              (br $while-in74)
             )
            )
           )
           (if
            (i32.lt_u
             (local.get $4)
             (i32.load
              (i32.const 192)
             )
            )
            (call $_abort)
            (block
             (i32.store
              (local.get $4)
              (local.get $6)
             )
             (i32.store offset=24
              (local.get $6)
              (local.get $1)
             )
             (i32.store offset=12
              (local.get $6)
              (local.get $6)
             )
             (i32.store offset=8
              (local.get $6)
              (local.get $6)
             )
             (br $do-once40)
            )
           )
           (br $__rjto$9)
          )
          (if
           (i32.and
            (i32.ge_u
             (local.tee $4
              (i32.load
               (local.tee $2
                (i32.add
                 (local.get $1)
                 (i32.const 8)
                )
               )
              )
             )
             (local.tee $3
              (i32.load
               (i32.const 192)
              )
             )
            )
            (i32.ge_u
             (local.get $1)
             (local.get $3)
            )
           )
           (block
            (i32.store offset=12
             (local.get $4)
             (local.get $6)
            )
            (i32.store
             (local.get $2)
             (local.get $6)
            )
            (i32.store offset=8
             (local.get $6)
             (local.get $4)
            )
            (i32.store offset=12
             (local.get $6)
             (local.get $1)
            )
            (i32.store offset=24
             (local.get $6)
             (i32.const 0)
            )
           )
           (call $_abort)
          )
         )
        )
       )
      )
      (block
       (if
        (i32.or
         (i32.eqz
          (local.tee $2
           (i32.load
            (i32.const 192)
           )
          )
         )
         (i32.lt_u
          (local.get $1)
          (local.get $2)
         )
        )
        (i32.store
         (i32.const 192)
         (local.get $1)
        )
       )
       (i32.store
        (i32.const 624)
        (local.get $1)
       )
       (i32.store
        (i32.const 628)
        (local.get $3)
       )
       (i32.store
        (i32.const 636)
        (i32.const 0)
       )
       (i32.store
        (i32.const 212)
        (i32.load
         (i32.const 648)
        )
       )
       (i32.store
        (i32.const 208)
        (i32.const -1)
       )
       (local.set $2
        (i32.const 0)
       )
       (loop $while-in43
        (i32.store offset=12
         (local.tee $4
          (i32.add
           (i32.shl
            (local.get $2)
            (i32.const 3)
           )
           (i32.const 216)
          )
         )
         (local.get $4)
        )
        (i32.store offset=8
         (local.get $4)
         (local.get $4)
        )
        (br_if $while-in43
         (i32.ne
          (local.tee $2
           (i32.add
            (local.get $2)
            (i32.const 1)
           )
          )
          (i32.const 32)
         )
        )
       )
       (i32.store
        (i32.const 200)
        (local.tee $2
         (i32.add
          (local.get $1)
          (local.tee $1
           (select
            (i32.and
             (i32.sub
              (i32.const 0)
              (local.tee $1
               (i32.add
                (local.get $1)
                (i32.const 8)
               )
              )
             )
             (i32.const 7)
            )
            (i32.const 0)
            (i32.and
             (local.get $1)
             (i32.const 7)
            )
           )
          )
         )
        )
       )
       (i32.store
        (i32.const 188)
        (local.tee $1
         (i32.sub
          (i32.add
           (local.get $3)
           (i32.const -40)
          )
          (local.get $1)
         )
        )
       )
       (i32.store offset=4
        (local.get $2)
        (i32.or
         (local.get $1)
         (i32.const 1)
        )
       )
       (i32.store offset=4
        (i32.add
         (local.get $2)
         (local.get $1)
        )
        (i32.const 40)
       )
       (i32.store
        (i32.const 204)
        (i32.load
         (i32.const 664)
        )
       )
      )
     )
    )
    (br_if $folding-inner0
     (i32.gt_u
      (local.tee $1
       (i32.load
        (i32.const 188)
       )
      )
      (local.get $0)
     )
    )
   )
   (i32.store
    (call $___errno_location)
    (i32.const 12)
   )
   (return
    (i32.const 0)
   )
  )
  (i32.store
   (i32.const 188)
   (local.tee $3
    (i32.sub
     (local.get $1)
     (local.get $0)
    )
   )
  )
  (i32.store
   (i32.const 200)
   (local.tee $1
    (i32.add
     (local.tee $2
      (i32.load
       (i32.const 200)
      )
     )
     (local.get $0)
    )
   )
  )
  (i32.store offset=4
   (local.get $1)
   (i32.or
    (local.get $3)
    (i32.const 1)
   )
  )
  (i32.store offset=4
   (local.get $2)
   (i32.or
    (local.get $0)
    (i32.const 3)
   )
  )
  (i32.add
   (local.get $2)
   (i32.const 8)
  )
 )
 (func $_free (param $0 i32)
  (local $1 i32)
  (local $2 i32)
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
  (local $15 i32)
  (if
   (i32.eqz
    (local.get $0)
   )
   (return)
  )
  (if
   (i32.lt_u
    (local.tee $1
     (i32.add
      (local.get $0)
      (i32.const -8)
     )
    )
    (local.tee $11
     (i32.load
      (i32.const 192)
     )
    )
   )
   (call $_abort)
  )
  (if
   (i32.eq
    (local.tee $5
     (i32.and
      (local.tee $7
       (i32.load
        (i32.add
         (local.get $0)
         (i32.const -4)
        )
       )
      )
      (i32.const 3)
     )
    )
    (i32.const 1)
   )
   (call $_abort)
  )
  (local.set $8
   (i32.add
    (local.get $1)
    (local.tee $0
     (i32.and
      (local.get $7)
      (i32.const -8)
     )
    )
   )
  )
  (block $do-once
   (if
    (i32.and
     (local.get $7)
     (i32.const 1)
    )
    (block
     (local.set $2
      (local.get $1)
     )
     (local.set $3
      (local.get $0)
     )
    )
    (block
     (local.set $7
      (i32.load
       (local.get $1)
      )
     )
     (if
      (i32.eqz
       (local.get $5)
      )
      (return)
     )
     (if
      (i32.lt_u
       (local.tee $1
        (i32.add
         (local.get $1)
         (i32.sub
          (i32.const 0)
          (local.get $7)
         )
        )
       )
       (local.get $11)
      )
      (call $_abort)
     )
     (local.set $0
      (i32.add
       (local.get $7)
       (local.get $0)
      )
     )
     (if
      (i32.eq
       (local.get $1)
       (i32.load
        (i32.const 196)
       )
      )
      (block
       (if
        (i32.ne
         (i32.and
          (local.tee $3
           (i32.load
            (local.tee $2
             (i32.add
              (local.get $8)
              (i32.const 4)
             )
            )
           )
          )
          (i32.const 3)
         )
         (i32.const 3)
        )
        (block
         (local.set $2
          (local.get $1)
         )
         (local.set $3
          (local.get $0)
         )
         (br $do-once)
        )
       )
       (i32.store
        (i32.const 184)
        (local.get $0)
       )
       (i32.store
        (local.get $2)
        (i32.and
         (local.get $3)
         (i32.const -2)
        )
       )
       (i32.store offset=4
        (local.get $1)
        (i32.or
         (local.get $0)
         (i32.const 1)
        )
       )
       (i32.store
        (i32.add
         (local.get $1)
         (local.get $0)
        )
        (local.get $0)
       )
       (return)
      )
     )
     (local.set $5
      (i32.shr_u
       (local.get $7)
       (i32.const 3)
      )
     )
     (if
      (i32.lt_u
       (local.get $7)
       (i32.const 256)
      )
      (block
       (local.set $6
        (i32.load offset=12
         (local.get $1)
        )
       )
       (if
        (i32.ne
         (local.tee $2
          (i32.load offset=8
           (local.get $1)
          )
         )
         (local.tee $3
          (i32.add
           (i32.shl
            (local.get $5)
            (i32.const 3)
           )
           (i32.const 216)
          )
         )
        )
        (block
         (if
          (i32.lt_u
           (local.get $2)
           (local.get $11)
          )
          (call $_abort)
         )
         (if
          (i32.ne
           (i32.load offset=12
            (local.get $2)
           )
           (local.get $1)
          )
          (call $_abort)
         )
        )
       )
       (if
        (i32.eq
         (local.get $6)
         (local.get $2)
        )
        (block
         (i32.store
          (i32.const 176)
          (i32.and
           (i32.load
            (i32.const 176)
           )
           (i32.xor
            (i32.shl
             (i32.const 1)
             (local.get $5)
            )
            (i32.const -1)
           )
          )
         )
         (local.set $2
          (local.get $1)
         )
         (local.set $3
          (local.get $0)
         )
         (br $do-once)
        )
       )
       (if
        (i32.eq
         (local.get $6)
         (local.get $3)
        )
        (local.set $4
         (i32.add
          (local.get $6)
          (i32.const 8)
         )
        )
        (block
         (if
          (i32.lt_u
           (local.get $6)
           (local.get $11)
          )
          (call $_abort)
         )
         (if
          (i32.eq
           (i32.load
            (local.tee $3
             (i32.add
              (local.get $6)
              (i32.const 8)
             )
            )
           )
           (local.get $1)
          )
          (local.set $4
           (local.get $3)
          )
          (call $_abort)
         )
        )
       )
       (i32.store offset=12
        (local.get $2)
        (local.get $6)
       )
       (i32.store
        (local.get $4)
        (local.get $2)
       )
       (local.set $2
        (local.get $1)
       )
       (local.set $3
        (local.get $0)
       )
       (br $do-once)
      )
     )
     (local.set $12
      (i32.load offset=24
       (local.get $1)
      )
     )
     (block $do-once0
      (if
       (i32.eq
        (local.tee $4
         (i32.load offset=12
          (local.get $1)
         )
        )
        (local.get $1)
       )
       (block
        (if
         (i32.eqz
          (local.tee $5
           (i32.load
            (local.tee $4
             (i32.add
              (local.tee $7
               (i32.add
                (local.get $1)
                (i32.const 16)
               )
              )
              (i32.const 4)
             )
            )
           )
          )
         )
         (if
          (local.tee $5
           (i32.load
            (local.get $7)
           )
          )
          (local.set $4
           (local.get $7)
          )
          (block
           (local.set $6
            (i32.const 0)
           )
           (br $do-once0)
          )
         )
        )
        (loop $while-in
         (if
          (local.tee $7
           (i32.load
            (local.tee $10
             (i32.add
              (local.get $5)
              (i32.const 20)
             )
            )
           )
          )
          (block
           (local.set $5
            (local.get $7)
           )
           (local.set $4
            (local.get $10)
           )
           (br $while-in)
          )
         )
         (if
          (local.tee $7
           (i32.load
            (local.tee $10
             (i32.add
              (local.get $5)
              (i32.const 16)
             )
            )
           )
          )
          (block
           (local.set $5
            (local.get $7)
           )
           (local.set $4
            (local.get $10)
           )
           (br $while-in)
          )
         )
        )
        (if
         (i32.lt_u
          (local.get $4)
          (local.get $11)
         )
         (call $_abort)
         (block
          (i32.store
           (local.get $4)
           (i32.const 0)
          )
          (local.set $6
           (local.get $5)
          )
         )
        )
       )
       (block
        (if
         (i32.lt_u
          (local.tee $10
           (i32.load offset=8
            (local.get $1)
           )
          )
          (local.get $11)
         )
         (call $_abort)
        )
        (if
         (i32.ne
          (i32.load
           (local.tee $7
            (i32.add
             (local.get $10)
             (i32.const 12)
            )
           )
          )
          (local.get $1)
         )
         (call $_abort)
        )
        (if
         (i32.eq
          (i32.load
           (local.tee $5
            (i32.add
             (local.get $4)
             (i32.const 8)
            )
           )
          )
          (local.get $1)
         )
         (block
          (i32.store
           (local.get $7)
           (local.get $4)
          )
          (i32.store
           (local.get $5)
           (local.get $10)
          )
          (local.set $6
           (local.get $4)
          )
         )
         (call $_abort)
        )
       )
      )
     )
     (if
      (local.get $12)
      (block
       (if
        (i32.eq
         (local.get $1)
         (i32.load
          (local.tee $4
           (i32.add
            (i32.shl
             (local.tee $5
              (i32.load offset=28
               (local.get $1)
              )
             )
             (i32.const 2)
            )
            (i32.const 480)
           )
          )
         )
        )
        (block
         (i32.store
          (local.get $4)
          (local.get $6)
         )
         (if
          (i32.eqz
           (local.get $6)
          )
          (block
           (i32.store
            (i32.const 180)
            (i32.and
             (i32.load
              (i32.const 180)
             )
             (i32.xor
              (i32.shl
               (i32.const 1)
               (local.get $5)
              )
              (i32.const -1)
             )
            )
           )
           (local.set $2
            (local.get $1)
           )
           (local.set $3
            (local.get $0)
           )
           (br $do-once)
          )
         )
        )
        (block
         (if
          (i32.lt_u
           (local.get $12)
           (i32.load
            (i32.const 192)
           )
          )
          (call $_abort)
         )
         (if
          (i32.eq
           (i32.load
            (local.tee $4
             (i32.add
              (local.get $12)
              (i32.const 16)
             )
            )
           )
           (local.get $1)
          )
          (i32.store
           (local.get $4)
           (local.get $6)
          )
          (i32.store offset=20
           (local.get $12)
           (local.get $6)
          )
         )
         (if
          (i32.eqz
           (local.get $6)
          )
          (block
           (local.set $2
            (local.get $1)
           )
           (local.set $3
            (local.get $0)
           )
           (br $do-once)
          )
         )
        )
       )
       (if
        (i32.lt_u
         (local.get $6)
         (local.tee $5
          (i32.load
           (i32.const 192)
          )
         )
        )
        (call $_abort)
       )
       (i32.store offset=24
        (local.get $6)
        (local.get $12)
       )
       (if
        (local.tee $7
         (i32.load
          (local.tee $4
           (i32.add
            (local.get $1)
            (i32.const 16)
           )
          )
         )
        )
        (if
         (i32.lt_u
          (local.get $7)
          (local.get $5)
         )
         (call $_abort)
         (block
          (i32.store offset=16
           (local.get $6)
           (local.get $7)
          )
          (i32.store offset=24
           (local.get $7)
           (local.get $6)
          )
         )
        )
       )
       (if
        (local.tee $4
         (i32.load offset=4
          (local.get $4)
         )
        )
        (if
         (i32.lt_u
          (local.get $4)
          (i32.load
           (i32.const 192)
          )
         )
         (call $_abort)
         (block
          (i32.store offset=20
           (local.get $6)
           (local.get $4)
          )
          (i32.store offset=24
           (local.get $4)
           (local.get $6)
          )
          (local.set $2
           (local.get $1)
          )
          (local.set $3
           (local.get $0)
          )
         )
        )
        (block
         (local.set $2
          (local.get $1)
         )
         (local.set $3
          (local.get $0)
         )
        )
       )
      )
      (block
       (local.set $2
        (local.get $1)
       )
       (local.set $3
        (local.get $0)
       )
      )
     )
    )
   )
  )
  (if
   (i32.ge_u
    (local.get $2)
    (local.get $8)
   )
   (call $_abort)
  )
  (if
   (i32.eqz
    (i32.and
     (local.tee $1
      (i32.load
       (local.tee $0
        (i32.add
         (local.get $8)
         (i32.const 4)
        )
       )
      )
     )
     (i32.const 1)
    )
   )
   (call $_abort)
  )
  (if
   (i32.and
    (local.get $1)
    (i32.const 2)
   )
   (block
    (i32.store
     (local.get $0)
     (i32.and
      (local.get $1)
      (i32.const -2)
     )
    )
    (i32.store offset=4
     (local.get $2)
     (i32.or
      (local.get $3)
      (i32.const 1)
     )
    )
    (i32.store
     (i32.add
      (local.get $2)
      (local.get $3)
     )
     (local.get $3)
    )
   )
   (block
    (if
     (i32.eq
      (local.get $8)
      (i32.load
       (i32.const 200)
      )
     )
     (block
      (i32.store
       (i32.const 188)
       (local.tee $0
        (i32.add
         (i32.load
          (i32.const 188)
         )
         (local.get $3)
        )
       )
      )
      (i32.store
       (i32.const 200)
       (local.get $2)
      )
      (i32.store offset=4
       (local.get $2)
       (i32.or
        (local.get $0)
        (i32.const 1)
       )
      )
      (if
       (i32.ne
        (local.get $2)
        (i32.load
         (i32.const 196)
        )
       )
       (return)
      )
      (i32.store
       (i32.const 196)
       (i32.const 0)
      )
      (i32.store
       (i32.const 184)
       (i32.const 0)
      )
      (return)
     )
    )
    (if
     (i32.eq
      (local.get $8)
      (i32.load
       (i32.const 196)
      )
     )
     (block
      (i32.store
       (i32.const 184)
       (local.tee $0
        (i32.add
         (i32.load
          (i32.const 184)
         )
         (local.get $3)
        )
       )
      )
      (i32.store
       (i32.const 196)
       (local.get $2)
      )
      (i32.store offset=4
       (local.get $2)
       (i32.or
        (local.get $0)
        (i32.const 1)
       )
      )
      (i32.store
       (i32.add
        (local.get $2)
        (local.get $0)
       )
       (local.get $0)
      )
      (return)
     )
    )
    (local.set $5
     (i32.add
      (i32.and
       (local.get $1)
       (i32.const -8)
      )
      (local.get $3)
     )
    )
    (local.set $3
     (i32.shr_u
      (local.get $1)
      (i32.const 3)
     )
    )
    (block $do-once4
     (if
      (i32.lt_u
       (local.get $1)
       (i32.const 256)
      )
      (block
       (local.set $4
        (i32.load offset=12
         (local.get $8)
        )
       )
       (if
        (i32.ne
         (local.tee $1
          (i32.load offset=8
           (local.get $8)
          )
         )
         (local.tee $0
          (i32.add
           (i32.shl
            (local.get $3)
            (i32.const 3)
           )
           (i32.const 216)
          )
         )
        )
        (block
         (if
          (i32.lt_u
           (local.get $1)
           (i32.load
            (i32.const 192)
           )
          )
          (call $_abort)
         )
         (if
          (i32.ne
           (i32.load offset=12
            (local.get $1)
           )
           (local.get $8)
          )
          (call $_abort)
         )
        )
       )
       (if
        (i32.eq
         (local.get $4)
         (local.get $1)
        )
        (block
         (i32.store
          (i32.const 176)
          (i32.and
           (i32.load
            (i32.const 176)
           )
           (i32.xor
            (i32.shl
             (i32.const 1)
             (local.get $3)
            )
            (i32.const -1)
           )
          )
         )
         (br $do-once4)
        )
       )
       (if
        (i32.eq
         (local.get $4)
         (local.get $0)
        )
        (local.set $14
         (i32.add
          (local.get $4)
          (i32.const 8)
         )
        )
        (block
         (if
          (i32.lt_u
           (local.get $4)
           (i32.load
            (i32.const 192)
           )
          )
          (call $_abort)
         )
         (if
          (i32.eq
           (i32.load
            (local.tee $0
             (i32.add
              (local.get $4)
              (i32.const 8)
             )
            )
           )
           (local.get $8)
          )
          (local.set $14
           (local.get $0)
          )
          (call $_abort)
         )
        )
       )
       (i32.store offset=12
        (local.get $1)
        (local.get $4)
       )
       (i32.store
        (local.get $14)
        (local.get $1)
       )
      )
      (block
       (local.set $6
        (i32.load offset=24
         (local.get $8)
        )
       )
       (block $do-once6
        (if
         (i32.eq
          (local.tee $0
           (i32.load offset=12
            (local.get $8)
           )
          )
          (local.get $8)
         )
         (block
          (if
           (i32.eqz
            (local.tee $3
             (i32.load
              (local.tee $0
               (i32.add
                (local.tee $1
                 (i32.add
                  (local.get $8)
                  (i32.const 16)
                 )
                )
                (i32.const 4)
               )
              )
             )
            )
           )
           (if
            (local.tee $3
             (i32.load
              (local.get $1)
             )
            )
            (local.set $0
             (local.get $1)
            )
            (block
             (local.set $9
              (i32.const 0)
             )
             (br $do-once6)
            )
           )
          )
          (loop $while-in9
           (if
            (local.tee $1
             (i32.load
              (local.tee $4
               (i32.add
                (local.get $3)
                (i32.const 20)
               )
              )
             )
            )
            (block
             (local.set $3
              (local.get $1)
             )
             (local.set $0
              (local.get $4)
             )
             (br $while-in9)
            )
           )
           (if
            (local.tee $1
             (i32.load
              (local.tee $4
               (i32.add
                (local.get $3)
                (i32.const 16)
               )
              )
             )
            )
            (block
             (local.set $3
              (local.get $1)
             )
             (local.set $0
              (local.get $4)
             )
             (br $while-in9)
            )
           )
          )
          (if
           (i32.lt_u
            (local.get $0)
            (i32.load
             (i32.const 192)
            )
           )
           (call $_abort)
           (block
            (i32.store
             (local.get $0)
             (i32.const 0)
            )
            (local.set $9
             (local.get $3)
            )
           )
          )
         )
         (block
          (if
           (i32.lt_u
            (local.tee $4
             (i32.load offset=8
              (local.get $8)
             )
            )
            (i32.load
             (i32.const 192)
            )
           )
           (call $_abort)
          )
          (if
           (i32.ne
            (i32.load
             (local.tee $1
              (i32.add
               (local.get $4)
               (i32.const 12)
              )
             )
            )
            (local.get $8)
           )
           (call $_abort)
          )
          (if
           (i32.eq
            (i32.load
             (local.tee $3
              (i32.add
               (local.get $0)
               (i32.const 8)
              )
             )
            )
            (local.get $8)
           )
           (block
            (i32.store
             (local.get $1)
             (local.get $0)
            )
            (i32.store
             (local.get $3)
             (local.get $4)
            )
            (local.set $9
             (local.get $0)
            )
           )
           (call $_abort)
          )
         )
        )
       )
       (if
        (local.get $6)
        (block
         (if
          (i32.eq
           (local.get $8)
           (i32.load
            (local.tee $0
             (i32.add
              (i32.shl
               (local.tee $3
                (i32.load offset=28
                 (local.get $8)
                )
               )
               (i32.const 2)
              )
              (i32.const 480)
             )
            )
           )
          )
          (block
           (i32.store
            (local.get $0)
            (local.get $9)
           )
           (if
            (i32.eqz
             (local.get $9)
            )
            (block
             (i32.store
              (i32.const 180)
              (i32.and
               (i32.load
                (i32.const 180)
               )
               (i32.xor
                (i32.shl
                 (i32.const 1)
                 (local.get $3)
                )
                (i32.const -1)
               )
              )
             )
             (br $do-once4)
            )
           )
          )
          (block
           (if
            (i32.lt_u
             (local.get $6)
             (i32.load
              (i32.const 192)
             )
            )
            (call $_abort)
           )
           (if
            (i32.eq
             (i32.load
              (local.tee $0
               (i32.add
                (local.get $6)
                (i32.const 16)
               )
              )
             )
             (local.get $8)
            )
            (i32.store
             (local.get $0)
             (local.get $9)
            )
            (i32.store offset=20
             (local.get $6)
             (local.get $9)
            )
           )
           (br_if $do-once4
            (i32.eqz
             (local.get $9)
            )
           )
          )
         )
         (if
          (i32.lt_u
           (local.get $9)
           (local.tee $3
            (i32.load
             (i32.const 192)
            )
           )
          )
          (call $_abort)
         )
         (i32.store offset=24
          (local.get $9)
          (local.get $6)
         )
         (if
          (local.tee $1
           (i32.load
            (local.tee $0
             (i32.add
              (local.get $8)
              (i32.const 16)
             )
            )
           )
          )
          (if
           (i32.lt_u
            (local.get $1)
            (local.get $3)
           )
           (call $_abort)
           (block
            (i32.store offset=16
             (local.get $9)
             (local.get $1)
            )
            (i32.store offset=24
             (local.get $1)
             (local.get $9)
            )
           )
          )
         )
         (if
          (local.tee $0
           (i32.load offset=4
            (local.get $0)
           )
          )
          (if
           (i32.lt_u
            (local.get $0)
            (i32.load
             (i32.const 192)
            )
           )
           (call $_abort)
           (block
            (i32.store offset=20
             (local.get $9)
             (local.get $0)
            )
            (i32.store offset=24
             (local.get $0)
             (local.get $9)
            )
           )
          )
         )
        )
       )
      )
     )
    )
    (i32.store offset=4
     (local.get $2)
     (i32.or
      (local.get $5)
      (i32.const 1)
     )
    )
    (i32.store
     (i32.add
      (local.get $2)
      (local.get $5)
     )
     (local.get $5)
    )
    (if
     (i32.eq
      (local.get $2)
      (i32.load
       (i32.const 196)
      )
     )
     (block
      (i32.store
       (i32.const 184)
       (local.get $5)
      )
      (return)
     )
     (local.set $3
      (local.get $5)
     )
    )
   )
  )
  (local.set $0
   (i32.shr_u
    (local.get $3)
    (i32.const 3)
   )
  )
  (if
   (i32.lt_u
    (local.get $3)
    (i32.const 256)
   )
   (block
    (local.set $1
     (i32.add
      (i32.shl
       (local.get $0)
       (i32.const 3)
      )
      (i32.const 216)
     )
    )
    (if
     (i32.and
      (local.tee $3
       (i32.load
        (i32.const 176)
       )
      )
      (local.tee $0
       (i32.shl
        (i32.const 1)
        (local.get $0)
       )
      )
     )
     (if
      (i32.lt_u
       (local.tee $0
        (i32.load
         (local.tee $3
          (i32.add
           (local.get $1)
           (i32.const 8)
          )
         )
        )
       )
       (i32.load
        (i32.const 192)
       )
      )
      (call $_abort)
      (block
       (local.set $15
        (local.get $3)
       )
       (local.set $13
        (local.get $0)
       )
      )
     )
     (block
      (i32.store
       (i32.const 176)
       (i32.or
        (local.get $3)
        (local.get $0)
       )
      )
      (local.set $15
       (i32.add
        (local.get $1)
        (i32.const 8)
       )
      )
      (local.set $13
       (local.get $1)
      )
     )
    )
    (i32.store
     (local.get $15)
     (local.get $2)
    )
    (i32.store offset=12
     (local.get $13)
     (local.get $2)
    )
    (i32.store offset=8
     (local.get $2)
     (local.get $13)
    )
    (i32.store offset=12
     (local.get $2)
     (local.get $1)
    )
    (return)
   )
  )
  (local.set $4
   (i32.add
    (i32.shl
     (local.tee $5
      (if (result i32)
       (local.tee $0
        (i32.shr_u
         (local.get $3)
         (i32.const 8)
        )
       )
       (if (result i32)
        (i32.gt_u
         (local.get $3)
         (i32.const 16777215)
        )
        (i32.const 31)
        (i32.or
         (i32.and
          (i32.shr_u
           (local.get $3)
           (i32.add
            (local.tee $0
             (i32.add
              (i32.sub
               (i32.const 14)
               (i32.or
                (i32.or
                 (local.tee $0
                  (i32.and
                   (i32.shr_u
                    (i32.add
                     (local.tee $1
                      (i32.shl
                       (local.get $0)
                       (local.tee $4
                        (i32.and
                         (i32.shr_u
                          (i32.add
                           (local.get $0)
                           (i32.const 1048320)
                          )
                          (i32.const 16)
                         )
                         (i32.const 8)
                        )
                       )
                      )
                     )
                     (i32.const 520192)
                    )
                    (i32.const 16)
                   )
                   (i32.const 4)
                  )
                 )
                 (local.get $4)
                )
                (local.tee $0
                 (i32.and
                  (i32.shr_u
                   (i32.add
                    (local.tee $1
                     (i32.shl
                      (local.get $1)
                      (local.get $0)
                     )
                    )
                    (i32.const 245760)
                   )
                   (i32.const 16)
                  )
                  (i32.const 2)
                 )
                )
               )
              )
              (i32.shr_u
               (i32.shl
                (local.get $1)
                (local.get $0)
               )
               (i32.const 15)
              )
             )
            )
            (i32.const 7)
           )
          )
          (i32.const 1)
         )
         (i32.shl
          (local.get $0)
          (i32.const 1)
         )
        )
       )
       (i32.const 0)
      )
     )
     (i32.const 2)
    )
    (i32.const 480)
   )
  )
  (i32.store offset=28
   (local.get $2)
   (local.get $5)
  )
  (i32.store offset=20
   (local.get $2)
   (i32.const 0)
  )
  (i32.store offset=16
   (local.get $2)
   (i32.const 0)
  )
  (block $do-once12
   (if
    (i32.and
     (local.tee $1
      (i32.load
       (i32.const 180)
      )
     )
     (local.tee $0
      (i32.shl
       (i32.const 1)
       (local.get $5)
      )
     )
    )
    (block
     (local.set $5
      (i32.shl
       (local.get $3)
       (select
        (i32.const 0)
        (i32.sub
         (i32.const 25)
         (i32.shr_u
          (local.get $5)
          (i32.const 1)
         )
        )
        (i32.eq
         (local.get $5)
         (i32.const 31)
        )
       )
      )
     )
     (local.set $0
      (i32.load
       (local.get $4)
      )
     )
     (block $__rjto$1
      (block $__rjti$1
       (loop $while-in15
        (br_if $__rjti$1
         (i32.eq
          (i32.and
           (i32.load offset=4
            (local.get $0)
           )
           (i32.const -8)
          )
          (local.get $3)
         )
        )
        (local.set $4
         (i32.shl
          (local.get $5)
          (i32.const 1)
         )
        )
        (if
         (local.tee $1
          (i32.load
           (local.tee $5
            (i32.add
             (i32.add
              (local.get $0)
              (i32.const 16)
             )
             (i32.shl
              (i32.shr_u
               (local.get $5)
               (i32.const 31)
              )
              (i32.const 2)
             )
            )
           )
          )
         )
         (block
          (local.set $5
           (local.get $4)
          )
          (local.set $0
           (local.get $1)
          )
          (br $while-in15)
         )
        )
       )
       (if
        (i32.lt_u
         (local.get $5)
         (i32.load
          (i32.const 192)
         )
        )
        (call $_abort)
        (block
         (i32.store
          (local.get $5)
          (local.get $2)
         )
         (i32.store offset=24
          (local.get $2)
          (local.get $0)
         )
         (i32.store offset=12
          (local.get $2)
          (local.get $2)
         )
         (i32.store offset=8
          (local.get $2)
          (local.get $2)
         )
         (br $do-once12)
        )
       )
       (br $__rjto$1)
      )
      (if
       (i32.and
        (i32.ge_u
         (local.tee $4
          (i32.load
           (local.tee $1
            (i32.add
             (local.get $0)
             (i32.const 8)
            )
           )
          )
         )
         (local.tee $3
          (i32.load
           (i32.const 192)
          )
         )
        )
        (i32.ge_u
         (local.get $0)
         (local.get $3)
        )
       )
       (block
        (i32.store offset=12
         (local.get $4)
         (local.get $2)
        )
        (i32.store
         (local.get $1)
         (local.get $2)
        )
        (i32.store offset=8
         (local.get $2)
         (local.get $4)
        )
        (i32.store offset=12
         (local.get $2)
         (local.get $0)
        )
        (i32.store offset=24
         (local.get $2)
         (i32.const 0)
        )
       )
       (call $_abort)
      )
     )
    )
    (block
     (i32.store
      (i32.const 180)
      (i32.or
       (local.get $1)
       (local.get $0)
      )
     )
     (i32.store
      (local.get $4)
      (local.get $2)
     )
     (i32.store offset=24
      (local.get $2)
      (local.get $4)
     )
     (i32.store offset=12
      (local.get $2)
      (local.get $2)
     )
     (i32.store offset=8
      (local.get $2)
      (local.get $2)
     )
    )
   )
  )
  (i32.store
   (i32.const 208)
   (local.tee $0
    (i32.add
     (i32.load
      (i32.const 208)
     )
     (i32.const -1)
    )
   )
  )
  (if
   (local.get $0)
   (return)
   (local.set $0
    (i32.const 632)
   )
  )
  (loop $while-in17
   (local.set $0
    (i32.add
     (local.tee $3
      (i32.load
       (local.get $0)
      )
     )
     (i32.const 8)
    )
   )
   (br_if $while-in17
    (local.get $3)
   )
  )
  (i32.store
   (i32.const 208)
   (i32.const -1)
  )
 )
 (func $runPostSets
  (nop)
 )
 (func $_i64Subtract (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (result i32)
  (global.set $tempRet0
   (i32.sub
    (i32.sub
     (local.get $1)
     (local.get $3)
    )
    (i32.gt_u
     (local.get $2)
     (local.get $0)
    )
   )
  )
  (i32.sub
   (local.get $0)
   (local.get $2)
  )
 )
 (func $_i64Add (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (result i32)
  (local $4 i32)
  (global.set $tempRet0
   (i32.add
    (i32.add
     (local.get $1)
     (local.get $3)
    )
    (i32.lt_u
     (local.tee $4
      (i32.add
       (local.get $0)
       (local.get $2)
      )
     )
     (local.get $0)
    )
   )
  )
  (local.get $4)
 )
 (func $_memset (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
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
    (local.set $1
     (i32.and
      (local.get $1)
      (i32.const 255)
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
    (local.set $3
     (i32.or
      (i32.or
       (i32.or
        (local.get $1)
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
    (local.set $5
     (i32.and
      (local.get $4)
      (i32.const -4)
     )
    )
    (loop $while-in1
     (if
      (i32.lt_s
       (local.get $0)
       (local.get $5)
      )
      (block
       (i32.store
        (local.get $0)
        (local.get $3)
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
 (func $_bitshift64Lshr (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (if
   (i32.lt_s
    (local.get $2)
    (i32.const 32)
   )
   (block
    (global.set $tempRet0
     (i32.shr_u
      (local.get $1)
      (local.get $2)
     )
    )
    (return
     (i32.or
      (i32.shr_u
       (local.get $0)
       (local.get $2)
      )
      (i32.shl
       (i32.and
        (local.get $1)
        (i32.sub
         (i32.shl
          (i32.const 1)
          (local.get $2)
         )
         (i32.const 1)
        )
       )
       (i32.sub
        (i32.const 32)
        (local.get $2)
       )
      )
     )
    )
   )
  )
  (global.set $tempRet0
   (i32.const 0)
  )
  (i32.shr_u
   (local.get $1)
   (i32.sub
    (local.get $2)
    (i32.const 32)
   )
  )
 )
 (func $_bitshift64Shl (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (if
   (i32.lt_s
    (local.get $2)
    (i32.const 32)
   )
   (block
    (global.set $tempRet0
     (i32.or
      (i32.shl
       (local.get $1)
       (local.get $2)
      )
      (i32.shr_u
       (i32.and
        (local.get $0)
        (i32.shl
         (i32.sub
          (i32.shl
           (i32.const 1)
           (local.get $2)
          )
          (i32.const 1)
         )
         (i32.sub
          (i32.const 32)
          (local.get $2)
         )
        )
       )
       (i32.sub
        (i32.const 32)
        (local.get $2)
       )
      )
     )
    )
    (return
     (i32.shl
      (local.get $0)
      (local.get $2)
     )
    )
   )
  )
  (global.set $tempRet0
   (i32.shl
    (local.get $0)
    (i32.sub
     (local.get $2)
     (i32.const 32)
    )
   )
  )
  (i32.const 0)
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
     (if
      (i32.and
       (local.get $0)
       (i32.const 3)
      )
      (block
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
 (func $___udivdi3 (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (result i32)
  (call $___udivmoddi4
   (local.get $0)
   (local.get $1)
   (local.get $2)
   (local.get $3)
   (i32.const 0)
  )
 )
 (func $___uremdi3 (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (result i32)
  (local $4 i32)
  (local.set $4
   (global.get $STACKTOP)
  )
  (global.set $STACKTOP
   (i32.add
    (global.get $STACKTOP)
    (i32.const 16)
   )
  )
  (drop
   (call $___udivmoddi4
    (local.get $0)
    (local.get $1)
    (local.get $2)
    (local.get $3)
    (local.tee $0
     (local.get $4)
    )
   )
  )
  (global.set $STACKTOP
   (local.get $4)
  )
  (global.set $tempRet0
   (i32.load offset=4
    (local.get $0)
   )
  )
  (i32.load
   (local.get $0)
  )
 )
 (func $___udivmoddi4 (param $xl i32) (param $xh i32) (param $yl i32) (param $yh i32) (param $r i32) (result i32)
  (local $x64 i64)
  (local $y64 i64)
  (local.set $x64
   (i64.or
    (i64.extend_i32_u
     (local.get $xl)
    )
    (i64.shl
     (i64.extend_i32_u
      (local.get $xh)
     )
     (i64.const 32)
    )
   )
  )
  (local.set $y64
   (i64.or
    (i64.extend_i32_u
     (local.get $yl)
    )
    (i64.shl
     (i64.extend_i32_u
      (local.get $yh)
     )
     (i64.const 32)
    )
   )
  )
  (if
   (local.get $r)
   (i64.store
    (local.get $r)
    (i64.rem_u
     (local.get $x64)
     (local.get $y64)
    )
   )
  )
  (local.set $x64
   (i64.div_u
    (local.get $x64)
    (local.get $y64)
   )
  )
  (global.set $tempRet0
   (i32.wrap_i64
    (i64.shr_u
     (local.get $x64)
     (i64.const 32)
    )
   )
  )
  (i32.wrap_i64
   (local.get $x64)
  )
 )
 (func $dynCall_ii (param $0 i32) (param $1 i32) (result i32)
  (call_indirect (type $FUNCSIG$ii)
   (local.get $1)
   (i32.and
    (local.get $0)
    (i32.const 1)
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
     (i32.const 7)
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
     (i32.const 7)
    )
    (i32.const 10)
   )
  )
 )
 (func $b0 (param $0 i32) (result i32)
  (call $nullFunc_ii
   (i32.const 0)
  )
  (i32.const 0)
 )
 (func $b1 (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (call $nullFunc_iiii
   (i32.const 1)
  )
  (i32.const 0)
 )
 (func $b2 (param $0 i32)
  (call $nullFunc_vi
   (i32.const 2)
  )
 )
)
