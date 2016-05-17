	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-12.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	f64, f64, f64, f64, f64, f64, f64, f64, f64, i32
	.local  	i32, f64, i32
# BB#0:                                 # %entry
	i32.const	$push18=, __stack_pointer
	i32.const	$push15=, __stack_pointer
	i32.load	$push16=, 0($pop15)
	i32.const	$push17=, 16
	i32.sub 	$push22=, $pop16, $pop17
	i32.store	$10=, 0($pop18), $pop22
	i32.const	$push0=, 7
	i32.add 	$push1=, $9, $pop0
	i32.const	$push2=, -8
	i32.and 	$push24=, $pop1, $pop2
	tee_local	$push23=, $12=, $pop24
	f64.load	$11=, 0($pop23)
	i32.store	$drop=, 12($10), $9
	i32.const	$push3=, 8
	i32.add 	$push4=, $12, $pop3
	i32.store	$9=, 12($10), $pop4
	block
	f64.const	$push5=, 0x1.4p3
	f64.ne  	$push6=, $11, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	f64.load	$11=, 0($9)
	i32.const	$push7=, 16
	i32.add 	$push8=, $12, $pop7
	i32.store	$9=, 12($10), $pop8
	f64.const	$push9=, 0x1.6p3
	f64.ne  	$push10=, $11, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#2:                                 # %if.end6
	f64.load	$11=, 0($9)
	i32.const	$push11=, 24
	i32.add 	$push12=, $12, $pop11
	i32.store	$drop=, 12($10), $pop12
	f64.const	$push13=, 0x0p0
	f64.ne  	$push14=, $11, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push21=, __stack_pointer
	i32.const	$push19=, 16
	i32.add 	$push20=, $10, $pop19
	i32.store	$drop=, 0($pop21), $pop20
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
	i32.const	$push9=, __stack_pointer
	i32.const	$push6=, __stack_pointer
	i32.load	$push7=, 0($pop6)
	i32.const	$push8=, 32
	i32.sub 	$push10=, $pop7, $pop8
	i32.store	$push12=, 0($pop9), $pop10
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
