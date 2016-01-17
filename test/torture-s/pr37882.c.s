	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr37882.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load8_u	$push0=, s($0)
	i32.const	$push1=, 248
	i32.and 	$push2=, $pop0, $pop1
	i32.const	$push3=, 4
	i32.or  	$push4=, $pop2, $pop3
	i32.store8	$discard=, s($0), $pop4
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
s:
	.skip	1
	.size	s, 1


	.ident	"clang version 3.9.0 "
