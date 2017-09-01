	.text
	.file	"pr43629.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push1=, 0
	i32.load	$push0=, flag($pop1)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end4
	i32.const	$push2=, 0
	return  	$pop2
.LBB0_2:                                # %if.then3
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	flag                    # @flag
	.type	flag,@object
	.section	.bss.flag,"aw",@nobits
	.globl	flag
	.p2align	2
flag:
	.int32	0                       # 0x0
	.size	flag, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
