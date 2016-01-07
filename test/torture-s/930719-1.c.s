	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/930719-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB0_5
	br_if   	$0, .LBB0_5
# BB#1:                                 # %while.body.preheader
	block   	.LBB0_4
	i32.const	$push0=, 1
	i32.ne  	$push1=, $1, $pop0
	br_if   	$pop1, .LBB0_4
# BB#2:                                 # %sw.bb.split
	br_if   	$2, .LBB0_5
# BB#3:                                 # %if.end2
	unreachable
	unreachable
.LBB0_4:                                  # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_5
	br      	.LBB0_4
.LBB0_5:                                  # %cleanup
	i32.const	$push2=, 0
	return  	$pop2
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
