	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980602-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, t($0)
	i32.const	$2=, 1073741823
	block
	i32.const	$push1=, 1
	i32.add 	$push2=, $1, $pop1
	i32.and 	$push3=, $pop2, $2
	i32.const	$push4=, -1073741824
	i32.and 	$push5=, $1, $pop4
	i32.or  	$push6=, $pop3, $pop5
	i32.store	$discard=, t($0), $pop6
	i32.and 	$push0=, $1, $2
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %if.then
	call    	exit@FUNCTION, $0
	unreachable
.LBB0_2:                                # %if.else
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	t                       # @t
	.type	t,@object
	.section	.bss.t,"aw",@nobits
	.globl	t
	.align	2
t:
	.skip	4
	.size	t, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
