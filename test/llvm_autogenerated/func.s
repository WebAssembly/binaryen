	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/func.ll"
	.globl	f0
	.type	f0,@function
f0:
	return
	.endfunc
.Lfunc_end0:
	.size	f0, .Lfunc_end0-f0

	.globl	f1
	.type	f1,@function
f1:
	.result 	i32
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	f1, .Lfunc_end1-f1

	.globl	f2
	.type	f2,@function
f2:
	.param  	i32, f32
	.result 	i32
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	f2, .Lfunc_end2-f2

	.globl	f3
	.type	f3,@function
f3:
	.param  	i32, f32
	return
	.endfunc
.Lfunc_end3:
	.size	f3, .Lfunc_end3-f3

	.globl	f4
	.type	f4,@function
f4:
	.param  	i32
	.result 	i32
	block   	
	i32.const	$push2=, 1
	i32.and 	$push0=, $0, $pop2
	i32.eqz 	$push4=, $pop0
	br_if   	0, $pop4
	i32.const	$push1=, 0
	return  	$pop1
.LBB4_2:
	end_block
	i32.const	$push3=, 1
	return  	$pop3
	.endfunc
.Lfunc_end4:
	.size	f4, .Lfunc_end4-f4

	.globl	f5
	.type	f5,@function
f5:
	.result 	f32
	unreachable
	.endfunc
.Lfunc_end5:
	.size	f5, .Lfunc_end5-f5


