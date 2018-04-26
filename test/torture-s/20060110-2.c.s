	.text
	.file	"20060110-2.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i64, i64
	.result 	i64
# %bb.0:                                # %entry
	i64.add 	$push0=, $1, $0
	i64.const	$push1=, 32
	i64.shl 	$push2=, $pop0, $pop1
	i64.const	$push4=, 32
	i64.shr_s	$push3=, $pop2, $pop4
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push11=, 0
	i64.load	$push1=, b($pop11)
	i32.const	$push10=, 0
	i64.load	$push0=, a($pop10)
	i64.add 	$push2=, $pop1, $pop0
	i64.const	$push3=, 32
	i64.shl 	$push4=, $pop2, $pop3
	i64.const	$push9=, 32
	i64.shr_s	$push5=, $pop4, $pop9
	i32.const	$push8=, 0
	i64.load	$push6=, c($pop8)
	i64.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push12=, 0
	return  	$pop12
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	3
a:
	.int64	1311768466852950544     # 0x1234567876543210
	.size	a, 8

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.p2align	3
b:
	.int64	2541551395937657089     # 0x2345678765432101
	.size	b, 8

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.p2align	3
c:
	.int64	-610839791              # 0xffffffffdb975311
	.size	c, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
