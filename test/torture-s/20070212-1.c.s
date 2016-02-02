	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20070212-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
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
	i32.sub 	$8=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$8=, 0($5), $8
	i32.store	$discard=, 12($8), $0
	i32.const	$push1=, 0
	i32.store	$discard=, 0($3), $pop1
	i32.const	$7=, 12
	i32.add 	$7=, $8, $7
	i32.select	$push0=, $1, $7, $2
	i32.load	$push2=, 0($pop0)
	i32.const	$6=, 16
	i32.add 	$8=, $8, $6
	i32.const	$6=, __stack_pointer
	i32.store	$8=, 0($6), $8
	return  	$pop2
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
