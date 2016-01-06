	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20101011-1.c"
	.globl	sigfpe
	.type	sigfpe,@function
sigfpe:                                 # @sigfpe
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end0:
	.size	sigfpe, func_end0-sigfpe

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.const	$push0=, sigfpe
	i32.call	$discard=, signal, $pop1, $pop0
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	k,@object               # @k
	.bss
	.globl	k
	.align	2
k:
	.int32	0                       # 0x0
	.size	k, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
