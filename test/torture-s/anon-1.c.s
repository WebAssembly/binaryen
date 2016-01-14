	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/anon-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.const	$push0=, 6
	i32.store	$discard=, foo+8($2), $pop0
	i32.const	$push1=, 5
	i32.store	$discard=, foo+4($2), $pop1
	return  	$2
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	foo                     # @foo
	.type	foo,@object
	.section	.bss.foo,"aw",@nobits
	.globl	foo
	.align	2
foo:
	.skip	12
	.size	foo, 12


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
