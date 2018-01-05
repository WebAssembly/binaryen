	.text
	.file	"loop-3b.c"
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
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
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, -1
	i32.xor 	$1=, $0, $pop0
	i32.const	$push8=, 0
	i32.const	$push15=, 0
	i32.load	$push9=, n($pop15)
	i32.const	$push1=, -268435456
	i32.const	$push14=, -268435456
	i32.gt_s	$push2=, $1, $pop14
	i32.select	$push3=, $1, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 268435455
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push13=, 268435455
	i32.div_u	$push7=, $pop6, $pop13
	i32.add 	$push10=, $pop9, $pop7
	i32.const	$push11=, 1
	i32.add 	$push12=, $pop10, $pop11
	i32.store	n($pop8), $pop12
	copy_local	$push16=, $0
                                        # fallthrough-return: $pop16
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
# %bb.0:                                # %entry
	i32.const	$push3=, 0
	i32.load	$0=, n($pop3)
	i32.const	$push2=, 0
	i32.const	$push0=, 4
	i32.add 	$push1=, $0, $pop0
	i32.store	n($pop2), $pop1
	block   	
	br_if   	0, $0           # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
