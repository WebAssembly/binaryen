	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030120-2.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 3
	i32.const	$2=, 4
	i32.eq  	$push4=, $0, $2
	i32.eq  	$push2=, $0, $1
	i32.const	$push0=, 1
	i32.eq  	$push1=, $0, $pop0
	i32.select	$push3=, $pop2, $1, $pop1
	i32.select	$push5=, $pop4, $2, $pop3
	return  	$pop5
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
