	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020418-1.c"
	.globl	gcc_crash
	.type	gcc_crash,@function
gcc_crash:                              # @gcc_crash
	.param  	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.load	$1=, 0($0)
	copy_local	$2=, $1
	block   	BB0_3
	i32.const	$push0=, 52
	i32.lt_s	$push1=, $1, $pop0
	br_if   	$pop1, BB0_3
BB0_1:                                  # %top
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_2
	i32.const	$push4=, 1
	i32.add 	$2=, $2, $pop4
	i32.const	$push2=, 60
	i32.gt_s	$push3=, $1, $pop2
	br_if   	$pop3, BB0_1
BB0_2:                                  # %if.end6
	i32.store	$discard=, 0($0), $2
	return
BB0_3:                                  # %if.then
	unreachable
	unreachable
func_end0:
	.size	gcc_crash, func_end0-gcc_crash

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %gcc_crash.exit
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
