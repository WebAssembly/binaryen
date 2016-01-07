	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr31072.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_2
	i32.load	$push0=, ReadyFlag_NotProperlyInitialized($0)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB0_2
# BB#1:                                 # %if.end
	return  	$0
.LBB0_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	ReadyFlag_NotProperlyInitialized,@object # @ReadyFlag_NotProperlyInitialized
	.data
	.globl	ReadyFlag_NotProperlyInitialized
	.align	2
ReadyFlag_NotProperlyInitialized:
	.int32	1                       # 0x1
	.size	ReadyFlag_NotProperlyInitialized, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
