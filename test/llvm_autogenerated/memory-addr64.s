	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/memory-addr64.ll"
	.globl	memory_size
	.type	memory_size,@function
memory_size:
	.result 	i64
	memory_size	$push0=
	return  	$pop0
func_end0:
	.size	memory_size, func_end0-memory_size

	.globl	grow_memory
	.type	grow_memory,@function
grow_memory:
	.param  	i64
	grow_memory	$0
	return
func_end1:
	.size	grow_memory, func_end1-grow_memory


	.section	".note.GNU-stack","",@progbits
