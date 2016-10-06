	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/load.ll"
	.globl	ldi32
	.type	ldi32,@function
ldi32:
	.param  	i32
	.result 	i32
	i32.load	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	ldi32, .Lfunc_end0-ldi32

	.globl	ldi64
	.type	ldi64,@function
ldi64:
	.param  	i32
	.result 	i64
	i64.load	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	ldi64, .Lfunc_end1-ldi64

	.globl	ldf32
	.type	ldf32,@function
ldf32:
	.param  	i32
	.result 	f32
	f32.load	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	ldf32, .Lfunc_end2-ldf32

	.globl	ldf64
	.type	ldf64,@function
ldf64:
	.param  	i32
	.result 	f64
	f64.load	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	ldf64, .Lfunc_end3-ldf64


