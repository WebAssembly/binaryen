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
	i32.const	$push40=, 0
	i64.load	$push39=, x($pop40)
	tee_local	$push38=, $0=, $pop39
	i32.wrap/i64	$push0=, $pop38
	i32.const	$push1=, 7
	i32.and 	$push2=, $pop0, $pop1
	i32.const	$push37=, -2
	i32.add 	$push3=, $pop2, $pop37
	i32.const	$push36=, 0
	i32.lt_s	$push4=, $pop3, $pop36
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block
	i64.const	$push5=, 31
	i64.shr_u	$push6=, $0, $pop5
	i32.wrap/i64	$push7=, $pop6
	i32.const	$push8=, 1
	i32.shr_s	$push9=, $pop7, $pop8
	i32.const	$push42=, -2
	i32.add 	$push10=, $pop9, $pop42
	i32.const	$push41=, 0
	i32.lt_s	$push11=, $pop10, $pop41
	br_if   	0, $pop11       # 0: down to label1
# BB#3:                                 # %if.then4
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %if.end5
	end_block                       # label1:
	block
	i32.const	$push47=, 0
	i64.load	$push46=, x+8($pop47)
	tee_local	$push45=, $0=, $pop46
	i32.wrap/i64	$push12=, $pop45
	i32.const	$push44=, -2
	i32.add 	$push13=, $pop12, $pop44
	i32.const	$push43=, 0
	i32.lt_s	$push14=, $pop13, $pop43
	br_if   	0, $pop14       # 0: down to label2
# BB#5:                                 # %if.then12
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.end13
	end_block                       # label2:
	block
	i32.const	$push50=, 0
	i64.load	$push15=, x+24($pop50)
	i64.const	$push16=, 35
	i64.shr_u	$push17=, $pop15, $pop16
	i32.wrap/i64	$push18=, $pop17
	i32.const	$push19=, 32767
	i32.and 	$push20=, $pop18, $pop19
	i32.const	$push49=, -2
	i32.add 	$push21=, $pop20, $pop49
	i32.const	$push48=, 0
	i32.lt_s	$push22=, $pop21, $pop48
	br_if   	0, $pop22       # 0: down to label3
# BB#7:                                 # %if.then19
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.end20
	end_block                       # label3:
	block
	i64.const	$push23=, 32
	i64.shr_u	$push24=, $0, $pop23
	i32.wrap/i64	$push25=, $pop24
	i32.const	$push26=, 2147483647
	i32.and 	$push27=, $pop25, $pop26
	i32.const	$push52=, -2
	i32.add 	$push28=, $pop27, $pop52
	i32.const	$push51=, 0
	i32.lt_s	$push29=, $pop28, $pop51
	br_if   	0, $pop29       # 0: down to label4
# BB#9:                                 # %if.then27
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %if.end35
	end_block                       # label4:
	block
	i32.const	$push55=, 0
	i32.load	$push30=, x+20($pop55)
	i32.const	$push31=, 7
	i32.and 	$push32=, $pop30, $pop31
	i32.const	$push54=, -2
	i32.add 	$push33=, $pop32, $pop54
	i32.const	$push53=, 0
	i32.lt_s	$push34=, $pop33, $pop53
	br_if   	0, $pop34       # 0: down to label5
# BB#11:                                # %if.then42
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %if.end50
	end_block                       # label5:
	i32.const	$push35=, 0
	call    	exit@FUNCTION, $pop35
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
