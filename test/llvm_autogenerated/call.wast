(module
 (type $FUNCSIG$v (func))
 (type $FUNCSIG$i (func (result i32)))
 (type $FUNCSIG$vi (func (param i32)))
 (type $FUNCSIG$iii (func (param i32 i32) (result i32)))
 (type $FUNCSIG$ii (func (param i32) (result i32)))
 (type $FUNCSIG$j (func (result i64)))
 (type $FUNCSIG$f (func (result f32)))
 (type $FUNCSIG$d (func (result f64)))
 (import "env" "double_nullary" (func $double_nullary (result f64)))
 (import "env" "float_nullary" (func $float_nullary (result f32)))
 (import "env" "i32_binary" (func $i32_binary (param i32 i32) (result i32)))
 (import "env" "i32_nullary" (func $i32_nullary (result i32)))
 (import "env" "i32_unary" (func $i32_unary (param i32) (result i32)))
 (import "env" "i64_nullary" (func $i64_nullary (result i64)))
 (import "env" "void_nullary" (func $void_nullary))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "call_i32_nullary" (func $call_i32_nullary))
 (export "call_i64_nullary" (func $call_i64_nullary))
 (export "call_float_nullary" (func $call_float_nullary))
 (export "call_double_nullary" (func $call_double_nullary))
 (export "call_void_nullary" (func $call_void_nullary))
 (export "call_i32_unary" (func $call_i32_unary))
 (export "call_i32_binary" (func $call_i32_binary))
 (export "call_indirect_void" (func $call_indirect_void))
 (export "call_indirect_i32" (func $call_indirect_i32))
 (export "call_indirect_arg" (func $call_indirect_arg))
 (export "call_indirect_arg_2" (func $call_indirect_arg_2))
 (export "tail_call_void_nullary" (func $tail_call_void_nullary))
 (export "fastcc_tail_call_void_nullary" (func $fastcc_tail_call_void_nullary))
 (export "coldcc_tail_call_void_nullary" (func $coldcc_tail_call_void_nullary))
 (func $call_i32_nullary (result i32) ;; 0
  (return
   (call $i32_nullary)
  )
 )
 (func $call_i64_nullary (result i64) ;; 1
  (return
   (call $i64_nullary)
  )
 )
 (func $call_float_nullary (result f32) ;; 2
  (return
   (call $float_nullary)
  )
 )
 (func $call_double_nullary (result f64) ;; 3
  (return
   (call $double_nullary)
  )
 )
 (func $call_void_nullary ;; 4
  (call $void_nullary)
  (return)
 )
 (func $call_i32_unary (param $0 i32) (result i32) ;; 5
  (return
   (call $i32_unary
    (get_local $0)
   )
  )
 )
 (func $call_i32_binary (param $0 i32) (param $1 i32) (result i32) ;; 6
  (return
   (call $i32_binary
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $call_indirect_void (param $0 i32) ;; 7
  (call_indirect $FUNCSIG$v
   (get_local $0)
  )
  (return)
 )
 (func $call_indirect_i32 (param $0 i32) (result i32) ;; 8
  (return
   (call_indirect $FUNCSIG$i
    (get_local $0)
   )
  )
 )
 (func $call_indirect_arg (param $0 i32) (param $1 i32) ;; 9
  (call_indirect $FUNCSIG$vi
   (get_local $1)
   (get_local $0)
  )
  (return)
 )
 (func $call_indirect_arg_2 (param $0 i32) (param $1 i32) (param $2 i32) ;; 10
  (drop
   (call_indirect $FUNCSIG$iii
    (get_local $1)
    (get_local $2)
    (get_local $0)
   )
  )
  (return)
 )
 (func $tail_call_void_nullary ;; 11
  (call $void_nullary)
  (return)
 )
 (func $fastcc_tail_call_void_nullary ;; 12
  (call $void_nullary)
  (return)
 )
 (func $coldcc_tail_call_void_nullary ;; 13
  (call $void_nullary)
  (return)
 )
 (func $stackSave (result i32) ;; 14
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (param $0 i32) (result i32) ;; 15
  (local $1 i32)
  (set_local $1
   (i32.load offset=4
    (i32.const 0)
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.and
    (i32.sub
     (get_local $1)
     (get_local $0)
    )
    (i32.const -16)
   )
  )
  (get_local $1)
 )
 (func $stackRestore (param $0 i32) ;; 16
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
