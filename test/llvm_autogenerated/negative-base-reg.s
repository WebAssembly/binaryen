	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/negative-base-reg.ll"
	.hidden	main
	.globl	main
	.type	main,@function
main:
	.result 	i32
	.local  	i32
	i32.const	$0=, -128
.LBB0_1:
	loop    	
	i32.const	$push6=, args+128
	i32.add 	$push0=, $0, $pop6
	i32.const	$push5=, 1
	i32.store	0($pop0), $pop5
	i32.const	$push4=, 4
	i32.add 	$push3=, $0, $pop4
	tee_local	$push2=, $0=, $pop3
	br_if   	0, $pop2
	end_loop
	i32.const	$push1=, 0
	return  	$pop1
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	args
	.type	args,@object
	.bss
	.globl	args
	.p2align	4
args:
	.skip	128
	.size	args, 128


	.ident	"clang version 4.0.0 (trunk 279056) (llvm/trunk 279074)"
