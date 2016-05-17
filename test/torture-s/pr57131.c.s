	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57131.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i64, i64, i64, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 48
	i32.sub 	$push20=, $pop14, $pop15
	i32.store	$push22=, 0($pop16), $pop20
	tee_local	$push21=, $7=, $pop22
	i32.const	$push1=, 0
	i32.store	$0=, 44($pop21), $pop1
	i64.const	$push2=, 0
	i64.store	$drop=, 32($7), $pop2
	i32.store	$1=, 28($7), $0
	i32.const	$push3=, 1
	i32.store	$push0=, 24($7), $pop3
	i32.store	$drop=, 20($7), $pop0
	i64.const	$push4=, 1
	i64.store	$2=, 8($7), $pop4
	i64.load32_s	$3=, 44($7)
	i64.load	$4=, 32($7)
	i64.load32_u	$5=, 28($7)
	i32.load	$0=, 24($7)
	i32.load	$6=, 20($7)
	block
	i64.load	$push10=, 8($7)
	i64.shl 	$push5=, $4, $5
	i64.mul 	$push6=, $3, $pop5
	i32.mul 	$push7=, $6, $0
	i64.extend_s/i32	$push8=, $pop7
	i64.div_s	$push9=, $pop6, $pop8
	i64.add 	$push11=, $pop10, $pop9
	i64.ne  	$push12=, $2, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push19=, __stack_pointer
	i32.const	$push17=, 48
	i32.add 	$push18=, $7, $pop17
	i32.store	$drop=, 0($pop19), $pop18
	return  	$1
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
