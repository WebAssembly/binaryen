	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/memory-addr32.ll"
	.globl	current_memory
	.type	current_memory,@function
current_memory:
	.result 	i32
	current_memory	$push0=
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	current_memory, .Lfunc_end0-current_memory

	.globl	grow_memory
	.type	grow_memory,@function
grow_memory:
	.param  	i32
	grow_memory	$0
	return
	.endfunc
.Lfunc_end1:
	.size	grow_memory, .Lfunc_end1-grow_memory


