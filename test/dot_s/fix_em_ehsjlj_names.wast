(module
 (type $FUNCSIG$vi (func (param i32)))
 (type $FUNCSIG$iiiii (func (param i32 i32 i32 i32) (result i32)))
 (type $FUNCSIG$fifd (func (param i32 f32 f64) (result f32)))
 (type $FUNCSIG$iiii (func (param i32 i32 i32) (result i32)))
 (type $FUNCSIG$vii (func (param i32 i32)))
 (type $FUNCSIG$v (func))
 (type $FUNCSIG$ffd (func (param f32 f64) (result f32)))
 (type $FUNCSIG$iii (func (param i32 i32) (result i32)))
 (import "env" "emscripten_longjmp" (func $emscripten_longjmp (param i32 i32)))
 (import "env" "invoke_ffd" (func $invoke_ffd (param i32 f32 f64) (result f32)))
 (import "env" "invoke_iii" (func $invoke_iii (param i32 i32 i32) (result i32)))
 (import "env" "invoke_iiii" (func $invoke_iiii (param i32 i32 i32 i32) (result i32)))
 (import "env" "invoke_v" (func $invoke_v (param i32)))
 (import "env" "memory" (memory $0 1))
 (table 5 5 anyfunc)
 (elem (i32.const 0) $__wasm_nullptr $_Z5func1v $_Z5func2iii $_Z5func3fd $_Z5func4P8mystructS_)
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "main" (func $main))
 (export "dynCall_v" (func $dynCall_v))
 (export "dynCall_iiii" (func $dynCall_iiii))
 (export "dynCall_ffd" (func $dynCall_ffd))
 (export "dynCall_iii" (func $dynCall_iii))
 (func $_Z5func1v (type $FUNCSIG$v) ;; 0
 )
 (func $_Z5func2iii (type $FUNCSIG$iiii) (param $0 i32) (param $1 i32) (param $2 i32) (result i32) ;; 1
  (i32.const 3)
 )
 (func $_Z5func3fd (type $FUNCSIG$ffd) (param $0 f32) (param $1 f64) (result f32) ;; 2
  (f32.const 1)
 )
 (func $_Z5func4P8mystructS_ (type $FUNCSIG$iii) (param $0 i32) (param $1 i32) (result i32) ;; 3
  (i32.const 0)
 )
 (func $main (result i32) ;; 4
  (local $0 i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (call $invoke_v
   (i32.const 1)
  )
  (drop
   (call $invoke_iiii
    (i32.const 2)
    (i32.const 1)
    (i32.const 2)
    (i32.const 3)
   )
  )
  (drop
   (call $invoke_ffd
    (i32.const 3)
    (f32.const 1.5)
    (f64.const 3.4)
   )
  )
  (drop
   (call $invoke_iii
    (i32.const 4)
    (i32.add
     (get_local $1)
     (i32.const 32)
    )
    (i32.add
     (get_local $1)
     (i32.const 4)
    )
   )
  )
  (call $emscripten_longjmp
   (i32.const 5)
   (i32.const 6)
  )
  (i32.const 0)
 )
 (func $stackSave (result i32) ;; 5
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (param $0 i32) (result i32) ;; 6
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
 (func $stackRestore (param $0 i32) ;; 7
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
 (func $__wasm_nullptr (type $FUNCSIG$v) ;; 8
  (unreachable)
 )
 (func $dynCall_v (param $fptr i32) ;; 9
  (call_indirect $FUNCSIG$v
   (get_local $fptr)
  )
 )
 (func $dynCall_iiii (param $fptr i32) (param $0 i32) (param $1 i32) (param $2 i32) (result i32) ;; 10
  (call_indirect $FUNCSIG$iiii
   (get_local $0)
   (get_local $1)
   (get_local $2)
   (get_local $fptr)
  )
 )
 (func $dynCall_ffd (param $fptr i32) (param $0 f32) (param $1 f64) (result f32) ;; 11
  (call_indirect $FUNCSIG$ffd
   (get_local $0)
   (get_local $1)
   (get_local $fptr)
  )
 )
 (func $dynCall_iii (param $fptr i32) (param $0 i32) (param $1 i32) (result i32) ;; 12
  (call_indirect $FUNCSIG$iii
   (get_local $0)
   (get_local $1)
   (get_local $fptr)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
