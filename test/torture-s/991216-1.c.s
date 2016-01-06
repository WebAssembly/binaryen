	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/991216-1.c"
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32, i64, i32
# BB#0:                                 # %entry
	block   	BB0_4
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, BB0_4
# BB#1:                                 # %entry
	i64.const	$push2=, 81985529216486895
	i64.ne  	$push3=, $1, $pop2
	br_if   	$pop3, BB0_4
# BB#2:                                 # %entry
	i32.const	$push4=, 85
	i32.ne  	$push5=, $2, $pop4
	br_if   	$pop5, BB0_4
# BB#3:                                 # %if.end
	return
BB0_4:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	test1, func_end0-test1

	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	BB1_5
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, BB1_5
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, BB1_5
# BB#2:                                 # %entry
	i64.const	$push4=, 81985529216486895
	i64.ne  	$push5=, $2, $pop4
	br_if   	$pop5, BB1_5
# BB#3:                                 # %entry
	i32.const	$push6=, 85
	i32.ne  	$push7=, $3, $pop6
	br_if   	$pop7, BB1_5
# BB#4:                                 # %if.end
	return
BB1_5:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	test2, func_end1-test2

	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.param  	i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	BB2_6
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, BB2_6
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, BB2_6
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	$pop5, BB2_6
# BB#3:                                 # %entry
	i64.const	$push6=, 81985529216486895
	i64.ne  	$push7=, $3, $pop6
	br_if   	$pop7, BB2_6
# BB#4:                                 # %entry
	i32.const	$push8=, 85
	i32.ne  	$push9=, $4, $pop8
	br_if   	$pop9, BB2_6
# BB#5:                                 # %if.end
	return
BB2_6:                                  # %if.then
	call    	abort
	unreachable
func_end2:
	.size	test3, func_end2-test3

	.globl	test4
	.type	test4,@function
test4:                                  # @test4
	.param  	i32, i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	BB3_7
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, BB3_7
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, BB3_7
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	$pop5, BB3_7
# BB#3:                                 # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	$pop7, BB3_7
# BB#4:                                 # %entry
	i64.const	$push8=, 81985529216486895
	i64.ne  	$push9=, $4, $pop8
	br_if   	$pop9, BB3_7
# BB#5:                                 # %entry
	i32.const	$push10=, 85
	i32.ne  	$push11=, $5, $pop10
	br_if   	$pop11, BB3_7
# BB#6:                                 # %if.end
	return
BB3_7:                                  # %if.then
	call    	abort
	unreachable
func_end3:
	.size	test4, func_end3-test4

	.globl	test5
	.type	test5,@function
test5:                                  # @test5
	.param  	i32, i32, i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	BB4_8
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, BB4_8
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, BB4_8
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	$pop5, BB4_8
# BB#3:                                 # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	$pop7, BB4_8
# BB#4:                                 # %entry
	i32.const	$push8=, 5
	i32.ne  	$push9=, $4, $pop8
	br_if   	$pop9, BB4_8
# BB#5:                                 # %entry
	i64.const	$push10=, 81985529216486895
	i64.ne  	$push11=, $5, $pop10
	br_if   	$pop11, BB4_8
# BB#6:                                 # %entry
	i32.const	$push12=, 85
	i32.ne  	$push13=, $6, $pop12
	br_if   	$pop13, BB4_8
# BB#7:                                 # %if.end
	return
BB4_8:                                  # %if.then
	call    	abort
	unreachable
func_end4:
	.size	test5, func_end4-test5

	.globl	test6
	.type	test6,@function
test6:                                  # @test6
	.param  	i32, i32, i32, i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	BB5_9
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, BB5_9
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, BB5_9
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	$pop5, BB5_9
# BB#3:                                 # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	$pop7, BB5_9
# BB#4:                                 # %entry
	i32.const	$push8=, 5
	i32.ne  	$push9=, $4, $pop8
	br_if   	$pop9, BB5_9
# BB#5:                                 # %entry
	i32.const	$push10=, 6
	i32.ne  	$push11=, $5, $pop10
	br_if   	$pop11, BB5_9
# BB#6:                                 # %entry
	i64.const	$push12=, 81985529216486895
	i64.ne  	$push13=, $6, $pop12
	br_if   	$pop13, BB5_9
# BB#7:                                 # %entry
	i32.const	$push14=, 85
	i32.ne  	$push15=, $7, $pop14
	br_if   	$pop15, BB5_9
# BB#8:                                 # %if.end
	return
BB5_9:                                  # %if.then
	call    	abort
	unreachable
func_end5:
	.size	test6, func_end5-test6

	.globl	test7
	.type	test7,@function
test7:                                  # @test7
	.param  	i32, i32, i32, i32, i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	BB6_10
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, BB6_10
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, BB6_10
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	$pop5, BB6_10
# BB#3:                                 # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	$pop7, BB6_10
# BB#4:                                 # %entry
	i32.const	$push8=, 5
	i32.ne  	$push9=, $4, $pop8
	br_if   	$pop9, BB6_10
# BB#5:                                 # %entry
	i32.const	$push10=, 6
	i32.ne  	$push11=, $5, $pop10
	br_if   	$pop11, BB6_10
# BB#6:                                 # %entry
	i32.const	$push12=, 7
	i32.ne  	$push13=, $6, $pop12
	br_if   	$pop13, BB6_10
# BB#7:                                 # %entry
	i64.const	$push14=, 81985529216486895
	i64.ne  	$push15=, $7, $pop14
	br_if   	$pop15, BB6_10
# BB#8:                                 # %entry
	i32.const	$push16=, 85
	i32.ne  	$push17=, $8, $pop16
	br_if   	$pop17, BB6_10
# BB#9:                                 # %if.end
	return
BB6_10:                                 # %if.then
	call    	abort
	unreachable
func_end6:
	.size	test7, func_end6-test7

	.globl	test8
	.type	test8,@function
test8:                                  # @test8
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	BB7_11
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, BB7_11
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, BB7_11
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	$pop5, BB7_11
# BB#3:                                 # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	$pop7, BB7_11
# BB#4:                                 # %entry
	i32.const	$push8=, 5
	i32.ne  	$push9=, $4, $pop8
	br_if   	$pop9, BB7_11
# BB#5:                                 # %entry
	i32.const	$push10=, 6
	i32.ne  	$push11=, $5, $pop10
	br_if   	$pop11, BB7_11
# BB#6:                                 # %entry
	i32.const	$push12=, 7
	i32.ne  	$push13=, $6, $pop12
	br_if   	$pop13, BB7_11
# BB#7:                                 # %entry
	i32.const	$push14=, 8
	i32.ne  	$push15=, $7, $pop14
	br_if   	$pop15, BB7_11
# BB#8:                                 # %entry
	i64.const	$push16=, 81985529216486895
	i64.ne  	$push17=, $8, $pop16
	br_if   	$pop17, BB7_11
# BB#9:                                 # %entry
	i32.const	$push18=, 85
	i32.ne  	$push19=, $9, $pop18
	br_if   	$pop19, BB7_11
# BB#10:                                # %if.end
	return
BB7_11:                                 # %if.then
	call    	abort
	unreachable
func_end7:
	.size	test8, func_end7-test8

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end8:
	.size	main, func_end8-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
