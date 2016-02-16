	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/stdarg-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$discard=, 12($5), $1
	block
	i32.const	$push0=, 5
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %sw.bb
	i32.load	$push2=, 12($5)
	i32.const	$push3=, 3
	i32.add 	$push4=, $pop2, $pop3
	i32.const	$push5=, -4
	i32.and 	$push11=, $pop4, $pop5
	tee_local	$push10=, $0=, $pop11
	i32.const	$push6=, 4
	i32.add 	$push7=, $pop10, $pop6
	i32.store	$discard=, 12($5), $pop7
	i32.const	$push9=, 0
	i32.load	$push8=, 0($0)
	i32.store	$discard=, foo_arg($pop9), $pop8
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
.LBB0_2:                                # %sw.default
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32, i32, i64, i32
# BB#0:                                 # %entry
	block
	block
	block
	i32.const	$push0=, 16392
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label3
# BB#1:                                 # %entry
	i32.const	$push2=, 16390
	i32.ne  	$push3=, $0, $pop2
	br_if   	1, $pop3        # 1: down to label2
# BB#2:                                 # %if.then
	i32.const	$push54=, 0
	i32.const	$push53=, 0
	i32.load	$push32=, gap($pop53)
	i32.const	$push33=, 7
	i32.add 	$push34=, $pop32, $pop33
	i32.const	$push35=, -8
	i32.and 	$push52=, $pop34, $pop35
	tee_local	$push51=, $1=, $pop52
	i32.const	$push36=, 8
	i32.add 	$push37=, $pop51, $pop36
	i32.store	$discard=, gap($pop54), $pop37
	block
	f64.load	$push38=, 0($1)
	f64.const	$push39=, 0x1.1p4
	f64.ne  	$push40=, $pop38, $pop39
	br_if   	0, $pop40       # 0: down to label4
# BB#3:                                 # %lor.lhs.false
	i32.const	$push58=, 0
	i32.const	$push57=, 0
	i32.load	$push41=, gap($pop57)
	i32.const	$push42=, 3
	i32.add 	$push43=, $pop41, $pop42
	i32.const	$push44=, -4
	i32.and 	$push56=, $pop43, $pop44
	tee_local	$push55=, $1=, $pop56
	i32.const	$push45=, 4
	i32.add 	$push46=, $pop55, $pop45
	i32.store	$discard=, gap($pop58), $pop46
	i32.load	$push47=, 0($1)
	i32.const	$push48=, 129
	i32.eq  	$push49=, $pop47, $pop48
	br_if   	2, $pop49       # 2: down to label2
.LBB1_4:                                # %if.then3
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_5:                                # %if.then5
	end_block                       # label3:
	i32.const	$push62=, 0
	i32.load	$1=, pap($pop62)
	i32.load	$push4=, 0($1)
	i32.const	$push5=, 7
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push7=, -8
	i32.and 	$push61=, $pop6, $pop7
	tee_local	$push60=, $2=, $pop61
	i32.const	$push59=, 8
	i32.add 	$push8=, $pop60, $pop59
	i32.store	$discard=, 0($1), $pop8
	i64.load	$push9=, 0($2)
	i64.const	$push10=, 14
	i64.ne  	$push11=, $pop9, $pop10
	br_if   	1, $pop11       # 1: down to label1
# BB#6:                                 # %lor.lhs.false7
	i32.const	$push67=, 0
	i32.load	$1=, pap($pop67)
	i32.load	$push12=, 0($1)
	i32.const	$push13=, 15
	i32.add 	$push14=, $pop12, $pop13
	i32.const	$push15=, -16
	i32.and 	$push66=, $pop14, $pop15
	tee_local	$push65=, $4=, $pop66
	i32.const	$push64=, 8
	i32.or  	$push16=, $pop65, $pop64
	i32.store	$2=, 0($1), $pop16
	i64.load	$3=, 0($4)
	i32.const	$push63=, 8
	i32.add 	$push17=, $2, $pop63
	i32.store	$discard=, 0($1), $pop17
	i64.load	$push18=, 0($2)
	i64.const	$push20=, 0
	i64.const	$push19=, 4613381465357418496
	i32.call	$push21=, __netf2@FUNCTION, $3, $pop18, $pop20, $pop19
	br_if   	1, $pop21       # 1: down to label1
# BB#7:                                 # %lor.lhs.false9
	i32.const	$push22=, 0
	i32.load	$1=, pap($pop22)
	i32.load	$push23=, 0($1)
	i32.const	$push24=, 3
	i32.add 	$push25=, $pop23, $pop24
	i32.const	$push26=, -4
	i32.and 	$push69=, $pop25, $pop26
	tee_local	$push68=, $2=, $pop69
	i32.const	$push27=, 4
	i32.add 	$push28=, $pop68, $pop27
	i32.store	$discard=, 0($1), $pop28
	i32.load	$push29=, 0($2)
	i32.const	$push30=, 17
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	1, $pop31       # 1: down to label1
.LBB1_8:                                # %if.end14
	end_block                       # label2:
	i32.const	$push50=, 0
	i32.store	$discard=, bar_arg($pop50), $0
	return
.LBB1_9:                                # %if.then11
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.f0,"ax",@progbits
	.hidden	f0
	.globl	f0
	.type	f0,@function
f0:                                     # @f0
	.param  	i32, i32
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end2:
	.size	f0, .Lfunc_end2-f0

	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$discard=, 12($5), $1
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
	.endfunc
.Lfunc_end3:
	.size	f1, .Lfunc_end3-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32
	.local  	f64, i32, i64, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 16
	i32.sub 	$10=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$10=, 0($8), $10
	i32.const	$push107=, 0
	f64.load	$2=, d($pop107)
	i32.store	$discard=, 12($10), $1
	block
	block
	block
	block
	i32.trunc_s/f64	$push106=, $2
	tee_local	$push105=, $1=, $pop106
	i32.const	$push1=, 16392
	i32.eq  	$push2=, $pop105, $pop1
	br_if   	0, $pop2        # 0: down to label8
# BB#1:                                 # %entry
	i32.const	$push3=, 16390
	i32.ne  	$push4=, $1, $pop3
	br_if   	1, $pop4        # 1: down to label7
# BB#2:                                 # %if.then.i
	i32.const	$push111=, 0
	i32.const	$push110=, 0
	i32.load	$push32=, gap($pop110)
	i32.const	$push33=, 7
	i32.add 	$push34=, $pop32, $pop33
	i32.const	$push35=, -8
	i32.and 	$push109=, $pop34, $pop35
	tee_local	$push108=, $5=, $pop109
	i32.const	$push36=, 8
	i32.add 	$push37=, $pop108, $pop36
	i32.store	$discard=, gap($pop111), $pop37
	block
	f64.load	$push38=, 0($5)
	f64.const	$push39=, 0x1.1p4
	f64.ne  	$push40=, $pop38, $pop39
	br_if   	0, $pop40       # 0: down to label9
# BB#3:                                 # %lor.lhs.false.i
	i32.const	$push115=, 0
	i32.const	$push114=, 0
	i32.load	$push41=, gap($pop114)
	i32.const	$push42=, 3
	i32.add 	$push43=, $pop41, $pop42
	i32.const	$push44=, -4
	i32.and 	$push113=, $pop43, $pop44
	tee_local	$push112=, $5=, $pop113
	i32.const	$push45=, 4
	i32.add 	$push46=, $pop112, $pop45
	i32.store	$discard=, gap($pop115), $pop46
	i32.load	$push47=, 0($5)
	i32.const	$push48=, 129
	i32.eq  	$push49=, $pop47, $pop48
	br_if   	2, $pop49       # 2: down to label7
.LBB4_4:                                # %if.then3.i
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB4_5:                                # %if.then5.i
	end_block                       # label8:
	i32.const	$push119=, 0
	i32.load	$5=, pap($pop119)
	i32.load	$push5=, 0($5)
	i32.const	$push6=, 7
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -8
	i32.and 	$push118=, $pop7, $pop8
	tee_local	$push117=, $3=, $pop118
	i32.const	$push116=, 8
	i32.add 	$push9=, $pop117, $pop116
	i32.store	$discard=, 0($5), $pop9
	i64.load	$push10=, 0($3)
	i64.const	$push11=, 14
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label6
# BB#6:                                 # %lor.lhs.false7.i
	i32.const	$push124=, 0
	i32.load	$5=, pap($pop124)
	i32.load	$push13=, 0($5)
	i32.const	$push14=, 15
	i32.add 	$push15=, $pop13, $pop14
	i32.const	$push16=, -16
	i32.and 	$push123=, $pop15, $pop16
	tee_local	$push122=, $6=, $pop123
	i32.const	$push121=, 8
	i32.or  	$push17=, $pop122, $pop121
	i32.store	$3=, 0($5), $pop17
	i64.load	$4=, 0($6)
	i32.const	$push120=, 8
	i32.add 	$push18=, $3, $pop120
	i32.store	$discard=, 0($5), $pop18
	i64.load	$push19=, 0($3)
	i64.const	$push21=, 0
	i64.const	$push20=, 4613381465357418496
	i32.call	$push22=, __netf2@FUNCTION, $4, $pop19, $pop21, $pop20
	br_if   	1, $pop22       # 1: down to label6
# BB#7:                                 # %lor.lhs.false9.i
	i32.const	$push127=, 0
	i32.load	$5=, pap($pop127)
	i32.load	$push23=, 0($5)
	i32.const	$push24=, 3
	i32.add 	$push25=, $pop23, $pop24
	i32.const	$push26=, -4
	i32.and 	$push126=, $pop25, $pop26
	tee_local	$push125=, $3=, $pop126
	i32.const	$push27=, 4
	i32.add 	$push28=, $pop125, $pop27
	i32.store	$discard=, 0($5), $pop28
	i32.load	$push29=, 0($3)
	i32.const	$push30=, 17
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	1, $pop31       # 1: down to label6
.LBB4_8:                                # %bar.exit
	end_block                       # label7:
	i32.load	$5=, 12($10)
	i32.const	$push133=, 0
	i32.store	$discard=, bar_arg($pop133), $1
	i32.const	$push50=, 3
	i32.add 	$push51=, $5, $pop50
	i32.const	$push52=, -4
	i32.and 	$push132=, $pop51, $pop52
	tee_local	$push131=, $1=, $pop132
	i32.const	$push53=, 4
	i32.add 	$push54=, $pop131, $pop53
	i32.store	$discard=, 12($10), $pop54
	block
	block
	i32.const	$push130=, 0
	i32.load	$push0=, 0($1)
	i32.store	$push129=, x($pop130), $pop0
	tee_local	$push128=, $1=, $pop129
	i32.const	$push55=, 16392
	i32.eq  	$push56=, $pop128, $pop55
	br_if   	0, $pop56       # 0: down to label11
# BB#9:                                 # %bar.exit
	i32.const	$push57=, 16390
	i32.ne  	$push58=, $1, $pop57
	br_if   	1, $pop58       # 1: down to label10
# BB#10:                                # %if.then.i4
	i32.const	$push137=, 0
	i32.const	$push136=, 0
	i32.load	$push86=, gap($pop136)
	i32.const	$push87=, 7
	i32.add 	$push88=, $pop86, $pop87
	i32.const	$push89=, -8
	i32.and 	$push135=, $pop88, $pop89
	tee_local	$push134=, $5=, $pop135
	i32.const	$push90=, 8
	i32.add 	$push91=, $pop134, $pop90
	i32.store	$discard=, gap($pop137), $pop91
	block
	f64.load	$push92=, 0($5)
	f64.const	$push93=, 0x1.1p4
	f64.ne  	$push94=, $pop92, $pop93
	br_if   	0, $pop94       # 0: down to label12
# BB#11:                                # %lor.lhs.false.i6
	i32.const	$push141=, 0
	i32.const	$push140=, 0
	i32.load	$push95=, gap($pop140)
	i32.const	$push96=, 3
	i32.add 	$push97=, $pop95, $pop96
	i32.const	$push98=, -4
	i32.and 	$push139=, $pop97, $pop98
	tee_local	$push138=, $5=, $pop139
	i32.const	$push99=, 4
	i32.add 	$push100=, $pop138, $pop99
	i32.store	$discard=, gap($pop141), $pop100
	i32.load	$push101=, 0($5)
	i32.const	$push102=, 129
	i32.eq  	$push103=, $pop101, $pop102
	br_if   	2, $pop103      # 2: down to label10
.LBB4_12:                               # %if.then3.i7
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB4_13:                               # %if.then5.i9
	end_block                       # label11:
	i32.const	$push145=, 0
	i32.load	$5=, pap($pop145)
	i32.load	$push59=, 0($5)
	i32.const	$push60=, 7
	i32.add 	$push61=, $pop59, $pop60
	i32.const	$push62=, -8
	i32.and 	$push144=, $pop61, $pop62
	tee_local	$push143=, $3=, $pop144
	i32.const	$push142=, 8
	i32.add 	$push63=, $pop143, $pop142
	i32.store	$discard=, 0($5), $pop63
	i64.load	$push64=, 0($3)
	i64.const	$push65=, 14
	i64.ne  	$push66=, $pop64, $pop65
	br_if   	2, $pop66       # 2: down to label5
# BB#14:                                # %lor.lhs.false7.i11
	i32.const	$push150=, 0
	i32.load	$5=, pap($pop150)
	i32.load	$push67=, 0($5)
	i32.const	$push68=, 15
	i32.add 	$push69=, $pop67, $pop68
	i32.const	$push70=, -16
	i32.and 	$push149=, $pop69, $pop70
	tee_local	$push148=, $6=, $pop149
	i32.const	$push147=, 8
	i32.or  	$push71=, $pop148, $pop147
	i32.store	$3=, 0($5), $pop71
	i64.load	$4=, 0($6)
	i32.const	$push146=, 8
	i32.add 	$push72=, $3, $pop146
	i32.store	$discard=, 0($5), $pop72
	i64.load	$push73=, 0($3)
	i64.const	$push75=, 0
	i64.const	$push74=, 4613381465357418496
	i32.call	$push76=, __netf2@FUNCTION, $4, $pop73, $pop75, $pop74
	br_if   	2, $pop76       # 2: down to label5
# BB#15:                                # %lor.lhs.false9.i13
	i32.const	$push153=, 0
	i32.load	$5=, pap($pop153)
	i32.load	$push77=, 0($5)
	i32.const	$push78=, 3
	i32.add 	$push79=, $pop77, $pop78
	i32.const	$push80=, -4
	i32.and 	$push152=, $pop79, $pop80
	tee_local	$push151=, $3=, $pop152
	i32.const	$push81=, 4
	i32.add 	$push82=, $pop151, $pop81
	i32.store	$discard=, 0($5), $pop82
	i32.load	$push83=, 0($3)
	i32.const	$push84=, 17
	i32.ne  	$push85=, $pop83, $pop84
	br_if   	2, $pop85       # 2: down to label5
.LBB4_16:                               # %bar.exit15
	end_block                       # label10:
	i32.const	$push104=, 0
	i32.store	$discard=, bar_arg($pop104), $1
	i32.const	$9=, 16
	i32.add 	$10=, $10, $9
	i32.const	$9=, __stack_pointer
	i32.store	$10=, 0($9), $10
	return
.LBB4_17:                               # %if.then11.i
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB4_18:                               # %if.then11.i14
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	f2, .Lfunc_end4-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$push0=, 12($5), $1
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push9=, $pop2, $pop3
	tee_local	$push8=, $1=, $pop9
	i32.const	$push4=, 8
	i32.add 	$push5=, $pop8, $pop4
	i32.store	$discard=, 12($5), $pop5
	i32.const	$push7=, 0
	f64.load	$push6=, 0($1)
	f64.store	$discard=, d($pop7), $pop6
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
	.endfunc
.Lfunc_end5:
	.size	f3, .Lfunc_end5-f3

	.section	.text.f4,"ax",@progbits
	.hidden	f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.store	$push0=, 8($6), $1
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push19=, $pop2, $pop3
	tee_local	$push18=, $1=, $pop19
	i32.const	$push4=, 8
	i32.add 	$push5=, $pop18, $pop4
	i32.store	$2=, 8($6), $pop5
	i32.const	$push17=, 0
	f64.load	$push6=, 0($1)
	i32.trunc_s/f64	$push7=, $pop6
	i32.store	$discard=, x($pop17), $pop7
	i32.store	$discard=, 12($6), $2
	block
	i32.const	$push8=, 5
	i32.ne  	$push9=, $0, $pop8
	br_if   	0, $pop9        # 0: down to label13
# BB#1:                                 # %foo.exit
	i32.load	$push10=, 12($6)
	i32.const	$push11=, 3
	i32.add 	$push12=, $pop10, $pop11
	i32.const	$push13=, -4
	i32.and 	$push22=, $pop12, $pop13
	tee_local	$push21=, $1=, $pop22
	i32.const	$push14=, 4
	i32.add 	$push15=, $pop21, $pop14
	i32.store	$discard=, 12($6), $pop15
	i32.const	$push20=, 0
	i32.load	$push16=, 0($1)
	i32.store	$discard=, foo_arg($pop20), $pop16
	i32.const	$5=, 16
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return
.LBB6_2:                                # %sw.default.i
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end6:
	.size	f4, .Lfunc_end6-f4

	.section	.text.f5,"ax",@progbits
	.hidden	f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.param  	i32, i32
	.local  	i32, i64, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 16
	i32.sub 	$8=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$8=, 0($6), $8
	i32.const	$push51=, 0
	i32.store	$push0=, 12($8), $1
	i32.store	$discard=, gap($pop51), $pop0
	block
	block
	block
	i32.const	$push1=, 16392
	i32.eq  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label16
# BB#1:                                 # %entry
	i32.const	$push3=, 16390
	i32.ne  	$push4=, $0, $pop3
	br_if   	1, $pop4        # 1: down to label15
# BB#2:                                 # %if.then.i
	i32.const	$push55=, 0
	i32.const	$push54=, 0
	i32.load	$push32=, gap($pop54)
	i32.const	$push33=, 7
	i32.add 	$push34=, $pop32, $pop33
	i32.const	$push35=, -8
	i32.and 	$push53=, $pop34, $pop35
	tee_local	$push52=, $1=, $pop53
	i32.const	$push36=, 8
	i32.add 	$push37=, $pop52, $pop36
	i32.store	$discard=, gap($pop55), $pop37
	block
	f64.load	$push38=, 0($1)
	f64.const	$push39=, 0x1.1p4
	f64.ne  	$push40=, $pop38, $pop39
	br_if   	0, $pop40       # 0: down to label17
# BB#3:                                 # %lor.lhs.false.i
	i32.const	$push59=, 0
	i32.const	$push58=, 0
	i32.load	$push41=, gap($pop58)
	i32.const	$push42=, 3
	i32.add 	$push43=, $pop41, $pop42
	i32.const	$push44=, -4
	i32.and 	$push57=, $pop43, $pop44
	tee_local	$push56=, $1=, $pop57
	i32.const	$push45=, 4
	i32.add 	$push46=, $pop56, $pop45
	i32.store	$discard=, gap($pop59), $pop46
	i32.load	$push47=, 0($1)
	i32.const	$push48=, 129
	i32.eq  	$push49=, $pop47, $pop48
	br_if   	2, $pop49       # 2: down to label15
.LBB7_4:                                # %if.then3.i
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB7_5:                                # %if.then5.i
	end_block                       # label16:
	i32.const	$push63=, 0
	i32.load	$1=, pap($pop63)
	i32.load	$push5=, 0($1)
	i32.const	$push6=, 7
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -8
	i32.and 	$push62=, $pop7, $pop8
	tee_local	$push61=, $2=, $pop62
	i32.const	$push60=, 8
	i32.add 	$push9=, $pop61, $pop60
	i32.store	$discard=, 0($1), $pop9
	i64.load	$push10=, 0($2)
	i64.const	$push11=, 14
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label14
# BB#6:                                 # %lor.lhs.false7.i
	i32.const	$push68=, 0
	i32.load	$1=, pap($pop68)
	i32.load	$push13=, 0($1)
	i32.const	$push14=, 15
	i32.add 	$push15=, $pop13, $pop14
	i32.const	$push16=, -16
	i32.and 	$push67=, $pop15, $pop16
	tee_local	$push66=, $4=, $pop67
	i32.const	$push65=, 8
	i32.or  	$push17=, $pop66, $pop65
	i32.store	$2=, 0($1), $pop17
	i64.load	$3=, 0($4)
	i32.const	$push64=, 8
	i32.add 	$push18=, $2, $pop64
	i32.store	$discard=, 0($1), $pop18
	i64.load	$push19=, 0($2)
	i64.const	$push21=, 0
	i64.const	$push20=, 4613381465357418496
	i32.call	$push22=, __netf2@FUNCTION, $3, $pop19, $pop21, $pop20
	br_if   	1, $pop22       # 1: down to label14
# BB#7:                                 # %lor.lhs.false9.i
	i32.const	$push71=, 0
	i32.load	$1=, pap($pop71)
	i32.load	$push23=, 0($1)
	i32.const	$push24=, 3
	i32.add 	$push25=, $pop23, $pop24
	i32.const	$push26=, -4
	i32.and 	$push70=, $pop25, $pop26
	tee_local	$push69=, $2=, $pop70
	i32.const	$push27=, 4
	i32.add 	$push28=, $pop69, $pop27
	i32.store	$discard=, 0($1), $pop28
	i32.load	$push29=, 0($2)
	i32.const	$push30=, 17
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	1, $pop31       # 1: down to label14
.LBB7_8:                                # %bar.exit
	end_block                       # label15:
	i32.const	$push50=, 0
	i32.store	$discard=, bar_arg($pop50), $0
	i32.const	$7=, 16
	i32.add 	$8=, $8, $7
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $8
	return
.LBB7_9:                                # %if.then11.i
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end7:
	.size	f5, .Lfunc_end7-f5

	.section	.text.f6,"ax",@progbits
	.hidden	f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.param  	i32, i32
	.local  	f64, i32, i64, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 16
	i32.sub 	$10=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$10=, 0($8), $10
	i32.const	$push110=, 0
	f64.load	$2=, d($pop110)
	i32.store	$discard=, 12($10), $1
	block
	block
	block
	block
	i32.trunc_s/f64	$push109=, $2
	tee_local	$push108=, $1=, $pop109
	i32.const	$push1=, 16392
	i32.eq  	$push2=, $pop108, $pop1
	br_if   	0, $pop2        # 0: down to label21
# BB#1:                                 # %entry
	i32.const	$push3=, 16390
	i32.ne  	$push4=, $1, $pop3
	br_if   	1, $pop4        # 1: down to label20
# BB#2:                                 # %if.then.i
	i32.const	$push114=, 0
	i32.const	$push113=, 0
	i32.load	$push32=, gap($pop113)
	i32.const	$push33=, 7
	i32.add 	$push34=, $pop32, $pop33
	i32.const	$push35=, -8
	i32.and 	$push112=, $pop34, $pop35
	tee_local	$push111=, $5=, $pop112
	i32.const	$push36=, 8
	i32.add 	$push37=, $pop111, $pop36
	i32.store	$discard=, gap($pop114), $pop37
	block
	f64.load	$push38=, 0($5)
	f64.const	$push39=, 0x1.1p4
	f64.ne  	$push40=, $pop38, $pop39
	br_if   	0, $pop40       # 0: down to label22
# BB#3:                                 # %lor.lhs.false.i
	i32.const	$push118=, 0
	i32.const	$push117=, 0
	i32.load	$push41=, gap($pop117)
	i32.const	$push42=, 3
	i32.add 	$push43=, $pop41, $pop42
	i32.const	$push44=, -4
	i32.and 	$push116=, $pop43, $pop44
	tee_local	$push115=, $5=, $pop116
	i32.const	$push45=, 4
	i32.add 	$push46=, $pop115, $pop45
	i32.store	$discard=, gap($pop118), $pop46
	i32.load	$push47=, 0($5)
	i32.const	$push48=, 129
	i32.eq  	$push49=, $pop47, $pop48
	br_if   	2, $pop49       # 2: down to label20
.LBB8_4:                                # %if.then3.i
	end_block                       # label22:
	call    	abort@FUNCTION
	unreachable
.LBB8_5:                                # %if.then5.i
	end_block                       # label21:
	i32.const	$push122=, 0
	i32.load	$5=, pap($pop122)
	i32.load	$push5=, 0($5)
	i32.const	$push6=, 7
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -8
	i32.and 	$push121=, $pop7, $pop8
	tee_local	$push120=, $3=, $pop121
	i32.const	$push119=, 8
	i32.add 	$push9=, $pop120, $pop119
	i32.store	$discard=, 0($5), $pop9
	i64.load	$push10=, 0($3)
	i64.const	$push11=, 14
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label19
# BB#6:                                 # %lor.lhs.false7.i
	i32.const	$push127=, 0
	i32.load	$5=, pap($pop127)
	i32.load	$push13=, 0($5)
	i32.const	$push14=, 15
	i32.add 	$push15=, $pop13, $pop14
	i32.const	$push16=, -16
	i32.and 	$push126=, $pop15, $pop16
	tee_local	$push125=, $6=, $pop126
	i32.const	$push124=, 8
	i32.or  	$push17=, $pop125, $pop124
	i32.store	$3=, 0($5), $pop17
	i64.load	$4=, 0($6)
	i32.const	$push123=, 8
	i32.add 	$push18=, $3, $pop123
	i32.store	$discard=, 0($5), $pop18
	i64.load	$push19=, 0($3)
	i64.const	$push21=, 0
	i64.const	$push20=, 4613381465357418496
	i32.call	$push22=, __netf2@FUNCTION, $4, $pop19, $pop21, $pop20
	br_if   	1, $pop22       # 1: down to label19
# BB#7:                                 # %lor.lhs.false9.i
	i32.const	$push130=, 0
	i32.load	$5=, pap($pop130)
	i32.load	$push23=, 0($5)
	i32.const	$push24=, 3
	i32.add 	$push25=, $pop23, $pop24
	i32.const	$push26=, -4
	i32.and 	$push129=, $pop25, $pop26
	tee_local	$push128=, $3=, $pop129
	i32.const	$push27=, 4
	i32.add 	$push28=, $pop128, $pop27
	i32.store	$discard=, 0($5), $pop28
	i32.load	$push29=, 0($3)
	i32.const	$push30=, 17
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	1, $pop31       # 1: down to label19
.LBB8_8:                                # %bar.exit
	end_block                       # label20:
	i32.load	$5=, 12($10)
	i32.const	$push146=, 0
	i32.store	$discard=, bar_arg($pop146), $1
	i32.const	$push50=, 3
	i32.add 	$push51=, $5, $pop50
	i32.const	$push52=, -4
	i32.and 	$push145=, $pop51, $pop52
	tee_local	$push144=, $1=, $pop145
	i32.const	$push53=, 4
	i32.add 	$push54=, $pop144, $pop53
	i32.store	$discard=, 12($10), $pop54
	i32.const	$push143=, 7
	i32.add 	$push55=, $1, $pop143
	i32.const	$push142=, -4
	i32.and 	$push141=, $pop55, $pop142
	tee_local	$push140=, $1=, $pop141
	i32.const	$push139=, 4
	i32.add 	$push56=, $pop140, $pop139
	i32.store	$discard=, 12($10), $pop56
	i32.const	$push138=, 7
	i32.add 	$push57=, $1, $pop138
	i32.const	$push137=, -4
	i32.and 	$push136=, $pop57, $pop137
	tee_local	$push135=, $1=, $pop136
	i32.const	$push134=, 4
	i32.add 	$push58=, $pop135, $pop134
	i32.store	$discard=, 12($10), $pop58
	block
	block
	i32.const	$push133=, 0
	i32.load	$push0=, 0($1)
	i32.store	$push132=, x($pop133), $pop0
	tee_local	$push131=, $1=, $pop132
	i32.const	$push59=, 16392
	i32.eq  	$push60=, $pop131, $pop59
	br_if   	0, $pop60       # 0: down to label24
# BB#9:                                 # %bar.exit
	i32.const	$push61=, 16390
	i32.ne  	$push62=, $1, $pop61
	br_if   	1, $pop62       # 1: down to label23
# BB#10:                                # %if.then.i4
	i32.const	$push150=, 0
	i32.const	$push149=, 0
	i32.load	$push89=, gap($pop149)
	i32.const	$push90=, 7
	i32.add 	$push91=, $pop89, $pop90
	i32.const	$push92=, -8
	i32.and 	$push148=, $pop91, $pop92
	tee_local	$push147=, $5=, $pop148
	i32.const	$push93=, 8
	i32.add 	$push94=, $pop147, $pop93
	i32.store	$discard=, gap($pop150), $pop94
	block
	f64.load	$push95=, 0($5)
	f64.const	$push96=, 0x1.1p4
	f64.ne  	$push97=, $pop95, $pop96
	br_if   	0, $pop97       # 0: down to label25
# BB#11:                                # %lor.lhs.false.i6
	i32.const	$push154=, 0
	i32.const	$push153=, 0
	i32.load	$push98=, gap($pop153)
	i32.const	$push99=, 3
	i32.add 	$push100=, $pop98, $pop99
	i32.const	$push101=, -4
	i32.and 	$push152=, $pop100, $pop101
	tee_local	$push151=, $5=, $pop152
	i32.const	$push102=, 4
	i32.add 	$push103=, $pop151, $pop102
	i32.store	$discard=, gap($pop154), $pop103
	i32.load	$push104=, 0($5)
	i32.const	$push105=, 129
	i32.eq  	$push106=, $pop104, $pop105
	br_if   	2, $pop106      # 2: down to label23
.LBB8_12:                               # %if.then3.i7
	end_block                       # label25:
	call    	abort@FUNCTION
	unreachable
.LBB8_13:                               # %if.then5.i9
	end_block                       # label24:
	i32.const	$push159=, 0
	i32.load	$5=, pap($pop159)
	i32.load	$push63=, 0($5)
	i32.const	$push158=, 7
	i32.add 	$push64=, $pop63, $pop158
	i32.const	$push65=, -8
	i32.and 	$push157=, $pop64, $pop65
	tee_local	$push156=, $3=, $pop157
	i32.const	$push155=, 8
	i32.add 	$push66=, $pop156, $pop155
	i32.store	$discard=, 0($5), $pop66
	i64.load	$push67=, 0($3)
	i64.const	$push68=, 14
	i64.ne  	$push69=, $pop67, $pop68
	br_if   	2, $pop69       # 2: down to label18
# BB#14:                                # %lor.lhs.false7.i11
	i32.const	$push164=, 0
	i32.load	$5=, pap($pop164)
	i32.load	$push70=, 0($5)
	i32.const	$push71=, 15
	i32.add 	$push72=, $pop70, $pop71
	i32.const	$push73=, -16
	i32.and 	$push163=, $pop72, $pop73
	tee_local	$push162=, $6=, $pop163
	i32.const	$push161=, 8
	i32.or  	$push74=, $pop162, $pop161
	i32.store	$3=, 0($5), $pop74
	i64.load	$4=, 0($6)
	i32.const	$push160=, 8
	i32.add 	$push75=, $3, $pop160
	i32.store	$discard=, 0($5), $pop75
	i64.load	$push76=, 0($3)
	i64.const	$push78=, 0
	i64.const	$push77=, 4613381465357418496
	i32.call	$push79=, __netf2@FUNCTION, $4, $pop76, $pop78, $pop77
	br_if   	2, $pop79       # 2: down to label18
# BB#15:                                # %lor.lhs.false9.i13
	i32.const	$push167=, 0
	i32.load	$5=, pap($pop167)
	i32.load	$push80=, 0($5)
	i32.const	$push81=, 3
	i32.add 	$push82=, $pop80, $pop81
	i32.const	$push83=, -4
	i32.and 	$push166=, $pop82, $pop83
	tee_local	$push165=, $3=, $pop166
	i32.const	$push84=, 4
	i32.add 	$push85=, $pop165, $pop84
	i32.store	$discard=, 0($5), $pop85
	i32.load	$push86=, 0($3)
	i32.const	$push87=, 17
	i32.ne  	$push88=, $pop86, $pop87
	br_if   	2, $pop88       # 2: down to label18
.LBB8_16:                               # %bar.exit15
	end_block                       # label23:
	i32.const	$push107=, 0
	i32.store	$discard=, bar_arg($pop107), $1
	i32.const	$9=, 16
	i32.add 	$10=, $10, $9
	i32.const	$9=, __stack_pointer
	i32.store	$10=, 0($9), $10
	return
.LBB8_17:                               # %if.then11.i
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
.LBB8_18:                               # %if.then11.i14
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end8:
	.size	f6, .Lfunc_end8-f6

	.section	.text.f7,"ax",@progbits
	.hidden	f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.param  	i32, i32
	.local  	i64, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$8=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$8=, 0($5), $8
	i32.store	$discard=, 12($8), $1
	i32.const	$push0=, 0
	i32.const	$7=, 12
	i32.add 	$7=, $8, $7
	i32.store	$discard=, pap($pop0), $7
	block
	block
	block
	i32.const	$push1=, 16392
	i32.eq  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label28
# BB#1:                                 # %entry
	i32.const	$push3=, 16390
	i32.ne  	$push4=, $0, $pop3
	br_if   	1, $pop4        # 1: down to label27
# BB#2:                                 # %if.then.i
	i32.const	$push54=, 0
	i32.const	$push53=, 0
	i32.load	$push32=, gap($pop53)
	i32.const	$push33=, 7
	i32.add 	$push34=, $pop32, $pop33
	i32.const	$push35=, -8
	i32.and 	$push52=, $pop34, $pop35
	tee_local	$push51=, $1=, $pop52
	i32.const	$push36=, 8
	i32.add 	$push37=, $pop51, $pop36
	i32.store	$discard=, gap($pop54), $pop37
	block
	f64.load	$push38=, 0($1)
	f64.const	$push39=, 0x1.1p4
	f64.ne  	$push40=, $pop38, $pop39
	br_if   	0, $pop40       # 0: down to label29
# BB#3:                                 # %lor.lhs.false.i
	i32.const	$push58=, 0
	i32.const	$push57=, 0
	i32.load	$push41=, gap($pop57)
	i32.const	$push42=, 3
	i32.add 	$push43=, $pop41, $pop42
	i32.const	$push44=, -4
	i32.and 	$push56=, $pop43, $pop44
	tee_local	$push55=, $1=, $pop56
	i32.const	$push45=, 4
	i32.add 	$push46=, $pop55, $pop45
	i32.store	$discard=, gap($pop58), $pop46
	i32.load	$push47=, 0($1)
	i32.const	$push48=, 129
	i32.eq  	$push49=, $pop47, $pop48
	br_if   	2, $pop49       # 2: down to label27
.LBB9_4:                                # %if.then3.i
	end_block                       # label29:
	call    	abort@FUNCTION
	unreachable
.LBB9_5:                                # %if.then5.i
	end_block                       # label28:
	i32.load	$push5=, 12($8)
	i32.const	$push6=, 7
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -8
	i32.and 	$push61=, $pop7, $pop8
	tee_local	$push60=, $1=, $pop61
	i32.const	$push59=, 8
	i32.add 	$push9=, $pop60, $pop59
	i32.store	$discard=, 12($8), $pop9
	i64.load	$push10=, 0($1)
	i64.const	$push11=, 14
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label26
# BB#6:                                 # %lor.lhs.false7.i
	i32.load	$push13=, 12($8)
	i32.const	$push14=, 15
	i32.add 	$push15=, $pop13, $pop14
	i32.const	$push16=, -16
	i32.and 	$push65=, $pop15, $pop16
	tee_local	$push64=, $3=, $pop65
	i32.const	$push63=, 8
	i32.or  	$push17=, $pop64, $pop63
	i32.store	$1=, 12($8), $pop17
	i64.load	$2=, 0($3)
	i32.const	$push62=, 8
	i32.add 	$push18=, $1, $pop62
	i32.store	$discard=, 12($8), $pop18
	i64.load	$push19=, 0($1)
	i64.const	$push21=, 0
	i64.const	$push20=, 4613381465357418496
	i32.call	$push22=, __netf2@FUNCTION, $2, $pop19, $pop21, $pop20
	br_if   	1, $pop22       # 1: down to label26
# BB#7:                                 # %lor.lhs.false9.i
	i32.load	$push23=, 12($8)
	i32.const	$push24=, 3
	i32.add 	$push25=, $pop23, $pop24
	i32.const	$push26=, -4
	i32.and 	$push67=, $pop25, $pop26
	tee_local	$push66=, $1=, $pop67
	i32.const	$push27=, 4
	i32.add 	$push28=, $pop66, $pop27
	i32.store	$discard=, 12($8), $pop28
	i32.load	$push29=, 0($1)
	i32.const	$push30=, 17
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	1, $pop31       # 1: down to label26
.LBB9_8:                                # %bar.exit
	end_block                       # label27:
	i32.const	$push50=, 0
	i32.store	$discard=, bar_arg($pop50), $0
	i32.const	$6=, 16
	i32.add 	$8=, $8, $6
	i32.const	$6=, __stack_pointer
	i32.store	$8=, 0($6), $8
	return
.LBB9_9:                                # %if.then11.i
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end9:
	.size	f7, .Lfunc_end9-f7

	.section	.text.f8,"ax",@progbits
	.hidden	f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.param  	i32, i32
	.local  	i64, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$8=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$8=, 0($5), $8
	i32.store	$discard=, 12($8), $1
	i32.const	$push0=, 0
	i32.const	$7=, 12
	i32.add 	$7=, $8, $7
	i32.store	$discard=, pap($pop0), $7
	block
	block
	block
	i32.const	$push1=, 16392
	i32.eq  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label32
# BB#1:                                 # %entry
	i32.const	$push3=, 16390
	i32.ne  	$push4=, $0, $pop3
	br_if   	1, $pop4        # 1: down to label31
# BB#2:                                 # %if.then.i
	i32.const	$push60=, 0
	i32.const	$push59=, 0
	i32.load	$push32=, gap($pop59)
	i32.const	$push33=, 7
	i32.add 	$push34=, $pop32, $pop33
	i32.const	$push35=, -8
	i32.and 	$push58=, $pop34, $pop35
	tee_local	$push57=, $1=, $pop58
	i32.const	$push36=, 8
	i32.add 	$push37=, $pop57, $pop36
	i32.store	$discard=, gap($pop60), $pop37
	block
	f64.load	$push38=, 0($1)
	f64.const	$push39=, 0x1.1p4
	f64.ne  	$push40=, $pop38, $pop39
	br_if   	0, $pop40       # 0: down to label33
# BB#3:                                 # %lor.lhs.false.i
	i32.const	$push64=, 0
	i32.const	$push63=, 0
	i32.load	$push41=, gap($pop63)
	i32.const	$push42=, 3
	i32.add 	$push43=, $pop41, $pop42
	i32.const	$push44=, -4
	i32.and 	$push62=, $pop43, $pop44
	tee_local	$push61=, $1=, $pop62
	i32.const	$push45=, 4
	i32.add 	$push46=, $pop61, $pop45
	i32.store	$discard=, gap($pop64), $pop46
	i32.load	$push47=, 0($1)
	i32.const	$push48=, 129
	i32.eq  	$push49=, $pop47, $pop48
	br_if   	2, $pop49       # 2: down to label31
.LBB10_4:                               # %if.then3.i
	end_block                       # label33:
	call    	abort@FUNCTION
	unreachable
.LBB10_5:                               # %if.then5.i
	end_block                       # label32:
	i32.load	$push5=, 12($8)
	i32.const	$push6=, 7
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -8
	i32.and 	$push67=, $pop7, $pop8
	tee_local	$push66=, $1=, $pop67
	i32.const	$push65=, 8
	i32.add 	$push9=, $pop66, $pop65
	i32.store	$discard=, 12($8), $pop9
	i64.load	$push10=, 0($1)
	i64.const	$push11=, 14
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label30
# BB#6:                                 # %lor.lhs.false7.i
	i32.load	$push13=, 12($8)
	i32.const	$push14=, 15
	i32.add 	$push15=, $pop13, $pop14
	i32.const	$push16=, -16
	i32.and 	$push71=, $pop15, $pop16
	tee_local	$push70=, $3=, $pop71
	i32.const	$push69=, 8
	i32.or  	$push17=, $pop70, $pop69
	i32.store	$1=, 12($8), $pop17
	i64.load	$2=, 0($3)
	i32.const	$push68=, 8
	i32.add 	$push18=, $1, $pop68
	i32.store	$discard=, 12($8), $pop18
	i64.load	$push19=, 0($1)
	i64.const	$push21=, 0
	i64.const	$push20=, 4613381465357418496
	i32.call	$push22=, __netf2@FUNCTION, $2, $pop19, $pop21, $pop20
	br_if   	1, $pop22       # 1: down to label30
# BB#7:                                 # %lor.lhs.false9.i
	i32.load	$push23=, 12($8)
	i32.const	$push24=, 3
	i32.add 	$push25=, $pop23, $pop24
	i32.const	$push26=, -4
	i32.and 	$push73=, $pop25, $pop26
	tee_local	$push72=, $1=, $pop73
	i32.const	$push27=, 4
	i32.add 	$push28=, $pop72, $pop27
	i32.store	$discard=, 12($8), $pop28
	i32.load	$push29=, 0($1)
	i32.const	$push30=, 17
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	1, $pop31       # 1: down to label30
.LBB10_8:                               # %bar.exit
	end_block                       # label31:
	i32.load	$1=, 12($8)
	i32.const	$push50=, 0
	i32.store	$discard=, bar_arg($pop50), $0
	i32.const	$push51=, 7
	i32.add 	$push52=, $1, $pop51
	i32.const	$push53=, -8
	i32.and 	$push76=, $pop52, $pop53
	tee_local	$push75=, $0=, $pop76
	i32.const	$push54=, 8
	i32.add 	$push55=, $pop75, $pop54
	i32.store	$discard=, 12($8), $pop55
	i32.const	$push74=, 0
	f64.load	$push56=, 0($0)
	f64.store	$discard=, d($pop74), $pop56
	i32.const	$6=, 16
	i32.add 	$8=, $8, $6
	i32.const	$6=, __stack_pointer
	i32.store	$8=, 0($6), $8
	return
.LBB10_9:                               # %if.then11.i
	end_block                       # label30:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end10:
	.size	f8, .Lfunc_end10-f8

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 176
	i32.sub 	$20=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$20=, 0($5), $20
	i32.const	$push55=, 0
	call    	f1@FUNCTION, $0, $pop55
	i32.const	$push54=, 0
	i64.const	$push1=, 4629418941960159232
	i64.store	$discard=, d($pop54), $pop1
	i32.const	$push2=, 28
	i32.store	$0=, 160($20):p2align=4, $pop2
	i32.const	$7=, 160
	i32.add 	$7=, $20, $7
	call    	f2@FUNCTION, $0, $7
	block
	block
	block
	block
	block
	block
	block
	i32.const	$push53=, 0
	i32.load	$push3=, bar_arg($pop53)
	i32.ne  	$push4=, $0, $pop3
	br_if   	0, $pop4        # 0: down to label40
# BB#1:                                 # %entry
	i32.const	$push56=, 0
	i32.load	$push0=, x($pop56)
	i32.ne  	$push5=, $pop0, $0
	br_if   	0, $pop5        # 0: down to label40
# BB#2:                                 # %if.end
	i64.const	$push6=, 4638813169307877376
	i64.store	$discard=, 144($20):p2align=4, $pop6
	i32.const	$8=, 144
	i32.add 	$8=, $20, $8
	call    	f3@FUNCTION, $0, $8
	i32.const	$push57=, 0
	f64.load	$push7=, d($pop57)
	f64.const	$push8=, 0x1.06p7
	f64.ne  	$push9=, $pop7, $pop8
	br_if   	1, $pop9        # 1: down to label39
# BB#3:                                 # %if.end4
	i32.const	$push11=, 8
	i32.const	$9=, 128
	i32.add 	$9=, $20, $9
	i32.or  	$push12=, $9, $pop11
	i32.const	$push13=, 128
	i32.store	$0=, 0($pop12):p2align=3, $pop13
	i64.const	$push14=, 4625196817309499392
	i64.store	$discard=, 128($20):p2align=4, $pop14
	i32.const	$push15=, 5
	i32.const	$10=, 128
	i32.add 	$10=, $20, $10
	call    	f4@FUNCTION, $pop15, $10
	i32.const	$push58=, 0
	i32.load	$push16=, x($pop58)
	i32.const	$push17=, 16
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	2, $pop18       # 2: down to label38
# BB#4:                                 # %if.end4
	i32.const	$push59=, 0
	i32.load	$push10=, foo_arg($pop59)
	i32.ne  	$push19=, $pop10, $0
	br_if   	2, $pop19       # 2: down to label38
# BB#5:                                 # %if.end9
	i32.const	$push62=, 8
	i32.const	$11=, 112
	i32.add 	$11=, $20, $11
	i32.or  	$push20=, $11, $pop62
	i32.const	$push21=, 129
	i32.store	$discard=, 0($pop20):p2align=3, $pop21
	i64.const	$push22=, 4625478292286210048
	i64.store	$discard=, 112($20):p2align=4, $pop22
	i32.const	$push23=, 16390
	i32.const	$12=, 112
	i32.add 	$12=, $20, $12
	call    	f5@FUNCTION, $pop23, $12
	i32.const	$push61=, 0
	i32.load	$push24=, bar_arg($pop61)
	i32.const	$push60=, 16390
	i32.ne  	$push25=, $pop24, $pop60
	br_if   	3, $pop25       # 3: down to label37
# BB#6:                                 # %if.end12
	i32.const	$push64=, 8
	i32.const	$13=, 96
	i32.add 	$13=, $20, $13
	i32.or  	$push26=, $13, $pop64
	i32.const	$push27=, -31
	i32.store	$0=, 0($pop26):p2align=3, $pop27
	i64.const	$push28=, 60129542156
	i64.store	$discard=, 96($20):p2align=4, $pop28
	i32.const	$14=, 96
	i32.add 	$14=, $20, $14
	call    	f6@FUNCTION, $0, $14
	i32.const	$push63=, 0
	i32.load	$push29=, bar_arg($pop63)
	i32.ne  	$push30=, $0, $pop29
	br_if   	4, $pop30       # 4: down to label36
# BB#7:                                 # %if.end15
	i32.const	$push71=, 32
	i32.const	$15=, 48
	i32.add 	$15=, $20, $15
	i32.add 	$push31=, $15, $pop71
	i64.const	$push32=, 4628011567076605952
	i64.store	$discard=, 0($pop31):p2align=4, $pop32
	i32.const	$push70=, 24
	i32.const	$16=, 48
	i32.add 	$16=, $20, $16
	i32.add 	$push33=, $16, $pop70
	i32.const	$push34=, 17
	i32.store	$0=, 0($pop33):p2align=3, $pop34
	i32.const	$push69=, 16
	i32.const	$17=, 48
	i32.add 	$17=, $20, $17
	i32.add 	$push35=, $17, $pop69
	i64.const	$push36=, 4613381465357418496
	i64.store	$1=, 0($pop35):p2align=4, $pop36
	i32.const	$push68=, 8
	i32.const	$18=, 48
	i32.add 	$18=, $20, $18
	i32.or  	$push37=, $18, $pop68
	i64.const	$push38=, 0
	i64.store	$2=, 0($pop37), $pop38
	i64.const	$push39=, 14
	i64.store	$3=, 48($20):p2align=4, $pop39
	i32.const	$push67=, 16392
	i32.const	$19=, 48
	i32.add 	$19=, $20, $19
	call    	f7@FUNCTION, $pop67, $19
	i32.const	$push66=, 0
	i32.load	$push40=, bar_arg($pop66)
	i32.const	$push65=, 16392
	i32.ne  	$push41=, $pop40, $pop65
	br_if   	5, $pop41       # 5: down to label35
# BB#8:                                 # %if.end18
	i32.const	$push78=, 32
	i32.add 	$push43=, $20, $pop78
	i64.const	$push44=, 4628293042053316608
	i64.store	$discard=, 0($pop43):p2align=4, $pop44
	i32.const	$push77=, 24
	i32.add 	$push45=, $20, $pop77
	i32.store	$discard=, 0($pop45):p2align=3, $0
	i32.const	$push76=, 16
	i32.add 	$push46=, $20, $pop76
	i64.store	$discard=, 0($pop46):p2align=4, $1
	i32.const	$push75=, 8
	i32.or  	$push47=, $20, $pop75
	i64.store	$discard=, 0($pop47), $2
	i64.store	$discard=, 0($20):p2align=4, $3
	i32.const	$push74=, 16392
	call    	f8@FUNCTION, $pop74, $20
	i32.const	$push73=, 0
	i32.load	$push48=, bar_arg($pop73)
	i32.const	$push72=, 16392
	i32.ne  	$push49=, $pop48, $pop72
	br_if   	6, $pop49       # 6: down to label34
# BB#9:                                 # %if.end18
	i32.const	$push79=, 0
	f64.load	$push42=, d($pop79)
	f64.const	$push50=, 0x1.bp4
	f64.ne  	$push51=, $pop42, $pop50
	br_if   	6, $pop51       # 6: down to label34
# BB#10:                                # %if.end23
	i32.const	$push52=, 0
	i32.const	$6=, 176
	i32.add 	$20=, $20, $6
	i32.const	$6=, __stack_pointer
	i32.store	$20=, 0($6), $20
	return  	$pop52
.LBB11_11:                              # %if.then
	end_block                       # label40:
	call    	abort@FUNCTION
	unreachable
.LBB11_12:                              # %if.then3
	end_block                       # label39:
	call    	abort@FUNCTION
	unreachable
.LBB11_13:                              # %if.then8
	end_block                       # label38:
	call    	abort@FUNCTION
	unreachable
.LBB11_14:                              # %if.then11
	end_block                       # label37:
	call    	abort@FUNCTION
	unreachable
.LBB11_15:                              # %if.then14
	end_block                       # label36:
	call    	abort@FUNCTION
	unreachable
.LBB11_16:                              # %if.then17
	end_block                       # label35:
	call    	abort@FUNCTION
	unreachable
.LBB11_17:                              # %if.then22
	end_block                       # label34:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end11:
	.size	main, .Lfunc_end11-main

	.hidden	foo_arg                 # @foo_arg
	.type	foo_arg,@object
	.section	.bss.foo_arg,"aw",@nobits
	.globl	foo_arg
	.p2align	2
foo_arg:
	.int32	0                       # 0x0
	.size	foo_arg, 4

	.hidden	gap                     # @gap
	.type	gap,@object
	.section	.bss.gap,"aw",@nobits
	.globl	gap
	.p2align	2
gap:
	.int32	0
	.size	gap, 4

	.hidden	pap                     # @pap
	.type	pap,@object
	.section	.bss.pap,"aw",@nobits
	.globl	pap
	.p2align	2
pap:
	.int32	0
	.size	pap, 4

	.hidden	bar_arg                 # @bar_arg
	.type	bar_arg,@object
	.section	.bss.bar_arg,"aw",@nobits
	.globl	bar_arg
	.p2align	2
bar_arg:
	.int32	0                       # 0x0
	.size	bar_arg, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	3
d:
	.int64	0                       # double 0
	.size	d, 8

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	2
x:
	.int32	0                       # 0x0
	.size	x, 4


	.ident	"clang version 3.9.0 "
