	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-pack-1.c"
	.section	.text.foo1,"ax",@progbits
	.hidden	foo1
	.globl	foo1
	.type	foo1,@function
foo1:                                   # @foo1
	.param  	i32, i32, i32
	.result 	i32
	.local  	i64, i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push90=, __stack_pointer
	i32.load	$push91=, 0($pop90)
	i32.const	$push92=, 32
	i32.sub 	$7=, $pop91, $pop92
	i32.const	$push93=, __stack_pointer
	i32.store	$discard=, 0($pop93), $7
	i32.store	$discard=, 12($7), $2
	block
	i32.const	$push2=, 19
	i32.gt_u	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %lor.lhs.false3
	i32.load8_u	$push4=, seen($0)
	br_if   	0, $pop4        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push5=, 0
	i32.const	$push78=, 0
	i32.load	$push6=, cnt($pop78)
	i32.const	$push7=, 1
	i32.add 	$push8=, $pop6, $pop7
	i32.store	$push9=, cnt($pop5), $pop8
	i32.store8	$discard=, seen($0), $pop9
	i32.const	$push10=, 6
	i32.ne  	$push11=, $1, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#3:                                 # %if.end9
	i32.load	$push80=, 12($7)
	tee_local	$push79=, $2=, $pop80
	i32.const	$push12=, 4
	i32.add 	$push0=, $pop79, $pop12
	i32.store	$1=, 12($7), $pop0
	i32.load	$push13=, 0($2)
	i32.const	$push14=, 5
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label0
# BB#4:                                 # %if.end13
	block
	i32.const	$push16=, 2
	i32.eq  	$push17=, $0, $pop16
	br_if   	0, $pop17       # 0: down to label1
# BB#5:                                 # %if.end13
	block
	i32.const	$push18=, 1
	i32.eq  	$push19=, $0, $pop18
	br_if   	0, $pop19       # 0: down to label2
# BB#6:                                 # %if.end13
	br_if   	2, $0           # 2: down to label0
# BB#7:                                 # %sw.bb
	i32.const	$push45=, 8
	i32.add 	$push1=, $2, $pop45
	i32.store	$1=, 12($7), $pop1
	i32.const	$push46=, 4
	i32.add 	$push47=, $2, $pop46
	i32.load	$push48=, 0($pop47)
	i32.const	$push81=, 9
	i32.ne  	$push49=, $pop48, $pop81
	br_if   	2, $pop49       # 2: down to label0
# BB#8:                                 # %sw.bb
	i32.const	$push50=, 0
	i32.load	$push44=, v1($pop50)
	i32.const	$push82=, 9
	i32.ne  	$push51=, $pop44, $pop82
	br_if   	2, $pop51       # 2: down to label0
# BB#9:                                 # %if.end22
	i32.const	$push58=, 8
	i32.add 	$push59=, $1, $pop58
	i32.load	$6=, 0($pop59):p2align=0
	i32.const	$push97=, 16
	i32.add 	$push98=, $7, $pop97
	i32.const	$push54=, 12
	i32.add 	$push57=, $pop98, $pop54
	i32.const	$push85=, 12
	i32.add 	$push55=, $1, $pop85
	i32.load	$push56=, 0($pop55):p2align=0
	i32.store	$discard=, 0($pop57), $pop56
	i32.const	$push99=, 16
	i32.add 	$push100=, $7, $pop99
	i32.const	$push84=, 8
	i32.add 	$push60=, $pop100, $pop84
	i32.store	$discard=, 0($pop60):p2align=3, $6
	i32.const	$push61=, 4
	i32.add 	$push62=, $1, $pop61
	i32.load	$6=, 0($pop62):p2align=0
	i32.const	$push52=, 24
	i32.add 	$push53=, $2, $pop52
	i32.store	$5=, 12($7), $pop53
	i32.load	$1=, 0($1):p2align=0
	i32.store	$discard=, 20($7), $6
	i32.store	$discard=, 16($7):p2align=3, $1
	i32.const	$push101=, 16
	i32.add 	$push102=, $7, $pop101
	i32.const	$push83=, v4
	i32.const	$push63=, 16
	i32.call	$push64=, memcmp@FUNCTION, $pop102, $pop83, $pop63
	br_if   	2, $pop64       # 2: down to label0
# BB#10:                                # %if.end28
	i32.const	$push65=, 28
	i32.add 	$push66=, $2, $pop65
	i32.store	$1=, 12($7), $pop66
	i32.load	$push67=, 0($5)
	i32.const	$push86=, v4
	i32.ne  	$push68=, $pop67, $pop86
	br_if   	2, $pop68       # 2: down to label0
# BB#11:                                # %if.end34
	i32.const	$push70=, 32
	i32.add 	$push71=, $2, $pop70
	i32.store	$discard=, 12($7), $pop71
	block
	i32.load	$push72=, 0($1)
	i32.const	$push73=, 3
	i32.ne  	$push74=, $pop72, $pop73
	br_if   	0, $pop74       # 0: down to label3
# BB#12:                                # %if.end34
	i32.const	$push75=, 0
	i32.load	$push69=, v2($pop75)
	i32.const	$push76=, 4
	i32.eq  	$push77=, $pop69, $pop76
	br_if   	2, $pop77       # 2: down to label1
.LBB0_13:                               # %if.then42
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %sw.bb44
	end_block                       # label2:
	i32.const	$push22=, 15
	i32.add 	$push23=, $1, $pop22
	i32.const	$push24=, -16
	i32.and 	$push88=, $pop23, $pop24
	tee_local	$push87=, $2=, $pop88
	i64.load	$4=, 8($pop87)
	i64.load	$3=, 0($2):p2align=4
	i32.const	$push25=, 16
	i32.add 	$push26=, $2, $pop25
	i32.store	$discard=, 12($7), $pop26
	i64.const	$push28=, 0
	i64.const	$push27=, 4612891083171430400
	i32.call	$push29=, __netf2@FUNCTION, $3, $4, $pop28, $pop27
	br_if   	1, $pop29       # 1: down to label0
# BB#15:                                # %sw.bb44
	i32.const	$push30=, 0
	i64.load	$push20=, v5($pop30):p2align=4
	i32.const	$push89=, 0
	i64.load	$push21=, v5+8($pop89)
	i32.call	$push31=, __eqtf2@FUNCTION, $pop20, $pop21, $3, $4
	br_if   	1, $pop31       # 1: down to label0
# BB#16:                                # %if.end53
	i32.const	$push32=, 20
	i32.add 	$push33=, $2, $pop32
	i32.store	$1=, 12($7), $pop33
	i32.const	$push34=, 16
	i32.add 	$push35=, $2, $pop34
	i32.load	$push36=, 0($pop35):p2align=4
	i32.const	$push37=, 8
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	1, $pop38       # 1: down to label0
# BB#17:                                # %if.end59
	i32.const	$push39=, 24
	i32.add 	$push40=, $2, $pop39
	i32.store	$discard=, 12($7), $pop40
	i32.load	$push41=, 0($1)
	i32.const	$push42=, v2
	i32.ne  	$push43=, $pop41, $pop42
	br_if   	1, $pop43       # 1: down to label0
.LBB0_18:                               # %sw.epilog
	end_block                       # label1:
	i32.const	$push96=, __stack_pointer
	i32.const	$push94=, 32
	i32.add 	$push95=, $7, $pop94
	i32.store	$discard=, 0($pop96), $pop95
	return  	$0
.LBB0_19:                               # %sw.default
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo1, .Lfunc_end0-foo1

	.section	.text.foo2,"ax",@progbits
	.hidden	foo2
	.globl	foo2
	.type	foo2,@function
foo2:                                   # @foo2
	.param  	i32, i32, i32
	.result 	i32
	.local  	i64, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push91=, __stack_pointer
	i32.load	$push92=, 0($pop91)
	i32.const	$push93=, 48
	i32.sub 	$6=, $pop92, $pop93
	i32.const	$push94=, __stack_pointer
	i32.store	$discard=, 0($pop94), $6
	i32.store	$discard=, 12($6), $2
	block
	i32.const	$push3=, 19
	i32.gt_u	$push4=, $0, $pop3
	br_if   	0, $pop4        # 0: down to label4
# BB#1:                                 # %lor.lhs.false3
	i32.load8_u	$push5=, seen($0)
	br_if   	0, $pop5        # 0: down to label4
# BB#2:                                 # %if.end
	i32.const	$push6=, 0
	i32.const	$push69=, 0
	i32.load	$push7=, cnt($pop69)
	i32.const	$push8=, 1
	i32.add 	$push9=, $pop7, $pop8
	i32.store	$push10=, cnt($pop6), $pop9
	i32.const	$push11=, 64
	i32.or  	$push12=, $pop10, $pop11
	i32.store8	$discard=, seen($0), $pop12
	i32.const	$push13=, 10
	i32.ne  	$push14=, $1, $pop13
	br_if   	0, $pop14       # 0: down to label4
# BB#3:                                 # %if.end9
	block
	i32.const	$push15=, 2
	i32.eq  	$push16=, $0, $pop15
	br_if   	0, $pop16       # 0: down to label5
# BB#4:                                 # %if.end9
	i32.const	$push17=, 11
	i32.eq  	$push18=, $0, $pop17
	br_if   	0, $pop18       # 0: down to label5
# BB#5:                                 # %if.end9
	i32.const	$push19=, 12
	i32.ne  	$push20=, $0, $pop19
	br_if   	1, $pop20       # 1: down to label4
# BB#6:                                 # %sw.bb
	i32.load	$push23=, 12($6)
	i32.const	$push24=, 15
	i32.add 	$push25=, $pop23, $pop24
	i32.const	$push26=, -16
	i32.and 	$push72=, $pop25, $pop26
	tee_local	$push71=, $2=, $pop72
	i64.load	$3=, 8($pop71)
	i64.load	$4=, 0($2):p2align=4
	i32.const	$push27=, 16
	i32.add 	$push0=, $2, $pop27
	i32.store	$1=, 12($6), $pop0
	i64.const	$push70=, 0
	i64.const	$push28=, 4612891083171430400
	i32.call	$push29=, __netf2@FUNCTION, $4, $3, $pop70, $pop28
	br_if   	1, $pop29       # 1: down to label4
# BB#7:                                 # %sw.bb
	i32.const	$push30=, 0
	i64.load	$push21=, v5($pop30):p2align=4
	i32.const	$push74=, 0
	i64.load	$push22=, v5+8($pop74)
	i64.const	$push73=, 0
	i64.const	$push31=, 4612882287078408192
	i32.call	$push32=, __eqtf2@FUNCTION, $pop21, $pop22, $pop73, $pop31
	br_if   	1, $pop32       # 1: down to label4
# BB#8:                                 # %if.end16
	i32.const	$push98=, 32
	i32.add 	$push99=, $6, $pop98
	i32.const	$push81=, 12
	i32.add 	$push36=, $pop99, $pop81
	i32.const	$push80=, 12
	i32.add 	$push34=, $1, $pop80
	i32.load	$push35=, 0($pop34):p2align=0
	i32.store	$discard=, 0($pop36), $pop35
	i32.const	$push100=, 32
	i32.add 	$push101=, $6, $pop100
	i32.const	$push79=, 8
	i32.add 	$push39=, $pop101, $pop79
	i32.const	$push78=, 8
	i32.add 	$push37=, $1, $pop78
	i32.load	$push38=, 0($pop37):p2align=0
	i32.store	$discard=, 0($pop39):p2align=3, $pop38
	i32.const	$push77=, 4
	i32.add 	$push40=, $1, $pop77
	i32.load	$push41=, 0($pop40):p2align=0
	i32.store	$discard=, 36($6), $pop41
	i32.const	$push33=, 32
	i32.add 	$push1=, $2, $pop33
	i32.store	$5=, 12($6), $pop1
	i32.load	$push42=, 0($1):p2align=0
	i32.store	$discard=, 32($6):p2align=3, $pop42
	i32.const	$push102=, 32
	i32.add 	$push103=, $6, $pop102
	i32.const	$push76=, v4
	i32.const	$push75=, 16
	i32.call	$push43=, memcmp@FUNCTION, $pop103, $pop76, $pop75
	br_if   	1, $pop43       # 1: down to label4
# BB#9:                                 # %if.end22
	i32.const	$push104=, 16
	i32.add 	$push105=, $6, $pop104
	i32.const	$push88=, 12
	i32.add 	$push48=, $pop105, $pop88
	i32.const	$push87=, 12
	i32.add 	$push46=, $5, $pop87
	i32.load	$push47=, 0($pop46):p2align=0
	i32.store	$discard=, 0($pop48), $pop47
	i32.const	$push106=, 16
	i32.add 	$push107=, $6, $pop106
	i32.const	$push86=, 8
	i32.add 	$push51=, $pop107, $pop86
	i32.const	$push85=, 8
	i32.add 	$push49=, $5, $pop85
	i32.load	$push50=, 0($pop49):p2align=0
	i32.store	$discard=, 0($pop51):p2align=3, $pop50
	i32.const	$push84=, 4
	i32.add 	$push52=, $5, $pop84
	i32.load	$push53=, 0($pop52):p2align=0
	i32.store	$discard=, 20($6), $pop53
	i32.const	$push44=, 48
	i32.add 	$push45=, $2, $pop44
	i32.store	$1=, 12($6), $pop45
	i32.load	$push54=, 0($5):p2align=0
	i32.store	$discard=, 16($6):p2align=3, $pop54
	i32.const	$push108=, 16
	i32.add 	$push109=, $6, $pop108
	i32.const	$push83=, v4
	i32.const	$push82=, 16
	i32.call	$push55=, memcmp@FUNCTION, $pop109, $pop83, $pop82
	br_if   	1, $pop55       # 1: down to label4
# BB#10:                                # %if.end31
	i32.const	$push56=, 52
	i32.add 	$push2=, $2, $pop56
	i32.store	$2=, 12($6), $pop2
	i32.load	$push57=, 0($1):p2align=4
	i32.const	$push58=, v2
	i32.ne  	$push59=, $pop57, $pop58
	br_if   	1, $pop59       # 1: down to label4
# BB#11:                                # %if.end37
	i32.const	$push60=, 7
	i32.add 	$push61=, $2, $pop60
	i32.const	$push62=, -8
	i32.and 	$push90=, $pop61, $pop62
	tee_local	$push89=, $2=, $pop90
	i64.load	$3=, 0($pop89)
	i32.const	$push63=, 8
	i32.add 	$push64=, $2, $pop63
	i32.store	$discard=, 12($6), $pop64
	i64.const	$push65=, 16
	i64.ne  	$push66=, $3, $pop65
	br_if   	1, $pop66       # 1: down to label4
.LBB1_12:                               # %sw.epilog
	end_block                       # label5:
	i32.const	$push67=, 8
	i32.add 	$push68=, $0, $pop67
	i32.const	$push97=, __stack_pointer
	i32.const	$push95=, 48
	i32.add 	$push96=, $6, $pop95
	i32.store	$discard=, 0($pop97), $pop96
	return  	$pop68
.LBB1_13:                               # %sw.default
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	foo2, .Lfunc_end1-foo2

	.section	.text.foo3,"ax",@progbits
	.hidden	foo3
	.globl	foo3
	.type	foo3,@function
foo3:                                   # @foo3
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	foo3, .Lfunc_end2-foo3

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push111=, __stack_pointer
	i32.load	$push112=, 0($pop111)
	i32.const	$push113=, 176
	i32.sub 	$5=, $pop112, $pop113
	i32.const	$push114=, __stack_pointer
	i32.store	$discard=, 0($pop114), $5
	i32.const	$push75=, 0
	i32.load	$0=, v1($pop75)
	i32.const	$push74=, 0
	i32.const	$push73=, 0
	i32.load	$push72=, v2($pop73)
	tee_local	$push71=, $4=, $pop72
	i32.const	$push70=, 1
	i32.add 	$push1=, $pop71, $pop70
	i32.store	$discard=, v2($pop74), $pop1
	i32.const	$push69=, 0
	i32.const	$push68=, 1
	i32.add 	$push0=, $0, $pop68
	i32.store	$0=, v1($pop69), $pop0
	i32.const	$push118=, 160
	i32.add 	$push119=, $5, $pop118
	i32.const	$push3=, 12
	i32.add 	$push4=, $pop119, $pop3
	i32.const	$push67=, 0
	i32.load	$push2=, v4+12($pop67):p2align=0
	i32.store	$discard=, 0($pop4), $pop2
	i32.const	$push120=, 160
	i32.add 	$push121=, $5, $pop120
	i32.const	$push66=, 8
	i32.add 	$push6=, $pop121, $pop66
	i32.const	$push65=, 0
	i32.load	$push5=, v4+8($pop65):p2align=0
	i32.store	$discard=, 0($pop6), $pop5
	i32.const	$push122=, 160
	i32.add 	$push123=, $5, $pop122
	i32.const	$push8=, 4
	i32.add 	$push9=, $pop123, $pop8
	i32.const	$push64=, 0
	i32.load	$push7=, v4+4($pop64):p2align=0
	i32.store	$discard=, 0($pop9), $pop7
	i32.const	$push63=, 0
	i32.load	$push10=, v4($pop63):p2align=0
	i32.store	$discard=, 160($5), $pop10
	i32.store	$discard=, 144($5):p2align=4, $0
	i32.store	$discard=, 156($5), $4
	i32.const	$push11=, v4
	i32.store	$discard=, 152($5):p2align=3, $pop11
	i32.const	$push124=, 160
	i32.add 	$push125=, $5, $pop124
	i32.store	$discard=, 148($5), $pop125
	block
	i32.const	$push62=, 0
	i32.const	$push126=, 144
	i32.add 	$push127=, $5, $pop126
	i32.call	$push12=, bar@FUNCTION, $pop62, $pop127
	br_if   	0, $pop12       # 0: down to label6
# BB#1:                                 # %if.end
	i32.const	$push128=, 96
	i32.add 	$push129=, $5, $pop128
	i32.const	$push84=, 0
	i64.load	$push14=, v5($pop84):p2align=4
	i32.const	$push83=, 0
	i64.load	$push13=, v5+8($pop83)
	i64.const	$push16=, 0
	i64.const	$push15=, 4611404543450677248
	call    	__addtf3@FUNCTION, $pop129, $pop14, $pop13, $pop16, $pop15
	i64.load	$1=, 96($5)
	i32.const	$push82=, 0
	i32.const	$push130=, 96
	i32.add 	$push131=, $5, $pop130
	i32.const	$push81=, 8
	i32.add 	$push17=, $pop131, $pop81
	i64.load	$push18=, 0($pop17)
	i64.store	$2=, v5+8($pop82), $pop18
	i32.const	$push80=, 0
	i32.load	$0=, v3($pop80)
	i32.const	$push79=, 0
	i64.store	$discard=, v5($pop79):p2align=4, $1
	i32.const	$push132=, 112
	i32.add 	$push133=, $5, $pop132
	i32.const	$push19=, 20
	i32.add 	$push20=, $pop133, $pop19
	i32.store	$discard=, 0($pop20), $0
	i32.const	$push134=, 112
	i32.add 	$push135=, $5, $pop134
	i32.const	$push21=, 16
	i32.add 	$push22=, $pop135, $pop21
	i32.const	$push78=, 8
	i32.store	$discard=, 0($pop22):p2align=4, $pop78
	i64.store	$discard=, 120($5), $2
	i64.store	$discard=, 112($5):p2align=4, $1
	i32.const	$push77=, 1
	i32.const	$push136=, 112
	i32.add 	$push137=, $5, $pop136
	i32.call	$push23=, bar@FUNCTION, $pop77, $pop137
	i32.const	$push76=, 1
	i32.ne  	$push24=, $pop23, $pop76
	br_if   	0, $pop24       # 0: down to label6
# BB#2:                                 # %if.end6
	i32.const	$push87=, 2
	i32.const	$push86=, 0
	i32.call	$push25=, bar@FUNCTION, $pop87, $pop86
	i32.const	$push85=, 2
	i32.ne  	$push26=, $pop25, $pop85
	br_if   	0, $pop26       # 0: down to label6
# BB#3:                                 # %if.end10
	i32.const	$push90=, 0
	i32.load	$push27=, v1($pop90)
	i32.const	$push89=, 2
	i32.add 	$push28=, $pop27, $pop89
	i32.const	$push88=, 0
	i32.call	$push29=, bar@FUNCTION, $pop28, $pop88
	i32.const	$push30=, 19
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label6
# BB#4:                                 # %if.end14
	i32.const	$push109=, 0
	i32.load	$0=, v1($pop109)
	i32.const	$push108=, 0
	i64.load	$push107=, v5($pop108):p2align=4
	tee_local	$push106=, $1=, $pop107
	i32.const	$push105=, 0
	i64.load	$push104=, v5+8($pop105)
	tee_local	$push103=, $2=, $pop104
	i64.const	$push35=, 0
	i64.const	$push34=, -4611967493404098560
	call    	__addtf3@FUNCTION, $5, $pop106, $pop103, $pop35, $pop34
	i64.load	$3=, 0($5)
	i32.const	$push102=, 0
	i32.const	$push36=, 8
	i32.add 	$push37=, $5, $pop36
	i64.load	$push38=, 0($pop37)
	i64.store	$discard=, v5+8($pop102), $pop38
	i32.const	$push101=, 0
	i64.store	$discard=, v5($pop101):p2align=4, $3
	i32.const	$push100=, 0
	i32.load	$4=, v3($pop100)
	i32.const	$push138=, 80
	i32.add 	$push139=, $5, $pop138
	i32.const	$push40=, 12
	i32.add 	$push41=, $pop139, $pop40
	i32.const	$push99=, 0
	i32.load	$push39=, v4+12($pop99):p2align=0
	i32.store	$discard=, 0($pop41), $pop39
	i32.const	$push140=, 80
	i32.add 	$push141=, $5, $pop140
	i32.const	$push98=, 8
	i32.add 	$push43=, $pop141, $pop98
	i32.const	$push97=, 0
	i32.load	$push42=, v4+8($pop97):p2align=0
	i32.store	$discard=, 0($pop43), $pop42
	i32.const	$push142=, 80
	i32.add 	$push143=, $5, $pop142
	i32.const	$push45=, 4
	i32.add 	$push46=, $pop143, $pop45
	i32.const	$push96=, 0
	i32.load	$push44=, v4+4($pop96):p2align=0
	i32.store	$discard=, 0($pop46), $pop44
	i32.const	$push95=, 0
	i32.load	$push47=, v4($pop95):p2align=0
	i32.store	$discard=, 80($5), $pop47
	i32.const	$push144=, 64
	i32.add 	$push145=, $5, $pop144
	i32.const	$push94=, 8
	i32.add 	$push48=, $pop145, $pop94
	i32.const	$push93=, 0
	i64.load	$push49=, v4+8($pop93):p2align=0
	i64.store	$discard=, 0($pop48):p2align=2, $pop49
	i32.const	$push92=, 0
	i64.load	$push50=, v4($pop92):p2align=0
	i64.store	$discard=, 64($5):p2align=2, $pop50
	i32.const	$push146=, 16
	i32.add 	$push147=, $5, $pop146
	i32.const	$push51=, 32
	i32.add 	$push52=, $pop147, $pop51
	i64.const	$push53=, 16
	i64.store	$discard=, 0($pop52):p2align=4, $pop53
	i32.const	$push148=, 16
	i32.add 	$push149=, $5, $pop148
	i32.const	$push54=, 24
	i32.add 	$push55=, $pop149, $pop54
	i32.store	$discard=, 0($pop55):p2align=3, $4
	i64.store	$discard=, 24($5), $2
	i32.const	$push150=, 16
	i32.add 	$push151=, $5, $pop150
	i32.const	$push56=, 20
	i32.add 	$push57=, $pop151, $pop56
	i32.const	$push152=, 64
	i32.add 	$push153=, $5, $pop152
	i32.store	$discard=, 0($pop57), $pop153
	i32.const	$push154=, 16
	i32.add 	$push155=, $5, $pop154
	i32.const	$push58=, 16
	i32.add 	$push59=, $pop155, $pop58
	i32.const	$push156=, 80
	i32.add 	$push157=, $5, $pop156
	i32.store	$discard=, 0($pop59):p2align=4, $pop157
	i64.store	$discard=, 16($5):p2align=4, $1
	i32.const	$push32=, 3
	i32.add 	$push33=, $0, $pop32
	i32.const	$push158=, 16
	i32.add 	$push159=, $5, $pop158
	i32.call	$push60=, bar@FUNCTION, $pop33, $pop159
	i32.const	$push91=, 20
	i32.ne  	$push61=, $pop60, $pop91
	br_if   	0, $pop61       # 0: down to label6
# BB#5:                                 # %if.end19
	i32.const	$push110=, 0
	i32.const	$push117=, __stack_pointer
	i32.const	$push115=, 176
	i32.add 	$push116=, $5, $pop115
	i32.store	$discard=, 0($pop117), $pop116
	return  	$pop110
.LBB3_6:                                # %if.then18
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	v1                      # @v1
	.type	v1,@object
	.section	.data.v1,"aw",@progbits
	.globl	v1
	.p2align	2
v1:
	.int32	8                       # 0x8
	.size	v1, 4

	.hidden	v2                      # @v2
	.type	v2,@object
	.section	.data.v2,"aw",@progbits
	.globl	v2
	.p2align	2
v2:
	.int32	3                       # 0x3
	.size	v2, 4

	.hidden	v3                      # @v3
	.type	v3,@object
	.section	.data.v3,"aw",@progbits
	.globl	v3
	.p2align	2
v3:
	.int32	v2
	.size	v3, 4

	.hidden	v4                      # @v4
	.type	v4,@object
	.section	.data.v4,"aw",@progbits
	.globl	v4
v4:
	.asciz	"foo\000\000\000\000\000\000\000\000\000\000\000\000"
	.size	v4, 16

	.hidden	v5                      # @v5
	.type	v5,@object
	.section	.data.v5,"aw",@progbits
	.globl	v5
	.p2align	4
v5:
	.int64	0                       # fp128 40
	.int64	4612882287078408192
	.size	v5, 16

	.hidden	seen                    # @seen
	.type	seen,@object
	.section	.bss.seen,"aw",@nobits
	.globl	seen
	.p2align	4
seen:
	.skip	20
	.size	seen, 20

	.hidden	cnt                     # @cnt
	.type	cnt,@object
	.section	.bss.cnt,"aw",@nobits
	.globl	cnt
	.p2align	2
cnt:
	.int32	0                       # 0x0
	.size	cnt, 4


	.ident	"clang version 3.9.0 "
