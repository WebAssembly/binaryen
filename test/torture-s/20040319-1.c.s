	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040319-1.c"
	.globl	blah
	.type	blah,@function
blah:                                   # @blah
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $0, $pop0
	i32.const	$push4=, 1
	i32.const	$push2=, 0
	i32.sub 	$push3=, $pop2, $0
	i32.select	$push5=, $pop1, $pop4, $pop3
	return  	$pop5
func_end0:
	.size	blah, func_end0-blah

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.else
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
