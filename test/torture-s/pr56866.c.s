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
	i32.add 	$push4=, $19, $2
	i32.const	$20=, 5664
	i32.add 	$20=, $35, $20
	i32.add 	$push0=, $20, $2
	i64.load	$push67=, 0($pop0)
	tee_local	$push66=, $3=, $pop67
	i64.const	$push65=, 8
	i64.shr_u	$push1=, $pop66, $pop65
	i64.const	$push64=, 56
	i64.shl 	$push2=, $3, $pop64
	i64.or  	$push3=, $pop1, $pop2
	i64.store	$discard=, 0($pop4), $pop3
	i32.const	$push63=, 8
	i32.add 	$2=, $2, $pop63
	i32.const	$push62=, 2048
	i32.ne  	$push5=, $2, $pop62
	br_if   	0, $pop5        # 0: up to label0
.LBB0_2:                                # %for.body16
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label1:
	loop                            # label2:
	i32.const	$21=, 1568
	i32.add 	$21=, $35, $21
	i32.add 	$push12=, $21, $0
	i32.const	$22=, 2592
	i32.add 	$22=, $35, $22
	i32.add 	$push6=, $22, $0
	i32.load	$push69=, 0($pop6)
	tee_local	$push68=, $2=, $pop69
	i32.const	$push7=, 8
	i32.shr_u	$push8=, $pop68, $pop7
	i32.const	$push9=, 24
	i32.shl 	$push10=, $2, $pop9
	i32.or  	$push11=, $pop8, $pop10
	i32.store	$discard=, 0($pop12), $pop11
	i32.const	$push13=, 4
	i32.add 	$0=, $0, $pop13
	i32.const	$2=, 0
	i32.const	$1=, 0
	i32.const	$push14=, 1024
	i32.ne  	$push15=, $0, $pop14
	br_if   	0, $pop15       # 0: up to label2
.LBB0_3:                                # %for.body28
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label3:
	loop                            # label4:
	i32.const	$23=, 544
	i32.add 	$23=, $35, $23
	i32.add 	$push22=, $23, $1
	i32.const	$24=, 1056
	i32.add 	$24=, $35, $24
	i32.add 	$push16=, $24, $1
	i32.load16_u	$push71=, 0($pop16)
	tee_local	$push70=, $0=, $pop71
	i32.const	$push17=, 9
	i32.shr_u	$push18=, $pop70, $pop17
	i32.const	$push19=, 7
	i32.shl 	$push20=, $0, $pop19
	i32.or  	$push21=, $pop18, $pop20
	i32.store16	$discard=, 0($pop22), $pop21
	i32.const	$push23=, 2
	i32.add 	$1=, $1, $pop23
	i32.const	$push24=, 512
	i32.ne  	$push25=, $1, $pop24
	br_if   	0, $pop25       # 0: up to label4
.LBB0_4:                                # %for.body43
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label5:
	loop                            # label6:
	i32.const	$25=, 32
	i32.add 	$25=, $35, $25
	i32.add 	$push32=, $25, $2
	i32.const	$26=, 288
	i32.add 	$26=, $35, $26
	i32.add 	$push26=, $26, $2
	i32.load8_u	$push73=, 0($pop26)
	tee_local	$push72=, $1=, $pop73
	i32.const	$push27=, 5
	i32.shr_u	$push28=, $pop72, $pop27
	i32.const	$push29=, 3
	i32.shl 	$push30=, $1, $pop29
	i32.or  	$push31=, $pop28, $pop30
	i32.store8	$discard=, 0($pop32), $pop31
	i32.const	$push33=, 1
	i32.add 	$2=, $2, $pop33
	i32.const	$push34=, 256
	i32.ne  	$push35=, $2, $pop34
	br_if   	0, $pop35       # 0: up to label6
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
	block
	block
	block
	i64.load	$push36=, 3616($35):p2align=4
	i64.const	$push37=, -1224658842671273011
	i64.ne  	$push38=, $pop36, $pop37
	br_if   	0, $pop38       # 0: down to label11
# BB#6:                                 # %lor.lhs.false
	i32.const	$push39=, 8
	i32.const	$34=, 3616
	i32.add 	$34=, $35, $34
	i32.or  	$push40=, $34, $pop39
	i64.load	$push41=, 0($pop40)
	i64.const	$push42=, 0
	i64.ne  	$push43=, $pop41, $pop42
	br_if   	0, $pop43       # 0: down to label11
# BB#7:                                 # %if.end
	i64.load	$push75=, 1568($35):p2align=4
	tee_local	$push74=, $3=, $pop75
	i32.wrap/i64	$push44=, $pop74
	i32.const	$push45=, 1728127813
	i32.ne  	$push46=, $pop44, $pop45
	br_if   	1, $pop46       # 1: down to label10
# BB#8:                                 # %if.end
	i64.const	$push47=, 4294967296
	i64.ge_u	$push48=, $3, $pop47
	br_if   	1, $pop48       # 1: down to label10
# BB#9:                                 # %if.end71
	i32.load	$push77=, 544($35):p2align=4
	tee_local	$push76=, $2=, $pop77
	i32.const	$push49=, 65535
	i32.and 	$push50=, $pop76, $pop49
	i32.const	$push51=, 45986
	i32.ne  	$push52=, $pop50, $pop51
	br_if   	2, $pop52       # 2: down to label9
# BB#10:                                # %if.end71
	i32.const	$push53=, 65536
	i32.ge_u	$push54=, $2, $pop53
	br_if   	2, $pop54       # 2: down to label9
# BB#11:                                # %if.end81
	i32.load16_u	$push79=, 32($35):p2align=4
	tee_local	$push78=, $2=, $pop79
	i32.const	$push55=, 255
	i32.and 	$push56=, $pop78, $pop55
	i32.const	$push57=, 155
	i32.ne  	$push58=, $pop56, $pop57
	br_if   	3, $pop58       # 3: down to label8
# BB#12:                                # %if.end81
	i32.const	$push59=, 256
	i32.ge_u	$push60=, $2, $pop59
	br_if   	3, $pop60       # 3: down to label8
# BB#13:                                # %if.end91
	i32.const	$push61=, 0
	i32.const	$6=, 7712
	i32.add 	$35=, $35, $6
	i32.const	$6=, __stack_pointer
	i32.store	$35=, 0($6), $35
	return  	$pop61
.LBB0_14:                               # %if.then
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB0_15:                               # %if.then70
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %if.then80
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB0_17:                               # %if.then90
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
