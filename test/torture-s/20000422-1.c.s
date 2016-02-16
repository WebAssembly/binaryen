	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000422-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	block
	i32.const	$push18=, 0
	i32.load	$push17=, num($pop18)
	tee_local	$push16=, $5=, $pop17
	i32.const	$push15=, 1
	i32.lt_s	$push0=, $pop16, $pop15
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %for.cond1.preheader.preheader
	i32.const	$push1=, 2
	i32.shl 	$push2=, $5, $pop1
	i32.const	$push3=, ops-8
	i32.add 	$1=, $pop2, $pop3
	i32.const	$push19=, -1
	i32.add 	$0=, $5, $pop19
	i32.const	$2=, 0
.LBB0_2:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	loop                            # label2:
	copy_local	$3=, $1
	copy_local	$4=, $0
	block
	i32.le_s	$push4=, $0, $2
	br_if   	0, $pop4        # 0: down to label4
.LBB0_3:                                # %for.body3
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label5:
	block
	i32.load	$push27=, 0($3)
	tee_local	$push26=, $8=, $pop27
	i32.const	$push25=, 4
	i32.add 	$push24=, $3, $pop25
	tee_local	$push23=, $7=, $pop24
	i32.load	$push22=, 0($pop23)
	tee_local	$push21=, $6=, $pop22
	i32.ge_s	$push5=, $pop26, $pop21
	br_if   	0, $pop5        # 0: down to label7
# BB#4:                                 # %if.then
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$discard=, 0($7), $8
	i32.store	$discard=, 0($3), $6
.LBB0_5:                                # %for.cond1.backedge
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label7:
	i32.const	$push29=, -1
	i32.add 	$4=, $4, $pop29
	i32.const	$push28=, -4
	i32.add 	$3=, $3, $pop28
	i32.gt_s	$push6=, $4, $2
	br_if   	0, $pop6        # 0: up to label5
.LBB0_6:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label6:
	end_block                       # label4:
	i32.const	$push30=, 1
	i32.add 	$2=, $2, $pop30
	i32.lt_s	$push7=, $2, $5
	br_if   	0, $pop7        # 0: up to label2
# BB#7:                                 # %for.cond15.preheader
	end_loop                        # label3:
	i32.const	$3=, 0
	i32.const	$4=, 0
	i32.const	$push20=, 0
	i32.le_s	$push8=, $5, $pop20
	br_if   	0, $pop8        # 0: down to label1
.LBB0_8:                                # %for.body17
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label8:
	i32.load	$push9=, ops($3)
	i32.load	$push10=, correct($3)
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	3, $pop11       # 3: down to label0
# BB#9:                                 # %for.cond15
                                        #   in Loop: Header=BB0_8 Depth=1
	i32.const	$push12=, 1
	i32.add 	$4=, $4, $pop12
	i32.const	$push13=, 4
	i32.add 	$3=, $3, $pop13
	i32.lt_s	$push14=, $4, $5
	br_if   	0, $pop14       # 0: up to label8
.LBB0_10:                               # %for.end25
	end_loop                        # label9:
	end_block                       # label1:
	i32.const	$push31=, 0
	call    	exit@FUNCTION, $pop31
	unreachable
.LBB0_11:                               # %if.then21
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

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


	.ident	"clang version 3.9.0 "
