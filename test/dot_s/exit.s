.text
	.file	"/s/newgit/native_client/toolchain_build/src/pnacl-gcc/gcc/testsuite/gcc.c-torture/execute/enum-1.c"
	.globl	main
	.type	main,@function
main:
	.result i32
	.local i32
	i32.const $push0=, 0
	call exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
