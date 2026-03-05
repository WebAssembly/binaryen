(module $em_asm_pthread.wasm
 (type $0 (func))
 (type $1 (func (param i32 i32 i32) (result i32)))
 (type $2 (func (result i32)))
 (type $3 (func (param i32 i32) (result i32)))
 (import "env" "memory" (memory $mimport$0 2 2 shared))
 (import "env" "emscripten_asm_const_int" (func $emscripten_asm_const_int (param i32 i32 i32) (result i32)))
 (import "env" "world" (func $world))
 (global $__stack_pointer (mut i32) (i32.const 66176))
 (global $__tls_base (mut i32) (i32.const 0))
 (global $global$2 i32 (i32.const 569))
 (global $global$3 i32 (i32.const 602))
 (global $global$4 i32 (i32.const 629))
 (data $.rodata "\00")
 (data $em_js "()<::>{ console.log(\"World.\"); }\00")
 (data $em_asm "{ console.log(\"Hello.\"); }\00")
 (table $0 1 1 funcref)
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "main" (func $main))
 (export "__em_js__world" (global $global$2))
 (export "__start_em_asm" (global $global$3))
 (export "__stop_em_asm" (global $global$4))
 (start $__wasm_init_memory)
 (func $__wasm_call_ctors
 )
 (func $__wasm_init_memory
  (block $block2
   (block $block1
    (block $block
     (br_table $block $block1 $block2
      (i32.atomic.rmw.cmpxchg
       (i32.const 632)
       (i32.const 0)
       (i32.const 1)
      )
     )
    )
    (memory.init $.rodata
     (i32.const 568)
     (i32.const 0)
     (i32.const 1)
    )
    (memory.init $em_js
     (i32.const 569)
     (i32.const 0)
     (i32.const 33)
    )
    (memory.init $em_asm
     (i32.const 602)
     (i32.const 0)
     (i32.const 27)
    )
    (i32.atomic.store
     (i32.const 632)
     (i32.const 2)
    )
    (drop
     (memory.atomic.notify
      (i32.const 632)
      (i32.const -1)
     )
    )
    (br $block2)
   )
   (drop
    (memory.atomic.wait32
     (i32.const 632)
     (i32.const 1)
     (i64.const -1)
    )
   )
  )
  (data.drop $.rodata)
  (data.drop $em_js)
  (data.drop $em_asm)
 )
 (func $__original_main (result i32)
  (drop
   (call $emscripten_asm_const_int
    (i32.const 602)
    (i32.const 568)
    (i32.const 0)
   )
  )
  (call $world)
  (i32.const 0)
 )
 (func $main (param $0 i32) (param $1 i32) (result i32)
  (call $__original_main)
 )
 ;; custom section "producers", size 115
 ;; features section: threads, mutable-globals, nontrapping-float-to-int, bulk-memory, sign-ext, reference-types, multivalue, bulk-memory-opt, call-indirect-overlong
)

