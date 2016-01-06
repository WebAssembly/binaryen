	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020506-1.c"
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	BB0_5
	block   	BB0_4
	block   	BB0_3
	i32.const	$push0=, 0
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, BB0_3
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	i32.eq  	$push3=, $1, $pop2
	br_if   	$pop3, BB0_4
# BB#2:                                 # %if.then2
	call    	abort
	unreachable
BB0_3:                                  # %if.else
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, BB0_5
BB0_4:                                  # %if.end45
	return
BB0_5:                                  # %if.then4
	call    	abort
	unreachable
func_end0:
	.size	test1, func_end0-test1

	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 24
	block   	BB1_5
	block   	BB1_4
	block   	BB1_3
	i32.shl 	$push0=, $0, $2
	i32.shr_s	$push1=, $pop0, $2
	i32.const	$push2=, 0
	i32.lt_s	$push3=, $pop1, $pop2
	br_if   	$pop3, BB1_3
# BB#1:                                 # %if.then
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, BB1_4
# BB#2:                                 # %if.then2
	call    	abort
	unreachable
BB1_3:                                  # %if.else
	i32.const	$push6=, 0
	i32.eq  	$push7=, $1, $pop6
	br_if   	$pop7, BB1_5
BB1_4:                                  # %if.end45
	return
BB1_5:                                  # %if.then4
	call    	abort
	unreachable
func_end1:
	.size	test2, func_end1-test2

	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	BB2_5
	block   	BB2_4
	block   	BB2_3
	i32.const	$push0=, 0
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, BB2_3
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	i32.eq  	$push3=, $1, $pop2
	br_if   	$pop3, BB2_4
# BB#2:                                 # %if.then2
	call    	abort
	unreachable
BB2_3:                                  # %if.else
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, BB2_5
BB2_4:                                  # %if.end45
	return
BB2_5:                                  # %if.then4
	call    	abort
	unreachable
func_end2:
	.size	test3, func_end2-test3

	.globl	test4
	.type	test4,@function
test4:                                  # @test4
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 16
	block   	BB3_5
	block   	BB3_4
	block   	BB3_3
	i32.shl 	$push0=, $0, $2
	i32.shr_s	$push1=, $pop0, $2
	i32.const	$push2=, 0
	i32.lt_s	$push3=, $pop1, $pop2
	br_if   	$pop3, BB3_3
# BB#1:                                 # %if.then
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, BB3_4
# BB#2:                                 # %if.then2
	call    	abort
	unreachable
BB3_3:                                  # %if.else
	i32.const	$push6=, 0
	i32.eq  	$push7=, $1, $pop6
	br_if   	$pop7, BB3_5
BB3_4:                                  # %if.end45
	return
BB3_5:                                  # %if.then4
	call    	abort
	unreachable
func_end3:
	.size	test4, func_end3-test4

	.globl	test5
	.type	test5,@function
test5:                                  # @test5
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	BB4_5
	block   	BB4_4
	block   	BB4_3
	i32.const	$push0=, 0
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, BB4_3
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	i32.eq  	$push3=, $1, $pop2
	br_if   	$pop3, BB4_4
# BB#2:                                 # %if.then1
	call    	abort
	unreachable
BB4_3:                                  # %if.else
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, BB4_5
BB4_4:                                  # %if.end38
	return
BB4_5:                                  # %if.then3
	call    	abort
	unreachable
func_end4:
	.size	test5, func_end4-test5

	.globl	test6
	.type	test6,@function
test6:                                  # @test6
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	BB5_5
	block   	BB5_4
	block   	BB5_3
	i32.const	$push0=, 0
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, BB5_3
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	i32.eq  	$push3=, $1, $pop2
	br_if   	$pop3, BB5_4
# BB#2:                                 # %if.then1
	call    	abort
	unreachable
BB5_3:                                  # %if.else
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, BB5_5
BB5_4:                                  # %if.end38
	return
BB5_5:                                  # %if.then3
	call    	abort
	unreachable
func_end5:
	.size	test6, func_end5-test6

	.globl	test7
	.type	test7,@function
test7:                                  # @test7
	.param  	i64, i32
# BB#0:                                 # %entry
	block   	BB6_5
	block   	BB6_4
	block   	BB6_3
	i64.const	$push0=, 0
	i64.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, BB6_3
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	i32.eq  	$push3=, $1, $pop2
	br_if   	$pop3, BB6_4
# BB#2:                                 # %if.then1
	call    	abort
	unreachable
BB6_3:                                  # %if.else
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, BB6_5
BB6_4:                                  # %if.end38
	return
BB6_5:                                  # %if.then3
	call    	abort
	unreachable
func_end6:
	.size	test7, func_end6-test7

	.globl	test8
	.type	test8,@function
test8:                                  # @test8
	.param  	i64, i32
# BB#0:                                 # %entry
	block   	BB7_5
	block   	BB7_4
	block   	BB7_3
	i64.const	$push0=, 0
	i64.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, BB7_3
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	i32.eq  	$push3=, $1, $pop2
	br_if   	$pop3, BB7_4
# BB#2:                                 # %if.then1
	call    	abort
	unreachable
BB7_3:                                  # %if.else
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, BB7_5
BB7_4:                                  # %if.end38
	return
BB7_5:                                  # %if.then3
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
	return  	$pop0
func_end8:
	.size	main, func_end8-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
