	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr36321.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	return
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.load	$discard=, argp($2)
	return  	$2
func_end1:
	.size	main, func_end1-main

	.type	argp,@object            # @argp
	.data
	.align	2
argp:
	.int32	.str
	.size	argp, 4

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"pr36321.x"
	.size	.str, 10


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
