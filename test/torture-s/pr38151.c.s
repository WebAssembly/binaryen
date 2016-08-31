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
	i32.const	$push21=, 0
	i32.load	$push22=, __stack_pointer($pop21)
	i32.const	$push23=, 16
	i32.sub 	$push33=, $pop22, $pop23
	tee_local	$push32=, $5=, $pop33
	i32.store	$drop=, 12($pop32), $1
	i32.const	$push0=, 15
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -16
	i32.and 	$push31=, $pop1, $pop2
	tee_local	$push30=, $1=, $pop31
	i32.const	$push3=, 16
	i32.add 	$push4=, $pop30, $pop3
	i32.store	$drop=, 12($5), $pop4
	i32.const	$push29=, 0
	i64.load	$push28=, s2848($pop29)
	tee_local	$push27=, $4=, $pop28
	i64.const	$push8=, 32
	i64.shr_u	$push9=, $pop27, $pop8
	i32.wrap/i64	$5=, $pop9
	i32.load	$2=, 8($1)
	i64.load	$push26=, 0($1)
	tee_local	$push25=, $3=, $pop26
	i64.const	$push24=, 32
	i64.shr_u	$push10=, $pop25, $pop24
	i32.wrap/i64	$1=, $pop10
	block
	i32.wrap/i64	$push6=, $4
	i32.wrap/i64	$push5=, $3
	i32.eq  	$push7=, $pop6, $pop5
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push35=, 0
	i32.const	$push34=, 0
	i32.load	$push11=, fails($pop34)
	i32.const	$push12=, 1
	i32.add 	$push13=, $pop11, $pop12
	i32.store	$drop=, fails($pop35), $pop13
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block
	block
	i32.ne  	$push15=, $5, $1
	br_if   	0, $pop15       # 0: down to label2
# BB#3:                                 # %if.end
	i32.const	$push36=, 0
	i32.load	$push14=, s2848+8($pop36)
	i32.eq  	$push16=, $pop14, $2
	br_if   	1, $pop16       # 1: down to label1
.LBB0_4:                                # %if.then2
	end_block                       # label2:
	i32.const	$push17=, 0
	i32.const	$push37=, 0
	i32.load	$push18=, fails($pop37)
	i32.const	$push19=, 1
	i32.add 	$push20=, $pop18, $pop19
	i32.store	$drop=, fails($pop17), $pop20
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 32
	i32.sub 	$push21=, $pop7, $pop8
	tee_local	$push20=, $0=, $pop21
	i32.store	$drop=, __stack_pointer($pop9), $pop20
	i32.const	$push19=, 0
	i64.const	$push0=, 3107062874477850347
	i64.store	$drop=, s2848($pop19), $pop0
	i32.const	$push18=, 0
	i32.const	$push1=, -218144346
	i32.store	$drop=, s2848+8($pop18), $pop1
	i32.const	$push2=, -267489557
	i32.store	$drop=, 16($0), $pop2
	i32.const	$push17=, -218144346
	i32.store	$drop=, 24($0), $pop17
	i32.const	$push3=, 723419448
	i32.store	$drop=, 20($0), $pop3
	i32.const	$push16=, 0
	i32.load	$push4=, s2848+12($pop16)
	i32.store	$drop=, 28($0), $pop4
	i32.const	$push13=, 16
	i32.add 	$push14=, $0, $pop13
	i32.store	$drop=, 0($0), $pop14
	call    	check2848va@FUNCTION, $0, $0
	block
	i32.const	$push15=, 0
	i32.load	$push5=, fails($pop15)
	br_if   	0, $pop5        # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	i32.const	$push10=, 32
	i32.add 	$push11=, $0, $pop10
	i32.store	$drop=, __stack_pointer($pop12), $pop11
	i32.const	$push22=, 0
	return  	$pop22
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
