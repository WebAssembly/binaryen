	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr30778.c"
	.section	.text.init_reg_last,"ax",@progbits
	.hidden	init_reg_last
	.globl	init_reg_last
	.type	init_reg_last,@function
init_reg_last:                          # @init_reg_last
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push14=, reg_stat($pop0)
	tee_local	$push13=, $1=, $pop14
	i32.const	$push12=, 0
	i32.store	$0=, 0($pop13), $pop12
	i32.const	$push1=, 8
	i32.add 	$push2=, $1, $pop1
	i64.const	$push3=, 0
	i64.store	$discard=, 0($pop2):p2align=2, $pop3
	i32.const	$push10=, 4
	i32.add 	$push11=, $1, $pop10
	i32.const	$push7=, 16
	i32.add 	$push8=, $1, $pop7
	i32.const	$push4=, 18
	i32.add 	$push5=, $1, $pop4
	i32.store8	$push6=, 0($pop5), $0
	i32.store16	$push9=, 0($pop8), $pop6
	i32.store	$discard=, 0($pop11), $pop9
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push5=, __stack_pointer
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 32
	i32.sub 	$1=, $pop6, $pop7
	i32.const	$push8=, __stack_pointer
	i32.store	$discard=, 0($pop8), $1
	i32.const	$push3=, 0
	i32.const	$push12=, 8
	i32.add 	$push13=, $1, $pop12
	i32.store	$discard=, reg_stat($pop3), $pop13
	i32.const	$push0=, -1
	i32.store	$0=, 28($1), $pop0
	call    	init_reg_last@FUNCTION
	block
	i32.load	$push1=, 28($1)
	i32.ne  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	i32.const	$push11=, __stack_pointer
	i32.const	$push9=, 32
	i32.add 	$push10=, $1, $pop9
	i32.store	$discard=, 0($pop11), $pop10
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
