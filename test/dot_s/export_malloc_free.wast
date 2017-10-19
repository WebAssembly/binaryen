(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "main" (func $main))
 (export "malloc" (func $malloc))
 (export "free" (func $free))
 (export "realloc" (func $realloc))
 (export "memalign" (func $memalign))
 (func $main (result i32) ;; 0
  (i32.const 0)
 )
 (func $malloc (param $0 i32) (result i32) ;; 1
  (i32.const 0)
 )
 (func $free (param $0 i32) ;; 2
 )
 (func $realloc (param $0 i32) (param $1 i32) (result i32) ;; 3
  (i32.const 0)
 )
 (func $memalign (param $0 i32) (param $1 i32) (result i32) ;; 4
  (i32.const 0)
 )
 (func $not_a_malloc (param $0 i32) (param $1 i32) (result i32) ;; 5
  (i32.const 0)
 )
 (func $stackSave (result i32) ;; 6
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (param $0 i32) (result i32) ;; 7
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
 (func $stackRestore (param $0 i32) ;; 8
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
