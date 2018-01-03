(module
 (type $0 (func (param i32 i32) (result i32)))
 (type $1 (func (result i32)))
 (import "env" "printf" (func $import$0 (param i32 i32) (result i32)))
 (global $global$0 (mut i32) (i32.const 66592))
 (table 1 1 anyfunc)
 (memory $0 2)
 (data (i32.const 1024) "%d:%d\n\00Result: %d\n\00")
 (export "memory" (memory $0))
 (export "main" (func $main))
 (func $foo (; 1 ;) (type $0) (param $var$0 i32) (param $var$1 i32) (result i32)
  (local $var$2 i32)
  (set_global $global$0
   (tee_local $var$2
    (i32.sub
     (get_global $global$0)
     (i32.const 16)
    )
   )
  )
  (i32.store offset=4
   (get_local $var$2)
   (get_local $var$1)
  )
  (i32.store
   (get_local $var$2)
   (get_local $var$0)
  )
  (drop
   (call $import$0
    (i32.const 1024)
    (get_local $var$2)
   )
  )
  (set_global $global$0
   (i32.add
    (get_local $var$2)
    (i32.const 16)
   )
  )
  (i32.add
   (get_local $var$1)
   (get_local $var$0)
  )
 )
 (func $main (; 2 ;) (type $1) (result i32)
  (local $var$0 i32)
  (set_global $global$0
   (tee_local $var$0
    (i32.sub
     (get_global $global$0)
     (i32.const 16)
    )
   )
  )
  (i32.store
   (get_local $var$0)
   (call $foo
    (i32.const 1)
    (i32.const 2)
   )
  )
  (drop
   (call $import$0
    (i32.const 1031)
    (get_local $var$0)
   )
  )
  (set_global $global$0
   (i32.add
    (get_local $var$0)
    (i32.const 16)
   )
  )
  (i32.const 0)
 )
 ;; custom section "linking", size 3
)

