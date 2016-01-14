	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/vrp-4.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 1
	block
	i32.eq  	$push0=, $0, $2
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %if.end
	block
	i32.eq  	$push1=, $1, $2
	br_if   	$pop1, 0        # 0: down to label1
# BB#2:                                 # %if.end3
	block
	i32.div_s	$push2=, $0, $1
	i32.ne  	$push3=, $pop2, $2
	br_if   	$pop3, 0        # 0: down to label2
# BB#3:                                 # %if.end6
	return
.LBB0_4:                                # %if.then5
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %if.then2
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.then
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
	.section	".note.GNU-stack","",@progbits
