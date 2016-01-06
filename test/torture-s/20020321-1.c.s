	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020321-1.c"
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32, i32, i32, f32
	.result 	f32
# BB#0:                                 # %entry
	return  	$4
func_end0:
	.size	g, func_end0-g

	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, f32
	.result 	f32
# BB#0:                                 # %entry
	return  	$3
func_end1:
	.size	f, func_end1-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
