	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/vrp-4.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
# BB#0:                                 # %entry
	block
	block
	block
	i32.const	$push5=, 1
	i32.eq  	$push0=, $0, $pop5
	br_if   	0, $pop0        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push6=, 1
	i32.eq  	$push1=, $1, $pop6
	br_if   	1, $pop1        # 1: down to label1
# BB#2:                                 # %if.end3
	i32.div_s	$push2=, $0, $1
	i32.const	$push3=, 1
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	2, $pop4        # 2: down to label0
# BB#3:                                 # %if.end6
	return
.LBB0_4:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %if.then2
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.then5
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

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
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
