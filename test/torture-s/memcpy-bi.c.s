	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memcpy-bi.c"
	.section	.text.check,"ax",@progbits
	.hidden	check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.call	$push0=, memcmp@FUNCTION, $0, $1, $2
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i64, i64, i64
# BB#0:                                 # %entry
	i32.const	$2=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$0=, 26
	i32.rem_s	$4=, $2, $0
	i32.const	$1=, src
	i32.add 	$push2=, $1, $2
	i32.const	$push0=, 97
	i32.add 	$push1=, $4, $pop0
	i32.store8	$discard=, 0($pop2), $pop1
	i32.const	$4=, 1
	i32.add 	$2=, $2, $4
	i32.const	$push3=, 80
	i32.ne  	$push4=, $2, $pop3
	br_if   	$pop4, 0        # 0: up to label1
# BB#2:                                 # %check.exit
	end_loop                        # label2:
	i32.const	$2=, 0
	block
	i32.load16_u	$push5=, src($2)
	i32.store16	$discard=, dst($2), $pop5
	i32.const	$push134=, 0
	i32.eq  	$push135=, $4, $pop134
	br_if   	$pop135, 0      # 0: down to label3
# BB#3:                                 # %check.exit13
	i32.load16_u	$3=, src($2)
	i32.load8_u	$push6=, src+2($2)
	i32.store8	$discard=, dst+2($2), $pop6
	i32.const	$4=, dst
	i32.store16	$discard=, dst($2), $3
	block
	i32.const	$push7=, 3
	i32.call	$push8=, memcmp@FUNCTION, $4, $1, $pop7
	br_if   	$pop8, 0        # 0: down to label4
# BB#4:                                 # %check.exit17
	i32.load	$3=, src($2)
	i32.load8_u	$push9=, src+4($2)
	i32.store8	$discard=, dst+4($2), $pop9
	i32.store	$discard=, dst($2), $3
	block
	i32.const	$push10=, 5
	i32.call	$push11=, memcmp@FUNCTION, $4, $1, $pop10
	br_if   	$pop11, 0       # 0: down to label5
# BB#5:                                 # %check.exit25
	i32.load	$3=, src($2)
	i32.load16_u	$push12=, src+4($2)
	i32.store16	$discard=, dst+4($2), $pop12
	i32.store	$discard=, dst($2), $3
	block
	i32.const	$push13=, 6
	i32.call	$push14=, memcmp@FUNCTION, $4, $1, $pop13
	br_if   	$pop14, 0       # 0: down to label6
# BB#6:                                 # %check.exit29
	i32.load16_u	$3=, src+4($2)
	i32.load	$5=, src($2)
	i32.load8_u	$push15=, src+6($2)
	i32.store8	$discard=, dst+6($2), $pop15
	i32.store16	$discard=, dst+4($2), $3
	i32.store	$discard=, dst($2), $5
	block
	i32.const	$push16=, 7
	i32.call	$push17=, memcmp@FUNCTION, $4, $1, $pop16
	br_if   	$pop17, 0       # 0: down to label7
# BB#7:                                 # %check.exit33
	i64.load	$6=, src($2)
	i32.load8_u	$push18=, src+8($2)
	i32.store8	$discard=, dst+8($2), $pop18
	i64.store	$discard=, dst($2), $6
	block
	i32.const	$push19=, 9
	i32.call	$push20=, memcmp@FUNCTION, $4, $1, $pop19
	br_if   	$pop20, 0       # 0: down to label8
# BB#8:                                 # %check.exit41
	i64.load	$6=, src($2)
	i32.load16_u	$push21=, src+8($2)
	i32.store16	$discard=, dst+8($2), $pop21
	i64.store	$discard=, dst($2), $6
	block
	i32.const	$push22=, 10
	i32.call	$push23=, memcmp@FUNCTION, $4, $1, $pop22
	br_if   	$pop23, 0       # 0: down to label9
# BB#9:                                 # %check.exit45
	i32.load16_u	$3=, src+8($2)
	i64.load	$6=, src($2)
	i32.load8_u	$push24=, src+10($2)
	i32.store8	$discard=, dst+10($2), $pop24
	i32.store16	$discard=, dst+8($2), $3
	i64.store	$discard=, dst($2), $6
	block
	i32.const	$push25=, 11
	i32.call	$push26=, memcmp@FUNCTION, $4, $1, $pop25
	br_if   	$pop26, 0       # 0: down to label10
# BB#10:                                # %check.exit49
	i64.load	$6=, src($2)
	i32.load	$push27=, src+8($2)
	i32.store	$discard=, dst+8($2), $pop27
	i64.store	$discard=, dst($2), $6
	block
	i32.const	$push28=, 12
	i32.call	$push29=, memcmp@FUNCTION, $4, $1, $pop28
	br_if   	$pop29, 0       # 0: down to label11
# BB#11:                                # %check.exit53
	i32.load	$3=, src+8($2)
	i64.load	$6=, src($2)
	i32.load8_u	$push30=, src+12($2)
	i32.store8	$discard=, dst+12($2), $pop30
	i32.store	$discard=, dst+8($2), $3
	i64.store	$discard=, dst($2), $6
	block
	i32.const	$push31=, 13
	i32.call	$push32=, memcmp@FUNCTION, $4, $1, $pop31
	br_if   	$pop32, 0       # 0: down to label12
# BB#12:                                # %check.exit57
	i32.load	$3=, src+8($2)
	i64.load	$6=, src($2)
	i32.load16_u	$push33=, src+12($2)
	i32.store16	$discard=, dst+12($2), $pop33
	i32.store	$discard=, dst+8($2), $3
	i64.store	$discard=, dst($2), $6
	block
	i32.const	$push34=, 14
	i32.call	$push35=, memcmp@FUNCTION, $4, $1, $pop34
	br_if   	$pop35, 0       # 0: down to label13
# BB#13:                                # %check.exit61
	i32.load16_u	$3=, src+12($2)
	i32.load	$5=, src+8($2)
	i32.load8_u	$push36=, src+14($2)
	i32.store8	$discard=, dst+14($2), $pop36
	i64.load	$6=, src($2)
	i32.store16	$discard=, dst+12($2), $3
	i32.store	$discard=, dst+8($2), $5
	i64.store	$discard=, dst($2), $6
	block
	i32.const	$push37=, 15
	i32.call	$push38=, memcmp@FUNCTION, $4, $1, $pop37
	br_if   	$pop38, 0       # 0: down to label14
# BB#14:                                # %check.exit65
	i64.load	$6=, src($2)
	i64.load	$push39=, src+8($2)
	i64.store	$discard=, dst+8($2), $pop39
	i64.store	$discard=, dst($2), $6
	block
	i32.const	$push40=, 16
	i32.call	$push41=, memcmp@FUNCTION, $4, $1, $pop40
	br_if   	$pop41, 0       # 0: down to label15
# BB#15:                                # %check.exit69
	i64.load	$6=, src+8($2)
	i64.load	$7=, src($2)
	i32.load8_u	$push42=, src+16($2)
	i32.store8	$discard=, dst+16($2), $pop42
	i64.store	$discard=, dst+8($2), $6
	i64.store	$discard=, dst($2), $7
	block
	i32.const	$push43=, 17
	i32.call	$push44=, memcmp@FUNCTION, $4, $1, $pop43
	br_if   	$pop44, 0       # 0: down to label16
# BB#16:                                # %check.exit73
	i64.load	$6=, src+8($2)
	i64.load	$7=, src($2)
	i32.load16_u	$push45=, src+16($2)
	i32.store16	$discard=, dst+16($2), $pop45
	i64.store	$discard=, dst+8($2), $6
	i64.store	$discard=, dst($2), $7
	block
	i32.const	$push46=, 18
	i32.call	$push47=, memcmp@FUNCTION, $4, $1, $pop46
	br_if   	$pop47, 0       # 0: down to label17
# BB#17:                                # %check.exit77
	i32.load16_u	$3=, src+16($2)
	i64.load	$6=, src+8($2)
	i32.load8_u	$push48=, src+18($2)
	i32.store8	$discard=, dst+18($2), $pop48
	i64.load	$7=, src($2)
	i32.store16	$discard=, dst+16($2), $3
	i64.store	$discard=, dst+8($2), $6
	i64.store	$discard=, dst($2), $7
	block
	i32.const	$push49=, 19
	i32.call	$push50=, memcmp@FUNCTION, $4, $1, $pop49
	br_if   	$pop50, 0       # 0: down to label18
# BB#18:                                # %check.exit81
	i64.load	$6=, src+8($2)
	i64.load	$7=, src($2)
	i32.load	$push51=, src+16($2)
	i32.store	$discard=, dst+16($2), $pop51
	i64.store	$discard=, dst+8($2), $6
	i64.store	$discard=, dst($2), $7
	block
	i32.const	$push52=, 20
	i32.call	$push53=, memcmp@FUNCTION, $4, $1, $pop52
	br_if   	$pop53, 0       # 0: down to label19
# BB#19:                                # %check.exit85
	i32.load	$3=, src+16($2)
	i64.load	$6=, src+8($2)
	i32.load8_u	$push54=, src+20($2)
	i32.store8	$discard=, dst+20($2), $pop54
	i64.load	$7=, src($2)
	i32.store	$discard=, dst+16($2), $3
	i64.store	$discard=, dst+8($2), $6
	i64.store	$discard=, dst($2), $7
	block
	i32.const	$push55=, 21
	i32.call	$push56=, memcmp@FUNCTION, $4, $1, $pop55
	br_if   	$pop56, 0       # 0: down to label20
# BB#20:                                # %check.exit89
	i32.load	$3=, src+16($2)
	i64.load	$6=, src+8($2)
	i32.load16_u	$push57=, src+20($2)
	i32.store16	$discard=, dst+20($2), $pop57
	i64.load	$7=, src($2)
	i32.store	$discard=, dst+16($2), $3
	i64.store	$discard=, dst+8($2), $6
	i64.store	$discard=, dst($2), $7
	block
	i32.const	$push58=, 22
	i32.call	$push59=, memcmp@FUNCTION, $4, $1, $pop58
	br_if   	$pop59, 0       # 0: down to label21
# BB#21:                                # %check.exit93
	i32.load16_u	$3=, src+20($2)
	i32.load8_u	$push60=, src+22($2)
	i32.store8	$discard=, dst+22($2), $pop60
	i32.load	$5=, src+16($2)
	i64.load	$6=, src+8($2)
	i32.store16	$discard=, dst+20($2), $3
	i64.load	$7=, src($2)
	i32.store	$discard=, dst+16($2), $5
	i64.store	$discard=, dst+8($2), $6
	i64.store	$discard=, dst($2), $7
	block
	i32.const	$push61=, 23
	i32.call	$push62=, memcmp@FUNCTION, $4, $1, $pop61
	br_if   	$pop62, 0       # 0: down to label22
# BB#22:                                # %check.exit97
	i64.load	$6=, src+8($2)
	i64.load	$7=, src($2)
	i64.load	$push63=, src+16($2)
	i64.store	$discard=, dst+16($2), $pop63
	i64.store	$discard=, dst+8($2), $6
	i64.store	$discard=, dst($2), $7
	block
	i32.const	$push64=, 24
	i32.call	$push65=, memcmp@FUNCTION, $4, $1, $pop64
	br_if   	$pop65, 0       # 0: down to label23
# BB#23:                                # %check.exit101
	i64.load	$6=, src+16($2)
	i64.load	$7=, src+8($2)
	i32.load8_u	$push66=, src+24($2)
	i32.store8	$discard=, dst+24($2), $pop66
	i64.load	$8=, src($2)
	i64.store	$discard=, dst+16($2), $6
	i64.store	$discard=, dst+8($2), $7
	i64.store	$discard=, dst($2), $8
	block
	i32.const	$push67=, 25
	i32.call	$push68=, memcmp@FUNCTION, $4, $1, $pop67
	br_if   	$pop68, 0       # 0: down to label24
# BB#24:                                # %check.exit105
	i64.load	$6=, src+16($2)
	i64.load	$7=, src+8($2)
	i64.load	$8=, src($2)
	i32.load16_u	$push69=, src+24($2)
	i32.store16	$discard=, dst+24($2), $pop69
	i64.store	$discard=, dst+16($2), $6
	i64.store	$discard=, dst+8($2), $7
	i64.store	$discard=, dst($2), $8
	block
	i32.call	$push70=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop70, 0       # 0: down to label25
# BB#25:                                # %check.exit109
	i32.load16_u	$0=, src+24($2)
	i32.load8_u	$push71=, src+26($2)
	i32.store8	$discard=, dst+26($2), $pop71
	i64.load	$6=, src+16($2)
	i64.load	$7=, src+8($2)
	i32.store16	$discard=, dst+24($2), $0
	i64.load	$8=, src($2)
	i64.store	$discard=, dst+16($2), $6
	i64.store	$discard=, dst+8($2), $7
	i64.store	$discard=, dst($2), $8
	block
	i32.const	$push72=, 27
	i32.call	$push73=, memcmp@FUNCTION, $4, $1, $pop72
	br_if   	$pop73, 0       # 0: down to label26
# BB#26:                                # %check.exit113
	i64.load	$6=, src+16($2)
	i64.load	$7=, src+8($2)
	i32.load	$push74=, src+24($2)
	i32.store	$discard=, dst+24($2), $pop74
	i64.load	$8=, src($2)
	i64.store	$discard=, dst+16($2), $6
	i64.store	$discard=, dst+8($2), $7
	i64.store	$discard=, dst($2), $8
	block
	i32.const	$push75=, 28
	i32.call	$push76=, memcmp@FUNCTION, $4, $1, $pop75
	br_if   	$pop76, 0       # 0: down to label27
# BB#27:                                # %check.exit117
	i32.load	$0=, src+24($2)
	i32.load8_u	$push77=, src+28($2)
	i32.store8	$discard=, dst+28($2), $pop77
	i64.load	$6=, src+16($2)
	i64.load	$7=, src+8($2)
	i32.store	$discard=, dst+24($2), $0
	i64.load	$8=, src($2)
	i64.store	$discard=, dst+16($2), $6
	i64.store	$discard=, dst+8($2), $7
	i64.store	$discard=, dst($2), $8
	block
	i32.const	$push78=, 29
	i32.call	$push79=, memcmp@FUNCTION, $4, $1, $pop78
	br_if   	$pop79, 0       # 0: down to label28
# BB#28:                                # %check.exit121
	i32.load	$0=, src+24($2)
	i32.load16_u	$push80=, src+28($2)
	i32.store16	$discard=, dst+28($2), $pop80
	i64.load	$6=, src+16($2)
	i64.load	$7=, src+8($2)
	i32.store	$discard=, dst+24($2), $0
	i64.load	$8=, src($2)
	i64.store	$discard=, dst+16($2), $6
	i64.store	$discard=, dst+8($2), $7
	i64.store	$discard=, dst($2), $8
	block
	i32.const	$push81=, 30
	i32.call	$push82=, memcmp@FUNCTION, $4, $1, $pop81
	br_if   	$pop82, 0       # 0: down to label29
# BB#29:                                # %check.exit125
	i32.const	$0=, 31
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push83=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop83, 0       # 0: down to label30
# BB#30:                                # %check.exit129
	i64.load	$6=, src+16($2)
	i64.load	$7=, src+8($2)
	i64.load	$push84=, src+24($2)
	i64.store	$discard=, dst+24($2), $pop84
	i64.load	$8=, src($2)
	i64.store	$discard=, dst+16($2), $6
	i64.store	$discard=, dst+8($2), $7
	i64.store	$discard=, dst($2), $8
	block
	i32.const	$push85=, 32
	i32.call	$push86=, memcmp@FUNCTION, $4, $1, $pop85
	br_if   	$pop86, 0       # 0: down to label31
# BB#31:                                # %check.exit133
	i32.const	$0=, 33
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push87=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop87, 0       # 0: down to label32
# BB#32:                                # %check.exit137
	i32.const	$0=, 34
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push88=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop88, 0       # 0: down to label33
# BB#33:                                # %check.exit141
	i32.const	$0=, 35
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push89=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop89, 0       # 0: down to label34
# BB#34:                                # %check.exit145
	i32.const	$0=, 36
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push90=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop90, 0       # 0: down to label35
# BB#35:                                # %check.exit149
	i32.const	$0=, 37
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push91=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop91, 0       # 0: down to label36
# BB#36:                                # %check.exit153
	i32.const	$0=, 38
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push92=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop92, 0       # 0: down to label37
# BB#37:                                # %check.exit157
	i32.const	$0=, 39
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push93=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop93, 0       # 0: down to label38
# BB#38:                                # %check.exit161
	i32.const	$0=, 40
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push94=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop94, 0       # 0: down to label39
# BB#39:                                # %check.exit165
	i32.const	$0=, 41
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push95=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop95, 0       # 0: down to label40
# BB#40:                                # %check.exit169
	i32.const	$0=, 42
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push96=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop96, 0       # 0: down to label41
# BB#41:                                # %check.exit173
	i32.const	$0=, 43
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push97=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop97, 0       # 0: down to label42
# BB#42:                                # %check.exit177
	i32.const	$0=, 44
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push98=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop98, 0       # 0: down to label43
# BB#43:                                # %check.exit181
	i32.const	$0=, 45
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push99=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop99, 0       # 0: down to label44
# BB#44:                                # %check.exit185
	i32.const	$0=, 46
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push100=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop100, 0      # 0: down to label45
# BB#45:                                # %check.exit189
	i32.const	$0=, 47
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push101=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop101, 0      # 0: down to label46
# BB#46:                                # %check.exit193
	i32.const	$0=, 48
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push102=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop102, 0      # 0: down to label47
# BB#47:                                # %check.exit197
	i32.const	$0=, 49
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push103=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop103, 0      # 0: down to label48
# BB#48:                                # %check.exit201
	i32.const	$0=, 50
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push104=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop104, 0      # 0: down to label49
# BB#49:                                # %check.exit205
	i32.const	$0=, 51
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push105=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop105, 0      # 0: down to label50
# BB#50:                                # %check.exit209
	i32.const	$0=, 52
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push106=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop106, 0      # 0: down to label51
# BB#51:                                # %check.exit213
	i32.const	$0=, 53
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push107=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop107, 0      # 0: down to label52
# BB#52:                                # %check.exit217
	i32.const	$0=, 54
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push108=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop108, 0      # 0: down to label53
# BB#53:                                # %check.exit221
	i32.const	$0=, 55
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push109=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop109, 0      # 0: down to label54
# BB#54:                                # %check.exit225
	i32.const	$0=, 56
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push110=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop110, 0      # 0: down to label55
# BB#55:                                # %check.exit229
	i32.const	$0=, 57
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push111=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop111, 0      # 0: down to label56
# BB#56:                                # %check.exit233
	i32.const	$0=, 58
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push112=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop112, 0      # 0: down to label57
# BB#57:                                # %check.exit237
	i32.const	$0=, 59
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push113=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop113, 0      # 0: down to label58
# BB#58:                                # %check.exit241
	i32.const	$0=, 60
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push114=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop114, 0      # 0: down to label59
# BB#59:                                # %check.exit245
	i32.const	$0=, 61
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push115=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop115, 0      # 0: down to label60
# BB#60:                                # %check.exit249
	i32.const	$0=, 62
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push116=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop116, 0      # 0: down to label61
# BB#61:                                # %check.exit253
	i32.const	$0=, 63
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push117=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop117, 0      # 0: down to label62
# BB#62:                                # %check.exit257
	i32.const	$0=, 64
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push118=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop118, 0      # 0: down to label63
# BB#63:                                # %check.exit261
	i32.const	$0=, 65
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push119=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop119, 0      # 0: down to label64
# BB#64:                                # %check.exit265
	i32.const	$0=, 66
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push120=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop120, 0      # 0: down to label65
# BB#65:                                # %check.exit269
	i32.const	$0=, 67
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push121=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop121, 0      # 0: down to label66
# BB#66:                                # %check.exit273
	i32.const	$0=, 68
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push122=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop122, 0      # 0: down to label67
# BB#67:                                # %check.exit277
	i32.const	$0=, 69
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push123=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop123, 0      # 0: down to label68
# BB#68:                                # %check.exit281
	i32.const	$0=, 70
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push124=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop124, 0      # 0: down to label69
# BB#69:                                # %check.exit285
	i32.const	$0=, 71
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push125=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop125, 0      # 0: down to label70
# BB#70:                                # %check.exit289
	i32.const	$0=, 72
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push126=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop126, 0      # 0: down to label71
# BB#71:                                # %check.exit293
	i32.const	$0=, 73
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push127=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop127, 0      # 0: down to label72
# BB#72:                                # %check.exit297
	i32.const	$0=, 74
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push128=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop128, 0      # 0: down to label73
# BB#73:                                # %check.exit301
	i32.const	$0=, 75
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push129=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop129, 0      # 0: down to label74
# BB#74:                                # %check.exit305
	i32.const	$0=, 76
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push130=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop130, 0      # 0: down to label75
# BB#75:                                # %check.exit309
	i32.const	$0=, 77
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push131=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop131, 0      # 0: down to label76
# BB#76:                                # %check.exit313
	i32.const	$0=, 78
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push132=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop132, 0      # 0: down to label77
# BB#77:                                # %check.exit317
	i32.const	$0=, 79
	call    	memcpy@FUNCTION, $4, $1, $0
	block
	i32.call	$push133=, memcmp@FUNCTION, $4, $1, $0
	br_if   	$pop133, 0      # 0: down to label78
# BB#78:                                # %check.exit321
	return  	$2
.LBB1_79:                               # %if.then.i320
	end_block                       # label78:
	call    	abort@FUNCTION
	unreachable
.LBB1_80:                               # %if.then.i316
	end_block                       # label77:
	call    	abort@FUNCTION
	unreachable
.LBB1_81:                               # %if.then.i312
	end_block                       # label76:
	call    	abort@FUNCTION
	unreachable
.LBB1_82:                               # %if.then.i308
	end_block                       # label75:
	call    	abort@FUNCTION
	unreachable
.LBB1_83:                               # %if.then.i304
	end_block                       # label74:
	call    	abort@FUNCTION
	unreachable
.LBB1_84:                               # %if.then.i300
	end_block                       # label73:
	call    	abort@FUNCTION
	unreachable
.LBB1_85:                               # %if.then.i296
	end_block                       # label72:
	call    	abort@FUNCTION
	unreachable
.LBB1_86:                               # %if.then.i292
	end_block                       # label71:
	call    	abort@FUNCTION
	unreachable
.LBB1_87:                               # %if.then.i288
	end_block                       # label70:
	call    	abort@FUNCTION
	unreachable
.LBB1_88:                               # %if.then.i284
	end_block                       # label69:
	call    	abort@FUNCTION
	unreachable
.LBB1_89:                               # %if.then.i280
	end_block                       # label68:
	call    	abort@FUNCTION
	unreachable
.LBB1_90:                               # %if.then.i276
	end_block                       # label67:
	call    	abort@FUNCTION
	unreachable
.LBB1_91:                               # %if.then.i272
	end_block                       # label66:
	call    	abort@FUNCTION
	unreachable
.LBB1_92:                               # %if.then.i268
	end_block                       # label65:
	call    	abort@FUNCTION
	unreachable
.LBB1_93:                               # %if.then.i264
	end_block                       # label64:
	call    	abort@FUNCTION
	unreachable
.LBB1_94:                               # %if.then.i260
	end_block                       # label63:
	call    	abort@FUNCTION
	unreachable
.LBB1_95:                               # %if.then.i256
	end_block                       # label62:
	call    	abort@FUNCTION
	unreachable
.LBB1_96:                               # %if.then.i252
	end_block                       # label61:
	call    	abort@FUNCTION
	unreachable
.LBB1_97:                               # %if.then.i248
	end_block                       # label60:
	call    	abort@FUNCTION
	unreachable
.LBB1_98:                               # %if.then.i244
	end_block                       # label59:
	call    	abort@FUNCTION
	unreachable
.LBB1_99:                               # %if.then.i240
	end_block                       # label58:
	call    	abort@FUNCTION
	unreachable
.LBB1_100:                              # %if.then.i236
	end_block                       # label57:
	call    	abort@FUNCTION
	unreachable
.LBB1_101:                              # %if.then.i232
	end_block                       # label56:
	call    	abort@FUNCTION
	unreachable
.LBB1_102:                              # %if.then.i228
	end_block                       # label55:
	call    	abort@FUNCTION
	unreachable
.LBB1_103:                              # %if.then.i224
	end_block                       # label54:
	call    	abort@FUNCTION
	unreachable
.LBB1_104:                              # %if.then.i220
	end_block                       # label53:
	call    	abort@FUNCTION
	unreachable
.LBB1_105:                              # %if.then.i216
	end_block                       # label52:
	call    	abort@FUNCTION
	unreachable
.LBB1_106:                              # %if.then.i212
	end_block                       # label51:
	call    	abort@FUNCTION
	unreachable
.LBB1_107:                              # %if.then.i208
	end_block                       # label50:
	call    	abort@FUNCTION
	unreachable
.LBB1_108:                              # %if.then.i204
	end_block                       # label49:
	call    	abort@FUNCTION
	unreachable
.LBB1_109:                              # %if.then.i200
	end_block                       # label48:
	call    	abort@FUNCTION
	unreachable
.LBB1_110:                              # %if.then.i196
	end_block                       # label47:
	call    	abort@FUNCTION
	unreachable
.LBB1_111:                              # %if.then.i192
	end_block                       # label46:
	call    	abort@FUNCTION
	unreachable
.LBB1_112:                              # %if.then.i188
	end_block                       # label45:
	call    	abort@FUNCTION
	unreachable
.LBB1_113:                              # %if.then.i184
	end_block                       # label44:
	call    	abort@FUNCTION
	unreachable
.LBB1_114:                              # %if.then.i180
	end_block                       # label43:
	call    	abort@FUNCTION
	unreachable
.LBB1_115:                              # %if.then.i176
	end_block                       # label42:
	call    	abort@FUNCTION
	unreachable
.LBB1_116:                              # %if.then.i172
	end_block                       # label41:
	call    	abort@FUNCTION
	unreachable
.LBB1_117:                              # %if.then.i168
	end_block                       # label40:
	call    	abort@FUNCTION
	unreachable
.LBB1_118:                              # %if.then.i164
	end_block                       # label39:
	call    	abort@FUNCTION
	unreachable
.LBB1_119:                              # %if.then.i160
	end_block                       # label38:
	call    	abort@FUNCTION
	unreachable
.LBB1_120:                              # %if.then.i156
	end_block                       # label37:
	call    	abort@FUNCTION
	unreachable
.LBB1_121:                              # %if.then.i152
	end_block                       # label36:
	call    	abort@FUNCTION
	unreachable
.LBB1_122:                              # %if.then.i148
	end_block                       # label35:
	call    	abort@FUNCTION
	unreachable
.LBB1_123:                              # %if.then.i144
	end_block                       # label34:
	call    	abort@FUNCTION
	unreachable
.LBB1_124:                              # %if.then.i140
	end_block                       # label33:
	call    	abort@FUNCTION
	unreachable
.LBB1_125:                              # %if.then.i136
	end_block                       # label32:
	call    	abort@FUNCTION
	unreachable
.LBB1_126:                              # %if.then.i132
	end_block                       # label31:
	call    	abort@FUNCTION
	unreachable
.LBB1_127:                              # %if.then.i128
	end_block                       # label30:
	call    	abort@FUNCTION
	unreachable
.LBB1_128:                              # %if.then.i124
	end_block                       # label29:
	call    	abort@FUNCTION
	unreachable
.LBB1_129:                              # %if.then.i120
	end_block                       # label28:
	call    	abort@FUNCTION
	unreachable
.LBB1_130:                              # %if.then.i116
	end_block                       # label27:
	call    	abort@FUNCTION
	unreachable
.LBB1_131:                              # %if.then.i112
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
.LBB1_132:                              # %if.then.i108
	end_block                       # label25:
	call    	abort@FUNCTION
	unreachable
.LBB1_133:                              # %if.then.i104
	end_block                       # label24:
	call    	abort@FUNCTION
	unreachable
.LBB1_134:                              # %if.then.i100
	end_block                       # label23:
	call    	abort@FUNCTION
	unreachable
.LBB1_135:                              # %if.then.i96
	end_block                       # label22:
	call    	abort@FUNCTION
	unreachable
.LBB1_136:                              # %if.then.i92
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
.LBB1_137:                              # %if.then.i88
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
.LBB1_138:                              # %if.then.i84
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
.LBB1_139:                              # %if.then.i80
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
.LBB1_140:                              # %if.then.i76
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB1_141:                              # %if.then.i72
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB1_142:                              # %if.then.i68
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB1_143:                              # %if.then.i64
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB1_144:                              # %if.then.i60
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB1_145:                              # %if.then.i56
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB1_146:                              # %if.then.i52
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB1_147:                              # %if.then.i48
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB1_148:                              # %if.then.i44
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_149:                              # %if.then.i40
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_150:                              # %if.then.i32
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_151:                              # %if.then.i28
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_152:                              # %if.then.i24
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_153:                              # %if.then.i16
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_154:                              # %if.then.i12
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	src                     # @src
	.type	src,@object
	.section	.bss.src,"aw",@nobits
	.globl	src
	.align	4
src:
	.skip	80
	.size	src, 80

	.hidden	dst                     # @dst
	.type	dst,@object
	.section	.bss.dst,"aw",@nobits
	.globl	dst
	.align	4
dst:
	.skip	80
	.size	dst, 80


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
