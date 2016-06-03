	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980709-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, f64, f64
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.const	$push12=, 0
	i32.load	$push13=, __stack_pointer($pop12)
	i32.const	$push14=, 16
	i32.sub 	$push16=, $pop13, $pop14
	i32.store	$push23=, __stack_pointer($pop15), $pop16
	tee_local	$push22=, $0=, $pop23
	i64.const	$push0=, 4629700416936869888
	i64.store	$drop=, 8($pop22), $pop0
	block
	f64.load	$push2=, 8($0)
	f64.const	$push1=, 0x1.5555555555555p-2
	f64.call	$push21=, pow@FUNCTION, $pop2, $pop1
	tee_local	$push20=, $1=, $pop21
	f64.const	$push3=, 0x1.999999999999ap-4
	f64.add 	$push19=, $pop20, $pop3
	tee_local	$push18=, $2=, $pop19
	f64.const	$push17=, 0x1.965fe974a3401p1
	f64.le  	$push4=, $pop18, $pop17
	f64.ne  	$push5=, $2, $2
	i32.or  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %entry
	f64.const	$push7=, -0x1.999999999999ap-4
	f64.add 	$push26=, $1, $pop7
	tee_local	$push25=, $2=, $pop26
	f64.const	$push24=, 0x1.965fe974a3401p1
	f64.ge  	$push8=, $pop25, $pop24
	f64.ne  	$push9=, $2, $2
	i32.or  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#2:                                 # %if.then
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
.LBB0_3:                                # %if.else
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
	.functype	abort, void
