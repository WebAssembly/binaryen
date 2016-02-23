	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56866.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push90=, __stack_pointer
	i32.load	$push91=, 0($pop90)
	i32.const	$push92=, 7712
	i32.sub 	$30=, $pop91, $pop92
	i32.const	$push93=, __stack_pointer
	i32.store	$discard=, 0($pop93), $30
	i32.const	$1=, 0
	i32.const	$push59=, 0
	i32.const	$push58=, 2048
	i32.const	$3=, 5664
	i32.add 	$3=, $30, $3
	i32.call	$discard=, memset@FUNCTION, $3, $pop59, $pop58
	i32.const	$push57=, 0
	i32.const	$push0=, 1024
	i32.const	$4=, 2592
	i32.add 	$4=, $30, $4
	i32.call	$discard=, memset@FUNCTION, $4, $pop57, $pop0
	i32.const	$push56=, 0
	i32.const	$push1=, 512
	i32.const	$5=, 1056
	i32.add 	$5=, $30, $5
	i32.call	$discard=, memset@FUNCTION, $5, $pop56, $pop1
	i32.const	$push55=, 0
	i32.const	$push2=, 256
	i32.const	$6=, 288
	i32.add 	$6=, $30, $6
	i32.call	$discard=, memset@FUNCTION, $6, $pop55, $pop2
	i32.const	$push4=, 19088743
	i32.store	$discard=, 2592($30):p2align=4, $pop4
	i32.const	$push5=, 17767
	i32.store16	$discard=, 1056($30):p2align=4, $pop5
	i32.const	$push6=, 115
	i32.store8	$discard=, 288($30):p2align=4, $pop6
	i64.const	$push3=, 81985529216486895
	i64.store	$discard=, 5664($30):p2align=4, $pop3
	i32.const	$7=, 5664
	i32.add 	$7=, $30, $7
	i32.store	$discard=, 28($30), $7
	i32.const	$8=, 2592
	i32.add 	$8=, $30, $8
	i32.store	$discard=, 24($30), $8
	i32.const	$9=, 1056
	i32.add 	$9=, $30, $9
	i32.store	$discard=, 20($30), $9
	i32.const	$10=, 288
	i32.add 	$10=, $30, $10
	i32.store	$discard=, 16($30), $10
	i32.const	$11=, 28
	i32.add 	$11=, $30, $11
	i32.const	$12=, 24
	i32.add 	$12=, $30, $12
	i32.const	$13=, 20
	i32.add 	$13=, $30, $13
	i32.const	$14=, 16
	i32.add 	$14=, $30, $14
	#APP
	#NO_APP
	i32.const	$0=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$15=, 3616
	i32.add 	$15=, $30, $15
	i32.add 	$push11=, $15, $0
	i32.const	$16=, 5664
	i32.add 	$16=, $30, $16
	i32.add 	$push7=, $16, $0
	i64.load	$push65=, 0($pop7)
	tee_local	$push64=, $2=, $pop65
	i64.const	$push63=, 8
	i64.shr_u	$push8=, $pop64, $pop63
	i64.const	$push62=, 56
	i64.shl 	$push9=, $2, $pop62
	i64.or  	$push10=, $pop8, $pop9
	i64.store	$discard=, 0($pop11), $pop10
	i32.const	$push61=, 8
	i32.add 	$0=, $0, $pop61
	i32.const	$push60=, 2048
	i32.ne  	$push12=, $0, $pop60
	br_if   	0, $pop12       # 0: up to label0
.LBB0_2:                                # %for.body16
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label1:
	loop                            # label2:
	i32.const	$17=, 1568
	i32.add 	$17=, $30, $17
	i32.add 	$push17=, $17, $1
	i32.const	$18=, 2592
	i32.add 	$18=, $30, $18
	i32.add 	$push13=, $18, $1
	i32.load	$push71=, 0($pop13)
	tee_local	$push70=, $0=, $pop71
	i32.const	$push69=, 8
	i32.shr_u	$push14=, $pop70, $pop69
	i32.const	$push68=, 24
	i32.shl 	$push15=, $0, $pop68
	i32.or  	$push16=, $pop14, $pop15
	i32.store	$discard=, 0($pop17), $pop16
	i32.const	$push67=, 4
	i32.add 	$1=, $1, $pop67
	i32.const	$push66=, 1024
	i32.ne  	$push18=, $1, $pop66
	br_if   	0, $pop18       # 0: up to label2
# BB#3:
	end_loop                        # label3:
	i32.const	$1=, 0
.LBB0_4:                                # %for.body28
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$19=, 544
	i32.add 	$19=, $30, $19
	i32.add 	$push23=, $19, $1
	i32.const	$20=, 1056
	i32.add 	$20=, $30, $20
	i32.add 	$push19=, $20, $1
	i32.load16_u	$push77=, 0($pop19)
	tee_local	$push76=, $0=, $pop77
	i32.const	$push75=, 9
	i32.shr_u	$push20=, $pop76, $pop75
	i32.const	$push74=, 7
	i32.shl 	$push21=, $0, $pop74
	i32.or  	$push22=, $pop20, $pop21
	i32.store16	$discard=, 0($pop23), $pop22
	i32.const	$push73=, 2
	i32.add 	$1=, $1, $pop73
	i32.const	$push72=, 512
	i32.ne  	$push24=, $1, $pop72
	br_if   	0, $pop24       # 0: up to label4
# BB#5:
	end_loop                        # label5:
	i32.const	$1=, 0
.LBB0_6:                                # %for.body43
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.const	$21=, 32
	i32.add 	$21=, $30, $21
	i32.add 	$push29=, $21, $1
	i32.const	$22=, 288
	i32.add 	$22=, $30, $22
	i32.add 	$push25=, $22, $1
	i32.load8_u	$push83=, 0($pop25)
	tee_local	$push82=, $0=, $pop83
	i32.const	$push81=, 5
	i32.shr_u	$push26=, $pop82, $pop81
	i32.const	$push80=, 3
	i32.shl 	$push27=, $0, $pop80
	i32.or  	$push28=, $pop26, $pop27
	i32.store8	$discard=, 0($pop29), $pop28
	i32.const	$push79=, 1
	i32.add 	$1=, $1, $pop79
	i32.const	$push78=, 256
	i32.ne  	$push30=, $1, $pop78
	br_if   	0, $pop30       # 0: up to label6
# BB#7:                                 # %for.end55
	end_loop                        # label7:
	i32.const	$23=, 3616
	i32.add 	$23=, $30, $23
	i32.store	$discard=, 12($30), $23
	i32.const	$24=, 1568
	i32.add 	$24=, $30, $24
	i32.store	$discard=, 8($30), $24
	i32.const	$25=, 544
	i32.add 	$25=, $30, $25
	i32.store	$discard=, 4($30), $25
	i32.const	$26=, 32
	i32.add 	$26=, $30, $26
	i32.store	$discard=, 0($30), $26
	i32.const	$27=, 12
	i32.add 	$27=, $30, $27
	i32.const	$28=, 8
	i32.add 	$28=, $30, $28
	i32.const	$29=, 4
	i32.add 	$29=, $30, $29
	#APP
	#NO_APP
	block
	i64.load	$push31=, 3616($30):p2align=4
	i64.const	$push32=, -1224658842671273011
	i64.ne  	$push33=, $pop31, $pop32
	br_if   	0, $pop33       # 0: down to label8
# BB#8:                                 # %lor.lhs.false
	i64.load	$push34=, 3624($30)
	i64.const	$push35=, 0
	i64.ne  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label8
# BB#9:                                 # %if.end
	i64.load	$push85=, 1568($30):p2align=4
	tee_local	$push84=, $2=, $pop85
	i32.wrap/i64	$push37=, $pop84
	i32.const	$push38=, 1728127813
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label8
# BB#10:                                # %if.end
	i64.const	$push40=, 4294967296
	i64.ge_u	$push41=, $2, $pop40
	br_if   	0, $pop41       # 0: down to label8
# BB#11:                                # %if.end71
	i32.load	$push87=, 544($30):p2align=4
	tee_local	$push86=, $1=, $pop87
	i32.const	$push42=, 65535
	i32.and 	$push43=, $pop86, $pop42
	i32.const	$push44=, 45986
	i32.ne  	$push45=, $pop43, $pop44
	br_if   	0, $pop45       # 0: down to label8
# BB#12:                                # %if.end71
	i32.const	$push46=, 65536
	i32.ge_u	$push47=, $1, $pop46
	br_if   	0, $pop47       # 0: down to label8
# BB#13:                                # %if.end81
	i32.load16_u	$push89=, 32($30):p2align=4
	tee_local	$push88=, $1=, $pop89
	i32.const	$push48=, 255
	i32.and 	$push49=, $pop88, $pop48
	i32.const	$push50=, 155
	i32.ne  	$push51=, $pop49, $pop50
	br_if   	0, $pop51       # 0: down to label8
# BB#14:                                # %if.end81
	i32.const	$push52=, 256
	i32.ge_u	$push53=, $1, $pop52
	br_if   	0, $pop53       # 0: down to label8
# BB#15:                                # %if.end91
	i32.const	$push54=, 0
	i32.const	$push94=, 7712
	i32.add 	$30=, $30, $pop94
	i32.const	$push95=, __stack_pointer
	i32.store	$discard=, 0($pop95), $30
	return  	$pop54
.LBB0_16:                               # %if.then90
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
