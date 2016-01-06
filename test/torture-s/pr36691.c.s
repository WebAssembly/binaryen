	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr36691.c"
	.globl	func_1
	.type	func_1,@function
func_1:                                 # @func_1
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.store8	$discard=, g_5($0), $0
	return
func_end0:
	.size	func_1, func_end0-func_1

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.store8	$push0=, g_5($0), $0
	return  	$pop0
func_end1:
	.size	main, func_end1-main

	.type	g_5,@object             # @g_5
	.bss
	.globl	g_5
g_5:
	.int8	0                       # 0x0
	.size	g_5, 1


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
