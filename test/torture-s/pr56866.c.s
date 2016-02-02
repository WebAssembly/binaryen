	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56866.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 7712
	i32.sub 	$35=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$35=, 0($5), $35
	i32.const	$2=, 2048
	i32.const	$0=, 0
	i32.const	$7=, 5664
	i32.add 	$7=, $35, $7
	i32.call	$discard=, memset@FUNCTION, $7, $0, $2
	i32.const	$2=, 1024
	i32.const	$8=, 2592
	i32.add 	$8=, $35, $8
	i32.call	$discard=, memset@FUNCTION, $8, $0, $2
	i32.const	$2=, 512
	i32.const	$9=, 1056
	i32.add 	$9=, $35, $9
	i32.call	$discard=, memset@FUNCTION, $9, $0, $2
	i32.const	$2=, 256
	i32.const	$10=, 288
	i32.add 	$10=, $35, $10
	i32.call	$discard=, memset@FUNCTION, $10, $0, $2
	i32.const	$2=, 19088743
	i32.store	$discard=, 2592($35):p2align=4, $2
	i32.const	$2=, 17767
	i32.store16	$discard=, 1056($35):p2align=4, $2
	i32.const	$2=, 115
	i32.store8	$discard=, 288($35):p2align=4, $2
	i64.const	$3=, 81985529216486895
	i64.store	$discard=, 5664($35):p2align=4, $3
	i32.const	$11=, 5664
	i32.add 	$11=, $35, $11
	i32.store	$discard=, 28($35), $11
	i32.const	$12=, 2592
	i32.add 	$12=, $35, $12
	i32.store	$discard=, 24($35), $12
	i32.const	$13=, 1056
	i32.add 	$13=, $35, $13
	i32.store	$discard=, 20($35), $13
	i32.const	$14=, 288
	i32.add 	$14=, $35, $14
	i32.store	$discard=, 16($35), $14
	i32.const	$15=, 28
	i32.add 	$15=, $35, $15
	i32.const	$16=, 24
	i32.add 	$16=, $35, $16
	i32.const	$17=, 20
	i32.add 	$17=, $35, $17
	i32.const	$18=, 16
	i32.add 	$18=, $35, $18
	#APP
	#NO_APP
	i32.const	$2=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$19=, 3616
	i32.add 	$19=, $35, $19
	i32.add 	$push5=, $19, $2
	i32.const	$20=, 5664
	i32.add 	$20=, $35, $20
	i32.add 	$push0=, $20, $2
	i64.load	$push1=, 0($pop0)
	tee_local	$push73=, $3=, $pop1
	i64.const	$push72=, 8
	i64.shr_u	$push2=, $pop73, $pop72
	i64.const	$push71=, 56
	i64.shl 	$push3=, $3, $pop71
	i64.or  	$push4=, $pop2, $pop3
	i64.store	$discard=, 0($pop5), $pop4
	i32.const	$push70=, 8
	i32.add 	$2=, $2, $pop70
	i32.const	$push69=, 2048
	i32.ne  	$push6=, $2, $pop69
	br_if   	$pop6, 0        # 0: up to label0
.LBB0_2:                                # %for.body16
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label1:
	loop                            # label2:
	i32.const	$21=, 1568
	i32.add 	$21=, $35, $21
	i32.add 	$push14=, $21, $0
	i32.const	$22=, 2592
	i32.add 	$22=, $35, $22
	i32.add 	$push7=, $22, $0
	i32.load	$push8=, 0($pop7)
	tee_local	$push74=, $2=, $pop8
	i32.const	$push9=, 8
	i32.shr_u	$push10=, $pop74, $pop9
	i32.const	$push11=, 24
	i32.shl 	$push12=, $2, $pop11
	i32.or  	$push13=, $pop10, $pop12
	i32.store	$discard=, 0($pop14), $pop13
	i32.const	$push15=, 4
	i32.add 	$0=, $0, $pop15
	i32.const	$2=, 0
	i32.const	$1=, 0
	i32.const	$push16=, 1024
	i32.ne  	$push17=, $0, $pop16
	br_if   	$pop17, 0       # 0: up to label2
.LBB0_3:                                # %for.body28
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label3:
	loop                            # label4:
	i32.const	$23=, 544
	i32.add 	$23=, $35, $23
	i32.add 	$push25=, $23, $1
	i32.const	$24=, 1056
	i32.add 	$24=, $35, $24
	i32.add 	$push18=, $24, $1
	i32.load16_u	$push19=, 0($pop18)
	tee_local	$push75=, $0=, $pop19
	i32.const	$push20=, 9
	i32.shr_u	$push21=, $pop75, $pop20
	i32.const	$push22=, 7
	i32.shl 	$push23=, $0, $pop22
	i32.or  	$push24=, $pop21, $pop23
	i32.store16	$discard=, 0($pop25), $pop24
	i32.const	$push26=, 2
	i32.add 	$1=, $1, $pop26
	i32.const	$push27=, 512
	i32.ne  	$push28=, $1, $pop27
	br_if   	$pop28, 0       # 0: up to label4
.LBB0_4:                                # %for.body43
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label5:
	loop                            # label6:
	i32.const	$25=, 32
	i32.add 	$25=, $35, $25
	i32.add 	$push36=, $25, $2
	i32.const	$26=, 288
	i32.add 	$26=, $35, $26
	i32.add 	$push29=, $26, $2
	i32.load8_u	$push30=, 0($pop29)
	tee_local	$push76=, $1=, $pop30
	i32.const	$push31=, 5
	i32.shr_u	$push32=, $pop76, $pop31
	i32.const	$push33=, 3
	i32.shl 	$push34=, $1, $pop33
	i32.or  	$push35=, $pop32, $pop34
	i32.store8	$discard=, 0($pop36), $pop35
	i32.const	$push37=, 1
	i32.add 	$2=, $2, $pop37
	i32.const	$push38=, 256
	i32.ne  	$push39=, $2, $pop38
	br_if   	$pop39, 0       # 0: up to label6
# BB#5:                                 # %for.end55
	end_loop                        # label7:
	i32.const	$27=, 3616
	i32.add 	$27=, $35, $27
	i32.store	$discard=, 12($35), $27
	i32.const	$28=, 1568
	i32.add 	$28=, $35, $28
	i32.store	$discard=, 8($35), $28
	i32.const	$29=, 544
	i32.add 	$29=, $35, $29
	i32.store	$discard=, 4($35), $29
	i32.const	$30=, 32
	i32.add 	$30=, $35, $30
	i32.store	$discard=, 0($35), $30
	i32.const	$31=, 12
	i32.add 	$31=, $35, $31
	i32.const	$32=, 8
	i32.add 	$32=, $35, $32
	i32.const	$33=, 4
	i32.add 	$33=, $35, $33
	#APP
	#NO_APP
	block
	i64.load	$push40=, 3616($35):p2align=4
	i64.const	$push41=, -1224658842671273011
	i64.ne  	$push42=, $pop40, $pop41
	br_if   	$pop42, 0       # 0: down to label8
# BB#6:                                 # %lor.lhs.false
	i32.const	$push43=, 8
	i32.const	$34=, 3616
	i32.add 	$34=, $35, $34
	i32.or  	$push44=, $34, $pop43
	i64.load	$push45=, 0($pop44)
	i64.const	$push46=, 0
	i64.ne  	$push47=, $pop45, $pop46
	br_if   	$pop47, 0       # 0: down to label8
# BB#7:                                 # %if.end
	block
	i64.load	$push48=, 1568($35):p2align=4
	tee_local	$push77=, $3=, $pop48
	i32.wrap/i64	$push49=, $pop77
	i32.const	$push50=, 1728127813
	i32.ne  	$push51=, $pop49, $pop50
	br_if   	$pop51, 0       # 0: down to label9
# BB#8:                                 # %if.end
	i64.const	$push52=, 4294967296
	i64.ge_u	$push53=, $3, $pop52
	br_if   	$pop53, 0       # 0: down to label9
# BB#9:                                 # %if.end71
	block
	i32.load	$push54=, 544($35):p2align=4
	tee_local	$push78=, $2=, $pop54
	i32.const	$push55=, 65535
	i32.and 	$push56=, $pop78, $pop55
	i32.const	$push57=, 45986
	i32.ne  	$push58=, $pop56, $pop57
	br_if   	$pop58, 0       # 0: down to label10
# BB#10:                                # %if.end71
	i32.const	$push59=, 65536
	i32.ge_u	$push60=, $2, $pop59
	br_if   	$pop60, 0       # 0: down to label10
# BB#11:                                # %if.end81
	block
	i32.load16_u	$push61=, 32($35):p2align=4
	tee_local	$push79=, $2=, $pop61
	i32.const	$push62=, 255
	i32.and 	$push63=, $pop79, $pop62
	i32.const	$push64=, 155
	i32.ne  	$push65=, $pop63, $pop64
	br_if   	$pop65, 0       # 0: down to label11
# BB#12:                                # %if.end81
	i32.const	$push66=, 256
	i32.ge_u	$push67=, $2, $pop66
	br_if   	$pop67, 0       # 0: down to label11
# BB#13:                                # %if.end91
	i32.const	$push68=, 0
	i32.const	$6=, 7712
	i32.add 	$35=, $35, $6
	i32.const	$6=, __stack_pointer
	i32.store	$35=, 0($6), $35
	return  	$pop68
.LBB0_14:                               # %if.then90
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB0_15:                               # %if.then80
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %if.then70
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB0_17:                               # %if.then
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
