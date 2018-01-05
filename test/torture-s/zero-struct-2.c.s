	.text
	.file	"zero-struct-2.c"
	.section	.text.one_raw_spinlock,"ax",@progbits
	.hidden	one_raw_spinlock        # -- Begin function one_raw_spinlock
	.globl	one_raw_spinlock
	.type	one_raw_spinlock,@function
one_raw_spinlock:                       # @one_raw_spinlock
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, ii($pop4)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	ii($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	one_raw_spinlock, .Lfunc_end0-one_raw_spinlock
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
	i32.load	$0=, ii($pop3)
	i32.const	$push2=, 0
	i32.const	$push0=, 1
	i32.add 	$push1=, $0, $pop0
	i32.store	ii($pop2), $pop1
	block   	
	br_if   	0, $0           # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	ii                      # @ii
	.type	ii,@object
	.section	.bss.ii,"aw",@nobits
	.globl	ii
	.p2align	2
ii:
	.int32	0                       # 0x0
	.size	ii, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
