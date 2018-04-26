	.text
	.file	"980602-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push10=, 0
	i32.load	$0=, t($pop10)
	i32.const	$push9=, 0
	i32.const	$push2=, 1
	i32.add 	$push3=, $0, $pop2
	i32.const	$push4=, 1073741823
	i32.and 	$push5=, $pop3, $pop4
	i32.const	$push0=, -1073741824
	i32.and 	$push1=, $0, $pop0
	i32.or  	$push6=, $pop5, $pop1
	i32.store	t($pop9), $pop6
	block   	
	i32.const	$push8=, 1073741823
	i32.and 	$push7=, $0, $pop8
	br_if   	0, $pop7        # 0: down to label0
# %bb.1:                                # %if.then
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
.LBB0_2:                                # %if.else
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	t                       # @t
	.type	t,@object
	.section	.bss.t,"aw",@nobits
	.globl	t
	.p2align	2
t:
	.skip	4
	.size	t, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
	.functype	abort, void
