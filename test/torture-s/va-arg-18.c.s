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
	i32.const	$push17=, __stack_pointer
	i32.load	$push18=, 0($pop17)
	i32.const	$push19=, 16
	i32.sub 	$12=, $pop18, $pop19
	i32.const	$push20=, __stack_pointer
	i32.store	$discard=, 0($pop20), $12
	i32.store	$push15=, 12($12), $9
	tee_local	$push14=, $9=, $pop15
	i32.const	$push0=, 4
	i32.add 	$push1=, $pop14, $pop0
	i32.store	$10=, 12($12), $pop1
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
	i32.store	$discard=, 12($12), $pop11
	i32.load	$push12=, 0($11)
	i32.const	$push16=, 12
	i32.ne  	$push13=, $pop12, $pop16
	br_if   	0, $pop13       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push23=, __stack_pointer
	i32.const	$push21=, 16
	i32.add 	$push22=, $12, $pop21
	i32.store	$discard=, 0($pop23), $pop22
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
	i32.const	$push3=, __stack_pointer
	i32.load	$push4=, 0($pop3)
	i32.const	$push5=, 16
	i32.sub 	$1=, $pop4, $pop5
	i32.const	$push6=, __stack_pointer
	i32.store	$discard=, 0($pop6), $1
	i32.const	$push0=, 12
	i32.store	$discard=, 8($1), $pop0
	i64.const	$push1=, 47244640266
	i64.store	$discard=, 0($1), $pop1
	call    	f@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $1
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
