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
	i32.load16_u	$push0=, 0($0):p2align=2
	i32.const	$push1=, 511
	i32.and 	$push20=, $pop0, $pop1
	tee_local	$push19=, $0=, $pop20
	i32.const	$push2=, 33
	i32.lt_u	$push3=, $pop19, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %if.then
	i32.const	$push11=, 1
	i32.const	$push9=, -33
	i32.add 	$push10=, $0, $pop9
	i32.shl 	$5=, $pop11, $pop10
	i32.const	$3=, -1
	i32.const	$push21=, -1
	i32.const	$push12=, 64
	i32.sub 	$push13=, $pop12, $0
	i32.shr_u	$0=, $pop21, $pop13
	i32.const	$4=, 0
	br      	1               # 1: down to label0
.LBB0_2:                                # %if.else
	end_block                       # label1:
	i32.const	$push6=, 1
	i32.const	$push4=, -1
	i32.add 	$push5=, $0, $pop4
	i32.shl 	$4=, $pop6, $pop5
	i32.const	$push22=, -1
	i32.const	$push7=, 32
	i32.sub 	$push8=, $pop7, $0
	i32.shr_u	$3=, $pop22, $pop8
	i32.const	$0=, 0
	i32.const	$5=, 0
.LBB0_3:                                # %if.end
	end_block                       # label0:
	i32.and 	$push16=, $3, $2
	i32.eq  	$push17=, $pop16, $4
	i32.and 	$push14=, $0, $1
	i32.eq  	$push15=, $pop14, $5
	i32.and 	$push18=, $pop17, $pop15
	return  	$pop18
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
