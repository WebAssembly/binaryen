	.text
	.file	"pr57568.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	block   	
	block   	
	i32.const	$push3=, 0
	i32.load	$push0=, b($pop3)
	i32.eqz 	$push6=, $pop0
	br_if   	0, $pop6        # 0: down to label1
# %bb.1:                                # %land.lhs.true
	i32.const	$push4=, 0
	i32.load	$0=, c($pop4)
	i32.load	$1=, 0($0)
	i32.const	$push1=, 1
	i32.shl 	$push2=, $1, $pop1
	i32.store	0($0), $pop2
	br_if   	1, $1           # 1: down to label0
.LBB0_2:                                # %if.end
	end_block                       # label1:
	i32.const	$push5=, 0
	return  	$pop5
.LBB0_3:                                # %if.then
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
	.p2align	4
a:
	.skip	216
	.size	a, 216

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.p2align	2
b:
	.int32	1                       # 0x1
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.p2align	2
c:
	.int32	a+128
	.size	c, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
