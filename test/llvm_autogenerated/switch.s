	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/switch.ll"
	.globl	bar32
	.type	bar32,@function
bar32:
	.param  	i32
	block
	i32.const	$push0=, 23
	i32.gt_u	$push1=, $0, $pop0
	br_if   	$pop1, 0
	block
	block
	block
	block
	block
	block
	tableswitch	$0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 4, 5
.LBB0_2:
	end_block
	call    	foo0@FUNCTION
	br      	5
.LBB0_3:
	end_block
	call    	foo1@FUNCTION
	br      	4
.LBB0_4:
	end_block
	call    	foo2@FUNCTION
	br      	3
.LBB0_5:
	end_block
	call    	foo3@FUNCTION
	br      	2
.LBB0_6:
	end_block
	call    	foo4@FUNCTION
	br      	1
.LBB0_7:
	end_block
	call    	foo5@FUNCTION
.LBB0_8:
	end_block
	return
.Lfunc_end0:
	.size	bar32, .Lfunc_end0-bar32

	.globl	bar64
	.type	bar64,@function
bar64:
	.param  	i64
	block
	i64.const	$push1=, 23
	i64.gt_u	$push2=, $0, $pop1
	br_if   	$pop2, 0
	block
	block
	block
	block
	block
	block
	i32.wrap/i64	$push0=, $0
	tableswitch	$pop0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 4, 5
.LBB1_2:
	end_block
	call    	foo0@FUNCTION
	br      	5
.LBB1_3:
	end_block
	call    	foo1@FUNCTION
	br      	4
.LBB1_4:
	end_block
	call    	foo2@FUNCTION
	br      	3
.LBB1_5:
	end_block
	call    	foo3@FUNCTION
	br      	2
.LBB1_6:
	end_block
	call    	foo4@FUNCTION
	br      	1
.LBB1_7:
	end_block
	call    	foo5@FUNCTION
.LBB1_8:
	end_block
	return
.Lfunc_end1:
	.size	bar64, .Lfunc_end1-bar64


	.section	".note.GNU-stack","",@progbits
