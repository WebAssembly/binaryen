	.text
	.file	"strct-pack-1.c"
	.section	.text.check,"ax",@progbits
	.hidden	check                   # -- Begin function check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.load16_u	$push0=, 0($0)
	i32.const	$push6=, 1
	i32.ne  	$push1=, $pop0, $pop6
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %lor.lhs.false
	f64.load	$push2=, 2($0):p2align=1
	f64.const	$push3=, 0x1p4
	f64.eq  	$push4=, $pop2, $pop3
	br_if   	1, $pop4        # 1: down to label0
.LBB0_2:                                # %return
	end_block                       # label1:
	i32.const	$push7=, 1
	return  	$pop7
.LBB0_3:                                # %if.end
	end_block                       # label0:
	i32.const	$push5=, 0
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
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
