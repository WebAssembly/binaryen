	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/fprintf-chk-1.c"
	.section	.text.__fprintf_chk,"ax",@progbits
	.hidden	__fprintf_chk
	.globl	__fprintf_chk
	.type	__fprintf_chk,@function
__fprintf_chk:                          # @__fprintf_chk
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	copy_local	$7=, $6
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	block
	i32.const	$push4=, 0
	i32.load	$push0=, should_optimize($pop4)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, 0
	i32.const	$push1=, 1
	i32.store	$discard=, should_optimize($pop5), $pop1
	i32.store	$push2=, 12($6), $7
	i32.call	$push3=, vfprintf@FUNCTION, $0, $2, $pop2
	i32.const	$5=, 16
	i32.add 	$6=, $7, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return  	$pop3
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	__fprintf_chk, .Lfunc_end0-__fprintf_chk

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$59=, __stack_pointer
	i32.load	$59=, 0($59)
	i32.const	$60=, 16
	i32.sub 	$62=, $59, $60
	i32.const	$60=, __stack_pointer
	i32.store	$62=, 0($60), $62
	i32.const	$push82=, 0
	i32.const	$push0=, 1
	i32.store	$discard=, should_optimize($pop82), $pop0
	i32.const	$push81=, 0
	i32.load	$push1=, stdout($pop81)
	i32.const	$push80=, .L.str
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop1, $0, $pop80
	block
	i32.const	$push79=, 0
	i32.load	$push2=, should_optimize($pop79)
	i32.const	$push161=, 0
	i32.eq  	$push162=, $pop2, $pop161
	br_if   	0, $pop162      # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push85=, 0
	i32.const	$push84=, 0
	i32.store	$push3=, should_optimize($pop85), $pop84
	i32.load	$push4=, stdout($pop3)
	i32.const	$push83=, .L.str
	i32.call	$0=, __fprintf_chk@FUNCTION, $pop4, $0, $pop83
	block
	i32.const	$push5=, 5
	i32.ne  	$push6=, $0, $pop5
	br_if   	0, $pop6        # 0: down to label2
# BB#2:                                 # %if.end3
	block
	i32.const	$push86=, 0
	i32.load	$push7=, should_optimize($pop86)
	i32.const	$push163=, 0
	i32.eq  	$push164=, $pop7, $pop163
	br_if   	0, $pop164      # 0: down to label3
# BB#3:                                 # %if.end6
	i32.const	$push90=, 0
	i32.const	$push8=, 1
	i32.store	$discard=, should_optimize($pop90), $pop8
	i32.const	$push89=, 0
	i32.load	$push9=, stdout($pop89)
	i32.const	$push88=, .L.str.1
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop9, $0, $pop88
	block
	i32.const	$push87=, 0
	i32.load	$push10=, should_optimize($pop87)
	i32.const	$push165=, 0
	i32.eq  	$push166=, $pop10, $pop165
	br_if   	0, $pop166      # 0: down to label4
# BB#4:                                 # %if.end10
	i32.const	$push11=, 0
	i32.const	$push93=, 0
	i32.store	$push12=, should_optimize($pop11), $pop93
	tee_local	$push92=, $1=, $pop12
	i32.load	$push13=, stdout($pop92)
	i32.const	$push91=, .L.str.1
	i32.call	$0=, __fprintf_chk@FUNCTION, $pop13, $0, $pop91
	block
	i32.const	$push14=, 6
	i32.ne  	$push15=, $0, $pop14
	br_if   	0, $pop15       # 0: down to label5
# BB#5:                                 # %if.end14
	block
	i32.load	$push16=, should_optimize($1)
	i32.const	$push167=, 0
	i32.eq  	$push168=, $pop16, $pop167
	br_if   	0, $pop168      # 0: down to label6
# BB#6:                                 # %if.end17
	i32.const	$push97=, 0
	i32.const	$push17=, 1
	i32.store	$0=, should_optimize($pop97), $pop17
	i32.const	$push96=, 0
	i32.load	$push18=, stdout($pop96)
	i32.const	$push95=, .L.str.2
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop18, $0, $pop95
	block
	i32.const	$push94=, 0
	i32.load	$push19=, should_optimize($pop94)
	i32.const	$push169=, 0
	i32.eq  	$push170=, $pop19, $pop169
	br_if   	0, $pop170      # 0: down to label7
# BB#7:                                 # %if.end21
	i32.const	$push100=, 0
	i32.const	$push99=, 0
	i32.store	$push20=, should_optimize($pop100), $pop99
	i32.load	$push21=, stdout($pop20)
	i32.const	$push98=, .L.str.2
	i32.call	$1=, __fprintf_chk@FUNCTION, $pop21, $0, $pop98
	block
	i32.ne  	$push22=, $1, $0
	br_if   	0, $pop22       # 0: down to label8
# BB#8:                                 # %if.end25
	block
	i32.const	$push101=, 0
	i32.load	$push23=, should_optimize($pop101)
	i32.const	$push171=, 0
	i32.eq  	$push172=, $pop23, $pop171
	br_if   	0, $pop172      # 0: down to label9
# BB#9:                                 # %if.end28
	i32.const	$push105=, 0
	i32.const	$push24=, 1
	i32.store	$discard=, should_optimize($pop105), $pop24
	i32.const	$push104=, 0
	i32.load	$push25=, stdout($pop104)
	i32.const	$push103=, .L.str.3
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop25, $0, $pop103
	block
	i32.const	$push102=, 0
	i32.load	$push26=, should_optimize($pop102)
	i32.const	$push173=, 0
	i32.eq  	$push174=, $pop26, $pop173
	br_if   	0, $pop174      # 0: down to label10
# BB#10:                                # %if.end32
	i32.const	$push27=, 0
	i32.const	$push108=, 0
	i32.store	$push28=, should_optimize($pop27), $pop108
	tee_local	$push107=, $1=, $pop28
	i32.load	$push29=, stdout($pop107)
	i32.const	$push106=, .L.str.3
	i32.call	$0=, __fprintf_chk@FUNCTION, $pop29, $0, $pop106
	block
	br_if   	0, $0           # 0: down to label11
# BB#11:                                # %if.end36
	block
	i32.load	$push30=, should_optimize($1)
	i32.const	$push175=, 0
	i32.eq  	$push176=, $pop30, $pop175
	br_if   	0, $pop176      # 0: down to label12
# BB#12:                                # %if.end39
	i32.const	$push112=, 0
	i32.const	$push31=, 1
	i32.store	$discard=, should_optimize($pop112), $pop31
	i32.const	$push111=, 0
	i32.load	$0=, stdout($pop111)
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 4
	i32.sub 	$62=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$62=, 0($4), $62
	i32.const	$push32=, .L.str
	i32.store	$1=, 0($62), $pop32
	i32.const	$push110=, .L.str.4
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop110
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 4
	i32.add 	$62=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$62=, 0($6), $62
	block
	i32.const	$push109=, 0
	i32.load	$push33=, should_optimize($pop109)
	i32.const	$push177=, 0
	i32.eq  	$push178=, $pop33, $pop177
	br_if   	0, $pop178      # 0: down to label13
# BB#13:                                # %if.end43
	i32.const	$push115=, 0
	i32.const	$push114=, 0
	i32.store	$push34=, should_optimize($pop115), $pop114
	i32.load	$0=, stdout($pop34)
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 4
	i32.sub 	$62=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$62=, 0($8), $62
	i32.store	$discard=, 0($62), $1
	i32.const	$push113=, .L.str.4
	i32.call	$0=, __fprintf_chk@FUNCTION, $0, $0, $pop113
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 4
	i32.add 	$62=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$62=, 0($10), $62
	block
	i32.const	$push35=, 5
	i32.ne  	$push36=, $0, $pop35
	br_if   	0, $pop36       # 0: down to label14
# BB#14:                                # %if.end47
	block
	i32.const	$push116=, 0
	i32.load	$push37=, should_optimize($pop116)
	i32.const	$push179=, 0
	i32.eq  	$push180=, $pop37, $pop179
	br_if   	0, $pop180      # 0: down to label15
# BB#15:                                # %if.end50
	i32.const	$push120=, 0
	i32.const	$push38=, 1
	i32.store	$discard=, should_optimize($pop120), $pop38
	i32.const	$push119=, 0
	i32.load	$0=, stdout($pop119)
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 4
	i32.sub 	$62=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$62=, 0($12), $62
	i32.const	$push39=, .L.str.1
	i32.store	$1=, 0($62), $pop39
	i32.const	$push118=, .L.str.4
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop118
	i32.const	$13=, __stack_pointer
	i32.load	$13=, 0($13)
	i32.const	$14=, 4
	i32.add 	$62=, $13, $14
	i32.const	$14=, __stack_pointer
	i32.store	$62=, 0($14), $62
	block
	i32.const	$push117=, 0
	i32.load	$push40=, should_optimize($pop117)
	i32.const	$push181=, 0
	i32.eq  	$push182=, $pop40, $pop181
	br_if   	0, $pop182      # 0: down to label16
# BB#16:                                # %if.end54
	i32.const	$push41=, 0
	i32.const	$push123=, 0
	i32.store	$push42=, should_optimize($pop41), $pop123
	tee_local	$push122=, $2=, $pop42
	i32.load	$0=, stdout($pop122)
	i32.const	$15=, __stack_pointer
	i32.load	$15=, 0($15)
	i32.const	$16=, 4
	i32.sub 	$62=, $15, $16
	i32.const	$16=, __stack_pointer
	i32.store	$62=, 0($16), $62
	i32.store	$discard=, 0($62), $1
	i32.const	$push121=, .L.str.4
	i32.call	$0=, __fprintf_chk@FUNCTION, $0, $0, $pop121
	i32.const	$17=, __stack_pointer
	i32.load	$17=, 0($17)
	i32.const	$18=, 4
	i32.add 	$62=, $17, $18
	i32.const	$18=, __stack_pointer
	i32.store	$62=, 0($18), $62
	block
	i32.const	$push43=, 6
	i32.ne  	$push44=, $0, $pop43
	br_if   	0, $pop44       # 0: down to label17
# BB#17:                                # %if.end58
	block
	i32.load	$push45=, should_optimize($2)
	i32.const	$push183=, 0
	i32.eq  	$push184=, $pop45, $pop183
	br_if   	0, $pop184      # 0: down to label18
# BB#18:                                # %if.end61
	i32.const	$push127=, 0
	i32.const	$push46=, 1
	i32.store	$1=, should_optimize($pop127), $pop46
	i32.const	$push126=, 0
	i32.load	$0=, stdout($pop126)
	i32.const	$19=, __stack_pointer
	i32.load	$19=, 0($19)
	i32.const	$20=, 4
	i32.sub 	$62=, $19, $20
	i32.const	$20=, __stack_pointer
	i32.store	$62=, 0($20), $62
	i32.const	$push47=, .L.str.2
	i32.store	$2=, 0($62), $pop47
	i32.const	$push125=, .L.str.4
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop125
	i32.const	$21=, __stack_pointer
	i32.load	$21=, 0($21)
	i32.const	$22=, 4
	i32.add 	$62=, $21, $22
	i32.const	$22=, __stack_pointer
	i32.store	$62=, 0($22), $62
	block
	i32.const	$push124=, 0
	i32.load	$push48=, should_optimize($pop124)
	i32.const	$push185=, 0
	i32.eq  	$push186=, $pop48, $pop185
	br_if   	0, $pop186      # 0: down to label19
# BB#19:                                # %if.end65
	i32.const	$push130=, 0
	i32.const	$push129=, 0
	i32.store	$push49=, should_optimize($pop130), $pop129
	i32.load	$0=, stdout($pop49)
	i32.const	$23=, __stack_pointer
	i32.load	$23=, 0($23)
	i32.const	$24=, 4
	i32.sub 	$62=, $23, $24
	i32.const	$24=, __stack_pointer
	i32.store	$62=, 0($24), $62
	i32.store	$discard=, 0($62), $2
	i32.const	$push128=, .L.str.4
	i32.call	$0=, __fprintf_chk@FUNCTION, $0, $0, $pop128
	i32.const	$25=, __stack_pointer
	i32.load	$25=, 0($25)
	i32.const	$26=, 4
	i32.add 	$62=, $25, $26
	i32.const	$26=, __stack_pointer
	i32.store	$62=, 0($26), $62
	block
	i32.ne  	$push50=, $0, $1
	br_if   	0, $pop50       # 0: down to label20
# BB#20:                                # %if.end69
	block
	i32.const	$push131=, 0
	i32.load	$push51=, should_optimize($pop131)
	i32.const	$push187=, 0
	i32.eq  	$push188=, $pop51, $pop187
	br_if   	0, $pop188      # 0: down to label21
# BB#21:                                # %if.end72
	i32.const	$push135=, 0
	i32.const	$push52=, 1
	i32.store	$discard=, should_optimize($pop135), $pop52
	i32.const	$push134=, 0
	i32.load	$0=, stdout($pop134)
	i32.const	$27=, __stack_pointer
	i32.load	$27=, 0($27)
	i32.const	$28=, 4
	i32.sub 	$62=, $27, $28
	i32.const	$28=, __stack_pointer
	i32.store	$62=, 0($28), $62
	i32.const	$push53=, .L.str.3
	i32.store	$1=, 0($62), $pop53
	i32.const	$push133=, .L.str.4
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop133
	i32.const	$29=, __stack_pointer
	i32.load	$29=, 0($29)
	i32.const	$30=, 4
	i32.add 	$62=, $29, $30
	i32.const	$30=, __stack_pointer
	i32.store	$62=, 0($30), $62
	block
	i32.const	$push132=, 0
	i32.load	$push54=, should_optimize($pop132)
	i32.const	$push189=, 0
	i32.eq  	$push190=, $pop54, $pop189
	br_if   	0, $pop190      # 0: down to label22
# BB#22:                                # %if.end76
	i32.const	$push55=, 0
	i32.const	$push138=, 0
	i32.store	$push56=, should_optimize($pop55), $pop138
	tee_local	$push137=, $2=, $pop56
	i32.load	$0=, stdout($pop137)
	i32.const	$31=, __stack_pointer
	i32.load	$31=, 0($31)
	i32.const	$32=, 4
	i32.sub 	$62=, $31, $32
	i32.const	$32=, __stack_pointer
	i32.store	$62=, 0($32), $62
	i32.store	$discard=, 0($62), $1
	i32.const	$push136=, .L.str.4
	i32.call	$0=, __fprintf_chk@FUNCTION, $0, $0, $pop136
	i32.const	$33=, __stack_pointer
	i32.load	$33=, 0($33)
	i32.const	$34=, 4
	i32.add 	$62=, $33, $34
	i32.const	$34=, __stack_pointer
	i32.store	$62=, 0($34), $62
	block
	br_if   	0, $0           # 0: down to label23
# BB#23:                                # %if.end80
	block
	i32.load	$push57=, should_optimize($2)
	i32.const	$push191=, 0
	i32.eq  	$push192=, $pop57, $pop191
	br_if   	0, $pop192      # 0: down to label24
# BB#24:                                # %if.end83
	i32.const	$push142=, 0
	i32.const	$push58=, 1
	i32.store	$1=, should_optimize($pop142), $pop58
	i32.const	$push141=, 0
	i32.load	$0=, stdout($pop141)
	i32.const	$35=, __stack_pointer
	i32.load	$35=, 0($35)
	i32.const	$36=, 4
	i32.sub 	$62=, $35, $36
	i32.const	$36=, __stack_pointer
	i32.store	$62=, 0($36), $62
	i32.const	$push59=, 120
	i32.store	$2=, 0($62), $pop59
	i32.const	$push140=, .L.str.5
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop140
	i32.const	$37=, __stack_pointer
	i32.load	$37=, 0($37)
	i32.const	$38=, 4
	i32.add 	$62=, $37, $38
	i32.const	$38=, __stack_pointer
	i32.store	$62=, 0($38), $62
	block
	i32.const	$push139=, 0
	i32.load	$push60=, should_optimize($pop139)
	i32.const	$push193=, 0
	i32.eq  	$push194=, $pop60, $pop193
	br_if   	0, $pop194      # 0: down to label25
# BB#25:                                # %if.end87
	i32.const	$push145=, 0
	i32.const	$push144=, 0
	i32.store	$push61=, should_optimize($pop145), $pop144
	i32.load	$0=, stdout($pop61)
	i32.const	$39=, __stack_pointer
	i32.load	$39=, 0($39)
	i32.const	$40=, 4
	i32.sub 	$62=, $39, $40
	i32.const	$40=, __stack_pointer
	i32.store	$62=, 0($40), $62
	i32.store	$discard=, 0($62), $2
	i32.const	$push143=, .L.str.5
	i32.call	$0=, __fprintf_chk@FUNCTION, $0, $0, $pop143
	i32.const	$41=, __stack_pointer
	i32.load	$41=, 0($41)
	i32.const	$42=, 4
	i32.add 	$62=, $41, $42
	i32.const	$42=, __stack_pointer
	i32.store	$62=, 0($42), $62
	block
	i32.ne  	$push62=, $0, $1
	br_if   	0, $pop62       # 0: down to label26
# BB#26:                                # %if.end91
	block
	i32.const	$push146=, 0
	i32.load	$push63=, should_optimize($pop146)
	i32.const	$push195=, 0
	i32.eq  	$push196=, $pop63, $pop195
	br_if   	0, $pop196      # 0: down to label27
# BB#27:                                # %if.end94
	i32.const	$push150=, 0
	i32.const	$push149=, 0
	i32.store	$push64=, should_optimize($pop150), $pop149
	tee_local	$push148=, $0=, $pop64
	i32.load	$1=, stdout($pop148)
	i32.const	$43=, __stack_pointer
	i32.load	$43=, 0($43)
	i32.const	$44=, 4
	i32.sub 	$62=, $43, $44
	i32.const	$44=, __stack_pointer
	i32.store	$62=, 0($44), $62
	i32.const	$push65=, .L.str.1
	i32.store	$2=, 0($62), $pop65
	i32.const	$push147=, .L.str.6
	i32.call	$discard=, __fprintf_chk@FUNCTION, $1, $0, $pop147
	i32.const	$45=, __stack_pointer
	i32.load	$45=, 0($45)
	i32.const	$46=, 4
	i32.add 	$62=, $45, $46
	i32.const	$46=, __stack_pointer
	i32.store	$62=, 0($46), $62
	block
	i32.load	$push66=, should_optimize($0)
	i32.const	$push197=, 0
	i32.eq  	$push198=, $pop66, $pop197
	br_if   	0, $pop198      # 0: down to label28
# BB#28:                                # %if.end98
	i32.const	$push67=, 0
	i32.const	$push153=, 0
	i32.store	$push68=, should_optimize($pop67), $pop153
	tee_local	$push152=, $1=, $pop68
	i32.load	$0=, stdout($pop152)
	i32.const	$47=, __stack_pointer
	i32.load	$47=, 0($47)
	i32.const	$48=, 4
	i32.sub 	$62=, $47, $48
	i32.const	$48=, __stack_pointer
	i32.store	$62=, 0($48), $62
	i32.store	$discard=, 0($62), $2
	i32.const	$push151=, .L.str.6
	i32.call	$0=, __fprintf_chk@FUNCTION, $0, $0, $pop151
	i32.const	$49=, __stack_pointer
	i32.load	$49=, 0($49)
	i32.const	$50=, 4
	i32.add 	$62=, $49, $50
	i32.const	$50=, __stack_pointer
	i32.store	$62=, 0($50), $62
	block
	i32.const	$push69=, 7
	i32.ne  	$push70=, $0, $pop69
	br_if   	0, $pop70       # 0: down to label29
# BB#29:                                # %if.end102
	block
	i32.load	$push71=, should_optimize($1)
	i32.const	$push199=, 0
	i32.eq  	$push200=, $pop71, $pop199
	br_if   	0, $pop200      # 0: down to label30
# BB#30:                                # %if.end105
	i32.const	$push72=, 0
	i32.const	$push156=, 0
	i32.store	$push73=, should_optimize($pop72), $pop156
	tee_local	$push155=, $0=, $pop73
	i32.load	$1=, stdout($pop155)
	i32.const	$51=, __stack_pointer
	i32.load	$51=, 0($51)
	i32.const	$52=, 4
	i32.sub 	$62=, $51, $52
	i32.const	$52=, __stack_pointer
	i32.store	$62=, 0($52), $62
	i32.store	$discard=, 0($62), $0
	i32.const	$push154=, .L.str.7
	i32.call	$discard=, __fprintf_chk@FUNCTION, $1, $0, $pop154
	i32.const	$53=, __stack_pointer
	i32.load	$53=, 0($53)
	i32.const	$54=, 4
	i32.add 	$62=, $53, $54
	i32.const	$54=, __stack_pointer
	i32.store	$62=, 0($54), $62
	block
	i32.load	$push74=, should_optimize($0)
	i32.const	$push201=, 0
	i32.eq  	$push202=, $pop74, $pop201
	br_if   	0, $pop202      # 0: down to label31
# BB#31:                                # %if.end109
	i32.store	$push75=, should_optimize($0), $0
	tee_local	$push158=, $0=, $pop75
	i32.load	$1=, stdout($pop158)
	i32.const	$55=, __stack_pointer
	i32.load	$55=, 0($55)
	i32.const	$56=, 4
	i32.sub 	$62=, $55, $56
	i32.const	$56=, __stack_pointer
	i32.store	$62=, 0($56), $62
	i32.store	$discard=, 0($62), $0
	i32.const	$push157=, .L.str.7
	i32.call	$0=, __fprintf_chk@FUNCTION, $1, $0, $pop157
	i32.const	$57=, __stack_pointer
	i32.load	$57=, 0($57)
	i32.const	$58=, 4
	i32.add 	$62=, $57, $58
	i32.const	$58=, __stack_pointer
	i32.store	$62=, 0($58), $62
	block
	i32.const	$push76=, 2
	i32.ne  	$push77=, $0, $pop76
	br_if   	0, $pop77       # 0: down to label32
# BB#32:                                # %if.end113
	block
	i32.const	$push159=, 0
	i32.load	$push78=, should_optimize($pop159)
	i32.const	$push203=, 0
	i32.eq  	$push204=, $pop78, $pop203
	br_if   	0, $pop204      # 0: down to label33
# BB#33:                                # %if.end116
	i32.const	$push160=, 0
	i32.const	$61=, 16
	i32.add 	$62=, $62, $61
	i32.const	$61=, __stack_pointer
	i32.store	$62=, 0($61), $62
	return  	$pop160
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
