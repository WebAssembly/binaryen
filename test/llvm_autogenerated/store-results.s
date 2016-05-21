	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/store-results.ll"
	.globl	single_block
	.type	single_block,@function
single_block:
	.param  	i32
	.result 	i32
	i32.const	$push1=, 0
	i32.store	$push0=, 0($0), $pop1
	return  	$pop0
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
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i32.store	$drop=, pos($pop6), $pop5
	i32.const	$push4=, 1
	i32.add 	$push3=, $0, $pop4
	tee_local	$push2=, $0=, $pop3
	i32.const	$push1=, 256
	i32.ne  	$push0=, $pop2, $pop1
	br_if   	0, $pop0
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
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i32.store	$drop=, pos($pop6), $pop5
	f32.const	$push4=, 0x1p0
	f32.add 	$push3=, $0, $pop4
	tee_local	$push2=, $0=, $pop3
	f32.const	$push1=, 0x1p8
	f32.ne  	$push0=, $pop2, $pop1
	br_if   	0, $pop0
	end_loop
	return
	.endfunc
.Lfunc_end2:
	.size	bar, .Lfunc_end2-bar

	.hidden	fi_ret
	.globl	fi_ret
	.type	fi_ret,@function
fi_ret:
	.param  	i32
	.result 	i32
	i32.const	$push1=, __stack_pointer
	i32.load	$push2=, 0($pop1)
	i32.const	$push3=, 32
	i32.sub 	$push4=, $pop2, $pop3
	i32.store	$push0=, 0($0), $pop4
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	fi_ret, .Lfunc_end3-fi_ret

	.type	pos,@object
	.bss
	.globl	pos
	.p2align	2
pos:
	.skip	12
	.size	pos, 12


