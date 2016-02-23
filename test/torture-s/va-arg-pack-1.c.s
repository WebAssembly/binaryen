	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-pack-1.c"
	.section	.text.foo1,"ax",@progbits
	.hidden	foo1
	.globl	foo1
	.type	foo1,@function
foo1:                                   # @foo1
	.param  	i32, i32, i32
	.result 	i32
	.local  	i64, i64, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push88=, __stack_pointer
	i32.load	$push89=, 0($pop88)
	i32.const	$push90=, 32
	i32.sub 	$9=, $pop89, $pop90
	i32.const	$push91=, __stack_pointer
	i32.store	$discard=, 0($pop91), $9
	i32.store	$discard=, 12($9), $2
	block
	i32.const	$push2=, 19
	i32.gt_u	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %lor.lhs.false3
	i32.load8_u	$push4=, seen($0)
	br_if   	0, $pop4        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push5=, 0
	i32.const	$push76=, 0
	i32.load	$push6=, cnt($pop76)
	i32.const	$push7=, 1
	i32.add 	$push8=, $pop6, $pop7
	i32.store	$push9=, cnt($pop5), $pop8
	i32.store8	$discard=, seen($0), $pop9
	i32.const	$push10=, 6
	i32.ne  	$push11=, $1, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#3:                                 # %if.end9
	i32.load	$push78=, 12($9)
	tee_local	$push77=, $2=, $pop78
	i32.const	$push12=, 4
	i32.add 	$push0=, $pop77, $pop12
	i32.store	$1=, 12($9), $pop0
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
	i32.store	$1=, 12($9), $pop1
	i32.const	$push46=, 4
	i32.add 	$push47=, $2, $pop46
	i32.load	$push48=, 0($pop47)
	i32.const	$push79=, 9
	i32.ne  	$push49=, $pop48, $pop79
	br_if   	2, $pop49       # 2: down to label0
# BB#8:                                 # %sw.bb
	i32.const	$push50=, 0
	i32.load	$push44=, v1($pop50)
	i32.const	$push80=, 9
	i32.ne  	$push51=, $pop44, $pop80
	br_if   	2, $pop51       # 2: down to label0
# BB#9:                                 # %if.end22
	i64.load	$4=, 0($1):p2align=0
	i32.const	$push58=, 8
	i32.add 	$push59=, $1, $pop58
	i32.load	$5=, 0($pop59):p2align=0
	i32.const	$push54=, 12
	i32.const	$6=, 16
	i32.add 	$6=, $9, $6
	i32.add 	$push57=, $6, $pop54
	i32.const	$push83=, 12
	i32.add 	$push55=, $1, $pop83
	i32.load	$push56=, 0($pop55):p2align=0
	i32.store	$discard=, 0($pop57), $pop56
	i32.const	$push82=, 8
	i32.const	$7=, 16
	i32.add 	$7=, $9, $7
	i32.add 	$push60=, $7, $pop82
	i32.store	$discard=, 0($pop60):p2align=3, $5
	i64.store	$discard=, 16($9), $4
	i32.const	$push52=, 24
	i32.add 	$push53=, $2, $pop52
	i32.store	$1=, 12($9), $pop53
	i32.const	$push81=, v4
	i32.const	$push61=, 16
	i32.const	$8=, 16
	i32.add 	$8=, $9, $8
	i32.call	$push62=, memcmp@FUNCTION, $8, $pop81, $pop61
	br_if   	2, $pop62       # 2: down to label0
# BB#10:                                # %if.end28
	i32.const	$push63=, 28
	i32.add 	$push64=, $2, $pop63
	i32.store	$5=, 12($9), $pop64
	i32.load	$push65=, 0($1)
	i32.const	$push84=, v4
	i32.ne  	$push66=, $pop65, $pop84
	br_if   	2, $pop66       # 2: down to label0
# BB#11:                                # %if.end34
	i32.const	$push68=, 32
	i32.add 	$push69=, $2, $pop68
	i32.store	$discard=, 12($9), $pop69
	block
	i32.load	$push70=, 0($5)
	i32.const	$push71=, 3
	i32.ne  	$push72=, $pop70, $pop71
	br_if   	0, $pop72       # 0: down to label3
# BB#12:                                # %if.end34
	i32.const	$push73=, 0
	i32.load	$push67=, v2($pop73)
	i32.const	$push74=, 4
	i32.eq  	$push75=, $pop67, $pop74
	br_if   	2, $pop75       # 2: down to label1
.LBB0_13:                               # %if.then42
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %sw.bb44
	end_block                       # label2:
	i32.const	$push22=, 15
	i32.add 	$push23=, $1, $pop22
	i32.const	$push24=, -16
	i32.and 	$push86=, $pop23, $pop24
	tee_local	$push85=, $2=, $pop86
	i64.load	$4=, 8($pop85)
	i64.load	$3=, 0($2):p2align=4
	i32.const	$push25=, 16
	i32.add 	$push26=, $2, $pop25
	i32.store	$discard=, 12($9), $pop26
	i64.const	$push28=, 0
	i64.const	$push27=, 4612891083171430400
	i32.call	$push29=, __netf2@FUNCTION, $3, $4, $pop28, $pop27
	br_if   	1, $pop29       # 1: down to label0
# BB#15:                                # %sw.bb44
	i32.const	$push30=, 0
	i64.load	$push20=, v5($pop30):p2align=4
	i32.const	$push87=, 0
	i64.load	$push21=, v5+8($pop87)
	i32.call	$push31=, __eqtf2@FUNCTION, $pop20, $pop21, $3, $4
	br_if   	1, $pop31       # 1: down to label0
# BB#16:                                # %if.end53
	i32.const	$push32=, 20
	i32.add 	$push33=, $2, $pop32
	i32.store	$1=, 12($9), $pop33
	i32.const	$push34=, 16
	i32.add 	$push35=, $2, $pop34
	i32.load	$push36=, 0($pop35):p2align=4
	i32.const	$push37=, 8
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	1, $pop38       # 1: down to label0
# BB#17:                                # %if.end59
	i32.const	$push39=, 24
	i32.add 	$push40=, $2, $pop39
	i32.store	$discard=, 12($9), $pop40
	i32.load	$push41=, 0($1)
	i32.const	$push42=, v2
	i32.ne  	$push43=, $pop41, $pop42
	br_if   	1, $pop43       # 1: down to label0
.LBB0_18:                               # %sw.epilog
	end_block                       # label1:
	i32.const	$push92=, 32
	i32.add 	$9=, $9, $pop92
	i32.const	$push93=, __stack_pointer
	i32.store	$discard=, 0($pop93), $9
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
	.local  	i64, i64, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push85=, __stack_pointer
	i32.load	$push86=, 0($pop85)
	i32.const	$push87=, 48
	i32.sub 	$11=, $pop86, $pop87
	i32.const	$push88=, __stack_pointer
	i32.store	$discard=, 0($pop88), $11
	i32.store	$discard=, 12($11), $2
	block
	i32.const	$push3=, 19
	i32.gt_u	$push4=, $0, $pop3
	br_if   	0, $pop4        # 0: down to label4
# BB#1:                                 # %lor.lhs.false3
	i32.load8_u	$push5=, seen($0)
	br_if   	0, $pop5        # 0: down to label4
# BB#2:                                 # %if.end
	i32.const	$push6=, 0
	i32.const	$push65=, 0
	i32.load	$push7=, cnt($pop65)
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
	i32.load	$push23=, 12($11)
	i32.const	$push24=, 15
	i32.add 	$push25=, $pop23, $pop24
	i32.const	$push26=, -16
	i32.and 	$push68=, $pop25, $pop26
	tee_local	$push67=, $2=, $pop68
	i64.load	$3=, 8($pop67)
	i64.load	$4=, 0($2):p2align=4
	i32.const	$push27=, 16
	i32.add 	$push0=, $2, $pop27
	i32.store	$1=, 12($11), $pop0
	i64.const	$push66=, 0
	i64.const	$push28=, 4612891083171430400
	i32.call	$push29=, __netf2@FUNCTION, $4, $3, $pop66, $pop28
	br_if   	1, $pop29       # 1: down to label4
# BB#7:                                 # %sw.bb
	i32.const	$push30=, 0
	i64.load	$push21=, v5($pop30):p2align=4
	i32.const	$push70=, 0
	i64.load	$push22=, v5+8($pop70)
	i64.const	$push69=, 0
	i64.const	$push31=, 4612882287078408192
	i32.call	$push32=, __eqtf2@FUNCTION, $pop21, $pop22, $pop69, $pop31
	br_if   	1, $pop32       # 1: down to label4
# BB#8:                                 # %if.end16
	i32.const	$push76=, 12
	i32.const	$5=, 32
	i32.add 	$5=, $11, $5
	i32.add 	$push36=, $5, $pop76
	i32.const	$push75=, 12
	i32.add 	$push34=, $1, $pop75
	i32.load	$push35=, 0($pop34):p2align=0
	i32.store	$discard=, 0($pop36), $pop35
	i32.const	$push74=, 8
	i32.const	$6=, 32
	i32.add 	$6=, $11, $6
	i32.add 	$push39=, $6, $pop74
	i32.const	$push73=, 8
	i32.add 	$push37=, $1, $pop73
	i32.load	$push38=, 0($pop37):p2align=0
	i32.store	$discard=, 0($pop39):p2align=3, $pop38
	i64.load	$push40=, 0($1):p2align=0
	i64.store	$discard=, 32($11), $pop40
	i32.const	$push33=, 32
	i32.add 	$push1=, $2, $pop33
	i32.store	$1=, 12($11), $pop1
	i32.const	$push72=, v4
	i32.const	$push71=, 16
	i32.const	$7=, 32
	i32.add 	$7=, $11, $7
	i32.call	$push41=, memcmp@FUNCTION, $7, $pop72, $pop71
	br_if   	1, $pop41       # 1: down to label4
# BB#9:                                 # %if.end22
	i32.const	$push82=, 12
	i32.const	$8=, 16
	i32.add 	$8=, $11, $8
	i32.add 	$push46=, $8, $pop82
	i32.const	$push81=, 12
	i32.add 	$push44=, $1, $pop81
	i32.load	$push45=, 0($pop44):p2align=0
	i32.store	$discard=, 0($pop46), $pop45
	i32.const	$push80=, 8
	i32.const	$9=, 16
	i32.add 	$9=, $11, $9
	i32.add 	$push49=, $9, $pop80
	i32.const	$push79=, 8
	i32.add 	$push47=, $1, $pop79
	i32.load	$push48=, 0($pop47):p2align=0
	i32.store	$discard=, 0($pop49):p2align=3, $pop48
	i64.load	$push50=, 0($1):p2align=0
	i64.store	$discard=, 16($11), $pop50
	i32.const	$push42=, 48
	i32.add 	$push43=, $2, $pop42
	i32.store	$1=, 12($11), $pop43
	i32.const	$push78=, v4
	i32.const	$push77=, 16
	i32.const	$10=, 16
	i32.add 	$10=, $11, $10
	i32.call	$push51=, memcmp@FUNCTION, $10, $pop78, $pop77
	br_if   	1, $pop51       # 1: down to label4
# BB#10:                                # %if.end31
	i32.const	$push52=, 52
	i32.add 	$push2=, $2, $pop52
	i32.store	$2=, 12($11), $pop2
	i32.load	$push53=, 0($1):p2align=4
	i32.const	$push54=, v2
	i32.ne  	$push55=, $pop53, $pop54
	br_if   	1, $pop55       # 1: down to label4
# BB#11:                                # %if.end37
	i32.const	$push56=, 7
	i32.add 	$push57=, $2, $pop56
	i32.const	$push58=, -8
	i32.and 	$push84=, $pop57, $pop58
	tee_local	$push83=, $2=, $pop84
	i64.load	$3=, 0($pop83)
	i32.const	$push59=, 8
	i32.add 	$push60=, $2, $pop59
	i32.store	$discard=, 12($11), $pop60
	i64.const	$push61=, 16
	i64.ne  	$push62=, $3, $pop61
	br_if   	1, $pop62       # 1: down to label4
.LBB1_12:                               # %sw.epilog
	end_block                       # label5:
	i32.const	$push63=, 8
	i32.add 	$push64=, $0, $pop63
	i32.const	$push89=, 48
	i32.add 	$11=, $11, $pop89
	i32.const	$push90=, __stack_pointer
	i32.store	$discard=, 0($pop90), $11
	return  	$pop64
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
	.local  	i32, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push103=, __stack_pointer
	i32.load	$push104=, 0($pop103)
	i32.const	$push105=, 176
	i32.sub 	$24=, $pop104, $pop105
	i32.const	$push106=, __stack_pointer
	i32.store	$discard=, 0($pop106), $24
	i32.const	$push68=, 0
	i32.load	$0=, v1($pop68)
	i32.const	$push67=, 0
	i32.const	$push66=, 0
	i32.load	$push65=, v2($pop66)
	tee_local	$push64=, $4=, $pop65
	i32.const	$push63=, 1
	i32.add 	$push1=, $pop64, $pop63
	i32.store	$discard=, v2($pop67), $pop1
	i32.const	$push62=, 0
	i32.const	$push61=, 1
	i32.add 	$push0=, $0, $pop61
	i32.store	$0=, v1($pop62), $pop0
	i32.const	$push2=, 12
	i32.const	$5=, 160
	i32.add 	$5=, $24, $5
	i32.add 	$push3=, $5, $pop2
	i32.const	$push60=, 0
	i32.load	$push4=, v4+12($pop60):p2align=0
	i32.store	$discard=, 0($pop3), $pop4
	i32.const	$push59=, 8
	i32.const	$6=, 160
	i32.add 	$6=, $24, $6
	i32.add 	$push5=, $6, $pop59
	i32.const	$push58=, 0
	i32.load	$push6=, v4+8($pop58):p2align=0
	i32.store	$discard=, 0($pop5), $pop6
	i32.const	$push57=, 0
	i64.load	$push7=, v4($pop57):p2align=0
	i64.store	$discard=, 160($24):p2align=2, $pop7
	i32.store	$discard=, 156($24), $4
	i32.const	$push8=, v4
	i32.store	$discard=, 152($24):p2align=3, $pop8
	i32.store	$discard=, 144($24):p2align=4, $0
	i32.const	$7=, 160
	i32.add 	$7=, $24, $7
	i32.store	$discard=, 148($24), $7
	i32.const	$push56=, 0
	i32.const	$8=, 144
	i32.add 	$8=, $24, $8
	block
	i32.call	$push9=, bar@FUNCTION, $pop56, $8
	br_if   	0, $pop9        # 0: down to label6
# BB#1:                                 # %if.end
	i32.const	$push77=, 0
	i64.load	$push11=, v5($pop77):p2align=4
	i32.const	$push76=, 0
	i64.load	$push10=, v5+8($pop76)
	i64.const	$push13=, 0
	i64.const	$push12=, 4611404543450677248
	i32.const	$9=, 96
	i32.add 	$9=, $24, $9
	call    	__addtf3@FUNCTION, $9, $pop11, $pop10, $pop13, $pop12
	i64.load	$1=, 96($24)
	i32.const	$push75=, 0
	i32.const	$push74=, 8
	i32.const	$10=, 96
	i32.add 	$10=, $24, $10
	i32.add 	$push14=, $10, $pop74
	i64.load	$push15=, 0($pop14)
	i64.store	$2=, v5+8($pop75), $pop15
	i32.const	$push73=, 0
	i32.load	$0=, v3($pop73)
	i32.const	$push72=, 0
	i64.store	$discard=, v5($pop72):p2align=4, $1
	i32.const	$push16=, 20
	i32.const	$11=, 112
	i32.add 	$11=, $24, $11
	i32.add 	$push17=, $11, $pop16
	i32.store	$discard=, 0($pop17), $0
	i32.const	$push18=, 16
	i32.const	$12=, 112
	i32.add 	$12=, $24, $12
	i32.add 	$push19=, $12, $pop18
	i32.const	$push71=, 8
	i32.store	$discard=, 0($pop19):p2align=4, $pop71
	i64.store	$discard=, 120($24), $2
	i64.store	$discard=, 112($24):p2align=4, $1
	i32.const	$push70=, 1
	i32.const	$13=, 112
	i32.add 	$13=, $24, $13
	i32.call	$push20=, bar@FUNCTION, $pop70, $13
	i32.const	$push69=, 1
	i32.ne  	$push21=, $pop20, $pop69
	br_if   	0, $pop21       # 0: down to label6
# BB#2:                                 # %if.end6
	i32.const	$push80=, 2
	i32.const	$push79=, 0
	i32.call	$push22=, bar@FUNCTION, $pop80, $pop79
	i32.const	$push78=, 2
	i32.ne  	$push23=, $pop22, $pop78
	br_if   	0, $pop23       # 0: down to label6
# BB#3:                                 # %if.end10
	i32.const	$push83=, 0
	i32.load	$push24=, v1($pop83)
	i32.const	$push82=, 2
	i32.add 	$push25=, $pop24, $pop82
	i32.const	$push81=, 0
	i32.call	$push26=, bar@FUNCTION, $pop25, $pop81
	i32.const	$push27=, 19
	i32.ne  	$push28=, $pop26, $pop27
	br_if   	0, $pop28       # 0: down to label6
# BB#4:                                 # %if.end14
	i32.const	$push101=, 0
	i32.load	$0=, v1($pop101)
	i32.const	$push100=, 0
	i64.load	$push99=, v5($pop100):p2align=4
	tee_local	$push98=, $1=, $pop99
	i32.const	$push97=, 0
	i64.load	$push96=, v5+8($pop97)
	tee_local	$push95=, $2=, $pop96
	i64.const	$push32=, 0
	i64.const	$push31=, -4611967493404098560
	call    	__addtf3@FUNCTION, $24, $pop98, $pop95, $pop32, $pop31
	i64.load	$3=, 0($24)
	i32.const	$push94=, 0
	i32.const	$push33=, 8
	i32.add 	$push34=, $24, $pop33
	i64.load	$push35=, 0($pop34)
	i64.store	$discard=, v5+8($pop94), $pop35
	i32.const	$push93=, 0
	i64.store	$discard=, v5($pop93):p2align=4, $3
	i32.const	$push92=, 0
	i32.load	$4=, v3($pop92)
	i32.const	$push36=, 12
	i32.const	$14=, 80
	i32.add 	$14=, $24, $14
	i32.add 	$push37=, $14, $pop36
	i32.const	$push91=, 0
	i32.load	$push38=, v4+12($pop91):p2align=0
	i32.store	$discard=, 0($pop37), $pop38
	i32.const	$push90=, 8
	i32.const	$15=, 80
	i32.add 	$15=, $24, $15
	i32.add 	$push39=, $15, $pop90
	i32.const	$push89=, 0
	i32.load	$push40=, v4+8($pop89):p2align=0
	i32.store	$discard=, 0($pop39), $pop40
	i32.const	$push88=, 0
	i64.load	$push41=, v4($pop88):p2align=0
	i64.store	$discard=, 80($24):p2align=2, $pop41
	i32.const	$push87=, 8
	i32.const	$16=, 64
	i32.add 	$16=, $24, $16
	i32.add 	$push42=, $16, $pop87
	i32.const	$push86=, 0
	i64.load	$push43=, v4+8($pop86):p2align=0
	i64.store	$discard=, 0($pop42):p2align=2, $pop43
	i32.const	$push85=, 0
	i64.load	$push44=, v4($pop85):p2align=0
	i64.store	$discard=, 64($24):p2align=2, $pop44
	i32.const	$push45=, 32
	i32.const	$17=, 16
	i32.add 	$17=, $24, $17
	i32.add 	$push46=, $17, $pop45
	i64.const	$push47=, 16
	i64.store	$discard=, 0($pop46):p2align=4, $pop47
	i32.const	$push48=, 24
	i32.const	$18=, 16
	i32.add 	$18=, $24, $18
	i32.add 	$push49=, $18, $pop48
	i32.store	$discard=, 0($pop49):p2align=3, $4
	i32.const	$push50=, 20
	i32.const	$19=, 16
	i32.add 	$19=, $24, $19
	i32.add 	$push51=, $19, $pop50
	i32.const	$20=, 64
	i32.add 	$20=, $24, $20
	i32.store	$discard=, 0($pop51), $20
	i32.const	$push52=, 16
	i32.const	$21=, 16
	i32.add 	$21=, $24, $21
	i32.add 	$push53=, $21, $pop52
	i32.const	$22=, 80
	i32.add 	$22=, $24, $22
	i32.store	$discard=, 0($pop53):p2align=4, $22
	i64.store	$discard=, 24($24), $2
	i64.store	$discard=, 16($24):p2align=4, $1
	i32.const	$push29=, 3
	i32.add 	$push30=, $0, $pop29
	i32.const	$23=, 16
	i32.add 	$23=, $24, $23
	i32.call	$push54=, bar@FUNCTION, $pop30, $23
	i32.const	$push84=, 20
	i32.ne  	$push55=, $pop54, $pop84
	br_if   	0, $pop55       # 0: down to label6
# BB#5:                                 # %if.end19
	i32.const	$push102=, 0
	i32.const	$push107=, 176
	i32.add 	$24=, $24, $pop107
	i32.const	$push108=, __stack_pointer
	i32.store	$discard=, 0($pop108), $24
	return  	$pop102
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
