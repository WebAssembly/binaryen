	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strct-pack-1.c"
	.section	.text.check,"ax",@progbits
	.hidden	check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32
	.result 	i32
	.local  	i64, i32
# BB#0:                                 # %entry
	i32.const	$2=, 1
	block   	.LBB0_3
	i32.load16_u	$push0=, 0($0)
	i32.ne  	$push1=, $pop0, $2
	br_if   	$pop1, .LBB0_3
# BB#1:                                 # %lor.lhs.false
	i64.const	$1=, 16
	i32.const	$push2=, 8
	i32.add 	$push3=, $0, $pop2
	i64.load16_u	$push4=, 0($pop3)
	i64.shl 	$push5=, $pop4, $1
	i32.const	$push6=, 6
	i32.add 	$push7=, $0, $pop6
	i64.load16_u	$push8=, 0($pop7)
	i64.or  	$push9=, $pop5, $pop8
	i64.const	$push10=, 32
	i64.shl 	$push11=, $pop9, $pop10
	i32.const	$push12=, 4
	i32.add 	$push13=, $0, $pop12
	i64.load16_u	$push14=, 0($pop13)
	i64.shl 	$push15=, $pop14, $1
	i64.load16_u	$push16=, 2($0)
	i64.or  	$push17=, $pop15, $pop16
	i64.or  	$push18=, $pop11, $pop17
	f64.reinterpret/i64	$push19=, $pop18
	f64.const	$push20=, 0x1p4
	f64.ne  	$push21=, $pop19, $pop20
	br_if   	$pop21, .LBB0_3
# BB#2:                                 # %if.end
	i32.const	$2=, 0
.LBB0_3:                                # %return
	return  	$2
.Lfunc_end0:
	.size	check, .Lfunc_end0-check

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
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
