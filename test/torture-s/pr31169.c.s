	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr31169.c"
	.section	.text.sign_bit_p,"ax",@progbits
	.hidden	sign_bit_p
	.globl	sign_bit_p
	.type	sign_bit_p,@function
sign_bit_p:                             # @sign_bit_p
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block
	block
	i32.load16_u	$push1=, 0($0):p2align=2
	i32.const	$push2=, 511
	i32.and 	$push0=, $pop1, $pop2
	tee_local	$push20=, $0=, $pop0
	i32.const	$push3=, 33
	i32.lt_u	$push4=, $pop20, $pop3
	br_if   	$pop4, 0        # 0: down to label1
# BB#1:                                 # %if.then
	i32.const	$push12=, 1
	i32.const	$push10=, -33
	i32.add 	$push11=, $0, $pop10
	i32.shl 	$5=, $pop12, $pop11
	i32.const	$3=, -1
	i32.const	$push21=, -1
	i32.const	$push13=, 64
	i32.sub 	$push14=, $pop13, $0
	i32.shr_u	$0=, $pop21, $pop14
	i32.const	$4=, 0
	br      	1               # 1: down to label0
.LBB0_2:                                # %if.else
	end_block                       # label1:
	i32.const	$push7=, 1
	i32.const	$push5=, -1
	i32.add 	$push6=, $0, $pop5
	i32.shl 	$4=, $pop7, $pop6
	i32.const	$push22=, -1
	i32.const	$push8=, 32
	i32.sub 	$push9=, $pop8, $0
	i32.shr_u	$3=, $pop22, $pop9
	i32.const	$0=, 0
	i32.const	$5=, 0
.LBB0_3:                                # %if.end
	end_block                       # label0:
	i32.and 	$push17=, $3, $2
	i32.eq  	$push18=, $pop17, $4
	i32.and 	$push15=, $0, $1
	i32.eq  	$push16=, $pop15, $5
	i32.and 	$push19=, $pop18, $pop16
	return  	$pop19
	.endfunc
.Lfunc_end0:
	.size	sign_bit_p, .Lfunc_end0-sign_bit_p

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %sign_bit_p.exit
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
