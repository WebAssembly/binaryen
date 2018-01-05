	.text
	.file	"20000403-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push8=, 0
	i32.load	$push0=, aa($pop8)
	i32.const	$push1=, 4096
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push7=, 0
	i32.load	$push3=, bb($pop7)
	i32.sub 	$push4=, $pop2, $pop3
	i32.const	$push6=, 0
	i32.gt_s	$push5=, $pop4, $pop6
	br_if   	0, $pop5        # 0: down to label0
# %bb.1:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.seqgt,"ax",@progbits
	.hidden	seqgt                   # -- Begin function seqgt
	.globl	seqgt
	.type	seqgt,@function
seqgt:                                  # @seqgt
	.param  	i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.add 	$push0=, $1, $0
	i32.sub 	$push1=, $pop0, $2
	i32.const	$push2=, 0
	i32.gt_s	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	seqgt, .Lfunc_end1-seqgt
                                        # -- End function
	.section	.text.seqgt2,"ax",@progbits
	.hidden	seqgt2                  # -- Begin function seqgt2
	.globl	seqgt2
	.type	seqgt2,@function
seqgt2:                                 # @seqgt2
	.param  	i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.add 	$push0=, $1, $0
	i32.sub 	$push1=, $pop0, $2
	i32.const	$push2=, 0
	i32.gt_s	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end2:
	.size	seqgt2, .Lfunc_end2-seqgt2
                                        # -- End function
	.hidden	aa                      # @aa
	.type	aa,@object
	.section	.data.aa,"aw",@progbits
	.globl	aa
	.p2align	2
aa:
	.int32	2147479553              # 0x7ffff001
	.size	aa, 4

	.hidden	bb                      # @bb
	.type	bb,@object
	.section	.data.bb,"aw",@progbits
	.globl	bb
	.p2align	2
bb:
	.int32	2147479553              # 0x7ffff001
	.size	bb, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
