	.text
	.file	"990527-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push3=, 0
	i32.load	$push1=, sum($pop3)
	i32.add 	$push2=, $pop1, $0
	i32.store	sum($pop0), $pop2
                                        # fallthrough-return
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
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, sum($pop5)
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 81
	i32.add 	$push4=, $pop2, $pop3
	i32.store	sum($pop0), $pop4
                                        # fallthrough-return
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
	i32.load	$0=, sum($pop3)
	i32.const	$push2=, 0
	i32.const	$push0=, 81
	i32.add 	$push1=, $0, $pop0
	i32.store	sum($pop2), $pop1
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
	.hidden	sum                     # @sum
	.type	sum,@object
	.section	.bss.sum,"aw",@nobits
	.globl	sum
	.p2align	2
sum:
	.int32	0                       # 0x0
	.size	sum, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
