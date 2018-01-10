	.text
	.file	"20020213-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$0=, b($pop0)
	i32.const	$push1=, -1
	i32.add 	$1=, $0, $pop1
	i32.const	$push8=, 0
	i32.const	$push2=, 2241
	i32.const	$push7=, 2241
	i32.lt_s	$push3=, $1, $pop7
	i32.select	$push4=, $1, $pop2, $pop3
	i32.store	a+4($pop8), $pop4
	block   	
	i32.const	$push5=, 2242
	i32.le_s	$push6=, $0, $pop5
	br_if   	0, $pop6        # 0: down to label0
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
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	f32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 2241
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %foo.exit
	i32.const	$push1=, 0
	i32.const	$push0=, 3384
	i32.store	b($pop1), $pop0
	i32.const	$push4=, 0
	i64.const	$push2=, 9626087063552
	i64.store	a($pop4):p2align=2, $pop2
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.skip	8
	.size	a, 8

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
