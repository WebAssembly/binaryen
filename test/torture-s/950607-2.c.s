	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/950607-2.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32
	.result 	i32
	.local  	i64, i32
# BB#0:                                 # %entry
	i32.const	$push23=, 0
	i32.const	$push21=, 1
	i32.const	$push20=, 2
	i32.load	$push4=, 4($2)
	i32.load	$push5=, 4($0)
	tee_local	$push28=, $4=, $pop5
	i32.sub 	$push6=, $pop4, $pop28
	i64.extend_s/i32	$push7=, $pop6
	i32.load	$push0=, 0($1)
	i32.load	$push1=, 0($0)
	tee_local	$push27=, $0=, $pop1
	i32.sub 	$push2=, $pop0, $pop27
	i64.extend_s/i32	$push3=, $pop2
	i64.mul 	$push8=, $pop7, $pop3
	i32.load	$push12=, 0($2)
	i32.sub 	$push13=, $pop12, $0
	i64.extend_s/i32	$push14=, $pop13
	i32.load	$push9=, 4($1)
	i32.sub 	$push10=, $pop9, $4
	i64.extend_s/i32	$push11=, $pop10
	i64.mul 	$push15=, $pop14, $pop11
	i64.sub 	$push16=, $pop8, $pop15
	tee_local	$push26=, $3=, $pop16
	i64.const	$push17=, 0
	i64.lt_s	$push19=, $pop26, $pop17
	i32.select	$push22=, $pop21, $pop20, $pop19
	i64.const	$push25=, 0
	i64.gt_s	$push18=, $3, $pop25
	i32.select	$push24=, $pop23, $pop22, $pop18
	return  	$pop24
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
