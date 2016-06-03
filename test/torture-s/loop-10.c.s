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
	i32.load	$push3=, count($pop4)
	tee_local	$push2=, $0=, $pop3
	i32.const	$push0=, 2
	i32.add 	$push1=, $pop2, $pop0
	i32.store	$drop=, count($pop5), $pop1
	block
	br_if   	0, $0           # 0: down to label0
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
	.functype	abort, void
