	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000818-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.yylex,"ax",@progbits
	.hidden	yylex
	.globl	yylex
	.type	yylex,@function
yylex:                                  # @yylex
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	yylex, .Lfunc_end1-yylex

	.hidden	temporary_obstack       # @temporary_obstack
	.type	temporary_obstack,@object
	.section	.bss.temporary_obstack,"aw",@nobits
	.globl	temporary_obstack
	.p2align	2
temporary_obstack:
	.int32	0
	.size	temporary_obstack, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
