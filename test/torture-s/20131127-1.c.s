	.text
	.file	"20131127-1.c"
	.section	.text.fn1,"ax",@progbits
	.hidden	fn1                     # -- Begin function fn1
	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 6
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 0
	i64.load	$push3=, c+6($pop2):p2align=0
	i64.store	0($pop1):p2align=0, $pop3
	i32.const	$push5=, 0
	i64.load	$push4=, c($pop5):p2align=0
	i64.store	0($0):p2align=0, $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	fn1, .Lfunc_end0-fn1
                                        # -- End function
	.section	.text.fn2,"ax",@progbits
	.hidden	fn2                     # -- Begin function fn2
	.globl	fn2
	.type	fn2,@function
fn2:                                    # @fn2
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push13=, 0
	i64.load	$push1=, c+6($pop13):p2align=0
	i64.store	b+6($pop0):p2align=0, $pop1
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i64.load	$push2=, c($pop11):p2align=0
	i64.store	b($pop12):p2align=0, $pop2
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i64.load	$push3=, e($pop9):p2align=0
	i64.store	d($pop10):p2align=0, $pop3
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i64.load	$push4=, e+6($pop7):p2align=0
	i64.store	d+6($pop8):p2align=0, $pop4
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i32.store16	a($pop6), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	fn2, .Lfunc_end1-fn2
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i64.load	$push1=, c+6($pop14):p2align=0
	i64.store	b+6($pop0):p2align=0, $pop1
	i32.const	$push13=, 0
	i32.const	$push12=, 0
	i64.load	$push2=, c($pop12):p2align=0
	i64.store	b($pop13):p2align=0, $pop2
	i32.const	$push11=, 0
	i32.const	$push10=, 0
	i64.load	$push3=, e($pop10):p2align=0
	i64.store	d($pop11):p2align=0, $pop3
	i32.const	$push9=, 0
	i32.const	$push8=, 0
	i64.load	$push4=, e+6($pop8):p2align=0
	i64.store	d+6($pop9):p2align=0, $pop4
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.store16	a($pop7), $pop6
	i32.const	$push5=, 0
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	1
a:
	.int16	1                       # 0x1
	.size	a, 2

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
b:
	.int32	1                       # 0x1
	.int32	0                       # 0x0
	.int32	0                       # 0x0
	.int16	0                       # 0x0
	.size	b, 14

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
c:
	.skip	14
	.size	c, 14

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
d:
	.skip	14
	.size	d, 14

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
e:
	.skip	14
	.size	e, 14


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
