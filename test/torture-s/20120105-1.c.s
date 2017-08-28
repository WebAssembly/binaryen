	.text
	.file	"20120105-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 16
	i32.sub 	$push15=, $pop5, $pop7
	tee_local	$push14=, $0=, $pop15
	i32.store	__stack_pointer($pop8), $pop14
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
# BB#0:                                 # %entry
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
