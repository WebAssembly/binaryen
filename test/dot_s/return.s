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

