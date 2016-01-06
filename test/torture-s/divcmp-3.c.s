	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/divcmp-3.c"
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -300
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 100
	i32.lt_u	$push3=, $pop1, $pop2
	return  	$pop3
func_end0:
	.size	test1, func_end0-test1

	.globl	test1u
	.type	test1u,@function
test1u:                                 # @test1u
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	test1u, func_end1-test1u

	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -300
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 99
	i32.gt_u	$push3=, $pop1, $pop2
	return  	$pop3
func_end2:
	.size	test2, func_end2-test2

	.globl	test2u
	.type	test2u,@function
test2u:                                 # @test2u
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
func_end3:
	.size	test2u, func_end3-test2u

	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
func_end4:
	.size	test3, func_end4-test3

	.globl	test3u
	.type	test3u,@function
test3u:                                 # @test3u
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
func_end5:
	.size	test3u, func_end5-test3u

	.globl	test4
	.type	test4,@function
test4:                                  # @test4
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
func_end6:
	.size	test4, func_end6-test4

	.globl	test4u
	.type	test4u,@function
test4u:                                 # @test4u
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
func_end7:
	.size	test4u, func_end7-test4u

	.globl	test5
	.type	test5,@function
test5:                                  # @test5
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end8:
	.size	test5, func_end8-test5

	.globl	test5u
	.type	test5u,@function
test5u:                                 # @test5u
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end9:
	.size	test5u, func_end9-test5u

	.globl	test6
	.type	test6,@function
test6:                                  # @test6
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end10:
	.size	test6, func_end10-test6

	.globl	test6u
	.type	test6u,@function
test6u:                                 # @test6u
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end11:
	.size	test6u, func_end11-test6u

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, -128
	i32.const	$0=, -2147483648
BB12_1:                                 # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	BB12_4
	loop    	BB12_3
	i32.const	$push0=, 24
	i32.shr_s	$push1=, $0, $pop0
	i32.const	$push2=, -300
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push5=, 99
	i32.le_u	$push6=, $pop3, $pop5
	br_if   	$pop6, BB12_4
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB12_1 Depth=1
	i32.const	$push4=, 1
	i32.add 	$1=, $1, $pop4
	i32.const	$push7=, 16777216
	i32.add 	$0=, $0, $pop7
	i32.const	$push8=, 255
	i32.le_s	$push9=, $1, $pop8
	br_if   	$pop9, BB12_1
BB12_3:                                 # %for.end
	i32.const	$push10=, 0
	return  	$pop10
BB12_4:                                 # %if.then
	call    	abort
	unreachable
func_end12:
	.size	main, func_end12-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
