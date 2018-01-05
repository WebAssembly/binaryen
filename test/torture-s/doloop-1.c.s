	.text
	.file	"doloop-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$0=, 0
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.load	$push0=, i($pop9)
	i32.const	$push8=, 1
	i32.add 	$push1=, $pop0, $pop8
	i32.store	i($pop10), $pop1
	i32.const	$push7=, -1
	i32.add 	$0=, $0, $pop7
	i32.const	$push6=, 255
	i32.and 	$push2=, $0, $pop6
	br_if   	0, $pop2        # 0: up to label0
# %bb.2:                                # %do.end
	end_loop
	block   	
	i32.const	$push11=, 0
	i32.load	$push3=, i($pop11)
	i32.const	$push4=, 256
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label1
# %bb.3:                                # %if.end
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
	unreachable
.LBB0_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
