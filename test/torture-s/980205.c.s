	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980205.c"
	.section	.text.fdouble,"ax",@progbits
	.hidden	fdouble
	.globl	fdouble
	.type	fdouble,@function
fdouble:                                # @fdouble
	.param  	f64, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push14=, __stack_pointer
	i32.const	$push11=, __stack_pointer
	i32.load	$push12=, 0($pop11)
	i32.const	$push13=, 16
	i32.sub 	$push18=, $pop12, $pop13
	i32.store	$2=, 0($pop14), $pop18
	i32.store	$push0=, 12($2), $1
	i32.const	$push2=, 7
	i32.add 	$push3=, $pop0, $pop2
	i32.const	$push4=, -8
	i32.and 	$push20=, $pop3, $pop4
	tee_local	$push19=, $1=, $pop20
	i32.const	$push5=, 8
	i32.add 	$push6=, $pop19, $pop5
	i32.store	$discard=, 12($2), $pop6
	block
	f64.const	$push7=, 0x1p0
	f64.ne  	$push8=, $0, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %entry
	f64.load	$push1=, 0($1)
	f64.const	$push9=, 0x1p1
	f64.ne  	$push10=, $pop1, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push17=, __stack_pointer
	i32.const	$push15=, 16
	i32.add 	$push16=, $2, $pop15
	i32.store	$discard=, 0($pop17), $pop16
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	fdouble, .Lfunc_end0-fdouble

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push6=, __stack_pointer
	i32.const	$push3=, __stack_pointer
	i32.load	$push4=, 0($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push7=, $pop4, $pop5
	i32.store	$push9=, 0($pop6), $pop7
	tee_local	$push8=, $0=, $pop9
	i64.const	$push0=, 4611686018427387904
	i64.store	$discard=, 0($pop8), $pop0
	f64.const	$push1=, 0x1p0
	call    	fdouble@FUNCTION, $pop1, $0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
