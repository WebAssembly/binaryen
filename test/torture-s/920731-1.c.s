	.text
	.file	"920731-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block   	
	i32.const	$push3=, 1
	i32.and 	$push0=, $0, $pop3
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %for.inc.preheader
	i32.const	$1=, 0
.LBB0_2:                                # %for.inc
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push5=, 1
	i32.add 	$2=, $1, $pop5
	i32.const	$push4=, 6
	i32.gt_u	$push2=, $1, $pop4
	br_if   	1, $pop2        # 1: down to label0
# BB#3:                                 # %for.inc
                                        #   in Loop: Header=BB0_2 Depth=1
	copy_local	$1=, $2
	i32.const	$push9=, 1
	i32.shr_s	$push8=, $0, $pop9
	tee_local	$push7=, $0=, $pop8
	i32.const	$push6=, 1
	i32.and 	$push1=, $pop7, $pop6
	i32.eqz 	$push10=, $pop1
	br_if   	0, $pop10       # 0: up to label1
.LBB0_4:                                # %for.end
	end_loop
	end_block                       # label0:
	copy_local	$push11=, $2
                                        # fallthrough-return: $pop11
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
