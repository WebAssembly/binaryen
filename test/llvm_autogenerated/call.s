	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/call.ll"
	.globl	call_i32_nullary
	.type	call_i32_nullary,@function
call_i32_nullary:
	.result 	i32
	i32.call	$push0=, i32_nullary@FUNCTION
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	call_i32_nullary, .Lfunc_end0-call_i32_nullary

	.globl	call_i64_nullary
	.type	call_i64_nullary,@function
call_i64_nullary:
	.result 	i64
	i64.call	$push0=, i64_nullary@FUNCTION
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	call_i64_nullary, .Lfunc_end1-call_i64_nullary

	.globl	call_float_nullary
	.type	call_float_nullary,@function
call_float_nullary:
	.result 	f32
	f32.call	$push0=, float_nullary@FUNCTION
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	call_float_nullary, .Lfunc_end2-call_float_nullary

	.globl	call_double_nullary
	.type	call_double_nullary,@function
call_double_nullary:
	.result 	f64
	f64.call	$push0=, double_nullary@FUNCTION
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	call_double_nullary, .Lfunc_end3-call_double_nullary

	.globl	call_void_nullary
	.type	call_void_nullary,@function
call_void_nullary:
	call    	void_nullary@FUNCTION
	return
	.endfunc
.Lfunc_end4:
	.size	call_void_nullary, .Lfunc_end4-call_void_nullary

	.globl	call_i32_unary
	.type	call_i32_unary,@function
call_i32_unary:
	.param  	i32
	.result 	i32
	i32.call	$push0=, i32_unary@FUNCTION, $0
	return  	$pop0
	.endfunc
.Lfunc_end5:
	.size	call_i32_unary, .Lfunc_end5-call_i32_unary

	.globl	call_i32_binary
	.type	call_i32_binary,@function
call_i32_binary:
	.param  	i32, i32
	.result 	i32
	i32.call	$push0=, i32_binary@FUNCTION, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end6:
	.size	call_i32_binary, .Lfunc_end6-call_i32_binary

	.globl	call_indirect_void
	.type	call_indirect_void,@function
call_indirect_void:
	.param  	i32
	call_indirect	$0
	return
	.endfunc
.Lfunc_end7:
	.size	call_indirect_void, .Lfunc_end7-call_indirect_void

	.globl	call_indirect_i32
	.type	call_indirect_i32,@function
call_indirect_i32:
	.param  	i32
	.result 	i32
	i32.call_indirect	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end8:
	.size	call_indirect_i32, .Lfunc_end8-call_indirect_i32

	.globl	call_indirect_arg
	.type	call_indirect_arg,@function
call_indirect_arg:
	.param  	i32, i32
	call_indirect	$1, $0
	return
	.endfunc
.Lfunc_end9:
	.size	call_indirect_arg, .Lfunc_end9-call_indirect_arg

	.globl	call_indirect_arg_2
	.type	call_indirect_arg_2,@function
call_indirect_arg_2:
	.param  	i32, i32, i32
	i32.call_indirect	$drop=, $1, $2, $0
	return
	.endfunc
.Lfunc_end10:
	.size	call_indirect_arg_2, .Lfunc_end10-call_indirect_arg_2

	.globl	tail_call_void_nullary
	.type	tail_call_void_nullary,@function
tail_call_void_nullary:
	call    	void_nullary@FUNCTION
	return
	.endfunc
.Lfunc_end11:
	.size	tail_call_void_nullary, .Lfunc_end11-tail_call_void_nullary

	.globl	fastcc_tail_call_void_nullary
	.type	fastcc_tail_call_void_nullary,@function
fastcc_tail_call_void_nullary:
	call    	void_nullary@FUNCTION
	return
	.endfunc
.Lfunc_end12:
	.size	fastcc_tail_call_void_nullary, .Lfunc_end12-fastcc_tail_call_void_nullary

	.globl	coldcc_tail_call_void_nullary
	.type	coldcc_tail_call_void_nullary,@function
coldcc_tail_call_void_nullary:
	call    	void_nullary@FUNCTION
	return
	.endfunc
.Lfunc_end13:
	.size	coldcc_tail_call_void_nullary, .Lfunc_end13-coldcc_tail_call_void_nullary


	.functype	i32_nullary, i32
	.functype	i32_unary, i32, i32
	.functype	i32_binary, i32, i32, i32
	.functype	i64_nullary, i64
	.functype	float_nullary, f32
	.functype	double_nullary, f64
	.functype	void_nullary, void
