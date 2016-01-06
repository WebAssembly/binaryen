	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021127-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end0:
	.size	main, func_end0-main

	.globl	llabs
	.type	llabs,@function
llabs:                                  # @llabs
	.param  	i64
	.result 	i64
# BB#0:                                 # %entry
	call    	abort
	unreachable
func_end1:
	.size	llabs, func_end1-llabs

	.type	a,@object               # @a
	.data
	.globl	a
	.align	3
a:
	.int64	-1                      # 0xffffffffffffffff
	.size	a, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
