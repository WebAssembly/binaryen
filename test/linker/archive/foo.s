	.text
	.file	"src/work/binaryen/test/linker/foo.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 43
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.9.0 (trunk 267883) (llvm/trunk 267901)"
