	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56866.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 7712
	i32.sub 	$34=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$34=, 0($4), $34
	i32.const	$0=, 2048
	i32.const	$1=, 0
	i32.const	$6=, 5664
	i32.add 	$6=, $34, $6
	i32.call	$discard=, memset@FUNCTION, $6, $1, $0
	i32.const	$0=, 1024
	i32.const	$7=, 2592
	i32.add 	$7=, $34, $7
	i32.call	$discard=, memset@FUNCTION, $7, $1, $0
	i32.const	$0=, 512
	i32.const	$8=, 1056
	i32.add 	$8=, $34, $8
	i32.call	$discard=, memset@FUNCTION, $8, $1, $0
	i32.const	$0=, 256
	i32.const	$9=, 288
	i32.add 	$9=, $34, $9
	i32.call	$discard=, memset@FUNCTION, $9, $1, $0
	i32.const	$0=, 19088743
	i32.store	$discard=, 2592($34):p2align=4, $0
	i32.const	$0=, 17767
	i32.store16	$discard=, 1056($34):p2align=4, $0
	i32.const	$0=, 115
	i32.store8	$discard=, 288($34):p2align=4, $0
	i64.const	$2=, 81985529216486895
	i64.store	$discard=, 5664($34):p2align=4, $2
	i32.const	$10=, 5664
	i32.add 	$10=, $34, $10
	i32.store	$discard=, 28($34), $10
	i32.const	$11=, 2592
	i32.add 	$11=, $34, $11
	i32.store	$discard=, 24($34), $11
	i32.const	$12=, 1056
	i32.add 	$12=, $34, $12
	i32.store	$discard=, 20($34), $12
	i32.const	$13=, 288
	i32.add 	$13=, $34, $13
	i32.store	$discard=, 16($34), $13
	i32.const	$14=, 28
	i32.add 	$14=, $34, $14
	i32.const	$15=, 24
	i32.add 	$15=, $34, $15
	i32.const	$16=, 20
	i32.add 	$16=, $34, $16
	i32.const	$17=, 16
	i32.add 	$17=, $34, $17
	#APP
	#NO_APP
	i32.const	$0=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$18=, 3616
	i32.add 	$18=, $34, $18
	i32.add 	$push4=, $18, $0
	i32.const	$19=, 5664
	i32.add 	$19=, $34, $19
	i32.add 	$push0=, $19, $0
	i64.load	$push55=, 0($pop0)
	tee_local	$push54=, $2=, $pop55
	i64.const	$push53=, 8
	i64.shr_u	$push1=, $pop54, $pop53
	i64.const	$push52=, 56
	i64.shl 	$push2=, $2, $pop52
	i64.or  	$push3=, $pop1, $pop2
	i64.store	$discard=, 0($pop4), $pop3
	i32.const	$push51=, 8
	i32.add 	$0=, $0, $pop51
	i32.const	$push50=, 2048
	i32.ne  	$push5=, $0, $pop50
	br_if   	0, $pop5        # 0: up to label0
.LBB0_2:                                # %for.body16
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label1:
	loop                            # label2:
	i32.const	$20=, 1568
	i32.add 	$20=, $34, $20
	i32.add 	$push10=, $20, $1
	i32.const	$21=, 2592
	i32.add 	$21=, $34, $21
	i32.add 	$push6=, $21, $1
	i32.load	$push61=, 0($pop6)
	tee_local	$push60=, $0=, $pop61
	i32.const	$push59=, 8
	i32.shr_u	$push7=, $pop60, $pop59
	i32.const	$push58=, 24
	i32.shl 	$push8=, $0, $pop58
	i32.or  	$push9=, $pop7, $pop8
	i32.store	$discard=, 0($pop10), $pop9
	i32.const	$push57=, 4
	i32.add 	$1=, $1, $pop57
	i32.const	$push56=, 1024
	i32.ne  	$push11=, $1, $pop56
	br_if   	0, $pop11       # 0: up to label2
# BB#3:
	end_loop                        # label3:
	i32.const	$1=, 0
.LBB0_4:                                # %for.body28
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$22=, 544
	i32.add 	$22=, $34, $22
	i32.add 	$push16=, $22, $1
	i32.const	$23=, 1056
	i32.add 	$23=, $34, $23
	i32.add 	$push12=, $23, $1
	i32.load16_u	$push67=, 0($pop12)
	tee_local	$push66=, $0=, $pop67
	i32.const	$push65=, 9
	i32.shr_u	$push13=, $pop66, $pop65
	i32.const	$push64=, 7
	i32.shl 	$push14=, $0, $pop64
	i32.or  	$push15=, $pop13, $pop14
	i32.store16	$discard=, 0($pop16), $pop15
	i32.const	$push63=, 2
	i32.add 	$1=, $1, $pop63
	i32.const	$push62=, 512
	i32.ne  	$push17=, $1, $pop62
	br_if   	0, $pop17       # 0: up to label4
# BB#5:
	end_loop                        # label5:
	i32.const	$1=, 0
.LBB0_6:                                # %for.body43
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.const	$24=, 32
	i32.add 	$24=, $34, $24
	i32.add 	$push22=, $24, $1
	i32.const	$25=, 288
	i32.add 	$25=, $34, $25
	i32.add 	$push18=, $25, $1
	i32.load8_u	$push73=, 0($pop18)
	tee_local	$push72=, $0=, $pop73
	i32.const	$push71=, 5
	i32.shr_u	$push19=, $pop72, $pop71
	i32.const	$push70=, 3
	i32.shl 	$push20=, $0, $pop70
	i32.or  	$push21=, $pop19, $pop20
	i32.store8	$discard=, 0($pop22), $pop21
	i32.const	$push69=, 1
	i32.add 	$1=, $1, $pop69
	i32.const	$push68=, 256
	i32.ne  	$push23=, $1, $pop68
	br_if   	0, $pop23       # 0: up to label6
# BB#7:                                 # %for.end55
	end_loop                        # label7:
	i32.const	$26=, 3616
	i32.add 	$26=, $34, $26
	i32.store	$discard=, 12($34), $26
	i32.const	$27=, 1568
	i32.add 	$27=, $34, $27
	i32.store	$discard=, 8($34), $27
	i32.const	$28=, 544
	i32.add 	$28=, $34, $28
	i32.store	$discard=, 4($34), $28
	i32.const	$29=, 32
	i32.add 	$29=, $34, $29
	i32.store	$discard=, 0($34), $29
	i32.const	$30=, 12
	i32.add 	$30=, $34, $30
	i32.const	$31=, 8
	i32.add 	$31=, $34, $31
	i32.const	$32=, 4
	i32.add 	$32=, $34, $32
	#APP
	#NO_APP
	block
	i64.load	$push24=, 3616($34):p2align=4
	i64.const	$push25=, -1224658842671273011
	i64.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label8
# BB#8:                                 # %lor.lhs.false
	i32.const	$push27=, 8
	i32.const	$33=, 3616
	i32.add 	$33=, $34, $33
	i32.or  	$push28=, $33, $pop27
	i64.load	$push29=, 0($pop28)
	i64.const	$push30=, 0
	i64.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label8
# BB#9:                                 # %if.end
	i64.load	$push75=, 1568($34):p2align=4
	tee_local	$push74=, $2=, $pop75
	i32.wrap/i64	$push32=, $pop74
	i32.const	$push33=, 1728127813
	i32.ne  	$push34=, $pop32, $pop33
	br_if   	0, $pop34       # 0: down to label8
# BB#10:                                # %if.end
	i64.const	$push35=, 4294967296
	i64.ge_u	$push36=, $2, $pop35
	br_if   	0, $pop36       # 0: down to label8
# BB#11:                                # %if.end71
	i32.load	$push77=, 544($34):p2align=4
	tee_local	$push76=, $1=, $pop77
	i32.const	$push37=, 65535
	i32.and 	$push38=, $pop76, $pop37
	i32.const	$push39=, 45986
	i32.ne  	$push40=, $pop38, $pop39
	br_if   	0, $pop40       # 0: down to label8
# BB#12:                                # %if.end71
	i32.const	$push41=, 65536
	i32.ge_u	$push42=, $1, $pop41
	br_if   	0, $pop42       # 0: down to label8
# BB#13:                                # %if.end81
	i32.load16_u	$push79=, 32($34):p2align=4
	tee_local	$push78=, $1=, $pop79
	i32.const	$push43=, 255
	i32.and 	$push44=, $pop78, $pop43
	i32.const	$push45=, 155
	i32.ne  	$push46=, $pop44, $pop45
	br_if   	0, $pop46       # 0: down to label8
# BB#14:                                # %if.end81
	i32.const	$push47=, 256
	i32.ge_u	$push48=, $1, $pop47
	br_if   	0, $pop48       # 0: down to label8
# BB#15:                                # %if.end91
	i32.const	$push49=, 0
	i32.const	$5=, 7712
	i32.add 	$34=, $34, $5
	i32.const	$5=, __stack_pointer
	i32.store	$34=, 0($5), $34
	return  	$pop49
.LBB0_16:                               # %if.then90
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
