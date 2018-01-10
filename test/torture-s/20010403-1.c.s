	.text
	.file	"20010403-1.c"
	.section	.text.a,"ax",@progbits
	.hidden	a                       # -- Begin function a
	.globl	a
	.type	a,@function
a:                                      # @a
	.param  	i32, i32
# %bb.0:                                # %c.exit
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	a, .Lfunc_end0-a
                                        # -- End function
	.section	.text.b,"ax",@progbits
	.hidden	b                       # -- Begin function b
	.globl	b
	.type	b,@function
b:                                      # @b
	.param  	i32
# %bb.0:                                # %entry
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	0($0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	b, .Lfunc_end1-b
                                        # -- End function
	.section	.text.c,"ax",@progbits
	.hidden	c                       # -- Begin function c
	.globl	c
	.type	c,@function
c:                                      # @c
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	i32.eq  	$push0=, $0, $1
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	c, .Lfunc_end2-c
                                        # -- End function
	.section	.text.d,"ax",@progbits
	.hidden	d                       # -- Begin function d
	.globl	d
	.type	d,@function
d:                                      # @d
	.param  	i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	d, .Lfunc_end3-d
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function
	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
