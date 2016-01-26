	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/fast-isel.ll"
	.globl	immediate_f32
	.type	immediate_f32,@function
immediate_f32:
	.result 	f32
	f32.const	$push0=, 0x1.4p1
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	immediate_f32, .Lfunc_end0-immediate_f32

	.globl	immediate_f64
	.type	immediate_f64,@function
immediate_f64:
	.result 	f64
	f64.const	$push0=, 0x1.4p1
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	immediate_f64, .Lfunc_end1-immediate_f64


