	.text
	.file	"pr43269.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	call    	func_32@FUNCTION
	block   	
	i32.const	$push3=, 0
	i32.load	$push0=, g_261($pop3)
	i32.const	$push1=, -1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.func_32,"ax",@progbits
	.type	func_32,@function       # -- Begin function func_32
func_32:                                # @func_32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, -1
	i32.store	g_261($pop1), $pop0
	block   	
	i32.const	$push5=, 0
	i32.load	$push2=, g_211($pop5)
	i32.const	$push4=, -1
	i32.eq  	$push3=, $pop2, $pop4
	br_if   	0, $pop3        # 0: down to label1
# %bb.1:                                # %for.end
	return
.LBB1_2:                                # %if.else
                                        # =>This Inner Loop Header: Depth=1
	end_block                       # label1:
	loop    	                # label2:
	br      	0               # 0: up to label2
.LBB1_3:
	end_loop
	.endfunc
.Lfunc_end1:
	.size	func_32, .Lfunc_end1-func_32
                                        # -- End function
	.hidden	g_261                   # @g_261
	.type	g_261,@object
	.section	.bss.g_261,"aw",@nobits
	.globl	g_261
	.p2align	2
g_261:
	.int32	0                       # 0x0
	.size	g_261, 4

	.hidden	g_21                    # @g_21
	.type	g_21,@object
	.section	.bss.g_21,"aw",@nobits
	.globl	g_21
	.p2align	2
g_21:
	.int32	0                       # 0x0
	.size	g_21, 4

	.hidden	g_211                   # @g_211
	.type	g_211,@object
	.section	.bss.g_211,"aw",@nobits
	.globl	g_211
	.p2align	2
g_211:
	.int32	0                       # 0x0
	.size	g_211, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
