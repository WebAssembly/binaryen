	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/offset-folding.ll"
	.globl	test0
	.type	test0,@function
test0:
	.result 	i32
	i32.const	$push0=, x+188
	return  	$pop0
func_end0:
	.size	test0, func_end0-test0

	.globl	test1
	.type	test1,@function
test1:
	.result 	i32
	i32.const	$push0=, y+188
	return  	$pop0
func_end1:
	.size	test1, func_end1-test1

	.globl	test2
	.type	test2,@function
test2:
	.result 	i32
	i32.const	$push0=, x
	return  	$pop0
func_end2:
	.size	test2, func_end2-test2

	.globl	test3
	.type	test3,@function
test3:
	.result 	i32
	i32.const	$push0=, y
	return  	$pop0
func_end3:
	.size	test3, func_end3-test3

	.type	x,@object
	.bss
	.globl	x
	.align	2
x:
	.size	x, 0

	.type	y,@object
	.globl	y
	.align	4
y:
	.zero	200
	.size	y, 200


	.section	".note.GNU-stack","",@progbits
