(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "ldi32_a1" (func $ldi32_a1))
 (export "ldi32_a2" (func $ldi32_a2))
 (export "ldi32_a4" (func $ldi32_a4))
 (export "ldi32" (func $ldi32))
 (export "ldi32_a8" (func $ldi32_a8))
 (export "ldi8_a1" (func $ldi8_a1))
 (export "ldi8_a2" (func $ldi8_a2))
 (export "ldi16_a1" (func $ldi16_a1))
 (export "ldi16_a2" (func $ldi16_a2))
 (export "ldi16_a4" (func $ldi16_a4))
 (export "sti32_a1" (func $sti32_a1))
 (export "sti32_a2" (func $sti32_a2))
 (export "sti32_a4" (func $sti32_a4))
 (export "sti32" (func $sti32))
 (export "sti32_a8" (func $sti32_a8))
 (export "sti8_a1" (func $sti8_a1))
 (export "sti8_a2" (func $sti8_a2))
 (export "sti16_a1" (func $sti16_a1))
 (export "sti16_a2" (func $sti16_a2))
 (export "sti16_a4" (func $sti16_a4))
 (func $ldi32_a1 (param $0 i32) (result i32)
  (return
   (i32.load align=1
    (get_local $0)
   )
  )
 )
 (func $ldi32_a2 (param $0 i32) (result i32)
  (return
   (i32.load align=2
    (get_local $0)
   )
  )
 )
 (func $ldi32_a4 (param $0 i32) (result i32)
  (return
   (i32.load
    (get_local $0)
   )
  )
 )
 (func $ldi32 (param $0 i32) (result i32)
  (return
   (i32.load
    (get_local $0)
   )
  )
 )
 (func $ldi32_a8 (param $0 i32) (result i32)
  (return
   (i32.load
    (get_local $0)
   )
  )
 )
 (func $ldi8_a1 (param $0 i32) (result i32)
  (return
   (i32.load8_u
    (get_local $0)
   )
  )
 )
 (func $ldi8_a2 (param $0 i32) (result i32)
  (return
   (i32.load8_u
    (get_local $0)
   )
  )
 )
 (func $ldi16_a1 (param $0 i32) (result i32)
  (return
   (i32.load16_u align=1
    (get_local $0)
   )
  )
 )
 (func $ldi16_a2 (param $0 i32) (result i32)
  (return
   (i32.load16_u
    (get_local $0)
   )
  )
 )
 (func $ldi16_a4 (param $0 i32) (result i32)
  (return
   (i32.load16_u
    (get_local $0)
   )
  )
 )
 (func $sti32_a1 (param $0 i32) (param $1 i32)
  (i32.store align=1
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti32_a2 (param $0 i32) (param $1 i32)
  (i32.store align=2
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti32_a4 (param $0 i32) (param $1 i32)
  (i32.store
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti32 (param $0 i32) (param $1 i32)
  (i32.store
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti32_a8 (param $0 i32) (param $1 i32)
  (i32.store
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti8_a1 (param $0 i32) (param $1 i32)
  (i32.store8
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti8_a2 (param $0 i32) (param $1 i32)
  (i32.store8
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti16_a1 (param $0 i32) (param $1 i32)
  (i32.store16 align=1
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti16_a2 (param $0 i32) (param $1 i32)
  (i32.store16
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti16_a4 (param $0 i32) (param $1 i32)
  (i32.store16
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $stackSave (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (param $0 i32) (result i32)
  (local $1 i32)
  (set_local $1
   (i32.load offset=4
    (i32.const 0)
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.and
    (i32.add
     (i32.add
      (get_local $1)
      (get_local $0)
     )
     (i32.const 15)
    )
    (i32.const -16)
   )
  )
  (get_local $1)
 )
 (func $stackRestore (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
