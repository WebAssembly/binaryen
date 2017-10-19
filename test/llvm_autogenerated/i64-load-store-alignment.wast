(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "ldi64_a1" (func $ldi64_a1))
 (export "ldi64_a2" (func $ldi64_a2))
 (export "ldi64_a4" (func $ldi64_a4))
 (export "ldi64_a8" (func $ldi64_a8))
 (export "ldi64" (func $ldi64))
 (export "ldi64_a16" (func $ldi64_a16))
 (export "ldi8_a1" (func $ldi8_a1))
 (export "ldi8_a2" (func $ldi8_a2))
 (export "ldi16_a1" (func $ldi16_a1))
 (export "ldi16_a2" (func $ldi16_a2))
 (export "ldi16_a4" (func $ldi16_a4))
 (export "ldi32_a1" (func $ldi32_a1))
 (export "ldi32_a2" (func $ldi32_a2))
 (export "ldi32_a4" (func $ldi32_a4))
 (export "ldi32_a8" (func $ldi32_a8))
 (export "sti64_a1" (func $sti64_a1))
 (export "sti64_a2" (func $sti64_a2))
 (export "sti64_a4" (func $sti64_a4))
 (export "sti64_a8" (func $sti64_a8))
 (export "sti64" (func $sti64))
 (export "sti64_a16" (func $sti64_a16))
 (export "sti8_a1" (func $sti8_a1))
 (export "sti8_a2" (func $sti8_a2))
 (export "sti16_a1" (func $sti16_a1))
 (export "sti16_a2" (func $sti16_a2))
 (export "sti16_a4" (func $sti16_a4))
 (export "sti32_a1" (func $sti32_a1))
 (export "sti32_a2" (func $sti32_a2))
 (export "sti32_a4" (func $sti32_a4))
 (export "sti32_a8" (func $sti32_a8))
 (func $ldi64_a1 (param $0 i32) (result i64) ;; 0
  (return
   (i64.load align=1
    (get_local $0)
   )
  )
 )
 (func $ldi64_a2 (param $0 i32) (result i64) ;; 1
  (return
   (i64.load align=2
    (get_local $0)
   )
  )
 )
 (func $ldi64_a4 (param $0 i32) (result i64) ;; 2
  (return
   (i64.load align=4
    (get_local $0)
   )
  )
 )
 (func $ldi64_a8 (param $0 i32) (result i64) ;; 3
  (return
   (i64.load
    (get_local $0)
   )
  )
 )
 (func $ldi64 (param $0 i32) (result i64) ;; 4
  (return
   (i64.load
    (get_local $0)
   )
  )
 )
 (func $ldi64_a16 (param $0 i32) (result i64) ;; 5
  (return
   (i64.load
    (get_local $0)
   )
  )
 )
 (func $ldi8_a1 (param $0 i32) (result i64) ;; 6
  (return
   (i64.load8_u
    (get_local $0)
   )
  )
 )
 (func $ldi8_a2 (param $0 i32) (result i64) ;; 7
  (return
   (i64.load8_u
    (get_local $0)
   )
  )
 )
 (func $ldi16_a1 (param $0 i32) (result i64) ;; 8
  (return
   (i64.load16_u align=1
    (get_local $0)
   )
  )
 )
 (func $ldi16_a2 (param $0 i32) (result i64) ;; 9
  (return
   (i64.load16_u
    (get_local $0)
   )
  )
 )
 (func $ldi16_a4 (param $0 i32) (result i64) ;; 10
  (return
   (i64.load16_u
    (get_local $0)
   )
  )
 )
 (func $ldi32_a1 (param $0 i32) (result i64) ;; 11
  (return
   (i64.load32_u align=1
    (get_local $0)
   )
  )
 )
 (func $ldi32_a2 (param $0 i32) (result i64) ;; 12
  (return
   (i64.load32_u align=2
    (get_local $0)
   )
  )
 )
 (func $ldi32_a4 (param $0 i32) (result i64) ;; 13
  (return
   (i64.load32_u
    (get_local $0)
   )
  )
 )
 (func $ldi32_a8 (param $0 i32) (result i64) ;; 14
  (return
   (i64.load32_u
    (get_local $0)
   )
  )
 )
 (func $sti64_a1 (param $0 i32) (param $1 i64) ;; 15
  (i64.store align=1
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti64_a2 (param $0 i32) (param $1 i64) ;; 16
  (i64.store align=2
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti64_a4 (param $0 i32) (param $1 i64) ;; 17
  (i64.store align=4
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti64_a8 (param $0 i32) (param $1 i64) ;; 18
  (i64.store
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti64 (param $0 i32) (param $1 i64) ;; 19
  (i64.store
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti64_a16 (param $0 i32) (param $1 i64) ;; 20
  (i64.store
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti8_a1 (param $0 i32) (param $1 i64) ;; 21
  (i64.store8
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti8_a2 (param $0 i32) (param $1 i64) ;; 22
  (i64.store8
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti16_a1 (param $0 i32) (param $1 i64) ;; 23
  (i64.store16 align=1
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti16_a2 (param $0 i32) (param $1 i64) ;; 24
  (i64.store16
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti16_a4 (param $0 i32) (param $1 i64) ;; 25
  (i64.store16
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti32_a1 (param $0 i32) (param $1 i64) ;; 26
  (i64.store32 align=1
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti32_a2 (param $0 i32) (param $1 i64) ;; 27
  (i64.store32 align=2
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti32_a4 (param $0 i32) (param $1 i64) ;; 28
  (i64.store32
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $sti32_a8 (param $0 i32) (param $1 i64) ;; 29
  (i64.store32
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $stackSave (result i32) ;; 30
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (param $0 i32) (result i32) ;; 31
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
 (func $stackRestore (param $0 i32) ;; 32
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
