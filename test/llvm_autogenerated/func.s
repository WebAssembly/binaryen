	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/func.ll"
	.globl	f0
	.type	f0,@function
f0:
	return
func_end0:
	.size	f0, func_end0-f0

	.globl	f1
	.type	f1,@function
f1:
	.result 	i32
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	f1, func_end1-f1

	.globl	f2
	.type	f2,@function
f2:
	.param  	i32, f32
	.result 	i32
	i32.const	$push0=, 0
	return  	$pop0
func_end2:
	.size	f2, func_end2-f2

	.globl	f3
	.type	f3,@function
f3:
	.param  	i32, f32
	return
func_end3:
	.size	f3, func_end3-f3

	.globl	f4
	.type	f4,@function
f4:
	.param  	i32
	.result 	i32
	.local  	i32
	i32.const	$1=, 1
	block   	BB4_2
	i32.and 	$push0=, $0, $1
	i32.const	$push2=, 0
	i32.eq  	$push3=, $pop0, $pop2
	br_if   	$pop3, BB4_2
	i32.const	$push1=, 0
	return  	$pop1
BB4_2:
	return  	$1
func_end4:
	.size	f4, func_end4-f4

	.globl	f5
	.type	f5,@function
f5:
	.result 	f32
	unreachable
func_end5:
	.size	f5, func_end5-f5


	.section	".note.GNU-stack","",@progbits
