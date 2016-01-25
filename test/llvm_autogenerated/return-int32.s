	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/return-int32.ll"
	.globl	return_i32
	.type	return_i32,@function
return_i32:
	.param  	i32
	.result 	i32
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	return_i32, .Lfunc_end0-return_i32


