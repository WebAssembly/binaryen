	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020201-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64
# BB#0:                                 # %entry
	block
	i32.const	$push5=, 0
	i32.load8_u	$push0=, cx($pop5)
	tee_local	$push47=, $0=, $pop0
	i32.const	$push6=, -6
	i32.add 	$push7=, $pop47, $pop6
	i32.const	$push46=, 255
	i32.and 	$push8=, $pop7, $pop46
	i32.const	$push45=, 6
	i32.lt_u	$push9=, $pop8, $pop45
	br_if   	0, $pop9        # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block
	i32.const	$push49=, 255
	i32.and 	$push10=, $0, $pop49
	i32.const	$push48=, 6
	i32.rem_u	$push11=, $pop10, $pop48
	i32.const	$push12=, 1
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label1
# BB#3:                                 # %if.end10
	block
	i32.const	$push14=, 0
	i32.load16_u	$push1=, sx($pop14)
	tee_local	$push52=, $0=, $pop1
	i32.const	$push15=, -12
	i32.add 	$push16=, $pop52, $pop15
	i32.const	$push51=, 65535
	i32.and 	$push17=, $pop16, $pop51
	i32.const	$push50=, 6
	i32.lt_u	$push18=, $pop17, $pop50
	br_if   	0, $pop18       # 0: down to label2
# BB#4:                                 # %if.then17
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %if.end18
	end_block                       # label2:
	block
	i32.const	$push54=, 65535
	i32.and 	$push19=, $0, $pop54
	i32.const	$push53=, 6
	i32.rem_u	$push20=, $pop19, $pop53
	i32.const	$push21=, 2
	i32.ne  	$push22=, $pop20, $pop21
	br_if   	0, $pop22       # 0: down to label3
# BB#6:                                 # %if.end26
	block
	i32.const	$push23=, 0
	i32.load	$push2=, ix($pop23)
	tee_local	$push56=, $0=, $pop2
	i32.const	$push24=, -18
	i32.add 	$push25=, $pop56, $pop24
	i32.const	$push55=, 6
	i32.lt_u	$push26=, $pop25, $pop55
	br_if   	0, $pop26       # 0: down to label4
# BB#7:                                 # %if.then30
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.end31
	end_block                       # label4:
	block
	i32.const	$push57=, 6
	i32.rem_u	$push27=, $0, $pop57
	i32.const	$push28=, 3
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label5
# BB#9:                                 # %if.end36
	block
	i32.const	$push30=, 0
	i32.load	$push3=, lx($pop30)
	tee_local	$push59=, $0=, $pop3
	i32.const	$push31=, -24
	i32.add 	$push32=, $pop59, $pop31
	i32.const	$push58=, 6
	i32.lt_u	$push33=, $pop32, $pop58
	br_if   	0, $pop33       # 0: down to label6
# BB#10:                                # %if.then40
	call    	abort@FUNCTION
	unreachable
.LBB0_11:                               # %if.end41
	end_block                       # label6:
	block
	i32.const	$push60=, 6
	i32.rem_u	$push34=, $0, $pop60
	i32.const	$push35=, 4
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label7
# BB#12:                                # %if.end46
	block
	i32.const	$push37=, 0
	i64.load	$push4=, Lx($pop37)
	tee_local	$push62=, $1=, $pop4
	i64.const	$push38=, -30
	i64.add 	$push39=, $pop62, $pop38
	i64.const	$push61=, 6
	i64.lt_u	$push40=, $pop39, $pop61
	br_if   	0, $pop40       # 0: down to label8
# BB#13:                                # %if.then50
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %if.end51
	end_block                       # label8:
	block
	i64.const	$push63=, 6
	i64.rem_u	$push41=, $1, $pop63
	i64.const	$push42=, 5
	i64.ne  	$push43=, $pop41, $pop42
	br_if   	0, $pop43       # 0: down to label9
# BB#15:                                # %if.end56
	i32.const	$push44=, 0
	call    	exit@FUNCTION, $pop44
	unreachable
.LBB0_16:                               # %if.then55
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB0_17:                               # %if.then45
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %if.then35
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_19:                               # %if.then25
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_20:                               # %if.then9
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	cx                      # @cx
	.type	cx,@object
	.section	.data.cx,"aw",@progbits
	.globl	cx
cx:
	.int8	7                       # 0x7
	.size	cx, 1

	.hidden	sx                      # @sx
	.type	sx,@object
	.section	.data.sx,"aw",@progbits
	.globl	sx
	.p2align	1
sx:
	.int16	14                      # 0xe
	.size	sx, 2

	.hidden	ix                      # @ix
	.type	ix,@object
	.section	.data.ix,"aw",@progbits
	.globl	ix
	.p2align	2
ix:
	.int32	21                      # 0x15
	.size	ix, 4

	.hidden	lx                      # @lx
	.type	lx,@object
	.section	.data.lx,"aw",@progbits
	.globl	lx
	.p2align	2
lx:
	.int32	28                      # 0x1c
	.size	lx, 4

	.hidden	Lx                      # @Lx
	.type	Lx,@object
	.section	.data.Lx,"aw",@progbits
	.globl	Lx
	.p2align	3
Lx:
	.int64	35                      # 0x23
	.size	Lx, 8


	.ident	"clang version 3.9.0 "
