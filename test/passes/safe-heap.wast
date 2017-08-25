(module
 (memory 100 100 shared)
 (func $loads
  (drop (i32.load (i32.const 1)))
  (drop (i32.load offset=31 (i32.const 1)))
 )
)

