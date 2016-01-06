	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/991019-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	f64
	.result 	f64
# BB#0:                                 # %entry
	f64.const	$push0=, 0x1p0
	f64.add 	$push1=, $0, $pop0
	return  	$pop1
func_end0:
	.size	foo, func_end0-foo

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


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
