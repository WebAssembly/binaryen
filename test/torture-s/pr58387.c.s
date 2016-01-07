	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58387.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_2
	i32.load	$push0=, a($0)
	i32.ge_s	$push1=, $pop0, $0
	br_if   	$pop1, .LBB0_2
# BB#1:                                 # %if.end
	return  	$0
.LBB0_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	a,@object               # @a
	.data
	.globl	a
	.align	2
a:
	.int32	4294967295              # 0xffffffff
	.size	a, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
