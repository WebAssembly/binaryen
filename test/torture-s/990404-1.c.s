	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990404-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, -1
                                        # implicit-def: %vreg166
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label1:
	i32.const	$push44=, 0
	i32.load	$0=, x($pop44)
	i32.const	$push43=, 0
	i32.load	$1=, x+4($pop43)
	i32.const	$push42=, 0
	i32.const	$push41=, 0
	i32.gt_s	$push40=, $0, $pop41
	tee_local	$push39=, $12=, $pop40
	i32.select	$0=, $0, $pop42, $pop39
	i32.const	$push38=, 0
	i32.load	$2=, x+8($pop38)
	i32.gt_s	$push37=, $1, $0
	tee_local	$push36=, $11=, $pop37
	i32.select	$0=, $1, $0, $pop36
	i32.const	$push35=, 0
	i32.load	$1=, x+12($pop35)
	i32.gt_s	$push34=, $2, $0
	tee_local	$push33=, $10=, $pop34
	i32.select	$0=, $2, $0, $pop33
	i32.const	$push32=, 0
	i32.load	$2=, x+16($pop32)
	i32.gt_s	$push31=, $1, $0
	tee_local	$push30=, $9=, $pop31
	i32.select	$0=, $1, $0, $pop30
	i32.const	$push29=, 0
	i32.load	$1=, x+20($pop29)
	i32.gt_s	$push28=, $2, $0
	tee_local	$push27=, $8=, $pop28
	i32.select	$0=, $2, $0, $pop27
	i32.const	$push26=, 0
	i32.load	$2=, x+24($pop26)
	i32.gt_s	$push25=, $1, $0
	tee_local	$push24=, $7=, $pop25
	i32.select	$0=, $1, $0, $pop24
	i32.const	$push23=, 0
	i32.load	$1=, x+28($pop23)
	i32.gt_s	$push22=, $2, $0
	tee_local	$push21=, $6=, $pop22
	i32.select	$0=, $2, $0, $pop21
	i32.const	$push20=, 0
	i32.load	$2=, x+32($pop20)
	i32.const	$push19=, 0
	i32.load	$3=, x+36($pop19)
	i32.gt_s	$push18=, $1, $0
	tee_local	$push17=, $5=, $pop18
	i32.select	$0=, $1, $0, $pop17
	i32.gt_s	$push16=, $2, $0
	tee_local	$push15=, $1=, $pop16
	i32.select	$0=, $2, $0, $pop15
	i32.gt_s	$push14=, $3, $0
	tee_local	$push13=, $2=, $pop14
	i32.select	$push9=, $3, $0, $pop13
	i32.eqz 	$push61=, $pop9
	br_if   	2, $pop61       # 2: down to label0
# BB#2:                                 # %if.end7
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push60=, 9
	i32.const	$push59=, 8
	i32.const	$push58=, 7
	i32.const	$push57=, 6
	i32.const	$push56=, 5
	i32.const	$push55=, 4
	i32.const	$push54=, 3
	i32.const	$push53=, 2
	i32.const	$push52=, 1
	i32.const	$push51=, 0
	i32.select	$push0=, $pop51, $13, $12
	i32.select	$push1=, $pop52, $pop0, $11
	i32.select	$push2=, $pop53, $pop1, $10
	i32.select	$push3=, $pop54, $pop2, $9
	i32.select	$push4=, $pop55, $pop3, $8
	i32.select	$push5=, $pop56, $pop4, $7
	i32.select	$push6=, $pop57, $pop5, $6
	i32.select	$push7=, $pop58, $pop6, $5
	i32.select	$push8=, $pop59, $pop7, $1
	i32.select	$push50=, $pop60, $pop8, $2
	tee_local	$push49=, $13=, $pop50
	i32.const	$push48=, 2
	i32.shl 	$push10=, $pop49, $pop48
	i32.const	$push47=, 0
	i32.store	$discard=, x($pop10), $pop47
	i32.const	$push46=, 1
	i32.add 	$4=, $4, $pop46
	i32.const	$push45=, 10
	i32.lt_s	$push11=, $4, $pop45
	br_if   	0, $pop11       # 0: up to label1
# BB#3:                                 # %if.then11
	end_loop                        # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %for.end15
	end_block                       # label0:
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.p2align	4
x:
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.int32	5                       # 0x5
	.int32	6                       # 0x6
	.int32	7                       # 0x7
	.int32	8                       # 0x8
	.int32	9                       # 0x9
	.size	x, 40


	.ident	"clang version 3.9.0 "
