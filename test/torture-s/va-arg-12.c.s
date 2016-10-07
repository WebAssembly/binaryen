	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-12.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	f64, f64, f64, f64, f64, f64, f64, f64, f64, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, 0
	i32.const	$push16=, 0
	i32.load	$push17=, __stack_pointer($pop16)
	i32.const	$push18=, 16
	i32.sub 	$push28=, $pop17, $pop18
	tee_local	$push27=, $12=, $pop28
	i32.store	__stack_pointer($pop19), $pop27
	i32.store	12($12), $9
	i32.const	$push0=, 7
	i32.add 	$push1=, $9, $pop0
	i32.const	$push2=, -8
	i32.and 	$push26=, $pop1, $pop2
	tee_local	$push25=, $9=, $pop26
	i32.const	$push3=, 8
	i32.add 	$push24=, $pop25, $pop3
	tee_local	$push23=, $10=, $pop24
	i32.store	12($12), $pop23
	block   	
	f64.load	$push4=, 0($9)
	f64.const	$push5=, 0x1.4p3
	f64.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push7=, 16
	i32.add 	$push30=, $9, $pop7
	tee_local	$push29=, $11=, $pop30
	i32.store	12($12), $pop29
	f64.load	$push8=, 0($10)
	f64.const	$push9=, 0x1.6p3
	f64.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push11=, 24
	i32.add 	$push12=, $9, $pop11
	i32.store	12($12), $pop12
	f64.load	$push13=, 0($11)
	f64.const	$push14=, 0x0p0
	f64.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push22=, 0
	i32.const	$push20=, 16
	i32.add 	$push21=, $12, $pop20
	i32.store	__stack_pointer($pop22), $pop21
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
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 32
	i32.sub 	$push11=, $pop7, $pop8
	tee_local	$push10=, $1=, $pop11
	i32.store	__stack_pointer($pop9), $pop10
	i32.const	$push0=, 16
	i32.add 	$push1=, $1, $pop0
	i64.const	$push2=, 0
	i64.store	0($pop1), $pop2
	i64.const	$push3=, 4622382067542392832
	i64.store	8($1), $pop3
	i64.const	$push4=, 4621819117588971520
	i64.store	0($1), $pop4
	call    	f@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $1
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
