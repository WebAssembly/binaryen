	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57131.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i64, i64, i64, i64, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 48
	i32.sub 	$10=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$10=, 0($8), $10
	i32.const	$push0=, 0
	i32.store	$0=, 44($10), $pop0
	i64.const	$push1=, 0
	i64.store	$discard=, 32($10), $pop1
	i32.store	$1=, 28($10), $0
	i32.const	$push2=, 1
	i32.store	$push3=, 24($10), $pop2
	i32.store	$discard=, 20($10), $pop3
	i64.const	$push4=, 1
	i64.store	$2=, 8($10), $pop4
	i64.load32_s	$3=, 44($10)
	i64.load	$4=, 32($10)
	i64.load32_u	$5=, 28($10)
	i32.load	$0=, 24($10)
	i32.load	$6=, 20($10)
	block   	.LBB0_2
	i64.load	$push10=, 8($10)
	i64.shl 	$push5=, $4, $5
	i64.mul 	$push6=, $pop5, $3
	i32.mul 	$push7=, $6, $0
	i64.extend_s/i32	$push8=, $pop7
	i64.div_s	$push9=, $pop6, $pop8
	i64.add 	$push11=, $pop10, $pop9
	i64.ne  	$push12=, $pop11, $2
	br_if   	$pop12, .LBB0_2
# BB#1:                                 # %if.end
	i32.const	$9=, 48
	i32.add 	$10=, $10, $9
	i32.const	$9=, __stack_pointer
	i32.store	$10=, 0($9), $10
	return  	$1
.LBB0_2:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
