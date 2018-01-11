	.text
	.file	"930513-2.c"
	.section	.text.sub3,"ax",@progbits
	.hidden	sub3                    # -- Begin function sub3
	.globl	sub3
	.type	sub3,@function
sub3:                                   # @sub3
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	sub3, .Lfunc_end0-sub3
                                        # -- End function
	.section	.text.eq,"ax",@progbits
	.hidden	eq                      # -- Begin function eq
	.globl	eq
	.type	eq,@function
eq:                                     # @eq
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push4=, 0
	i32.load	$push0=, eq.i($pop4)
	i32.ne  	$push1=, $pop0, $0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push5=, 0
	i32.const	$push2=, 1
	i32.add 	$push3=, $0, $pop2
	i32.store	eq.i($pop5), $pop3
	return  	$0
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	eq, .Lfunc_end1-eq
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push2=, 0
	i32.load	$push0=, eq.i($pop2)
	br_if   	0, $pop0        # 0: down to label1
# %bb.1:                                # %eq.exit.3
	i32.const	$push4=, 0
	i32.const	$push1=, 4
	i32.store	eq.i($pop4), $pop1
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
.LBB2_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	eq.i,@object            # @eq.i
	.section	.bss.eq.i,"aw",@nobits
	.p2align	2
eq.i:
	.int32	0                       # 0x0
	.size	eq.i, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
