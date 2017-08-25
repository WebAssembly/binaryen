(module
 (memory 100 100 shared)
 (func $loads
  (drop (i32.load (i32.const 1)))
  (drop (i32.load offset=31 (i32.const 2)))
  (drop (i32.load align=2 (i32.const 3)))
  (drop (i32.load align=1 (i32.const 4)))
  (drop (i32.load8_s (i32.const 5)))
  (drop (i32.load16_u (i32.const 6)))
  (drop (i64.load8_s (i32.const 7)))
  (drop (i64.load16_u (i32.const 8)))
  (drop (i64.load32_s (i32.const 9)))
  (drop (i64.load align=4 (i32.const 10)))
  (drop (i64.load (i32.const 11)))
  (drop (f32.load (i32.const 12)))
  (drop (f64.load (i32.const 13)))
 )
)

