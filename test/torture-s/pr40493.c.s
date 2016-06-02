	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr40493.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push1=, 22
	i32.store	$2=, x01($pop2), $pop1
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.const	$push3=, 2
	i32.store	$push0=, x00($pop6), $pop3
	i32.store	$drop=, y00($pop7), $pop0
	i32.const	$push5=, 0
	i32.store	$drop=, y01($pop5), $2
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	x00                     # @x00
	.type	x00,@object
	.section	.bss.x00,"aw",@nobits
	.globl	x00
	.p2align	2
x00:
	.int32	0                       # 0x0
	.size	x00, 4

	.hidden	x01                     # @x01
	.type	x01,@object
	.section	.bss.x01,"aw",@nobits
	.globl	x01
	.p2align	2
x01:
	.int32	0                       # 0x0
	.size	x01, 4

	.hidden	y00                     # @y00
	.type	y00,@object
	.section	.bss.y00,"aw",@nobits
	.globl	y00
	.p2align	2
y00:
	.int32	0                       # 0x0
	.size	y00, 4

	.hidden	y01                     # @y01
	.type	y01,@object
	.section	.bss.y01,"aw",@nobits
	.globl	y01
	.p2align	2
y01:
	.int32	0                       # 0x0
	.size	y01, 4


	.ident	"clang version 3.9.0 "
