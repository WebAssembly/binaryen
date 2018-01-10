	.text
	.file	"20020611-1.c"
	.section	.text.x,"ax",@progbits
	.hidden	x                       # -- Begin function x
	.globl	x
	.type	x,@function
x:                                      # @x
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, n($pop0)
	i32.const	$push2=, 31
	i32.lt_u	$0=, $pop1, $pop2
	i32.const	$push4=, 0
	i32.store	p($pop4), $0
	i32.const	$push3=, 0
	i32.store	k($pop3), $0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	x, .Lfunc_end0-x
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	i32.load	$push0=, n($pop4)
	i32.const	$push1=, 31
	i32.lt_u	$0=, $pop0, $pop1
	i32.const	$push3=, 0
	i32.store	p($pop3), $0
	i32.const	$push2=, 0
	i32.store	k($pop2), $0
	block   	
	i32.eqz 	$push6=, $0
	br_if   	0, $pop6        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	n                       # @n
	.type	n,@object
	.section	.data.n,"aw",@progbits
	.globl	n
	.p2align	2
n:
	.int32	30                      # 0x1e
	.size	n, 4

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0                       # 0x0
	.size	p, 4

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	2
k:
	.int32	0                       # 0x0
	.size	k, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
