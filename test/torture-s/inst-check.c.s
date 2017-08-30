	.text
	.file	"inst-check.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.body.lr.ph
	i32.const	$push5=, -1
	i32.add 	$push6=, $0, $pop5
	i64.extend_u/i32	$push7=, $pop6
	i32.const	$push2=, -2
	i32.add 	$push3=, $0, $pop2
	i64.extend_u/i32	$push4=, $pop3
	i64.mul 	$push8=, $pop7, $pop4
	i64.const	$push9=, 1
	i64.shr_u	$push10=, $pop8, $pop9
	i32.wrap/i64	$push11=, $pop10
	i32.add 	$push12=, $pop11, $0
	i32.const	$push15=, -1
	i32.add 	$push13=, $pop12, $pop15
	return  	$pop13
.LBB0_2:
	end_block                       # label0:
	i32.const	$push14=, 0
                                        # fallthrough-return: $pop14
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
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
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
