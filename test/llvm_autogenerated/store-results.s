	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/store-results.ll"
	.globl	single_block
	.type	single_block,@function
single_block:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 0
	i32.store	$push1=, 0($0), $pop0
	return  	$pop1
func_end0:
	.size	single_block, func_end0-single_block

	.globl	foo
	.type	foo,@function
foo:
	.local  	i32, i32
	i32.const	$0=, 0
	copy_local	$1=, $0
BB1_1:
	loop    	BB1_2
	i32.const	$push0=, 1
	i32.add 	$1=, $1, $pop0
	i32.store	$discard=, pos($0), $0
	i32.const	$push1=, 256
	i32.ne  	$push2=, $1, $pop1
	br_if   	$pop2, BB1_1
BB1_2:
	return
func_end1:
	.size	foo, func_end1-foo

	.globl	bar
	.type	bar,@function
bar:
	.local  	i32, f32
	f32.const	$1=, 0x0p0
	i32.const	$0=, 0
BB2_1:
	loop    	BB2_2
	i32.store	$discard=, pos($0), $0
	f32.const	$push0=, 0x1p0
	f32.add 	$1=, $1, $pop0
	f32.const	$push1=, 0x1p8
	f32.ne  	$push2=, $1, $pop1
	br_if   	$pop2, BB2_1
BB2_2:
	return
func_end2:
	.size	bar, func_end2-bar

	.type	pos,@object
	.bss
	.globl	pos
	.align	2
pos:
	.zero	12
	.size	pos, 12


	.section	".note.GNU-stack","",@progbits
