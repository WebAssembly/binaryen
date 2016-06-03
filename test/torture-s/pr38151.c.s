	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr38151.c"
	.section	.text.check2848va,"ax",@progbits
	.hidden	check2848va
	.globl	check2848va
	.type	check2848va,@function
check2848va:                            # @check2848va
	.param  	i32, i32
	.local  	i32, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push22=, 0
	i32.load	$push23=, __stack_pointer($pop22)
	i32.const	$push24=, 16
	i32.sub 	$push34=, $pop23, $pop24
	tee_local	$push33=, $5=, $pop34
	i32.store	$push0=, 12($5), $1
	i32.const	$push1=, 15
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -16
	i32.and 	$push32=, $pop2, $pop3
	tee_local	$push31=, $1=, $pop32
	i32.const	$push4=, 16
	i32.add 	$push5=, $pop31, $pop4
	i32.store	$drop=, 12($pop33), $pop5
	i32.const	$push30=, 0
	i64.load	$push29=, s2848($pop30)
	tee_local	$push28=, $4=, $pop29
	i64.const	$push9=, 32
	i64.shr_u	$push10=, $pop28, $pop9
	i32.wrap/i64	$5=, $pop10
	i32.load	$2=, 8($1)
	i64.load	$push27=, 0($1)
	tee_local	$push26=, $3=, $pop27
	i64.const	$push25=, 32
	i64.shr_u	$push11=, $pop26, $pop25
	i32.wrap/i64	$1=, $pop11
	block
	i32.wrap/i64	$push7=, $4
	i32.wrap/i64	$push6=, $3
	i32.eq  	$push8=, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push36=, 0
	i32.const	$push35=, 0
	i32.load	$push12=, fails($pop35)
	i32.const	$push13=, 1
	i32.add 	$push14=, $pop12, $pop13
	i32.store	$drop=, fails($pop36), $pop14
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block
	block
	i32.ne  	$push16=, $5, $1
	br_if   	0, $pop16       # 0: down to label2
# BB#3:                                 # %if.end
	i32.const	$push37=, 0
	i32.load	$push15=, s2848+8($pop37)
	i32.eq  	$push17=, $pop15, $2
	br_if   	1, $pop17       # 1: down to label1
.LBB0_4:                                # %if.then2
	end_block                       # label2:
	i32.const	$push18=, 0
	i32.const	$push38=, 0
	i32.load	$push19=, fails($pop38)
	i32.const	$push20=, 1
	i32.add 	$push21=, $pop19, $pop20
	i32.store	$drop=, fails($pop18), $pop21
.LBB0_5:                                # %if.end4
	end_block                       # label1:
                                        # fallthrough-return
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
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 32
	i32.sub 	$push15=, $pop7, $pop8
	i32.store	$1=, __stack_pointer($pop9), $pop15
	i32.const	$push19=, 0
	i64.const	$push0=, 3107062874477850347
	i64.store	$drop=, s2848($pop19), $pop0
	i32.const	$push18=, 0
	i32.const	$push1=, -218144346
	i32.store	$0=, s2848+8($pop18), $pop1
	i32.const	$push2=, -267489557
	i32.store	$drop=, 16($1), $pop2
	i32.store	$drop=, 24($1), $0
	i32.const	$push3=, 723419448
	i32.store	$drop=, 20($1), $pop3
	i32.const	$push17=, 0
	i32.load	$push4=, s2848+12($pop17)
	i32.store	$drop=, 28($1), $pop4
	i32.const	$push13=, 16
	i32.add 	$push14=, $1, $pop13
	i32.store	$drop=, 0($1), $pop14
	call    	check2848va@FUNCTION, $1, $1
	block
	i32.const	$push16=, 0
	i32.load	$push5=, fails($pop16)
	br_if   	0, $pop5        # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	i32.const	$push10=, 32
	i32.add 	$push11=, $1, $pop10
	i32.store	$drop=, __stack_pointer($pop12), $pop11
	i32.const	$push20=, 0
	return  	$pop20
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
	.functype	abort, void
