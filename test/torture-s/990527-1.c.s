	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990527-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push3=, 0
	i32.load	$push1=, sum($pop3)
	i32.add 	$push2=, $pop1, $0
	i32.store	$discard=, sum($pop0), $pop2
	return
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, sum($pop5)
	i32.add 	$push2=, $0, $pop1
	i32.const	$push3=, 81
	i32.add 	$push4=, $pop2, $pop3
	i32.store	$discard=, sum($pop0), $pop4
	return
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.load	$push3=, sum($pop4)
	tee_local	$push2=, $0=, $pop3
	i32.const	$push0=, 81
	i32.add 	$push1=, $pop2, $pop0
	i32.store	$discard=, sum($pop5), $pop1
	block
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	sum                     # @sum
	.type	sum,@object
	.section	.bss.sum,"aw",@nobits
	.globl	sum
	.p2align	2
sum:
	.int32	0                       # 0x0
	.size	sum, 4


	.ident	"clang version 3.9.0 "
