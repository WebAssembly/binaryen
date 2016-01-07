	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/990827-1.c"
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 1
	i32.and 	$push0=, $1, $2
	i32.add 	$push2=, $pop0, $2
	i32.shr_u	$push3=, $pop2, $2
	i32.shr_u	$push1=, $0, $2
	i32.add 	$push4=, $pop3, $pop1
	return  	$pop4
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end8
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
