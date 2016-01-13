	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/991216-1.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32, i64, i32
# BB#0:                                 # %entry
	block   	.LBB0_4
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_4
# BB#1:                                 # %entry
	i64.const	$push2=, 81985529216486895
	i64.ne  	$push3=, $1, $pop2
	br_if   	$pop3, .LBB0_4
# BB#2:                                 # %entry
	i32.const	$push4=, 85
	i32.ne  	$push5=, $2, $pop4
	br_if   	$pop5, .LBB0_4
# BB#3:                                 # %if.end
	return
.LBB0_4:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1

	.section	.text.test2,"ax",@progbits
	.hidden	test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	.LBB1_5
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB1_5
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, .LBB1_5
# BB#2:                                 # %entry
	i64.const	$push4=, 81985529216486895
	i64.ne  	$push5=, $2, $pop4
	br_if   	$pop5, .LBB1_5
# BB#3:                                 # %entry
	i32.const	$push6=, 85
	i32.ne  	$push7=, $3, $pop6
	br_if   	$pop7, .LBB1_5
# BB#4:                                 # %if.end
	return
.LBB1_5:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	test2, .Lfunc_end1-test2

	.section	.text.test3,"ax",@progbits
	.hidden	test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.param  	i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	.LBB2_6
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB2_6
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, .LBB2_6
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	$pop5, .LBB2_6
# BB#3:                                 # %entry
	i64.const	$push6=, 81985529216486895
	i64.ne  	$push7=, $3, $pop6
	br_if   	$pop7, .LBB2_6
# BB#4:                                 # %entry
	i32.const	$push8=, 85
	i32.ne  	$push9=, $4, $pop8
	br_if   	$pop9, .LBB2_6
# BB#5:                                 # %if.end
	return
.LBB2_6:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end2:
	.size	test3, .Lfunc_end2-test3

	.section	.text.test4,"ax",@progbits
	.hidden	test4
	.globl	test4
	.type	test4,@function
test4:                                  # @test4
	.param  	i32, i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	.LBB3_7
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB3_7
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, .LBB3_7
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	$pop5, .LBB3_7
# BB#3:                                 # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	$pop7, .LBB3_7
# BB#4:                                 # %entry
	i64.const	$push8=, 81985529216486895
	i64.ne  	$push9=, $4, $pop8
	br_if   	$pop9, .LBB3_7
# BB#5:                                 # %entry
	i32.const	$push10=, 85
	i32.ne  	$push11=, $5, $pop10
	br_if   	$pop11, .LBB3_7
# BB#6:                                 # %if.end
	return
.LBB3_7:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end3:
	.size	test4, .Lfunc_end3-test4

	.section	.text.test5,"ax",@progbits
	.hidden	test5
	.globl	test5
	.type	test5,@function
test5:                                  # @test5
	.param  	i32, i32, i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	.LBB4_8
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB4_8
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, .LBB4_8
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	$pop5, .LBB4_8
# BB#3:                                 # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	$pop7, .LBB4_8
# BB#4:                                 # %entry
	i32.const	$push8=, 5
	i32.ne  	$push9=, $4, $pop8
	br_if   	$pop9, .LBB4_8
# BB#5:                                 # %entry
	i64.const	$push10=, 81985529216486895
	i64.ne  	$push11=, $5, $pop10
	br_if   	$pop11, .LBB4_8
# BB#6:                                 # %entry
	i32.const	$push12=, 85
	i32.ne  	$push13=, $6, $pop12
	br_if   	$pop13, .LBB4_8
# BB#7:                                 # %if.end
	return
.LBB4_8:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end4:
	.size	test5, .Lfunc_end4-test5

	.section	.text.test6,"ax",@progbits
	.hidden	test6
	.globl	test6
	.type	test6,@function
test6:                                  # @test6
	.param  	i32, i32, i32, i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	.LBB5_9
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB5_9
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, .LBB5_9
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	$pop5, .LBB5_9
# BB#3:                                 # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	$pop7, .LBB5_9
# BB#4:                                 # %entry
	i32.const	$push8=, 5
	i32.ne  	$push9=, $4, $pop8
	br_if   	$pop9, .LBB5_9
# BB#5:                                 # %entry
	i32.const	$push10=, 6
	i32.ne  	$push11=, $5, $pop10
	br_if   	$pop11, .LBB5_9
# BB#6:                                 # %entry
	i64.const	$push12=, 81985529216486895
	i64.ne  	$push13=, $6, $pop12
	br_if   	$pop13, .LBB5_9
# BB#7:                                 # %entry
	i32.const	$push14=, 85
	i32.ne  	$push15=, $7, $pop14
	br_if   	$pop15, .LBB5_9
# BB#8:                                 # %if.end
	return
.LBB5_9:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end5:
	.size	test6, .Lfunc_end5-test6

	.section	.text.test7,"ax",@progbits
	.hidden	test7
	.globl	test7
	.type	test7,@function
test7:                                  # @test7
	.param  	i32, i32, i32, i32, i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	.LBB6_10
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB6_10
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, .LBB6_10
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	$pop5, .LBB6_10
# BB#3:                                 # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	$pop7, .LBB6_10
# BB#4:                                 # %entry
	i32.const	$push8=, 5
	i32.ne  	$push9=, $4, $pop8
	br_if   	$pop9, .LBB6_10
# BB#5:                                 # %entry
	i32.const	$push10=, 6
	i32.ne  	$push11=, $5, $pop10
	br_if   	$pop11, .LBB6_10
# BB#6:                                 # %entry
	i32.const	$push12=, 7
	i32.ne  	$push13=, $6, $pop12
	br_if   	$pop13, .LBB6_10
# BB#7:                                 # %entry
	i64.const	$push14=, 81985529216486895
	i64.ne  	$push15=, $7, $pop14
	br_if   	$pop15, .LBB6_10
# BB#8:                                 # %entry
	i32.const	$push16=, 85
	i32.ne  	$push17=, $8, $pop16
	br_if   	$pop17, .LBB6_10
# BB#9:                                 # %if.end
	return
.LBB6_10:                               # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end6:
	.size	test7, .Lfunc_end6-test7

	.section	.text.test8,"ax",@progbits
	.hidden	test8
	.globl	test8
	.type	test8,@function
test8:                                  # @test8
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i64, i32
# BB#0:                                 # %entry
	block   	.LBB7_11
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB7_11
# BB#1:                                 # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, .LBB7_11
# BB#2:                                 # %entry
	i32.const	$push4=, 3
	i32.ne  	$push5=, $2, $pop4
	br_if   	$pop5, .LBB7_11
# BB#3:                                 # %entry
	i32.const	$push6=, 4
	i32.ne  	$push7=, $3, $pop6
	br_if   	$pop7, .LBB7_11
# BB#4:                                 # %entry
	i32.const	$push8=, 5
	i32.ne  	$push9=, $4, $pop8
	br_if   	$pop9, .LBB7_11
# BB#5:                                 # %entry
	i32.const	$push10=, 6
	i32.ne  	$push11=, $5, $pop10
	br_if   	$pop11, .LBB7_11
# BB#6:                                 # %entry
	i32.const	$push12=, 7
	i32.ne  	$push13=, $6, $pop12
	br_if   	$pop13, .LBB7_11
# BB#7:                                 # %entry
	i32.const	$push14=, 8
	i32.ne  	$push15=, $7, $pop14
	br_if   	$pop15, .LBB7_11
# BB#8:                                 # %entry
	i64.const	$push16=, 81985529216486895
	i64.ne  	$push17=, $8, $pop16
	br_if   	$pop17, .LBB7_11
# BB#9:                                 # %entry
	i32.const	$push18=, 85
	i32.ne  	$push19=, $9, $pop18
	br_if   	$pop19, .LBB7_11
# BB#10:                                # %if.end
	return
.LBB7_11:                               # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end7:
	.size	test8, .Lfunc_end7-test8

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
.Lfunc_end8:
	.size	main, .Lfunc_end8-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
