(module
 (type $FUNCSIG$vi (func (param i32)))
 (import "env" "memory" (memory $0 1))
 (import "env" "emscripten_asm_const_v" (func $emscripten_asm_const_v (param i32)))
 (table 0 anyfunc)
 (data (i32.const 16) "{ Module.print(\"hello, world! \" + HEAP32[8>>2]); }\00")
 (export "main" (func $main))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $_Z6reporti (; 1 ;) (param $0 i32)
  (i32.store
   (i32.const 8)
   (get_local $0)
  )
  (call $emscripten_asm_const_v
   (i32.const 0)
  )
  (return)
 )
 (func $main (; 2 ;) (result i32)
  (local $0 i32)
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
  (set_local $7
   (i32.const 0)
  )
  (set_local $7
   (i32.load
    (get_local $7)
   )
  )
  (set_local $8
   (i32.const 1048576)
  )
  (set_local $12
   (i32.sub
    (get_local $7)
    (get_local $8)
   )
  )
  (set_local $8
   (i32.const 0)
  )
  (i32.store
   (get_local $8)
   (get_local $12)
  )
  (set_local $1
   (i32.const 0)
  )
  (set_local $0
   (get_local $1)
  )
  (set_local $6
   (get_local $1)
  )
  (block $label$0
   (loop $label$1
    (set_local $4
     (get_local $1)
    )
    (block $label$2
     (loop $label$3
      (set_local $10
       (i32.const 0)
      )
      (set_local $10
       (i32.add
        (get_local $12)
        (get_local $10)
       )
      )
      (i32.store8
       (i32.add
        (get_local $10)
        (get_local $4)
       )
       (i32.add
        (get_local $6)
        (get_local $4)
       )
      )
      (set_local $2
       (i32.const 1)
      )
      (set_local $4
       (i32.add
        (get_local $4)
        (get_local $2)
       )
      )
      (set_local $3
       (i32.const 1048576)
      )
      (set_local $5
       (get_local $1)
      )
      (br_if $label$3
       (i32.ne
        (get_local $4)
        (get_local $3)
       )
      )
     )
    )
    (block $label$4
     (loop $label$5
      (set_local $11
       (i32.const 0)
      )
      (set_local $11
       (i32.add
        (get_local $12)
        (get_local $11)
       )
      )
      (set_local $6
       (i32.add
        (i32.and
         (i32.load8_u
          (i32.add
           (get_local $11)
           (get_local $5)
          )
         )
         (get_local $2)
        )
        (get_local $6)
       )
      )
      (set_local $5
       (i32.add
        (get_local $5)
        (get_local $2)
       )
      )
      (br_if $label$5
       (i32.ne
        (get_local $5)
        (get_local $3)
       )
      )
     )
    )
    (set_local $6
     (i32.and
      (i32.add
       (i32.add
        (i32.mul
         (get_local $6)
         (i32.const 3)
        )
        (i32.div_s
         (get_local $6)
         (i32.const 5)
        )
       )
       (i32.const 17)
      )
      (i32.const 65535)
     )
    )
    (set_local $0
     (i32.add
      (get_local $0)
      (get_local $2)
     )
    )
    (br_if $label$1
     (i32.ne
      (get_local $0)
      (i32.const 100)
     )
    )
   )
  )
  (call $_Z6reporti
   (get_local $6)
  )
  (set_local $9
   (i32.const 1048576)
  )
  (set_local $12
   (i32.add
    (get_local $12)
    (get_local $9)
   )
  )
  (set_local $9
   (i32.const 0)
  )
  (i32.store
   (get_local $9)
   (get_local $12)
  )
  (return
   (i32.const 0)
  )
 )
 (func $stackSave (; 3 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 4 ;) (param $0 i32) (result i32)
  (local $1 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $1
    (i32.and
     (i32.sub
      (i32.load offset=4
       (i32.const 0)
      )
      (get_local $0)
     )
     (i32.const -16)
    )
   )
  )
  (get_local $1)
 )
 (func $stackRestore (; 5 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {"0": ["{ Module.print(\"hello, world! \" + HEAP32[8>>2]); }", ["v"]]},"staticBump": 67, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_main","_stackSave","_stackAlloc","_stackRestore"], "exports": ["main","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
