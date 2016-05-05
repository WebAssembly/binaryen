	.text
	.file	"test/linker/bar.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
# BB#0:                                 # %entry
	call    	quux@FUNCTION
	return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar


	.ident	"clang version 3.9.0 (trunk 268553) (llvm/trunk 268561)"
