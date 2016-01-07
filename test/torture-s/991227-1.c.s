	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/991227-1.c"
	.globl	doit
	.type	doit,@function
doit:                                   # @doit
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, .str
	i32.const	$push0=, .str.1
	i32.select	$push2=, $0, $pop1, $pop0
	i32.const	$push3=, 1
	i32.add 	$push4=, $pop2, $pop3
	return  	$pop4
.Lfunc_end0:
	.size	doit, .Lfunc_end0-doit

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.then
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.str,@object            # @.str
	.section	.rodata.cst8,"aM",@progbits,8
.str:
	.asciz	"\000wrong\n"
	.size	.str, 8

	.type	.str.1,@object          # @.str.1
.str.1:
	.asciz	"\000right\n"
	.size	.str.1, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
