	.text
	.file	"pr17252.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push0=, a
	i32.store	a($pop7), $pop0
	i32.const	$push6=, 0
	i32.const	$push1=, a+1
	i32.store8	a($pop6), $pop1
	block   	
	i32.const	$push5=, 0
	i32.load	$push2=, a($pop5)
	i32.const	$push4=, a
	i32.eq  	$push3=, $pop2, $pop4
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push8=, 0
	return  	$pop8
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0
	.size	a, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
