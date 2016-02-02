	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57131.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 48
	i32.sub 	$4=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	i32.const	$push0=, 0
	i32.store	$0=, 44($4), $pop0
	i64.const	$push1=, 0
	i64.store	$discard=, 32($4), $pop1
	i32.store	$discard=, 28($4), $0
	i32.const	$push2=, 1
	i32.store	$push3=, 24($4), $pop2
	i32.store	$discard=, 20($4), $pop3
	block
	i64.const	$push4=, 1
	i64.store	$push5=, 8($4), $pop4
	i64.load32_s	$push6=, 44($4)
	i64.load	$push7=, 32($4)
	i64.load32_u	$push8=, 28($4)
	i64.shl 	$push9=, $pop7, $pop8
	i64.mul 	$push10=, $pop6, $pop9
	i32.load	$push11=, 24($4)
	i32.load	$push12=, 20($4)
	i32.mul 	$push13=, $pop11, $pop12
	i64.extend_s/i32	$push14=, $pop13
	i64.div_s	$push15=, $pop10, $pop14
	i64.load	$push16=, 8($4)
	i64.add 	$push17=, $pop15, $pop16
	i64.ne  	$push18=, $pop5, $pop17
	br_if   	$pop18, 0       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$3=, 48
	i32.add 	$4=, $4, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	return  	$0
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
