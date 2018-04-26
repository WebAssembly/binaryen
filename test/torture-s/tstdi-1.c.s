	.text
	.file	"tstdi-1.c"
	.section	.text.feq,"ax",@progbits
	.hidden	feq                     # -- Begin function feq
	.globl	feq
	.type	feq,@function
feq:                                    # @feq
	.param  	i64
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push2=, 13
	i32.const	$push1=, 140
	i64.eqz 	$push0=, $0
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	feq, .Lfunc_end0-feq
                                        # -- End function
	.section	.text.fne,"ax",@progbits
	.hidden	fne                     # -- Begin function fne
	.globl	fne
	.type	fne,@function
fne:                                    # @fne
	.param  	i64
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push2=, 140
	i32.const	$push1=, 13
	i64.eqz 	$push0=, $0
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	fne, .Lfunc_end1-fne
                                        # -- End function
	.section	.text.flt,"ax",@progbits
	.hidden	flt                     # -- Begin function flt
	.globl	flt
	.type	flt,@function
flt:                                    # @flt
	.param  	i64
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push3=, 13
	i32.const	$push2=, 140
	i64.const	$push0=, 0
	i64.lt_s	$push1=, $0, $pop0
	i32.select	$push4=, $pop3, $pop2, $pop1
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end2:
	.size	flt, .Lfunc_end2-flt
                                        # -- End function
	.section	.text.fge,"ax",@progbits
	.hidden	fge                     # -- Begin function fge
	.globl	fge
	.type	fge,@function
fge:                                    # @fge
	.param  	i64
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push3=, 13
	i32.const	$push2=, 140
	i64.const	$push0=, -1
	i64.gt_s	$push1=, $0, $pop0
	i32.select	$push4=, $pop3, $pop2, $pop1
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end3:
	.size	fge, .Lfunc_end3-fge
                                        # -- End function
	.section	.text.fgt,"ax",@progbits
	.hidden	fgt                     # -- Begin function fgt
	.globl	fgt
	.type	fgt,@function
fgt:                                    # @fgt
	.param  	i64
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push3=, 13
	i32.const	$push2=, 140
	i64.const	$push0=, 0
	i64.gt_s	$push1=, $0, $pop0
	i32.select	$push4=, $pop3, $pop2, $pop1
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end4:
	.size	fgt, .Lfunc_end4-fgt
                                        # -- End function
	.section	.text.fle,"ax",@progbits
	.hidden	fle                     # -- Begin function fle
	.globl	fle
	.type	fle,@function
fle:                                    # @fle
	.param  	i64
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push3=, 13
	i32.const	$push2=, 140
	i64.const	$push0=, 1
	i64.lt_s	$push1=, $0, $pop0
	i32.select	$push4=, $pop3, $pop2, $pop1
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end5:
	.size	fle, .Lfunc_end5-fle
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end140
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end6:
	.size	main, .Lfunc_end6-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
