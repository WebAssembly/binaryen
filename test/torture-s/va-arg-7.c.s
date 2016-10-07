	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-7.c"
	.section	.text.debug,"ax",@progbits
	.hidden	debug
	.globl	debug
	.type	debug,@function
debug:                                  # @debug
	.param  	i32, i32, i32, i32, i32, i32, i32, f64, f64, f64, f64, f64, f64, f64, f64, f64, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push17=, 0
	i32.const	$push14=, 0
	i32.load	$push15=, __stack_pointer($pop14)
	i32.const	$push16=, 16
	i32.sub 	$push25=, $pop15, $pop16
	tee_local	$push24=, $18=, $pop25
	i32.store	__stack_pointer($pop17), $pop24
	i32.store	12($18), $16
	i32.const	$push0=, 4
	i32.add 	$push23=, $16, $pop0
	tee_local	$push22=, $17=, $pop23
	i32.store	12($18), $pop22
	block   	
	i32.load	$push1=, 0($16)
	i32.const	$push21=, 8
	i32.ne  	$push2=, $pop1, $pop21
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push26=, 8
	i32.add 	$push3=, $16, $pop26
	i32.store	12($18), $pop3
	i32.load	$push4=, 0($17)
	i32.const	$push5=, 9
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push7=, 12
	i32.add 	$push8=, $16, $pop7
	i32.store	12($18), $pop8
	i32.const	$push9=, 8
	i32.add 	$push10=, $16, $pop9
	i32.load	$push11=, 0($pop10)
	i32.const	$push12=, 10
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push20=, 0
	i32.const	$push18=, 16
	i32.add 	$push19=, $18, $pop18
	i32.store	__stack_pointer($pop20), $pop19
	return
.LBB0_4:                                # %if.then10
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
	.local  	f64, i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push8=, $pop4, $pop5
	tee_local	$push7=, $1=, $pop8
	i32.store	__stack_pointer($pop6), $pop7
	i32.const	$push0=, 10
	i32.store	8($1), $pop0
	i64.const	$push1=, 38654705672
	i64.store	0($1), $pop1
	call    	debug@FUNCTION, $1, $1, $1, $1, $1, $1, $1, $0, $0, $0, $0, $0, $0, $0, $0, $0, $1
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
