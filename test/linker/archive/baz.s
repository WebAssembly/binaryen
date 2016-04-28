	.text
	.file	"src/work/binaryen/test/linker/baz.c"
	.section	.text.baz,"ax",@progbits
	.hidden	baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end0:
	.size	baz, .Lfunc_end0-baz


	.ident	"clang version 3.9.0 (trunk 267883) (llvm/trunk 267901)"
