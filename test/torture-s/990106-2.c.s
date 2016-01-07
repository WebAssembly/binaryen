	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/990106-2.c"
	.globl	calc_mp
	.type	calc_mp,@function
calc_mp:                                # @calc_mp
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.rem_u	$push1=, $pop0, $0
	i32.const	$push2=, 1
	i32.add 	$1=, $pop1, $pop2
	i32.gt_u	$push3=, $1, $0
	i32.const	$push4=, 0
	i32.select	$push5=, $pop3, $0, $pop4
	i32.sub 	$push6=, $1, $pop5
	return  	$pop6
.Lfunc_end0:
	.size	calc_mp, .Lfunc_end0-calc_mp

	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
