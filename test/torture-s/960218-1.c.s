	.text
	.file	"960218-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	glob($pop0), $0
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g
                                        # -- End function
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push3=, -1
	i32.eq  	$push0=, $0, $pop3
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %while.cond.while.end_crit_edge
	i32.const	$push2=, 0
	i32.const	$push4=, -1
	i32.xor 	$push1=, $0, $pop4
	i32.store	glob($pop2), $pop1
.LBB1_2:                                # %while.end
	end_block                       # label0:
	copy_local	$push5=, $0
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, -4
	i32.store	glob($pop1), $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	glob                    # @glob
	.type	glob,@object
	.section	.bss.glob,"aw",@nobits
	.globl	glob
	.p2align	2
glob:
	.int32	0                       # 0x0
	.size	glob, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
