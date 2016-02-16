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
	i32.const	$push20=, 0
	i32.const	$push18=, 1
	i32.const	$push17=, 2
	i32.load	$push3=, 4($2)
	i32.load	$push28=, 4($0)
	tee_local	$push27=, $4=, $pop28
	i32.sub 	$push4=, $pop3, $pop27
	i64.extend_s/i32	$push5=, $pop4
	i32.load	$push0=, 0($1)
	i32.load	$push26=, 0($0)
	tee_local	$push25=, $0=, $pop26
	i32.sub 	$push1=, $pop0, $pop25
	i64.extend_s/i32	$push2=, $pop1
	i64.mul 	$push6=, $pop5, $pop2
	i32.load	$push10=, 0($2)
	i32.sub 	$push11=, $pop10, $0
	i64.extend_s/i32	$push12=, $pop11
	i32.load	$push7=, 4($1)
	i32.sub 	$push8=, $pop7, $4
	i64.extend_s/i32	$push9=, $pop8
	i64.mul 	$push13=, $pop12, $pop9
	i64.sub 	$push24=, $pop6, $pop13
	tee_local	$push23=, $3=, $pop24
	i64.const	$push14=, 0
	i64.lt_s	$push16=, $pop23, $pop14
	i32.select	$push19=, $pop18, $pop17, $pop16
	i64.const	$push22=, 0
	i64.gt_s	$push15=, $3, $pop22
	i32.select	$push21=, $pop20, $pop19, $pop15
	return  	$pop21
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
