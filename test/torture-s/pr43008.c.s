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
	i32.call	$push1=, __builtin_malloc@FUNCTION, $pop0
	tee_local	$push3=, $0=, $pop1
	i32.const	$push2=, i
	i32.store	$discard=, 0($pop3), $pop2
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
	i32.call	$push1=, __builtin_malloc@FUNCTION, $pop0
	tee_local	$push11=, $1=, $pop1
	i32.const	$push2=, i
	i32.store	$0=, 0($pop11), $pop2
	i32.const	$push10=, 4
	i32.call	$push3=, __builtin_malloc@FUNCTION, $pop10
	i32.store	$discard=, 0($pop3), $0
	i32.load	$push4=, 0($1)
	tee_local	$push9=, $1=, $pop4
	i32.const	$push5=, 1
	i32.store	$discard=, 0($pop9), $pop5
	i32.const	$push6=, 0
	i32.const	$push8=, 0
	i32.store	$0=, i($pop6), $pop8
	block
	i32.load	$push7=, 0($1)
	br_if   	$pop7, 0        # 0: down to label0
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
