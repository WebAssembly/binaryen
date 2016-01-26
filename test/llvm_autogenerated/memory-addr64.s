	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/memory-addr64.ll"
	.globl	memory_size
	.type	memory_size,@function
memory_size:
	.result 	i64
	memory_size	$push0=
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	memory_size, .Lfunc_end0-memory_size

	.globl	grow_memory
	.type	grow_memory,@function
grow_memory:
	.param  	i64
	grow_memory	$0
	return
	.endfunc
.Lfunc_end1:
	.size	grow_memory, .Lfunc_end1-grow_memory


