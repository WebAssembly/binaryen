	.text
	.file	"/tmp/tmplu1mMq/a.out.bc"

  .type unreachable_block_void,@function
unreachable_block_void:
  .result   i32
  block     
  # Tests that we don't consume the type of the first item inside a block
  i32.const $push0=, 1
  end_block
  return    $pop0
  block     i32
  end_block
  .endfunc
.Lfunc_end0:
  .size unreachable_block_void, .Lfunc_end0-unreachable_block_void

  .type unreachable_block_i32,@function
unreachable_block_i32:
  .result   i32
  i32.const $push0=, 2
  return    $pop0
  block     i32
  end_block
  .endfunc
.Lfunc_end0:
  .size unreachable_block_i32, .Lfunc_end0-unreachable_block_i32

  .type unreachable_block_i64,@function
unreachable_block_i64:
  .result   i64
  i64.const $push0=, 3
  return    $pop0
  block     i64
  end_block
  .endfunc
.Lfunc_end0:
  .size unreachable_block_i64, .Lfunc_end0-unreachable_block_i64

  .type unreachable_block_f32,@function
unreachable_block_f32:
  .result   f32
  f32.const $push0=, 4.5
  return    $pop0
  block     f32
  end_block
  .endfunc
.Lfunc_end0:
  .size unreachable_block_f32, .Lfunc_end0-unreachable_block_f32

  .type unreachable_block_f64,@function
unreachable_block_f64:
  .result   f64
  f64.const $push0=, 5.5
  return    $pop0
  block     f64
  end_block
  .endfunc
.Lfunc_end0:
  .size unreachable_block_f64, .Lfunc_end0-unreachable_block_f64

  .type unreachable_loop_void,@function
unreachable_loop_void:
  .result   i32
  loop
  i32.const $push0=, 6
  br        0
  end_loop
  return    $pop0
  loop      
  br        0
  end_loop
  .endfunc
.Lfunc_end0:
  .size unreachable_loop_void, .Lfunc_end0-unreachable_loop_void

  .type unreachable_loop_i32,@function
unreachable_loop_i32:
  .result   i32
  i32.const $push0=, 7
  return    $pop0
  loop      i32
  br        0
  end_loop
  .endfunc
.Lfunc_end0:
  .size unreachable_loop_i32, .Lfunc_end0-unreachable_loop_i32

  .type unreachable_loop_i64,@function
unreachable_loop_i64:
  .result   i64
  i64.const $push0=, 8
  return    $pop0
  loop      i64
  br        0
  end_loop
  .endfunc
.Lfunc_end0:
  .size unreachable_loop_i64, .Lfunc_end0-unreachable_loop_i64

  .type unreachable_loop_f32,@function
unreachable_loop_f32:
  .result   f32
  f32.const $push0=, 9.5
  return    $pop0
  loop      f32
  br        0
  end_loop
  .endfunc
.Lfunc_end0:
  .size unreachable_loop_f32, .Lfunc_end0-unreachable_loop_f32

  .type unreachable_loop_f64,@function
unreachable_loop_f64:
  .result   f64
  f64.const $push0=, 10.5
  return    $pop0
  loop      f64
  br        0
  end_loop
  .endfunc
.Lfunc_end0:
  .size unreachable_loop_f64, .Lfunc_end0-unreachable_loop_f64
