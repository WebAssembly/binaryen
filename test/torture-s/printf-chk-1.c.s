	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/printf-chk-1.c"
	.section	.text.__printf_chk,"ax",@progbits
	.hidden	__printf_chk
	.globl	__printf_chk
	.type	__printf_chk,@function
__printf_chk:                           # @__printf_chk
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	copy_local	$6=, $5
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	block
	i32.const	$push5=, 0
	i32.load	$push0=, should_optimize($pop5)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push7=, 0
	i32.const	$push1=, 1
	i32.store	$discard=, should_optimize($pop7), $pop1
	i32.const	$push6=, 0
	i32.load	$push3=, stdout($pop6)
	i32.store	$push2=, 12($5), $6
	i32.call	$push4=, vfprintf@FUNCTION, $pop3, $1, $pop2
	i32.const	$4=, 16
	i32.add 	$5=, $6, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return  	$pop4
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	__printf_chk, .Lfunc_end0-__printf_chk

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$58=, __stack_pointer
	i32.load	$58=, 0($58)
	i32.const	$59=, 16
	i32.sub 	$61=, $58, $59
	i32.const	$59=, __stack_pointer
	i32.store	$61=, 0($59), $61
	i32.const	$push0=, 0
	i32.const	$push62=, 0
	i32.store	$0=, should_optimize($pop0), $pop62
	i32.const	$push61=, .L.str
	i32.call	$discard=, __printf_chk@FUNCTION, $0, $pop61
	block
	i32.load	$push1=, should_optimize($0)
	i32.const	$push120=, 0
	i32.eq  	$push121=, $pop1, $pop120
	br_if   	0, $pop121      # 0: down to label1
# BB#1:                                 # %if.end
	i32.store	$discard=, should_optimize($0), $0
	i32.const	$push63=, .L.str
	i32.call	$0=, __printf_chk@FUNCTION, $0, $pop63
	block
	i32.const	$push2=, 5
	i32.ne  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label2
# BB#2:                                 # %if.end3
	block
	i32.const	$push64=, 0
	i32.load	$push4=, should_optimize($pop64)
	i32.const	$push122=, 0
	i32.eq  	$push123=, $pop4, $pop122
	br_if   	0, $pop123      # 0: down to label3
# BB#3:                                 # %if.end6
	i32.const	$push67=, 0
	i32.const	$push5=, 1
	i32.store	$discard=, should_optimize($pop67), $pop5
	i32.const	$push66=, .L.str.1
	i32.call	$discard=, __printf_chk@FUNCTION, $0, $pop66
	block
	i32.const	$push65=, 0
	i32.load	$push6=, should_optimize($pop65)
	i32.const	$push124=, 0
	i32.eq  	$push125=, $pop6, $pop124
	br_if   	0, $pop125      # 0: down to label4
# BB#4:                                 # %if.end10
	i32.const	$push7=, 0
	i32.const	$push69=, 0
	i32.store	$1=, should_optimize($pop7), $pop69
	i32.const	$push68=, .L.str.1
	i32.call	$0=, __printf_chk@FUNCTION, $0, $pop68
	block
	i32.const	$push8=, 6
	i32.ne  	$push9=, $0, $pop8
	br_if   	0, $pop9        # 0: down to label5
# BB#5:                                 # %if.end14
	block
	i32.load	$push10=, should_optimize($1)
	i32.const	$push126=, 0
	i32.eq  	$push127=, $pop10, $pop126
	br_if   	0, $pop127      # 0: down to label6
# BB#6:                                 # %if.end17
	i32.const	$push72=, 0
	i32.const	$push11=, 1
	i32.store	$0=, should_optimize($pop72), $pop11
	i32.const	$push71=, .L.str.2
	i32.call	$discard=, __printf_chk@FUNCTION, $0, $pop71
	block
	i32.const	$push70=, 0
	i32.load	$push12=, should_optimize($pop70)
	i32.const	$push128=, 0
	i32.eq  	$push129=, $pop12, $pop128
	br_if   	0, $pop129      # 0: down to label7
# BB#7:                                 # %if.end21
	i32.const	$push75=, 0
	i32.const	$push74=, 0
	i32.store	$discard=, should_optimize($pop75), $pop74
	i32.const	$push73=, .L.str.2
	i32.call	$1=, __printf_chk@FUNCTION, $0, $pop73
	block
	i32.ne  	$push13=, $1, $0
	br_if   	0, $pop13       # 0: down to label8
# BB#8:                                 # %if.end25
	block
	i32.const	$push76=, 0
	i32.load	$push14=, should_optimize($pop76)
	i32.const	$push130=, 0
	i32.eq  	$push131=, $pop14, $pop130
	br_if   	0, $pop131      # 0: down to label9
# BB#9:                                 # %if.end28
	i32.const	$push79=, 0
	i32.const	$push15=, 1
	i32.store	$discard=, should_optimize($pop79), $pop15
	i32.const	$push78=, .L.str.3
	i32.call	$discard=, __printf_chk@FUNCTION, $0, $pop78
	block
	i32.const	$push77=, 0
	i32.load	$push16=, should_optimize($pop77)
	i32.const	$push132=, 0
	i32.eq  	$push133=, $pop16, $pop132
	br_if   	0, $pop133      # 0: down to label10
# BB#10:                                # %if.end32
	i32.const	$push17=, 0
	i32.const	$push81=, 0
	i32.store	$1=, should_optimize($pop17), $pop81
	i32.const	$push80=, .L.str.3
	i32.call	$0=, __printf_chk@FUNCTION, $0, $pop80
	block
	br_if   	0, $0           # 0: down to label11
# BB#11:                                # %if.end36
	block
	i32.load	$push18=, should_optimize($1)
	i32.const	$push134=, 0
	i32.eq  	$push135=, $pop18, $pop134
	br_if   	0, $pop135      # 0: down to label12
# BB#12:                                # %if.end39
	i32.const	$push19=, 0
	i32.const	$push83=, 0
	i32.store	$0=, should_optimize($pop19), $pop83
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 4
	i32.sub 	$61=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$61=, 0($3), $61
	i32.const	$push20=, .L.str
	i32.store	$1=, 0($61), $pop20
	i32.const	$push82=, .L.str.4
	i32.call	$discard=, __printf_chk@FUNCTION, $0, $pop82
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 4
	i32.add 	$61=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$61=, 0($5), $61
	block
	i32.load	$push21=, should_optimize($0)
	i32.const	$push136=, 0
	i32.eq  	$push137=, $pop21, $pop136
	br_if   	0, $pop137      # 0: down to label13
# BB#13:                                # %if.end43
	i32.store	$discard=, should_optimize($0), $0
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 4
	i32.sub 	$61=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$61=, 0($7), $61
	i32.store	$discard=, 0($61), $1
	i32.const	$push84=, .L.str.4
	i32.call	$0=, __printf_chk@FUNCTION, $0, $pop84
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 4
	i32.add 	$61=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$61=, 0($9), $61
	block
	i32.const	$push22=, 5
	i32.ne  	$push23=, $0, $pop22
	br_if   	0, $pop23       # 0: down to label14
# BB#14:                                # %if.end47
	block
	i32.const	$push85=, 0
	i32.load	$push24=, should_optimize($pop85)
	i32.const	$push138=, 0
	i32.eq  	$push139=, $pop24, $pop138
	br_if   	0, $pop139      # 0: down to label15
# BB#15:                                # %if.end50
	i32.const	$push88=, 0
	i32.const	$push25=, 1
	i32.store	$discard=, should_optimize($pop88), $pop25
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 4
	i32.sub 	$61=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$61=, 0($11), $61
	i32.const	$push26=, .L.str.1
	i32.store	$0=, 0($61), $pop26
	i32.const	$push87=, .L.str.4
	i32.call	$discard=, __printf_chk@FUNCTION, $0, $pop87
	i32.const	$12=, __stack_pointer
	i32.load	$12=, 0($12)
	i32.const	$13=, 4
	i32.add 	$61=, $12, $13
	i32.const	$13=, __stack_pointer
	i32.store	$61=, 0($13), $61
	block
	i32.const	$push86=, 0
	i32.load	$push27=, should_optimize($pop86)
	i32.const	$push140=, 0
	i32.eq  	$push141=, $pop27, $pop140
	br_if   	0, $pop141      # 0: down to label16
# BB#16:                                # %if.end54
	i32.const	$push28=, 0
	i32.const	$push90=, 0
	i32.store	$1=, should_optimize($pop28), $pop90
	i32.const	$14=, __stack_pointer
	i32.load	$14=, 0($14)
	i32.const	$15=, 4
	i32.sub 	$61=, $14, $15
	i32.const	$15=, __stack_pointer
	i32.store	$61=, 0($15), $61
	i32.store	$discard=, 0($61), $0
	i32.const	$push89=, .L.str.4
	i32.call	$0=, __printf_chk@FUNCTION, $0, $pop89
	i32.const	$16=, __stack_pointer
	i32.load	$16=, 0($16)
	i32.const	$17=, 4
	i32.add 	$61=, $16, $17
	i32.const	$17=, __stack_pointer
	i32.store	$61=, 0($17), $61
	block
	i32.const	$push29=, 6
	i32.ne  	$push30=, $0, $pop29
	br_if   	0, $pop30       # 0: down to label17
# BB#17:                                # %if.end58
	block
	i32.load	$push31=, should_optimize($1)
	i32.const	$push142=, 0
	i32.eq  	$push143=, $pop31, $pop142
	br_if   	0, $pop143      # 0: down to label18
# BB#18:                                # %if.end61
	i32.const	$push93=, 0
	i32.const	$push32=, 1
	i32.store	$0=, should_optimize($pop93), $pop32
	i32.const	$18=, __stack_pointer
	i32.load	$18=, 0($18)
	i32.const	$19=, 4
	i32.sub 	$61=, $18, $19
	i32.const	$19=, __stack_pointer
	i32.store	$61=, 0($19), $61
	i32.const	$push33=, .L.str.2
	i32.store	$1=, 0($61), $pop33
	i32.const	$push92=, .L.str.4
	i32.call	$discard=, __printf_chk@FUNCTION, $0, $pop92
	i32.const	$20=, __stack_pointer
	i32.load	$20=, 0($20)
	i32.const	$21=, 4
	i32.add 	$61=, $20, $21
	i32.const	$21=, __stack_pointer
	i32.store	$61=, 0($21), $61
	block
	i32.const	$push91=, 0
	i32.load	$push34=, should_optimize($pop91)
	i32.const	$push144=, 0
	i32.eq  	$push145=, $pop34, $pop144
	br_if   	0, $pop145      # 0: down to label19
# BB#19:                                # %if.end65
	i32.const	$push96=, 0
	i32.const	$push95=, 0
	i32.store	$discard=, should_optimize($pop96), $pop95
	i32.const	$22=, __stack_pointer
	i32.load	$22=, 0($22)
	i32.const	$23=, 4
	i32.sub 	$61=, $22, $23
	i32.const	$23=, __stack_pointer
	i32.store	$61=, 0($23), $61
	i32.store	$discard=, 0($61), $1
	i32.const	$push94=, .L.str.4
	i32.call	$1=, __printf_chk@FUNCTION, $0, $pop94
	i32.const	$24=, __stack_pointer
	i32.load	$24=, 0($24)
	i32.const	$25=, 4
	i32.add 	$61=, $24, $25
	i32.const	$25=, __stack_pointer
	i32.store	$61=, 0($25), $61
	block
	i32.ne  	$push35=, $1, $0
	br_if   	0, $pop35       # 0: down to label20
# BB#20:                                # %if.end69
	block
	i32.const	$push97=, 0
	i32.load	$push36=, should_optimize($pop97)
	i32.const	$push146=, 0
	i32.eq  	$push147=, $pop36, $pop146
	br_if   	0, $pop147      # 0: down to label21
# BB#21:                                # %if.end72
	i32.const	$push100=, 0
	i32.const	$push37=, 1
	i32.store	$discard=, should_optimize($pop100), $pop37
	i32.const	$26=, __stack_pointer
	i32.load	$26=, 0($26)
	i32.const	$27=, 4
	i32.sub 	$61=, $26, $27
	i32.const	$27=, __stack_pointer
	i32.store	$61=, 0($27), $61
	i32.const	$push38=, .L.str.3
	i32.store	$0=, 0($61), $pop38
	i32.const	$push99=, .L.str.4
	i32.call	$discard=, __printf_chk@FUNCTION, $0, $pop99
	i32.const	$28=, __stack_pointer
	i32.load	$28=, 0($28)
	i32.const	$29=, 4
	i32.add 	$61=, $28, $29
	i32.const	$29=, __stack_pointer
	i32.store	$61=, 0($29), $61
	block
	i32.const	$push98=, 0
	i32.load	$push39=, should_optimize($pop98)
	i32.const	$push148=, 0
	i32.eq  	$push149=, $pop39, $pop148
	br_if   	0, $pop149      # 0: down to label22
# BB#22:                                # %if.end76
	i32.const	$push40=, 0
	i32.const	$push102=, 0
	i32.store	$1=, should_optimize($pop40), $pop102
	i32.const	$30=, __stack_pointer
	i32.load	$30=, 0($30)
	i32.const	$31=, 4
	i32.sub 	$61=, $30, $31
	i32.const	$31=, __stack_pointer
	i32.store	$61=, 0($31), $61
	i32.store	$discard=, 0($61), $0
	i32.const	$push101=, .L.str.4
	i32.call	$0=, __printf_chk@FUNCTION, $0, $pop101
	i32.const	$32=, __stack_pointer
	i32.load	$32=, 0($32)
	i32.const	$33=, 4
	i32.add 	$61=, $32, $33
	i32.const	$33=, __stack_pointer
	i32.store	$61=, 0($33), $61
	block
	br_if   	0, $0           # 0: down to label23
# BB#23:                                # %if.end80
	block
	i32.load	$push41=, should_optimize($1)
	i32.const	$push150=, 0
	i32.eq  	$push151=, $pop41, $pop150
	br_if   	0, $pop151      # 0: down to label24
# BB#24:                                # %if.end83
	i32.const	$push105=, 0
	i32.const	$push42=, 1
	i32.store	$0=, should_optimize($pop105), $pop42
	i32.const	$34=, __stack_pointer
	i32.load	$34=, 0($34)
	i32.const	$35=, 4
	i32.sub 	$61=, $34, $35
	i32.const	$35=, __stack_pointer
	i32.store	$61=, 0($35), $61
	i32.const	$push43=, 120
	i32.store	$1=, 0($61), $pop43
	i32.const	$push104=, .L.str.5
	i32.call	$discard=, __printf_chk@FUNCTION, $0, $pop104
	i32.const	$36=, __stack_pointer
	i32.load	$36=, 0($36)
	i32.const	$37=, 4
	i32.add 	$61=, $36, $37
	i32.const	$37=, __stack_pointer
	i32.store	$61=, 0($37), $61
	block
	i32.const	$push103=, 0
	i32.load	$push44=, should_optimize($pop103)
	i32.const	$push152=, 0
	i32.eq  	$push153=, $pop44, $pop152
	br_if   	0, $pop153      # 0: down to label25
# BB#25:                                # %if.end87
	i32.const	$push108=, 0
	i32.const	$push107=, 0
	i32.store	$discard=, should_optimize($pop108), $pop107
	i32.const	$38=, __stack_pointer
	i32.load	$38=, 0($38)
	i32.const	$39=, 4
	i32.sub 	$61=, $38, $39
	i32.const	$39=, __stack_pointer
	i32.store	$61=, 0($39), $61
	i32.store	$discard=, 0($61), $1
	i32.const	$push106=, .L.str.5
	i32.call	$1=, __printf_chk@FUNCTION, $0, $pop106
	i32.const	$40=, __stack_pointer
	i32.load	$40=, 0($40)
	i32.const	$41=, 4
	i32.add 	$61=, $40, $41
	i32.const	$41=, __stack_pointer
	i32.store	$61=, 0($41), $61
	block
	i32.ne  	$push45=, $1, $0
	br_if   	0, $pop45       # 0: down to label26
# BB#26:                                # %if.end91
	block
	i32.const	$push109=, 0
	i32.load	$push46=, should_optimize($pop109)
	i32.const	$push154=, 0
	i32.eq  	$push155=, $pop46, $pop154
	br_if   	0, $pop155      # 0: down to label27
# BB#27:                                # %if.end94
	i32.const	$push112=, 0
	i32.const	$push47=, 1
	i32.store	$discard=, should_optimize($pop112), $pop47
	i32.const	$42=, __stack_pointer
	i32.load	$42=, 0($42)
	i32.const	$43=, 4
	i32.sub 	$61=, $42, $43
	i32.const	$43=, __stack_pointer
	i32.store	$61=, 0($43), $61
	i32.const	$push48=, .L.str.1
	i32.store	$0=, 0($61), $pop48
	i32.const	$push111=, .L.str.6
	i32.call	$discard=, __printf_chk@FUNCTION, $0, $pop111
	i32.const	$44=, __stack_pointer
	i32.load	$44=, 0($44)
	i32.const	$45=, 4
	i32.add 	$61=, $44, $45
	i32.const	$45=, __stack_pointer
	i32.store	$61=, 0($45), $61
	block
	i32.const	$push110=, 0
	i32.load	$push49=, should_optimize($pop110)
	i32.const	$push156=, 0
	i32.eq  	$push157=, $pop49, $pop156
	br_if   	0, $pop157      # 0: down to label28
# BB#28:                                # %if.end98
	i32.const	$push50=, 0
	i32.const	$push114=, 0
	i32.store	$1=, should_optimize($pop50), $pop114
	i32.const	$46=, __stack_pointer
	i32.load	$46=, 0($46)
	i32.const	$47=, 4
	i32.sub 	$61=, $46, $47
	i32.const	$47=, __stack_pointer
	i32.store	$61=, 0($47), $61
	i32.store	$discard=, 0($61), $0
	i32.const	$push113=, .L.str.6
	i32.call	$0=, __printf_chk@FUNCTION, $0, $pop113
	i32.const	$48=, __stack_pointer
	i32.load	$48=, 0($48)
	i32.const	$49=, 4
	i32.add 	$61=, $48, $49
	i32.const	$49=, __stack_pointer
	i32.store	$61=, 0($49), $61
	block
	i32.const	$push51=, 7
	i32.ne  	$push52=, $0, $pop51
	br_if   	0, $pop52       # 0: down to label29
# BB#29:                                # %if.end102
	block
	i32.load	$push53=, should_optimize($1)
	i32.const	$push158=, 0
	i32.eq  	$push159=, $pop53, $pop158
	br_if   	0, $pop159      # 0: down to label30
# BB#30:                                # %if.end105
	i32.const	$50=, __stack_pointer
	i32.load	$50=, 0($50)
	i32.const	$51=, 4
	i32.sub 	$61=, $50, $51
	i32.const	$51=, __stack_pointer
	i32.store	$61=, 0($51), $61
	i32.const	$push54=, 0
	i32.const	$push116=, 0
	i32.store	$push55=, should_optimize($pop54), $pop116
	i32.store	$0=, 0($61), $pop55
	i32.const	$push115=, .L.str.7
	i32.call	$discard=, __printf_chk@FUNCTION, $0, $pop115
	i32.const	$52=, __stack_pointer
	i32.load	$52=, 0($52)
	i32.const	$53=, 4
	i32.add 	$61=, $52, $53
	i32.const	$53=, __stack_pointer
	i32.store	$61=, 0($53), $61
	block
	i32.load	$push56=, should_optimize($0)
	i32.const	$push160=, 0
	i32.eq  	$push161=, $pop56, $pop160
	br_if   	0, $pop161      # 0: down to label31
# BB#31:                                # %if.end109
	i32.const	$54=, __stack_pointer
	i32.load	$54=, 0($54)
	i32.const	$55=, 4
	i32.sub 	$61=, $54, $55
	i32.const	$55=, __stack_pointer
	i32.store	$61=, 0($55), $61
	i32.store	$push57=, should_optimize($0), $0
	i32.store	$discard=, 0($61), $pop57
	i32.const	$push117=, .L.str.7
	i32.call	$0=, __printf_chk@FUNCTION, $0, $pop117
	i32.const	$56=, __stack_pointer
	i32.load	$56=, 0($56)
	i32.const	$57=, 4
	i32.add 	$61=, $56, $57
	i32.const	$57=, __stack_pointer
	i32.store	$61=, 0($57), $61
	block
	i32.const	$push58=, 2
	i32.ne  	$push59=, $0, $pop58
	br_if   	0, $pop59       # 0: down to label32
# BB#32:                                # %if.end113
	block
	i32.const	$push118=, 0
	i32.load	$push60=, should_optimize($pop118)
	i32.const	$push162=, 0
	i32.eq  	$push163=, $pop60, $pop162
	br_if   	0, $pop163      # 0: down to label33
# BB#33:                                # %if.end116
	i32.const	$push119=, 0
	i32.const	$60=, 16
	i32.add 	$61=, $61, $60
	i32.const	$60=, __stack_pointer
	i32.store	$61=, 0($60), $61
	return  	$pop119
.LBB1_34:                               # %if.then115
	end_block                       # label33:
	call    	abort@FUNCTION
	unreachable
.LBB1_35:                               # %if.then112
	end_block                       # label32:
	call    	abort@FUNCTION
	unreachable
.LBB1_36:                               # %if.then108
	end_block                       # label31:
	call    	abort@FUNCTION
	unreachable
.LBB1_37:                               # %if.then104
	end_block                       # label30:
	call    	abort@FUNCTION
	unreachable
.LBB1_38:                               # %if.then101
	end_block                       # label29:
	call    	abort@FUNCTION
	unreachable
.LBB1_39:                               # %if.then97
	end_block                       # label28:
	call    	abort@FUNCTION
	unreachable
.LBB1_40:                               # %if.then93
	end_block                       # label27:
	call    	abort@FUNCTION
	unreachable
.LBB1_41:                               # %if.then90
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
.LBB1_42:                               # %if.then86
	end_block                       # label25:
	call    	abort@FUNCTION
	unreachable
.LBB1_43:                               # %if.then82
	end_block                       # label24:
	call    	abort@FUNCTION
	unreachable
.LBB1_44:                               # %if.then79
	end_block                       # label23:
	call    	abort@FUNCTION
	unreachable
.LBB1_45:                               # %if.then75
	end_block                       # label22:
	call    	abort@FUNCTION
	unreachable
.LBB1_46:                               # %if.then71
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
.LBB1_47:                               # %if.then68
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
.LBB1_48:                               # %if.then64
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
.LBB1_49:                               # %if.then60
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
.LBB1_50:                               # %if.then57
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB1_51:                               # %if.then53
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB1_52:                               # %if.then49
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB1_53:                               # %if.then46
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB1_54:                               # %if.then42
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB1_55:                               # %if.then38
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB1_56:                               # %if.then35
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB1_57:                               # %if.then31
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB1_58:                               # %if.then27
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_59:                               # %if.then24
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_60:                               # %if.then20
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_61:                               # %if.then16
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_62:                               # %if.then13
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_63:                               # %if.then9
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_64:                               # %if.then5
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_65:                               # %if.then2
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_66:                               # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	should_optimize         # @should_optimize
	.type	should_optimize,@object
	.section	.bss.should_optimize,"aw",@nobits
	.globl	should_optimize
	.p2align	2
should_optimize:
	.int32	0                       # 0x0
	.size	should_optimize, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"hello"
	.size	.L.str, 6

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"hello\n"
	.size	.L.str.1, 7

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"a"
	.size	.L.str.2, 2

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.skip	1
	.size	.L.str.3, 1

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"%s"
	.size	.L.str.4, 3

	.type	.L.str.5,@object        # @.str.5
.L.str.5:
	.asciz	"%c"
	.size	.L.str.5, 3

	.type	.L.str.6,@object        # @.str.6
.L.str.6:
	.asciz	"%s\n"
	.size	.L.str.6, 4

	.type	.L.str.7,@object        # @.str.7
.L.str.7:
	.asciz	"%d\n"
	.size	.L.str.7, 4


	.ident	"clang version 3.9.0 "
