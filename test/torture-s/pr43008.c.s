	.text
	.file	"pr43008.c"
	.section	.text.my_alloc,"ax",@progbits
	.hidden	my_alloc                # -- Begin function my_alloc
	.globl	my_alloc
	.type	my_alloc,@function
my_alloc:                               # @my_alloc
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 4
	i32.call	$0=, __builtin_malloc@FUNCTION, $pop0
	i32.const	$push1=, i
	i32.store	0($0), $pop1
	copy_local	$push2=, $0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	my_alloc, .Lfunc_end0-my_alloc
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 4
	i32.call	$0=, __builtin_malloc@FUNCTION, $pop0
	i32.const	$push1=, i
	i32.store	0($0), $pop1
	i32.const	$push8=, 4
	i32.call	$push2=, __builtin_malloc@FUNCTION, $pop8
	i32.const	$push7=, i
	i32.store	0($pop2), $pop7
	i32.load	$0=, 0($0)
	i32.const	$push3=, 1
	i32.store	0($0), $pop3
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i32.store	i($pop6), $pop5
	block   	
	i32.load	$push4=, 0($0)
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push9=, 0
	return  	$pop9
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
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
	.functype	__builtin_malloc, i32
	.functype	abort, void
