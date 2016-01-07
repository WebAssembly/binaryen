	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr31169.c"
	.globl	sign_bit_p
	.type	sign_bit_p,@function
sign_bit_p:                             # @sign_bit_p
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	.LBB0_3
	block   	.LBB0_2
	i32.load16_u	$push0=, 0($0)
	i32.const	$push1=, 511
	i32.and 	$0=, $pop0, $pop1
	i32.const	$push2=, 33
	i32.lt_u	$push3=, $0, $pop2
	br_if   	$pop3, .LBB0_2
# BB#1:                                 # %if.then
	i32.const	$push10=, 1
	i32.const	$push8=, -33
	i32.add 	$push9=, $0, $pop8
	i32.shl 	$6=, $pop10, $pop9
	i32.const	$3=, -1
	i32.const	$push11=, 64
	i32.sub 	$push12=, $pop11, $0
	i32.shr_u	$5=, $3, $pop12
	i32.const	$4=, 0
	br      	.LBB0_3
.LBB0_2:                                  # %if.else
	i32.const	$3=, -1
	i32.const	$push5=, 1
	i32.add 	$push4=, $0, $3
	i32.shl 	$4=, $pop5, $pop4
	i32.const	$5=, 0
	i32.const	$push6=, 32
	i32.sub 	$push7=, $pop6, $0
	i32.shr_u	$3=, $3, $pop7
	copy_local	$6=, $5
.LBB0_3:                                  # %if.end
	i32.and 	$push15=, $3, $2
	i32.eq  	$push16=, $pop15, $4
	i32.and 	$push13=, $5, $1
	i32.eq  	$push14=, $pop13, $6
	i32.and 	$push17=, $pop16, $pop14
	return  	$pop17
.Lfunc_end0:
	.size	sign_bit_p, .Lfunc_end0-sign_bit_p

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %sign_bit_p.exit
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
