	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-7.c"
	.section	.text.debug,"ax",@progbits
	.hidden	debug
	.globl	debug
	.type	debug,@function
debug:                                  # @debug
	.param  	i32, i32, i32, i32, i32, i32, i32, f64, f64, f64, f64, f64, f64, f64, f64, f64, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push18=, 0
	i32.const	$push15=, 0
	i32.load	$push16=, __stack_pointer($pop15)
	i32.const	$push17=, 16
	i32.sub 	$push22=, $pop16, $pop17
	i32.store	$push27=, __stack_pointer($pop18), $pop22
	tee_local	$push26=, $18=, $pop27
	i32.store	$push25=, 12($18), $16
	tee_local	$push24=, $16=, $pop25
	i32.const	$push0=, 4
	i32.add 	$push1=, $pop24, $pop0
	i32.store	$17=, 12($pop26), $pop1
	block
	i32.load	$push2=, 0($16)
	i32.const	$push23=, 8
	i32.ne  	$push3=, $pop2, $pop23
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push28=, 8
	i32.add 	$push4=, $16, $pop28
	i32.store	$drop=, 12($18), $pop4
	i32.load	$push5=, 0($17)
	i32.const	$push6=, 9
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push8=, 12
	i32.add 	$push9=, $16, $pop8
	i32.store	$drop=, 12($18), $pop9
	i32.const	$push10=, 8
	i32.add 	$push11=, $16, $pop10
	i32.load	$push12=, 0($pop11)
	i32.const	$push13=, 10
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push21=, 0
	i32.const	$push19=, 16
	i32.add 	$push20=, $18, $pop19
	i32.store	$drop=, __stack_pointer($pop21), $pop20
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
	i32.sub 	$push7=, $pop4, $pop5
	i32.store	$push9=, __stack_pointer($pop6), $pop7
	tee_local	$push8=, $1=, $pop9
	i32.const	$push0=, 10
	i32.store	$drop=, 8($pop8), $pop0
	i64.const	$push1=, 38654705672
	i64.store	$drop=, 0($1), $pop1
	call    	debug@FUNCTION, $1, $1, $1, $1, $1, $1, $1, $0, $0, $0, $0, $0, $0, $0, $0, $0, $1
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
