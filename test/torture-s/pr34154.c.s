	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr34154.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, -1000000000000000000
	i64.add 	$push1=, $0, $pop0
	i64.const	$push2=, 9000000000000000000
	i64.lt_u	$push3=, $pop1, $pop2
	i32.const	$push5=, 19
	i32.const	$push4=, 20
	i32.select	$push6=, $pop3, $pop5, $pop4
	return  	$pop6
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
