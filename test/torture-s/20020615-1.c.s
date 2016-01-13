	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020615-1.c"
	.section	.text.line_hints,"ax",@progbits
	.hidden	line_hints
	.globl	line_hints
	.type	line_hints,@function
line_hints:                             # @line_hints
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.load	$push2=, 0($2)
	i32.load	$push3=, 0($1)
	i32.sub 	$6=, $pop2, $pop3
	i32.load	$push4=, 4($2)
	i32.load	$push5=, 4($1)
	i32.sub 	$1=, $pop4, $pop5
	i32.load	$3=, 4($0)
	i32.load	$4=, 8($0)
	i32.load	$5=, 0($0)
	i32.const	$0=, 0
	i32.sub 	$push6=, $0, $6
	i32.select	$2=, $3, $pop6, $6
	i32.sub 	$push7=, $0, $1
	i32.select	$6=, $4, $pop7, $1
	i32.select	$1=, $5, $2, $6
	i32.const	$7=, 31
	i32.shr_s	$8=, $1, $7
	i32.add 	$push8=, $1, $8
	i32.xor 	$8=, $pop8, $8
	i32.select	$2=, $5, $6, $2
	i32.shr_s	$6=, $2, $7
	i32.add 	$push9=, $2, $6
	i32.xor 	$7=, $pop9, $6
	i32.const	$6=, 4
	block
	block
	i32.const	$push25=, 0
	i32.eq  	$push26=, $1, $pop25
	br_if   	$pop26, 0       # 0: down to label1
# BB#1:                                 # %entry
	i32.shr_s	$push1=, $8, $6
	i32.gt_s	$push10=, $7, $pop1
	br_if   	$pop10, 0       # 0: down to label1
# BB#2:                                 # %if.then21
	i32.gt_s	$push12=, $1, $0
	i32.const	$push14=, 2
	i32.const	$push13=, 1
	i32.select	$0=, $pop12, $pop14, $pop13
	i32.select	$push11=, $5, $4, $3
	i32.const	$push15=, 3
	i32.xor 	$push16=, $0, $pop15
	i32.select	$0=, $pop11, $pop16, $0
	br      	1               # 1: down to label0
.LBB0_3:                                # %if.else
	end_block                       # label1:
	i32.const	$push27=, 0
	i32.eq  	$push28=, $2, $pop27
	br_if   	$pop28, 0       # 0: down to label0
# BB#4:                                 # %if.else
	i32.shr_s	$push17=, $7, $6
	i32.gt_s	$push18=, $8, $pop17
	br_if   	$pop18, 0       # 0: down to label0
# BB#5:                                 # %if.then31
	i32.const	$push19=, 29
	i32.shr_u	$push20=, $2, $pop19
	i32.and 	$push21=, $pop20, $6
	i32.add 	$0=, $pop21, $6
	i32.select	$push0=, $5, $3, $4
	i32.const	$push22=, 12
	i32.xor 	$push23=, $0, $pop22
	i32.select	$push24=, $pop0, $pop23, $0
	return  	$pop24
.LBB0_6:                                # %if.end40
	end_block                       # label0:
	return  	$0
.Lfunc_end0:
	.size	line_hints, .Lfunc_end0-line_hints

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i64, i64, i64, i32, i32, i32, i32, i32, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 0
	i64.load	$7=, main.gsf+8($6)
	i64.load	$8=, main.gsf($6)
	i32.wrap/i64	$push4=, $7
	i32.wrap/i64	$push5=, $8
	i32.sub 	$3=, $pop4, $pop5
	i64.const	$9=, 32
	i32.load	$0=, main.fh+4($6)
	i64.shr_u	$push6=, $7, $9
	i32.wrap/i64	$push7=, $pop6
	i64.shr_u	$push8=, $8, $9
	i32.wrap/i64	$push9=, $pop8
	i32.sub 	$10=, $pop7, $pop9
	i64.load	$7=, main.fh+8($6)
	i32.sub 	$push10=, $6, $3
	i32.select	$11=, $0, $pop10, $3
	i32.load	$2=, main.fh($6)
	i32.wrap/i64	$1=, $7
	i32.sub 	$push11=, $6, $10
	i32.select	$12=, $1, $pop11, $10
	i32.select	$3=, $2, $11, $12
	block
	i32.const	$push53=, 0
	i32.eq  	$push54=, $3, $pop53
	br_if   	$pop54, 0       # 0: down to label2
# BB#1:                                 # %entry
	i32.const	$10=, 31
	i32.shr_s	$13=, $3, $10
	i32.select	$11=, $2, $12, $11
	i32.shr_s	$12=, $11, $10
	i32.const	$14=, 4
	i32.add 	$push14=, $11, $12
	i32.xor 	$push2=, $pop14, $12
	i32.add 	$push12=, $3, $13
	i32.xor 	$push13=, $pop12, $13
	i32.shr_s	$push3=, $pop13, $14
	i32.gt_s	$push15=, $pop2, $pop3
	br_if   	$pop15, 0       # 0: down to label2
# BB#2:                                 # %line_hints.exit
	i32.const	$11=, 1
	i32.gt_s	$push17=, $3, $6
	i32.const	$push18=, 2
	i32.select	$3=, $pop17, $pop18, $11
	i32.select	$push16=, $2, $1, $0
	i32.const	$push19=, 3
	i32.xor 	$push20=, $3, $pop19
	i32.select	$push21=, $pop16, $pop20, $3
	i32.ne  	$push22=, $pop21, $11
	br_if   	$pop22, 0       # 0: down to label2
# BB#3:                                 # %lor.lhs.false
	i64.load	$8=, main.gsf+24($6)
	i64.load	$15=, main.gsf+16($6)
	i32.wrap/i64	$push24=, $8
	i32.wrap/i64	$push25=, $15
	i32.sub 	$12=, $pop24, $pop25
	i64.shr_u	$push26=, $8, $9
	i32.wrap/i64	$push27=, $pop26
	i64.shr_u	$push28=, $15, $9
	i32.wrap/i64	$push29=, $pop28
	i32.sub 	$0=, $pop27, $pop29
	i32.load	$16=, main.fh+16($6)
	i64.const	$push30=, 4294967296
	i64.lt_u	$11=, $7, $pop30
	i32.load	$17=, main.fh+20($6)
	i32.sub 	$4=, $6, $12
	i32.select	$2=, $16, $4, $12
	i32.sub 	$5=, $6, $0
	i32.select	$1=, $17, $5, $0
	i32.select	$3=, $11, $1, $2
	i32.shr_s	$13=, $3, $10
	i32.add 	$push31=, $3, $13
	i32.xor 	$13=, $pop31, $13
	i32.select	$2=, $11, $2, $1
	i32.shr_s	$1=, $2, $10
	block
	i32.add 	$push32=, $2, $1
	i32.xor 	$1=, $pop32, $1
	i32.const	$push55=, 0
	i32.eq  	$push56=, $3, $pop55
	br_if   	$pop56, 0       # 0: down to label3
# BB#4:                                 # %lor.lhs.false
	i32.shr_s	$push23=, $13, $14
	i32.le_s	$push33=, $1, $pop23
	br_if   	$pop33, 1       # 1: down to label2
.LBB1_5:                                # %if.else.i82
	end_block                       # label3:
	i32.const	$push57=, 0
	i32.eq  	$push58=, $2, $pop57
	br_if   	$pop58, 0       # 0: down to label2
# BB#6:                                 # %if.else.i82
	i32.shr_s	$push34=, $1, $14
	i32.gt_s	$push35=, $13, $pop34
	br_if   	$pop35, 0       # 0: down to label2
# BB#7:                                 # %line_hints.exit89
	i32.const	$1=, 29
	i32.shr_u	$push36=, $2, $1
	i32.and 	$push37=, $pop36, $14
	i32.add 	$3=, $pop37, $14
	i32.const	$2=, 12
	i32.select	$push0=, $11, $17, $16
	i32.xor 	$push38=, $3, $2
	i32.select	$push39=, $pop0, $pop38, $3
	i32.const	$push40=, 8
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	$pop41, 0       # 0: down to label2
# BB#8:                                 # %lor.lhs.false3
	i32.load	$16=, main.fh+28($6)
	i32.load	$17=, main.fh+32($6)
	i32.load	$13=, main.fh+24($6)
	i32.select	$11=, $16, $4, $12
	i32.select	$12=, $17, $5, $0
	i32.select	$3=, $13, $11, $12
	i32.shr_s	$0=, $3, $10
	i32.add 	$push43=, $3, $0
	i32.xor 	$0=, $pop43, $0
	i32.select	$11=, $13, $12, $11
	i32.shr_s	$10=, $11, $10
	block
	i32.add 	$push44=, $11, $10
	i32.xor 	$10=, $pop44, $10
	i32.const	$push59=, 0
	i32.eq  	$push60=, $3, $pop59
	br_if   	$pop60, 0       # 0: down to label4
# BB#9:                                 # %lor.lhs.false3
	i32.shr_s	$push42=, $0, $14
	i32.le_s	$push45=, $10, $pop42
	br_if   	$pop45, 1       # 1: down to label2
.LBB1_10:                               # %if.else.i40
	end_block                       # label4:
	i32.const	$push61=, 0
	i32.eq  	$push62=, $11, $pop61
	br_if   	$pop62, 0       # 0: down to label2
# BB#11:                                # %if.else.i40
	i32.shr_s	$push46=, $10, $14
	i32.gt_s	$push47=, $0, $pop46
	br_if   	$pop47, 0       # 0: down to label2
# BB#12:                                # %line_hints.exit47
	i32.shr_u	$push48=, $11, $1
	i32.and 	$push49=, $pop48, $14
	i32.add 	$3=, $pop49, $14
	i32.select	$push1=, $13, $16, $17
	i32.xor 	$push50=, $3, $2
	i32.select	$push51=, $pop1, $pop50, $3
	i32.ne  	$push52=, $pop51, $14
	br_if   	$pop52, 0       # 0: down to label2
# BB#13:                                # %if.end
	call    	exit@FUNCTION, $6
	unreachable
.LBB1_14:                               # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	main.fh,@object         # @main.fh
	.section	.data.main.fh,"aw",@progbits
	.align	4
main.fh:
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.int32	0                       # 0x0
	.int32	0                       # 0x0
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.skip	12
	.size	main.fh, 36

	.type	main.gsf,@object        # @main.gsf
	.section	.data.main.gsf,"aw",@progbits
	.align	4
main.gsf:
	.int32	196608                  # 0x30000
	.int32	80216                   # 0x13958
	.int32	196608                  # 0x30000
	.int32	98697                   # 0x18189
	.int32	80216                   # 0x13958
	.int32	196608                  # 0x30000
	.int32	98697                   # 0x18189
	.int32	196608                  # 0x30000
	.size	main.gsf, 32


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
