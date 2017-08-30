	.text
	.file	"pr61375.c"
	.section	.text.uint128_central_bitsi_ior,"ax",@progbits
	.hidden	uint128_central_bitsi_ior # -- Begin function uint128_central_bitsi_ior
	.globl	uint128_central_bitsi_ior
	.type	uint128_central_bitsi_ior,@function
uint128_central_bitsi_ior:              # @uint128_central_bitsi_ior
	.param  	i64, i64, i64
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push2=, 56
	i64.shr_u	$push3=, $0, $pop2
	i64.const	$push0=, 8
	i64.shl 	$push1=, $1, $pop0
	i64.or  	$push4=, $pop3, $pop1
	i64.const	$push5=, 65535
	i64.and 	$push6=, $pop4, $pop5
	i64.or  	$push7=, $pop6, $2
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end0:
	.size	uint128_central_bitsi_ior, .Lfunc_end0-uint128_central_bitsi_ior
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i64.const	$push2=, 0
	i64.const	$push1=, 1
	i64.const	$push0=, 2
	i64.call	$push3=, uint128_central_bitsi_ior@FUNCTION, $pop2, $pop1, $pop0
	i64.const	$push4=, 258
	i64.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	return  	$pop6
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
