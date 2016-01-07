	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43008.c"
	.globl	my_alloc
	.type	my_alloc,@function
my_alloc:                               # @my_alloc
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.call	$0=, __builtin_malloc, $pop0
	i32.const	$push1=, i
	i32.store	$discard=, 0($0), $pop1
	return  	$0
.Lfunc_end0:
	.size	my_alloc, .Lfunc_end0-my_alloc

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 4
	i32.call	$1=, __builtin_malloc, $0
	i32.call	$push2=, __builtin_malloc, $0
	i32.const	$push0=, i
	i32.store	$push1=, 0($1), $pop0
	i32.store	$discard=, 0($pop2), $pop1
	i32.load	$0=, 0($1)
	i32.const	$push3=, 1
	i32.store	$discard=, 0($0), $pop3
	i32.const	$1=, 0
	i32.store	$discard=, i($1), $1
	block   	.LBB1_2
	i32.load	$push4=, 0($0)
	br_if   	$pop4, .LBB1_2
# BB#1:                                 # %if.end
	return  	$1
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	i,@object               # @i
	.bss
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
