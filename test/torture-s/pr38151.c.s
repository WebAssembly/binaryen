	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr38151.c"
	.section	.text.check2848va,"ax",@progbits
	.hidden	check2848va
	.globl	check2848va
	.type	check2848va,@function
check2848va:                            # @check2848va
	.param  	i32, i32
	.local  	i32, i32, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push30=, __stack_pointer
	i32.load	$push31=, 0($pop30)
	i32.const	$push32=, 16
	i32.sub 	$6=, $pop31, $pop32
	i32.store	$push0=, 12($6), $1
	i32.const	$push1=, 15
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -16
	i32.and 	$push25=, $pop2, $pop3
	tee_local	$push24=, $1=, $pop25
	i64.load	$4=, 0($pop24):p2align=4
	i32.const	$push23=, 0
	i64.load	$5=, s2848($pop23):p2align=4
	i32.const	$push4=, 16
	i32.add 	$push5=, $1, $pop4
	i32.store	$discard=, 12($6), $pop5
	i32.load	$2=, 8($1):p2align=3
	i64.const	$push7=, 32
	i64.shr_u	$push8=, $4, $pop7
	i32.wrap/i64	$1=, $pop8
	i64.const	$push22=, 32
	i64.shr_u	$push11=, $5, $pop22
	i32.wrap/i64	$3=, $pop11
	block
	i32.wrap/i64	$push9=, $5
	i32.wrap/i64	$push6=, $4
	i32.eq  	$push10=, $pop9, $pop6
	br_if   	0, $pop10       # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push27=, 0
	i32.const	$push26=, 0
	i32.load	$push12=, fails($pop26)
	i32.const	$push13=, 1
	i32.add 	$push14=, $pop12, $pop13
	i32.store	$discard=, fails($pop27), $pop14
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block
	block
	i32.ne  	$push16=, $3, $1
	br_if   	0, $pop16       # 0: down to label2
# BB#3:                                 # %if.end
	i32.const	$push28=, 0
	i32.load	$push15=, s2848+8($pop28):p2align=3
	i32.eq  	$push17=, $pop15, $2
	br_if   	1, $pop17       # 1: down to label1
.LBB0_4:                                # %if.then2
	end_block                       # label2:
	i32.const	$push18=, 0
	i32.const	$push29=, 0
	i32.load	$push19=, fails($pop29)
	i32.const	$push20=, 1
	i32.add 	$push21=, $pop19, $pop20
	i32.store	$discard=, fails($pop18), $pop21
.LBB0_5:                                # %if.end4
	end_block                       # label1:
	return
	.endfunc
.Lfunc_end0:
	.size	check2848va, .Lfunc_end0-check2848va

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push11=, __stack_pointer
	i32.load	$push12=, 0($pop11)
	i32.const	$push13=, 32
	i32.sub 	$1=, $pop12, $pop13
	i32.const	$push14=, __stack_pointer
	i32.store	$discard=, 0($pop14), $1
	i32.const	$push9=, 0
	i64.const	$push0=, 3107062874477850347
	i64.store	$discard=, s2848($pop9):p2align=4, $pop0
	i32.const	$push8=, 0
	i32.const	$push1=, -218144346
	i32.store	$0=, s2848+8($pop8):p2align=3, $pop1
	i32.const	$push2=, -267489557
	i32.store	$discard=, 16($1):p2align=4, $pop2
	i32.store	$discard=, 24($1):p2align=3, $0
	i32.const	$push3=, 723419448
	i32.store	$discard=, 20($1), $pop3
	i32.const	$push7=, 0
	i32.load	$push4=, s2848+12($pop7)
	i32.store	$discard=, 28($1), $pop4
	i32.const	$push18=, 16
	i32.add 	$push19=, $1, $pop18
	i32.store	$discard=, 0($1):p2align=4, $pop19
	call    	check2848va@FUNCTION, $0, $1
	block
	i32.const	$push6=, 0
	i32.load	$push5=, fails($pop6)
	br_if   	0, $pop5        # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$push10=, 0
	i32.const	$push17=, __stack_pointer
	i32.const	$push15=, 32
	i32.add 	$push16=, $1, $pop15
	i32.store	$discard=, 0($pop17), $pop16
	return  	$pop10
.LBB1_2:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	s2848                   # @s2848
	.type	s2848,@object
	.section	.bss.s2848,"aw",@nobits
	.globl	s2848
	.p2align	4
s2848:
	.skip	16
	.size	s2848, 16

	.hidden	fails                   # @fails
	.type	fails,@object
	.section	.bss.fails,"aw",@nobits
	.globl	fails
	.p2align	2
fails:
	.int32	0                       # 0x0
	.size	fails, 4


	.ident	"clang version 3.9.0 "
