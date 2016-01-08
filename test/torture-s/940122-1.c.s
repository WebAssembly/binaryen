	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/940122-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block   	.LBB0_2
	i32.load	$push0=, a($1)
	i32.ne  	$push1=, $pop0, $1
	i32.load	$push2=, b($1)
	i32.ne  	$push3=, $pop2, $1
	i32.ne  	$push4=, $pop1, $pop3
	br_if   	$pop4, .LBB0_2
# BB#1:                                 # %if.end
	return  	$1
.LBB0_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block   	.LBB1_2
	i32.load	$push0=, a($1)
	i32.ne  	$push1=, $pop0, $1
	i32.load	$push2=, b($1)
	i32.ne  	$push3=, $pop2, $1
	i32.ne  	$push4=, $pop1, $pop3
	br_if   	$pop4, .LBB1_2
# BB#1:                                 # %g.exit
	return  	$1
.LBB1_2:                                # %if.then.i
	call    	abort
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
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB2_2
	i32.load	$push0=, a($0)
	i32.ne  	$push1=, $pop0, $0
	i32.load	$push2=, b($0)
	i32.ne  	$push3=, $pop2, $0
	i32.eq  	$push4=, $pop1, $pop3
	br_if   	$pop4, .LBB2_2
# BB#1:                                 # %if.then.i.i
	call    	abort
	unreachable
.LBB2_2:                                # %f.exit
	call    	exit, $0
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	2
a:
	.int32	0
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	2
b:
	.int32	0
	.size	b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
