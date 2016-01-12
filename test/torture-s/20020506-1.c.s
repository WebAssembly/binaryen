	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020506-1.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	.LBB0_5
	block   	.LBB0_4
	block   	.LBB0_3
	i32.const	$push0=, 0
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_3
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	i32.eq  	$push3=, $1, $pop2
	br_if   	$pop3, .LBB0_4
# BB#2:                                 # %if.then2
	call    	abort@FUNCTION
	unreachable
.LBB0_3:                                # %if.else
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, .LBB0_5
.LBB0_4:                                # %if.end45
	return
.LBB0_5:                                # %if.then4
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1

	.section	.text.test2,"ax",@progbits
	.hidden	test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 24
	block   	.LBB1_5
	block   	.LBB1_4
	block   	.LBB1_3
	i32.shl 	$push0=, $0, $2
	i32.shr_s	$push1=, $pop0, $2
	i32.const	$push2=, 0
	i32.lt_s	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB1_3
# BB#1:                                 # %if.then
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, .LBB1_4
# BB#2:                                 # %if.then2
	call    	abort@FUNCTION
	unreachable
.LBB1_3:                                # %if.else
	i32.const	$push6=, 0
	i32.eq  	$push7=, $1, $pop6
	br_if   	$pop7, .LBB1_5
.LBB1_4:                                # %if.end45
	return
.LBB1_5:                                # %if.then4
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	test2, .Lfunc_end1-test2

	.section	.text.test3,"ax",@progbits
	.hidden	test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	.LBB2_5
	block   	.LBB2_4
	block   	.LBB2_3
	i32.const	$push0=, 0
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, .LBB2_3
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	i32.eq  	$push3=, $1, $pop2
	br_if   	$pop3, .LBB2_4
# BB#2:                                 # %if.then2
	call    	abort@FUNCTION
	unreachable
.LBB2_3:                                # %if.else
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, .LBB2_5
.LBB2_4:                                # %if.end45
	return
.LBB2_5:                                # %if.then4
	call    	abort@FUNCTION
	unreachable
.Lfunc_end2:
	.size	test3, .Lfunc_end2-test3

	.section	.text.test4,"ax",@progbits
	.hidden	test4
	.globl	test4
	.type	test4,@function
test4:                                  # @test4
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 16
	block   	.LBB3_5
	block   	.LBB3_4
	block   	.LBB3_3
	i32.shl 	$push0=, $0, $2
	i32.shr_s	$push1=, $pop0, $2
	i32.const	$push2=, 0
	i32.lt_s	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB3_3
# BB#1:                                 # %if.then
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, .LBB3_4
# BB#2:                                 # %if.then2
	call    	abort@FUNCTION
	unreachable
.LBB3_3:                                # %if.else
	i32.const	$push6=, 0
	i32.eq  	$push7=, $1, $pop6
	br_if   	$pop7, .LBB3_5
.LBB3_4:                                # %if.end45
	return
.LBB3_5:                                # %if.then4
	call    	abort@FUNCTION
	unreachable
.Lfunc_end3:
	.size	test4, .Lfunc_end3-test4

	.section	.text.test5,"ax",@progbits
	.hidden	test5
	.globl	test5
	.type	test5,@function
test5:                                  # @test5
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	.LBB4_5
	block   	.LBB4_4
	block   	.LBB4_3
	i32.const	$push0=, 0
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, .LBB4_3
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	i32.eq  	$push3=, $1, $pop2
	br_if   	$pop3, .LBB4_4
# BB#2:                                 # %if.then1
	call    	abort@FUNCTION
	unreachable
.LBB4_3:                                # %if.else
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, .LBB4_5
.LBB4_4:                                # %if.end38
	return
.LBB4_5:                                # %if.then3
	call    	abort@FUNCTION
	unreachable
.Lfunc_end4:
	.size	test5, .Lfunc_end4-test5

	.section	.text.test6,"ax",@progbits
	.hidden	test6
	.globl	test6
	.type	test6,@function
test6:                                  # @test6
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	.LBB5_5
	block   	.LBB5_4
	block   	.LBB5_3
	i32.const	$push0=, 0
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, .LBB5_3
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	i32.eq  	$push3=, $1, $pop2
	br_if   	$pop3, .LBB5_4
# BB#2:                                 # %if.then1
	call    	abort@FUNCTION
	unreachable
.LBB5_3:                                # %if.else
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, .LBB5_5
.LBB5_4:                                # %if.end38
	return
.LBB5_5:                                # %if.then3
	call    	abort@FUNCTION
	unreachable
.Lfunc_end5:
	.size	test6, .Lfunc_end5-test6

	.section	.text.test7,"ax",@progbits
	.hidden	test7
	.globl	test7
	.type	test7,@function
test7:                                  # @test7
	.param  	i64, i32
# BB#0:                                 # %entry
	block   	.LBB6_5
	block   	.LBB6_4
	block   	.LBB6_3
	i64.const	$push0=, 0
	i64.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, .LBB6_3
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	i32.eq  	$push3=, $1, $pop2
	br_if   	$pop3, .LBB6_4
# BB#2:                                 # %if.then1
	call    	abort@FUNCTION
	unreachable
.LBB6_3:                                # %if.else
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, .LBB6_5
.LBB6_4:                                # %if.end38
	return
.LBB6_5:                                # %if.then3
	call    	abort@FUNCTION
	unreachable
.Lfunc_end6:
	.size	test7, .Lfunc_end6-test7

	.section	.text.test8,"ax",@progbits
	.hidden	test8
	.globl	test8
	.type	test8,@function
test8:                                  # @test8
	.param  	i64, i32
# BB#0:                                 # %entry
	block   	.LBB7_5
	block   	.LBB7_4
	block   	.LBB7_3
	i64.const	$push0=, 0
	i64.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, .LBB7_3
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	i32.eq  	$push3=, $1, $pop2
	br_if   	$pop3, .LBB7_4
# BB#2:                                 # %if.then1
	call    	abort@FUNCTION
	unreachable
.LBB7_3:                                # %if.else
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, .LBB7_5
.LBB7_4:                                # %if.end38
	return
.LBB7_5:                                # %if.then3
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
	return  	$pop0
.Lfunc_end8:
	.size	main, .Lfunc_end8-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
