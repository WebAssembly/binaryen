	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/phi.ll"
	.globl	test0
	.type	test0,@function
test0:
	.param  	i32
	.result 	i32
	block
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $0, $pop0
	br_if   	$pop1, 0
	i32.const	$push2=, 3
	i32.div_s	$0=, $0, $pop2
.LBB0_2:
	end_block
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	test0, .Lfunc_end0-test0

	.globl	test1
	.type	test1,@function
test1:
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
	i32.const	$2=, 0
	i32.const	$3=, 1
	i32.const	$4=, 0
.LBB1_1:
	loop
	copy_local	$1=, $3
	copy_local	$3=, $2
	i32.const	$push1=, 1
	i32.add 	$4=, $4, $pop1
	copy_local	$2=, $1
	i32.lt_s	$push0=, $4, $0
	br_if   	$pop0, 0
	end_loop
	return  	$3
	.endfunc
.Lfunc_end1:
	.size	test1, .Lfunc_end1-test1


