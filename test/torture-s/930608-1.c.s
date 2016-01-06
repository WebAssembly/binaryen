	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/930608-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	f64
	.result 	f64
	.local  	f64
# BB#0:                                 # %entry
	return  	$1
func_end0:
	.size	f, func_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	a,@object               # @a
	.section	.data.rel.ro,"aw",@progbits
	.globl	a
	.align	2
a:
	.int32	f
	.size	a, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
