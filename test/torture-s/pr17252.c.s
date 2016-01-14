	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr17252.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.const	$push0=, a
	i32.store	$1=, a($0), $pop0
	i32.const	$push1=, a+1
	i32.store8	$discard=, a($0), $pop1
	i32.load	$push2=, a($0)
	i32.eq  	$push3=, $pop2, $1
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %if.end
	return  	$0
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	2
a:
	.int32	0
	.size	a, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
