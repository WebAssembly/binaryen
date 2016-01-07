	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000217-1.c"
	.globl	showbug
	.type	showbug,@function
showbug:                                # @showbug
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 65528
	i32.load16_u	$push0=, 0($1)
	i32.load16_u	$push1=, 0($0)
	i32.add 	$push2=, $pop0, $pop1
	i32.add 	$push3=, $pop2, $2
	i32.store16	$push4=, 0($0), $pop3
	i32.and 	$push5=, $pop4, $2
	i32.const	$push6=, 7
	i32.gt_u	$push7=, $pop5, $pop6
	return  	$pop7
.Lfunc_end0:
	.size	showbug, .Lfunc_end0-showbug

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
