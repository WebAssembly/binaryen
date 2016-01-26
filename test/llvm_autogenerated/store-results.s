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
	.endfunc
.Lfunc_end0:
	.size	single_block, .Lfunc_end0-single_block

	.globl	foo
	.type	foo,@function
foo:
	.local  	i32
	i32.const	$0=, 0
.LBB1_1:
	loop
	i32.const	$push4=, 0
	i32.const	$push3=, 0
	i32.store	$discard=, pos($pop4), $pop3
	i32.const	$push2=, 1
	i32.add 	$0=, $0, $pop2
	i32.const	$push1=, 256
	i32.ne  	$push0=, $0, $pop1
	br_if   	$pop0, 0
	end_loop
	return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.globl	bar
	.type	bar,@function
bar:
	.local  	f32
	f32.const	$0=, 0x0p0
.LBB2_1:
	loop
	i32.const	$push4=, 0
	i32.const	$push3=, 0
	i32.store	$discard=, pos($pop4), $pop3
	f32.const	$push2=, 0x1p0
	f32.add 	$0=, $0, $pop2
	f32.const	$push1=, 0x1p8
	f32.ne  	$push0=, $0, $pop1
	br_if   	$pop0, 0
	end_loop
	return
	.endfunc
.Lfunc_end2:
	.size	bar, .Lfunc_end2-bar

	.type	pos,@object
	.bss
	.globl	pos
	.p2align	2
pos:
	.skip	12
	.size	pos, 12


