	.text
	.file	"20000818-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.yylex,"ax",@progbits
	.hidden	yylex                   # -- Begin function yylex
	.globl	yylex
	.type	yylex,@function
yylex:                                  # @yylex
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	yylex, .Lfunc_end1-yylex
                                        # -- End function
	.hidden	temporary_obstack       # @temporary_obstack
	.type	temporary_obstack,@object
	.section	.bss.temporary_obstack,"aw",@nobits
	.globl	temporary_obstack
	.p2align	2
temporary_obstack:
	.int32	0
	.size	temporary_obstack, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
