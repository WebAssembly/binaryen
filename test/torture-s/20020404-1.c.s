	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020404-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i64.const	$push0=, 3735928559
	i64.store	bfd_make_section_anyway.foo_section+8($pop1), $pop0
	i32.const	$push11=, 0
	i64.const	$push10=, 3735928559
	i64.store	bfd_make_section_anyway.foo_section+16($pop11), $pop10
	i32.const	$push9=, 0
	i64.const	$push2=, 0
	i64.store	bfd_make_section_anyway.foo_section+24($pop9), $pop2
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.load8_u	$push3=, bfd_make_section_anyway.foo_section($pop7)
	i32.const	$push4=, 1
	i32.or  	$push5=, $pop3, $pop4
	i32.store8	bfd_make_section_anyway.foo_section($pop8), $pop5
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	bfd_make_section_anyway.foo_section,@object # @bfd_make_section_anyway.foo_section
	.section	.bss.bfd_make_section_anyway.foo_section,"aw",@nobits
	.p2align	3
bfd_make_section_anyway.foo_section:
	.skip	32
	.size	bfd_make_section_anyway.foo_section, 32


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
