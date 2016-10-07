	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr38151.c"
	.section	.text.check2848va,"ax",@progbits
	.hidden	check2848va
	.globl	check2848va
	.type	check2848va,@function
check2848va:                            # @check2848va
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, 0
	i32.load	$push20=, __stack_pointer($pop19)
	i32.const	$push21=, 16
	i32.sub 	$push26=, $pop20, $pop21
	tee_local	$push25=, $3=, $pop26
	i32.store	12($pop25), $1
	i32.const	$push0=, 15
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -16
	i32.and 	$push24=, $pop1, $pop2
	tee_local	$push23=, $1=, $pop24
	i32.const	$push3=, 16
	i32.add 	$push4=, $pop23, $pop3
	i32.store	12($3), $pop4
	i32.load	$2=, 8($1)
	i32.load	$3=, 4($1)
	block   	
	i32.const	$push22=, 0
	i32.load	$push6=, s2848($pop22)
	i32.load	$push5=, 0($1)
	i32.eq  	$push7=, $pop6, $pop5
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push28=, 0
	i32.const	$push27=, 0
	i32.load	$push8=, fails($pop27)
	i32.const	$push9=, 1
	i32.add 	$push10=, $pop8, $pop9
	i32.store	fails($pop28), $pop10
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block   	
	block   	
	i32.const	$push29=, 0
	i32.load	$push12=, s2848+4($pop29)
	i32.ne  	$push13=, $pop12, $3
	br_if   	0, $pop13       # 0: down to label2
# BB#3:                                 # %if.end
	i32.const	$push30=, 0
	i32.load	$push11=, s2848+8($pop30)
	i32.eq  	$push14=, $pop11, $2
	br_if   	1, $pop14       # 1: down to label1
.LBB0_4:                                # %if.then2
	end_block                       # label2:
	i32.const	$push15=, 0
	i32.const	$push31=, 0
	i32.load	$push16=, fails($pop31)
	i32.const	$push17=, 1
	i32.add 	$push18=, $pop16, $pop17
	i32.store	fails($pop15), $pop18
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
	i32.store	__stack_pointer($pop9), $pop20
	i32.const	$push19=, 0
	i64.const	$push0=, 3107062874477850347
	i64.store	s2848($pop19), $pop0
	i32.const	$push18=, 0
	i32.const	$push1=, -218144346
	i32.store	s2848+8($pop18), $pop1
	i32.const	$push2=, -267489557
	i32.store	16($0), $pop2
	i32.const	$push17=, -218144346
	i32.store	24($0), $pop17
	i32.const	$push3=, 723419448
	i32.store	20($0), $pop3
	i32.const	$push16=, 0
	i32.load	$push4=, s2848+12($pop16)
	i32.store	28($0), $pop4
	i32.const	$push13=, 16
	i32.add 	$push14=, $0, $pop13
	i32.store	0($0), $pop14
	call    	check2848va@FUNCTION, $0, $0
	block   	
	i32.const	$push15=, 0
	i32.load	$push5=, fails($pop15)
	br_if   	0, $pop5        # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	i32.const	$push10=, 32
	i32.add 	$push11=, $0, $pop10
	i32.store	__stack_pointer($pop12), $pop11
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
