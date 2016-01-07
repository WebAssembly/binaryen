	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010222-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_2
	i32.load	$push1=, a+4($0)
	i32.load	$push0=, a($0)
	i32.add 	$push2=, $pop1, $pop0
	i32.const	$push3=, -3
	i32.mul 	$push4=, $pop2, $pop3
	i32.const	$push5=, 83
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push7=, 12
	i32.lt_u	$push8=, $pop6, $pop7
	br_if   	$pop8, .LBB0_2
# BB#1:                                 # %if.then
	call    	abort
	unreachable
.LBB0_2:                                  # %if.end
	call    	exit, $0
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	a,@object               # @a
	.data
	.globl	a
	.align	2
a:
	.int32	18                      # 0x12
	.int32	6                       # 0x6
	.size	a, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
