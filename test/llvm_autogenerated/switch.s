	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/switch.ll"
	.globl	bar32
	.type	bar32,@function
bar32:
	.param  	i32
	block   	BB0_8
	i32.const	$push0=, 23
	i32.gt_u	$push1=, $0, $pop0
	br_if   	$pop1, BB0_8
	block   	BB0_7
	block   	BB0_6
	block   	BB0_5
	block   	BB0_4
	block   	BB0_3
	block   	BB0_2
	tableswitch	$0, BB0_2, BB0_2, BB0_2, BB0_2, BB0_2, BB0_2, BB0_2, BB0_2, BB0_3, BB0_3, BB0_3, BB0_3, BB0_3, BB0_3, BB0_3, BB0_3, BB0_4, BB0_4, BB0_4, BB0_4, BB0_4, BB0_4, BB0_5, BB0_6, BB0_7
BB0_2:
	call    	foo0
	br      	BB0_8
BB0_3:
	call    	foo1
	br      	BB0_8
BB0_4:
	call    	foo2
	br      	BB0_8
BB0_5:
	call    	foo3
	br      	BB0_8
BB0_6:
	call    	foo4
	br      	BB0_8
BB0_7:
	call    	foo5
BB0_8:
	return
func_end0:
	.size	bar32, func_end0-bar32

	.globl	bar64
	.type	bar64,@function
bar64:
	.param  	i64
	block   	BB1_8
	i64.const	$push1=, 23
	i64.gt_u	$push2=, $0, $pop1
	br_if   	$pop2, BB1_8
	block   	BB1_7
	block   	BB1_6
	block   	BB1_5
	block   	BB1_4
	block   	BB1_3
	block   	BB1_2
	i32.wrap/i64	$push0=, $0
	tableswitch	$pop0, BB1_2, BB1_2, BB1_2, BB1_2, BB1_2, BB1_2, BB1_2, BB1_2, BB1_3, BB1_3, BB1_3, BB1_3, BB1_3, BB1_3, BB1_3, BB1_3, BB1_4, BB1_4, BB1_4, BB1_4, BB1_4, BB1_4, BB1_5, BB1_6, BB1_7
BB1_2:
	call    	foo0
	br      	BB1_8
BB1_3:
	call    	foo1
	br      	BB1_8
BB1_4:
	call    	foo2
	br      	BB1_8
BB1_5:
	call    	foo3
	br      	BB1_8
BB1_6:
	call    	foo4
	br      	BB1_8
BB1_7:
	call    	foo5
BB1_8:
	return
func_end1:
	.size	bar64, func_end1-bar64


	.section	".note.GNU-stack","",@progbits
