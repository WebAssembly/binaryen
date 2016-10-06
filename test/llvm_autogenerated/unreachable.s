	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/unreachable.ll"
	.globl	f1
	.type	f1,@function
f1:
	.result 	i32
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.globl	f2
	.type	f2,@function
f2:
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2

	.globl	f3
	.type	f3,@function
f3:
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3


	.functype	abort, void
