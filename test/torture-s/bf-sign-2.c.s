	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/bf-sign-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	block
	i32.const	$push41=, 0
	i64.load	$push0=, x($pop41)
	tee_local	$push40=, $0=, $pop0
	i32.wrap/i64	$push2=, $pop40
	i32.const	$push3=, 7
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push39=, -2
	i32.add 	$push5=, $pop4, $pop39
	i32.const	$push38=, 0
	i32.lt_s	$push6=, $pop5, $pop38
	br_if   	$pop6, 0        # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block
	i64.const	$push7=, 31
	i64.shr_u	$push8=, $0, $pop7
	i32.wrap/i64	$push9=, $pop8
	i32.const	$push10=, 1
	i32.shr_s	$push11=, $pop9, $pop10
	i32.const	$push43=, -2
	i32.add 	$push12=, $pop11, $pop43
	i32.const	$push42=, 0
	i32.lt_s	$push13=, $pop12, $pop42
	br_if   	$pop13, 0       # 0: down to label1
# BB#3:                                 # %if.then4
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %if.end5
	end_block                       # label1:
	block
	i32.const	$push47=, 0
	i64.load	$push1=, x+8($pop47)
	tee_local	$push46=, $0=, $pop1
	i32.wrap/i64	$push14=, $pop46
	i32.const	$push45=, -2
	i32.add 	$push15=, $pop14, $pop45
	i32.const	$push44=, 0
	i32.lt_s	$push16=, $pop15, $pop44
	br_if   	$pop16, 0       # 0: down to label2
# BB#5:                                 # %if.then12
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.end13
	end_block                       # label2:
	block
	i32.const	$push50=, 0
	i64.load	$push17=, x+24($pop50)
	i64.const	$push18=, 35
	i64.shr_u	$push19=, $pop17, $pop18
	i32.wrap/i64	$push20=, $pop19
	i32.const	$push21=, 32767
	i32.and 	$push22=, $pop20, $pop21
	i32.const	$push49=, -2
	i32.add 	$push23=, $pop22, $pop49
	i32.const	$push48=, 0
	i32.lt_s	$push24=, $pop23, $pop48
	br_if   	$pop24, 0       # 0: down to label3
# BB#7:                                 # %if.then19
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.end20
	end_block                       # label3:
	block
	i64.const	$push25=, 32
	i64.shr_u	$push26=, $0, $pop25
	i32.wrap/i64	$push27=, $pop26
	i32.const	$push28=, 2147483647
	i32.and 	$push29=, $pop27, $pop28
	i32.const	$push52=, -2
	i32.add 	$push30=, $pop29, $pop52
	i32.const	$push51=, 0
	i32.lt_s	$push31=, $pop30, $pop51
	br_if   	$pop31, 0       # 0: down to label4
# BB#9:                                 # %if.then27
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %if.end35
	end_block                       # label4:
	block
	i32.const	$push55=, 0
	i32.load	$push32=, x+20($pop55)
	i32.const	$push33=, 7
	i32.and 	$push34=, $pop32, $pop33
	i32.const	$push54=, -2
	i32.add 	$push35=, $pop34, $pop54
	i32.const	$push53=, 0
	i32.lt_s	$push36=, $pop35, $pop53
	br_if   	$pop36, 0       # 0: down to label5
# BB#11:                                # %if.then42
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %if.end50
	end_block                       # label5:
	i32.const	$push37=, 0
	call    	exit@FUNCTION, $pop37
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	3
x:
	.skip	32
	.size	x, 32


	.ident	"clang version 3.9.0 "
