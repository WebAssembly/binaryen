	.text
	.file	"pr38151.c"
	.section	.text.check2848va,"ax",@progbits
	.hidden	check2848va             # -- Begin function check2848va
	.globl	check2848va
	.type	check2848va,@function
check2848va:                            # @check2848va
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.load	$push19=, __stack_pointer($pop20)
	i32.const	$push21=, 16
	i32.sub 	$push26=, $pop19, $pop21
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
	i32.const	$push29=, 0
	i32.load	$push12=, s2848+4($pop29)
	i32.ne  	$push13=, $pop12, $3
	br_if   	0, $pop13       # 0: down to label1
# BB#3:                                 # %if.end
	i32.const	$push30=, 0
	i32.load	$push11=, s2848+8($pop30)
	i32.ne  	$push14=, $pop11, $2
	br_if   	0, $pop14       # 0: down to label1
# BB#4:                                 # %if.end4
	return
.LBB0_5:                                # %if.then2
	end_block                       # label1:
	i32.const	$push15=, 0
	i32.const	$push31=, 0
	i32.load	$push16=, fails($pop31)
	i32.const	$push17=, 1
	i32.add 	$push18=, $pop16, $pop17
	i32.store	fails($pop15), $pop18
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	check2848va, .Lfunc_end0-check2848va
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 32
	i32.sub 	$push19=, $pop4, $pop6
	tee_local	$push18=, $0=, $pop19
	i32.store	__stack_pointer($pop7), $pop18
	i32.const	$push17=, 0
	i32.const	$push0=, -218144346
	i32.store	s2848+8($pop17), $pop0
	i32.const	$push16=, 0
	i64.const	$push1=, 3107062874477850347
	i64.store	s2848($pop16), $pop1
	i64.const	$push15=, 3107062874477850347
	i64.store	16($0), $pop15
	i32.const	$push14=, 0
	i64.load	$push2=, s2848+8($pop14)
	i64.store	24($0), $pop2
	i32.const	$push11=, 16
	i32.add 	$push12=, $0, $pop11
	i32.store	0($0), $pop12
	call    	check2848va@FUNCTION, $0, $0
	block   	
	i32.const	$push13=, 0
	i32.load	$push3=, fails($pop13)
	br_if   	0, $pop3        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push10=, 0
	i32.const	$push8=, 32
	i32.add 	$push9=, $0, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	i32.const	$push20=, 0
	return  	$pop20
.LBB1_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
