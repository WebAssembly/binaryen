	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/vrp-5.c"
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 4
	block   	BB0_6
	i32.le_u	$push0=, $0, $2
	br_if   	$pop0, BB0_6
# BB#1:                                 # %if.end
	block   	BB0_5
	i32.le_u	$push1=, $1, $2
	br_if   	$pop1, BB0_5
# BB#2:                                 # %if.end3
	block   	BB0_4
	i32.const	$push2=, 0
	i32.sub 	$push3=, $pop2, $1
	i32.ne  	$push4=, $0, $pop3
	br_if   	$pop4, BB0_4
# BB#3:                                 # %if.end6
	return
BB0_4:                                  # %if.then5
	call    	abort
	unreachable
BB0_5:                                  # %if.then2
	call    	abort
	unreachable
BB0_6:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	test, func_end0-test

	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
