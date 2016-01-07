	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/931102-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 1
	i32.const	$2=, 0
	block   	.LBB0_2
	i32.and 	$push0=, $0, $1
	br_if   	$pop0, .LBB0_2
.LBB0_1:                                  # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_2
	i32.const	$push1=, 24
	i32.shl 	$push2=, $0, $pop1
	i32.const	$push3=, 25
	i32.shr_s	$0=, $pop2, $pop3
	i32.add 	$2=, $2, $1
	i32.and 	$push4=, $0, $1
	i32.const	$push5=, 0
	i32.eq  	$push6=, $pop4, $pop5
	br_if   	$pop6, .LBB0_1
.LBB0_2:                                  # %while.end
	return  	$2
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
