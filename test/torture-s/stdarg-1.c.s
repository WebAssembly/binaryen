	.text
	.file	"stdarg-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 5
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %sw.bb
	i32.const	$push3=, 0
	i32.load	$push2=, 0($1)
	i32.store	foo_arg($pop3), $pop2
	return
.LBB0_2:                                # %sw.default
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32, i32
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
	i32.const	$push49=, 0
	i32.const	$push48=, 0
	i32.load	$push30=, gap($pop48)
	i32.const	$push31=, 7
	i32.add 	$push32=, $pop30, $pop31
	i32.const	$push33=, -8
	i32.and 	$push47=, $pop32, $pop33
	tee_local	$push46=, $1=, $pop47
	i32.const	$push34=, 8
	i32.add 	$push45=, $pop46, $pop34
	tee_local	$push44=, $2=, $pop45
	i32.store	gap($pop49), $pop44
	f64.load	$push35=, 0($1)
	f64.const	$push36=, 0x1.1p4
	f64.ne  	$push37=, $pop35, $pop36
	br_if   	2, $pop37       # 2: down to label1
# BB#3:                                 # %lor.lhs.false
	i32.const	$push50=, 0
	i32.const	$push38=, 12
	i32.add 	$push39=, $1, $pop38
	i32.store	gap($pop50), $pop39
	i32.load	$push40=, 0($2)
	i32.const	$push41=, 129
	i32.eq  	$push42=, $pop40, $pop41
	br_if   	1, $pop42       # 1: down to label2
	br      	2               # 2: down to label1
.LBB1_4:                                # %if.then7
	end_block                       # label3:
	i32.const	$push55=, 0
	i32.load	$push54=, pap($pop55)
	tee_local	$push53=, $1=, $pop54
	i32.load	$push4=, 0($1)
	i32.const	$push5=, 7
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push7=, -8
	i32.and 	$push52=, $pop6, $pop7
	tee_local	$push51=, $1=, $pop52
	i32.const	$push8=, 8
	i32.add 	$push9=, $pop51, $pop8
	i32.store	0($pop53), $pop9
	i64.load	$push10=, 0($1)
	i64.const	$push11=, 14
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label1
# BB#5:                                 # %lor.lhs.false11
	i32.const	$push60=, 0
	i32.load	$push59=, pap($pop60)
	tee_local	$push58=, $1=, $pop59
	i32.load	$push13=, 0($1)
	i32.const	$push14=, 15
	i32.add 	$push15=, $pop13, $pop14
	i32.const	$push16=, -16
	i32.and 	$push57=, $pop15, $pop16
	tee_local	$push56=, $1=, $pop57
	i32.const	$push17=, 16
	i32.add 	$push18=, $pop56, $pop17
	i32.store	0($pop58), $pop18
	i64.load	$push20=, 0($1)
	i64.load	$push19=, 8($1)
	i64.const	$push22=, 0
	i64.const	$push21=, 4613381465357418496
	i32.call	$push23=, __netf2@FUNCTION, $pop20, $pop19, $pop22, $pop21
	br_if   	1, $pop23       # 1: down to label1
# BB#6:                                 # %lor.lhs.false15
	i32.const	$push24=, 0
	i32.load	$push64=, pap($pop24)
	tee_local	$push63=, $1=, $pop64
	i32.load	$push62=, 0($1)
	tee_local	$push61=, $1=, $pop62
	i32.const	$push25=, 4
	i32.add 	$push26=, $pop61, $pop25
	i32.store	0($pop63), $pop26
	i32.load	$push27=, 0($1)
	i32.const	$push28=, 17
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	1, $pop29       # 1: down to label1
.LBB1_7:                                # %if.end22
	end_block                       # label2:
	i32.const	$push43=, 0
	i32.store	bar_arg($pop43), $0
	return
.LBB1_8:                                # %if.then5
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.f0,"ax",@progbits
	.hidden	f0                      # -- Begin function f0
	.globl	f0
	.type	f0,@function
f0:                                     # @f0
	.param  	i32, i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	f0, .Lfunc_end2-f0
                                        # -- End function
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	f1, .Lfunc_end3-f1
                                        # -- End function
	.section	.text.f2,"ax",@progbits
	.hidden	f2                      # -- Begin function f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push91=, 0
	i32.const	$push89=, 0
	i32.load	$push88=, __stack_pointer($pop89)
	i32.const	$push90=, 16
	i32.sub 	$push99=, $pop88, $pop90
	tee_local	$push98=, $4=, $pop99
	i32.store	__stack_pointer($pop91), $pop98
	i32.store	12($4), $1
	block   	
	block   	
	block   	
	i32.const	$push97=, 0
	f64.load	$push0=, d($pop97)
	i32.trunc_s/f64	$push96=, $pop0
	tee_local	$push95=, $1=, $pop96
	i32.const	$push1=, 16392
	i32.eq  	$push2=, $pop95, $pop1
	br_if   	0, $pop2        # 0: down to label6
# BB#1:                                 # %entry
	i32.const	$push3=, 16390
	i32.ne  	$push4=, $1, $pop3
	br_if   	1, $pop4        # 1: down to label5
# BB#2:                                 # %if.then.i
	i32.const	$push105=, 0
	i32.const	$push104=, 0
	i32.load	$push30=, gap($pop104)
	i32.const	$push31=, 7
	i32.add 	$push32=, $pop30, $pop31
	i32.const	$push33=, -8
	i32.and 	$push103=, $pop32, $pop33
	tee_local	$push102=, $2=, $pop103
	i32.const	$push34=, 8
	i32.add 	$push101=, $pop102, $pop34
	tee_local	$push100=, $3=, $pop101
	i32.store	gap($pop105), $pop100
	f64.load	$push35=, 0($2)
	f64.const	$push36=, 0x1.1p4
	f64.ne  	$push37=, $pop35, $pop36
	br_if   	2, $pop37       # 2: down to label4
# BB#3:                                 # %lor.lhs.false.i
	i32.const	$push106=, 0
	i32.const	$push38=, 12
	i32.add 	$push39=, $2, $pop38
	i32.store	gap($pop106), $pop39
	i32.load	$push40=, 0($3)
	i32.const	$push41=, 129
	i32.eq  	$push42=, $pop40, $pop41
	br_if   	1, $pop42       # 1: down to label5
	br      	2               # 2: down to label4
.LBB4_4:                                # %if.then7.i
	end_block                       # label6:
	i32.const	$push111=, 0
	i32.load	$push110=, pap($pop111)
	tee_local	$push109=, $2=, $pop110
	i32.load	$push5=, 0($2)
	i32.const	$push6=, 7
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -8
	i32.and 	$push108=, $pop7, $pop8
	tee_local	$push107=, $2=, $pop108
	i32.const	$push9=, 8
	i32.add 	$push10=, $pop107, $pop9
	i32.store	0($pop109), $pop10
	i64.load	$push11=, 0($2)
	i64.const	$push12=, 14
	i64.ne  	$push13=, $pop11, $pop12
	br_if   	1, $pop13       # 1: down to label4
# BB#5:                                 # %lor.lhs.false11.i
	i32.const	$push116=, 0
	i32.load	$push115=, pap($pop116)
	tee_local	$push114=, $2=, $pop115
	i32.load	$push14=, 0($2)
	i32.const	$push15=, 15
	i32.add 	$push16=, $pop14, $pop15
	i32.const	$push17=, -16
	i32.and 	$push113=, $pop16, $pop17
	tee_local	$push112=, $2=, $pop113
	i32.const	$push18=, 16
	i32.add 	$push19=, $pop112, $pop18
	i32.store	0($pop114), $pop19
	i64.load	$push21=, 0($2)
	i64.load	$push20=, 8($2)
	i64.const	$push23=, 0
	i64.const	$push22=, 4613381465357418496
	i32.call	$push24=, __netf2@FUNCTION, $pop21, $pop20, $pop23, $pop22
	br_if   	1, $pop24       # 1: down to label4
# BB#6:                                 # %lor.lhs.false15.i
	i32.const	$push121=, 0
	i32.load	$push120=, pap($pop121)
	tee_local	$push119=, $2=, $pop120
	i32.load	$push118=, 0($2)
	tee_local	$push117=, $2=, $pop118
	i32.const	$push25=, 4
	i32.add 	$push26=, $pop117, $pop25
	i32.store	0($pop119), $pop26
	i32.load	$push27=, 0($2)
	i32.const	$push28=, 17
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	1, $pop29       # 1: down to label4
.LBB4_7:                                # %bar.exit
	end_block                       # label5:
	i32.const	$push127=, 0
	i32.store	bar_arg($pop127), $1
	i32.load	$push126=, 12($4)
	tee_local	$push125=, $1=, $pop126
	i32.const	$push43=, 4
	i32.add 	$push44=, $pop125, $pop43
	i32.store	12($4), $pop44
	i32.const	$push124=, 0
	i32.load	$push123=, 0($1)
	tee_local	$push122=, $1=, $pop123
	i32.store	x($pop124), $pop122
	block   	
	block   	
	i32.const	$push45=, 16392
	i32.eq  	$push46=, $1, $pop45
	br_if   	0, $pop46       # 0: down to label8
# BB#8:                                 # %bar.exit
	i32.const	$push47=, 16390
	i32.ne  	$push48=, $1, $pop47
	br_if   	1, $pop48       # 1: down to label7
# BB#9:                                 # %if.then.i7
	i32.const	$push133=, 0
	i32.const	$push132=, 0
	i32.load	$push74=, gap($pop132)
	i32.const	$push75=, 7
	i32.add 	$push76=, $pop74, $pop75
	i32.const	$push77=, -8
	i32.and 	$push131=, $pop76, $pop77
	tee_local	$push130=, $2=, $pop131
	i32.const	$push78=, 8
	i32.add 	$push129=, $pop130, $pop78
	tee_local	$push128=, $3=, $pop129
	i32.store	gap($pop133), $pop128
	f64.load	$push79=, 0($2)
	f64.const	$push80=, 0x1.1p4
	f64.ne  	$push81=, $pop79, $pop80
	br_if   	2, $pop81       # 2: down to label4
# BB#10:                                # %lor.lhs.false.i10
	i32.const	$push134=, 0
	i32.const	$push82=, 12
	i32.add 	$push83=, $2, $pop82
	i32.store	gap($pop134), $pop83
	i32.load	$push84=, 0($3)
	i32.const	$push85=, 129
	i32.eq  	$push86=, $pop84, $pop85
	br_if   	1, $pop86       # 1: down to label7
	br      	2               # 2: down to label4
.LBB4_11:                               # %if.then7.i16
	end_block                       # label8:
	i32.const	$push139=, 0
	i32.load	$push138=, pap($pop139)
	tee_local	$push137=, $2=, $pop138
	i32.load	$push49=, 0($2)
	i32.const	$push50=, 7
	i32.add 	$push51=, $pop49, $pop50
	i32.const	$push52=, -8
	i32.and 	$push136=, $pop51, $pop52
	tee_local	$push135=, $2=, $pop136
	i32.const	$push53=, 8
	i32.add 	$push54=, $pop135, $pop53
	i32.store	0($pop137), $pop54
	i64.load	$push55=, 0($2)
	i64.const	$push56=, 14
	i64.ne  	$push57=, $pop55, $pop56
	br_if   	1, $pop57       # 1: down to label4
# BB#12:                                # %lor.lhs.false11.i21
	i32.const	$push144=, 0
	i32.load	$push143=, pap($pop144)
	tee_local	$push142=, $2=, $pop143
	i32.load	$push58=, 0($2)
	i32.const	$push59=, 15
	i32.add 	$push60=, $pop58, $pop59
	i32.const	$push61=, -16
	i32.and 	$push141=, $pop60, $pop61
	tee_local	$push140=, $2=, $pop141
	i32.const	$push62=, 16
	i32.add 	$push63=, $pop140, $pop62
	i32.store	0($pop142), $pop63
	i64.load	$push65=, 0($2)
	i64.load	$push64=, 8($2)
	i64.const	$push67=, 0
	i64.const	$push66=, 4613381465357418496
	i32.call	$push68=, __netf2@FUNCTION, $pop65, $pop64, $pop67, $pop66
	br_if   	1, $pop68       # 1: down to label4
# BB#13:                                # %lor.lhs.false15.i25
	i32.const	$push149=, 0
	i32.load	$push148=, pap($pop149)
	tee_local	$push147=, $2=, $pop148
	i32.load	$push146=, 0($2)
	tee_local	$push145=, $2=, $pop146
	i32.const	$push69=, 4
	i32.add 	$push70=, $pop145, $pop69
	i32.store	0($pop147), $pop70
	i32.load	$push71=, 0($2)
	i32.const	$push72=, 17
	i32.ne  	$push73=, $pop71, $pop72
	br_if   	1, $pop73       # 1: down to label4
.LBB4_14:                               # %bar.exit27
	end_block                       # label7:
	i32.const	$push87=, 0
	i32.store	bar_arg($pop87), $1
	i32.const	$push94=, 0
	i32.const	$push92=, 16
	i32.add 	$push93=, $4, $pop92
	i32.store	__stack_pointer($pop94), $pop93
	return
.LBB4_15:                               # %if.then5.i
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	f2, .Lfunc_end4-f2
                                        # -- End function
	.section	.text.f3,"ax",@progbits
	.hidden	f3                      # -- Begin function f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.load	$2=, __stack_pointer($pop7)
	i32.const	$push4=, 0
	i32.const	$push0=, 7
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -8
	i32.and 	$push11=, $pop1, $pop2
	tee_local	$push10=, $1=, $pop11
	i64.load	$push3=, 0($pop10)
	i64.store	d($pop4), $pop3
	i32.const	$push8=, 16
	i32.sub 	$push9=, $2, $pop8
	i32.const	$push5=, 8
	i32.add 	$push6=, $1, $pop5
	i32.store	12($pop9), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end5:
	.size	f3, .Lfunc_end5-f3
                                        # -- End function
	.section	.text.f4,"ax",@progbits
	.hidden	f4                      # -- Begin function f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, __stack_pointer($pop10)
	i32.const	$push11=, 16
	i32.sub 	$push22=, $pop9, $pop11
	tee_local	$push21=, $2=, $pop22
	i32.store	__stack_pointer($pop12), $pop21
	i32.const	$push20=, 0
	i32.const	$push0=, 7
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -8
	i32.and 	$push19=, $pop1, $pop2
	tee_local	$push18=, $1=, $pop19
	f64.load	$push3=, 0($pop18)
	i32.trunc_s/f64	$push4=, $pop3
	i32.store	x($pop20), $pop4
	i32.const	$push5=, 8
	i32.add 	$push17=, $1, $pop5
	tee_local	$push16=, $1=, $pop17
	i32.store	12($2), $pop16
	block   	
	i32.const	$push6=, 5
	i32.ne  	$push7=, $0, $pop6
	br_if   	0, $pop7        # 0: down to label9
# BB#1:                                 # %foo.exit
	i32.const	$push23=, 0
	i32.load	$push8=, 0($1)
	i32.store	foo_arg($pop23), $pop8
	i32.const	$push15=, 0
	i32.const	$push13=, 16
	i32.add 	$push14=, $2, $pop13
	i32.store	__stack_pointer($pop15), $pop14
	return
.LBB6_2:                                # %sw.default.i
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end6:
	.size	f4, .Lfunc_end6-f4
                                        # -- End function
	.section	.text.f5,"ax",@progbits
	.hidden	f5                      # -- Begin function f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push46=, 0
	i32.const	$push44=, 0
	i32.load	$push43=, __stack_pointer($pop44)
	i32.const	$push45=, 16
	i32.sub 	$push52=, $pop43, $pop45
	tee_local	$push51=, $3=, $pop52
	i32.store	__stack_pointer($pop46), $pop51
	i32.const	$push50=, 0
	i32.store	gap($pop50), $1
	i32.store	12($3), $1
	block   	
	block   	
	block   	
	i32.const	$push0=, 16392
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label12
# BB#1:                                 # %entry
	i32.const	$push2=, 16390
	i32.ne  	$push3=, $0, $pop2
	br_if   	1, $pop3        # 1: down to label11
# BB#2:                                 # %if.then.i
	i32.const	$push58=, 0
	i32.const	$push57=, 0
	i32.load	$push29=, gap($pop57)
	i32.const	$push30=, 7
	i32.add 	$push31=, $pop29, $pop30
	i32.const	$push32=, -8
	i32.and 	$push56=, $pop31, $pop32
	tee_local	$push55=, $1=, $pop56
	i32.const	$push33=, 8
	i32.add 	$push54=, $pop55, $pop33
	tee_local	$push53=, $2=, $pop54
	i32.store	gap($pop58), $pop53
	f64.load	$push34=, 0($1)
	f64.const	$push35=, 0x1.1p4
	f64.ne  	$push36=, $pop34, $pop35
	br_if   	2, $pop36       # 2: down to label10
# BB#3:                                 # %lor.lhs.false.i
	i32.const	$push59=, 0
	i32.const	$push37=, 12
	i32.add 	$push38=, $1, $pop37
	i32.store	gap($pop59), $pop38
	i32.load	$push39=, 0($2)
	i32.const	$push40=, 129
	i32.eq  	$push41=, $pop39, $pop40
	br_if   	1, $pop41       # 1: down to label11
	br      	2               # 2: down to label10
.LBB7_4:                                # %if.then7.i
	end_block                       # label12:
	i32.const	$push64=, 0
	i32.load	$push63=, pap($pop64)
	tee_local	$push62=, $1=, $pop63
	i32.load	$push4=, 0($1)
	i32.const	$push5=, 7
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push7=, -8
	i32.and 	$push61=, $pop6, $pop7
	tee_local	$push60=, $1=, $pop61
	i32.const	$push8=, 8
	i32.add 	$push9=, $pop60, $pop8
	i32.store	0($pop62), $pop9
	i64.load	$push10=, 0($1)
	i64.const	$push11=, 14
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label10
# BB#5:                                 # %lor.lhs.false11.i
	i32.const	$push69=, 0
	i32.load	$push68=, pap($pop69)
	tee_local	$push67=, $1=, $pop68
	i32.load	$push13=, 0($1)
	i32.const	$push14=, 15
	i32.add 	$push15=, $pop13, $pop14
	i32.const	$push16=, -16
	i32.and 	$push66=, $pop15, $pop16
	tee_local	$push65=, $1=, $pop66
	i32.const	$push17=, 16
	i32.add 	$push18=, $pop65, $pop17
	i32.store	0($pop67), $pop18
	i64.load	$push20=, 0($1)
	i64.load	$push19=, 8($1)
	i64.const	$push22=, 0
	i64.const	$push21=, 4613381465357418496
	i32.call	$push23=, __netf2@FUNCTION, $pop20, $pop19, $pop22, $pop21
	br_if   	1, $pop23       # 1: down to label10
# BB#6:                                 # %lor.lhs.false15.i
	i32.const	$push74=, 0
	i32.load	$push73=, pap($pop74)
	tee_local	$push72=, $1=, $pop73
	i32.load	$push71=, 0($1)
	tee_local	$push70=, $1=, $pop71
	i32.const	$push24=, 4
	i32.add 	$push25=, $pop70, $pop24
	i32.store	0($pop72), $pop25
	i32.load	$push26=, 0($1)
	i32.const	$push27=, 17
	i32.ne  	$push28=, $pop26, $pop27
	br_if   	1, $pop28       # 1: down to label10
.LBB7_7:                                # %bar.exit
	end_block                       # label11:
	i32.const	$push42=, 0
	i32.store	bar_arg($pop42), $0
	i32.const	$push49=, 0
	i32.const	$push47=, 16
	i32.add 	$push48=, $3, $pop47
	i32.store	__stack_pointer($pop49), $pop48
	return
.LBB7_8:                                # %if.then5.i
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end7:
	.size	f5, .Lfunc_end7-f5
                                        # -- End function
	.section	.text.f6,"ax",@progbits
	.hidden	f6                      # -- Begin function f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push91=, 0
	i32.const	$push89=, 0
	i32.load	$push88=, __stack_pointer($pop89)
	i32.const	$push90=, 16
	i32.sub 	$push99=, $pop88, $pop90
	tee_local	$push98=, $4=, $pop99
	i32.store	__stack_pointer($pop91), $pop98
	i32.store	12($4), $1
	block   	
	block   	
	block   	
	i32.const	$push97=, 0
	f64.load	$push0=, d($pop97)
	i32.trunc_s/f64	$push96=, $pop0
	tee_local	$push95=, $1=, $pop96
	i32.const	$push1=, 16392
	i32.eq  	$push2=, $pop95, $pop1
	br_if   	0, $pop2        # 0: down to label15
# BB#1:                                 # %entry
	i32.const	$push3=, 16390
	i32.ne  	$push4=, $1, $pop3
	br_if   	1, $pop4        # 1: down to label14
# BB#2:                                 # %if.then.i
	i32.const	$push105=, 0
	i32.const	$push104=, 0
	i32.load	$push30=, gap($pop104)
	i32.const	$push31=, 7
	i32.add 	$push32=, $pop30, $pop31
	i32.const	$push33=, -8
	i32.and 	$push103=, $pop32, $pop33
	tee_local	$push102=, $3=, $pop103
	i32.const	$push34=, 8
	i32.add 	$push101=, $pop102, $pop34
	tee_local	$push100=, $2=, $pop101
	i32.store	gap($pop105), $pop100
	f64.load	$push35=, 0($3)
	f64.const	$push36=, 0x1.1p4
	f64.ne  	$push37=, $pop35, $pop36
	br_if   	2, $pop37       # 2: down to label13
# BB#3:                                 # %lor.lhs.false.i
	i32.const	$push106=, 0
	i32.const	$push38=, 12
	i32.add 	$push39=, $3, $pop38
	i32.store	gap($pop106), $pop39
	i32.load	$push40=, 0($2)
	i32.const	$push41=, 129
	i32.eq  	$push42=, $pop40, $pop41
	br_if   	1, $pop42       # 1: down to label14
	br      	2               # 2: down to label13
.LBB8_4:                                # %if.then7.i
	end_block                       # label15:
	i32.const	$push111=, 0
	i32.load	$push110=, pap($pop111)
	tee_local	$push109=, $3=, $pop110
	i32.load	$push5=, 0($3)
	i32.const	$push6=, 7
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -8
	i32.and 	$push108=, $pop7, $pop8
	tee_local	$push107=, $3=, $pop108
	i32.const	$push9=, 8
	i32.add 	$push10=, $pop107, $pop9
	i32.store	0($pop109), $pop10
	i64.load	$push11=, 0($3)
	i64.const	$push12=, 14
	i64.ne  	$push13=, $pop11, $pop12
	br_if   	1, $pop13       # 1: down to label13
# BB#5:                                 # %lor.lhs.false11.i
	i32.const	$push116=, 0
	i32.load	$push115=, pap($pop116)
	tee_local	$push114=, $3=, $pop115
	i32.load	$push14=, 0($3)
	i32.const	$push15=, 15
	i32.add 	$push16=, $pop14, $pop15
	i32.const	$push17=, -16
	i32.and 	$push113=, $pop16, $pop17
	tee_local	$push112=, $3=, $pop113
	i32.const	$push18=, 16
	i32.add 	$push19=, $pop112, $pop18
	i32.store	0($pop114), $pop19
	i64.load	$push21=, 0($3)
	i64.load	$push20=, 8($3)
	i64.const	$push23=, 0
	i64.const	$push22=, 4613381465357418496
	i32.call	$push24=, __netf2@FUNCTION, $pop21, $pop20, $pop23, $pop22
	br_if   	1, $pop24       # 1: down to label13
# BB#6:                                 # %lor.lhs.false15.i
	i32.const	$push121=, 0
	i32.load	$push120=, pap($pop121)
	tee_local	$push119=, $3=, $pop120
	i32.load	$push118=, 0($3)
	tee_local	$push117=, $3=, $pop118
	i32.const	$push25=, 4
	i32.add 	$push26=, $pop117, $pop25
	i32.store	0($pop119), $pop26
	i32.load	$push27=, 0($3)
	i32.const	$push28=, 17
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	1, $pop29       # 1: down to label13
.LBB8_7:                                # %bar.exit
	end_block                       # label14:
	i32.const	$push127=, 0
	i32.store	bar_arg($pop127), $1
	i32.const	$push126=, 0
	i32.load	$push125=, 12($4)
	tee_local	$push124=, $3=, $pop125
	i32.load	$push123=, 8($pop124)
	tee_local	$push122=, $1=, $pop123
	i32.store	x($pop126), $pop122
	i32.const	$push43=, 12
	i32.add 	$push44=, $3, $pop43
	i32.store	12($4), $pop44
	block   	
	block   	
	i32.const	$push45=, 16392
	i32.eq  	$push46=, $1, $pop45
	br_if   	0, $pop46       # 0: down to label17
# BB#8:                                 # %bar.exit
	i32.const	$push47=, 16390
	i32.ne  	$push48=, $1, $pop47
	br_if   	1, $pop48       # 1: down to label16
# BB#9:                                 # %if.then.i11
	i32.const	$push133=, 0
	i32.const	$push132=, 0
	i32.load	$push74=, gap($pop132)
	i32.const	$push75=, 7
	i32.add 	$push76=, $pop74, $pop75
	i32.const	$push77=, -8
	i32.and 	$push131=, $pop76, $pop77
	tee_local	$push130=, $3=, $pop131
	i32.const	$push78=, 8
	i32.add 	$push129=, $pop130, $pop78
	tee_local	$push128=, $2=, $pop129
	i32.store	gap($pop133), $pop128
	f64.load	$push79=, 0($3)
	f64.const	$push80=, 0x1.1p4
	f64.ne  	$push81=, $pop79, $pop80
	br_if   	2, $pop81       # 2: down to label13
# BB#10:                                # %lor.lhs.false.i14
	i32.const	$push134=, 0
	i32.const	$push82=, 12
	i32.add 	$push83=, $3, $pop82
	i32.store	gap($pop134), $pop83
	i32.load	$push84=, 0($2)
	i32.const	$push85=, 129
	i32.eq  	$push86=, $pop84, $pop85
	br_if   	1, $pop86       # 1: down to label16
	br      	2               # 2: down to label13
.LBB8_11:                               # %if.then7.i20
	end_block                       # label17:
	i32.const	$push139=, 0
	i32.load	$push138=, pap($pop139)
	tee_local	$push137=, $3=, $pop138
	i32.load	$push49=, 0($3)
	i32.const	$push50=, 7
	i32.add 	$push51=, $pop49, $pop50
	i32.const	$push52=, -8
	i32.and 	$push136=, $pop51, $pop52
	tee_local	$push135=, $3=, $pop136
	i32.const	$push53=, 8
	i32.add 	$push54=, $pop135, $pop53
	i32.store	0($pop137), $pop54
	i64.load	$push55=, 0($3)
	i64.const	$push56=, 14
	i64.ne  	$push57=, $pop55, $pop56
	br_if   	1, $pop57       # 1: down to label13
# BB#12:                                # %lor.lhs.false11.i25
	i32.const	$push144=, 0
	i32.load	$push143=, pap($pop144)
	tee_local	$push142=, $3=, $pop143
	i32.load	$push58=, 0($3)
	i32.const	$push59=, 15
	i32.add 	$push60=, $pop58, $pop59
	i32.const	$push61=, -16
	i32.and 	$push141=, $pop60, $pop61
	tee_local	$push140=, $3=, $pop141
	i32.const	$push62=, 16
	i32.add 	$push63=, $pop140, $pop62
	i32.store	0($pop142), $pop63
	i64.load	$push65=, 0($3)
	i64.load	$push64=, 8($3)
	i64.const	$push67=, 0
	i64.const	$push66=, 4613381465357418496
	i32.call	$push68=, __netf2@FUNCTION, $pop65, $pop64, $pop67, $pop66
	br_if   	1, $pop68       # 1: down to label13
# BB#13:                                # %lor.lhs.false15.i29
	i32.const	$push149=, 0
	i32.load	$push148=, pap($pop149)
	tee_local	$push147=, $3=, $pop148
	i32.load	$push146=, 0($3)
	tee_local	$push145=, $3=, $pop146
	i32.const	$push69=, 4
	i32.add 	$push70=, $pop145, $pop69
	i32.store	0($pop147), $pop70
	i32.load	$push71=, 0($3)
	i32.const	$push72=, 17
	i32.ne  	$push73=, $pop71, $pop72
	br_if   	1, $pop73       # 1: down to label13
.LBB8_14:                               # %bar.exit31
	end_block                       # label16:
	i32.const	$push87=, 0
	i32.store	bar_arg($pop87), $1
	i32.const	$push94=, 0
	i32.const	$push92=, 16
	i32.add 	$push93=, $4, $pop92
	i32.store	__stack_pointer($pop94), $pop93
	return
.LBB8_15:                               # %if.then5.i
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end8:
	.size	f6, .Lfunc_end8-f6
                                        # -- End function
	.section	.text.f7,"ax",@progbits
	.hidden	f7                      # -- Begin function f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push44=, 0
	i32.const	$push42=, 0
	i32.load	$push41=, __stack_pointer($pop42)
	i32.const	$push43=, 16
	i32.sub 	$push51=, $pop41, $pop43
	tee_local	$push50=, $3=, $pop51
	i32.store	__stack_pointer($pop44), $pop50
	i32.const	$push0=, 0
	i32.const	$push48=, 12
	i32.add 	$push49=, $3, $pop48
	i32.store	pap($pop0), $pop49
	i32.store	12($3), $1
	block   	
	block   	
	block   	
	i32.const	$push1=, 16392
	i32.eq  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label20
# BB#1:                                 # %entry
	i32.const	$push3=, 16390
	i32.ne  	$push4=, $0, $pop3
	br_if   	1, $pop4        # 1: down to label19
# BB#2:                                 # %if.then.i
	i32.const	$push57=, 0
	i32.const	$push56=, 0
	i32.load	$push27=, gap($pop56)
	i32.const	$push28=, 7
	i32.add 	$push29=, $pop27, $pop28
	i32.const	$push30=, -8
	i32.and 	$push55=, $pop29, $pop30
	tee_local	$push54=, $1=, $pop55
	i32.const	$push31=, 8
	i32.add 	$push53=, $pop54, $pop31
	tee_local	$push52=, $2=, $pop53
	i32.store	gap($pop57), $pop52
	f64.load	$push32=, 0($1)
	f64.const	$push33=, 0x1.1p4
	f64.ne  	$push34=, $pop32, $pop33
	br_if   	2, $pop34       # 2: down to label18
# BB#3:                                 # %lor.lhs.false.i
	i32.const	$push58=, 0
	i32.const	$push35=, 12
	i32.add 	$push36=, $1, $pop35
	i32.store	gap($pop58), $pop36
	i32.load	$push37=, 0($2)
	i32.const	$push38=, 129
	i32.eq  	$push39=, $pop37, $pop38
	br_if   	1, $pop39       # 1: down to label19
	br      	2               # 2: down to label18
.LBB9_4:                                # %if.then7.i
	end_block                       # label20:
	i32.load	$push6=, 12($3)
	i32.const	$push5=, 7
	i32.add 	$push7=, $pop6, $pop5
	i32.const	$push8=, -8
	i32.and 	$push62=, $pop7, $pop8
	tee_local	$push61=, $1=, $pop62
	i32.const	$push9=, 8
	i32.add 	$push60=, $pop61, $pop9
	tee_local	$push59=, $2=, $pop60
	i32.store	12($3), $pop59
	i64.load	$push10=, 0($1)
	i64.const	$push11=, 14
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label18
# BB#5:                                 # %lor.lhs.false11.i
	i32.const	$push13=, 15
	i32.add 	$push14=, $2, $pop13
	i32.const	$push15=, -16
	i32.and 	$push66=, $pop14, $pop15
	tee_local	$push65=, $1=, $pop66
	i32.const	$push16=, 16
	i32.add 	$push64=, $pop65, $pop16
	tee_local	$push63=, $2=, $pop64
	i32.store	12($3), $pop63
	i64.load	$push18=, 0($1)
	i64.load	$push17=, 8($1)
	i64.const	$push20=, 0
	i64.const	$push19=, 4613381465357418496
	i32.call	$push21=, __netf2@FUNCTION, $pop18, $pop17, $pop20, $pop19
	br_if   	1, $pop21       # 1: down to label18
# BB#6:                                 # %lor.lhs.false15.i
	i32.const	$push22=, 20
	i32.add 	$push23=, $1, $pop22
	i32.store	12($3), $pop23
	i32.load	$push24=, 0($2)
	i32.const	$push25=, 17
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	1, $pop26       # 1: down to label18
.LBB9_7:                                # %bar.exit
	end_block                       # label19:
	i32.const	$push40=, 0
	i32.store	bar_arg($pop40), $0
	i32.const	$push47=, 0
	i32.const	$push45=, 16
	i32.add 	$push46=, $3, $pop45
	i32.store	__stack_pointer($pop47), $pop46
	return
.LBB9_8:                                # %if.then5.i
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end9:
	.size	f7, .Lfunc_end9-f7
                                        # -- End function
	.section	.text.f8,"ax",@progbits
	.hidden	f8                      # -- Begin function f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push51=, 0
	i32.const	$push49=, 0
	i32.load	$push48=, __stack_pointer($pop49)
	i32.const	$push50=, 16
	i32.sub 	$push58=, $pop48, $pop50
	tee_local	$push57=, $3=, $pop58
	i32.store	__stack_pointer($pop51), $pop57
	i32.const	$push0=, 0
	i32.const	$push55=, 12
	i32.add 	$push56=, $3, $pop55
	i32.store	pap($pop0), $pop56
	i32.store	12($3), $1
	block   	
	block   	
	block   	
	i32.const	$push1=, 16392
	i32.eq  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label23
# BB#1:                                 # %entry
	i32.const	$push3=, 16390
	i32.ne  	$push4=, $0, $pop3
	br_if   	1, $pop4        # 1: down to label22
# BB#2:                                 # %if.then.i
	i32.const	$push64=, 0
	i32.const	$push63=, 0
	i32.load	$push27=, gap($pop63)
	i32.const	$push28=, 7
	i32.add 	$push29=, $pop27, $pop28
	i32.const	$push30=, -8
	i32.and 	$push62=, $pop29, $pop30
	tee_local	$push61=, $1=, $pop62
	i32.const	$push31=, 8
	i32.add 	$push60=, $pop61, $pop31
	tee_local	$push59=, $2=, $pop60
	i32.store	gap($pop64), $pop59
	f64.load	$push32=, 0($1)
	f64.const	$push33=, 0x1.1p4
	f64.ne  	$push34=, $pop32, $pop33
	br_if   	2, $pop34       # 2: down to label21
# BB#3:                                 # %lor.lhs.false.i
	i32.const	$push65=, 0
	i32.const	$push35=, 12
	i32.add 	$push36=, $1, $pop35
	i32.store	gap($pop65), $pop36
	i32.load	$push37=, 0($2)
	i32.const	$push38=, 129
	i32.eq  	$push39=, $pop37, $pop38
	br_if   	1, $pop39       # 1: down to label22
	br      	2               # 2: down to label21
.LBB10_4:                               # %if.then7.i
	end_block                       # label23:
	i32.load	$push6=, 12($3)
	i32.const	$push5=, 7
	i32.add 	$push7=, $pop6, $pop5
	i32.const	$push8=, -8
	i32.and 	$push69=, $pop7, $pop8
	tee_local	$push68=, $1=, $pop69
	i32.const	$push9=, 8
	i32.add 	$push67=, $pop68, $pop9
	tee_local	$push66=, $2=, $pop67
	i32.store	12($3), $pop66
	i64.load	$push10=, 0($1)
	i64.const	$push11=, 14
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label21
# BB#5:                                 # %lor.lhs.false11.i
	i32.const	$push13=, 15
	i32.add 	$push14=, $2, $pop13
	i32.const	$push15=, -16
	i32.and 	$push73=, $pop14, $pop15
	tee_local	$push72=, $1=, $pop73
	i32.const	$push16=, 16
	i32.add 	$push71=, $pop72, $pop16
	tee_local	$push70=, $2=, $pop71
	i32.store	12($3), $pop70
	i64.load	$push18=, 0($1)
	i64.load	$push17=, 8($1)
	i64.const	$push20=, 0
	i64.const	$push19=, 4613381465357418496
	i32.call	$push21=, __netf2@FUNCTION, $pop18, $pop17, $pop20, $pop19
	br_if   	1, $pop21       # 1: down to label21
# BB#6:                                 # %lor.lhs.false15.i
	i32.const	$push22=, 20
	i32.add 	$push23=, $1, $pop22
	i32.store	12($3), $pop23
	i32.load	$push24=, 0($2)
	i32.const	$push25=, 17
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	1, $pop26       # 1: down to label21
.LBB10_7:                               # %bar.exit
	end_block                       # label22:
	i32.const	$push40=, 0
	i32.store	bar_arg($pop40), $0
	i32.const	$push76=, 0
	i32.load	$push42=, 12($3)
	i32.const	$push41=, 7
	i32.add 	$push43=, $pop42, $pop41
	i32.const	$push44=, -8
	i32.and 	$push75=, $pop43, $pop44
	tee_local	$push74=, $0=, $pop75
	i64.load	$push45=, 0($pop74)
	i64.store	d($pop76), $pop45
	i32.const	$push46=, 8
	i32.add 	$push47=, $0, $pop46
	i32.store	12($3), $pop47
	i32.const	$push54=, 0
	i32.const	$push52=, 16
	i32.add 	$push53=, $3, $pop52
	i32.store	__stack_pointer($pop54), $pop53
	return
.LBB10_8:                               # %if.then5.i
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end10:
	.size	f8, .Lfunc_end10-f8
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push44=, 0
	i32.const	$push42=, 0
	i32.load	$push41=, __stack_pointer($pop42)
	i32.const	$push43=, 176
	i32.sub 	$push71=, $pop41, $pop43
	tee_local	$push70=, $0=, $pop71
	i32.store	__stack_pointer($pop44), $pop70
	i32.const	$push69=, 0
	i64.const	$push1=, 4629418941960159232
	i64.store	d($pop69), $pop1
	i32.const	$push68=, 28
	i32.store	160($0), $pop68
	i32.const	$push48=, 160
	i32.add 	$push49=, $0, $pop48
	call    	f2@FUNCTION, $0, $pop49
	block   	
	i32.const	$push67=, 0
	i32.load	$push2=, bar_arg($pop67)
	i32.const	$push66=, 28
	i32.ne  	$push3=, $pop2, $pop66
	br_if   	0, $pop3        # 0: down to label24
# BB#1:                                 # %entry
	i32.const	$push73=, 0
	i32.load	$push0=, x($pop73)
	i32.const	$push72=, 28
	i32.ne  	$push4=, $pop0, $pop72
	br_if   	0, $pop4        # 0: down to label24
# BB#2:                                 # %if.end
	i64.const	$push5=, 4638813169307877376
	i64.store	144($0), $pop5
	i32.const	$push50=, 144
	i32.add 	$push51=, $0, $pop50
	call    	f3@FUNCTION, $0, $pop51
	i32.const	$push74=, 0
	f64.load	$push6=, d($pop74)
	f64.const	$push7=, 0x1.06p7
	f64.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label24
# BB#3:                                 # %if.end4
	i32.const	$push76=, 128
	i32.store	136($0), $pop76
	i64.const	$push10=, 4625196817309499392
	i64.store	128($0), $pop10
	i32.const	$push11=, 5
	i32.const	$push52=, 128
	i32.add 	$push53=, $0, $pop52
	call    	f4@FUNCTION, $pop11, $pop53
	i32.const	$push75=, 0
	i32.load	$push12=, x($pop75)
	i32.const	$push13=, 16
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label24
# BB#4:                                 # %if.end4
	i32.const	$push78=, 0
	i32.load	$push9=, foo_arg($pop78)
	i32.const	$push77=, 128
	i32.ne  	$push15=, $pop9, $pop77
	br_if   	0, $pop15       # 0: down to label24
# BB#5:                                 # %if.end9
	i32.const	$push16=, 129
	i32.store	120($0), $pop16
	i64.const	$push17=, 4625478292286210048
	i64.store	112($0), $pop17
	i32.const	$push18=, 16390
	i32.const	$push54=, 112
	i32.add 	$push55=, $0, $pop54
	call    	f5@FUNCTION, $pop18, $pop55
	i32.const	$push80=, 0
	i32.load	$push19=, bar_arg($pop80)
	i32.const	$push79=, 16390
	i32.ne  	$push20=, $pop19, $pop79
	br_if   	0, $pop20       # 0: down to label24
# BB#6:                                 # %if.end12
	i64.const	$push21=, 60129542156
	i64.store	96($0), $pop21
	i32.const	$push22=, -31
	i32.store	104($0), $pop22
	i32.const	$push56=, 96
	i32.add 	$push57=, $0, $pop56
	call    	f6@FUNCTION, $0, $pop57
	i32.const	$push82=, 0
	i32.load	$push23=, bar_arg($pop82)
	i32.const	$push81=, -31
	i32.ne  	$push24=, $pop23, $pop81
	br_if   	0, $pop24       # 0: down to label24
# BB#7:                                 # %if.end15
	i32.const	$push58=, 48
	i32.add 	$push59=, $0, $pop58
	i32.const	$push92=, 32
	i32.add 	$push25=, $pop59, $pop92
	i64.const	$push26=, 4628011567076605952
	i64.store	0($pop25), $pop26
	i32.const	$push60=, 48
	i32.add 	$push61=, $0, $pop60
	i32.const	$push91=, 24
	i32.add 	$push27=, $pop61, $pop91
	i32.const	$push90=, 17
	i32.store	0($pop27), $pop90
	i32.const	$push62=, 48
	i32.add 	$push63=, $0, $pop62
	i32.const	$push89=, 16
	i32.add 	$push28=, $pop63, $pop89
	i64.const	$push88=, 4613381465357418496
	i64.store	0($pop28), $pop88
	i64.const	$push87=, 0
	i64.store	56($0), $pop87
	i64.const	$push86=, 14
	i64.store	48($0), $pop86
	i32.const	$push85=, 16392
	i32.const	$push64=, 48
	i32.add 	$push65=, $0, $pop64
	call    	f7@FUNCTION, $pop85, $pop65
	i32.const	$push84=, 0
	i32.load	$push29=, bar_arg($pop84)
	i32.const	$push83=, 16392
	i32.ne  	$push30=, $pop29, $pop83
	br_if   	0, $pop30       # 0: down to label24
# BB#8:                                 # %if.end18
	i32.const	$push102=, 32
	i32.add 	$push32=, $0, $pop102
	i64.const	$push33=, 4628293042053316608
	i64.store	0($pop32), $pop33
	i32.const	$push101=, 24
	i32.add 	$push34=, $0, $pop101
	i32.const	$push100=, 17
	i32.store	0($pop34), $pop100
	i32.const	$push99=, 16
	i32.add 	$push35=, $0, $pop99
	i64.const	$push98=, 4613381465357418496
	i64.store	0($pop35), $pop98
	i64.const	$push97=, 0
	i64.store	8($0), $pop97
	i64.const	$push96=, 14
	i64.store	0($0), $pop96
	i32.const	$push95=, 16392
	call    	f8@FUNCTION, $pop95, $0
	i32.const	$push94=, 0
	i32.load	$push36=, bar_arg($pop94)
	i32.const	$push93=, 16392
	i32.ne  	$push37=, $pop36, $pop93
	br_if   	0, $pop37       # 0: down to label24
# BB#9:                                 # %if.end18
	i32.const	$push103=, 0
	f64.load	$push31=, d($pop103)
	f64.const	$push38=, 0x1.bp4
	f64.ne  	$push39=, $pop31, $pop38
	br_if   	0, $pop39       # 0: down to label24
# BB#10:                                # %if.end23
	i32.const	$push47=, 0
	i32.const	$push45=, 176
	i32.add 	$push46=, $0, $pop45
	i32.store	__stack_pointer($pop47), $pop46
	i32.const	$push40=, 0
	return  	$pop40
.LBB11_11:                              # %if.then
	end_block                       # label24:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end11:
	.size	main, .Lfunc_end11-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
