	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/dead-vreg.ll"
	.globl	foo
	.type	foo,@function
foo:
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32
	block
	i32.const	$push4=, 1
	i32.lt_s	$push1=, $2, $pop4
	br_if   	0, $pop1
	i32.const	$push2=, 2
	i32.shl 	$3=, $1, $pop2
	i32.const	$5=, 0
	i32.const	$push5=, 1
	i32.lt_s	$4=, $1, $pop5
.LBB0_2:
	loop
	block
	br_if   	0, $4
	i32.const	$6=, 0
	copy_local	$7=, $0
	copy_local	$8=, $1
.LBB0_4:
	loop
	i32.store	$push0=, 0($7), $6
	i32.add 	$6=, $pop0, $5
	i32.const	$push9=, 4
	i32.add 	$7=, $7, $pop9
	i32.const	$push8=, -1
	i32.add 	$push7=, $8, $pop8
	tee_local	$push6=, $8=, $pop7
	br_if   	0, $pop6
.LBB0_5:
	end_loop
	end_block
	i32.add 	$0=, $0, $3
	i32.const	$push12=, 1
	i32.add 	$push11=, $5, $pop12
	tee_local	$push10=, $5=, $pop11
	i32.ne  	$push3=, $pop10, $2
	br_if   	0, $pop3
.LBB0_6:
	end_loop
	end_block
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


