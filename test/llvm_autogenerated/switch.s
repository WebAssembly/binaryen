	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/switch.ll"
	.globl	bar32
	.type	bar32,@function
bar32:
	.param  	i32
	block   	
	i32.const	$push0=, 23
	i32.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 4, 5, 0
.LBB0_2:
	end_block
	call    	foo0@FUNCTION
	return
.LBB0_3:
	end_block
	call    	foo1@FUNCTION
	return
.LBB0_4:
	end_block
	call    	foo2@FUNCTION
	return
.LBB0_5:
	end_block
	call    	foo3@FUNCTION
	return
.LBB0_6:
	end_block
	call    	foo4@FUNCTION
	return
.LBB0_7:
	end_block
	call    	foo5@FUNCTION
.LBB0_8:
	end_block
	return
	.endfunc
.Lfunc_end0:
	.size	bar32, .Lfunc_end0-bar32

	.globl	bar64
	.type	bar64,@function
bar64:
	.param  	i64
	block   	
	i64.const	$push1=, 23
	i64.gt_u	$push2=, $0, $pop1
	br_if   	0, $pop2
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	i32.wrap/i64	$push0=, $0
	br_table 	$pop0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 4, 5, 0
.LBB1_2:
	end_block
	call    	foo0@FUNCTION
	return
.LBB1_3:
	end_block
	call    	foo1@FUNCTION
	return
.LBB1_4:
	end_block
	call    	foo2@FUNCTION
	return
.LBB1_5:
	end_block
	call    	foo3@FUNCTION
	return
.LBB1_6:
	end_block
	call    	foo4@FUNCTION
	return
.LBB1_7:
	end_block
	call    	foo5@FUNCTION
.LBB1_8:
	end_block
	return
	.endfunc
.Lfunc_end1:
	.size	bar64, .Lfunc_end1-bar64


	.functype	foo0, void
	.functype	foo1, void
	.functype	foo2, void
	.functype	foo3, void
	.functype	foo4, void
	.functype	foo5, void
