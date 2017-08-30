	.text
	.file	"pr52209.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.load8_u	$push0=, c($pop7)
	i32.const	$push1=, 1
	i32.and 	$push6=, $pop0, $pop1
	tee_local	$push5=, $0=, $pop6
	i32.sub 	$push2=, $pop8, $pop5
	i32.const	$push3=, -1
	i32.xor 	$push4=, $pop2, $pop3
	i32.store	b($pop9), $pop4
	block   	
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push10=, 0
	return  	$pop10
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.skip	4
	.size	c, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
