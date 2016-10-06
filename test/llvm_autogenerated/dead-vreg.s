	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/dead-vreg.ll"
	.globl	foo
	.type	foo,@function
foo:
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32
	block   	
	i32.const	$push3=, 1
	i32.lt_s	$push0=, $2, $pop3
	br_if   	0, $pop0
	i32.const	$push1=, 2
	i32.shl 	$3=, $1, $pop1
	i32.const	$5=, 0
	i32.const	$push4=, 1
	i32.lt_s	$4=, $1, $pop4
.LBB0_2:
	loop    	
	block   	
	br_if   	0, $4
	i32.const	$6=, 0
	copy_local	$7=, $0
	copy_local	$8=, $1
.LBB0_4:
	loop    	
	i32.store	0($7), $6
	i32.add 	$6=, $6, $5
	i32.const	$push8=, 4
	i32.add 	$7=, $7, $pop8
	i32.const	$push7=, -1
	i32.add 	$push6=, $8, $pop7
	tee_local	$push5=, $8=, $pop6
	br_if   	0, $pop5
.LBB0_5:
	end_loop
	end_block
	i32.add 	$0=, $0, $3
	i32.const	$push11=, 1
	i32.add 	$push10=, $5, $pop11
	tee_local	$push9=, $5=, $pop10
	i32.ne  	$push2=, $pop9, $2
	br_if   	0, $pop2
.LBB0_6:
	end_loop
	end_block
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


