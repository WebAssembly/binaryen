	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/unused-argument.ll"
	.globl	unused_first
	.type	unused_first,@function
unused_first:
	.param  	i32, i32
	.result 	i32
	return  	$1
func_end0:
	.size	unused_first, func_end0-unused_first

	.globl	unused_second
	.type	unused_second,@function
unused_second:
	.param  	i32, i32
	.result 	i32
	return  	$0
func_end1:
	.size	unused_second, func_end1-unused_second

	.globl	call_something
	.type	call_something,@function
call_something:
	i32.call	$discard=, return_something
	return
func_end2:
	.size	call_something, func_end2-call_something


	.section	".note.GNU-stack","",@progbits
