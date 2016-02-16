	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43008.c"
	.section	.text.my_alloc,"ax",@progbits
	.hidden	my_alloc
	.globl	my_alloc
	.type	my_alloc,@function
my_alloc:                               # @my_alloc
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.call	$push3=, __builtin_malloc@FUNCTION, $pop0
	tee_local	$push2=, $0=, $pop3
	i32.const	$push1=, i
	i32.store	$discard=, 0($pop2), $pop1
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	my_alloc, .Lfunc_end0-my_alloc

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.call	$push11=, __builtin_malloc@FUNCTION, $pop0
	tee_local	$push10=, $1=, $pop11
	i32.const	$push1=, i
	i32.store	$0=, 0($pop10), $pop1
	i32.const	$push9=, 4
	i32.call	$push2=, __builtin_malloc@FUNCTION, $pop9
	i32.store	$discard=, 0($pop2), $0
	i32.load	$push8=, 0($1)
	tee_local	$push7=, $1=, $pop8
	i32.const	$push3=, 1
	i32.store	$discard=, 0($pop7), $pop3
	i32.const	$push4=, 0
	i32.const	$push6=, 0
	i32.store	$0=, i($pop4), $pop6
	block
	i32.load	$push5=, 0($1)
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.end
	return  	$0
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4


	.ident	"clang version 3.9.0 "
