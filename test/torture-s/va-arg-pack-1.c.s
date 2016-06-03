	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-pack-1.c"
	.section	.text.foo1,"ax",@progbits
	.hidden	foo1
	.globl	foo1
	.type	foo1,@function
foo1:                                   # @foo1
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$push86=, 0
	i32.const	$push83=, 0
	i32.load	$push84=, __stack_pointer($pop83)
	i32.const	$push85=, 32
	i32.sub 	$push96=, $pop84, $pop85
	i32.store	$push98=, __stack_pointer($pop86), $pop96
	tee_local	$push97=, $4=, $pop98
	i32.store	$drop=, 12($pop97), $2
	block
	i32.const	$push3=, 19
	i32.gt_u	$push4=, $0, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %lor.lhs.false3
	i32.load8_u	$push5=, seen($0)
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push6=, 0
	i32.const	$push99=, 0
	i32.load	$push7=, cnt($pop99)
	i32.const	$push8=, 1
	i32.add 	$push9=, $pop7, $pop8
	i32.store8	$push0=, seen($0), $pop9
	i32.store	$drop=, cnt($pop6), $pop0
	i32.const	$push10=, 6
	i32.ne  	$push11=, $1, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#3:                                 # %if.end9
	i32.load	$push101=, 12($4)
	tee_local	$push100=, $2=, $pop101
	i32.const	$push12=, 4
	i32.add 	$push1=, $pop100, $pop12
	i32.store	$1=, 12($4), $pop1
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
	i32.const	$push47=, 8
	i32.add 	$push2=, $2, $pop47
	i32.store	$1=, 12($4), $pop2
	i32.const	$push48=, 4
	i32.add 	$push49=, $2, $pop48
	i32.load	$push50=, 0($pop49)
	i32.const	$push102=, 9
	i32.ne  	$push51=, $pop50, $pop102
	br_if   	2, $pop51       # 2: down to label0
# BB#8:                                 # %sw.bb
	i32.const	$push52=, 0
	i32.load	$push46=, v1($pop52)
	i32.const	$push103=, 9
	i32.ne  	$push53=, $pop46, $pop103
	br_if   	2, $pop53       # 2: down to label0
# BB#9:                                 # %if.end22
	i32.const	$push90=, 16
	i32.add 	$push91=, $4, $pop90
	i32.const	$push54=, 12
	i32.add 	$push57=, $pop91, $pop54
	i32.const	$push106=, 12
	i32.add 	$push55=, $1, $pop106
	i32.load	$push56=, 0($pop55):p2align=0
	i32.store	$drop=, 0($pop57), $pop56
	i32.const	$push92=, 16
	i32.add 	$push93=, $4, $pop92
	i32.const	$push58=, 8
	i32.add 	$push61=, $pop93, $pop58
	i32.const	$push105=, 8
	i32.add 	$push59=, $1, $pop105
	i32.load	$push60=, 0($pop59):p2align=0
	i32.store	$drop=, 0($pop61), $pop60
	i32.const	$push62=, 24
	i32.add 	$push63=, $2, $pop62
	i32.store	$3=, 12($4), $pop63
	i32.const	$push64=, 4
	i32.add 	$push65=, $1, $pop64
	i32.load	$push66=, 0($pop65):p2align=0
	i32.store	$drop=, 20($4), $pop66
	i32.load	$push67=, 0($1):p2align=0
	i32.store	$drop=, 16($4), $pop67
	i32.const	$push94=, 16
	i32.add 	$push95=, $4, $pop94
	i32.const	$push104=, v4
	i32.const	$push68=, 16
	i32.call	$push69=, memcmp@FUNCTION, $pop95, $pop104, $pop68
	br_if   	2, $pop69       # 2: down to label0
# BB#10:                                # %if.end28
	i32.const	$push70=, 28
	i32.add 	$push71=, $2, $pop70
	i32.store	$1=, 12($4), $pop71
	i32.load	$push72=, 0($3)
	i32.const	$push107=, v4
	i32.ne  	$push73=, $pop72, $pop107
	br_if   	2, $pop73       # 2: down to label0
# BB#11:                                # %if.end34
	i32.const	$push75=, 32
	i32.add 	$push76=, $2, $pop75
	i32.store	$drop=, 12($4), $pop76
	block
	i32.load	$push77=, 0($1)
	i32.const	$push78=, 3
	i32.ne  	$push79=, $pop77, $pop78
	br_if   	0, $pop79       # 0: down to label3
# BB#12:                                # %if.end34
	i32.const	$push80=, 0
	i32.load	$push74=, v2($pop80)
	i32.const	$push81=, 4
	i32.eq  	$push82=, $pop74, $pop81
	br_if   	2, $pop82       # 2: down to label1
.LBB0_13:                               # %if.then42
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %sw.bb44
	end_block                       # label2:
	i32.const	$push22=, 15
	i32.add 	$push23=, $1, $pop22
	i32.const	$push24=, -16
	i32.and 	$push113=, $pop23, $pop24
	tee_local	$push112=, $2=, $pop113
	i32.const	$push25=, 16
	i32.add 	$push26=, $pop112, $pop25
	i32.store	$drop=, 12($4), $pop26
	i64.load	$push111=, 0($2)
	tee_local	$push110=, $5=, $pop111
	i64.load	$push109=, 8($2)
	tee_local	$push108=, $6=, $pop109
	i64.const	$push28=, 0
	i64.const	$push27=, 4612891083171430400
	i32.call	$push29=, __netf2@FUNCTION, $pop110, $pop108, $pop28, $pop27
	br_if   	1, $pop29       # 1: down to label0
# BB#15:                                # %sw.bb44
	i32.const	$push30=, 0
	i64.load	$push20=, v5($pop30)
	i32.const	$push114=, 0
	i64.load	$push21=, v5+8($pop114)
	i32.call	$push31=, __eqtf2@FUNCTION, $pop20, $pop21, $5, $6
	br_if   	1, $pop31       # 1: down to label0
# BB#16:                                # %if.end53
	i32.const	$push32=, 20
	i32.add 	$push33=, $2, $pop32
	i32.store	$drop=, 12($4), $pop33
	i32.const	$push34=, 16
	i32.add 	$push35=, $2, $pop34
	i64.load	$push116=, 0($pop35)
	tee_local	$push115=, $5=, $pop116
	i32.wrap/i64	$push36=, $pop115
	i32.const	$push37=, 8
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	1, $pop38       # 1: down to label0
# BB#17:                                # %if.end59
	i32.const	$push39=, 24
	i32.add 	$push40=, $2, $pop39
	i32.store	$drop=, 12($4), $pop40
	i64.const	$push41=, 32
	i64.shr_u	$push42=, $5, $pop41
	i32.wrap/i64	$push43=, $pop42
	i32.const	$push44=, v2
	i32.ne  	$push45=, $pop43, $pop44
	br_if   	1, $pop45       # 1: down to label0
.LBB0_18:                               # %sw.epilog
	end_block                       # label1:
	i32.const	$push89=, 0
	i32.const	$push87=, 32
	i32.add 	$push88=, $4, $pop87
	i32.store	$drop=, __stack_pointer($pop89), $pop88
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
	i32.const	$push75=, 0
	i32.const	$push72=, 0
	i32.load	$push73=, __stack_pointer($pop72)
	i32.const	$push74=, 48
	i32.sub 	$push91=, $pop73, $pop74
	i32.store	$push93=, __stack_pointer($pop75), $pop91
	tee_local	$push92=, $4=, $pop93
	i32.store	$drop=, 12($pop92), $2
	block
	i32.const	$push4=, 19
	i32.gt_u	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: down to label4
# BB#1:                                 # %lor.lhs.false3
	i32.load8_u	$push6=, seen($0)
	br_if   	0, $pop6        # 0: down to label4
# BB#2:                                 # %if.end
	i32.const	$push7=, 0
	i32.const	$push94=, 0
	i32.load	$push8=, cnt($pop94)
	i32.const	$push9=, 1
	i32.add 	$push10=, $pop8, $pop9
	i32.store	$push0=, cnt($pop7), $pop10
	i32.const	$push11=, 64
	i32.or  	$push12=, $pop0, $pop11
	i32.store8	$drop=, seen($0), $pop12
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
	i32.load	$push24=, 12($4)
	i32.const	$push23=, 15
	i32.add 	$push25=, $pop24, $pop23
	i32.const	$push26=, -16
	i32.and 	$push97=, $pop25, $pop26
	tee_local	$push96=, $2=, $pop97
	i32.const	$push27=, 16
	i32.add 	$push1=, $pop96, $pop27
	i32.store	$1=, 12($4), $pop1
	i64.load	$push29=, 0($2)
	i64.load	$push28=, 8($2)
	i64.const	$push95=, 0
	i64.const	$push30=, 4612891083171430400
	i32.call	$push31=, __netf2@FUNCTION, $pop29, $pop28, $pop95, $pop30
	br_if   	1, $pop31       # 1: down to label4
# BB#7:                                 # %sw.bb
	i32.const	$push32=, 0
	i64.load	$push21=, v5($pop32)
	i32.const	$push99=, 0
	i64.load	$push22=, v5+8($pop99)
	i64.const	$push98=, 0
	i64.const	$push33=, 4612882287078408192
	i32.call	$push34=, __eqtf2@FUNCTION, $pop21, $pop22, $pop98, $pop33
	br_if   	1, $pop34       # 1: down to label4
# BB#8:                                 # %if.end16
	i32.const	$push79=, 32
	i32.add 	$push80=, $4, $pop79
	i32.const	$push106=, 12
	i32.add 	$push37=, $pop80, $pop106
	i32.const	$push105=, 12
	i32.add 	$push35=, $1, $pop105
	i32.load	$push36=, 0($pop35):p2align=0
	i32.store	$drop=, 0($pop37), $pop36
	i32.const	$push81=, 32
	i32.add 	$push82=, $4, $pop81
	i32.const	$push104=, 8
	i32.add 	$push40=, $pop82, $pop104
	i32.const	$push103=, 8
	i32.add 	$push38=, $1, $pop103
	i32.load	$push39=, 0($pop38):p2align=0
	i32.store	$drop=, 0($pop40), $pop39
	i32.const	$push41=, 32
	i32.add 	$push2=, $2, $pop41
	i32.store	$3=, 12($4), $pop2
	i32.const	$push102=, 4
	i32.add 	$push42=, $1, $pop102
	i32.load	$push43=, 0($pop42):p2align=0
	i32.store	$drop=, 36($4), $pop43
	i32.load	$push44=, 0($1):p2align=0
	i32.store	$drop=, 32($4), $pop44
	i32.const	$push83=, 32
	i32.add 	$push84=, $4, $pop83
	i32.const	$push101=, v4
	i32.const	$push100=, 16
	i32.call	$push45=, memcmp@FUNCTION, $pop84, $pop101, $pop100
	br_if   	1, $pop45       # 1: down to label4
# BB#9:                                 # %if.end22
	i32.const	$push85=, 16
	i32.add 	$push86=, $4, $pop85
	i32.const	$push113=, 12
	i32.add 	$push48=, $pop86, $pop113
	i32.const	$push112=, 12
	i32.add 	$push46=, $3, $pop112
	i32.load	$push47=, 0($pop46):p2align=0
	i32.store	$drop=, 0($pop48), $pop47
	i32.const	$push87=, 16
	i32.add 	$push88=, $4, $pop87
	i32.const	$push111=, 8
	i32.add 	$push51=, $pop88, $pop111
	i32.const	$push110=, 8
	i32.add 	$push49=, $3, $pop110
	i32.load	$push50=, 0($pop49):p2align=0
	i32.store	$drop=, 0($pop51), $pop50
	i32.const	$push52=, 48
	i32.add 	$push53=, $2, $pop52
	i32.store	$1=, 12($4), $pop53
	i32.const	$push109=, 4
	i32.add 	$push54=, $3, $pop109
	i32.load	$push55=, 0($pop54):p2align=0
	i32.store	$drop=, 20($4), $pop55
	i32.load	$push56=, 0($3):p2align=0
	i32.store	$drop=, 16($4), $pop56
	i32.const	$push89=, 16
	i32.add 	$push90=, $4, $pop89
	i32.const	$push108=, v4
	i32.const	$push107=, 16
	i32.call	$push57=, memcmp@FUNCTION, $pop90, $pop108, $pop107
	br_if   	1, $pop57       # 1: down to label4
# BB#10:                                # %if.end31
	i32.const	$push58=, 52
	i32.add 	$push3=, $2, $pop58
	i32.store	$2=, 12($4), $pop3
	i32.load	$push59=, 0($1)
	i32.const	$push60=, v2
	i32.ne  	$push61=, $pop59, $pop60
	br_if   	1, $pop61       # 1: down to label4
# BB#11:                                # %if.end37
	i32.const	$push62=, 7
	i32.add 	$push63=, $2, $pop62
	i32.const	$push64=, -8
	i32.and 	$push115=, $pop63, $pop64
	tee_local	$push114=, $2=, $pop115
	i32.const	$push65=, 8
	i32.add 	$push66=, $pop114, $pop65
	i32.store	$drop=, 12($4), $pop66
	i64.load	$push67=, 0($2)
	i64.const	$push68=, 16
	i64.ne  	$push69=, $pop67, $pop68
	br_if   	1, $pop69       # 1: down to label4
.LBB1_12:                               # %sw.epilog
	end_block                       # label5:
	i32.const	$push78=, 0
	i32.const	$push76=, 48
	i32.add 	$push77=, $4, $pop76
	i32.store	$drop=, __stack_pointer($pop78), $pop77
	i32.const	$push70=, 8
	i32.add 	$push71=, $0, $pop70
	return  	$pop71
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
	.local  	i32, i64, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push70=, 0
	i32.const	$push67=, 0
	i32.load	$push68=, __stack_pointer($pop67)
	i32.const	$push69=, 176
	i32.sub 	$push98=, $pop68, $pop69
	i32.store	$3=, __stack_pointer($pop70), $pop98
	i32.const	$push112=, 0
	i32.const	$push111=, 0
	i32.load	$push1=, v1($pop111)
	i32.const	$push110=, 1
	i32.add 	$push2=, $pop1, $pop110
	i32.store	$0=, v1($pop112), $pop2
	i32.const	$push109=, 0
	i32.const	$push108=, 0
	i32.load	$push107=, v2($pop108)
	tee_local	$push106=, $4=, $pop107
	i32.const	$push105=, 1
	i32.add 	$push3=, $pop106, $pop105
	i32.store	$drop=, v2($pop109), $pop3
	i32.const	$push5=, 172
	i32.add 	$push6=, $3, $pop5
	i32.const	$push104=, 0
	i32.load	$push4=, v4+12($pop104):p2align=0
	i32.store	$drop=, 0($pop6), $pop4
	i32.const	$push74=, 160
	i32.add 	$push75=, $3, $pop74
	i32.const	$push103=, 8
	i32.add 	$push8=, $pop75, $pop103
	i32.const	$push102=, 0
	i32.load	$push7=, v4+8($pop102):p2align=0
	i32.store	$drop=, 0($pop8), $pop7
	i32.const	$push10=, 164
	i32.add 	$push11=, $3, $pop10
	i32.const	$push101=, 0
	i32.load	$push9=, v4+4($pop101):p2align=0
	i32.store	$drop=, 0($pop11), $pop9
	i32.const	$push100=, 0
	i32.load	$push12=, v4($pop100):p2align=0
	i32.store	$drop=, 160($3), $pop12
	i32.store	$drop=, 144($3), $0
	i32.store	$drop=, 156($3), $4
	i32.const	$push13=, v4
	i32.store	$drop=, 152($3), $pop13
	i32.const	$push76=, 160
	i32.add 	$push77=, $3, $pop76
	i32.store	$drop=, 148($3), $pop77
	block
	i32.const	$push99=, 0
	i32.const	$push78=, 144
	i32.add 	$push79=, $3, $pop78
	i32.call	$push14=, bar@FUNCTION, $pop99, $pop79
	br_if   	0, $pop14       # 0: down to label6
# BB#1:                                 # %if.end
	i32.const	$push80=, 96
	i32.add 	$push81=, $3, $pop80
	i32.const	$push120=, 0
	i64.load	$push16=, v5($pop120)
	i32.const	$push119=, 0
	i64.load	$push15=, v5+8($pop119)
	i64.const	$push18=, 0
	i64.const	$push17=, 4611404543450677248
	call    	__addtf3@FUNCTION, $pop81, $pop16, $pop15, $pop18, $pop17
	i32.const	$push20=, 132
	i32.add 	$push21=, $3, $pop20
	i32.const	$push118=, 0
	i32.load	$push19=, v3($pop118)
	i32.store	$drop=, 0($pop21), $pop19
	i32.const	$push117=, 0
	i32.const	$push82=, 96
	i32.add 	$push83=, $3, $pop82
	i32.const	$push22=, 128
	i32.add 	$push23=, $3, $pop22
	i32.const	$push116=, 8
	i32.store	$push0=, 0($pop23), $pop116
	i32.add 	$push24=, $pop83, $pop0
	i64.load	$push25=, 0($pop24)
	i64.store	$1=, v5+8($pop117), $pop25
	i32.const	$push115=, 0
	i64.load	$push26=, 96($3)
	i64.store	$2=, v5($pop115), $pop26
	i64.store	$drop=, 120($3), $1
	i64.store	$drop=, 112($3), $2
	i32.const	$push114=, 1
	i32.const	$push84=, 112
	i32.add 	$push85=, $3, $pop84
	i32.call	$push27=, bar@FUNCTION, $pop114, $pop85
	i32.const	$push113=, 1
	i32.ne  	$push28=, $pop27, $pop113
	br_if   	0, $pop28       # 0: down to label6
# BB#2:                                 # %if.end6
	i32.const	$push123=, 2
	i32.const	$push122=, 0
	i32.call	$push29=, bar@FUNCTION, $pop123, $pop122
	i32.const	$push121=, 2
	i32.ne  	$push30=, $pop29, $pop121
	br_if   	0, $pop30       # 0: down to label6
# BB#3:                                 # %if.end10
	i32.const	$push126=, 0
	i32.load	$push31=, v1($pop126)
	i32.const	$push125=, 2
	i32.add 	$push32=, $pop31, $pop125
	i32.const	$push124=, 0
	i32.call	$push33=, bar@FUNCTION, $pop32, $pop124
	i32.const	$push34=, 19
	i32.ne  	$push35=, $pop33, $pop34
	br_if   	0, $pop35       # 0: down to label6
# BB#4:                                 # %if.end14
	i32.const	$push145=, 0
	i64.load	$push144=, v5($pop145)
	tee_local	$push143=, $1=, $pop144
	i32.const	$push142=, 0
	i64.load	$push141=, v5+8($pop142)
	tee_local	$push140=, $2=, $pop141
	i64.const	$push37=, 0
	i64.const	$push36=, -4611967493404098560
	call    	__addtf3@FUNCTION, $3, $pop143, $pop140, $pop37, $pop36
	i32.const	$push39=, 92
	i32.add 	$push40=, $3, $pop39
	i32.const	$push139=, 0
	i32.load	$push38=, v4+12($pop139):p2align=0
	i32.store	$drop=, 0($pop40), $pop38
	i32.const	$push86=, 80
	i32.add 	$push87=, $3, $pop86
	i32.const	$push42=, 8
	i32.add 	$push43=, $pop87, $pop42
	i32.const	$push138=, 0
	i32.load	$push41=, v4+8($pop138):p2align=0
	i32.store	$drop=, 0($pop43), $pop41
	i32.const	$push45=, 84
	i32.add 	$push46=, $3, $pop45
	i32.const	$push137=, 0
	i32.load	$push44=, v4+4($pop137):p2align=0
	i32.store	$drop=, 0($pop46), $pop44
	i32.const	$push136=, 0
	i32.const	$push135=, 8
	i32.add 	$push47=, $3, $pop135
	i64.load	$push48=, 0($pop47)
	i64.store	$drop=, v5+8($pop136), $pop48
	i32.const	$push134=, 0
	i64.load	$push49=, 0($3)
	i64.store	$drop=, v5($pop134), $pop49
	i32.const	$push133=, 0
	i32.load	$push50=, v4($pop133):p2align=0
	i32.store	$drop=, 80($3), $pop50
	i32.const	$push132=, 0
	i32.load	$0=, v1($pop132)
	i32.const	$push131=, 0
	i32.load	$4=, v3($pop131)
	i32.const	$push88=, 64
	i32.add 	$push89=, $3, $pop88
	i32.const	$push130=, 8
	i32.add 	$push51=, $pop89, $pop130
	i32.const	$push129=, 0
	i64.load	$push52=, v4+8($pop129):p2align=0
	i64.store	$drop=, 0($pop51):p2align=2, $pop52
	i32.const	$push128=, 0
	i64.load	$push53=, v4($pop128):p2align=0
	i64.store	$drop=, 64($3):p2align=2, $pop53
	i32.const	$push54=, 48
	i32.add 	$push55=, $3, $pop54
	i64.const	$push56=, 16
	i64.store	$drop=, 0($pop55), $pop56
	i32.const	$push57=, 40
	i32.add 	$push58=, $3, $pop57
	i32.store	$drop=, 0($pop58), $4
	i64.store	$drop=, 16($3), $1
	i32.const	$push90=, 16
	i32.add 	$push91=, $3, $pop90
	i32.const	$push59=, 20
	i32.add 	$push60=, $pop91, $pop59
	i32.const	$push92=, 64
	i32.add 	$push93=, $3, $pop92
	i32.store	$drop=, 0($pop60), $pop93
	i32.const	$push61=, 32
	i32.add 	$push62=, $3, $pop61
	i32.const	$push94=, 80
	i32.add 	$push95=, $3, $pop94
	i32.store	$drop=, 0($pop62), $pop95
	i64.store	$drop=, 24($3), $2
	i32.const	$push63=, 3
	i32.add 	$push64=, $0, $pop63
	i32.const	$push96=, 16
	i32.add 	$push97=, $3, $pop96
	i32.call	$push65=, bar@FUNCTION, $pop64, $pop97
	i32.const	$push127=, 20
	i32.ne  	$push66=, $pop65, $pop127
	br_if   	0, $pop66       # 0: down to label6
# BB#5:                                 # %if.end19
	i32.const	$push73=, 0
	i32.const	$push71=, 176
	i32.add 	$push72=, $3, $pop71
	i32.store	$drop=, __stack_pointer($pop73), $pop72
	i32.const	$push146=, 0
	return  	$pop146
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
	.functype	abort, void
	.functype	memcmp, i32, i32, i32, i32
	.functype	bar, i32, i32
