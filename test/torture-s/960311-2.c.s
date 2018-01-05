	.text
	.file	"960311-2.c"
	.section	.text.a1,"ax",@progbits
	.hidden	a1                      # -- Begin function a1
	.globl	a1
	.type	a1,@function
a1:                                     # @a1
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, count($pop4)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	count($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	a1, .Lfunc_end0-a1
                                        # -- End function
	.section	.text.b,"ax",@progbits
	.hidden	b                       # -- Begin function b
	.globl	b
	.type	b,@function
b:                                      # @b
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 32768
	i32.and 	$push1=, $0, $pop0
	i32.eqz 	$push21=, $pop1
	br_if   	0, $pop21       # 0: down to label0
# %bb.1:                                # %if.then
	i32.const	$push2=, 0
	i32.const	$push18=, 0
	i32.load	$push3=, count($pop18)
	i32.const	$push4=, 1
	i32.add 	$push5=, $pop3, $pop4
	i32.store	count($pop2), $pop5
.LBB1_2:                                # %if.end
	end_block                       # label0:
	block   	
	i32.const	$push6=, 16384
	i32.and 	$push7=, $0, $pop6
	i32.eqz 	$push22=, $pop7
	br_if   	0, $pop22       # 0: down to label1
# %bb.3:                                # %if.then6
	i32.const	$push8=, 0
	i32.const	$push19=, 0
	i32.load	$push9=, count($pop19)
	i32.const	$push10=, 1
	i32.add 	$push11=, $pop9, $pop10
	i32.store	count($pop8), $pop11
.LBB1_4:                                # %if.end7
	end_block                       # label1:
	block   	
	i32.const	$push12=, 8192
	i32.and 	$push13=, $0, $pop12
	i32.eqz 	$push23=, $pop13
	br_if   	0, $pop23       # 0: down to label2
# %bb.5:                                # %if.then14
	i32.const	$push14=, 0
	i32.const	$push20=, 0
	i32.load	$push15=, count($pop20)
	i32.const	$push16=, 1
	i32.add 	$push17=, $pop15, $pop16
	i32.store	count($pop14), $pop17
.LBB1_6:                                # %if.end15
	end_block                       # label2:
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	b, .Lfunc_end1-b
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end21
	i32.const	$push1=, 0
	i32.const	$push0=, 3
	i32.store	count($pop1), $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	count                   # @count
	.type	count,@object
	.section	.bss.count,"aw",@nobits
	.globl	count
	.p2align	2
count:
	.int32	0                       # 0x0
	.size	count, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
