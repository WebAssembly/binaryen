	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120817-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, foo($pop0)
	i32.const	$push2=, -1
	i32.add 	$push3=, $pop1, $pop2
	i64.extend_s/i32	$push4=, $pop3
	i64.const	$push5=, 24
	i64.mul 	$push6=, $pop4, $pop5
	i64.const	$push7=, 40
	i64.add 	$push8=, $pop6, $pop7
	return  	$pop8
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB1_2
	i64.call	$push0=, f
	i64.const	$push1=, 16
	i64.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB1_2
# BB#1:                                 # %if.end
	i32.const	$push3=, 0
	call    	exit, $pop3
	unreachable
.LBB1_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	foo                     # @foo
	.type	foo,@object
	.section	.bss.foo,"aw",@nobits
	.globl	foo
	.align	2
foo:
	.int32	0                       # 0x0
	.size	foo, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
