	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20070212-1.c"
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$4=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$4=, 0($5), $4
	i32.store	$discard=, 12($4), $0
	i32.const	$push1=, 0
	i32.store	$discard=, 0($3), $pop1
	i32.const	$7=, 12
	i32.add 	$7=, $4, $7
	i32.select	$push0=, $1, $7, $2
	i32.load	$push2=, 0($pop0)
	i32.const	$6=, 16
	i32.add 	$4=, $4, $6
	i32.const	$6=, __stack_pointer
	i32.store	$4=, 0($6), $4
	return  	$pop2
func_end0:
	.size	g, func_end0-g

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
