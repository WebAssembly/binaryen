	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr30778.c"
	.section	.text.init_reg_last,"ax",@progbits
	.hidden	init_reg_last
	.globl	init_reg_last
	.type	init_reg_last,@function
init_reg_last:                          # @init_reg_last
	.local  	i64, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, reg_stat($pop0)
	tee_local	$push11=, $1=, $pop1
	i64.const	$push2=, 0
	i64.store	$0=, 0($pop11):p2align=2, $pop2
	i32.const	$push6=, 16
	i32.add 	$push7=, $1, $pop6
	i32.const	$push3=, 18
	i32.add 	$push4=, $1, $pop3
	i32.const	$push10=, 0
	i32.store8	$push5=, 0($pop4):p2align=1, $pop10
	i32.store16	$discard=, 0($pop7):p2align=2, $pop5
	i32.const	$push8=, 8
	i32.add 	$push9=, $1, $pop8
	i64.store	$discard=, 0($pop9):p2align=2, $0
	return
	.endfunc
.Lfunc_end0:
	.size	init_reg_last, .Lfunc_end0-init_reg_last

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 32
	i32.sub 	$5=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
	i32.const	$push3=, 0
	i32.const	$4=, 8
	i32.add 	$4=, $5, $4
	i32.store	$discard=, reg_stat($pop3), $4
	i32.const	$push0=, -1
	i32.store	$0=, 28($5), $pop0
	call    	init_reg_last@FUNCTION
	block
	i32.load	$push1=, 28($5)
	i32.ne  	$push2=, $0, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	i32.const	$3=, 32
	i32.add 	$5=, $5, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	reg_stat,@object        # @reg_stat
	.lcomm	reg_stat,4,2

	.ident	"clang version 3.9.0 "
