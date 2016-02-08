	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/struct-ini-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push1=, 0
	i32.load16_u	$push0=, x($pop1):p2align=2
	tee_local	$push15=, $0=, $pop0
	i32.const	$push2=, 15
	i32.and 	$push3=, $pop15, $pop2
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.end
	block
	i32.const	$push6=, 3840
	i32.and 	$push7=, $0, $pop6
	i32.const	$push8=, 768
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label1
# BB#2:                                 # %if.end7
	block
	i32.const	$push10=, 61440
	i32.and 	$push11=, $0, $pop10
	i32.const	$push12=, 16384
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label2
# BB#3:                                 # %if.end13
	i32.const	$push14=, 0
	call    	exit@FUNCTION, $pop14
	unreachable
.LBB0_4:                                # %if.then12
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %if.then6
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.p2align	2
x:
	.int8	2                       # 0x2
	.int8	67                      # 0x43
	.skip	2
	.size	x, 4


	.ident	"clang version 3.9.0 "
