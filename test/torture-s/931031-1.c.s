	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931031-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load	$push0=, 4($0)
	tee_local	$push7=, $0=, $pop0
	i32.const	$push1=, 0
	i32.lt_s	$push2=, $pop7, $pop1
	i32.const	$push3=, 1
	i32.const	$push6=, 1
	i32.add 	$push4=, $0, $pop6
	i32.select	$push5=, $pop2, $pop3, $pop4
	return  	$pop5
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
