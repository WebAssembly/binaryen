	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20070212-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push3=, __stack_pointer
	i32.load	$4=, 0($pop3)
	i32.const	$push1=, 0
	i32.store	$discard=, 0($3), $pop1
	i32.const	$push4=, 16
	i32.sub 	$push8=, $4, $pop4
	tee_local	$push7=, $3=, $pop8
	i32.store	$discard=, 12($pop7), $0
	i32.const	$push5=, 12
	i32.add 	$push6=, $3, $pop5
	i32.select	$push0=, $pop6, $2, $1
	i32.load	$push2=, 0($pop0)
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
