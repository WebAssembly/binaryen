	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980205.c"
	.section	.text.fdouble,"ax",@progbits
	.hidden	fdouble
	.globl	fdouble
	.type	fdouble,@function
fdouble:                                # @fdouble
	.param  	f64, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$push1=, 12($5), $1
	i32.const	$push2=, 7
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -8
	i32.and 	$push5=, $pop3, $pop4
	tee_local	$push12=, $1=, $pop5
	i32.const	$push6=, 8
	i32.add 	$push7=, $pop12, $pop6
	i32.store	$discard=, 12($5), $pop7
	block
	f64.const	$push8=, 0x1p0
	f64.ne  	$push9=, $0, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#1:                                 # %entry
	f64.load	$push0=, 0($1)
	f64.const	$push10=, 0x1p1
	f64.ne  	$push11=, $pop0, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$2=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$2=, 0($1), $2
	i64.const	$push0=, 4611686018427387904
	i64.store	$discard=, 0($2):p2align=4, $pop0
	f64.const	$push1=, 0x1p0
	call    	fdouble@FUNCTION, $pop1, $2
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
