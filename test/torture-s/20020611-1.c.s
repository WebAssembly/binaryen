	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020611-1.c"
	.section	.text.x,"ax",@progbits
	.hidden	x
	.globl	x
	.type	x,@function
x:                                      # @x
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i32.load	$push2=, n($pop5)
	i32.const	$push3=, 31
	i32.lt_u	$push4=, $pop2, $pop3
	i32.store	$push0=, p($pop6), $pop4
	i32.store	$drop=, k($pop1), $pop0
                                        # fallthrough-return
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
	i32.load	$push2=, n($pop5)
	i32.const	$push3=, 31
	i32.lt_u	$push4=, $pop2, $pop3
	i32.store	$push0=, p($pop6), $pop4
	i32.store	$push1=, k($pop7), $pop0
	i32.eqz 	$push9=, $pop1
	br_if   	0, $pop9        # 0: down to label0
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
	.functype	abort, void
	.functype	exit, void, i32
