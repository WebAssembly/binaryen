	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20131127-1.c"
	.section	.text.fn1,"ax",@progbits
	.hidden	fn1
	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 12
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 0
	i32.load16_u	$push3=, c+12($pop2):p2align=0
	i32.store16	$drop=, 0($pop1):p2align=0, $pop3
	i32.const	$push4=, 8
	i32.add 	$push5=, $0, $pop4
	i32.const	$push9=, 0
	i32.load	$push6=, c+8($pop9):p2align=0
	i32.store	$drop=, 0($pop5):p2align=0, $pop6
	i32.const	$push8=, 0
	i64.load	$push7=, c($pop8):p2align=0
	i64.store	$drop=, 0($0):p2align=0, $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	fn1, .Lfunc_end0-fn1

	.section	.text.fn2,"ax",@progbits
	.hidden	fn2
	.globl	fn2
	.type	fn2,@function
fn2:                                    # @fn2
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push15=, 0
	i32.load16_u	$push1=, c+12($pop15):p2align=0
	i32.store16	$drop=, b+12($pop0):p2align=0, $pop1
	i32.const	$push14=, 0
	i32.const	$push13=, 0
	i32.load	$push2=, c+8($pop13):p2align=0
	i32.store	$drop=, b+8($pop14):p2align=0, $pop2
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i64.load	$push3=, c($pop11):p2align=0
	i64.store	$drop=, b($pop12):p2align=0, $pop3
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.store16	$push8=, a($pop10), $pop9
	tee_local	$push7=, $0=, $pop8
	i32.load16_u	$push4=, e+12($0):p2align=0
	i32.store16	$drop=, d+12($pop7):p2align=0, $pop4
	i32.load	$push5=, e+8($0):p2align=0
	i32.store	$drop=, d+8($0):p2align=0, $pop5
	i64.load	$push6=, e($0):p2align=0
	i64.store	$drop=, d($0):p2align=0, $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	fn2, .Lfunc_end1-fn2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push15=, 0
	i32.load16_u	$push1=, c+12($pop15):p2align=0
	i32.store16	$drop=, b+12($pop0):p2align=0, $pop1
	i32.const	$push14=, 0
	i32.const	$push13=, 0
	i32.load	$push2=, c+8($pop13):p2align=0
	i32.store	$drop=, b+8($pop14):p2align=0, $pop2
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i64.load	$push3=, c($pop11):p2align=0
	i64.store	$drop=, b($pop12):p2align=0, $pop3
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.store16	$push8=, a($pop10), $pop9
	tee_local	$push7=, $0=, $pop8
	i32.load16_u	$push4=, e+12($0):p2align=0
	i32.store16	$drop=, d+12($pop7):p2align=0, $pop4
	i32.load	$push5=, e+8($0):p2align=0
	i32.store	$drop=, d+8($0):p2align=0, $pop5
	i64.load	$push6=, e($0):p2align=0
	i64.store	$drop=, d($0):p2align=0, $pop6
	copy_local	$push16=, $0
                                        # fallthrough-return: $pop16
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

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


	.ident	"clang version 3.9.0 "
