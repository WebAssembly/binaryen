	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/shiftdi.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i64, i32, i32, i32
	.local  	i64
# BB#0:                                 # %entry
	i64.const	$4=, 4294967295
	i64.load	$push10=, 0($3)
	i64.extend_u/i32	$push0=, $1
	i64.shr_u	$push1=, $0, $pop0
	i64.and 	$push2=, $pop1, $4
	i32.const	$push3=, 31
	i32.and 	$push4=, $2, $pop3
	i64.extend_u/i32	$push5=, $pop4
	i64.shl 	$push6=, $pop2, $pop5
	i64.and 	$push7=, $pop6, $4
	i64.extend_u/i32	$push8=, $2
	i64.shl 	$push9=, $pop7, $pop8
	i64.or  	$push11=, $pop10, $pop9
	i64.store	$discard=, 0($3), $pop11
	return
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
