	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/return-void.ll"
	.globl	return_void
	.type	return_void,@function
return_void:
	.endfunc
.Lfunc_end0:
	.size	return_void, .Lfunc_end0-return_void

	.globl	return_void_twice
	.type	return_void_twice,@function
return_void_twice:
	.param  	i32
	block   	
	i32.eqz 	$push4=, $0
	br_if   	0, $pop4
	i32.const	$push2=, 0
	i32.const	$push3=, 0
	i32.store	0($pop2), $pop3
	return
.LBB1_2:
	end_block
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	0($pop1), $pop0
	.endfunc
.Lfunc_end1:
	.size	return_void_twice, .Lfunc_end1-return_void_twice


