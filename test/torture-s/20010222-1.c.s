	.text
	.file	"20010222-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push10=, 0
	i32.load	$push1=, a+4($pop10)
	i32.const	$push9=, 0
	i32.load	$push0=, a($pop9)
	i32.add 	$push2=, $pop1, $pop0
	i32.const	$push3=, -3
	i32.mul 	$push4=, $pop2, $pop3
	i32.const	$push5=, 83
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push7=, 12
	i32.lt_u	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	18                      # 0x12
	.int32	6                       # 0x6
	.size	a, 8


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
