	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/globl.ll"
	.globl	foo
	.type	foo,@function
foo:
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.section	".note.GNU-stack","",@progbits
