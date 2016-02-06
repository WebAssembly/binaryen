	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/921204-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1)
	tee_local	$push8=, $1=, $pop0
	i32.const	$push3=, 1310720
	i32.or  	$push4=, $pop8, $pop3
	i32.const	$push5=, -1310721
	i32.and 	$push6=, $1, $pop5
	i32.const	$push1=, 1
	i32.and 	$push2=, $1, $pop1
	i32.select	$push7=, $pop4, $pop6, $pop2
	i32.store	$discard=, 0($0), $pop7
	return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
