	.text
	.file	"loop-3.c"
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, n($pop4)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	n($pop0), $pop3
	copy_local	$push5=, $1
                                        # fallthrough-return: $pop5
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
	i32.const	$push4=, 0
	i32.const	$push13=, 0
	i32.load	$push5=, n($pop13)
	i32.add 	$push6=, $pop5, $0
	i32.const	$push0=, -1
	i32.xor 	$push12=, $0, $pop0
	tee_local	$push11=, $0=, $pop12
	i32.const	$push1=, -2
	i32.const	$push10=, -2
	i32.gt_s	$push2=, $0, $pop10
	i32.select	$push3=, $pop11, $pop1, $pop2
	i32.add 	$push7=, $pop6, $pop3
	i32.const	$push8=, 2
	i32.add 	$push9=, $pop7, $pop8
	i32.store	n($pop4), $pop9
	copy_local	$push14=, $0
                                        # fallthrough-return: $pop14
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.load	$push3=, n($pop4)
	tee_local	$push2=, $0=, $pop3
	i32.const	$push0=, 4
	i32.add 	$push1=, $pop2, $pop0
	i32.store	n($pop5), $pop1
	block   	
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	n                       # @n
	.type	n,@object
	.section	.bss.n,"aw",@nobits
	.globl	n
	.p2align	2
n:
	.int32	0                       # 0x0
	.size	n, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
