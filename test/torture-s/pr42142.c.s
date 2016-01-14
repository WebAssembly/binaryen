	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42142.c"
	.section	.text.sort,"ax",@progbits
	.hidden	sort
	.globl	sort
	.type	sort,@function
sort:                                   # @sort
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 1
	i32.const	$push0=, 10
	i32.lt_s	$push1=, $0, $pop0
	i32.lt_s	$push2=, $0, $1
	i32.const	$push3=, 2
	i32.select	$push4=, $pop2, $pop3, $1
	i32.const	$push5=, 0
	i32.select	$push6=, $pop1, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end0:
	.size	sort, .Lfunc_end0-sort

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 5
	i32.call	$push1=, sort@FUNCTION, $pop0
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
