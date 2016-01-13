	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-3b.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$push0=, n($1)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, n($1), $pop2
	return  	$1
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 268435455
	i32.const	$1=, 0
	i32.load	$push0=, n($1)
	i32.lt_s	$push1=, $0, $2
	i32.select	$push2=, $pop1, $0, $2
	i32.const	$push3=, -1
	i32.xor 	$push4=, $pop2, $pop3
	i32.add 	$push5=, $0, $pop4
	i32.add 	$push6=, $pop5, $2
	i32.div_u	$push7=, $pop6, $2
	i32.add 	$push8=, $pop0, $pop7
	i32.const	$push9=, 1
	i32.add 	$push10=, $pop8, $pop9
	i32.store	$discard=, n($1), $pop10
	return  	$2
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, n($0)
	block
	i32.const	$push0=, 4
	i32.add 	$push1=, $1, $pop0
	i32.store	$discard=, n($0), $pop1
	br_if   	$1, 0           # 0: down to label0
# BB#1:                                 # %if.end
	call    	exit@FUNCTION, $0
	unreachable
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	n                       # @n
	.type	n,@object
	.section	.bss.n,"aw",@nobits
	.globl	n
	.align	2
n:
	.int32	0                       # 0x0
	.size	n, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
