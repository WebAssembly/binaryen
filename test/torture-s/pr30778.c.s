	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr30778.c"
	.section	.text.init_reg_last,"ax",@progbits
	.hidden	init_reg_last
	.globl	init_reg_last
	.type	init_reg_last,@function
init_reg_last:                          # @init_reg_last
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.load	$push14=, reg_stat($pop2)
	tee_local	$push13=, $1=, $pop14
	i32.const	$push12=, 0
	i32.store	$0=, 0($pop13), $pop12
	i32.const	$push3=, 8
	i32.add 	$push4=, $1, $pop3
	i64.const	$push5=, 0
	i64.store	$drop=, 0($pop4):p2align=2, $pop5
	i32.const	$push10=, 4
	i32.add 	$push11=, $1, $pop10
	i32.const	$push8=, 16
	i32.add 	$push9=, $1, $pop8
	i32.const	$push6=, 18
	i32.add 	$push7=, $1, $pop6
	i32.store8	$push0=, 0($pop7), $0
	i32.store16	$push1=, 0($pop9), $pop0
	i32.store	$drop=, 0($pop11), $pop1
                                        # fallthrough-return
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
	i32.const	$push15=, 0
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 32
	i32.sub 	$push12=, $pop4, $pop5
	i32.store	$push14=, __stack_pointer($pop6), $pop12
	tee_local	$push13=, $1=, $pop14
	i32.const	$push10=, 8
	i32.add 	$push11=, $pop13, $pop10
	i32.store	$drop=, reg_stat($pop15), $pop11
	i32.const	$push0=, -1
	i32.store	$0=, 28($1), $pop0
	call    	init_reg_last@FUNCTION
	block
	i32.load	$push1=, 28($1)
	i32.ne  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push9=, 0
	i32.const	$push7=, 32
	i32.add 	$push8=, $1, $pop7
	i32.store	$drop=, __stack_pointer($pop9), $pop8
	i32.const	$push16=, 0
	return  	$pop16
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
	.functype	abort, void
