	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030903-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block   	BB0_2
	i32.load	$push0=, test($1)
	i32.const	$push1=, -1
	i32.add 	$0=, $pop0, $pop1
	i32.const	$push2=, 3
	i32.le_u	$push3=, $0, $pop2
	br_if   	$pop3, BB0_2
# BB#1:                                 # %sw.epilog
	return  	$1
BB0_2:                                  # %entry
	block   	BB0_6
	block   	BB0_5
	block   	BB0_4
	block   	BB0_3
	tableswitch	$0, BB0_3, BB0_3, BB0_4, BB0_5, BB0_6
BB0_3:                                  # %sw.bb
	call    	y
	unreachable
BB0_4:                                  # %sw.bb1
	call    	y
	unreachable
BB0_5:                                  # %sw.bb2
	call    	y
	unreachable
BB0_6:                                  # %sw.bb3
	call    	y
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	y,@function
y:                                      # @y
# BB#0:                                 # %entry
	call    	abort
	unreachable
func_end1:
	.size	y, func_end1-y

	.type	test,@object            # @test
	.lcomm	test,4,2

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
