	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42721.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, b($0)
	block
	i32.const	$push0=, 1
	i32.xor 	$push1=, $1, $pop0
	i32.store	$discard=, b($0), $pop1
	br_if   	$1, 0           # 0: down to label0
# BB#1:                                 # %if.end
	return  	$0
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	b,@object               # @b
	.lcomm	b,4,2

	.ident	"clang version 3.9.0 "
