	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/cpus.ll"
	.globl	f
	.type	f,@function
f:
	.param  	i32
	.result 	i32
	return  	$0
func_end0:
	.size	f, func_end0-f


	.section	".note.GNU-stack","",@progbits
