	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/phi.ll"
	.globl	test0
	.type	test0,@function
test0:
	.param  	i32
	.result 	i32
	block   	
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $0, $pop0
	br_if   	0, $pop1
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
	copy_local	$1=, $2
	copy_local	$2=, $3
	copy_local	$3=, $1
	i32.const	$push3=, 1
	i32.add 	$push2=, $4, $pop3
	tee_local	$push1=, $4=, $pop2
	i32.lt_s	$push0=, $pop1, $0
	br_if   	0, $pop0
	end_loop
	return  	$1
	.endfunc
.Lfunc_end1:
	.size	test1, .Lfunc_end1-test1


