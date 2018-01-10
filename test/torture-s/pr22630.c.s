	.text
	.file	"pr22630.c"
	.section	.text.bla,"ax",@progbits
	.hidden	bla                     # -- Begin function bla
	.globl	bla
	.type	bla,@function
bla:                                    # @bla
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, j
	i32.select	$push1=, $0, $pop0, $0
	i32.eq  	$push2=, $pop1, $0
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.then1
	i32.const	$push4=, 0
	i32.const	$push3=, 1
	i32.store	j($pop4), $pop3
.LBB0_2:                                # %if.end2
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bla, .Lfunc_end0-bla
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	j($pop1), $pop0
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
	.p2align	2
j:
	.int32	0                       # 0x0
	.size	j, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
