	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/950621-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block   	.LBB0_3
	i32.const	$push3=, 0
	i32.eq  	$push4=, $0, $pop3
	br_if   	$pop4, .LBB0_3
# BB#1:                                 # %land.lhs.true
	i32.const	$1=, -1
	i32.load	$push0=, 0($0)
	i32.ne  	$push1=, $pop0, $1
	br_if   	$pop1, .LBB0_3
# BB#2:                                 # %land.rhs
	i32.load	$push2=, 4($0)
	i32.eq  	$2=, $pop2, $1
.LBB0_3:                                  # %land.end
	return  	$2
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %f.exit
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
