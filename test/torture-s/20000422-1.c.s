	.text
	.file	"20000422-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push16=, 0
	i32.load	$0=, num($pop16)
	block   	
	block   	
	i32.const	$push15=, 1
	i32.lt_s	$push0=, $0, $pop15
	br_if   	0, $pop0        # 0: down to label1
# %bb.1:                                # %for.body.lr.ph
	i32.const	$push17=, -1
	i32.add 	$1=, $0, $pop17
	i32.const	$push1=, 2
	i32.shl 	$push2=, $0, $pop1
	i32.const	$push3=, ops-8
	i32.add 	$2=, $pop2, $pop3
	i32.const	$6=, 0
.LBB0_2:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_4 Depth 2
	loop    	                # label2:
	block   	
	i32.le_s	$push4=, $1, $6
	br_if   	0, $pop4        # 0: down to label3
# %bb.3:                                # %for.body3.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	copy_local	$7=, $2
	copy_local	$8=, $1
.LBB0_4:                                # %for.body3
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label4:
	i32.const	$push18=, 4
	i32.add 	$5=, $7, $pop18
	i32.load	$4=, 0($5)
	i32.load	$3=, 0($7)
	block   	
	i32.ge_s	$push5=, $3, $4
	br_if   	0, $pop5        # 0: down to label5
# %bb.5:                                # %if.then
                                        #   in Loop: Header=BB0_4 Depth=2
	i32.store	0($7), $4
	i32.store	0($5), $3
.LBB0_6:                                # %for.inc
                                        #   in Loop: Header=BB0_4 Depth=2
	end_block                       # label5:
	i32.const	$push20=, -4
	i32.add 	$7=, $7, $pop20
	i32.const	$push19=, -1
	i32.add 	$8=, $8, $pop19
	i32.gt_s	$push6=, $8, $6
	br_if   	0, $pop6        # 0: up to label4
.LBB0_7:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	end_block                       # label3:
	i32.const	$push21=, 1
	i32.add 	$6=, $6, $pop21
	i32.lt_s	$push7=, $6, $0
	br_if   	0, $pop7        # 0: up to label2
# %bb.8:                                # %for.end14
	end_loop
	i32.const	$push22=, 1
	i32.lt_s	$push8=, $0, $pop22
	br_if   	0, $pop8        # 0: down to label1
# %bb.9:                                # %for.body17.preheader
	i32.const	$7=, 0
	i32.const	$8=, 0
.LBB0_10:                               # %for.body17
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label6:
	i32.const	$push24=, ops
	i32.add 	$push11=, $7, $pop24
	i32.load	$push12=, 0($pop11)
	i32.const	$push23=, correct
	i32.add 	$push9=, $7, $pop23
	i32.load	$push10=, 0($pop9)
	i32.ne  	$push13=, $pop12, $pop10
	br_if   	2, $pop13       # 2: down to label0
# %bb.11:                               # %for.cond15
                                        #   in Loop: Header=BB0_10 Depth=1
	i32.const	$push26=, 1
	i32.add 	$8=, $8, $pop26
	i32.const	$push25=, 4
	i32.add 	$7=, $7, $pop25
	i32.lt_s	$push14=, $8, $0
	br_if   	0, $pop14       # 0: up to label6
.LBB0_12:                               # %for.end25
	end_loop
	end_block                       # label1:
	i32.const	$push27=, 0
	call    	exit@FUNCTION, $pop27
	unreachable
.LBB0_13:                               # %if.then21
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	ops                     # @ops
	.type	ops,@object
	.section	.data.ops,"aw",@progbits
	.globl	ops
	.p2align	4
ops:
	.int32	11                      # 0xb
	.int32	12                      # 0xc
	.int32	46                      # 0x2e
	.int32	3                       # 0x3
	.int32	2                       # 0x2
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	2                       # 0x2
	.int32	1                       # 0x1
	.int32	3                       # 0x3
	.int32	2                       # 0x2
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.size	ops, 52

	.hidden	correct                 # @correct
	.type	correct,@object
	.section	.data.correct,"aw",@progbits
	.globl	correct
	.p2align	4
correct:
	.int32	46                      # 0x2e
	.int32	12                      # 0xc
	.int32	11                      # 0xb
	.int32	3                       # 0x3
	.int32	3                       # 0x3
	.int32	3                       # 0x3
	.int32	2                       # 0x2
	.int32	2                       # 0x2
	.int32	2                       # 0x2
	.int32	2                       # 0x2
	.int32	2                       # 0x2
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.size	correct, 52

	.hidden	num                     # @num
	.type	num,@object
	.section	.data.num,"aw",@progbits
	.globl	num
	.p2align	2
num:
	.int32	13                      # 0xd
	.size	num, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
