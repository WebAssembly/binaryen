	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20090814-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($0)
	return  	$pop0
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, i($pop0)
	i32.const	$push2=, 2
	i32.shl 	$push3=, $pop1, $pop2
	i32.add 	$push4=, $0, $pop3
	i32.call	$push5=, bar, $pop4
	return  	$pop5
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

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
	i32.const	$push0=, -1
	i32.store	$discard=, a($0), $pop0
	i32.const	$push4=, 1
	i32.store	$discard=, i($0), $pop4
	i32.const	$push1=, a
	i32.call	$push5=, foo, $pop1
	i32.const	$push2=, 42
	i32.store	$push3=, a+4($0), $pop2
	i32.ne  	$push6=, $pop5, $pop3
	br_if   	$pop6, .LBB2_2
# BB#1:                                 # %if.end
	return  	$0
.LBB2_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	2
a:
	.skip	8
	.size	a, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
