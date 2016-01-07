	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010221-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.load	$0=, n($3)
	i32.const	$2=, 45
	i32.const	$1=, 1
	block   	.LBB0_4
	i32.lt_s	$push0=, $0, $1
	br_if   	$pop0, .LBB0_4
.LBB0_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_2
	i32.select	$2=, $3, $3, $2
	i32.add 	$3=, $3, $1
	i32.lt_s	$push1=, $3, $0
	br_if   	$pop1, .LBB0_1
.LBB0_2:                                  # %for.end
	i32.ne  	$push2=, $2, $1
	br_if   	$pop2, .LBB0_4
# BB#3:                                 # %if.end5
	i32.const	$push3=, 0
	call    	exit, $pop3
	unreachable
.LBB0_4:                                  # %if.then4
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	n,@object               # @n
	.data
	.globl	n
	.align	2
n:
	.int32	2                       # 0x2
	.size	n, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
