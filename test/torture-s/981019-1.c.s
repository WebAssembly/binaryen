	.text
	.file	"981019-1.c"
	.section	.text.ff,"ax",@progbits
	.hidden	ff                      # -- Begin function ff
	.globl	ff
	.type	ff,@function
ff:                                     # @ff
	.param  	i32, i32, i32
	.local  	i32
# %bb.0:                                # %entry
	block   	
	block   	
	block   	
	i32.eqz 	$push5=, $0
	br_if   	0, $pop5        # 0: down to label2
# %bb.1:                                # %entry
	br_if   	1, $2           # 1: down to label1
.LBB0_2:                                # %if.end3
	end_block                       # label2:
	i32.const	$push0=, 0
	i32.load	$0=, f3.x($pop0)
	i32.eqz 	$3=, $0
	i32.const	$push4=, 0
	i32.store	f3.x($pop4), $3
	block   	
	i32.eqz 	$push6=, $0
	br_if   	0, $pop6        # 0: down to label3
# %bb.3:                                # %while.end
	br_if   	1, $2           # 1: down to label1
# %bb.4:                                # %if.end16
	return
.LBB0_5:                                # %while.body.lr.ph
	end_block                       # label3:
	br_if   	1, $2           # 1: down to label0
# %bb.6:                                # %while.end.thread
	i32.const	$push3=, 0
	i32.const	$push1=, 1
	i32.xor 	$push2=, $3, $pop1
	i32.store	f3.x($pop3), $pop2
	return
.LBB0_7:                                # %if.then2
	end_block                       # label1:
	call    	f1@FUNCTION
	unreachable
.LBB0_8:                                # %land.lhs.true.split
	end_block                       # label0:
	i32.call	$drop=, f2@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	ff, .Lfunc_end0-ff
                                        # -- End function
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
# %bb.0:                                # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f1, .Lfunc_end1-f1
                                        # -- End function
	.section	.text.f3,"ax",@progbits
	.hidden	f3                      # -- Begin function f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, f3.x($pop0)
	i32.eqz 	$0=, $pop1
	i32.const	$push2=, 0
	i32.store	f3.x($pop2), $0
	copy_local	$push3=, $0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3
                                        # -- End function
	.section	.text.f2,"ax",@progbits
	.hidden	f2                      # -- Begin function f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.result 	i32
# %bb.0:                                # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	f2, .Lfunc_end3-f2
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push2=, 0
	i32.store	f3.x($pop0), $pop2
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function
	.type	f3.x,@object            # @f3.x
	.section	.bss.f3.x,"aw",@nobits
	.p2align	2
f3.x:
	.int32	0                       # 0x0
	.size	f3.x, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
