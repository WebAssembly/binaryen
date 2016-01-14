	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000422-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 0
	i32.load	$0=, num($5)
	i32.const	$6=, 1
	block
	i32.lt_s	$push0=, $0, $6
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %for.cond1.preheader.preheader
	i32.const	$8=, ops
	i32.const	$push1=, 2
	i32.shl 	$push2=, $0, $pop1
	i32.add 	$push3=, $pop2, $8
	i32.const	$push4=, -8
	i32.add 	$2=, $pop3, $pop4
	i32.const	$7=, -1
	i32.add 	$1=, $0, $7
	copy_local	$10=, $5
.LBB0_2:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	loop                            # label1:
	copy_local	$11=, $2
	copy_local	$12=, $1
	block
	i32.le_s	$push5=, $1, $10
	br_if   	$pop5, 0        # 0: down to label3
.LBB0_3:                                # %for.body3
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label4:
	i32.const	$push6=, 4
	i32.add 	$9=, $11, $pop6
	i32.load	$3=, 0($11)
	i32.load	$4=, 0($9)
	block
	i32.ge_s	$push7=, $3, $4
	br_if   	$pop7, 0        # 0: down to label6
# BB#4:                                 # %if.then
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$discard=, 0($9), $3
	i32.store	$discard=, 0($11), $4
.LBB0_5:                                # %for.cond1.backedge
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label6:
	i32.const	$push8=, -4
	i32.add 	$11=, $11, $pop8
	i32.add 	$12=, $12, $7
	i32.gt_s	$push9=, $12, $10
	br_if   	$pop9, 0        # 0: up to label4
.LBB0_6:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label5:
	end_block                       # label3:
	i32.add 	$10=, $10, $6
	i32.lt_s	$push10=, $10, $0
	br_if   	$pop10, 0       # 0: up to label1
# BB#7:                                 # %for.cond15.preheader
	end_loop                        # label2:
	i32.const	$11=, 0
	copy_local	$12=, $11
	i32.le_s	$push11=, $0, $11
	br_if   	$pop11, 0       # 0: down to label0
.LBB0_8:                                # %for.body17
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	i32.add 	$push12=, $8, $11
	i32.load	$push13=, 0($pop12)
	i32.const	$push14=, correct
	i32.add 	$push15=, $pop14, $11
	i32.load	$push16=, 0($pop15)
	i32.ne  	$push17=, $pop13, $pop16
	br_if   	$pop17, 1       # 1: down to label8
# BB#9:                                 # %for.cond15
                                        #   in Loop: Header=BB0_8 Depth=1
	i32.const	$push18=, 4
	i32.add 	$11=, $11, $pop18
	i32.add 	$12=, $12, $6
	i32.lt_s	$push19=, $12, $0
	br_if   	$pop19, 0       # 0: up to label7
	br      	2               # 2: down to label0
.LBB0_10:                               # %if.then21
	end_loop                        # label8:
	call    	abort@FUNCTION
	unreachable
.LBB0_11:                               # %for.end25
	end_block                       # label0:
	call    	exit@FUNCTION, $5
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	ops                     # @ops
	.type	ops,@object
	.section	.data.ops,"aw",@progbits
	.globl	ops
	.align	4
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
	.align	4
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
	.align	2
num:
	.int32	13                      # 0xd
	.size	num, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
