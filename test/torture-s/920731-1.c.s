	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/920731-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 1
	i32.const	$2=, 0
	block   	BB0_3
	i32.and 	$push0=, $0, $1
	br_if   	$pop0, BB0_3
BB0_1:                                  # %for.inc
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_3
	i32.add 	$2=, $2, $1
	i32.const	$push2=, 7
	i32.gt_s	$push3=, $2, $pop2
	br_if   	$pop3, BB0_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.shr_s	$0=, $0, $1
	i32.and 	$push1=, $0, $1
	i32.const	$push4=, 0
	i32.eq  	$push5=, $pop1, $pop4
	br_if   	$pop5, BB0_1
BB0_3:                                  # %for.end
	return  	$2
func_end0:
	.size	f, func_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
