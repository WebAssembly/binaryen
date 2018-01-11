	.text
	.file	"pr52209.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push11=, 0
	i32.load8_u	$0=, c($pop11)
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.const	$push0=, 1
	i32.and 	$push1=, $0, $pop0
	i32.sub 	$push2=, $pop9, $pop1
	i32.const	$push3=, -1
	i32.xor 	$push4=, $pop2, $pop3
	i32.store	b($pop10), $pop4
	block   	
	i32.const	$push5=, 7
	i32.shl 	$push6=, $0, $pop5
	i32.const	$push7=, 128
	i32.and 	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push12=, 0
	return  	$pop12
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
