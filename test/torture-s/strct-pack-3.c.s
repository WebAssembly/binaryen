	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strct-pack-3.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 16
	i32.const	$push2=, 8
	i32.add 	$push3=, $0, $pop2
	i32.load16_u	$push4=, 0($pop3)
	i32.shl 	$push5=, $pop4, $1
	i32.const	$push0=, 6
	i32.add 	$push1=, $0, $pop0
	i32.load16_u	$push6=, 0($pop1)
	i32.or  	$2=, $pop5, $pop6
	i32.shl 	$push12=, $2, $1
	i32.load16_u	$push9=, 2($0)
	i32.shl 	$push10=, $pop9, $1
	i32.const	$push7=, 17
	i32.shl 	$push8=, $2, $pop7
	i32.add 	$push11=, $pop10, $pop8
	i32.add 	$push13=, $pop12, $pop11
	i32.shr_s	$push14=, $pop13, $1
	return  	$pop14
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
	.section	".note.GNU-stack","",@progbits
