	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-8.c"
	.section	.text.debug,"ax",@progbits
	.hidden	debug
	.globl	debug
	.type	debug,@function
debug:                                  # @debug
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, 0
	i32.const	$push13=, 0
	i32.load	$push14=, __stack_pointer($pop13)
	i32.const	$push15=, 16
	i32.sub 	$push20=, $pop14, $pop15
	i32.store	$push24=, __stack_pointer($pop16), $pop20
	tee_local	$push23=, $11=, $pop24
	i32.store	$push22=, 12($11), $9
	tee_local	$push21=, $9=, $pop22
	i32.const	$push1=, 4
	i32.add 	$push0=, $pop21, $pop1
	i32.store	$10=, 12($pop23), $pop0
	block
	i32.load	$push2=, 0($9)
	i32.const	$push3=, 10
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, 7
	i32.add 	$push6=, $10, $pop5
	i32.const	$push7=, -8
	i32.and 	$push26=, $pop6, $pop7
	tee_local	$push25=, $9=, $pop26
	i32.const	$push8=, 8
	i32.add 	$push9=, $pop25, $pop8
	i32.store	$drop=, 12($11), $pop9
	i64.load	$push10=, 0($9)
	i64.const	$push11=, 20014547621496
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push19=, 0
	i32.const	$push17=, 16
	i32.add 	$push18=, $11, $pop17
	i32.store	$drop=, __stack_pointer($pop19), $pop18
	return
.LBB0_3:                                # %if.then5
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	debug, .Lfunc_end0-debug

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push7=, $pop4, $pop5
	i32.store	$push9=, __stack_pointer($pop6), $pop7
	tee_local	$push8=, $0=, $pop9
	i64.const	$push0=, 20014547621496
	i64.store	$drop=, 8($pop8), $pop0
	i32.const	$push1=, 10
	i32.store	$drop=, 0($0), $pop1
	call    	debug@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
