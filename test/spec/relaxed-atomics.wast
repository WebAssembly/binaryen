(module
 (memory $0 23 256 shared)

 (func $load (result i32)
   (i32.atomic.load seqcst
    (i32.const 0)
   )
 )
)