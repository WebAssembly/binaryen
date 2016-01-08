	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071018-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 8
	i32.call	$push1=, __builtin_malloc, $pop0
	i32.store	$discard=, 0($0), $pop1
	return
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 16
	i32.call	$1=, __builtin_malloc, $pop0
	i32.const	$push1=, 5
	i32.shl 	$push2=, $0, $pop1
	i32.add 	$push3=, $pop2, $1
	i32.const	$push4=, -20
	i32.add 	$0=, $pop3, $pop4
	i32.const	$push5=, 0
	i32.store	$discard=, 0($0), $pop5
	call    	bar, $0
	i32.load	$push6=, 0($0)
	return  	$pop6
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB2_2
	i32.const	$push0=, 1
	i32.call	$push1=, foo, $pop0
	i32.const	$push3=, 0
	i32.eq  	$push4=, $pop1, $pop3
	br_if   	$pop4, .LBB2_2
# BB#1:                                 # %if.end
	i32.const	$push2=, 0
	return  	$pop2
.LBB2_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
