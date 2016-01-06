	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/cvt-1.c"
	.globl	g2
	.type	g2,@function
g2:                                     # @g2
	.param  	f64
	.result 	i32
# BB#0:                                 # %entry
	i32.trunc_s/f64	$push0=, $0
	return  	$pop0
func_end0:
	.size	g2, func_end0-g2

	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	f64
# BB#0:                                 # %if.end
	f64.convert_s/i32	$push0=, $0
	return  	$pop0
func_end1:
	.size	f, func_end1-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end6
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
