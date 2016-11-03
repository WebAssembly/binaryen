	.text
	.globl	return_i32
	.type	return_i32,@function
return_i32:
	.result 	i32
	i32.const	$push0=, 5
        .endfunc
.Lfunc_end0:
	.size	return_i32, .Lfunc_end0-return_i32

	.globl	return_void
	.type	return_void,@function
return_void:
        .endfunc
.Lfunc_end0:
	.size	return_void, .Lfunc_end0-return_void

  .type fallthrough_return_nested_loop_i32,@function
fallthrough_return_nested_loop_i32:
  .result   i32
  loop      i32
  loop      i32
  i32.const $push0=, 1
  return    $pop0
  end_loop
  end_loop
  .endfunc
.Lfunc_end0:
  .size fallthrough_return_nested_loop_i32, .Lfunc_end0-fallthrough_return_nested_loop_i32
