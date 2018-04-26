	.text
	.file	"pr61306-3.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push8=, 0
	i32.load16_s	$0=, a($pop8)
	i32.const	$push7=, 0
	i32.store8	c($pop7), $0
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push6=, 24
	i32.shr_s	$push2=, $pop1, $pop6
	i32.or  	$0=, $0, $pop2
	i32.const	$push5=, 0
	i32.store	b($pop5), $0
	block   	
	i32.const	$push3=, -1
	i32.ne  	$push4=, $0, $pop3
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push9=, 0
	return  	$pop9
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
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	1
a:
	.int16	65535                   # 0xffff
	.size	a, 2

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
c:
	.int8	0                       # 0x0
	.size	c, 1

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
