	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/return-int32.ll"
	.globl	return_i32
	.type	return_i32,@function
return_i32:
	.param  	i32
	.result 	i32
	copy_local	$push0=, $0
	.endfunc
.Lfunc_end0:
	.size	return_i32, .Lfunc_end0-return_i32

	.globl	return_i32_twice
	.type	return_i32_twice,@function
return_i32_twice:
	.param  	i32
	.result 	i32
	block   	
	i32.eqz 	$push6=, $0
	br_if   	0, $pop6
	i32.const	$push3=, 0
	i32.const	$push5=, 0
	i32.store	0($pop3), $pop5
	i32.const	$push4=, 1
	return  	$pop4
.LBB1_2:
	end_block
	i32.const	$push1=, 0
	i32.const	$push0=, 2
	i32.store	0($pop1), $pop0
	i32.const	$push2=, 3
	.endfunc
.Lfunc_end1:
	.size	return_i32_twice, .Lfunc_end1-return_i32_twice


