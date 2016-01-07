	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020904-1.c"
	.globl	fun
	.type	fun,@function
fun:                                    # @fun
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 255
	i32.div_u	$push1=, $pop0, $0
	return  	$pop1
.Lfunc_end0:
	.size	fun, .Lfunc_end0-fun

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
