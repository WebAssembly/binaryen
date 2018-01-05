	.text
	.file	"20040625-1.c"
	.section	.text.maybe_next,"ax",@progbits
	.hidden	maybe_next              # -- Begin function maybe_next
	.globl	maybe_next
	.type	maybe_next,@function
maybe_next:                             # @maybe_next
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.eqz 	$push0=, $1
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %if.then
	i32.load	$0=, 0($0):p2align=0
.LBB0_2:                                # %if.end
	end_block                       # label0:
	copy_local	$push1=, $0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	maybe_next, .Lfunc_end0-maybe_next
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$0=, $pop4, $pop6
	i32.const	$push7=, 0
	i32.store	__stack_pointer($pop7), $0
	i32.store	8($0), $0
	block   	
	i32.const	$push8=, 8
	i32.add 	$push9=, $0, $pop8
	i32.const	$push0=, 1
	i32.call	$push1=, maybe_next@FUNCTION, $pop9, $pop0
	i32.ne  	$push2=, $pop1, $0
	br_if   	0, $pop2        # 0: down to label1
# %bb.1:                                # %if.end
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
