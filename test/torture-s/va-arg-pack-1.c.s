	.text
	.file	"va-arg-pack-1.c"
	.section	.text.foo1,"ax",@progbits
	.hidden	foo1                    # -- Begin function foo1
	.globl	foo1
	.type	foo1,@function
foo1:                                   # @foo1
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push71=, 0
	i32.const	$push69=, 0
	i32.load	$push68=, __stack_pointer($pop69)
	i32.const	$push70=, 32
	i32.sub 	$push80=, $pop68, $pop70
	tee_local	$push79=, $6=, $pop80
	i32.store	__stack_pointer($pop71), $pop79
	i32.store	12($6), $2
	block   	
	i32.const	$push0=, 19
	i32.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %lor.lhs.false3
	i32.const	$push2=, seen
	i32.add 	$push82=, $0, $pop2
	tee_local	$push81=, $2=, $pop82
	i32.load8_u	$push3=, 0($pop81)
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push4=, 0
	i32.load	$push5=, cnt($pop4)
	i32.const	$push6=, 1
	i32.add 	$push85=, $pop5, $pop6
	tee_local	$push84=, $3=, $pop85
	i32.store8	0($2), $pop84
	i32.const	$push83=, 0
	i32.store	cnt($pop83), $3
	i32.const	$push7=, 6
	i32.ne  	$push8=, $1, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %if.end9
	i32.load	$push89=, 12($6)
	tee_local	$push88=, $1=, $pop89
	i32.const	$push9=, 4
	i32.add 	$push87=, $pop88, $pop9
	tee_local	$push86=, $2=, $pop87
	i32.store	12($6), $pop86
	i32.load	$push10=, 0($1)
	i32.const	$push11=, 5
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#4:                                 # %if.end13
	block   	
	i32.const	$push13=, 2
	i32.eq  	$push14=, $0, $pop13
	br_if   	0, $pop14       # 0: down to label1
# BB#5:                                 # %if.end13
	block   	
	i32.const	$push15=, 1
	i32.eq  	$push16=, $0, $pop15
	br_if   	0, $pop16       # 0: down to label2
# BB#6:                                 # %if.end13
	br_if   	2, $0           # 2: down to label0
# BB#7:                                 # %sw.bb
	i32.const	$push41=, 8
	i32.add 	$push92=, $1, $pop41
	tee_local	$push91=, $2=, $pop92
	i32.store	12($6), $pop91
	i32.const	$push42=, 4
	i32.add 	$push43=, $1, $pop42
	i32.load	$push44=, 0($pop43)
	i32.const	$push90=, 9
	i32.ne  	$push45=, $pop44, $pop90
	br_if   	2, $pop45       # 2: down to label0
# BB#8:                                 # %sw.bb
	i32.const	$push46=, 0
	i32.load	$push40=, v1($pop46)
	i32.const	$push93=, 9
	i32.ne  	$push47=, $pop40, $pop93
	br_if   	2, $pop47       # 2: down to label0
# BB#9:                                 # %if.end22
	i32.const	$push75=, 16
	i32.add 	$push76=, $6, $pop75
	i32.const	$push48=, 8
	i32.add 	$push51=, $pop76, $pop48
	i32.const	$push97=, 8
	i32.add 	$push49=, $2, $pop97
	i64.load	$push50=, 0($pop49):p2align=0
	i64.store	0($pop51), $pop50
	i64.load	$push52=, 0($2):p2align=0
	i64.store	16($6), $pop52
	i32.const	$push53=, 24
	i32.add 	$push96=, $1, $pop53
	tee_local	$push95=, $2=, $pop96
	i32.store	12($6), $pop95
	i32.const	$push77=, 16
	i32.add 	$push78=, $6, $pop77
	i32.const	$push94=, v4
	i32.const	$push54=, 16
	i32.call	$push55=, memcmp@FUNCTION, $pop78, $pop94, $pop54
	br_if   	2, $pop55       # 2: down to label0
# BB#10:                                # %if.end28
	i32.const	$push56=, 28
	i32.add 	$push100=, $1, $pop56
	tee_local	$push99=, $3=, $pop100
	i32.store	12($6), $pop99
	i32.load	$push57=, 0($2)
	i32.const	$push98=, v4
	i32.ne  	$push58=, $pop57, $pop98
	br_if   	2, $pop58       # 2: down to label0
# BB#11:                                # %if.end34
	i32.const	$push60=, 32
	i32.add 	$push61=, $1, $pop60
	i32.store	12($6), $pop61
	i32.load	$push62=, 0($3)
	i32.const	$push63=, 3
	i32.ne  	$push64=, $pop62, $pop63
	br_if   	2, $pop64       # 2: down to label0
# BB#12:                                # %if.end34
	i32.const	$push65=, 0
	i32.load	$push59=, v2($pop65)
	i32.const	$push66=, 4
	i32.eq  	$push67=, $pop59, $pop66
	br_if   	1, $pop67       # 1: down to label1
	br      	2               # 2: down to label0
.LBB0_13:                               # %sw.bb44
	end_block                       # label2:
	i32.const	$push19=, 15
	i32.add 	$push20=, $2, $pop19
	i32.const	$push21=, -16
	i32.and 	$push106=, $pop20, $pop21
	tee_local	$push105=, $1=, $pop106
	i32.const	$push22=, 16
	i32.add 	$push23=, $pop105, $pop22
	i32.store	12($6), $pop23
	i64.load	$push104=, 0($1)
	tee_local	$push103=, $4=, $pop104
	i64.load	$push102=, 8($1)
	tee_local	$push101=, $5=, $pop102
	i64.const	$push25=, 0
	i64.const	$push24=, 4612891083171430400
	i32.call	$push26=, __netf2@FUNCTION, $pop103, $pop101, $pop25, $pop24
	br_if   	1, $pop26       # 1: down to label0
# BB#14:                                # %sw.bb44
	i32.const	$push27=, 0
	i64.load	$push17=, v5($pop27)
	i32.const	$push107=, 0
	i64.load	$push18=, v5+8($pop107)
	i32.call	$push28=, __eqtf2@FUNCTION, $pop17, $pop18, $4, $5
	br_if   	1, $pop28       # 1: down to label0
# BB#15:                                # %if.end53
	i32.const	$push29=, 20
	i32.add 	$push109=, $1, $pop29
	tee_local	$push108=, $2=, $pop109
	i32.store	12($6), $pop108
	i32.const	$push30=, 16
	i32.add 	$push31=, $1, $pop30
	i32.load	$push32=, 0($pop31)
	i32.const	$push33=, 8
	i32.ne  	$push34=, $pop32, $pop33
	br_if   	1, $pop34       # 1: down to label0
# BB#16:                                # %if.end59
	i32.const	$push35=, 24
	i32.add 	$push36=, $1, $pop35
	i32.store	12($6), $pop36
	i32.load	$push37=, 0($2)
	i32.const	$push38=, v2
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	1, $pop39       # 1: down to label0
.LBB0_17:                               # %sw.epilog
	end_block                       # label1:
	i32.const	$push74=, 0
	i32.const	$push72=, 32
	i32.add 	$push73=, $6, $pop72
	i32.store	__stack_pointer($pop74), $pop73
	return  	$0
.LBB0_18:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo1, .Lfunc_end0-foo1
                                        # -- End function
	.section	.text.foo2,"ax",@progbits
	.hidden	foo2                    # -- Begin function foo2
	.globl	foo2
	.type	foo2,@function
foo2:                                   # @foo2
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push60=, 0
	i32.const	$push58=, 0
	i32.load	$push57=, __stack_pointer($pop58)
	i32.const	$push59=, 48
	i32.sub 	$push73=, $pop57, $pop59
	tee_local	$push72=, $4=, $pop73
	i32.store	__stack_pointer($pop60), $pop72
	i32.store	12($4), $2
	block   	
	i32.const	$push0=, 19
	i32.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label3
# BB#1:                                 # %lor.lhs.false3
	i32.const	$push2=, seen
	i32.add 	$push75=, $0, $pop2
	tee_local	$push74=, $2=, $pop75
	i32.load8_u	$push3=, 0($pop74)
	br_if   	0, $pop3        # 0: down to label3
# BB#2:                                 # %if.end
	i32.const	$push4=, 0
	i32.const	$push78=, 0
	i32.load	$push5=, cnt($pop78)
	i32.const	$push6=, 1
	i32.add 	$push77=, $pop5, $pop6
	tee_local	$push76=, $3=, $pop77
	i32.store	cnt($pop4), $pop76
	i32.const	$push7=, 64
	i32.or  	$push8=, $3, $pop7
	i32.store8	0($2), $pop8
	i32.const	$push9=, 10
	i32.ne  	$push10=, $1, $pop9
	br_if   	0, $pop10       # 0: down to label3
# BB#3:                                 # %if.end9
	block   	
	i32.const	$push11=, 2
	i32.eq  	$push12=, $0, $pop11
	br_if   	0, $pop12       # 0: down to label4
# BB#4:                                 # %if.end9
	i32.const	$push13=, 11
	i32.eq  	$push14=, $0, $pop13
	br_if   	0, $pop14       # 0: down to label4
# BB#5:                                 # %if.end9
	i32.const	$push15=, 12
	i32.ne  	$push16=, $0, $pop15
	br_if   	1, $pop16       # 1: down to label3
# BB#6:                                 # %sw.bb
	i32.load	$push20=, 12($4)
	i32.const	$push19=, 15
	i32.add 	$push21=, $pop20, $pop19
	i32.const	$push22=, -16
	i32.and 	$push83=, $pop21, $pop22
	tee_local	$push82=, $1=, $pop83
	i32.const	$push23=, 16
	i32.add 	$push81=, $pop82, $pop23
	tee_local	$push80=, $2=, $pop81
	i32.store	12($4), $pop80
	i64.load	$push25=, 0($1)
	i64.load	$push24=, 8($1)
	i64.const	$push79=, 0
	i64.const	$push26=, 4612891083171430400
	i32.call	$push27=, __netf2@FUNCTION, $pop25, $pop24, $pop79, $pop26
	br_if   	1, $pop27       # 1: down to label3
# BB#7:                                 # %sw.bb
	i32.const	$push28=, 0
	i64.load	$push17=, v5($pop28)
	i32.const	$push85=, 0
	i64.load	$push18=, v5+8($pop85)
	i64.const	$push84=, 0
	i64.const	$push29=, 4612882287078408192
	i32.call	$push30=, __eqtf2@FUNCTION, $pop17, $pop18, $pop84, $pop29
	br_if   	1, $pop30       # 1: down to label3
# BB#8:                                 # %if.end16
	i32.const	$push64=, 32
	i32.add 	$push65=, $4, $pop64
	i32.const	$push91=, 8
	i32.add 	$push33=, $pop65, $pop91
	i32.const	$push90=, 8
	i32.add 	$push31=, $2, $pop90
	i64.load	$push32=, 0($pop31):p2align=0
	i64.store	0($pop33), $pop32
	i64.load	$push34=, 0($2):p2align=0
	i64.store	32($4), $pop34
	i32.const	$push35=, 32
	i32.add 	$push89=, $1, $pop35
	tee_local	$push88=, $2=, $pop89
	i32.store	12($4), $pop88
	i32.const	$push66=, 32
	i32.add 	$push67=, $4, $pop66
	i32.const	$push87=, v4
	i32.const	$push86=, 16
	i32.call	$push36=, memcmp@FUNCTION, $pop67, $pop87, $pop86
	br_if   	1, $pop36       # 1: down to label3
# BB#9:                                 # %if.end22
	i32.const	$push68=, 16
	i32.add 	$push69=, $4, $pop68
	i32.const	$push97=, 8
	i32.add 	$push39=, $pop69, $pop97
	i32.const	$push96=, 8
	i32.add 	$push37=, $2, $pop96
	i64.load	$push38=, 0($pop37):p2align=0
	i64.store	0($pop39), $pop38
	i64.load	$push40=, 0($2):p2align=0
	i64.store	16($4), $pop40
	i32.const	$push41=, 48
	i32.add 	$push95=, $1, $pop41
	tee_local	$push94=, $2=, $pop95
	i32.store	12($4), $pop94
	i32.const	$push70=, 16
	i32.add 	$push71=, $4, $pop70
	i32.const	$push93=, v4
	i32.const	$push92=, 16
	i32.call	$push42=, memcmp@FUNCTION, $pop71, $pop93, $pop92
	br_if   	1, $pop42       # 1: down to label3
# BB#10:                                # %if.end31
	i32.const	$push43=, 52
	i32.add 	$push99=, $1, $pop43
	tee_local	$push98=, $1=, $pop99
	i32.store	12($4), $pop98
	i32.load	$push44=, 0($2)
	i32.const	$push45=, v2
	i32.ne  	$push46=, $pop44, $pop45
	br_if   	1, $pop46       # 1: down to label3
# BB#11:                                # %if.end37
	i32.const	$push47=, 7
	i32.add 	$push48=, $1, $pop47
	i32.const	$push49=, -8
	i32.and 	$push101=, $pop48, $pop49
	tee_local	$push100=, $1=, $pop101
	i32.const	$push50=, 8
	i32.add 	$push51=, $pop100, $pop50
	i32.store	12($4), $pop51
	i64.load	$push52=, 0($1)
	i64.const	$push53=, 16
	i64.ne  	$push54=, $pop52, $pop53
	br_if   	1, $pop54       # 1: down to label3
.LBB1_12:                               # %sw.epilog
	end_block                       # label4:
	i32.const	$push63=, 0
	i32.const	$push61=, 48
	i32.add 	$push62=, $4, $pop61
	i32.store	__stack_pointer($pop63), $pop62
	i32.const	$push55=, 8
	i32.add 	$push56=, $0, $pop55
	return  	$pop56
.LBB1_13:                               # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	foo2, .Lfunc_end1-foo2
                                        # -- End function
	.section	.text.foo3,"ax",@progbits
	.hidden	foo3                    # -- Begin function foo3
	.globl	foo3
	.type	foo3,@function
foo3:                                   # @foo3
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	foo3, .Lfunc_end2-foo3
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push52=, 0
	i32.const	$push50=, 0
	i32.load	$push49=, __stack_pointer($pop50)
	i32.const	$push51=, 176
	i32.sub 	$push95=, $pop49, $pop51
	tee_local	$push94=, $5=, $pop95
	i32.store	__stack_pointer($pop52), $pop94
	i32.const	$push56=, 160
	i32.add 	$push57=, $5, $pop56
	i32.const	$push93=, 8
	i32.add 	$push1=, $pop57, $pop93
	i32.const	$push92=, 0
	i64.load	$push0=, v4+8($pop92):p2align=0
	i64.store	0($pop1), $pop0
	i32.const	$push91=, 0
	i32.const	$push90=, 0
	i32.load	$push2=, v1($pop90)
	i32.const	$push89=, 1
	i32.add 	$push88=, $pop2, $pop89
	tee_local	$push87=, $0=, $pop88
	i32.store	v1($pop91), $pop87
	i32.const	$push86=, 0
	i32.const	$push85=, 0
	i32.load	$push84=, v2($pop85)
	tee_local	$push83=, $1=, $pop84
	i32.const	$push82=, 1
	i32.add 	$push3=, $pop83, $pop82
	i32.store	v2($pop86), $pop3
	i32.const	$push4=, v4
	i32.store	152($5), $pop4
	i32.const	$push81=, 0
	i64.load	$push5=, v4($pop81):p2align=0
	i64.store	160($5), $pop5
	i32.store	156($5), $1
	i32.store	144($5), $0
	i32.const	$push58=, 160
	i32.add 	$push59=, $5, $pop58
	i32.store	148($5), $pop59
	block   	
	i32.const	$push80=, 0
	i32.const	$push60=, 144
	i32.add 	$push61=, $5, $pop60
	i32.call	$push6=, bar@FUNCTION, $pop80, $pop61
	br_if   	0, $pop6        # 0: down to label5
# BB#1:                                 # %if.end
	i32.const	$push62=, 96
	i32.add 	$push63=, $5, $pop62
	i32.const	$push108=, 0
	i64.load	$push8=, v5($pop108)
	i32.const	$push107=, 0
	i64.load	$push7=, v5+8($pop107)
	i64.const	$push10=, 0
	i64.const	$push9=, 4611404543450677248
	call    	__addtf3@FUNCTION, $pop63, $pop8, $pop7, $pop10, $pop9
	i32.const	$push12=, 132
	i32.add 	$push13=, $5, $pop12
	i32.const	$push106=, 0
	i32.load	$push11=, v3($pop106)
	i32.store	0($pop13), $pop11
	i32.const	$push14=, 128
	i32.add 	$push15=, $5, $pop14
	i32.const	$push105=, 8
	i32.store	0($pop15), $pop105
	i32.const	$push104=, 0
	i32.const	$push64=, 96
	i32.add 	$push65=, $5, $pop64
	i32.const	$push103=, 8
	i32.add 	$push16=, $pop65, $pop103
	i64.load	$push102=, 0($pop16)
	tee_local	$push101=, $2=, $pop102
	i64.store	v5+8($pop104), $pop101
	i32.const	$push100=, 0
	i64.load	$push99=, 96($5)
	tee_local	$push98=, $3=, $pop99
	i64.store	v5($pop100), $pop98
	i64.store	120($5), $2
	i64.store	112($5), $3
	i32.const	$push97=, 1
	i32.const	$push66=, 112
	i32.add 	$push67=, $5, $pop66
	i32.call	$push17=, bar@FUNCTION, $pop97, $pop67
	i32.const	$push96=, 1
	i32.ne  	$push18=, $pop17, $pop96
	br_if   	0, $pop18       # 0: down to label5
# BB#2:                                 # %if.end6
	i32.const	$push111=, 2
	i32.const	$push110=, 0
	i32.call	$push19=, bar@FUNCTION, $pop111, $pop110
	i32.const	$push109=, 2
	i32.ne  	$push20=, $pop19, $pop109
	br_if   	0, $pop20       # 0: down to label5
# BB#3:                                 # %if.end10
	i32.const	$push114=, 0
	i32.load	$push21=, v1($pop114)
	i32.const	$push113=, 2
	i32.add 	$push22=, $pop21, $pop113
	i32.const	$push112=, 0
	i32.call	$push23=, bar@FUNCTION, $pop22, $pop112
	i32.const	$push24=, 19
	i32.ne  	$push25=, $pop23, $pop24
	br_if   	0, $pop25       # 0: down to label5
# BB#4:                                 # %if.end14
	i32.const	$push133=, 0
	i64.load	$push132=, v5($pop133)
	tee_local	$push131=, $2=, $pop132
	i32.const	$push130=, 0
	i64.load	$push129=, v5+8($pop130)
	tee_local	$push128=, $3=, $pop129
	i64.const	$push27=, 0
	i64.const	$push26=, -4611967493404098560
	call    	__addtf3@FUNCTION, $5, $pop131, $pop128, $pop27, $pop26
	i32.const	$push68=, 80
	i32.add 	$push69=, $5, $pop68
	i32.const	$push28=, 8
	i32.add 	$push29=, $pop69, $pop28
	i32.const	$push127=, 0
	i64.load	$push126=, v4+8($pop127):p2align=0
	tee_local	$push125=, $4=, $pop126
	i64.store	0($pop29), $pop125
	i32.const	$push70=, 64
	i32.add 	$push71=, $5, $pop70
	i32.const	$push124=, 8
	i32.add 	$push30=, $pop71, $pop124
	i64.store	0($pop30), $4
	i32.const	$push31=, 48
	i32.add 	$push32=, $5, $pop31
	i64.const	$push33=, 16
	i64.store	0($pop32), $pop33
	i32.const	$push35=, 40
	i32.add 	$push36=, $5, $pop35
	i32.const	$push123=, 0
	i32.load	$push34=, v3($pop123)
	i32.store	0($pop36), $pop34
	i32.const	$push122=, 0
	i32.const	$push121=, 8
	i32.add 	$push37=, $5, $pop121
	i64.load	$push38=, 0($pop37)
	i64.store	v5+8($pop122), $pop38
	i32.const	$push120=, 0
	i64.load	$push39=, 0($5)
	i64.store	v5($pop120), $pop39
	i32.const	$push119=, 0
	i64.load	$push118=, v4($pop119):p2align=0
	tee_local	$push117=, $4=, $pop118
	i64.store	80($5), $pop117
	i64.store	64($5), $4
	i32.const	$push72=, 16
	i32.add 	$push73=, $5, $pop72
	i32.const	$push40=, 20
	i32.add 	$push41=, $pop73, $pop40
	i32.const	$push74=, 64
	i32.add 	$push75=, $5, $pop74
	i32.store	0($pop41), $pop75
	i32.const	$push42=, 32
	i32.add 	$push43=, $5, $pop42
	i32.const	$push76=, 80
	i32.add 	$push77=, $5, $pop76
	i32.store	0($pop43), $pop77
	i64.store	24($5), $3
	i64.store	16($5), $2
	i32.const	$push116=, 0
	i32.load	$push44=, v1($pop116)
	i32.const	$push45=, 3
	i32.add 	$push46=, $pop44, $pop45
	i32.const	$push78=, 16
	i32.add 	$push79=, $5, $pop78
	i32.call	$push47=, bar@FUNCTION, $pop46, $pop79
	i32.const	$push115=, 20
	i32.ne  	$push48=, $pop47, $pop115
	br_if   	0, $pop48       # 0: down to label5
# BB#5:                                 # %if.end19
	i32.const	$push55=, 0
	i32.const	$push53=, 176
	i32.add 	$push54=, $5, $pop53
	i32.store	__stack_pointer($pop55), $pop54
	i32.const	$push134=, 0
	return  	$pop134
.LBB3_6:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	memcmp, i32, i32, i32, i32
	.functype	bar, i32, i32
