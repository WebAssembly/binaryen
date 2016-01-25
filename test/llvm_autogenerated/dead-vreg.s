	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/dead-vreg.ll"
	.globl	foo
	.type	foo,@function
foo:
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32
	block
	i32.const	$push3=, 1
	i32.lt_s	$push0=, $2, $pop3
	br_if   	$pop0, 0
	i32.const	$push1=, 2
	i32.shl 	$3=, $1, $pop1
	i32.const	$5=, 0
	i32.const	$push4=, 1
	i32.lt_s	$4=, $1, $pop4
.LBB0_2:
	loop
	i32.const	$6=, 0
	copy_local	$7=, $0
	copy_local	$8=, $1
	block
	br_if   	$4, 0
.LBB0_3:
	loop
	i32.store	$discard=, 0($7), $6
	i32.const	$push6=, -1
	i32.add 	$8=, $8, $pop6
	i32.const	$push5=, 4
	i32.add 	$7=, $7, $pop5
	i32.add 	$6=, $6, $5
	br_if   	$8, 0
.LBB0_4:
	end_loop
	end_block
	i32.const	$push7=, 1
	i32.add 	$5=, $5, $pop7
	i32.add 	$0=, $0, $3
	i32.ne  	$push2=, $5, $2
	br_if   	$pop2, 0
.LBB0_5:
	end_loop
	end_block
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


