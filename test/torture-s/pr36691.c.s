	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr36691.c"
	.section	.text.func_1,"ax",@progbits
	.hidden	func_1
	.globl	func_1
	.type	func_1,@function
func_1:                                 # @func_1
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push1=, 0
	i32.store8	$drop=, g_5($pop0), $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	func_1, .Lfunc_end0-func_1

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push2=, 0
	i32.store8	$push0=, g_5($pop1), $pop2
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	g_5                     # @g_5
	.type	g_5,@object
	.section	.bss.g_5,"aw",@nobits
	.globl	g_5
g_5:
	.int8	0                       # 0x0
	.size	g_5, 1


	.ident	"clang version 3.9.0 "
