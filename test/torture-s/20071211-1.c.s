	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071211-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i64.load	$1=, sv($0)
	i64.const	$2=, -1099511627776
	i64.or  	$1=, $1, $2
	i64.store	$discard=, sv($0), $1
	#APP
	#NO_APP
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i64.load	$push0=, sv($pop16)
	tee_local	$push15=, $1=, $pop0
	i64.const	$push1=, 40
	i64.shr_u	$push2=, $pop15, $pop1
	i64.const	$push3=, 1
	i64.add 	$push4=, $pop2, $pop3
	tee_local	$push14=, $2=, $pop4
	i64.const	$push13=, 40
	i64.shl 	$push5=, $pop14, $pop13
	i64.const	$push6=, 1099511627775
	i64.and 	$push7=, $1, $pop6
	i64.or  	$push8=, $pop5, $pop7
	i64.store	$discard=, sv($pop17), $pop8
	block
	i64.const	$push9=, 16777215
	i64.and 	$push10=, $2, $pop9
	i64.const	$push11=, 0
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	$pop12, 0       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push18=, 0
	return  	$pop18
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
