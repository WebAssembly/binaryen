	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020611-1.c"
	.section	.text.x,"ax",@progbits
	.hidden	x
	.globl	x
	.type	x,@function
x:                                      # @x
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, n($pop5)
	i32.const	$push2=, 31
	i32.lt_u	$push3=, $pop1, $pop2
	i32.store	$push4=, p($pop6), $pop3
	i32.store	$discard=, k($pop0), $pop4
	return
	.endfunc
.Lfunc_end0:
	.size	x, .Lfunc_end0-x

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i32.load	$push0=, n($pop5)
	i32.const	$push1=, 31
	i32.lt_u	$push2=, $pop0, $pop1
	i32.store	$push3=, p($pop6), $pop2
	i32.store	$push4=, k($pop7), $pop3
	i32.const	$push9=, 0
	i32.eq  	$push10=, $pop4, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push8=, 0
	call    	exit@FUNCTION, $pop8
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	n                       # @n
	.type	n,@object
	.section	.data.n,"aw",@progbits
	.globl	n
	.p2align	2
n:
	.int32	30                      # 0x1e
	.size	n, 4

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0                       # 0x0
	.size	p, 4

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	2
k:
	.int32	0                       # 0x0
	.size	k, 4


	.ident	"clang version 3.9.0 "
