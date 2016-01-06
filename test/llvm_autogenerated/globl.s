	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/globl.ll"
	.globl	foo
	.type	foo,@function
foo:
	return
func_end0:
	.size	foo, func_end0-foo


	.section	".note.GNU-stack","",@progbits
