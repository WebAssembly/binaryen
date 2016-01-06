	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/vrp-6.c"
	.globl	test01
	.type	test01,@function
test01:                                 # @test01
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
	i32.sub 	$push2=, $0, $1
	i32.const	$push3=, 5
	i32.ne  	$push4=, $pop2, $pop3
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
	.size	test01, func_end0-test01

	.globl	test02
	.type	test02,@function
test02:                                 # @test02
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	BB1_4
	i32.const	$push1=, 12
	i32.lt_u	$push2=, $0, $pop1
	br_if   	$pop2, BB1_4
# BB#1:                                 # %entry
	i32.const	$push3=, 16
	i32.lt_u	$push4=, $1, $pop3
	br_if   	$pop4, BB1_4
# BB#2:                                 # %entry
	i32.sub 	$push0=, $0, $1
	i32.const	$push5=, -17
	i32.gt_u	$push6=, $pop0, $pop5
	br_if   	$pop6, BB1_4
# BB#3:                                 # %if.then4
	call    	abort
	unreachable
BB1_4:                                  # %if.end6
	return
func_end1:
	.size	test02, func_end1-test02

	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
