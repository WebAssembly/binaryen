	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-12.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	f64, f64, f64, f64, f64, f64, f64, f64, f64, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push22=, 0
	i32.const	$push19=, 0
	i32.load	$push20=, __stack_pointer($pop19)
	i32.const	$push21=, 16
	i32.sub 	$push26=, $pop20, $pop21
	i32.store	$push30=, __stack_pointer($pop22), $pop26
	tee_local	$push29=, $12=, $pop30
	i32.store	$push0=, 12($12), $9
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push28=, $pop2, $pop3
	tee_local	$push27=, $9=, $pop28
	i32.const	$push4=, 8
	i32.add 	$push5=, $pop27, $pop4
	i32.store	$10=, 12($pop29), $pop5
	block
	f64.load	$push6=, 0($9)
	f64.const	$push7=, 0x1.4p3
	f64.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push9=, 16
	i32.add 	$push10=, $9, $pop9
	i32.store	$11=, 12($12), $pop10
	f64.load	$push11=, 0($10)
	f64.const	$push12=, 0x1.6p3
	f64.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push14=, 24
	i32.add 	$push15=, $9, $pop14
	i32.store	$drop=, 12($12), $pop15
	f64.load	$push16=, 0($11)
	f64.const	$push17=, 0x0p0
	f64.ne  	$push18=, $pop16, $pop17
	br_if   	0, $pop18       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push25=, 0
	i32.const	$push23=, 16
	i32.add 	$push24=, $12, $pop23
	i32.store	$drop=, __stack_pointer($pop25), $pop24
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
	i32.sub 	$push10=, $pop7, $pop8
	i32.store	$push12=, __stack_pointer($pop9), $pop10
	tee_local	$push11=, $1=, $pop12
	i32.const	$push0=, 16
	i32.add 	$push1=, $pop11, $pop0
	i64.const	$push2=, 0
	i64.store	$drop=, 0($pop1), $pop2
	i64.const	$push3=, 4622382067542392832
	i64.store	$drop=, 8($1), $pop3
	i64.const	$push4=, 4621819117588971520
	i64.store	$drop=, 0($1), $pop4
	call    	f@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $1
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
