	.text
	.file	"20041126-1.c"
	.section	.text.check,"ax",@progbits
	.hidden	check                   # -- Begin function check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	block   	
	i32.load	$push0=, 0($0)
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %for.inc
	i32.load	$push1=, 4($0)
	br_if   	0, $pop1        # 0: down to label0
# %bb.2:                                # %for.inc.1
	i32.load	$push2=, 8($0)
	br_if   	0, $pop2        # 0: down to label0
# %bb.3:                                # %for.inc.2
	i32.load	$push3=, 12($0)
	br_if   	0, $pop3        # 0: down to label0
# %bb.4:                                # %for.inc.3
	i32.load	$push4=, 16($0)
	br_if   	0, $pop4        # 0: down to label0
# %bb.5:                                # %for.body3.preheader
	i32.const	$2=, 5
.LBB0_6:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push10=, 1
	i32.add 	$1=, $2, $pop10
	i32.const	$push9=, 2
	i32.shl 	$push5=, $2, $pop9
	i32.add 	$push6=, $0, $pop5
	i32.load	$2=, 0($pop6)
	i32.ne  	$push7=, $2, $1
	br_if   	1, $pop7        # 1: down to label0
# %bb.7:                                # %for.cond1
                                        #   in Loop: Header=BB0_6 Depth=1
	i32.const	$push11=, 9
	i32.le_u	$push8=, $2, $pop11
	br_if   	0, $pop8        # 0: up to label1
# %bb.8:                                # %for.end10
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
	.local  	i32, i32, i32
# %bb.0:                                # %for.body3.lr.ph.i
	i32.const	$push16=, 0
	i32.load	$push15=, __stack_pointer($pop16)
	i32.const	$push17=, 48
	i32.sub 	$2=, $pop15, $pop17
	i32.const	$push18=, 0
	i32.store	__stack_pointer($pop18), $2
	i32.const	$push2=, 16
	i32.add 	$1=, $2, $pop2
	i32.const	$push0=, 0
	i64.load	$push1=, .Lmain.a+16($pop0)
	i64.store	0($1), $pop1
	i32.const	$push4=, 32
	i32.add 	$push5=, $2, $pop4
	i32.const	$push25=, 0
	i64.load	$push3=, .Lmain.a+32($pop25)
	i64.store	0($pop5), $pop3
	i32.const	$push7=, 24
	i32.add 	$push8=, $2, $pop7
	i32.const	$push24=, 0
	i64.load	$push6=, .Lmain.a+24($pop24)
	i64.store	0($pop8), $pop6
	i32.const	$push23=, 0
	i32.store	0($1), $pop23
	i64.const	$push9=, 0
	i64.store	8($2), $pop9
	i64.const	$push22=, 0
	i64.store	0($2), $pop22
	i32.const	$1=, 5
.LBB1_1:                                # %for.body3.i
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label3:
	i32.const	$push27=, 1
	i32.add 	$0=, $1, $pop27
	i32.const	$push26=, 2
	i32.shl 	$push10=, $1, $pop26
	i32.add 	$push11=, $2, $pop10
	i32.load	$1=, 0($pop11)
	i32.ne  	$push12=, $1, $0
	br_if   	1, $pop12       # 1: down to label2
# %bb.2:                                # %for.cond1.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push28=, 9
	i32.le_u	$push13=, $1, $pop28
	br_if   	0, $pop13       # 0: up to label3
# %bb.3:                                # %check.exit
	end_loop
	i32.const	$push21=, 0
	i32.const	$push19=, 48
	i32.add 	$push20=, $2, $pop19
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
