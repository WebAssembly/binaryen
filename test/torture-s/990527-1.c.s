	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990527-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$push0=, sum($1)
	i32.add 	$push1=, $pop0, $0
	i32.store	$discard=, sum($1), $pop1
	return
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$push0=, sum($1)
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 81
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$discard=, sum($1), $pop3
	return
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
	i32.load	$1=, sum($0)
	block
	i32.const	$push0=, 81
	i32.add 	$push1=, $1, $pop0
	i32.store	$discard=, sum($0), $pop1
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

	.hidden	sum                     # @sum
	.type	sum,@object
	.section	.bss.sum,"aw",@nobits
	.globl	sum
	.align	2
sum:
	.int32	0                       # 0x0
	.size	sum, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
