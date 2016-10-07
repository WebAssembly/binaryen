	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr30778.c"
	.section	.text.init_reg_last,"ax",@progbits
	.hidden	init_reg_last
	.globl	init_reg_last
	.type	init_reg_last,@function
init_reg_last:                          # @init_reg_last
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push15=, reg_stat($pop0)
	tee_local	$push14=, $0=, $pop15
	i32.const	$push13=, 0
	i32.store	0($pop14):p2align=0, $pop13
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i64.const	$push3=, 0
	i64.store	0($pop2):p2align=0, $pop3
	i32.const	$push4=, 18
	i32.add 	$push5=, $0, $pop4
	i32.const	$push12=, 0
	i32.store8	0($pop5), $pop12
	i32.const	$push6=, 16
	i32.add 	$push7=, $0, $pop6
	i32.const	$push11=, 0
	i32.store16	0($pop7):p2align=0, $pop11
	i32.const	$push8=, 4
	i32.add 	$push9=, $0, $pop8
	i32.const	$push10=, 0
	i32.store	0($pop9):p2align=0, $pop10
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 32
	i32.sub 	$push15=, $pop4, $pop5
	tee_local	$push14=, $0=, $pop15
	i32.store	__stack_pointer($pop6), $pop14
	i32.const	$push13=, 0
	i32.const	$push10=, 8
	i32.add 	$push11=, $0, $pop10
	i32.store	reg_stat($pop13), $pop11
	i32.const	$push0=, -1
	i32.store	28($0), $pop0
	call    	init_reg_last@FUNCTION
	block   	
	i32.load	$push1=, 28($0)
	i32.const	$push12=, -1
	i32.ne  	$push2=, $pop1, $pop12
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push9=, 0
	i32.const	$push7=, 32
	i32.add 	$push8=, $0, $pop7
	i32.store	__stack_pointer($pop9), $pop8
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
	.section	.bss.reg_stat,"aw",@nobits
	.p2align	2
reg_stat:
	.int32	0
	.size	reg_stat, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
