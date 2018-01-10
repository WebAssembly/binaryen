	.text
	.file	"struct-ini-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push10=, 0
	i32.load8_u	$push2=, object($pop10)
	i32.const	$push3=, 88
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %entry
	i32.const	$push11=, 0
	i32.load	$push0=, object+4($pop11)
	i32.const	$push5=, 8
	i32.ne  	$push6=, $pop0, $pop5
	br_if   	0, $pop6        # 0: down to label0
# %bb.2:                                # %entry
	i32.const	$push12=, 0
	i32.load	$push1=, object+8($pop12)
	i32.const	$push7=, 9
	i32.ne  	$push8=, $pop1, $pop7
	br_if   	0, $pop8        # 0: down to label0
# %bb.3:                                # %if.end
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
.LBB0_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	object                  # @object
	.type	object,@object
	.section	.data.object,"aw",@progbits
	.globl	object
	.p2align	2
object:
	.int8	88                      # 0x58
	.skip	3
	.int32	8                       # 0x8
	.int32	9                       # 0x9
	.size	object, 12


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
