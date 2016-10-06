	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-pack-1.c"
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
	i32.const	$push75=, 0
	i32.load	$push76=, __stack_pointer($pop75)
	i32.const	$push77=, 32
	i32.sub 	$push89=, $pop76, $pop77
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
	block   	
	i32.load	$push69=, 0($1)
	i32.const	$push70=, 3
	i32.ne  	$push71=, $pop69, $pop70
	br_if   	0, $pop71       # 0: down to label3
# BB#12:                                # %if.end34
	i32.const	$push72=, 0
	i32.load	$push66=, v2($pop72)
	i32.const	$push73=, 4
	i32.eq  	$push74=, $pop66, $pop73
	br_if   	2, $pop74       # 2: down to label1
.LBB0_13:                               # %if.then42
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %sw.bb44
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
# BB#15:                                # %sw.bb44
	i32.const	$push27=, 0
	i64.load	$push17=, v5($pop27)
	i32.const	$push117=, 0
	i64.load	$push18=, v5+8($pop117)
	i32.call	$push28=, __eqtf2@FUNCTION, $pop17, $pop18, $4, $5
	br_if   	1, $pop28       # 1: down to label0
# BB#16:                                # %if.end53
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
# BB#17:                                # %if.end59
	i32.const	$push35=, 24
	i32.add 	$push36=, $2, $pop35
	i32.store	12($6), $pop36
	i32.load	$push37=, 0($1)
	i32.const	$push38=, v2
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	1, $pop39       # 1: down to label0
.LBB0_18:                               # %sw.epilog
	end_block                       # label1:
	i32.const	$push81=, 0
	i32.const	$push79=, 32
	i32.add 	$push80=, $6, $pop79
	i32.store	__stack_pointer($pop81), $pop80
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push70=, 0
	i32.const	$push67=, 0
	i32.load	$push68=, __stack_pointer($pop67)
	i32.const	$push69=, 48
	i32.sub 	$push87=, $pop68, $pop69
	tee_local	$push86=, $4=, $pop87
	i32.store	__stack_pointer($pop70), $pop86
	i32.store	12($4), $2
	block   	
	i32.const	$push0=, 19
	i32.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label4
# BB#1:                                 # %lor.lhs.false3
	i32.const	$push2=, seen
	i32.add 	$push89=, $0, $pop2
	tee_local	$push88=, $2=, $pop89
	i32.load8_u	$push3=, 0($pop88)
	br_if   	0, $pop3        # 0: down to label4
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
	br_if   	0, $pop10       # 0: down to label4
# BB#3:                                 # %if.end9
	block   	
	i32.const	$push11=, 2
	i32.eq  	$push12=, $0, $pop11
	br_if   	0, $pop12       # 0: down to label5
# BB#4:                                 # %if.end9
	i32.const	$push13=, 11
	i32.eq  	$push14=, $0, $pop13
	br_if   	0, $pop14       # 0: down to label5
# BB#5:                                 # %if.end9
	i32.const	$push15=, 12
	i32.ne  	$push16=, $0, $pop15
	br_if   	1, $pop16       # 1: down to label4
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
	br_if   	1, $pop27       # 1: down to label4
# BB#7:                                 # %sw.bb
	i32.const	$push28=, 0
	i64.load	$push17=, v5($pop28)
	i32.const	$push99=, 0
	i64.load	$push18=, v5+8($pop99)
	i64.const	$push98=, 0
	i64.const	$push29=, 4612882287078408192
	i32.call	$push30=, __eqtf2@FUNCTION, $pop17, $pop18, $pop98, $pop29
	br_if   	1, $pop30       # 1: down to label4
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
	br_if   	1, $pop41       # 1: down to label4
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
	br_if   	1, $pop52       # 1: down to label4
# BB#10:                                # %if.end31
	i32.const	$push53=, 52
	i32.add 	$push119=, $2, $pop53
	tee_local	$push118=, $2=, $pop119
	i32.store	12($4), $pop118
	i32.load	$push54=, 0($1)
	i32.const	$push55=, v2
	i32.ne  	$push56=, $pop54, $pop55
	br_if   	1, $pop56       # 1: down to label4
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
	br_if   	1, $pop64       # 1: down to label4
.LBB1_12:                               # %sw.epilog
	end_block                       # label5:
	i32.const	$push73=, 0
	i32.const	$push71=, 48
	i32.add 	$push72=, $4, $pop71
	i32.store	__stack_pointer($pop73), $pop72
	i32.const	$push65=, 8
	i32.add 	$push66=, $0, $pop65
	return  	$pop66
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
	.local  	i32, i32, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push66=, 0
	i32.const	$push63=, 0
	i32.load	$push64=, __stack_pointer($pop63)
	i32.const	$push65=, 176
	i32.sub 	$push111=, $pop64, $pop65
	tee_local	$push110=, $4=, $pop111
	i32.store	__stack_pointer($pop66), $pop110
	i32.const	$push109=, 0
	i32.const	$push108=, 0
	i32.load	$push0=, v1($pop108)
	i32.const	$push107=, 1
	i32.add 	$push106=, $pop0, $pop107
	tee_local	$push105=, $0=, $pop106
	i32.store	v1($pop109), $pop105
	i32.const	$push104=, 0
	i32.const	$push103=, 0
	i32.load	$push102=, v2($pop103)
	tee_local	$push101=, $1=, $pop102
	i32.const	$push100=, 1
	i32.add 	$push1=, $pop101, $pop100
	i32.store	v2($pop104), $pop1
	i32.const	$push3=, 172
	i32.add 	$push4=, $4, $pop3
	i32.const	$push99=, 0
	i32.load	$push2=, v4+12($pop99):p2align=0
	i32.store	0($pop4), $pop2
	i32.const	$push70=, 160
	i32.add 	$push71=, $4, $pop70
	i32.const	$push98=, 8
	i32.add 	$push6=, $pop71, $pop98
	i32.const	$push97=, 0
	i32.load	$push5=, v4+8($pop97):p2align=0
	i32.store	0($pop6), $pop5
	i32.const	$push8=, 164
	i32.add 	$push9=, $4, $pop8
	i32.const	$push96=, 0
	i32.load	$push7=, v4+4($pop96):p2align=0
	i32.store	0($pop9), $pop7
	i32.const	$push95=, 0
	i32.load	$push10=, v4($pop95):p2align=0
	i32.store	160($4), $pop10
	i32.store	144($4), $0
	i32.store	156($4), $1
	i32.const	$push11=, v4
	i32.store	152($4), $pop11
	i32.const	$push72=, 160
	i32.add 	$push73=, $4, $pop72
	i32.store	148($4), $pop73
	block   	
	i32.const	$push94=, 0
	i32.const	$push74=, 144
	i32.add 	$push75=, $4, $pop74
	i32.call	$push12=, bar@FUNCTION, $pop94, $pop75
	br_if   	0, $pop12       # 0: down to label6
# BB#1:                                 # %if.end
	i32.const	$push76=, 96
	i32.add 	$push77=, $4, $pop76
	i32.const	$push124=, 0
	i64.load	$push14=, v5($pop124)
	i32.const	$push123=, 0
	i64.load	$push13=, v5+8($pop123)
	i64.const	$push16=, 0
	i64.const	$push15=, 4611404543450677248
	call    	__addtf3@FUNCTION, $pop77, $pop14, $pop13, $pop16, $pop15
	i32.const	$push18=, 132
	i32.add 	$push19=, $4, $pop18
	i32.const	$push122=, 0
	i32.load	$push17=, v3($pop122)
	i32.store	0($pop19), $pop17
	i32.const	$push20=, 128
	i32.add 	$push21=, $4, $pop20
	i32.const	$push121=, 8
	i32.store	0($pop21), $pop121
	i32.const	$push120=, 0
	i32.const	$push78=, 96
	i32.add 	$push79=, $4, $pop78
	i32.const	$push119=, 8
	i32.add 	$push22=, $pop79, $pop119
	i64.load	$push118=, 0($pop22)
	tee_local	$push117=, $2=, $pop118
	i64.store	v5+8($pop120), $pop117
	i32.const	$push116=, 0
	i64.load	$push115=, 96($4)
	tee_local	$push114=, $3=, $pop115
	i64.store	v5($pop116), $pop114
	i64.store	120($4), $2
	i64.store	112($4), $3
	i32.const	$push113=, 1
	i32.const	$push80=, 112
	i32.add 	$push81=, $4, $pop80
	i32.call	$push23=, bar@FUNCTION, $pop113, $pop81
	i32.const	$push112=, 1
	i32.ne  	$push24=, $pop23, $pop112
	br_if   	0, $pop24       # 0: down to label6
# BB#2:                                 # %if.end6
	i32.const	$push127=, 2
	i32.const	$push126=, 0
	i32.call	$push25=, bar@FUNCTION, $pop127, $pop126
	i32.const	$push125=, 2
	i32.ne  	$push26=, $pop25, $pop125
	br_if   	0, $pop26       # 0: down to label6
# BB#3:                                 # %if.end10
	i32.const	$push130=, 0
	i32.load	$push27=, v1($pop130)
	i32.const	$push129=, 2
	i32.add 	$push28=, $pop27, $pop129
	i32.const	$push128=, 0
	i32.call	$push29=, bar@FUNCTION, $pop28, $pop128
	i32.const	$push30=, 19
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label6
# BB#4:                                 # %if.end14
	i32.const	$push149=, 0
	i64.load	$push148=, v5($pop149)
	tee_local	$push147=, $2=, $pop148
	i32.const	$push146=, 0
	i64.load	$push145=, v5+8($pop146)
	tee_local	$push144=, $3=, $pop145
	i64.const	$push33=, 0
	i64.const	$push32=, -4611967493404098560
	call    	__addtf3@FUNCTION, $4, $pop147, $pop144, $pop33, $pop32
	i32.const	$push35=, 92
	i32.add 	$push36=, $4, $pop35
	i32.const	$push143=, 0
	i32.load	$push34=, v4+12($pop143):p2align=0
	i32.store	0($pop36), $pop34
	i32.const	$push82=, 80
	i32.add 	$push83=, $4, $pop82
	i32.const	$push38=, 8
	i32.add 	$push39=, $pop83, $pop38
	i32.const	$push142=, 0
	i32.load	$push37=, v4+8($pop142):p2align=0
	i32.store	0($pop39), $pop37
	i32.const	$push41=, 84
	i32.add 	$push42=, $4, $pop41
	i32.const	$push141=, 0
	i32.load	$push40=, v4+4($pop141):p2align=0
	i32.store	0($pop42), $pop40
	i32.const	$push140=, 0
	i32.const	$push139=, 8
	i32.add 	$push43=, $4, $pop139
	i64.load	$push44=, 0($pop43)
	i64.store	v5+8($pop140), $pop44
	i32.const	$push138=, 0
	i64.load	$push45=, 0($4)
	i64.store	v5($pop138), $pop45
	i32.const	$push137=, 0
	i32.load	$push46=, v4($pop137):p2align=0
	i32.store	80($4), $pop46
	i32.const	$push136=, 0
	i32.load	$0=, v1($pop136)
	i32.const	$push135=, 0
	i32.load	$1=, v3($pop135)
	i32.const	$push84=, 64
	i32.add 	$push85=, $4, $pop84
	i32.const	$push134=, 8
	i32.add 	$push47=, $pop85, $pop134
	i32.const	$push133=, 0
	i64.load	$push48=, v4+8($pop133):p2align=0
	i64.store	0($pop47):p2align=2, $pop48
	i32.const	$push132=, 0
	i64.load	$push49=, v4($pop132):p2align=0
	i64.store	64($4):p2align=2, $pop49
	i32.const	$push50=, 48
	i32.add 	$push51=, $4, $pop50
	i64.const	$push52=, 16
	i64.store	0($pop51), $pop52
	i32.const	$push53=, 40
	i32.add 	$push54=, $4, $pop53
	i32.store	0($pop54), $1
	i64.store	16($4), $2
	i32.const	$push86=, 16
	i32.add 	$push87=, $4, $pop86
	i32.const	$push55=, 20
	i32.add 	$push56=, $pop87, $pop55
	i32.const	$push88=, 64
	i32.add 	$push89=, $4, $pop88
	i32.store	0($pop56), $pop89
	i32.const	$push57=, 32
	i32.add 	$push58=, $4, $pop57
	i32.const	$push90=, 80
	i32.add 	$push91=, $4, $pop90
	i32.store	0($pop58), $pop91
	i64.store	24($4), $3
	i32.const	$push59=, 3
	i32.add 	$push60=, $0, $pop59
	i32.const	$push92=, 16
	i32.add 	$push93=, $4, $pop92
	i32.call	$push61=, bar@FUNCTION, $pop60, $pop93
	i32.const	$push131=, 20
	i32.ne  	$push62=, $pop61, $pop131
	br_if   	0, $pop62       # 0: down to label6
# BB#5:                                 # %if.end19
	i32.const	$push69=, 0
	i32.const	$push67=, 176
	i32.add 	$push68=, $4, $pop67
	i32.store	__stack_pointer($pop69), $pop68
	i32.const	$push150=, 0
	return  	$pop150
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	memcmp, i32, i32, i32, i32
	.functype	bar, i32, i32
