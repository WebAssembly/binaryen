	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/phi.ll"
	.globl	test0
	.type	test0,@function
test0:
	.param  	i32
	.result 	i32
	block   	.LBB0_2
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_2
	i32.const	$push2=, 3
	i32.div_s	$0=, $0, $pop2
.LBB0_2:
	return  	$0
.Lfunc_end0:
	.size	test0, .Lfunc_end0-test0

	.globl	test1
	.type	test1,@function
test1:
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
	i32.const	$2=, 1
	i32.const	$3=, 0
	copy_local	$4=, $2
	copy_local	$5=, $3
.LBB1_1:
	loop    	.LBB1_2
	copy_local	$1=, $4
	copy_local	$4=, $3
	i32.add 	$5=, $5, $2
	copy_local	$3=, $1
	i32.lt_s	$push0=, $5, $0
	br_if   	$pop0, .LBB1_1
.LBB1_2:
	return  	$4
.Lfunc_end1:
	.size	test1, .Lfunc_end1-test1


	.section	".note.GNU-stack","",@progbits
