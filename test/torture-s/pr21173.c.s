	.text
	.file	"pr21173.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, q
	i32.sub 	$0=, $0, $pop0
	i32.const	$push1=, 0
	i32.const	$push8=, 0
	i32.load	$push2=, a($pop8)
	i32.add 	$push3=, $pop2, $0
	i32.store	a($pop1), $pop3
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.load	$push4=, a+4($pop6)
	i32.add 	$push5=, $pop4, $0
	i32.store	a+4($pop7), $pop5
                                        # fallthrough-return
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
# %bb.0:                                # %entry
	block   	
	i32.const	$push4=, 0
	i32.load	$push1=, a($pop4)
	i32.const	$push3=, 0
	i32.load	$push0=, a+4($pop3)
	i32.or  	$push2=, $pop1, $pop0
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %for.cond.1
	i32.const	$push5=, 0
	return  	$pop5
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	q                       # @q
	.type	q,@object
	.section	.bss.q,"aw",@nobits
	.globl	q
q:
	.int8	0                       # 0x0
	.size	q, 1

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.skip	8
	.size	a, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
