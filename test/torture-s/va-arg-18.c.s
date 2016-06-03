	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-18.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	f64, f64, f64, f64, f64, f64, f64, f64, f64, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push17=, 0
	i32.const	$push14=, 0
	i32.load	$push15=, __stack_pointer($pop14)
	i32.const	$push16=, 16
	i32.sub 	$push21=, $pop15, $pop16
	i32.store	$push25=, __stack_pointer($pop17), $pop21
	tee_local	$push24=, $12=, $pop25
	i32.store	$push23=, 12($12), $9
	tee_local	$push22=, $9=, $pop23
	i32.const	$push0=, 4
	i32.add 	$push1=, $pop22, $pop0
	i32.store	$10=, 12($pop24), $pop1
	block
	i32.load	$push2=, 0($9)
	i32.const	$push3=, 10
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, 8
	i32.add 	$push6=, $9, $pop5
	i32.store	$11=, 12($12), $pop6
	i32.load	$push7=, 0($10)
	i32.const	$push8=, 11
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push10=, 12
	i32.add 	$push11=, $9, $pop10
	i32.store	$drop=, 12($12), $pop11
	i32.load	$push12=, 0($11)
	i32.const	$push26=, 12
	i32.ne  	$push13=, $pop12, $pop26
	br_if   	0, $pop13       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push20=, 0
	i32.const	$push18=, 16
	i32.add 	$push19=, $12, $pop18
	i32.store	$drop=, __stack_pointer($pop20), $pop19
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
	i32.sub 	$push7=, $pop4, $pop5
	i32.store	$push9=, __stack_pointer($pop6), $pop7
	tee_local	$push8=, $1=, $pop9
	i32.const	$push0=, 12
	i32.store	$drop=, 8($pop8), $pop0
	i64.const	$push1=, 47244640266
	i64.store	$drop=, 0($1), $pop1
	call    	f@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $1
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
