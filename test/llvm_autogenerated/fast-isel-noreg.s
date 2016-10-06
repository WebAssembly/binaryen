	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/fast-isel-noreg.ll"
	.hidden	a
	.globl	a
	.type	a,@function
a:
	.result 	i32
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	a, .Lfunc_end0-a

	.hidden	b
	.globl	b
	.type	b,@function
b:
	.result 	i32
	block   	
	i32.const	$push0=, 1
	br_if   	0, $pop0
	unreachable
.LBB1_2:
	end_block
	i32.const	$push1=, 0
	return  	$pop1
	.endfunc
.Lfunc_end1:
	.size	b, .Lfunc_end1-b

	.hidden	c
	.globl	c
	.type	c,@function
c:
	.result 	i32
	i32.const	$push1=, 0
	i32.const	$push2=, 0
	i32.store	0($pop1), $pop2
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	c, .Lfunc_end2-c


