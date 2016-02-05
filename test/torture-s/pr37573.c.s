	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr37573.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	call    	bar@FUNCTION
	block
	i32.const	$push1=, p
	i32.const	$push0=, q
	i32.const	$push2=, 23
	i32.call	$push3=, memcmp@FUNCTION, $pop1, $pop0, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.bar,"ax",@progbits
	.type	bar,@function
bar:                                    # @bar
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 2512
	i32.sub 	$32=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$32=, 0($4), $32
	i32.const	$push2=, 8
	i32.const	$6=, 8
	i32.add 	$6=, $32, $6
	i32.add 	$push3=, $6, $pop2
	i32.const	$push1=, 41589
	i32.store	$1=, 0($pop3):p2align=3, $pop1
	i32.const	$push4=, 12
	i32.const	$7=, 8
	i32.add 	$7=, $32, $7
	i32.add 	$0=, $7, $pop4
	i32.const	$2=, 1
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push86=, 30
	i32.shr_u	$push5=, $1, $pop86
	i32.xor 	$push6=, $pop5, $1
	i32.const	$push85=, 1812433253
	i32.mul 	$push7=, $pop6, $pop85
	i32.add 	$push0=, $pop7, $2
	i32.store	$1=, 0($0), $pop0
	i32.const	$push84=, 1
	i32.add 	$2=, $2, $pop84
	i32.const	$push83=, 4
	i32.add 	$0=, $0, $pop83
	i32.const	$push82=, 624
	i32.ne  	$push8=, $2, $pop82
	br_if   	$pop8, 0        # 0: up to label1
# BB#2:                                 # %for.end
	end_loop                        # label2:
	i32.const	$push9=, 4
	i32.const	$8=, 8
	i32.add 	$8=, $32, $8
	i32.or  	$push10=, $8, $pop9
	i32.const	$push11=, 1
	i32.store	$discard=, 0($pop10), $pop11
	i32.const	$push13=, 0
	i32.const	$push131=, 0
	i32.load8_u	$push14=, p($pop131):p2align=4
	i32.const	$9=, 8
	i32.add 	$9=, $32, $9
	i32.call	$push12=, foo@FUNCTION, $9
	i32.xor 	$push15=, $pop14, $pop12
	i32.store8	$discard=, p($pop13):p2align=4, $pop15
	i32.const	$push130=, 0
	i32.const	$push129=, 0
	i32.load8_u	$push17=, p+1($pop129)
	i32.const	$10=, 8
	i32.add 	$10=, $32, $10
	i32.call	$push16=, foo@FUNCTION, $10
	i32.xor 	$push18=, $pop17, $pop16
	i32.store8	$discard=, p+1($pop130), $pop18
	i32.const	$push128=, 0
	i32.const	$push127=, 0
	i32.load8_u	$push20=, p+2($pop127):p2align=1
	i32.const	$11=, 8
	i32.add 	$11=, $32, $11
	i32.call	$push19=, foo@FUNCTION, $11
	i32.xor 	$push21=, $pop20, $pop19
	i32.store8	$discard=, p+2($pop128):p2align=1, $pop21
	i32.const	$push126=, 0
	i32.const	$push125=, 0
	i32.load8_u	$push23=, p+3($pop125)
	i32.const	$12=, 8
	i32.add 	$12=, $32, $12
	i32.call	$push22=, foo@FUNCTION, $12
	i32.xor 	$push24=, $pop23, $pop22
	i32.store8	$discard=, p+3($pop126), $pop24
	i32.const	$push124=, 0
	i32.const	$push123=, 0
	i32.load8_u	$push26=, p+4($pop123):p2align=2
	i32.const	$13=, 8
	i32.add 	$13=, $32, $13
	i32.call	$push25=, foo@FUNCTION, $13
	i32.xor 	$push27=, $pop26, $pop25
	i32.store8	$discard=, p+4($pop124):p2align=2, $pop27
	i32.const	$push122=, 0
	i32.const	$push121=, 0
	i32.load8_u	$push29=, p+5($pop121)
	i32.const	$14=, 8
	i32.add 	$14=, $32, $14
	i32.call	$push28=, foo@FUNCTION, $14
	i32.xor 	$push30=, $pop29, $pop28
	i32.store8	$discard=, p+5($pop122), $pop30
	i32.const	$push120=, 0
	i32.const	$push119=, 0
	i32.load8_u	$push32=, p+6($pop119):p2align=1
	i32.const	$15=, 8
	i32.add 	$15=, $32, $15
	i32.call	$push31=, foo@FUNCTION, $15
	i32.xor 	$push33=, $pop32, $pop31
	i32.store8	$discard=, p+6($pop120):p2align=1, $pop33
	i32.const	$push118=, 0
	i32.const	$push117=, 0
	i32.load8_u	$push35=, p+7($pop117)
	i32.const	$16=, 8
	i32.add 	$16=, $32, $16
	i32.call	$push34=, foo@FUNCTION, $16
	i32.xor 	$push36=, $pop35, $pop34
	i32.store8	$discard=, p+7($pop118), $pop36
	i32.const	$push116=, 0
	i32.const	$push115=, 0
	i32.load8_u	$push38=, p+8($pop115):p2align=3
	i32.const	$17=, 8
	i32.add 	$17=, $32, $17
	i32.call	$push37=, foo@FUNCTION, $17
	i32.xor 	$push39=, $pop38, $pop37
	i32.store8	$discard=, p+8($pop116):p2align=3, $pop39
	i32.const	$push114=, 0
	i32.const	$push113=, 0
	i32.load8_u	$push41=, p+9($pop113)
	i32.const	$18=, 8
	i32.add 	$18=, $32, $18
	i32.call	$push40=, foo@FUNCTION, $18
	i32.xor 	$push42=, $pop41, $pop40
	i32.store8	$discard=, p+9($pop114), $pop42
	i32.const	$push112=, 0
	i32.const	$push111=, 0
	i32.load8_u	$push44=, p+10($pop111):p2align=1
	i32.const	$19=, 8
	i32.add 	$19=, $32, $19
	i32.call	$push43=, foo@FUNCTION, $19
	i32.xor 	$push45=, $pop44, $pop43
	i32.store8	$discard=, p+10($pop112):p2align=1, $pop45
	i32.const	$push110=, 0
	i32.const	$push109=, 0
	i32.load8_u	$push47=, p+11($pop109)
	i32.const	$20=, 8
	i32.add 	$20=, $32, $20
	i32.call	$push46=, foo@FUNCTION, $20
	i32.xor 	$push48=, $pop47, $pop46
	i32.store8	$discard=, p+11($pop110), $pop48
	i32.const	$push108=, 0
	i32.const	$push107=, 0
	i32.load8_u	$push50=, p+12($pop107):p2align=2
	i32.const	$21=, 8
	i32.add 	$21=, $32, $21
	i32.call	$push49=, foo@FUNCTION, $21
	i32.xor 	$push51=, $pop50, $pop49
	i32.store8	$discard=, p+12($pop108):p2align=2, $pop51
	i32.const	$push106=, 0
	i32.const	$push105=, 0
	i32.load8_u	$push53=, p+13($pop105)
	i32.const	$22=, 8
	i32.add 	$22=, $32, $22
	i32.call	$push52=, foo@FUNCTION, $22
	i32.xor 	$push54=, $pop53, $pop52
	i32.store8	$discard=, p+13($pop106), $pop54
	i32.const	$push104=, 0
	i32.const	$push103=, 0
	i32.load8_u	$push56=, p+14($pop103):p2align=1
	i32.const	$23=, 8
	i32.add 	$23=, $32, $23
	i32.call	$push55=, foo@FUNCTION, $23
	i32.xor 	$push57=, $pop56, $pop55
	i32.store8	$discard=, p+14($pop104):p2align=1, $pop57
	i32.const	$push102=, 0
	i32.const	$push101=, 0
	i32.load8_u	$push59=, p+15($pop101)
	i32.const	$24=, 8
	i32.add 	$24=, $32, $24
	i32.call	$push58=, foo@FUNCTION, $24
	i32.xor 	$push60=, $pop59, $pop58
	i32.store8	$discard=, p+15($pop102), $pop60
	i32.const	$push100=, 0
	i32.const	$push99=, 0
	i32.load8_u	$push62=, p+16($pop99):p2align=4
	i32.const	$25=, 8
	i32.add 	$25=, $32, $25
	i32.call	$push61=, foo@FUNCTION, $25
	i32.xor 	$push63=, $pop62, $pop61
	i32.store8	$discard=, p+16($pop100):p2align=4, $pop63
	i32.const	$push98=, 0
	i32.const	$push97=, 0
	i32.load8_u	$push65=, p+17($pop97)
	i32.const	$26=, 8
	i32.add 	$26=, $32, $26
	i32.call	$push64=, foo@FUNCTION, $26
	i32.xor 	$push66=, $pop65, $pop64
	i32.store8	$discard=, p+17($pop98), $pop66
	i32.const	$push96=, 0
	i32.const	$push95=, 0
	i32.load8_u	$push68=, p+18($pop95):p2align=1
	i32.const	$27=, 8
	i32.add 	$27=, $32, $27
	i32.call	$push67=, foo@FUNCTION, $27
	i32.xor 	$push69=, $pop68, $pop67
	i32.store8	$discard=, p+18($pop96):p2align=1, $pop69
	i32.const	$push94=, 0
	i32.const	$push93=, 0
	i32.load8_u	$push71=, p+19($pop93)
	i32.const	$28=, 8
	i32.add 	$28=, $32, $28
	i32.call	$push70=, foo@FUNCTION, $28
	i32.xor 	$push72=, $pop71, $pop70
	i32.store8	$discard=, p+19($pop94), $pop72
	i32.const	$push92=, 0
	i32.const	$push91=, 0
	i32.load8_u	$push74=, p+20($pop91):p2align=2
	i32.const	$29=, 8
	i32.add 	$29=, $32, $29
	i32.call	$push73=, foo@FUNCTION, $29
	i32.xor 	$push75=, $pop74, $pop73
	i32.store8	$discard=, p+20($pop92):p2align=2, $pop75
	i32.const	$push90=, 0
	i32.const	$push89=, 0
	i32.load8_u	$push77=, p+21($pop89)
	i32.const	$30=, 8
	i32.add 	$30=, $32, $30
	i32.call	$push76=, foo@FUNCTION, $30
	i32.xor 	$push78=, $pop77, $pop76
	i32.store8	$discard=, p+21($pop90), $pop78
	i32.const	$push88=, 0
	i32.const	$push87=, 0
	i32.load8_u	$push80=, p+22($pop87):p2align=1
	i32.const	$31=, 8
	i32.add 	$31=, $32, $31
	i32.call	$push79=, foo@FUNCTION, $31
	i32.xor 	$push81=, $pop80, $pop79
	i32.store8	$discard=, p+22($pop88):p2align=1, $pop81
	i32.const	$5=, 2512
	i32.add 	$32=, $32, $5
	i32.const	$5=, __stack_pointer
	i32.store	$32=, 0($5), $32
	return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.foo,"ax",@progbits
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.load	$push1=, 4($0)
	i32.const	$push2=, -1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$push4=, 4($0), $pop3
	br_if   	$pop4, 0        # 0: down to label3
# BB#1:                                 # %if.then
	i32.const	$push44=, 8
	i32.add 	$push5=, $0, $pop44
	i32.store	$discard=, 0($0), $pop5
	i32.load	$2=, 8($0)
	i32.const	$1=, 0
.LBB2_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.add 	$push6=, $0, $1
	tee_local	$push56=, $4=, $pop6
	i32.const	$push55=, 8
	i32.add 	$push19=, $pop56, $pop55
	i32.const	$push54=, 0
	i32.const	$push53=, 12
	i32.add 	$push7=, $4, $pop53
	i32.load	$push0=, 0($pop7)
	tee_local	$push52=, $3=, $pop0
	i32.const	$push51=, 1
	i32.and 	$push12=, $pop52, $pop51
	i32.sub 	$push13=, $pop54, $pop12
	i32.const	$push50=, -1727483681
	i32.and 	$push14=, $pop13, $pop50
	i32.const	$push49=, 1596
	i32.add 	$push15=, $4, $pop49
	i32.load	$push16=, 0($pop15)
	i32.xor 	$push17=, $pop14, $pop16
	i32.xor 	$push8=, $3, $2
	i32.const	$push48=, 2147483646
	i32.and 	$push9=, $pop8, $pop48
	i32.xor 	$push10=, $pop9, $2
	i32.const	$push47=, 1
	i32.shr_u	$push11=, $pop10, $pop47
	i32.xor 	$push18=, $pop17, $pop11
	i32.store	$discard=, 0($pop19), $pop18
	i32.const	$push46=, 4
	i32.add 	$1=, $1, $pop46
	copy_local	$2=, $3
	i32.const	$push45=, 908
	i32.ne  	$push20=, $1, $pop45
	br_if   	$pop20, 0       # 0: up to label4
.LBB2_3:                                # %if.end
	end_loop                        # label5:
	end_block                       # label3:
	i32.load	$push21=, 0($0)
	tee_local	$push59=, $2=, $pop21
	i32.load	$1=, 0($pop59)
	i32.const	$push22=, 4
	i32.add 	$push23=, $2, $pop22
	i32.store	$discard=, 0($0), $pop23
	i32.const	$push24=, 11
	i32.shr_u	$push25=, $1, $pop24
	i32.xor 	$push26=, $1, $pop25
	tee_local	$push58=, $1=, $pop26
	i32.const	$push27=, 7
	i32.shl 	$push28=, $pop58, $pop27
	i32.const	$push29=, -1658038656
	i32.and 	$push30=, $pop28, $pop29
	i32.xor 	$push31=, $pop30, $1
	tee_local	$push57=, $1=, $pop31
	i32.const	$push32=, 15
	i32.shl 	$push33=, $pop57, $pop32
	i32.const	$push34=, 130023424
	i32.and 	$push35=, $pop33, $pop34
	i32.xor 	$push36=, $pop35, $1
	i32.const	$push37=, 18
	i32.shr_u	$push38=, $pop36, $pop37
	i32.xor 	$push39=, $pop38, $1
	i32.const	$push40=, 1
	i32.shr_u	$push41=, $pop39, $pop40
	i32.const	$push42=, 255
	i32.and 	$push43=, $pop41, $pop42
	return  	$pop43
	.endfunc
.Lfunc_end2:
	.size	foo, .Lfunc_end2-foo

	.type	p,@object               # @p
	.section	.data.p,"aw",@progbits
	.p2align	4
p:
	.ascii	"\300I\0272b\036.\325L\031(I\221\344r\203\221=\223\203\263a8"
	.size	p, 23

	.type	q,@object               # @q
	.section	.data.q,"aw",@progbits
	.p2align	4
q:
	.ascii	">AUTOIT UNICODE SCRIPT<"
	.size	q, 23


	.ident	"clang version 3.9.0 "
