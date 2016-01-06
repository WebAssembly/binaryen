	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/unreachable.ll"
	.globl	f1
	.type	f1,@function
f1:
	.result 	i32
	call    	abort
	unreachable
func_end0:
	.size	f1, func_end0-f1

	.globl	f2
	.type	f2,@function
f2:
	unreachable
	return
func_end1:
	.size	f2, func_end1-f2

	.globl	f3
	.type	f3,@function
f3:
	unreachable
	return
func_end2:
	.size	f3, func_end2-f3


	.section	".note.GNU-stack","",@progbits
