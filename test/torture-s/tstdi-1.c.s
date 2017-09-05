	.text
	.file	"tstdi-1.c"
	.section	.text.feq,"ax",@progbits
	.hidden	feq                     # -- Begin function feq
	.globl	feq
	.type	feq,@function
feq:                                    # @feq
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
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
# BB#0:                                 # %if.end140
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end6:
	.size	main, .Lfunc_end6-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
