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
	i32.and 	$push6=, $pop4, $pop5
	tee_local	$push11=, $0=, $pop6
	i32.const	$push7=, 4
	i32.add 	$push8=, $pop11, $pop7
	i32.store	$discard=, 12($5), $pop8
	i32.const	$push10=, 0
	i32.load	$push9=, 0($0)
	i32.store	$discard=, foo_arg($pop10), $pop9
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
	.local  	i32, i64, i32
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
	i32.const	$push60=, 0
	i32.const	$push59=, 0
	i32.load	$push37=, gap($pop59)
	i32.const	$push38=, 7
	i32.add 	$push39=, $pop37, $pop38
	i32.const	$push40=, -8
	i32.and 	$push41=, $pop39, $pop40
	tee_local	$push58=, $1=, $pop41
	i32.const	$push42=, 8
	i32.add 	$push43=, $pop58, $pop42
	i32.store	$discard=, gap($pop60), $pop43
	block
	f64.load	$push44=, 0($1)
	f64.const	$push45=, 0x1.1p4
	f64.ne  	$push46=, $pop44, $pop45
	br_if   	0, $pop46       # 0: down to label4
# BB#3:                                 # %lor.lhs.false
	i32.const	$push63=, 0
	i32.const	$push62=, 0
	i32.load	$push47=, gap($pop62)
	i32.const	$push48=, 3
	i32.add 	$push49=, $pop47, $pop48
	i32.const	$push50=, -4
	i32.and 	$push51=, $pop49, $pop50
	tee_local	$push61=, $1=, $pop51
	i32.const	$push52=, 4
	i32.add 	$push53=, $pop61, $pop52
	i32.store	$discard=, gap($pop63), $pop53
	i32.load	$push54=, 0($1)
	i32.const	$push55=, 129
	i32.eq  	$push56=, $pop54, $pop55
	br_if   	2, $pop56       # 2: down to label2
.LBB1_4:                                # %if.then3
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_5:                                # %if.then5
	end_block                       # label3:
	i32.const	$push66=, 0
	i32.load	$1=, pap($pop66)
	i32.load	$push4=, 0($1)
	i32.const	$push5=, 7
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push7=, -8
	i32.and 	$push8=, $pop6, $pop7
	tee_local	$push65=, $3=, $pop8
	i32.const	$push64=, 8
	i32.add 	$push9=, $pop65, $pop64
	i32.store	$discard=, 0($1), $pop9
	i64.load	$push10=, 0($3)
	i64.const	$push11=, 14
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label1
# BB#6:                                 # %lor.lhs.false7
	i32.const	$push72=, 0
	i32.load	$push13=, pap($pop72)
	tee_local	$push71=, $1=, $pop13
	i32.load	$push14=, 0($pop71)
	i32.const	$push15=, 15
	i32.add 	$push16=, $pop14, $pop15
	i32.const	$push17=, -16
	i32.and 	$push18=, $pop16, $pop17
	tee_local	$push70=, $3=, $pop18
	i64.load	$2=, 0($pop70)
	i32.const	$push69=, 8
	i32.or  	$push19=, $3, $pop69
	i32.store	$push20=, 0($1), $pop19
	tee_local	$push68=, $3=, $pop20
	i32.const	$push67=, 8
	i32.add 	$push21=, $pop68, $pop67
	i32.store	$discard=, 0($1), $pop21
	i64.load	$push22=, 0($3)
	i64.const	$push24=, 0
	i64.const	$push23=, 4613381465357418496
	i32.call	$push25=, __netf2@FUNCTION, $2, $pop22, $pop24, $pop23
	br_if   	1, $pop25       # 1: down to label1
# BB#7:                                 # %lor.lhs.false9
	i32.const	$push26=, 0
	i32.load	$1=, pap($pop26)
	i32.load	$push27=, 0($1)
	i32.const	$push28=, 3
	i32.add 	$push29=, $pop27, $pop28
	i32.const	$push30=, -4
	i32.and 	$push31=, $pop29, $pop30
	tee_local	$push73=, $3=, $pop31
	i32.const	$push32=, 4
	i32.add 	$push33=, $pop73, $pop32
	i32.store	$discard=, 0($1), $pop33
	i32.load	$push34=, 0($3)
	i32.const	$push35=, 17
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	1, $pop36       # 1: down to label1
.LBB1_8:                                # %if.end14
	end_block                       # label2:
	i32.const	$push57=, 0
	i32.store	$discard=, bar_arg($pop57), $0
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
	.param  	i32
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
	.param  	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	copy_local	$5=, $4
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	i32.store	$discard=, 12($4), $5
	i32.const	$3=, 16
	i32.add 	$4=, $5, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	return
	.endfunc
.Lfunc_end3:
	.size	f1, .Lfunc_end3-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32
	.local  	f64, i64, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 16
	i32.sub 	$9=, $6, $7
	copy_local	$10=, $9
	i32.const	$7=, __stack_pointer
	i32.store	$9=, 0($7), $9
	i32.const	$push123=, 0
	f64.load	$1=, d($pop123)
	i32.store	$discard=, 12($9), $10
	block
	block
	block
	i32.trunc_s/f64	$push0=, $1
	tee_local	$push122=, $4=, $pop0
	i32.const	$push2=, 16392
	i32.eq  	$push3=, $pop122, $pop2
	br_if   	0, $pop3        # 0: down to label7
# BB#1:                                 # %entry
	i32.const	$push4=, 16390
	i32.ne  	$push5=, $4, $pop4
	br_if   	1, $pop5        # 1: down to label6
# BB#2:                                 # %if.then.i
	i32.const	$push126=, 0
	i32.const	$push125=, 0
	i32.load	$push38=, gap($pop125)
	i32.const	$push39=, 7
	i32.add 	$push40=, $pop38, $pop39
	i32.const	$push41=, -8
	i32.and 	$push42=, $pop40, $pop41
	tee_local	$push124=, $3=, $pop42
	i32.const	$push43=, 8
	i32.add 	$push44=, $pop124, $pop43
	i32.store	$discard=, gap($pop126), $pop44
	block
	f64.load	$push45=, 0($3)
	f64.const	$push46=, 0x1.1p4
	f64.ne  	$push47=, $pop45, $pop46
	br_if   	0, $pop47       # 0: down to label8
# BB#3:                                 # %lor.lhs.false.i
	i32.const	$push129=, 0
	i32.const	$push128=, 0
	i32.load	$push48=, gap($pop128)
	i32.const	$push49=, 3
	i32.add 	$push50=, $pop48, $pop49
	i32.const	$push51=, -4
	i32.and 	$push52=, $pop50, $pop51
	tee_local	$push127=, $3=, $pop52
	i32.const	$push53=, 4
	i32.add 	$push54=, $pop127, $pop53
	i32.store	$discard=, gap($pop129), $pop54
	i32.load	$push55=, 0($3)
	i32.const	$push56=, 129
	i32.eq  	$push57=, $pop55, $pop56
	br_if   	2, $pop57       # 2: down to label6
.LBB4_4:                                # %if.then3.i
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB4_5:                                # %if.then5.i
	end_block                       # label7:
	i32.const	$push132=, 0
	i32.load	$3=, pap($pop132)
	i32.load	$push6=, 0($3)
	i32.const	$push7=, 7
	i32.add 	$push8=, $pop6, $pop7
	i32.const	$push9=, -8
	i32.and 	$push10=, $pop8, $pop9
	tee_local	$push131=, $5=, $pop10
	i32.const	$push130=, 8
	i32.add 	$push11=, $pop131, $pop130
	i32.store	$discard=, 0($3), $pop11
	i64.load	$push12=, 0($5)
	i64.const	$push13=, 14
	i64.ne  	$push14=, $pop12, $pop13
	br_if   	1, $pop14       # 1: down to label5
# BB#6:                                 # %lor.lhs.false7.i
	i32.const	$push138=, 0
	i32.load	$push15=, pap($pop138)
	tee_local	$push137=, $3=, $pop15
	i32.load	$push16=, 0($pop137)
	i32.const	$push17=, 15
	i32.add 	$push18=, $pop16, $pop17
	i32.const	$push19=, -16
	i32.and 	$push20=, $pop18, $pop19
	tee_local	$push136=, $5=, $pop20
	i64.load	$2=, 0($pop136)
	i32.const	$push135=, 8
	i32.or  	$push21=, $5, $pop135
	i32.store	$push22=, 0($3), $pop21
	tee_local	$push134=, $5=, $pop22
	i32.const	$push133=, 8
	i32.add 	$push23=, $pop134, $pop133
	i32.store	$discard=, 0($3), $pop23
	i64.load	$push24=, 0($5)
	i64.const	$push26=, 0
	i64.const	$push25=, 4613381465357418496
	i32.call	$push27=, __netf2@FUNCTION, $2, $pop24, $pop26, $pop25
	br_if   	1, $pop27       # 1: down to label5
# BB#7:                                 # %lor.lhs.false9.i
	i32.const	$push140=, 0
	i32.load	$3=, pap($pop140)
	i32.load	$push28=, 0($3)
	i32.const	$push29=, 3
	i32.add 	$push30=, $pop28, $pop29
	i32.const	$push31=, -4
	i32.and 	$push32=, $pop30, $pop31
	tee_local	$push139=, $5=, $pop32
	i32.const	$push33=, 4
	i32.add 	$push34=, $pop139, $pop33
	i32.store	$discard=, 0($3), $pop34
	i32.load	$push35=, 0($5)
	i32.const	$push36=, 17
	i32.ne  	$push37=, $pop35, $pop36
	br_if   	1, $pop37       # 1: down to label5
.LBB4_8:                                # %bar.exit
	end_block                       # label6:
	i32.load	$3=, 12($9)
	i32.const	$push144=, 0
	i32.store	$discard=, bar_arg($pop144), $4
	i32.const	$push58=, 3
	i32.add 	$push59=, $3, $pop58
	i32.const	$push60=, -4
	i32.and 	$push61=, $pop59, $pop60
	tee_local	$push143=, $4=, $pop61
	i32.const	$push62=, 4
	i32.add 	$push63=, $pop143, $pop62
	i32.store	$discard=, 12($9), $pop63
	block
	block
	block
	i32.const	$push142=, 0
	i32.load	$push1=, 0($4)
	i32.store	$push64=, x($pop142), $pop1
	tee_local	$push141=, $4=, $pop64
	i32.const	$push65=, 16392
	i32.eq  	$push66=, $pop141, $pop65
	br_if   	0, $pop66       # 0: down to label11
# BB#9:                                 # %bar.exit
	i32.const	$push67=, 16390
	i32.ne  	$push68=, $4, $pop67
	br_if   	1, $pop68       # 1: down to label10
# BB#10:                                # %if.then.i4
	i32.const	$push147=, 0
	i32.const	$push146=, 0
	i32.load	$push101=, gap($pop146)
	i32.const	$push102=, 7
	i32.add 	$push103=, $pop101, $pop102
	i32.const	$push104=, -8
	i32.and 	$push105=, $pop103, $pop104
	tee_local	$push145=, $3=, $pop105
	i32.const	$push106=, 8
	i32.add 	$push107=, $pop145, $pop106
	i32.store	$discard=, gap($pop147), $pop107
	block
	f64.load	$push108=, 0($3)
	f64.const	$push109=, 0x1.1p4
	f64.ne  	$push110=, $pop108, $pop109
	br_if   	0, $pop110      # 0: down to label12
# BB#11:                                # %lor.lhs.false.i6
	i32.const	$push150=, 0
	i32.const	$push149=, 0
	i32.load	$push111=, gap($pop149)
	i32.const	$push112=, 3
	i32.add 	$push113=, $pop111, $pop112
	i32.const	$push114=, -4
	i32.and 	$push115=, $pop113, $pop114
	tee_local	$push148=, $3=, $pop115
	i32.const	$push116=, 4
	i32.add 	$push117=, $pop148, $pop116
	i32.store	$discard=, gap($pop150), $pop117
	i32.load	$push118=, 0($3)
	i32.const	$push119=, 129
	i32.eq  	$push120=, $pop118, $pop119
	br_if   	2, $pop120      # 2: down to label10
.LBB4_12:                               # %if.then3.i7
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB4_13:                               # %if.then5.i9
	end_block                       # label11:
	i32.const	$push153=, 0
	i32.load	$3=, pap($pop153)
	i32.load	$push69=, 0($3)
	i32.const	$push70=, 7
	i32.add 	$push71=, $pop69, $pop70
	i32.const	$push72=, -8
	i32.and 	$push73=, $pop71, $pop72
	tee_local	$push152=, $5=, $pop73
	i32.const	$push151=, 8
	i32.add 	$push74=, $pop152, $pop151
	i32.store	$discard=, 0($3), $pop74
	i64.load	$push75=, 0($5)
	i64.const	$push76=, 14
	i64.ne  	$push77=, $pop75, $pop76
	br_if   	1, $pop77       # 1: down to label9
# BB#14:                                # %lor.lhs.false7.i11
	i32.const	$push159=, 0
	i32.load	$push78=, pap($pop159)
	tee_local	$push158=, $3=, $pop78
	i32.load	$push79=, 0($pop158)
	i32.const	$push80=, 15
	i32.add 	$push81=, $pop79, $pop80
	i32.const	$push82=, -16
	i32.and 	$push83=, $pop81, $pop82
	tee_local	$push157=, $5=, $pop83
	i64.load	$2=, 0($pop157)
	i32.const	$push156=, 8
	i32.or  	$push84=, $5, $pop156
	i32.store	$push85=, 0($3), $pop84
	tee_local	$push155=, $5=, $pop85
	i32.const	$push154=, 8
	i32.add 	$push86=, $pop155, $pop154
	i32.store	$discard=, 0($3), $pop86
	i64.load	$push87=, 0($5)
	i64.const	$push89=, 0
	i64.const	$push88=, 4613381465357418496
	i32.call	$push90=, __netf2@FUNCTION, $2, $pop87, $pop89, $pop88
	br_if   	1, $pop90       # 1: down to label9
# BB#15:                                # %lor.lhs.false9.i13
	i32.const	$push161=, 0
	i32.load	$3=, pap($pop161)
	i32.load	$push91=, 0($3)
	i32.const	$push92=, 3
	i32.add 	$push93=, $pop91, $pop92
	i32.const	$push94=, -4
	i32.and 	$push95=, $pop93, $pop94
	tee_local	$push160=, $5=, $pop95
	i32.const	$push96=, 4
	i32.add 	$push97=, $pop160, $pop96
	i32.store	$discard=, 0($3), $pop97
	i32.load	$push98=, 0($5)
	i32.const	$push99=, 17
	i32.ne  	$push100=, $pop98, $pop99
	br_if   	1, $pop100      # 1: down to label9
.LBB4_16:                               # %bar.exit15
	end_block                       # label10:
	i32.const	$push121=, 0
	i32.store	$discard=, bar_arg($pop121), $4
	i32.const	$8=, 16
	i32.add 	$9=, $10, $8
	i32.const	$8=, __stack_pointer
	i32.store	$9=, 0($8), $9
	return
.LBB4_17:                               # %if.then11.i14
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB4_18:                               # %if.then11.i
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
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	copy_local	$6=, $5
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$push0=, 12($5), $6
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push9=, $1=, $pop4
	i32.const	$push5=, 8
	i32.add 	$push6=, $pop9, $pop5
	i32.store	$discard=, 12($5), $pop6
	i32.const	$push8=, 0
	f64.load	$push7=, 0($1)
	f64.store	$discard=, d($pop8), $pop7
	i32.const	$4=, 16
	i32.add 	$5=, $6, $4
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
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	copy_local	$7=, $6
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.store	$push0=, 8($6), $7
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push20=, $2=, $pop4
	i32.const	$push5=, 8
	i32.add 	$push6=, $pop20, $pop5
	i32.store	$1=, 8($6), $pop6
	i32.const	$push19=, 0
	f64.load	$push7=, 0($2)
	i32.trunc_s/f64	$push8=, $pop7
	i32.store	$discard=, x($pop19), $pop8
	i32.store	$discard=, 12($6), $1
	block
	i32.const	$push9=, 5
	i32.ne  	$push10=, $0, $pop9
	br_if   	0, $pop10       # 0: down to label13
# BB#1:                                 # %foo.exit
	i32.load	$push11=, 12($6)
	i32.const	$push12=, 3
	i32.add 	$push13=, $pop11, $pop12
	i32.const	$push14=, -4
	i32.and 	$push15=, $pop13, $pop14
	tee_local	$push22=, $0=, $pop15
	i32.const	$push16=, 4
	i32.add 	$push17=, $pop22, $pop16
	i32.store	$discard=, 12($6), $pop17
	i32.const	$push21=, 0
	i32.load	$push18=, 0($0)
	i32.store	$discard=, foo_arg($pop21), $pop18
	i32.const	$5=, 16
	i32.add 	$6=, $7, $5
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
	.param  	i32
	.local  	i32, i64, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$7=, $4, $5
	copy_local	$8=, $7
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	i32.const	$push58=, 0
	i32.store	$push0=, 12($7), $8
	i32.store	$discard=, gap($pop58), $pop0
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
	i32.const	$push61=, 0
	i32.const	$push60=, 0
	i32.load	$push37=, gap($pop60)
	i32.const	$push38=, 7
	i32.add 	$push39=, $pop37, $pop38
	i32.const	$push40=, -8
	i32.and 	$push41=, $pop39, $pop40
	tee_local	$push59=, $1=, $pop41
	i32.const	$push42=, 8
	i32.add 	$push43=, $pop59, $pop42
	i32.store	$discard=, gap($pop61), $pop43
	block
	f64.load	$push44=, 0($1)
	f64.const	$push45=, 0x1.1p4
	f64.ne  	$push46=, $pop44, $pop45
	br_if   	0, $pop46       # 0: down to label17
# BB#3:                                 # %lor.lhs.false.i
	i32.const	$push64=, 0
	i32.const	$push63=, 0
	i32.load	$push47=, gap($pop63)
	i32.const	$push48=, 3
	i32.add 	$push49=, $pop47, $pop48
	i32.const	$push50=, -4
	i32.and 	$push51=, $pop49, $pop50
	tee_local	$push62=, $1=, $pop51
	i32.const	$push52=, 4
	i32.add 	$push53=, $pop62, $pop52
	i32.store	$discard=, gap($pop64), $pop53
	i32.load	$push54=, 0($1)
	i32.const	$push55=, 129
	i32.eq  	$push56=, $pop54, $pop55
	br_if   	2, $pop56       # 2: down to label15
.LBB7_4:                                # %if.then3.i
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB7_5:                                # %if.then5.i
	end_block                       # label16:
	i32.const	$push67=, 0
	i32.load	$1=, pap($pop67)
	i32.load	$push5=, 0($1)
	i32.const	$push6=, 7
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -8
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push66=, $3=, $pop9
	i32.const	$push65=, 8
	i32.add 	$push10=, $pop66, $pop65
	i32.store	$discard=, 0($1), $pop10
	i64.load	$push11=, 0($3)
	i64.const	$push12=, 14
	i64.ne  	$push13=, $pop11, $pop12
	br_if   	1, $pop13       # 1: down to label14
# BB#6:                                 # %lor.lhs.false7.i
	i32.const	$push73=, 0
	i32.load	$push14=, pap($pop73)
	tee_local	$push72=, $1=, $pop14
	i32.load	$push15=, 0($pop72)
	i32.const	$push16=, 15
	i32.add 	$push17=, $pop15, $pop16
	i32.const	$push18=, -16
	i32.and 	$push19=, $pop17, $pop18
	tee_local	$push71=, $3=, $pop19
	i64.load	$2=, 0($pop71)
	i32.const	$push70=, 8
	i32.or  	$push20=, $3, $pop70
	i32.store	$push21=, 0($1), $pop20
	tee_local	$push69=, $3=, $pop21
	i32.const	$push68=, 8
	i32.add 	$push22=, $pop69, $pop68
	i32.store	$discard=, 0($1), $pop22
	i64.load	$push23=, 0($3)
	i64.const	$push25=, 0
	i64.const	$push24=, 4613381465357418496
	i32.call	$push26=, __netf2@FUNCTION, $2, $pop23, $pop25, $pop24
	br_if   	1, $pop26       # 1: down to label14
# BB#7:                                 # %lor.lhs.false9.i
	i32.const	$push75=, 0
	i32.load	$1=, pap($pop75)
	i32.load	$push27=, 0($1)
	i32.const	$push28=, 3
	i32.add 	$push29=, $pop27, $pop28
	i32.const	$push30=, -4
	i32.and 	$push31=, $pop29, $pop30
	tee_local	$push74=, $3=, $pop31
	i32.const	$push32=, 4
	i32.add 	$push33=, $pop74, $pop32
	i32.store	$discard=, 0($1), $pop33
	i32.load	$push34=, 0($3)
	i32.const	$push35=, 17
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	1, $pop36       # 1: down to label14
.LBB7_8:                                # %bar.exit
	end_block                       # label15:
	i32.const	$push57=, 0
	i32.store	$discard=, bar_arg($pop57), $0
	i32.const	$6=, 16
	i32.add 	$7=, $8, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
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
	.param  	i32
	.local  	f64, i64, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 16
	i32.sub 	$9=, $6, $7
	copy_local	$10=, $9
	i32.const	$7=, __stack_pointer
	i32.store	$9=, 0($7), $9
	i32.const	$push128=, 0
	f64.load	$1=, d($pop128)
	i32.store	$discard=, 12($9), $10
	block
	block
	block
	i32.trunc_s/f64	$push0=, $1
	tee_local	$push127=, $4=, $pop0
	i32.const	$push2=, 16392
	i32.eq  	$push3=, $pop127, $pop2
	br_if   	0, $pop3        # 0: down to label20
# BB#1:                                 # %entry
	i32.const	$push4=, 16390
	i32.ne  	$push5=, $4, $pop4
	br_if   	1, $pop5        # 1: down to label19
# BB#2:                                 # %if.then.i
	i32.const	$push131=, 0
	i32.const	$push130=, 0
	i32.load	$push38=, gap($pop130)
	i32.const	$push39=, 7
	i32.add 	$push40=, $pop38, $pop39
	i32.const	$push41=, -8
	i32.and 	$push42=, $pop40, $pop41
	tee_local	$push129=, $3=, $pop42
	i32.const	$push43=, 8
	i32.add 	$push44=, $pop129, $pop43
	i32.store	$discard=, gap($pop131), $pop44
	block
	f64.load	$push45=, 0($3)
	f64.const	$push46=, 0x1.1p4
	f64.ne  	$push47=, $pop45, $pop46
	br_if   	0, $pop47       # 0: down to label21
# BB#3:                                 # %lor.lhs.false.i
	i32.const	$push134=, 0
	i32.const	$push133=, 0
	i32.load	$push48=, gap($pop133)
	i32.const	$push49=, 3
	i32.add 	$push50=, $pop48, $pop49
	i32.const	$push51=, -4
	i32.and 	$push52=, $pop50, $pop51
	tee_local	$push132=, $3=, $pop52
	i32.const	$push53=, 4
	i32.add 	$push54=, $pop132, $pop53
	i32.store	$discard=, gap($pop134), $pop54
	i32.load	$push55=, 0($3)
	i32.const	$push56=, 129
	i32.eq  	$push57=, $pop55, $pop56
	br_if   	2, $pop57       # 2: down to label19
.LBB8_4:                                # %if.then3.i
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
.LBB8_5:                                # %if.then5.i
	end_block                       # label20:
	i32.const	$push137=, 0
	i32.load	$3=, pap($pop137)
	i32.load	$push6=, 0($3)
	i32.const	$push7=, 7
	i32.add 	$push8=, $pop6, $pop7
	i32.const	$push9=, -8
	i32.and 	$push10=, $pop8, $pop9
	tee_local	$push136=, $5=, $pop10
	i32.const	$push135=, 8
	i32.add 	$push11=, $pop136, $pop135
	i32.store	$discard=, 0($3), $pop11
	i64.load	$push12=, 0($5)
	i64.const	$push13=, 14
	i64.ne  	$push14=, $pop12, $pop13
	br_if   	1, $pop14       # 1: down to label18
# BB#6:                                 # %lor.lhs.false7.i
	i32.const	$push143=, 0
	i32.load	$push15=, pap($pop143)
	tee_local	$push142=, $3=, $pop15
	i32.load	$push16=, 0($pop142)
	i32.const	$push17=, 15
	i32.add 	$push18=, $pop16, $pop17
	i32.const	$push19=, -16
	i32.and 	$push20=, $pop18, $pop19
	tee_local	$push141=, $5=, $pop20
	i64.load	$2=, 0($pop141)
	i32.const	$push140=, 8
	i32.or  	$push21=, $5, $pop140
	i32.store	$push22=, 0($3), $pop21
	tee_local	$push139=, $5=, $pop22
	i32.const	$push138=, 8
	i32.add 	$push23=, $pop139, $pop138
	i32.store	$discard=, 0($3), $pop23
	i64.load	$push24=, 0($5)
	i64.const	$push26=, 0
	i64.const	$push25=, 4613381465357418496
	i32.call	$push27=, __netf2@FUNCTION, $2, $pop24, $pop26, $pop25
	br_if   	1, $pop27       # 1: down to label18
# BB#7:                                 # %lor.lhs.false9.i
	i32.const	$push145=, 0
	i32.load	$3=, pap($pop145)
	i32.load	$push28=, 0($3)
	i32.const	$push29=, 3
	i32.add 	$push30=, $pop28, $pop29
	i32.const	$push31=, -4
	i32.and 	$push32=, $pop30, $pop31
	tee_local	$push144=, $5=, $pop32
	i32.const	$push33=, 4
	i32.add 	$push34=, $pop144, $pop33
	i32.store	$discard=, 0($3), $pop34
	i32.load	$push35=, 0($5)
	i32.const	$push36=, 17
	i32.ne  	$push37=, $pop35, $pop36
	br_if   	1, $pop37       # 1: down to label18
.LBB8_8:                                # %bar.exit
	end_block                       # label19:
	i32.load	$3=, 12($9)
	i32.const	$push157=, 0
	i32.store	$discard=, bar_arg($pop157), $4
	i32.const	$push58=, 3
	i32.add 	$push59=, $3, $pop58
	i32.const	$push60=, -4
	i32.and 	$push61=, $pop59, $pop60
	tee_local	$push156=, $4=, $pop61
	i32.const	$push62=, 4
	i32.add 	$push63=, $pop156, $pop62
	i32.store	$discard=, 12($9), $pop63
	i32.const	$push155=, 7
	i32.add 	$push64=, $4, $pop155
	i32.const	$push154=, -4
	i32.and 	$push65=, $pop64, $pop154
	tee_local	$push153=, $4=, $pop65
	i32.const	$push152=, 4
	i32.add 	$push66=, $pop153, $pop152
	i32.store	$discard=, 12($9), $pop66
	i32.const	$push151=, 7
	i32.add 	$push67=, $4, $pop151
	i32.const	$push150=, -4
	i32.and 	$push68=, $pop67, $pop150
	tee_local	$push149=, $4=, $pop68
	i32.const	$push148=, 4
	i32.add 	$push69=, $pop149, $pop148
	i32.store	$discard=, 12($9), $pop69
	block
	block
	block
	i32.const	$push147=, 0
	i32.load	$push1=, 0($4)
	i32.store	$push70=, x($pop147), $pop1
	tee_local	$push146=, $4=, $pop70
	i32.const	$push71=, 16392
	i32.eq  	$push72=, $pop146, $pop71
	br_if   	0, $pop72       # 0: down to label24
# BB#9:                                 # %bar.exit
	i32.const	$push73=, 16390
	i32.ne  	$push74=, $4, $pop73
	br_if   	1, $pop74       # 1: down to label23
# BB#10:                                # %if.then.i4
	i32.const	$push160=, 0
	i32.const	$push159=, 0
	i32.load	$push106=, gap($pop159)
	i32.const	$push107=, 7
	i32.add 	$push108=, $pop106, $pop107
	i32.const	$push109=, -8
	i32.and 	$push110=, $pop108, $pop109
	tee_local	$push158=, $3=, $pop110
	i32.const	$push111=, 8
	i32.add 	$push112=, $pop158, $pop111
	i32.store	$discard=, gap($pop160), $pop112
	block
	f64.load	$push113=, 0($3)
	f64.const	$push114=, 0x1.1p4
	f64.ne  	$push115=, $pop113, $pop114
	br_if   	0, $pop115      # 0: down to label25
# BB#11:                                # %lor.lhs.false.i6
	i32.const	$push163=, 0
	i32.const	$push162=, 0
	i32.load	$push116=, gap($pop162)
	i32.const	$push117=, 3
	i32.add 	$push118=, $pop116, $pop117
	i32.const	$push119=, -4
	i32.and 	$push120=, $pop118, $pop119
	tee_local	$push161=, $3=, $pop120
	i32.const	$push121=, 4
	i32.add 	$push122=, $pop161, $pop121
	i32.store	$discard=, gap($pop163), $pop122
	i32.load	$push123=, 0($3)
	i32.const	$push124=, 129
	i32.eq  	$push125=, $pop123, $pop124
	br_if   	2, $pop125      # 2: down to label23
.LBB8_12:                               # %if.then3.i7
	end_block                       # label25:
	call    	abort@FUNCTION
	unreachable
.LBB8_13:                               # %if.then5.i9
	end_block                       # label24:
	i32.const	$push167=, 0
	i32.load	$3=, pap($pop167)
	i32.load	$push75=, 0($3)
	i32.const	$push166=, 7
	i32.add 	$push76=, $pop75, $pop166
	i32.const	$push77=, -8
	i32.and 	$push78=, $pop76, $pop77
	tee_local	$push165=, $5=, $pop78
	i32.const	$push164=, 8
	i32.add 	$push79=, $pop165, $pop164
	i32.store	$discard=, 0($3), $pop79
	i64.load	$push80=, 0($5)
	i64.const	$push81=, 14
	i64.ne  	$push82=, $pop80, $pop81
	br_if   	1, $pop82       # 1: down to label22
# BB#14:                                # %lor.lhs.false7.i11
	i32.const	$push173=, 0
	i32.load	$push83=, pap($pop173)
	tee_local	$push172=, $3=, $pop83
	i32.load	$push84=, 0($pop172)
	i32.const	$push85=, 15
	i32.add 	$push86=, $pop84, $pop85
	i32.const	$push87=, -16
	i32.and 	$push88=, $pop86, $pop87
	tee_local	$push171=, $5=, $pop88
	i64.load	$2=, 0($pop171)
	i32.const	$push170=, 8
	i32.or  	$push89=, $5, $pop170
	i32.store	$push90=, 0($3), $pop89
	tee_local	$push169=, $5=, $pop90
	i32.const	$push168=, 8
	i32.add 	$push91=, $pop169, $pop168
	i32.store	$discard=, 0($3), $pop91
	i64.load	$push92=, 0($5)
	i64.const	$push94=, 0
	i64.const	$push93=, 4613381465357418496
	i32.call	$push95=, __netf2@FUNCTION, $2, $pop92, $pop94, $pop93
	br_if   	1, $pop95       # 1: down to label22
# BB#15:                                # %lor.lhs.false9.i13
	i32.const	$push175=, 0
	i32.load	$3=, pap($pop175)
	i32.load	$push96=, 0($3)
	i32.const	$push97=, 3
	i32.add 	$push98=, $pop96, $pop97
	i32.const	$push99=, -4
	i32.and 	$push100=, $pop98, $pop99
	tee_local	$push174=, $5=, $pop100
	i32.const	$push101=, 4
	i32.add 	$push102=, $pop174, $pop101
	i32.store	$discard=, 0($3), $pop102
	i32.load	$push103=, 0($5)
	i32.const	$push104=, 17
	i32.ne  	$push105=, $pop103, $pop104
	br_if   	1, $pop105      # 1: down to label22
.LBB8_16:                               # %bar.exit15
	end_block                       # label23:
	i32.const	$push126=, 0
	i32.store	$discard=, bar_arg($pop126), $4
	i32.const	$8=, 16
	i32.add 	$9=, $10, $8
	i32.const	$8=, __stack_pointer
	i32.store	$9=, 0($8), $9
	return
.LBB8_17:                               # %if.then11.i14
	end_block                       # label22:
	call    	abort@FUNCTION
	unreachable
.LBB8_18:                               # %if.then11.i
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
	.param  	i32
	.local  	i64, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$7=, $3, $4
	copy_local	$8=, $7
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
	i32.const	$push0=, 0
	i32.const	$6=, 12
	i32.add 	$6=, $7, $6
	i32.store	$discard=, pap($pop0), $6
	i32.store	$discard=, 12($7), $8
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
	i32.const	$push59=, 0
	i32.const	$push58=, 0
	i32.load	$push36=, gap($pop58)
	i32.const	$push37=, 7
	i32.add 	$push38=, $pop36, $pop37
	i32.const	$push39=, -8
	i32.and 	$push40=, $pop38, $pop39
	tee_local	$push57=, $2=, $pop40
	i32.const	$push41=, 8
	i32.add 	$push42=, $pop57, $pop41
	i32.store	$discard=, gap($pop59), $pop42
	block
	f64.load	$push43=, 0($2)
	f64.const	$push44=, 0x1.1p4
	f64.ne  	$push45=, $pop43, $pop44
	br_if   	0, $pop45       # 0: down to label29
# BB#3:                                 # %lor.lhs.false.i
	i32.const	$push62=, 0
	i32.const	$push61=, 0
	i32.load	$push46=, gap($pop61)
	i32.const	$push47=, 3
	i32.add 	$push48=, $pop46, $pop47
	i32.const	$push49=, -4
	i32.and 	$push50=, $pop48, $pop49
	tee_local	$push60=, $2=, $pop50
	i32.const	$push51=, 4
	i32.add 	$push52=, $pop60, $pop51
	i32.store	$discard=, gap($pop62), $pop52
	i32.load	$push53=, 0($2)
	i32.const	$push54=, 129
	i32.eq  	$push55=, $pop53, $pop54
	br_if   	2, $pop55       # 2: down to label27
.LBB9_4:                                # %if.then3.i
	end_block                       # label29:
	call    	abort@FUNCTION
	unreachable
.LBB9_5:                                # %if.then5.i
	end_block                       # label28:
	i32.load	$push5=, 12($7)
	i32.const	$push6=, 7
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -8
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push64=, $2=, $pop9
	i32.const	$push63=, 8
	i32.add 	$push10=, $pop64, $pop63
	i32.store	$discard=, 12($7), $pop10
	i64.load	$push11=, 0($2)
	i64.const	$push12=, 14
	i64.ne  	$push13=, $pop11, $pop12
	br_if   	1, $pop13       # 1: down to label26
# BB#6:                                 # %lor.lhs.false7.i
	i32.load	$push14=, 12($7)
	i32.const	$push15=, 15
	i32.add 	$push16=, $pop14, $pop15
	i32.const	$push17=, -16
	i32.and 	$push18=, $pop16, $pop17
	tee_local	$push68=, $2=, $pop18
	i64.load	$1=, 0($pop68)
	i32.const	$push67=, 8
	i32.or  	$push19=, $2, $pop67
	i32.store	$push20=, 12($7), $pop19
	tee_local	$push66=, $2=, $pop20
	i32.const	$push65=, 8
	i32.add 	$push21=, $pop66, $pop65
	i32.store	$discard=, 12($7), $pop21
	i64.load	$push22=, 0($2)
	i64.const	$push24=, 0
	i64.const	$push23=, 4613381465357418496
	i32.call	$push25=, __netf2@FUNCTION, $1, $pop22, $pop24, $pop23
	br_if   	1, $pop25       # 1: down to label26
# BB#7:                                 # %lor.lhs.false9.i
	i32.load	$push26=, 12($7)
	i32.const	$push27=, 3
	i32.add 	$push28=, $pop26, $pop27
	i32.const	$push29=, -4
	i32.and 	$push30=, $pop28, $pop29
	tee_local	$push69=, $2=, $pop30
	i32.const	$push31=, 4
	i32.add 	$push32=, $pop69, $pop31
	i32.store	$discard=, 12($7), $pop32
	i32.load	$push33=, 0($2)
	i32.const	$push34=, 17
	i32.ne  	$push35=, $pop33, $pop34
	br_if   	1, $pop35       # 1: down to label26
.LBB9_8:                                # %bar.exit
	end_block                       # label27:
	i32.const	$push56=, 0
	i32.store	$discard=, bar_arg($pop56), $0
	i32.const	$5=, 16
	i32.add 	$7=, $8, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
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
	.param  	i32
	.local  	i64, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$7=, $3, $4
	copy_local	$8=, $7
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
	i32.const	$push0=, 0
	i32.const	$6=, 12
	i32.add 	$6=, $7, $6
	i32.store	$discard=, pap($pop0), $6
	i32.store	$discard=, 12($7), $8
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
	i32.const	$push66=, 0
	i32.const	$push65=, 0
	i32.load	$push36=, gap($pop65)
	i32.const	$push37=, 7
	i32.add 	$push38=, $pop36, $pop37
	i32.const	$push39=, -8
	i32.and 	$push40=, $pop38, $pop39
	tee_local	$push64=, $2=, $pop40
	i32.const	$push41=, 8
	i32.add 	$push42=, $pop64, $pop41
	i32.store	$discard=, gap($pop66), $pop42
	block
	f64.load	$push43=, 0($2)
	f64.const	$push44=, 0x1.1p4
	f64.ne  	$push45=, $pop43, $pop44
	br_if   	0, $pop45       # 0: down to label33
# BB#3:                                 # %lor.lhs.false.i
	i32.const	$push69=, 0
	i32.const	$push68=, 0
	i32.load	$push46=, gap($pop68)
	i32.const	$push47=, 3
	i32.add 	$push48=, $pop46, $pop47
	i32.const	$push49=, -4
	i32.and 	$push50=, $pop48, $pop49
	tee_local	$push67=, $2=, $pop50
	i32.const	$push51=, 4
	i32.add 	$push52=, $pop67, $pop51
	i32.store	$discard=, gap($pop69), $pop52
	i32.load	$push53=, 0($2)
	i32.const	$push54=, 129
	i32.eq  	$push55=, $pop53, $pop54
	br_if   	2, $pop55       # 2: down to label31
.LBB10_4:                               # %if.then3.i
	end_block                       # label33:
	call    	abort@FUNCTION
	unreachable
.LBB10_5:                               # %if.then5.i
	end_block                       # label32:
	i32.load	$push5=, 12($7)
	i32.const	$push6=, 7
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -8
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push71=, $2=, $pop9
	i32.const	$push70=, 8
	i32.add 	$push10=, $pop71, $pop70
	i32.store	$discard=, 12($7), $pop10
	i64.load	$push11=, 0($2)
	i64.const	$push12=, 14
	i64.ne  	$push13=, $pop11, $pop12
	br_if   	1, $pop13       # 1: down to label30
# BB#6:                                 # %lor.lhs.false7.i
	i32.load	$push14=, 12($7)
	i32.const	$push15=, 15
	i32.add 	$push16=, $pop14, $pop15
	i32.const	$push17=, -16
	i32.and 	$push18=, $pop16, $pop17
	tee_local	$push75=, $2=, $pop18
	i64.load	$1=, 0($pop75)
	i32.const	$push74=, 8
	i32.or  	$push19=, $2, $pop74
	i32.store	$push20=, 12($7), $pop19
	tee_local	$push73=, $2=, $pop20
	i32.const	$push72=, 8
	i32.add 	$push21=, $pop73, $pop72
	i32.store	$discard=, 12($7), $pop21
	i64.load	$push22=, 0($2)
	i64.const	$push24=, 0
	i64.const	$push23=, 4613381465357418496
	i32.call	$push25=, __netf2@FUNCTION, $1, $pop22, $pop24, $pop23
	br_if   	1, $pop25       # 1: down to label30
# BB#7:                                 # %lor.lhs.false9.i
	i32.load	$push26=, 12($7)
	i32.const	$push27=, 3
	i32.add 	$push28=, $pop26, $pop27
	i32.const	$push29=, -4
	i32.and 	$push30=, $pop28, $pop29
	tee_local	$push76=, $2=, $pop30
	i32.const	$push31=, 4
	i32.add 	$push32=, $pop76, $pop31
	i32.store	$discard=, 12($7), $pop32
	i32.load	$push33=, 0($2)
	i32.const	$push34=, 17
	i32.ne  	$push35=, $pop33, $pop34
	br_if   	1, $pop35       # 1: down to label30
.LBB10_8:                               # %bar.exit
	end_block                       # label31:
	i32.load	$2=, 12($7)
	i32.const	$push56=, 0
	i32.store	$discard=, bar_arg($pop56), $0
	i32.const	$push57=, 7
	i32.add 	$push58=, $2, $pop57
	i32.const	$push59=, -8
	i32.and 	$push60=, $pop58, $pop59
	tee_local	$push78=, $0=, $pop60
	i32.const	$push61=, 8
	i32.add 	$push62=, $pop78, $pop61
	i32.store	$discard=, 12($7), $pop62
	i32.const	$push77=, 0
	f64.load	$push63=, 0($0)
	f64.store	$discard=, d($pop77), $pop63
	i32.const	$5=, 16
	i32.add 	$7=, $8, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
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
	.local  	i32, i64, i32, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$33=, __stack_pointer
	i32.load	$33=, 0($33)
	i32.const	$34=, 48
	i32.sub 	$36=, $33, $34
	i32.const	$34=, __stack_pointer
	i32.store	$36=, 0($34), $36
	call    	f1@FUNCTION, $0
	i32.const	$push43=, 0
	i64.const	$push1=, 4629418941960159232
	i64.store	$discard=, d($pop43), $pop1
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 4
	i32.sub 	$36=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$36=, 0($6), $36
	i32.const	$push2=, 28
	i32.store	$0=, 0($36), $pop2
	call    	f2@FUNCTION, $0
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 4
	i32.add 	$36=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$36=, 0($8), $36
	block
	i32.const	$push42=, 0
	i32.load	$push3=, bar_arg($pop42)
	i32.ne  	$push4=, $0, $pop3
	br_if   	0, $pop4        # 0: down to label34
# BB#1:                                 # %entry
	i32.const	$push44=, 0
	i32.load	$push0=, x($pop44)
	i32.ne  	$push5=, $pop0, $0
	br_if   	0, $pop5        # 0: down to label34
# BB#2:                                 # %if.end
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 8
	i32.sub 	$36=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$36=, 0($10), $36
	i64.const	$push6=, 4638813169307877376
	i64.store	$discard=, 0($36), $pop6
	call    	f3@FUNCTION, $0
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 8
	i32.add 	$36=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$36=, 0($12), $36
	block
	i32.const	$push45=, 0
	f64.load	$push7=, d($pop45)
	f64.const	$push8=, 0x1.06p7
	f64.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label35
# BB#3:                                 # %if.end4
	i32.const	$13=, __stack_pointer
	i32.load	$13=, 0($13)
	i32.const	$14=, 16
	i32.sub 	$36=, $13, $14
	i32.const	$14=, __stack_pointer
	i32.store	$36=, 0($14), $36
	i64.const	$push11=, 4625196817309499392
	i64.store	$discard=, 0($36), $pop11
	i32.const	$push12=, 8
	i32.add 	$0=, $36, $pop12
	i32.const	$push13=, 128
	i32.store	$0=, 0($0), $pop13
	i32.const	$push14=, 5
	call    	f4@FUNCTION, $pop14
	i32.const	$15=, __stack_pointer
	i32.load	$15=, 0($15)
	i32.const	$16=, 16
	i32.add 	$36=, $15, $16
	i32.const	$16=, __stack_pointer
	i32.store	$36=, 0($16), $36
	block
	i32.const	$push46=, 0
	i32.load	$push15=, x($pop46)
	i32.const	$push16=, 16
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label36
# BB#4:                                 # %if.end4
	i32.const	$push47=, 0
	i32.load	$push10=, foo_arg($pop47)
	i32.ne  	$push18=, $pop10, $0
	br_if   	0, $pop18       # 0: down to label36
# BB#5:                                 # %if.end9
	i32.const	$17=, __stack_pointer
	i32.load	$17=, 0($17)
	i32.const	$18=, 16
	i32.sub 	$36=, $17, $18
	i32.const	$18=, __stack_pointer
	i32.store	$36=, 0($18), $36
	i64.const	$push19=, 4625478292286210048
	i64.store	$discard=, 0($36), $pop19
	i32.const	$push50=, 8
	i32.add 	$0=, $36, $pop50
	i32.const	$push20=, 129
	i32.store	$discard=, 0($0), $pop20
	i32.const	$push21=, 16390
	call    	f5@FUNCTION, $pop21
	i32.const	$19=, __stack_pointer
	i32.load	$19=, 0($19)
	i32.const	$20=, 16
	i32.add 	$36=, $19, $20
	i32.const	$20=, __stack_pointer
	i32.store	$36=, 0($20), $36
	block
	i32.const	$push49=, 0
	i32.load	$push22=, bar_arg($pop49)
	i32.const	$push48=, 16390
	i32.ne  	$push23=, $pop22, $pop48
	br_if   	0, $pop23       # 0: down to label37
# BB#6:                                 # %if.end12
	i32.const	$21=, __stack_pointer
	i32.load	$21=, 0($21)
	i32.const	$22=, 12
	i32.sub 	$36=, $21, $22
	i32.const	$22=, __stack_pointer
	i32.store	$36=, 0($22), $36
	i64.const	$push24=, 60129542156
	i64.store	$discard=, 0($36):p2align=2, $pop24
	i32.const	$push52=, 8
	i32.add 	$0=, $36, $pop52
	i32.const	$push25=, -31
	i32.store	$0=, 0($0), $pop25
	call    	f6@FUNCTION, $0
	i32.const	$23=, __stack_pointer
	i32.load	$23=, 0($23)
	i32.const	$24=, 12
	i32.add 	$36=, $23, $24
	i32.const	$24=, __stack_pointer
	i32.store	$36=, 0($24), $36
	block
	i32.const	$push51=, 0
	i32.load	$push26=, bar_arg($pop51)
	i32.ne  	$push27=, $0, $pop26
	br_if   	0, $pop27       # 0: down to label38
# BB#7:                                 # %if.end15
	i32.const	$25=, __stack_pointer
	i32.load	$25=, 0($25)
	i32.const	$26=, 40
	i32.sub 	$36=, $25, $26
	i32.const	$26=, __stack_pointer
	i32.store	$36=, 0($26), $36
	i64.const	$push28=, 14
	i64.store	$1=, 0($36), $pop28
	i32.const	$push59=, 32
	i32.add 	$0=, $36, $pop59
	i64.const	$push29=, 4628011567076605952
	i64.store	$discard=, 0($0), $pop29
	i32.const	$push58=, 24
	i32.add 	$0=, $36, $pop58
	i32.const	$push30=, 17
	i32.store	$2=, 0($0), $pop30
	i32.const	$push57=, 16
	i32.add 	$0=, $36, $pop57
	i64.const	$push31=, 4613381465357418496
	i64.store	$3=, 0($0), $pop31
	i32.const	$push56=, 8
	i32.add 	$0=, $36, $pop56
	i64.const	$push32=, 0
	i64.store	$4=, 0($0), $pop32
	i32.const	$push55=, 16392
	call    	f7@FUNCTION, $pop55
	i32.const	$27=, __stack_pointer
	i32.load	$27=, 0($27)
	i32.const	$28=, 40
	i32.add 	$36=, $27, $28
	i32.const	$28=, __stack_pointer
	i32.store	$36=, 0($28), $36
	block
	i32.const	$push54=, 0
	i32.load	$push33=, bar_arg($pop54)
	i32.const	$push53=, 16392
	i32.ne  	$push34=, $pop33, $pop53
	br_if   	0, $pop34       # 0: down to label39
# BB#8:                                 # %if.end18
	i32.const	$29=, __stack_pointer
	i32.load	$29=, 0($29)
	i32.const	$30=, 40
	i32.sub 	$36=, $29, $30
	i32.const	$30=, __stack_pointer
	i32.store	$36=, 0($30), $36
	i64.store	$discard=, 0($36), $1
	i32.const	$push66=, 32
	i32.add 	$0=, $36, $pop66
	i64.const	$push36=, 4628293042053316608
	i64.store	$discard=, 0($0), $pop36
	i32.const	$push65=, 24
	i32.add 	$0=, $36, $pop65
	i32.store	$discard=, 0($0), $2
	i32.const	$push64=, 16
	i32.add 	$0=, $36, $pop64
	i64.store	$discard=, 0($0), $3
	i32.const	$push63=, 8
	i32.add 	$0=, $36, $pop63
	i64.store	$discard=, 0($0), $4
	i32.const	$push62=, 16392
	call    	f8@FUNCTION, $pop62
	i32.const	$31=, __stack_pointer
	i32.load	$31=, 0($31)
	i32.const	$32=, 40
	i32.add 	$36=, $31, $32
	i32.const	$32=, __stack_pointer
	i32.store	$36=, 0($32), $36
	block
	i32.const	$push61=, 0
	i32.load	$push37=, bar_arg($pop61)
	i32.const	$push60=, 16392
	i32.ne  	$push38=, $pop37, $pop60
	br_if   	0, $pop38       # 0: down to label40
# BB#9:                                 # %if.end18
	i32.const	$push67=, 0
	f64.load	$push35=, d($pop67)
	f64.const	$push39=, 0x1.bp4
	f64.ne  	$push40=, $pop35, $pop39
	br_if   	0, $pop40       # 0: down to label40
# BB#10:                                # %if.end23
	i32.const	$push41=, 0
	i32.const	$35=, 48
	i32.add 	$36=, $36, $35
	i32.const	$35=, __stack_pointer
	i32.store	$36=, 0($35), $36
	return  	$pop41
.LBB11_11:                              # %if.then22
	end_block                       # label40:
	call    	abort@FUNCTION
	unreachable
.LBB11_12:                              # %if.then17
	end_block                       # label39:
	call    	abort@FUNCTION
	unreachable
.LBB11_13:                              # %if.then14
	end_block                       # label38:
	call    	abort@FUNCTION
	unreachable
.LBB11_14:                              # %if.then11
	end_block                       # label37:
	call    	abort@FUNCTION
	unreachable
.LBB11_15:                              # %if.then8
	end_block                       # label36:
	call    	abort@FUNCTION
	unreachable
.LBB11_16:                              # %if.then3
	end_block                       # label35:
	call    	abort@FUNCTION
	unreachable
.LBB11_17:                              # %if.then
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
