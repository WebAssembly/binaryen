	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/941015-1.c"
	.globl	foo1
	.type	foo1,@function
foo1:                                   # @foo1
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, -4611686016279904256
	i64.lt_s	$push1=, $0, $pop0
	i32.const	$push3=, 1
	i32.const	$push2=, 2
	i32.select	$push4=, $pop1, $pop3, $pop2
	return  	$pop4
func_end0:
	.size	foo1, func_end0-foo1

	.globl	foo2
	.type	foo2,@function
foo2:                                   # @foo2
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, -4611686016279904256
	i64.lt_u	$push1=, $0, $pop0
	i32.const	$push3=, 1
	i32.const	$push2=, 2
	i32.select	$push4=, $pop1, $pop3, $pop2
	return  	$pop4
func_end1:
	.size	foo2, func_end1-foo2

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
