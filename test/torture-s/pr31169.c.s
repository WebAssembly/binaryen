	.text
	.file	"pr31169.c"
	.section	.text.sign_bit_p,"ax",@progbits
	.hidden	sign_bit_p              # -- Begin function sign_bit_p
	.globl	sign_bit_p
	.type	sign_bit_p,@function
sign_bit_p:                             # @sign_bit_p
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.load16_u	$push0=, 0($0)
	i32.const	$push1=, 511
	i32.and 	$0=, $pop0, $pop1
	block   	
	block   	
	i32.const	$push2=, 33
	i32.lt_u	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label1
# %bb.1:                                # %if.then
	i32.const	$3=, -1
	i32.const	$push19=, -1
	i32.const	$push9=, 64
	i32.sub 	$push10=, $pop9, $0
	i32.shr_u	$5=, $pop19, $pop10
	i32.const	$push13=, 1
	i32.const	$push11=, -33
	i32.add 	$push12=, $0, $pop11
	i32.shl 	$0=, $pop13, $pop12
	i32.const	$4=, 0
	br      	1               # 1: down to label0
.LBB0_2:                                # %if.else
	end_block                       # label1:
	i32.const	$push6=, -1
	i32.const	$push4=, 32
	i32.sub 	$push5=, $pop4, $0
	i32.shr_u	$3=, $pop6, $pop5
	i32.const	$push8=, 1
	i32.const	$push20=, -1
	i32.add 	$push7=, $0, $pop20
	i32.shl 	$4=, $pop8, $pop7
	i32.const	$5=, 0
	i32.const	$0=, 0
.LBB0_3:                                # %if.end
	end_block                       # label0:
	i32.and 	$push16=, $3, $2
	i32.eq  	$push17=, $pop16, $4
	i32.and 	$push14=, $5, $1
	i32.eq  	$push15=, $pop14, $0
	i32.and 	$push18=, $pop17, $pop15
                                        # fallthrough-return: $pop18
	.endfunc
.Lfunc_end0:
	.size	sign_bit_p, .Lfunc_end0-sign_bit_p
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %sign_bit_p.exit
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
