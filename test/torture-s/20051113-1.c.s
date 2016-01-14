	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20051113-1.c"
	.section	.text.Sum,"ax",@progbits
	.hidden	Sum
	.globl	Sum
	.type	Sum,@function
Sum:                                    # @Sum
	.param  	i32
	.result 	i64
	.local  	i32, i32, i32, i32, i32, i64, i32, i32, i32, i64, i32, i32, i32, i64, i32, i64
# BB#0:                                 # %entry
	i32.const	$2=, 3
	i32.const	$3=, 2
	i32.const	$15=, 8
	i32.const	$4=, 1
	i32.add 	$push0=, $0, $2
	i32.load8_u	$push1=, 0($pop0)
	i32.shl 	$push2=, $pop1, $15
	i32.add 	$push3=, $0, $3
	i32.load8_u	$push4=, 0($pop3)
	i32.or  	$push5=, $pop2, $pop4
	i32.const	$push6=, 16
	i32.shl 	$push7=, $pop5, $pop6
	i32.add 	$push8=, $0, $4
	i32.load8_u	$push9=, 0($pop8)
	i32.shl 	$push10=, $pop9, $15
	i32.load8_u	$push11=, 0($0)
	i32.or  	$push12=, $pop10, $pop11
	i32.or  	$1=, $pop7, $pop12
	i64.const	$16=, 0
	block
	i32.lt_s	$push13=, $1, $4
	br_if   	$pop13, 0       # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push14=, 10
	i32.add 	$0=, $0, $pop14
	i64.const	$16=, 0
	i32.const	$15=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push15=, 5
	i32.add 	$5=, $0, $pop15
	i32.const	$push18=, 4
	i32.add 	$7=, $0, $pop18
	i32.const	$push21=, 7
	i32.add 	$8=, $0, $pop21
	i32.const	$push24=, 6
	i32.add 	$9=, $0, $pop24
	i32.add 	$11=, $0, $2
	i32.add 	$12=, $0, $3
	i32.add 	$13=, $0, $4
	i64.load8_u	$14=, 0($0)
	i32.const	$push41=, 30
	i32.add 	$0=, $0, $pop41
	i64.const	$6=, 8
	i64.const	$10=, 16
	i64.load8_u	$push22=, 0($8)
	i64.shl 	$push23=, $pop22, $6
	i64.load8_u	$push25=, 0($9)
	i64.or  	$push26=, $pop23, $pop25
	i64.shl 	$push27=, $pop26, $10
	i64.load8_u	$push16=, 0($5)
	i64.shl 	$push17=, $pop16, $6
	i64.load8_u	$push19=, 0($7)
	i64.or  	$push20=, $pop17, $pop19
	i64.or  	$push28=, $pop27, $pop20
	i64.const	$push29=, 32
	i64.shl 	$push30=, $pop28, $pop29
	i64.load8_u	$push31=, 0($11)
	i64.shl 	$push32=, $pop31, $6
	i64.load8_u	$push33=, 0($12)
	i64.or  	$push34=, $pop32, $pop33
	i64.shl 	$push35=, $pop34, $10
	i64.load8_u	$push36=, 0($13)
	i64.shl 	$push37=, $pop36, $6
	i64.or  	$push38=, $pop37, $14
	i64.or  	$push39=, $pop35, $pop38
	i64.or  	$push40=, $pop30, $pop39
	i64.add 	$16=, $pop40, $16
	i32.add 	$15=, $15, $4
	i32.lt_s	$push42=, $15, $1
	br_if   	$pop42, 0       # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	return  	$16
	.endfunc
.Lfunc_end0:
	.size	Sum, .Lfunc_end0-Sum

	.section	.text.Sum2,"ax",@progbits
	.hidden	Sum2
	.globl	Sum2
	.type	Sum2,@function
Sum2:                                   # @Sum2
	.param  	i32
	.result 	i64
	.local  	i32, i32, i32, i32, i32, i64, i32, i32, i32, i64, i32, i32, i32, i64, i32, i64
# BB#0:                                 # %entry
	i32.const	$2=, 3
	i32.const	$3=, 2
	i32.const	$15=, 8
	i32.const	$4=, 1
	i32.add 	$push0=, $0, $2
	i32.load8_u	$push1=, 0($pop0)
	i32.shl 	$push2=, $pop1, $15
	i32.add 	$push3=, $0, $3
	i32.load8_u	$push4=, 0($pop3)
	i32.or  	$push5=, $pop2, $pop4
	i32.const	$push6=, 16
	i32.shl 	$push7=, $pop5, $pop6
	i32.add 	$push8=, $0, $4
	i32.load8_u	$push9=, 0($pop8)
	i32.shl 	$push10=, $pop9, $15
	i32.load8_u	$push11=, 0($0)
	i32.or  	$push12=, $pop10, $pop11
	i32.or  	$1=, $pop7, $pop12
	i64.const	$16=, 0
	block
	i32.lt_s	$push13=, $1, $4
	br_if   	$pop13, 0       # 0: down to label3
# BB#1:                                 # %for.body.preheader
	i32.const	$push14=, 18
	i32.add 	$0=, $0, $pop14
	i64.const	$16=, 0
	i32.const	$15=, 0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push15=, 5
	i32.add 	$5=, $0, $pop15
	i32.const	$push18=, 4
	i32.add 	$7=, $0, $pop18
	i32.const	$push21=, 7
	i32.add 	$8=, $0, $pop21
	i32.const	$push24=, 6
	i32.add 	$9=, $0, $pop24
	i32.add 	$11=, $0, $2
	i32.add 	$12=, $0, $3
	i32.add 	$13=, $0, $4
	i64.load8_u	$14=, 0($0)
	i32.const	$push41=, 30
	i32.add 	$0=, $0, $pop41
	i64.const	$6=, 8
	i64.const	$10=, 16
	i64.load8_u	$push22=, 0($8)
	i64.shl 	$push23=, $pop22, $6
	i64.load8_u	$push25=, 0($9)
	i64.or  	$push26=, $pop23, $pop25
	i64.shl 	$push27=, $pop26, $10
	i64.load8_u	$push16=, 0($5)
	i64.shl 	$push17=, $pop16, $6
	i64.load8_u	$push19=, 0($7)
	i64.or  	$push20=, $pop17, $pop19
	i64.or  	$push28=, $pop27, $pop20
	i64.const	$push29=, 32
	i64.shl 	$push30=, $pop28, $pop29
	i64.load8_u	$push31=, 0($11)
	i64.shl 	$push32=, $pop31, $6
	i64.load8_u	$push33=, 0($12)
	i64.or  	$push34=, $pop32, $pop33
	i64.shl 	$push35=, $pop34, $10
	i64.load8_u	$push36=, 0($13)
	i64.shl 	$push37=, $pop36, $6
	i64.or  	$push38=, $pop37, $14
	i64.or  	$push39=, $pop35, $pop38
	i64.or  	$push40=, $pop30, $pop39
	i64.add 	$16=, $pop40, $16
	i32.add 	$15=, $15, $4
	i32.lt_s	$push42=, $15, $1
	br_if   	$pop42, 0       # 0: up to label4
.LBB1_3:                                # %for.end
	end_loop                        # label5:
	end_block                       # label3:
	return  	$16
	.endfunc
.Lfunc_end1:
	.size	Sum2, .Lfunc_end1-Sum2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$1=, 94
	i32.call	$0=, malloc@FUNCTION, $1
	i32.const	$2=, 0
	call    	memset@FUNCTION, $0, $2, $1
	i32.const	$1=, 3
	i32.add 	$push0=, $0, $1
	i32.store8	$discard=, 0($pop0), $2
	i32.const	$push1=, 2
	i32.add 	$push2=, $0, $pop1
	i32.store8	$discard=, 0($pop2), $2
	i32.const	$push3=, 1
	i32.add 	$push4=, $0, $pop3
	i32.store8	$discard=, 0($pop4), $2
	i32.store8	$discard=, 0($0), $1
	i32.const	$push5=, 17
	i32.add 	$push6=, $0, $pop5
	i64.const	$push7=, 0
	i64.store8	$4=, 0($pop6), $pop7
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i64.store8	$discard=, 0($pop9), $4
	i32.const	$push10=, 15
	i32.add 	$push11=, $0, $pop10
	i64.store8	$discard=, 0($pop11), $4
	i32.const	$push12=, 14
	i32.add 	$push13=, $0, $pop12
	i64.store8	$discard=, 0($pop13), $4
	i32.const	$push14=, 13
	i32.add 	$push15=, $0, $pop14
	i64.store8	$discard=, 0($pop15), $4
	i32.const	$push16=, 12
	i32.add 	$push17=, $0, $pop16
	i64.store8	$discard=, 0($pop17), $4
	i32.const	$push18=, 11
	i32.add 	$push19=, $0, $pop18
	i64.const	$push20=, 2
	i64.store8	$3=, 0($pop19), $pop20
	i32.const	$push23=, 47
	i32.add 	$push24=, $0, $pop23
	i64.store8	$discard=, 0($pop24), $4
	i32.const	$push25=, 46
	i32.add 	$push26=, $0, $pop25
	i64.store8	$discard=, 0($pop26), $4
	i32.const	$push27=, 45
	i32.add 	$push28=, $0, $pop27
	i64.store8	$discard=, 0($pop28), $4
	i32.const	$push29=, 44
	i32.add 	$push30=, $0, $pop29
	i64.store8	$discard=, 0($pop30), $4
	i32.const	$push31=, 43
	i32.add 	$push32=, $0, $pop31
	i64.store8	$discard=, 0($pop32), $4
	i32.const	$push33=, 42
	i32.add 	$push34=, $0, $pop33
	i64.store8	$discard=, 0($pop34), $4
	i32.const	$push40=, 77
	i32.add 	$push41=, $0, $pop40
	i64.store8	$discard=, 0($pop41), $4
	i32.const	$push42=, 76
	i32.add 	$push43=, $0, $pop42
	i64.store8	$discard=, 0($pop43), $4
	i32.const	$push44=, 75
	i32.add 	$push45=, $0, $pop44
	i64.store8	$discard=, 0($pop45), $4
	i32.const	$push55=, 25
	i32.add 	$push56=, $0, $pop55
	i64.store8	$discard=, 0($pop56), $4
	i32.const	$push57=, 24
	i32.add 	$push58=, $0, $pop57
	i64.store8	$discard=, 0($pop58), $4
	i32.const	$push59=, 23
	i32.add 	$push60=, $0, $pop59
	i64.store8	$discard=, 0($pop60), $4
	i32.const	$push61=, 22
	i32.add 	$push62=, $0, $pop61
	i64.store8	$discard=, 0($pop62), $4
	i32.const	$push63=, 21
	i32.add 	$push64=, $0, $pop63
	i64.store8	$discard=, 0($pop64), $4
	i32.const	$push65=, 20
	i32.add 	$push66=, $0, $pop65
	i64.store8	$discard=, 0($pop66), $4
	i32.const	$push67=, 19
	i32.add 	$push68=, $0, $pop67
	i64.store8	$discard=, 0($pop68), $3
	i32.const	$push35=, 41
	i32.add 	$push36=, $0, $pop35
	i64.const	$push37=, 3
	i64.store8	$3=, 0($pop36), $pop37
	i32.const	$push69=, 55
	i32.add 	$push70=, $0, $pop69
	i64.store8	$discard=, 0($pop70), $4
	i32.const	$push71=, 54
	i32.add 	$push72=, $0, $pop71
	i64.store8	$discard=, 0($pop72), $4
	i32.const	$push73=, 53
	i32.add 	$push74=, $0, $pop73
	i64.store8	$discard=, 0($pop74), $4
	i32.const	$push75=, 52
	i32.add 	$push76=, $0, $pop75
	i64.store8	$discard=, 0($pop76), $4
	i32.const	$push77=, 51
	i32.add 	$push78=, $0, $pop77
	i64.store8	$discard=, 0($pop78), $4
	i32.const	$push79=, 50
	i32.add 	$push80=, $0, $pop79
	i64.store8	$discard=, 0($pop80), $4
	i32.const	$push81=, 49
	i32.add 	$push82=, $0, $pop81
	i64.store8	$discard=, 0($pop82), $3
	i32.const	$push46=, 74
	i32.add 	$push47=, $0, $pop46
	i64.const	$push48=, 1
	i64.store8	$3=, 0($pop47), $pop48
	i32.const	$push49=, 73
	i32.add 	$push50=, $0, $pop49
	i64.store8	$discard=, 0($pop50), $3
	i32.const	$push51=, 72
	i32.add 	$push52=, $0, $pop51
	i64.store8	$discard=, 0($pop52), $3
	i32.const	$push53=, 71
	i32.add 	$push54=, $0, $pop53
	i64.store8	$discard=, 0($pop54), $3
	i32.const	$push83=, 85
	i32.add 	$push84=, $0, $pop83
	i64.store8	$discard=, 0($pop84), $4
	i32.const	$push85=, 84
	i32.add 	$push86=, $0, $pop85
	i64.store8	$discard=, 0($pop86), $4
	i32.const	$push87=, 83
	i32.add 	$push88=, $0, $pop87
	i64.store8	$discard=, 0($pop88), $4
	i64.store8	$4=, 70($0), $3
	i32.const	$push89=, 82
	i32.add 	$push90=, $0, $pop89
	i64.store8	$discard=, 0($pop90), $4
	i32.const	$push91=, 81
	i32.add 	$push92=, $0, $pop91
	i64.store8	$discard=, 0($pop92), $4
	i32.const	$push93=, 80
	i32.add 	$push94=, $0, $pop93
	i64.store8	$discard=, 0($pop94), $4
	i32.const	$push95=, 79
	i32.add 	$push96=, $0, $pop95
	i64.store8	$discard=, 0($pop96), $4
	i64.const	$push21=, 43
	i64.store8	$push22=, 10($0), $pop21
	i64.store8	$discard=, 18($0), $pop22
	i64.const	$push38=, 231
	i64.store8	$push39=, 40($0), $pop38
	i64.store8	$discard=, 48($0), $pop39
	i64.store8	$discard=, 78($0), $4
	i64.call	$3=, Sum@FUNCTION, $0
	i64.const	$4=, 4311811859
	block
	i64.ne  	$push97=, $3, $4
	br_if   	$pop97, 0       # 0: down to label6
# BB#1:                                 # %if.end
	block
	i64.call	$push98=, Sum2@FUNCTION, $0
	i64.ne  	$push99=, $pop98, $4
	br_if   	$pop99, 0       # 0: down to label7
# BB#2:                                 # %if.end25
	return  	$2
.LBB2_3:                                # %if.then24
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB2_4:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
