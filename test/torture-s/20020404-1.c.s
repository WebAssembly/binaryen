	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020404-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push11=, 0
	i64.const	$push1=, 3735928559
	i64.store	$push0=, bfd_make_section_anyway.foo_section+8($pop11), $pop1
	i64.store	$drop=, bfd_make_section_anyway.foo_section+16($pop2), $pop0
	i32.const	$push10=, 0
	i64.const	$push3=, 0
	i64.store	$drop=, bfd_make_section_anyway.foo_section+24($pop10), $pop3
	i32.const	$push9=, 0
	i32.const	$push8=, 0
	i32.load8_u	$push4=, bfd_make_section_anyway.foo_section($pop8)
	i32.const	$push5=, 1
	i32.or  	$push6=, $pop4, $pop5
	i32.store8	$drop=, bfd_make_section_anyway.foo_section($pop9), $pop6
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	bfd_make_section_anyway.foo_section,@object # @bfd_make_section_anyway.foo_section
	.lcomm	bfd_make_section_anyway.foo_section,32,3

	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
