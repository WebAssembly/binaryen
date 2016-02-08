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
	i32.const	$push21=, 0
	i32.load	$push0=, num($pop21)
	tee_local	$push20=, $5=, $pop0
	i32.const	$push19=, 1
	i32.lt_s	$push3=, $pop20, $pop19
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %for.cond1.preheader.preheader
	i32.const	$push4=, 2
	i32.shl 	$push5=, $5, $pop4
	i32.const	$push6=, ops-8
	i32.add 	$1=, $pop5, $pop6
	i32.const	$push22=, -1
	i32.add 	$0=, $5, $pop22
	i32.const	$2=, 0
.LBB0_2:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	loop                            # label1:
	copy_local	$3=, $1
	copy_local	$4=, $0
	block
	i32.le_s	$push7=, $0, $2
	br_if   	0, $pop7        # 0: down to label3
.LBB0_3:                                # %for.body3
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label4:
	block
	i32.load	$push1=, 0($3)
	tee_local	$push27=, $8=, $pop1
	i32.const	$push26=, 4
	i32.add 	$push8=, $3, $pop26
	tee_local	$push25=, $7=, $pop8
	i32.load	$push2=, 0($pop25)
	tee_local	$push24=, $6=, $pop2
	i32.ge_s	$push9=, $pop27, $pop24
	br_if   	0, $pop9        # 0: down to label6
# BB#4:                                 # %if.then
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$discard=, 0($7), $8
	i32.store	$discard=, 0($3), $6
.LBB0_5:                                # %for.cond1.backedge
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label6:
	i32.const	$push29=, -1
	i32.add 	$4=, $4, $pop29
	i32.const	$push28=, -4
	i32.add 	$3=, $3, $pop28
	i32.gt_s	$push10=, $4, $2
	br_if   	0, $pop10       # 0: up to label4
.LBB0_6:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label5:
	end_block                       # label3:
	i32.const	$push30=, 1
	i32.add 	$2=, $2, $pop30
	i32.lt_s	$push11=, $2, $5
	br_if   	0, $pop11       # 0: up to label1
# BB#7:                                 # %for.cond15.preheader
	end_loop                        # label2:
	i32.const	$3=, 0
	i32.const	$4=, 0
	i32.const	$push23=, 0
	i32.le_s	$push12=, $5, $pop23
	br_if   	0, $pop12       # 0: down to label0
.LBB0_8:                                # %for.body17
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	i32.load	$push13=, ops($3)
	i32.load	$push14=, correct($3)
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	1, $pop15       # 1: down to label8
# BB#9:                                 # %for.cond15
                                        #   in Loop: Header=BB0_8 Depth=1
	i32.const	$push16=, 1
	i32.add 	$4=, $4, $pop16
	i32.const	$push17=, 4
	i32.add 	$3=, $3, $pop17
	i32.lt_s	$push18=, $4, $5
	br_if   	0, $pop18       # 0: up to label7
	br      	2               # 2: down to label0
.LBB0_10:                               # %if.then21
	end_loop                        # label8:
	call    	abort@FUNCTION
	unreachable
.LBB0_11:                               # %for.end25
	end_block                       # label0:
	i32.const	$push31=, 0
	call    	exit@FUNCTION, $pop31
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
