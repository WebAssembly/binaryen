	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-10.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %while.end
	i32.const	$0=, 0
	i32.load	$1=, count($0)
	block
	i32.const	$push0=, 2
	i32.add 	$push1=, $1, $pop0
	i32.store	$discard=, count($0), $pop1
	br_if   	$1, 0           # 0: down to label0
# BB#1:                                 # %if.end4
	return  	$0
.LBB0_2:                                # %if.then3
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	count,@object           # @count
	.lcomm	count,4,2

	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
