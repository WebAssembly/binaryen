	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-18.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	f64, f64, f64, f64, f64, f64, f64, f64, f64, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.const	$push12=, 0
	i32.load	$push13=, __stack_pointer($pop12)
	i32.const	$push14=, 16
	i32.sub 	$push22=, $pop13, $pop14
	tee_local	$push21=, $12=, $pop22
	i32.store	__stack_pointer($pop15), $pop21
	i32.store	12($12), $9
	i32.const	$push0=, 4
	i32.add 	$push20=, $9, $pop0
	tee_local	$push19=, $10=, $pop20
	i32.store	12($12), $pop19
	block   	
	i32.load	$push1=, 0($9)
	i32.const	$push2=, 10
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 8
	i32.add 	$push24=, $9, $pop4
	tee_local	$push23=, $11=, $pop24
	i32.store	12($12), $pop23
	i32.load	$push5=, 0($10)
	i32.const	$push6=, 11
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push8=, 12
	i32.add 	$push9=, $9, $pop8
	i32.store	12($12), $pop9
	i32.load	$push10=, 0($11)
	i32.const	$push25=, 12
	i32.ne  	$push11=, $pop10, $pop25
	br_if   	0, $pop11       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push18=, 0
	i32.const	$push16=, 16
	i32.add 	$push17=, $12, $pop16
	i32.store	__stack_pointer($pop18), $pop17
	return
.LBB0_4:                                # %if.then10
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

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
	i32.const	$push0=, 12
	i32.store	8($1), $pop0
	i64.const	$push1=, 47244640266
	i64.store	0($1), $pop1
	call    	f@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $1
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
