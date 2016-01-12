	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010518-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 48
	i32.sub 	$8=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $8
	block   	.LBB0_6
	i32.const	$push0=, 1
	i32.store16	$0=, 28($8), $pop0
	i32.const	$push1=, 2
	i32.store	$1=, 24($8), $pop1
	i32.const	$push2=, 3
	i32.store16	$2=, 22($8), $pop2
	i32.const	$push3=, 4
	i32.store16	$3=, 20($8), $pop3
	i32.const	$push4=, 0
	i32.store	$push5=, 16($8), $pop4
	i32.store8	$push6=, 15($8), $pop5
	i32.store8	$4=, 14($8), $pop6
	i32.load16_u	$push7=, 28($8)
	i32.store16	$discard=, 46($8), $pop7
	i32.load	$push8=, 24($8)
	i32.store	$discard=, 40($8), $pop8
	i32.load16_u	$push9=, 22($8)
	i32.store16	$discard=, 38($8), $pop9
	i32.load16_u	$push10=, 20($8)
	i32.store16	$discard=, 36($8), $pop10
	i32.load	$push11=, 16($8)
	i32.store	$discard=, 32($8), $pop11
	i32.load8_u	$push12=, 15($8)
	i32.store8	$discard=, 31($8), $pop12
	i32.load8_u	$push13=, 14($8)
	i32.store8	$discard=, 30($8), $pop13
	i32.const	$push14=, 99
	i32.store8	$5=, 31($8), $pop14
	i32.load16_u	$push15=, 46($8)
	i32.ne  	$push16=, $pop15, $0
	br_if   	$pop16, .LBB0_6
# BB#1:                                 # %lor.lhs.false
	i32.load	$push17=, 40($8)
	i32.ne  	$push18=, $pop17, $1
	br_if   	$pop18, .LBB0_6
# BB#2:                                 # %lor.lhs.false9
	i32.load16_u	$push19=, 38($8)
	i32.ne  	$push20=, $pop19, $2
	br_if   	$pop20, .LBB0_6
# BB#3:                                 # %lor.lhs.false14
	i32.load16_u	$push21=, 36($8)
	i32.ne  	$push22=, $pop21, $3
	br_if   	$pop22, .LBB0_6
# BB#4:                                 # %lor.lhs.false19
	i32.load8_u	$push23=, 31($8)
	i32.ne  	$push24=, $pop23, $5
	br_if   	$pop24, .LBB0_6
# BB#5:                                 # %if.end
	call    	exit@FUNCTION, $4
	unreachable
.LBB0_6:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
