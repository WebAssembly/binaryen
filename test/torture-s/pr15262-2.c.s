	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr15262-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load	$0=, 0($0)
	i32.const	$push1=, 0
	f32.load	$push0=, 0($2)
	i32.const	$push7=, 0
	f32.load	$push2=, X($pop7)
	f32.add 	$push3=, $pop0, $pop2
	f32.store	$discard=, X($pop1), $pop3
	i32.const	$push4=, 3
	i32.store	$discard=, 0($0), $pop4
	i32.const	$push5=, 2
	i32.store	$discard=, 0($1), $pop5
	i32.load	$push6=, 0($0)
	return  	$pop6
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	f32.load	$push1=, X($pop5)
	tee_local	$push4=, $0=, $pop1
	f32.add 	$push2=, $pop4, $0
	f32.store	$discard=, X($pop0), $pop2
	i32.const	$push3=, 0
	return  	$pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	X                       # @X
	.type	X,@object
	.section	.bss.X,"aw",@nobits
	.globl	X
	.p2align	2
X:
	.int32	0                       # float 0
	.size	X, 4


	.ident	"clang version 3.9.0 "
