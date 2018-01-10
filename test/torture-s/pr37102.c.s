	.text
	.file	"pr37102.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 5
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push9=, 0
	i32.load	$0=, b($pop9)
	block   	
	i32.const	$push8=, 0
	i32.load	$push0=, c($pop8)
	i32.eqz 	$push14=, $pop0
	br_if   	0, $pop14       # 0: down to label1
# %bb.1:                                # %if.then.3
	i32.const	$push10=, 0
	i32.store	a($pop10), $0
.LBB1_2:                                # %for.inc.3
	end_block                       # label1:
	i32.const	$push13=, 0
	i32.store	a($pop13), $0
	i32.const	$push3=, 2
	i32.shl 	$push4=, $0, $pop3
	i32.const	$push5=, 1
	i32.or  	$push6=, $pop4, $pop5
	i32.const	$push12=, 0
	i32.const	$push1=, 2147483647
	i32.and 	$push2=, $0, $pop1
	i32.select	$push7=, $pop6, $pop12, $pop2
	call    	foo@FUNCTION, $pop7
	i32.const	$push11=, 0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
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
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
