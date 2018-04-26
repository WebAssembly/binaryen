	.text
	.file	"20060102-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 31
	i32.shr_s	$push1=, $0, $pop0
	i32.const	$push2=, 1
	i32.or  	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push14=, 0
	i32.load	$push0=, one($pop14)
	i32.const	$push1=, 31
	i32.shr_s	$push2=, $pop0, $pop1
	i32.const	$push3=, 1
	i32.or  	$push4=, $pop2, $pop3
	i32.const	$push13=, 0
	i32.const	$push12=, 0
	i32.load	$push5=, one($pop12)
	i32.sub 	$push6=, $pop13, $pop5
	i32.const	$push11=, 31
	i32.shr_s	$push7=, $pop6, $pop11
	i32.const	$push10=, 1
	i32.or  	$push8=, $pop7, $pop10
	i32.eq  	$push9=, $pop4, $pop8
	br_if   	0, $pop9        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push15=, 0
	return  	$pop15
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	one                     # @one
	.type	one,@object
	.section	.data.one,"aw",@progbits
	.globl	one
	.p2align	2
one:
	.int32	1                       # 0x1
	.size	one, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
