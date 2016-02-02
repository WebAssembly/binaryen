	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strct-pack-3.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.add 	$push1=, $0, $pop0
	i32.load	$push2=, 0($pop1):p2align=1
	tee_local	$push14=, $1=, $pop2
	i32.const	$push6=, 16
	i32.shl 	$push9=, $pop14, $pop6
	i32.load	$push5=, 2($0):p2align=1
	i32.const	$push13=, 16
	i32.shl 	$push7=, $pop5, $pop13
	i32.const	$push3=, 17
	i32.shl 	$push4=, $1, $pop3
	i32.add 	$push8=, $pop7, $pop4
	i32.add 	$push10=, $pop9, $pop8
	i32.const	$push12=, 16
	i32.shr_s	$push11=, $pop10, $pop12
	return  	$pop11
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
