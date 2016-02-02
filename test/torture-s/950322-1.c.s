	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/950322-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load8_u	$push1=, 0($0)
	i32.load8_u	$push0=, 1($0)
	i32.sub 	$0=, $pop1, $pop0
	i32.const	$push2=, 31
	i32.shr_s	$push3=, $0, $pop2
	tee_local	$push9=, $1=, $pop3
	i32.add 	$push4=, $0, $pop9
	i32.xor 	$push5=, $pop4, $1
	i32.const	$push8=, 31
	i32.shr_u	$push6=, $0, $pop8
	i32.add 	$push7=, $pop5, $pop6
	return  	$pop7
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
