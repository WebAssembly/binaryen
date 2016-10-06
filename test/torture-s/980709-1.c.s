	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980709-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64, f64, i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.const	$push12=, 0
	i32.load	$push13=, __stack_pointer($pop12)
	i32.const	$push14=, 16
	i32.sub 	$push22=, $pop13, $pop14
	tee_local	$push21=, $2=, $pop22
	i32.store	__stack_pointer($pop15), $pop21
	i64.const	$push0=, 4629700416936869888
	i64.store	8($2), $pop0
	block   	
	f64.load	$push2=, 8($2)
	f64.const	$push1=, 0x1.5555555555555p-2
	f64.call	$push20=, pow@FUNCTION, $pop2, $pop1
	tee_local	$push19=, $0=, $pop20
	f64.const	$push3=, 0x1.999999999999ap-4
	f64.add 	$push18=, $pop19, $pop3
	tee_local	$push17=, $1=, $pop18
	f64.const	$push16=, 0x1.965fe974a3401p1
	f64.le  	$push4=, $pop17, $pop16
	f64.ne  	$push5=, $1, $1
	i32.or  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %entry
	f64.const	$push7=, -0x1.999999999999ap-4
	f64.add 	$push25=, $0, $pop7
	tee_local	$push24=, $1=, $pop25
	f64.const	$push23=, 0x1.965fe974a3401p1
	f64.ge  	$push8=, $pop24, $pop23
	f64.ne  	$push9=, $1, $1
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
	.functype	abort, void
