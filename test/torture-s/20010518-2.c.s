	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010518-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push32=, 0
	i32.const	$push29=, 0
	i32.load	$push30=, __stack_pointer($pop29)
	i32.const	$push31=, 48
	i32.sub 	$push33=, $pop30, $pop31
	i32.store	$push35=, __stack_pointer($pop32), $pop33
	tee_local	$push34=, $2=, $pop35
	i32.const	$push2=, 1
	i32.store16	$0=, 28($pop34), $pop2
	i32.const	$push3=, 2
	i32.store	$1=, 24($2), $pop3
	i32.const	$push4=, 3
	i32.store16	$drop=, 22($2), $pop4
	i32.const	$push5=, 4
	i32.store16	$drop=, 20($2), $pop5
	i32.const	$push6=, 0
	i32.store	$push0=, 16($2), $pop6
	i32.store8	$push1=, 15($2), $pop0
	i32.store8	$drop=, 14($2), $pop1
	i32.load16_u	$push7=, 28($2)
	i32.store16	$drop=, 46($2), $pop7
	i32.load	$push8=, 24($2)
	i32.store	$drop=, 40($2), $pop8
	i32.load16_u	$push9=, 22($2)
	i32.store16	$drop=, 38($2), $pop9
	i32.load16_u	$push10=, 20($2)
	i32.store16	$drop=, 36($2), $pop10
	i32.load	$push11=, 16($2)
	i32.store	$drop=, 32($2), $pop11
	i32.load8_u	$push12=, 15($2)
	i32.store8	$drop=, 31($2), $pop12
	i32.load8_u	$push13=, 14($2)
	i32.store8	$drop=, 30($2), $pop13
	i32.const	$push14=, 99
	i32.store8	$drop=, 31($2), $pop14
	block
	i32.load16_u	$push15=, 46($2)
	i32.ne  	$push16=, $0, $pop15
	br_if   	0, $pop16       # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push17=, 40($2)
	i32.ne  	$push18=, $pop17, $1
	br_if   	0, $pop18       # 0: down to label0
# BB#2:                                 # %lor.lhs.false9
	i32.load16_u	$push20=, 38($2)
	i32.const	$push19=, 3
	i32.ne  	$push21=, $pop20, $pop19
	br_if   	0, $pop21       # 0: down to label0
# BB#3:                                 # %lor.lhs.false14
	i32.load16_u	$push23=, 36($2)
	i32.const	$push22=, 4
	i32.ne  	$push24=, $pop23, $pop22
	br_if   	0, $pop24       # 0: down to label0
# BB#4:                                 # %lor.lhs.false19
	i32.load8_u	$push26=, 31($2)
	i32.const	$push25=, 99
	i32.ne  	$push27=, $pop26, $pop25
	br_if   	0, $pop27       # 0: down to label0
# BB#5:                                 # %if.end
	i32.const	$push28=, 0
	call    	exit@FUNCTION, $pop28
	unreachable
.LBB0_6:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
