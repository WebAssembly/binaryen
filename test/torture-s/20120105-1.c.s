	.text
	.file	"20120105-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 16
	i32.sub 	$0=, $pop5, $pop7
	i32.const	$push8=, 0
	i32.store	__stack_pointer($pop8), $0
	i64.const	$push0=, 0
	i64.store	5($0):p2align=0, $pop0
	i64.const	$push13=, 0
	i64.store	0($0), $pop13
	i32.const	$push4=, 0
	i32.const	$push1=, 1
	i32.or  	$push2=, $0, $pop1
	i32.call	$push3=, extract@FUNCTION, $pop2
	i32.store	i($pop4), $pop3
	i32.const	$push11=, 0
	i32.const	$push9=, 16
	i32.add 	$push10=, $0, $pop9
	i32.store	__stack_pointer($pop11), $pop10
	i32.const	$push12=, 0
                                        # fallthrough-return: $pop12
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.extract,"ax",@progbits
	.type	extract,@function       # -- Begin function extract
extract:                                # @extract
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.load	$push0=, 0($0):p2align=0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	extract, .Lfunc_end1-extract
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
