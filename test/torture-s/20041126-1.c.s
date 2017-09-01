	.text
	.file	"20041126-1.c"
	.section	.text.check,"ax",@progbits
	.hidden	check                   # -- Begin function check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push0=, 0($0)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %for.inc
	i32.load	$push1=, 4($0)
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %for.inc.1
	i32.load	$push2=, 8($0)
	br_if   	0, $pop2        # 0: down to label0
# BB#3:                                 # %for.inc.2
	i32.load	$push3=, 12($0)
	br_if   	0, $pop3        # 0: down to label0
# BB#4:                                 # %for.inc.3
	i32.load	$push4=, 16($0)
	br_if   	0, $pop4        # 0: down to label0
# BB#5:                                 # %for.body3.preheader
	i32.const	$3=, 5
.LBB0_6:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push12=, 2
	i32.shl 	$push6=, $3, $pop12
	i32.add 	$push7=, $0, $pop6
	i32.load	$push11=, 0($pop7)
	tee_local	$push10=, $1=, $pop11
	i32.const	$push9=, 1
	i32.add 	$push5=, $3, $pop9
	i32.ne  	$push8=, $pop10, $pop5
	br_if   	1, $pop8        # 1: down to label0
# BB#7:                                 # %for.cond1
                                        #   in Loop: Header=BB0_6 Depth=1
	i32.const	$push13=, 8
	i32.gt_s	$2=, $3, $pop13
	copy_local	$3=, $1
	i32.eqz 	$push14=, $2
	br_if   	0, $pop14       # 0: up to label1
# BB#8:                                 # %for.end10
	end_loop
	return
.LBB0_9:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %for.body3.lr.ph.i
	i32.const	$push18=, 0
	i32.const	$push16=, 0
	i32.load	$push15=, __stack_pointer($pop16)
	i32.const	$push17=, 48
	i32.sub 	$push29=, $pop15, $pop17
	tee_local	$push28=, $3=, $pop29
	i32.store	__stack_pointer($pop18), $pop28
	i32.const	$push2=, 16
	i32.add 	$push27=, $3, $pop2
	tee_local	$push26=, $2=, $pop27
	i32.const	$push0=, 0
	i64.load	$push1=, .Lmain.a+16($pop0)
	i64.store	0($pop26), $pop1
	i32.const	$push4=, 32
	i32.add 	$push5=, $3, $pop4
	i32.const	$push25=, 0
	i64.load	$push3=, .Lmain.a+32($pop25)
	i64.store	0($pop5), $pop3
	i32.const	$push7=, 24
	i32.add 	$push8=, $3, $pop7
	i32.const	$push24=, 0
	i64.load	$push6=, .Lmain.a+24($pop24)
	i64.store	0($pop8), $pop6
	i32.const	$push23=, 0
	i32.store	0($2), $pop23
	i64.const	$push9=, 0
	i64.store	8($3), $pop9
	i64.const	$push22=, 0
	i64.store	0($3), $pop22
	i32.const	$2=, 5
.LBB1_1:                                # %for.body3.i
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label3:
	i32.const	$push33=, 2
	i32.shl 	$push11=, $2, $pop33
	i32.add 	$push12=, $3, $pop11
	i32.load	$push32=, 0($pop12)
	tee_local	$push31=, $0=, $pop32
	i32.const	$push30=, 1
	i32.add 	$push10=, $2, $pop30
	i32.ne  	$push13=, $pop31, $pop10
	br_if   	1, $pop13       # 1: down to label2
# BB#2:                                 # %for.cond1.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push34=, 8
	i32.gt_s	$1=, $2, $pop34
	copy_local	$2=, $0
	i32.eqz 	$push35=, $1
	br_if   	0, $pop35       # 0: up to label3
# BB#3:                                 # %check.exit
	end_loop
	i32.const	$push21=, 0
	i32.const	$push19=, 48
	i32.add 	$push20=, $3, $pop19
	i32.store	__stack_pointer($pop21), $pop20
	i32.const	$push14=, 0
	return  	$pop14
.LBB1_4:                                # %if.then6.i
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	.Lmain.a,@object        # @main.a
	.section	.rodata..Lmain.a,"a",@progbits
	.p2align	4
.Lmain.a:
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.int32	5                       # 0x5
	.int32	6                       # 0x6
	.int32	7                       # 0x7
	.int32	8                       # 0x8
	.int32	9                       # 0x9
	.int32	10                      # 0xa
	.size	.Lmain.a, 40


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
