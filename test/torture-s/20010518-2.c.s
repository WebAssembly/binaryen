	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010518-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 48
	i32.sub 	$4=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	i32.const	$push2=, 3
	i32.store16	$discard=, 22($4), $pop2
	i32.const	$push3=, 4
	i32.store16	$discard=, 20($4), $pop3
	i32.const	$push4=, 0
	i32.store	$push5=, 16($4):p2align=3, $pop4
	i32.store8	$push6=, 15($4), $pop5
	i32.store8	$discard=, 14($4), $pop6
	i32.const	$push0=, 1
	i32.store16	$0=, 28($4), $pop0
	i32.const	$push1=, 2
	i32.store	$1=, 24($4), $pop1
	i32.load16_u	$push7=, 28($4)
	i32.store16	$discard=, 46($4), $pop7
	i32.load	$push8=, 24($4)
	i32.store	$discard=, 40($4), $pop8
	i32.load16_u	$push9=, 22($4)
	i32.store16	$discard=, 38($4), $pop9
	i32.load16_u	$push10=, 20($4)
	i32.store16	$discard=, 36($4), $pop10
	i32.load	$push11=, 16($4):p2align=3
	i32.store	$discard=, 32($4):p2align=3, $pop11
	i32.load8_u	$push12=, 15($4)
	i32.store8	$discard=, 31($4), $pop12
	i32.load8_u	$push13=, 14($4)
	i32.store8	$discard=, 30($4), $pop13
	i32.const	$push14=, 99
	i32.store8	$discard=, 31($4), $pop14
	block
	i32.load16_u	$push15=, 46($4)
	i32.ne  	$push16=, $0, $pop15
	br_if   	0, $pop16       # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push17=, 40($4)
	i32.ne  	$push18=, $pop17, $1
	br_if   	0, $pop18       # 0: down to label0
# BB#2:                                 # %lor.lhs.false9
	i32.load16_u	$push19=, 38($4)
	i32.const	$push20=, 3
	i32.ne  	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label0
# BB#3:                                 # %lor.lhs.false14
	i32.load16_u	$push22=, 36($4)
	i32.const	$push23=, 4
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	0, $pop24       # 0: down to label0
# BB#4:                                 # %lor.lhs.false19
	i32.load8_u	$push25=, 31($4)
	i32.const	$push26=, 99
	i32.ne  	$push27=, $pop25, $pop26
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
