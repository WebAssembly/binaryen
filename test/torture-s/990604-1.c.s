	.text
	.file	"990604-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
# %bb.0:                                # %entry
	block   	
	i32.const	$push2=, 0
	i32.load	$push0=, b($pop2)
	i32.eqz 	$push4=, $pop0
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	i32.const	$push3=, 0
	i32.const	$push1=, 9
	i32.store	b($pop3), $pop1
                                        # fallthrough-return
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
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	i32.load	$0=, b($pop4)
	block   	
	block   	
	i32.const	$push0=, 9
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label2
# %bb.1:                                # %entry
	br_if   	1, $0           # 1: down to label1
# %bb.2:                                # %f.exit.thread
	i32.const	$push3=, 0
	i32.const	$push2=, 9
	i32.store	b($pop3), $pop2
.LBB1_3:                                # %if.end
	end_block                       # label2:
	i32.const	$push5=, 0
	return  	$pop5
.LBB1_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
