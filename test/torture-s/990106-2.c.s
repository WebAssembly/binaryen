	.text
	.file	"990106-2.c"
	.section	.text.calc_mp,"ax",@progbits
	.hidden	calc_mp                 # -- Begin function calc_mp
	.globl	calc_mp
	.type	calc_mp,@function
calc_mp:                                # @calc_mp
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.rem_u	$push1=, $pop0, $0
	i32.const	$push2=, 1
	i32.add 	$push8=, $pop1, $pop2
	tee_local	$push7=, $1=, $pop8
	i32.const	$push4=, 0
	i32.gt_u	$push3=, $1, $0
	i32.select	$push5=, $0, $pop4, $pop3
	i32.sub 	$push6=, $pop7, $pop5
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	calc_mp, .Lfunc_end0-calc_mp
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
