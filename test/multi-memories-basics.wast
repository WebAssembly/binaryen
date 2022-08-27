(module
 (type $none_=>_none (func))
 (type $none_=>_i32 (func (result i32)))
 (import "env" "memory" (memory $importedMemory 1 1))
 (memory $memory1 1 500)
 (memory $memory2 1 800)
 (memory $memory3 1 400)
 (data (i32.const 0) "abcd")
 (func $memory.fill
  (memory.fill $memory2
   (i32.const 0)
   (i32.const 1)
   (i32.const 2)
  )
 )
 (func $memory.copy
  (memory.copy $memory2 $memory3
   (i32.const 512)
   (i32.const 0)
   (i32.const 12)
  )
 )
 (func $memory.init
  (memory.init $memory1 0
   (i32.const 0)
   (i32.const 0)
   (i32.const 45)
  )
 )
 (func $memory.grow (result i32)
  (memory.grow $memory3
   (i32.const 10)
  )
 )
 (func $memory.size (result i32)
  (memory.size $memory3)
 )
 (func $loads
  (drop
   (i32.load $memory1
    (i32.const 12)
   )
  )
  (drop
   (i32.load $memory3
    (i32.const 12)
   )
  )
  (drop
   (i32.load16_s $memory2
    (i32.const 12)
   )
  )
  (drop
   (i32.load16_s $memory2
    (i32.const 12)
   )
  )
  (drop
   (i32.load8_s $memory3
    (i32.const 12)
   )
  )
  (drop
   (i32.load8_s $memory3
    (i32.const 12)
   )
  )
  (drop
   (i32.load16_u $memory1
    (i32.const 12)
   )
  )
  (drop
   (i32.load16_u $memory1
    (i32.const 12)
   )
  )
  (drop
   (i32.load8_u $memory2
    (i32.const 12)
   )
  )
  (drop
   (i32.load8_u $memory2
    (i32.const 12)
   )
  )
 )
 (func $stores
  (i32.store $memory1
   (i32.const 12)
   (i32.const 115)
  )
  (i32.store $memory1
   (i32.const 12)
   (i32.const 115)
  )
  (i32.store16 $memory2
   (i32.const 20)
   (i32.const 31353)
  )
  (i32.store16 $importedMemory
   (i32.const 20)
   (i32.const 31353)
  )
  (i32.store8 $memory3
   (i32.const 23)
   (i32.const 120)
  )
  (i32.store8 $memory3
   (i32.const 23)
   (i32.const 120)
  )
 )
)

