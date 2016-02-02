	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031214-1.c"
	.section	.text.b,"ax",@progbits
	.hidden	b
	.globl	b
	.type	b,@function
b:                                      # @b
	.param  	i32
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end0:
	.size	b, .Lfunc_end0-b

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push17=, 0
	i32.load	$push1=, k($pop17)
	tee_local	$push16=, $1=, $pop1
	i32.const	$push15=, 0
	i32.load	$push2=, g+8($pop15):p2align=3
	tee_local	$push14=, $0=, $pop2
	i32.gt_s	$push3=, $pop16, $pop14
	i32.select	$push4=, $pop3, $1, $0
	tee_local	$push13=, $1=, $pop4
	i32.const	$push12=, 0
	i32.load	$push5=, g+12($pop12)
	tee_local	$push11=, $0=, $pop5
	i32.gt_s	$push6=, $pop13, $pop11
	i32.select	$push7=, $pop6, $1, $0
	i32.const	$push8=, 1
	i32.add 	$push9=, $pop7, $pop8
	i32.store	$discard=, k($pop0), $pop9
	i32.const	$push10=, 0
	return  	$pop10
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	g                       # @g
	.type	g,@object
	.section	.data.g,"aw",@progbits
	.globl	g
	.p2align	3
g:
	.int64	0                       # double 0
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.size	g, 16

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	2
k:
	.int32	0                       # 0x0
	.size	k, 4


	.ident	"clang version 3.9.0 "
