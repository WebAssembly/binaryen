	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030626-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, buf
	i32.const	$push0=, .L.str.2
	i32.const	$push2=, 13
	call    	memcpy@FUNCTION, $pop1, $pop0, $pop2
	i32.const	$push3=, 0
	return  	$pop3
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
	.align	4
buf:
	.skip	40
	.size	buf, 40

	.type	.L.str.2,@object        # @.str.2
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.2:
	.asciz	"other string"
	.size	.L.str.2, 13


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
