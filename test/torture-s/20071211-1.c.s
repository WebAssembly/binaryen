	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071211-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64
# BB#0:                                 # %entry
	i32.const	$push22=, 0
	i32.const	$push21=, 0
	i64.load	$push0=, sv($pop21)
	i64.const	$push1=, -1099511627776
	i64.or  	$push2=, $pop0, $pop1
	i64.store	$discard=, sv($pop22), $pop2
	#APP
	#NO_APP
	i32.const	$push20=, 0
	i32.const	$push19=, 0
	i64.load	$push18=, sv($pop19)
	tee_local	$push17=, $1=, $pop18
	i64.const	$push3=, 40
	i64.shr_u	$push4=, $pop17, $pop3
	i64.const	$push5=, 1
	i64.add 	$push16=, $pop4, $pop5
	tee_local	$push15=, $0=, $pop16
	i64.const	$push14=, 40
	i64.shl 	$push6=, $pop15, $pop14
	i64.const	$push7=, 1099511627775
	i64.and 	$push8=, $1, $pop7
	i64.or  	$push9=, $pop6, $pop8
	i64.store	$discard=, sv($pop20), $pop9
	block
	i64.const	$push10=, 16777215
	i64.and 	$push11=, $0, $pop10
	i64.const	$push12=, 0
	i64.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push23=, 0
	return  	$pop23
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	sv                      # @sv
	.type	sv,@object
	.section	.bss.sv,"aw",@nobits
	.globl	sv
	.p2align	3
sv:
	.skip	8
	.size	sv, 8


	.ident	"clang version 3.9.0 "
