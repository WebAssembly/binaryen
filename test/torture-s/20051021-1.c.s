	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20051021-1.c"
	.section	.text.foo1,"ax",@progbits
	.hidden	foo1
	.globl	foo1
	.type	foo1,@function
foo1:                                   # @foo1
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, count($0)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, count($0), $pop2
	return  	$0
.Lfunc_end0:
	.size	foo1, .Lfunc_end0-foo1

	.section	.text.foo2,"ax",@progbits
	.hidden	foo2
	.globl	foo2
	.type	foo2,@function
foo2:                                   # @foo2
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, count($0)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, count($0), $pop2
	return  	$0
.Lfunc_end1:
	.size	foo2, .Lfunc_end1-foo2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, count($0)
	block
	i32.const	$push0=, 2
	i32.add 	$push1=, $1, $pop0
	i32.store	$discard=, count($0), $pop1
	br_if   	$1, 0           # 0: down to label0
# BB#1:                                 # %if.end7
	return  	$0
.LBB2_2:                                # %if.then6
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	count                   # @count
	.type	count,@object
	.section	.bss.count,"aw",@nobits
	.globl	count
	.align	2
count:
	.int32	0                       # 0x0
	.size	count, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
