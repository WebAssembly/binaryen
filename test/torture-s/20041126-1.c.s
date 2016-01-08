	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041126-1.c"
	.section	.text.check,"ax",@progbits
	.hidden	check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block   	.LBB0_9
	i32.load	$push0=, 0($0)
	br_if   	$pop0, .LBB0_9
# BB#1:                                 # %for.inc
	i32.load	$push1=, 4($0)
	br_if   	$pop1, .LBB0_9
# BB#2:                                 # %for.inc.1
	i32.load	$push2=, 8($0)
	br_if   	$pop2, .LBB0_9
# BB#3:                                 # %for.inc.2
	i32.load	$push3=, 12($0)
	br_if   	$pop3, .LBB0_9
# BB#4:                                 # %for.inc.3
	i32.const	$3=, 5
	i32.load	$push4=, 16($0)
	br_if   	$pop4, .LBB0_9
.LBB0_5:                                # %for.cond1
                                        # =>This Inner Loop Header: Depth=1
	block   	.LBB0_8
	loop    	.LBB0_7
	i32.const	$push5=, 9
	i32.gt_s	$push6=, $3, $pop5
	br_if   	$pop6, .LBB0_8
# BB#6:                                 # %for.body3
                                        #   in Loop: Header=BB0_5 Depth=1
	i32.const	$push7=, 2
	i32.shl 	$push8=, $3, $pop7
	i32.add 	$push9=, $0, $pop8
	i32.load	$1=, 0($pop9)
	i32.const	$push10=, 1
	i32.add 	$2=, $3, $pop10
	copy_local	$3=, $1
	i32.eq  	$push11=, $1, $2
	br_if   	$pop11, .LBB0_5
.LBB0_7:                                # %if.then6
	call    	abort
	unreachable
.LBB0_8:                                # %for.end10
	return
.LBB0_9:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	check, .Lfunc_end0-check

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %for.cond1.i.preheader
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 48
	i32.sub 	$14=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$14=, 0($5), $14
	i32.const	$3=, 0
	i32.const	$push1=, 32
	i32.const	$7=, 0
	i32.add 	$7=, $14, $7
	i32.add 	$push2=, $7, $pop1
	i64.load	$push0=, .Lmain.a+32($3)
	i64.store	$discard=, 0($pop2), $pop0
	i32.const	$push4=, 24
	i32.const	$8=, 0
	i32.add 	$8=, $14, $8
	i32.add 	$push5=, $8, $pop4
	i64.load	$push3=, .Lmain.a+24($3)
	i64.store	$discard=, 0($pop5), $pop3
	i32.const	$push7=, 16
	i32.const	$9=, 0
	i32.add 	$9=, $14, $9
	i32.add 	$push8=, $9, $pop7
	i64.load	$push6=, .Lmain.a+16($3)
	i64.store	$discard=, 0($pop8), $pop6
	i32.const	$push10=, 8
	i32.const	$10=, 0
	i32.add 	$10=, $14, $10
	i32.or  	$0=, $10, $pop10
	i64.load	$push9=, .Lmain.a+8($3)
	i64.store	$discard=, 0($0), $pop9
	i32.store	$2=, 16($14), $3
	i32.const	$push12=, 12
	i32.const	$11=, 0
	i32.add 	$11=, $14, $11
	i32.or  	$push13=, $11, $pop12
	i32.store	$push14=, 0($pop13), $2
	i32.store	$0=, 0($0), $pop14
	i64.load	$push11=, .Lmain.a($3)
	i64.store	$discard=, 0($14), $pop11
	i32.const	$push15=, 4
	i32.const	$12=, 0
	i32.add 	$12=, $14, $12
	i32.or  	$push16=, $12, $pop15
	i32.store	$push17=, 0($pop16), $0
	i32.store	$1=, 0($14), $pop17
	i32.const	$3=, 5
.LBB1_1:                                # %for.cond1.i
                                        # =>This Inner Loop Header: Depth=1
	block   	.LBB1_4
	loop    	.LBB1_3
	i32.const	$push18=, 9
	i32.gt_s	$push19=, $3, $pop18
	br_if   	$pop19, .LBB1_4
# BB#2:                                 # %for.body3.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push20=, 2
	i32.shl 	$push21=, $3, $pop20
	i32.const	$13=, 0
	i32.add 	$13=, $14, $13
	i32.add 	$push22=, $13, $pop21
	i32.load	$0=, 0($pop22)
	i32.const	$push23=, 1
	i32.add 	$2=, $3, $pop23
	copy_local	$3=, $0
	i32.eq  	$push24=, $0, $2
	br_if   	$pop24, .LBB1_1
.LBB1_3:                                # %if.then6.i
	call    	abort
	unreachable
.LBB1_4:                                # %check.exit
	i32.const	$6=, 48
	i32.add 	$14=, $14, $6
	i32.const	$6=, __stack_pointer
	i32.store	$14=, 0($6), $14
	return  	$1
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.a,@object        # @main.a
	.section	.rodata..Lmain.a,"a",@progbits
	.align	4
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


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
