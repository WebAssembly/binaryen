	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20131127-1.c"
	.section	.text.fn1,"ax",@progbits
	.hidden	fn1
	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.param  	i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push0=, 12
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 0
	i32.load16_u	$push3=, c+12($pop2):p2align=0
	i32.store16	$discard=, 0($pop1):p2align=0, $pop3
	i32.const	$push8=, 0
	i64.load	$1=, c($pop8):p2align=0
	i32.const	$push4=, 8
	i32.add 	$push5=, $0, $pop4
	i32.const	$push7=, 0
	i32.load	$push6=, c+8($pop7):p2align=0
	i32.store	$discard=, 0($pop5):p2align=0, $pop6
	i64.store	$discard=, 0($0):p2align=0, $1
	return
	.endfunc
.Lfunc_end0:
	.size	fn1, .Lfunc_end0-fn1

	.section	.text.fn2,"ax",@progbits
	.hidden	fn2
	.globl	fn2
	.type	fn2,@function
fn2:                                    # @fn2
	.local  	i64, i32, i32, i64, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$4=, c+8($pop0):p2align=0
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.load16_u	$push1=, c+12($pop9):p2align=0
	i32.store16	$discard=, b+12($pop10):p2align=0, $pop1
	i32.const	$push8=, 0
	i32.store	$discard=, b+8($pop8):p2align=0, $4
	i32.const	$push7=, 0
	i64.load	$0=, c($pop7):p2align=0
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i32.store16	$push4=, a($pop6), $pop5
	tee_local	$push3=, $4=, $pop4
	i32.load16_u	$1=, e+12($pop3):p2align=0
	i32.load	$2=, e+8($4):p2align=0
	i64.load	$3=, e($4):p2align=0
	i32.const	$push2=, 0
	i64.store	$discard=, b($pop2):p2align=0, $0
	i32.store16	$discard=, d+12($4):p2align=0, $1
	i32.store	$discard=, d+8($4):p2align=0, $2
	i64.store	$discard=, d($4):p2align=0, $3
	return
	.endfunc
.Lfunc_end1:
	.size	fn2, .Lfunc_end1-fn2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i64, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$4=, c+8($pop0):p2align=0
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.load16_u	$push1=, c+12($pop9):p2align=0
	i32.store16	$discard=, b+12($pop10):p2align=0, $pop1
	i32.const	$push8=, 0
	i32.store	$discard=, b+8($pop8):p2align=0, $4
	i32.const	$push7=, 0
	i64.load	$0=, c($pop7):p2align=0
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i32.store16	$push4=, a($pop6), $pop5
	tee_local	$push3=, $4=, $pop4
	i32.load16_u	$1=, e+12($pop3):p2align=0
	i32.load	$2=, e+8($4):p2align=0
	i64.load	$3=, e($4):p2align=0
	i32.const	$push2=, 0
	i64.store	$discard=, b($pop2):p2align=0, $0
	i32.store16	$discard=, d+12($4):p2align=0, $1
	i32.store	$discard=, d+8($4):p2align=0, $2
	i64.store	$discard=, d($4):p2align=0, $3
	return  	$4
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
