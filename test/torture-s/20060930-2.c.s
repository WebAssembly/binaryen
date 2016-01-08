	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20060930-2.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, s
	i32.store	$discard=, 0($1), $pop0
	i32.const	$push1=, 0
	i32.load	$push2=, t($pop1)
	i32.store	$discard=, 0($0), $pop2
	i32.load	$push3=, 0($1)
	return  	$pop3
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, s
	block   	.LBB1_2
	i32.call	$push2=, bar, $1, $1
	i32.const	$push0=, t
	i32.store	$push1=, t($0), $pop0
	i32.ne  	$push3=, $pop2, $pop1
	br_if   	$pop3, .LBB1_2
# BB#1:                                 # %if.end
	return  	$0
.LBB1_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.align	2
s:
	.skip	4
	.size	s, 4

	.hidden	t                       # @t
	.type	t,@object
	.section	.bss.t,"aw",@nobits
	.globl	t
	.align	2
t:
	.skip	4
	.size	t, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
