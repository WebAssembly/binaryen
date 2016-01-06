	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/strct-pack-4.c"
	.globl	my_set_a
	.type	my_set_a,@function
my_set_a:                               # @my_set_a
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 171
	return  	$pop0
func_end0:
	.size	my_set_a, func_end0-my_set_a

	.globl	my_set_b
	.type	my_set_b,@function
my_set_b:                               # @my_set_b
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4660
	return  	$pop0
func_end1:
	.size	my_set_b, func_end1-my_set_b

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
