	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-10.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %while.end
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.load	$push0=, count($pop4)
	tee_local	$push3=, $0=, $pop0
	i32.const	$push1=, 2
	i32.add 	$push2=, $pop3, $pop1
	i32.store	$discard=, count($pop5), $pop2
	block
	br_if   	$0, 0           # 0: down to label0
# BB#1:                                 # %if.end4
	i32.const	$push6=, 0
	return  	$pop6
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
