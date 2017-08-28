	.text
	.file	"961004-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push2=, 0
	i32.load	$push0=, k($pop2)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.else
	i32.const	$push3=, 0
	i32.const	$push1=, 1
	i32.store	k($pop3), $pop1
.LBB0_2:                                # %for.inc.1
	end_block                       # label0:
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	2
k:
	.int32	0                       # 0x0
	.size	k, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
