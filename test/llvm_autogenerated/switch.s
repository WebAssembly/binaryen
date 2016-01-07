	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/switch.ll"
	.globl	bar32
	.type	bar32,@function
bar32:
	.param  	i32
	block   	.LBB0_8
	i32.const	$push0=, 23
	i32.gt_u	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_8
	block   	.LBB0_7
	block   	.LBB0_6
	block   	.LBB0_5
	block   	.LBB0_4
	block   	.LBB0_3
	block   	.LBB0_2
	tableswitch	$0, .LBB0_2, .LBB0_2, .LBB0_2, .LBB0_2, .LBB0_2, .LBB0_2, .LBB0_2, .LBB0_2, .LBB0_3, .LBB0_3, .LBB0_3, .LBB0_3, .LBB0_3, .LBB0_3, .LBB0_3, .LBB0_3, .LBB0_4, .LBB0_4, .LBB0_4, .LBB0_4, .LBB0_4, .LBB0_4, .LBB0_5, .LBB0_6, .LBB0_7
.LBB0_2:
	call    	foo0
	br      	.LBB0_8
.LBB0_3:
	call    	foo1
	br      	.LBB0_8
.LBB0_4:
	call    	foo2
	br      	.LBB0_8
.LBB0_5:
	call    	foo3
	br      	.LBB0_8
.LBB0_6:
	call    	foo4
	br      	.LBB0_8
.LBB0_7:
	call    	foo5
.LBB0_8:
	return
.Lfunc_end0:
	.size	bar32, .Lfunc_end0-bar32

	.globl	bar64
	.type	bar64,@function
bar64:
	.param  	i64
	block   	.LBB1_8
	i64.const	$push1=, 23
	i64.gt_u	$push2=, $0, $pop1
	br_if   	$pop2, .LBB1_8
	block   	.LBB1_7
	block   	.LBB1_6
	block   	.LBB1_5
	block   	.LBB1_4
	block   	.LBB1_3
	block   	.LBB1_2
	i32.wrap/i64	$push0=, $0
	tableswitch	$pop0, .LBB1_2, .LBB1_2, .LBB1_2, .LBB1_2, .LBB1_2, .LBB1_2, .LBB1_2, .LBB1_2, .LBB1_3, .LBB1_3, .LBB1_3, .LBB1_3, .LBB1_3, .LBB1_3, .LBB1_3, .LBB1_3, .LBB1_4, .LBB1_4, .LBB1_4, .LBB1_4, .LBB1_4, .LBB1_4, .LBB1_5, .LBB1_6, .LBB1_7
.LBB1_2:
	call    	foo0
	br      	.LBB1_8
.LBB1_3:
	call    	foo1
	br      	.LBB1_8
.LBB1_4:
	call    	foo2
	br      	.LBB1_8
.LBB1_5:
	call    	foo3
	br      	.LBB1_8
.LBB1_6:
	call    	foo4
	br      	.LBB1_8
.LBB1_7:
	call    	foo5
.LBB1_8:
	return
.Lfunc_end1:
	.size	bar64, .Lfunc_end1-bar64


	.section	".note.GNU-stack","",@progbits
