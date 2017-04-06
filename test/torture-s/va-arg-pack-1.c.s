	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-pack-1.c"
	.section	.text.foo1,"ax",@progbits
	.hidden	foo1
	.globl	foo1
	.type	foo1,@function
foo1:                                   # @foo1
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push78=, 0
	i32.const	$push76=, 0
	i32.load	$push75=, __stack_pointer($pop76)
	i32.const	$push77=, 32
	i32.sub 	$push89=, $pop75, $pop77
	tee_local	$push88=, $6=, $pop89
	i32.store	__stack_pointer($pop78), $pop88
	i32.store	12($6), $2
	block   	
	i32.const	$push0=, 19
	i32.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %lor.lhs.false3
	i32.const	$push2=, seen
	i32.add 	$push91=, $0, $pop2
	tee_local	$push90=, $2=, $pop91
	i32.load8_u	$push3=, 0($pop90)
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push4=, 0
	i32.load	$push5=, cnt($pop4)
	i32.const	$push6=, 1
	i32.add 	$push94=, $pop5, $pop6
	tee_local	$push93=, $3=, $pop94
	i32.store8	0($2), $pop93
	i32.const	$push92=, 0
	i32.store	cnt($pop92), $3
	i32.const	$push7=, 6
	i32.ne  	$push8=, $1, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %if.end9
	i32.load	$push98=, 12($6)
	tee_local	$push97=, $2=, $pop98
	i32.const	$push9=, 4
	i32.add 	$push96=, $pop97, $pop9
	tee_local	$push95=, $1=, $pop96
	i32.store	12($6), $pop95
	i32.load	$push10=, 0($2)
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
	i32.add 	$push101=, $2, $pop41
	tee_local	$push100=, $1=, $pop101
	i32.store	12($6), $pop100
	i32.const	$push42=, 4
	i32.add 	$push43=, $2, $pop42
	i32.load	$push44=, 0($pop43)
	i32.const	$push99=, 9
	i32.ne  	$push45=, $pop44, $pop99
	br_if   	2, $pop45       # 2: down to label0
# BB#8:                                 # %sw.bb
	i32.const	$push46=, 0
	i32.load	$push40=, v1($pop46)
	i32.const	$push102=, 9
	i32.ne  	$push47=, $pop40, $pop102
	br_if   	2, $pop47       # 2: down to label0
# BB#9:                                 # %if.end22
	i32.const	$push82=, 16
	i32.add 	$push83=, $6, $pop82
	i32.const	$push48=, 12
	i32.add 	$push51=, $pop83, $pop48
	i32.const	$push107=, 12
	i32.add 	$push49=, $1, $pop107
	i32.load	$push50=, 0($pop49):p2align=0
	i32.store	0($pop51), $pop50
	i32.const	$push84=, 16
	i32.add 	$push85=, $6, $pop84
	i32.const	$push52=, 8
	i32.add 	$push55=, $pop85, $pop52
	i32.const	$push106=, 8
	i32.add 	$push53=, $1, $pop106
	i32.load	$push54=, 0($pop53):p2align=0
	i32.store	0($pop55), $pop54
	i32.const	$push56=, 24
	i32.add 	$push105=, $2, $pop56
	tee_local	$push104=, $3=, $pop105
	i32.store	12($6), $pop104
	i32.const	$push57=, 4
	i32.add 	$push58=, $1, $pop57
	i32.load	$push59=, 0($pop58):p2align=0
	i32.store	20($6), $pop59
	i32.load	$push60=, 0($1):p2align=0
	i32.store	16($6), $pop60
	i32.const	$push86=, 16
	i32.add 	$push87=, $6, $pop86
	i32.const	$push103=, v4
	i32.const	$push61=, 16
	i32.call	$push62=, memcmp@FUNCTION, $pop87, $pop103, $pop61
	br_if   	2, $pop62       # 2: down to label0
# BB#10:                                # %if.end28
	i32.const	$push63=, 28
	i32.add 	$push110=, $2, $pop63
	tee_local	$push109=, $1=, $pop110
	i32.store	12($6), $pop109
	i32.load	$push64=, 0($3)
	i32.const	$push108=, v4
	i32.ne  	$push65=, $pop64, $pop108
	br_if   	2, $pop65       # 2: down to label0
# BB#11:                                # %if.end34
	i32.const	$push67=, 32
	i32.add 	$push68=, $2, $pop67
	i32.store	12($6), $pop68
	i32.load	$push69=, 0($1)
	i32.const	$push70=, 3
	i32.ne  	$push71=, $pop69, $pop70
	br_if   	2, $pop71       # 2: down to label0
# BB#12:                                # %if.end34
	i32.const	$push72=, 0
	i32.load	$push66=, v2($pop72)
	i32.const	$push73=, 4
	i32.eq  	$push74=, $pop66, $pop73
	br_if   	1, $pop74       # 1: down to label1
	br      	2               # 2: down to label0
.LBB0_13:                               # %sw.bb44
	end_block                       # label2:
	i32.const	$push19=, 15
	i32.add 	$push20=, $1, $pop19
	i32.const	$push21=, -16
	i32.and 	$push116=, $pop20, $pop21
	tee_local	$push115=, $2=, $pop116
	i32.const	$push22=, 16
	i32.add 	$push23=, $pop115, $pop22
	i32.store	12($6), $pop23
	i64.load	$push114=, 0($2)
	tee_local	$push113=, $4=, $pop114
	i64.load	$push112=, 8($2)
	tee_local	$push111=, $5=, $pop112
	i64.const	$push25=, 0
	i64.const	$push24=, 4612891083171430400
	i32.call	$push26=, __netf2@FUNCTION, $pop113, $pop111, $pop25, $pop24
	br_if   	1, $pop26       # 1: down to label0
# BB#14:                                # %sw.bb44
	i32.const	$push27=, 0
	i64.load	$push17=, v5($pop27)
	i32.const	$push117=, 0
	i64.load	$push18=, v5+8($pop117)
	i32.call	$push28=, __eqtf2@FUNCTION, $pop17, $pop18, $4, $5
	br_if   	1, $pop28       # 1: down to label0
# BB#15:                                # %if.end53
	i32.const	$push29=, 20
	i32.add 	$push119=, $2, $pop29
	tee_local	$push118=, $1=, $pop119
	i32.store	12($6), $pop118
	i32.const	$push30=, 16
	i32.add 	$push31=, $2, $pop30
	i32.load	$push32=, 0($pop31)
	i32.const	$push33=, 8
	i32.ne  	$push34=, $pop32, $pop33
	br_if   	1, $pop34       # 1: down to label0
# BB#16:                                # %if.end59
	i32.const	$push35=, 24
	i32.add 	$push36=, $2, $pop35
	i32.store	12($6), $pop36
	i32.load	$push37=, 0($1)
	i32.const	$push38=, v2
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	1, $pop39       # 1: down to label0
.LBB0_17:                               # %sw.epilog
	end_block                       # label1:
	i32.const	$push81=, 0
	i32.const	$push79=, 32
	i32.add 	$push80=, $6, $pop79
	i32.store	__stack_pointer($pop81), $pop80
	return  	$0
.LBB0_18:                               # %if.then
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push70=, 0
	i32.const	$push68=, 0
	i32.load	$push67=, __stack_pointer($pop68)
	i32.const	$push69=, 48
	i32.sub 	$push87=, $pop67, $pop69
	tee_local	$push86=, $4=, $pop87
	i32.store	__stack_pointer($pop70), $pop86
	i32.store	12($4), $2
	block   	
	i32.const	$push0=, 19
	i32.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label3
# BB#1:                                 # %lor.lhs.false3
	i32.const	$push2=, seen
	i32.add 	$push89=, $0, $pop2
	tee_local	$push88=, $2=, $pop89
	i32.load8_u	$push3=, 0($pop88)
	br_if   	0, $pop3        # 0: down to label3
# BB#2:                                 # %if.end
	i32.const	$push4=, 0
	i32.const	$push92=, 0
	i32.load	$push5=, cnt($pop92)
	i32.const	$push6=, 1
	i32.add 	$push91=, $pop5, $pop6
	tee_local	$push90=, $3=, $pop91
	i32.store	cnt($pop4), $pop90
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
	i32.and 	$push97=, $pop21, $pop22
	tee_local	$push96=, $2=, $pop97
	i32.const	$push23=, 16
	i32.add 	$push95=, $pop96, $pop23
	tee_local	$push94=, $1=, $pop95
	i32.store	12($4), $pop94
	i64.load	$push25=, 0($2)
	i64.load	$push24=, 8($2)
	i64.const	$push93=, 0
	i64.const	$push26=, 4612891083171430400
	i32.call	$push27=, __netf2@FUNCTION, $pop25, $pop24, $pop93, $pop26
	br_if   	1, $pop27       # 1: down to label3
# BB#7:                                 # %sw.bb
	i32.const	$push28=, 0
	i64.load	$push17=, v5($pop28)
	i32.const	$push99=, 0
	i64.load	$push18=, v5+8($pop99)
	i64.const	$push98=, 0
	i64.const	$push29=, 4612882287078408192
	i32.call	$push30=, __eqtf2@FUNCTION, $pop17, $pop18, $pop98, $pop29
	br_if   	1, $pop30       # 1: down to label3
# BB#8:                                 # %if.end16
	i32.const	$push74=, 32
	i32.add 	$push75=, $4, $pop74
	i32.const	$push108=, 12
	i32.add 	$push33=, $pop75, $pop108
	i32.const	$push107=, 12
	i32.add 	$push31=, $1, $pop107
	i32.load	$push32=, 0($pop31):p2align=0
	i32.store	0($pop33), $pop32
	i32.const	$push76=, 32
	i32.add 	$push77=, $4, $pop76
	i32.const	$push106=, 8
	i32.add 	$push36=, $pop77, $pop106
	i32.const	$push105=, 8
	i32.add 	$push34=, $1, $pop105
	i32.load	$push35=, 0($pop34):p2align=0
	i32.store	0($pop36), $pop35
	i32.const	$push37=, 32
	i32.add 	$push104=, $2, $pop37
	tee_local	$push103=, $3=, $pop104
	i32.store	12($4), $pop103
	i32.const	$push102=, 4
	i32.add 	$push38=, $1, $pop102
	i32.load	$push39=, 0($pop38):p2align=0
	i32.store	36($4), $pop39
	i32.load	$push40=, 0($1):p2align=0
	i32.store	32($4), $pop40
	i32.const	$push78=, 32
	i32.add 	$push79=, $4, $pop78
	i32.const	$push101=, v4
	i32.const	$push100=, 16
	i32.call	$push41=, memcmp@FUNCTION, $pop79, $pop101, $pop100
	br_if   	1, $pop41       # 1: down to label3
# BB#9:                                 # %if.end22
	i32.const	$push80=, 16
	i32.add 	$push81=, $4, $pop80
	i32.const	$push117=, 12
	i32.add 	$push44=, $pop81, $pop117
	i32.const	$push116=, 12
	i32.add 	$push42=, $3, $pop116
	i32.load	$push43=, 0($pop42):p2align=0
	i32.store	0($pop44), $pop43
	i32.const	$push82=, 16
	i32.add 	$push83=, $4, $pop82
	i32.const	$push115=, 8
	i32.add 	$push47=, $pop83, $pop115
	i32.const	$push114=, 8
	i32.add 	$push45=, $3, $pop114
	i32.load	$push46=, 0($pop45):p2align=0
	i32.store	0($pop47), $pop46
	i32.const	$push48=, 48
	i32.add 	$push113=, $2, $pop48
	tee_local	$push112=, $1=, $pop113
	i32.store	12($4), $pop112
	i32.const	$push111=, 4
	i32.add 	$push49=, $3, $pop111
	i32.load	$push50=, 0($pop49):p2align=0
	i32.store	20($4), $pop50
	i32.load	$push51=, 0($3):p2align=0
	i32.store	16($4), $pop51
	i32.const	$push84=, 16
	i32.add 	$push85=, $4, $pop84
	i32.const	$push110=, v4
	i32.const	$push109=, 16
	i32.call	$push52=, memcmp@FUNCTION, $pop85, $pop110, $pop109
	br_if   	1, $pop52       # 1: down to label3
# BB#10:                                # %if.end31
	i32.const	$push53=, 52
	i32.add 	$push119=, $2, $pop53
	tee_local	$push118=, $2=, $pop119
	i32.store	12($4), $pop118
	i32.load	$push54=, 0($1)
	i32.const	$push55=, v2
	i32.ne  	$push56=, $pop54, $pop55
	br_if   	1, $pop56       # 1: down to label3
# BB#11:                                # %if.end37
	i32.const	$push57=, 7
	i32.add 	$push58=, $2, $pop57
	i32.const	$push59=, -8
	i32.and 	$push121=, $pop58, $pop59
	tee_local	$push120=, $2=, $pop121
	i32.const	$push60=, 8
	i32.add 	$push61=, $pop120, $pop60
	i32.store	12($4), $pop61
	i64.load	$push62=, 0($2)
	i64.const	$push63=, 16
	i64.ne  	$push64=, $pop62, $pop63
	br_if   	1, $pop64       # 1: down to label3
.LBB1_12:                               # %sw.epilog
	end_block                       # label4:
	i32.const	$push73=, 0
	i32.const	$push71=, 48
	i32.add 	$push72=, $4, $pop71
	i32.store	__stack_pointer($pop73), $pop72
	i32.const	$push65=, 8
	i32.add 	$push66=, $0, $pop65
	return  	$pop66
.LBB1_13:                               # %if.then
	end_block                       # label3:
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
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	foo3, .Lfunc_end2-foo3

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i64, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push59=, 0
	i32.const	$push57=, 0
	i32.load	$push56=, __stack_pointer($pop57)
	i32.const	$push58=, 176
	i32.sub 	$push102=, $pop56, $pop58
	tee_local	$push101=, $5=, $pop102
	i32.store	__stack_pointer($pop59), $pop101
	i32.const	$push63=, 160
	i32.add 	$push64=, $5, $pop63
	i32.const	$push100=, 8
	i32.add 	$push1=, $pop64, $pop100
	i32.const	$push99=, 0
	i64.load	$push0=, v4+8($pop99):p2align=0
	i64.store	0($pop1):p2align=2, $pop0
	i32.const	$push98=, 0
	i32.const	$push97=, 0
	i32.load	$push2=, v1($pop97)
	i32.const	$push96=, 1
	i32.add 	$push95=, $pop2, $pop96
	tee_local	$push94=, $0=, $pop95
	i32.store	v1($pop98), $pop94
	i32.const	$push93=, 0
	i32.const	$push92=, 0
	i32.load	$push91=, v2($pop92)
	tee_local	$push90=, $1=, $pop91
	i32.const	$push89=, 1
	i32.add 	$push3=, $pop90, $pop89
	i32.store	v2($pop93), $pop3
	i32.const	$push88=, 0
	i64.load	$push4=, v4($pop88):p2align=0
	i64.store	160($5):p2align=2, $pop4
	i32.store	144($5), $0
	i32.store	156($5), $1
	i32.const	$push5=, v4
	i32.store	152($5), $pop5
	i32.const	$push65=, 160
	i32.add 	$push66=, $5, $pop65
	i32.store	148($5), $pop66
	block   	
	i32.const	$push87=, 0
	i32.const	$push67=, 144
	i32.add 	$push68=, $5, $pop67
	i32.call	$push6=, bar@FUNCTION, $pop87, $pop68
	br_if   	0, $pop6        # 0: down to label5
# BB#1:                                 # %if.end
	i32.const	$push69=, 96
	i32.add 	$push70=, $5, $pop69
	i32.const	$push115=, 0
	i64.load	$push8=, v5($pop115)
	i32.const	$push114=, 0
	i64.load	$push7=, v5+8($pop114)
	i64.const	$push10=, 0
	i64.const	$push9=, 4611404543450677248
	call    	__addtf3@FUNCTION, $pop70, $pop8, $pop7, $pop10, $pop9
	i32.const	$push12=, 132
	i32.add 	$push13=, $5, $pop12
	i32.const	$push113=, 0
	i32.load	$push11=, v3($pop113)
	i32.store	0($pop13), $pop11
	i32.const	$push14=, 128
	i32.add 	$push15=, $5, $pop14
	i32.const	$push112=, 8
	i32.store	0($pop15), $pop112
	i32.const	$push111=, 0
	i32.const	$push71=, 96
	i32.add 	$push72=, $5, $pop71
	i32.const	$push110=, 8
	i32.add 	$push16=, $pop72, $pop110
	i64.load	$push109=, 0($pop16)
	tee_local	$push108=, $2=, $pop109
	i64.store	v5+8($pop111), $pop108
	i32.const	$push107=, 0
	i64.load	$push106=, 96($5)
	tee_local	$push105=, $3=, $pop106
	i64.store	v5($pop107), $pop105
	i64.store	120($5), $2
	i64.store	112($5), $3
	i32.const	$push104=, 1
	i32.const	$push73=, 112
	i32.add 	$push74=, $5, $pop73
	i32.call	$push17=, bar@FUNCTION, $pop104, $pop74
	i32.const	$push103=, 1
	i32.ne  	$push18=, $pop17, $pop103
	br_if   	0, $pop18       # 0: down to label5
# BB#2:                                 # %if.end6
	i32.const	$push118=, 2
	i32.const	$push117=, 0
	i32.call	$push19=, bar@FUNCTION, $pop118, $pop117
	i32.const	$push116=, 2
	i32.ne  	$push20=, $pop19, $pop116
	br_if   	0, $pop20       # 0: down to label5
# BB#3:                                 # %if.end10
	i32.const	$push121=, 0
	i32.load	$push21=, v1($pop121)
	i32.const	$push120=, 2
	i32.add 	$push22=, $pop21, $pop120
	i32.const	$push119=, 0
	i32.call	$push23=, bar@FUNCTION, $pop22, $pop119
	i32.const	$push24=, 19
	i32.ne  	$push25=, $pop23, $pop24
	br_if   	0, $pop25       # 0: down to label5
# BB#4:                                 # %if.end14
	i32.const	$push140=, 0
	i64.load	$push139=, v5($pop140)
	tee_local	$push138=, $2=, $pop139
	i32.const	$push137=, 0
	i64.load	$push136=, v5+8($pop137)
	tee_local	$push135=, $3=, $pop136
	i64.const	$push27=, 0
	i64.const	$push26=, -4611967493404098560
	call    	__addtf3@FUNCTION, $5, $pop138, $pop135, $pop27, $pop26
	i32.const	$push75=, 80
	i32.add 	$push76=, $5, $pop75
	i32.const	$push29=, 8
	i32.add 	$push30=, $pop76, $pop29
	i32.const	$push134=, 0
	i64.load	$push28=, v4+8($pop134):p2align=0
	i64.store	0($pop30):p2align=2, $pop28
	i32.const	$push133=, 0
	i32.const	$push132=, 8
	i32.add 	$push31=, $5, $pop132
	i64.load	$push32=, 0($pop31)
	i64.store	v5+8($pop133), $pop32
	i32.const	$push131=, 0
	i64.load	$push33=, 0($5)
	i64.store	v5($pop131), $pop33
	i32.const	$push130=, 0
	i64.load	$push34=, v4($pop130):p2align=0
	i64.store	80($5):p2align=2, $pop34
	i32.const	$push36=, 68
	i32.add 	$push37=, $5, $pop36
	i32.const	$push129=, 0
	i32.load	$push35=, v4+4($pop129):p2align=0
	i32.store	0($pop37), $pop35
	i32.const	$push39=, 76
	i32.add 	$push40=, $5, $pop39
	i32.const	$push128=, 0
	i32.load	$push38=, v4+12($pop128):p2align=0
	i32.store	0($pop40), $pop38
	i32.const	$push77=, 64
	i32.add 	$push78=, $5, $pop77
	i32.const	$push127=, 8
	i32.add 	$push42=, $pop78, $pop127
	i32.const	$push126=, 0
	i32.load	$push41=, v4+8($pop126):p2align=0
	i32.store	0($pop42), $pop41
	i32.const	$push125=, 0
	i32.load	$0=, v1($pop125)
	i32.const	$push124=, 0
	i32.load	$1=, v4($pop124):p2align=0
	i32.const	$push123=, 0
	i32.load	$4=, v3($pop123)
	i32.const	$push43=, 48
	i32.add 	$push44=, $5, $pop43
	i64.const	$push45=, 16
	i64.store	0($pop44), $pop45
	i32.const	$push46=, 40
	i32.add 	$push47=, $5, $pop46
	i32.store	0($pop47), $4
	i32.store	64($5), $1
	i32.const	$push79=, 16
	i32.add 	$push80=, $5, $pop79
	i32.const	$push48=, 20
	i32.add 	$push49=, $pop80, $pop48
	i32.const	$push81=, 64
	i32.add 	$push82=, $5, $pop81
	i32.store	0($pop49), $pop82
	i32.const	$push50=, 32
	i32.add 	$push51=, $5, $pop50
	i32.const	$push83=, 80
	i32.add 	$push84=, $5, $pop83
	i32.store	0($pop51), $pop84
	i64.store	16($5), $2
	i64.store	24($5), $3
	i32.const	$push52=, 3
	i32.add 	$push53=, $0, $pop52
	i32.const	$push85=, 16
	i32.add 	$push86=, $5, $pop85
	i32.call	$push54=, bar@FUNCTION, $pop53, $pop86
	i32.const	$push122=, 20
	i32.ne  	$push55=, $pop54, $pop122
	br_if   	0, $pop55       # 0: down to label5
# BB#5:                                 # %if.end19
	i32.const	$push62=, 0
	i32.const	$push60=, 176
	i32.add 	$push61=, $5, $pop60
	i32.store	__stack_pointer($pop62), $pop61
	i32.const	$push141=, 0
	return  	$pop141
.LBB3_6:                                # %if.then
	end_block                       # label5:
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


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
	.functype	memcmp, i32, i32, i32, i32
	.functype	bar, i32, i32
