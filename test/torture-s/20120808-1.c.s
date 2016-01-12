	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120808-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 32
	i32.sub 	$15=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$15=, 0($10), $15
	i32.const	$push0=, 24
	i32.const	$11=, 0
	i32.add 	$11=, $15, $11
	i32.add 	$push1=, $11, $pop0
	i64.const	$push2=, 0
	i64.store	$5=, 0($pop1), $pop2
	i32.const	$3=, 16
	i32.const	$12=, 0
	i32.add 	$12=, $15, $12
	i32.add 	$push3=, $12, $3
	i64.store	$discard=, 0($pop3), $5
	i32.const	$push4=, 8
	i32.const	$13=, 0
	i32.add 	$13=, $15, $13
	i32.or  	$push5=, $13, $pop4
	i64.store	$push6=, 0($pop5), $5
	i64.store	$discard=, 0($15), $pop6
	i32.const	$7=, 0
	i32.load	$1=, i($7)
	i32.const	$4=, 1
	i32.const	$push7=, d
	i32.add 	$push8=, $1, $pop7
	i32.add 	$0=, $pop8, $4
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_8
	i32.add 	$1=, $0, $7
	i32.load8_u	$2=, 0($1)
	block   	.LBB0_7
	block   	.LBB0_6
	i32.const	$push9=, 25
	i32.eq  	$push10=, $7, $pop9
	br_if   	$pop10, .LBB0_6
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	block   	.LBB0_5
	i32.const	$push11=, 2
	i32.eq  	$push12=, $7, $pop11
	br_if   	$pop12, .LBB0_5
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$8=, 255
	i32.ne  	$push13=, $7, $4
	br_if   	$pop13, .LBB0_7
# BB#4:                                 # %sw.bb
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$8=, 253
	br      	.LBB0_7
.LBB0_5:                                # %sw.bb1
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$8=, 251
	br      	.LBB0_7
.LBB0_6:                                # %sw.bb3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$8=, 254
.LBB0_7:                                # %sw.epilog
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$14=, 0
	i32.add 	$14=, $15, $14
	i32.add 	$push15=, $14, $7
	i32.or  	$push14=, $8, $2
	i32.store8	$discard=, 0($pop15), $pop14
	i32.const	$8=, 0
	i32.store	$discard=, cp($8), $1
	i32.add 	$7=, $7, $4
	i32.const	$push16=, 30
	i32.ne  	$push17=, $7, $pop16
	br_if   	$pop17, .LBB0_1
.LBB0_8:                                # %for.end
	i64.load	$5=, 0($15)
	block   	.LBB0_15
	i64.const	$push22=, 65535
	i64.and 	$push23=, $5, $pop22
	i64.const	$push24=, 65023
	i64.ne  	$push25=, $pop23, $pop24
	br_if   	$pop25, .LBB0_15
# BB#9:                                 # %for.end
	i32.wrap/i64	$push21=, $5
	i32.shr_u	$push18=, $pop21, $3
	i32.const	$push26=, 255
	i32.and 	$push27=, $pop18, $pop26
	i32.const	$push28=, 251
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	$pop29, .LBB0_15
# BB#10:                                # %for.end
	i32.load	$push19=, 0($15)
	i32.const	$push30=, -16777216
	i32.lt_u	$push31=, $pop19, $pop30
	br_if   	$pop31, .LBB0_15
# BB#11:                                # %for.end
	i64.const	$6=, 1095216660480
	i64.and 	$push20=, $5, $6
	i64.ne  	$push32=, $pop20, $6
	br_if   	$pop32, .LBB0_15
# BB#12:                                # %lor.lhs.false29
	i32.load8_u	$push33=, 25($15)
	i32.const	$push34=, 254
	i32.ne  	$push35=, $pop33, $pop34
	br_if   	$pop35, .LBB0_15
# BB#13:                                # %lor.lhs.false34
	i32.load	$push36=, cp($8)
	i32.const	$push37=, d+30
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	$pop38, .LBB0_15
# BB#14:                                # %if.end
	call    	exit@FUNCTION, $8
	unreachable
.LBB0_15:                               # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.align	4
d:
	.skip	32
	.size	d, 32

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	cp                      # @cp
	.type	cp,@object
	.section	.bss.cp,"aw",@nobits
	.globl	cp
	.align	2
cp:
	.int32	0
	.size	cp, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
