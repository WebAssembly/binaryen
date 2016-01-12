	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930408-1.c"
	.section	.text.p,"ax",@progbits
	.hidden	p
	.globl	p
	.type	p,@function
p:                                      # @p
	.result 	i32
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	p, .Lfunc_end0-p

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	.LBB1_2
	i32.const	$push0=, 0
	i32.load	$push1=, s($pop0)
	i32.const	$push2=, 0
	i32.eq  	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB1_2
# BB#1:                                 # %sw.epilog
	return  	$0
.LBB1_2:                                # %sw.bb
	i32.call	$discard=, p@FUNCTION
	unreachable
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %f.exit
	i32.const	$0=, 0
	i32.const	$push0=, 1
	i32.store	$discard=, s($0), $pop0
	call    	exit@FUNCTION, $0
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.align	2
s:
	.skip	4
	.size	s, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
