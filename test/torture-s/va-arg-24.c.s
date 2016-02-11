	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-24.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i64, i32, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 288
	i32.sub 	$39=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$39=, 0($9), $39
	i32.const	$push0=, 32
	i32.const	$10=, 240
	i32.add 	$10=, $39, $10
	i32.add 	$push1=, $10, $pop0
	i64.const	$push2=, 42949672969
	i64.store	$0=, 0($pop1):p2align=4, $pop2
	i32.const	$push3=, 24
	i32.const	$11=, 240
	i32.add 	$11=, $39, $11
	i32.add 	$push4=, $11, $pop3
	i64.const	$push5=, 34359738375
	i64.store	$1=, 0($pop4), $pop5
	i32.const	$push6=, 16
	i32.const	$12=, 240
	i32.add 	$12=, $39, $12
	i32.add 	$push7=, $12, $pop6
	i64.const	$push8=, 25769803781
	i64.store	$2=, 0($pop7):p2align=4, $pop8
	i32.const	$push9=, 8
	i32.const	$13=, 240
	i32.add 	$13=, $39, $13
	i32.or  	$push10=, $13, $pop9
	i64.const	$push11=, 17179869187
	i64.store	$3=, 0($pop10), $pop11
	i64.const	$push12=, 8589934593
	i64.store	$discard=, 240($39):p2align=4, $pop12
	i32.const	$14=, 240
	i32.add 	$14=, $39, $14
	call    	varargs0@FUNCTION, $4, $14
	i32.const	$push51=, 32
	i32.const	$15=, 192
	i32.add 	$15=, $39, $15
	i32.add 	$push13=, $15, $pop51
	i32.const	$push14=, 10
	i32.store	$4=, 0($pop13):p2align=4, $pop14
	i32.const	$push50=, 24
	i32.const	$16=, 192
	i32.add 	$16=, $39, $16
	i32.add 	$push15=, $16, $pop50
	i64.const	$push16=, 38654705672
	i64.store	$5=, 0($pop15), $pop16
	i32.const	$push49=, 16
	i32.const	$17=, 192
	i32.add 	$17=, $39, $17
	i32.add 	$push17=, $17, $pop49
	i64.const	$push18=, 30064771078
	i64.store	$6=, 0($pop17):p2align=4, $pop18
	i32.const	$push48=, 8
	i32.const	$18=, 192
	i32.add 	$18=, $39, $18
	i32.or  	$push19=, $18, $pop48
	i64.const	$push20=, 21474836484
	i64.store	$7=, 0($pop19), $pop20
	i64.const	$push21=, 12884901890
	i64.store	$discard=, 192($39):p2align=4, $pop21
	i32.const	$19=, 192
	i32.add 	$19=, $39, $19
	call    	varargs1@FUNCTION, $4, $4, $19
	i32.const	$push47=, 24
	i32.const	$20=, 160
	i32.add 	$20=, $39, $20
	i32.add 	$push22=, $20, $pop47
	i64.store	$discard=, 0($pop22), $0
	i32.const	$push46=, 16
	i32.const	$21=, 160
	i32.add 	$21=, $39, $21
	i32.add 	$push23=, $21, $pop46
	i64.store	$discard=, 0($pop23):p2align=4, $1
	i32.const	$push45=, 8
	i32.const	$22=, 160
	i32.add 	$22=, $39, $22
	i32.or  	$push24=, $22, $pop45
	i64.store	$discard=, 0($pop24), $2
	i64.store	$discard=, 160($39):p2align=4, $3
	i32.const	$23=, 160
	i32.add 	$23=, $39, $23
	call    	varargs2@FUNCTION, $4, $4, $4, $23
	i32.const	$push44=, 24
	i32.const	$24=, 128
	i32.add 	$24=, $39, $24
	i32.add 	$push25=, $24, $pop44
	i32.store	$discard=, 0($pop25):p2align=3, $4
	i32.const	$push43=, 16
	i32.const	$25=, 128
	i32.add 	$25=, $39, $25
	i32.add 	$push26=, $25, $pop43
	i64.store	$3=, 0($pop26):p2align=4, $5
	i32.const	$push42=, 8
	i32.const	$26=, 128
	i32.add 	$26=, $39, $26
	i32.or  	$push27=, $26, $pop42
	i64.store	$5=, 0($pop27), $6
	i64.store	$discard=, 128($39):p2align=4, $7
	i32.const	$27=, 128
	i32.add 	$27=, $39, $27
	call    	varargs3@FUNCTION, $4, $4, $4, $4, $27
	i32.const	$push41=, 16
	i32.const	$28=, 96
	i32.add 	$28=, $39, $28
	i32.add 	$push28=, $28, $pop41
	i64.store	$discard=, 0($pop28):p2align=4, $0
	i32.const	$push40=, 8
	i32.const	$29=, 96
	i32.add 	$29=, $39, $29
	i32.or  	$push29=, $29, $pop40
	i64.store	$discard=, 0($pop29), $1
	i64.store	$discard=, 96($39):p2align=4, $2
	i32.const	$30=, 96
	i32.add 	$30=, $39, $30
	call    	varargs4@FUNCTION, $4, $4, $4, $4, $4, $30
	i32.const	$push39=, 16
	i32.const	$31=, 64
	i32.add 	$31=, $39, $31
	i32.add 	$push30=, $31, $pop39
	i32.store	$discard=, 0($pop30):p2align=4, $4
	i32.const	$push38=, 8
	i32.const	$32=, 64
	i32.add 	$32=, $39, $32
	i32.or  	$push31=, $32, $pop38
	i64.store	$2=, 0($pop31), $3
	i64.store	$discard=, 64($39):p2align=4, $5
	i32.const	$33=, 64
	i32.add 	$33=, $39, $33
	call    	varargs5@FUNCTION, $4, $4, $4, $4, $4, $4, $33
	i32.const	$push37=, 8
	i32.const	$34=, 48
	i32.add 	$34=, $39, $34
	i32.or  	$push32=, $34, $pop37
	i64.store	$discard=, 0($pop32), $0
	i64.store	$discard=, 48($39):p2align=4, $1
	i32.const	$35=, 48
	i32.add 	$35=, $39, $35
	call    	varargs6@FUNCTION, $4, $4, $4, $4, $4, $4, $4, $35
	i32.const	$push36=, 8
	i32.const	$36=, 32
	i32.add 	$36=, $39, $36
	i32.or  	$push33=, $36, $pop36
	i32.store	$discard=, 0($pop33):p2align=3, $4
	i64.store	$discard=, 32($39):p2align=4, $2
	i32.const	$37=, 32
	i32.add 	$37=, $39, $37
	call    	varargs7@FUNCTION, $4, $4, $4, $4, $4, $4, $4, $4, $37
	i64.store	$discard=, 16($39):p2align=4, $0
	i32.const	$38=, 16
	i32.add 	$38=, $39, $38
	call    	varargs8@FUNCTION, $4, $4, $4, $4, $4, $4, $4, $4, $4, $38
	i32.store	$discard=, 0($39):p2align=4, $4
	call    	varargs9@FUNCTION, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $39
	block
	i32.const	$push35=, 0
	i32.load	$push34=, errors($pop35)
	br_if   	0, $pop34       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push52=, 0
	call    	exit@FUNCTION, $pop52
	unreachable
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.varargs0,"ax",@progbits
	.type	varargs0,@function
varargs0:                               # @varargs0
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 64
	i32.sub 	$12=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$12=, 0($7), $12
	i32.store	$discard=, 60($12), $1
	i32.load	$push1=, 60($12)
	i32.const	$push2=, 3
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -4
	i32.and 	$push5=, $pop3, $pop4
	tee_local	$push95=, $1=, $pop5
	i32.const	$push94=, 4
	i32.add 	$push6=, $pop95, $pop94
	i32.store	$discard=, 60($12), $pop6
	i32.const	$push0=, 0
	i32.store	$2=, 16($12):p2align=4, $pop0
	i32.const	$push93=, 4
	i32.const	$9=, 16
	i32.add 	$9=, $12, $9
	i32.or  	$push54=, $9, $pop93
	tee_local	$push92=, $5=, $pop54
	i32.load	$push7=, 0($1)
	i32.store	$discard=, 0($pop92), $pop7
	i32.const	$push8=, 7
	i32.add 	$push9=, $1, $pop8
	i32.const	$push91=, -4
	i32.and 	$push10=, $pop9, $pop91
	tee_local	$push90=, $1=, $pop10
	i32.const	$push89=, 4
	i32.add 	$push11=, $pop90, $pop89
	i32.store	$discard=, 60($12), $pop11
	i32.const	$push88=, 8
	i32.const	$10=, 16
	i32.add 	$10=, $12, $10
	i32.or  	$push13=, $10, $pop88
	i32.load	$push12=, 0($1)
	i32.store	$discard=, 0($pop13):p2align=3, $pop12
	i32.const	$push87=, 7
	i32.add 	$push14=, $1, $pop87
	i32.const	$push86=, -4
	i32.and 	$push15=, $pop14, $pop86
	tee_local	$push85=, $1=, $pop15
	i32.const	$push84=, 4
	i32.add 	$push16=, $pop85, $pop84
	i32.store	$discard=, 60($12), $pop16
	i32.const	$push83=, 12
	i32.const	$11=, 16
	i32.add 	$11=, $12, $11
	i32.or  	$push18=, $11, $pop83
	i32.load	$push17=, 0($1)
	i32.store	$discard=, 0($pop18), $pop17
	i32.const	$push82=, 7
	i32.add 	$push19=, $1, $pop82
	i32.const	$push81=, -4
	i32.and 	$push20=, $pop19, $pop81
	tee_local	$push80=, $1=, $pop20
	i32.const	$push79=, 4
	i32.add 	$push21=, $pop80, $pop79
	i32.store	$discard=, 60($12), $pop21
	i32.load	$push22=, 0($1)
	i32.store	$discard=, 32($12):p2align=4, $pop22
	i32.const	$push78=, 7
	i32.add 	$push23=, $1, $pop78
	i32.const	$push77=, -4
	i32.and 	$push24=, $pop23, $pop77
	tee_local	$push76=, $1=, $pop24
	i32.const	$push75=, 4
	i32.add 	$push25=, $pop76, $pop75
	i32.store	$discard=, 60($12), $pop25
	i32.load	$push26=, 0($1)
	i32.store	$discard=, 36($12), $pop26
	i32.const	$push74=, 7
	i32.add 	$push27=, $1, $pop74
	i32.const	$push73=, -4
	i32.and 	$push28=, $pop27, $pop73
	tee_local	$push72=, $1=, $pop28
	i32.const	$push71=, 4
	i32.add 	$push29=, $pop72, $pop71
	i32.store	$discard=, 60($12), $pop29
	i32.load	$push30=, 0($1)
	i32.store	$discard=, 40($12):p2align=3, $pop30
	i32.const	$push70=, 7
	i32.add 	$push31=, $1, $pop70
	i32.const	$push69=, -4
	i32.and 	$push32=, $pop31, $pop69
	tee_local	$push68=, $1=, $pop32
	i32.const	$push67=, 4
	i32.add 	$push33=, $pop68, $pop67
	i32.store	$discard=, 60($12), $pop33
	i32.load	$push34=, 0($1)
	i32.store	$discard=, 44($12), $pop34
	i32.const	$push66=, 7
	i32.add 	$push35=, $1, $pop66
	i32.const	$push65=, -4
	i32.and 	$push36=, $pop35, $pop65
	tee_local	$push64=, $1=, $pop36
	i32.const	$push63=, 4
	i32.add 	$push37=, $pop64, $pop63
	i32.store	$discard=, 60($12), $pop37
	i32.load	$push38=, 0($1)
	i32.store	$discard=, 48($12):p2align=4, $pop38
	i32.const	$push62=, 7
	i32.add 	$push39=, $1, $pop62
	i32.const	$push61=, -4
	i32.and 	$push40=, $pop39, $pop61
	tee_local	$push60=, $1=, $pop40
	i32.const	$push59=, 4
	i32.add 	$push41=, $pop60, $pop59
	i32.store	$discard=, 60($12), $pop41
	i32.load	$push42=, 0($1)
	i32.store	$discard=, 52($12), $pop42
	i32.const	$push58=, 7
	i32.add 	$push43=, $1, $pop58
	i32.const	$push57=, -4
	i32.and 	$push44=, $pop43, $pop57
	tee_local	$push56=, $1=, $pop44
	i32.const	$push55=, 4
	i32.add 	$push45=, $pop56, $pop55
	i32.store	$discard=, 60($12), $pop45
	i32.load	$push46=, 0($1)
	i32.store	$discard=, 56($12):p2align=3, $pop46
	copy_local	$4=, $2
	copy_local	$1=, $2
.LBB1_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	block
	i32.eq  	$push47=, $1, $4
	br_if   	0, $pop47       # 0: down to label3
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push101=, 12
	i32.or  	$push48=, $12, $pop101
	i32.store	$3=, 0($pop48), $1
	i32.const	$push100=, 8
	i32.or  	$push49=, $12, $pop100
	i32.store	$discard=, 0($pop49):p2align=3, $4
	i32.const	$push99=, 4
	i32.or  	$push50=, $12, $pop99
	i32.store	$discard=, 0($pop50), $3
	i32.const	$push98=, .L.str
	i32.store	$discard=, 0($12):p2align=4, $pop98
	i32.const	$push97=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop97, $12
	i32.load	$push51=, errors($2)
	i32.const	$push96=, 1
	i32.add 	$push52=, $pop51, $pop96
	i32.store	$discard=, errors($2), $pop52
.LBB1_3:                                # %for.inc.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.const	$push102=, 10
	i32.eq  	$push53=, $1, $pop102
	br_if   	1, $pop53       # 1: down to label2
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$4=, 0($5)
	i32.const	$push104=, 1
	i32.add 	$1=, $1, $pop104
	i32.const	$push103=, 4
	i32.add 	$5=, $5, $pop103
	br      	0               # 0: up to label1
.LBB1_5:                                # %verify.exit
	end_loop                        # label2:
	i32.const	$8=, 64
	i32.add 	$12=, $12, $8
	i32.const	$8=, __stack_pointer
	i32.store	$12=, 0($8), $12
	return
	.endfunc
.Lfunc_end1:
	.size	varargs0, .Lfunc_end1-varargs0

	.section	.text.varargs1,"ax",@progbits
	.type	varargs1,@function
varargs1:                               # @varargs1
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 64
	i32.sub 	$12=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$12=, 0($7), $12
	i32.store	$discard=, 60($12), $2
	i32.load	$push1=, 60($12)
	i32.const	$push2=, 3
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -4
	i32.and 	$push5=, $pop3, $pop4
	tee_local	$push85=, $2=, $pop5
	i32.const	$push84=, 4
	i32.add 	$push6=, $pop85, $pop84
	i32.store	$discard=, 60($12), $pop6
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($12):p2align=4, $pop0
	i32.const	$push83=, 8
	i32.const	$9=, 16
	i32.add 	$9=, $12, $9
	i32.or  	$push8=, $9, $pop83
	i32.load	$push7=, 0($2)
	i32.store	$discard=, 0($pop8):p2align=3, $pop7
	i32.const	$push9=, 7
	i32.add 	$push10=, $2, $pop9
	i32.const	$push82=, -4
	i32.and 	$push11=, $pop10, $pop82
	tee_local	$push81=, $2=, $pop11
	i32.const	$push80=, 4
	i32.add 	$push12=, $pop81, $pop80
	i32.store	$discard=, 60($12), $pop12
	i32.const	$push79=, 12
	i32.const	$10=, 16
	i32.add 	$10=, $12, $10
	i32.or  	$push14=, $10, $pop79
	i32.load	$push13=, 0($2)
	i32.store	$discard=, 0($pop14), $pop13
	i32.const	$push78=, 7
	i32.add 	$push15=, $2, $pop78
	i32.const	$push77=, -4
	i32.and 	$push16=, $pop15, $pop77
	tee_local	$push76=, $2=, $pop16
	i32.const	$push75=, 4
	i32.add 	$push17=, $pop76, $pop75
	i32.store	$discard=, 60($12), $pop17
	i32.load	$push18=, 0($2)
	i32.store	$discard=, 32($12):p2align=4, $pop18
	i32.const	$push74=, 7
	i32.add 	$push19=, $2, $pop74
	i32.const	$push73=, -4
	i32.and 	$push20=, $pop19, $pop73
	tee_local	$push72=, $2=, $pop20
	i32.const	$push71=, 4
	i32.add 	$push21=, $pop72, $pop71
	i32.store	$discard=, 60($12), $pop21
	i32.load	$push22=, 0($2)
	i32.store	$discard=, 36($12), $pop22
	i32.const	$push70=, 7
	i32.add 	$push23=, $2, $pop70
	i32.const	$push69=, -4
	i32.and 	$push24=, $pop23, $pop69
	tee_local	$push68=, $2=, $pop24
	i32.const	$push67=, 4
	i32.add 	$push25=, $pop68, $pop67
	i32.store	$discard=, 60($12), $pop25
	i32.load	$push26=, 0($2)
	i32.store	$discard=, 40($12):p2align=3, $pop26
	i32.const	$push66=, 7
	i32.add 	$push27=, $2, $pop66
	i32.const	$push65=, -4
	i32.and 	$push28=, $pop27, $pop65
	tee_local	$push64=, $2=, $pop28
	i32.const	$push63=, 4
	i32.add 	$push29=, $pop64, $pop63
	i32.store	$discard=, 60($12), $pop29
	i32.load	$push30=, 0($2)
	i32.store	$discard=, 44($12), $pop30
	i32.const	$push62=, 7
	i32.add 	$push31=, $2, $pop62
	i32.const	$push61=, -4
	i32.and 	$push32=, $pop31, $pop61
	tee_local	$push60=, $2=, $pop32
	i32.const	$push59=, 4
	i32.add 	$push33=, $pop60, $pop59
	i32.store	$discard=, 60($12), $pop33
	i32.load	$push34=, 0($2)
	i32.store	$discard=, 48($12):p2align=4, $pop34
	i32.const	$push58=, 7
	i32.add 	$push35=, $2, $pop58
	i32.const	$push57=, -4
	i32.and 	$push36=, $pop35, $pop57
	tee_local	$push56=, $2=, $pop36
	i32.const	$push55=, 4
	i32.add 	$push37=, $pop56, $pop55
	i32.store	$discard=, 60($12), $pop37
	i32.load	$push38=, 0($2)
	i32.store	$discard=, 52($12), $pop38
	i32.const	$push54=, 7
	i32.add 	$push39=, $2, $pop54
	i32.const	$push53=, -4
	i32.and 	$push40=, $pop39, $pop53
	tee_local	$push52=, $2=, $pop40
	i32.const	$push51=, 4
	i32.add 	$push41=, $pop52, $pop51
	i32.store	$discard=, 60($12), $pop41
	i32.load	$push42=, 0($2)
	i32.store	$discard=, 56($12):p2align=3, $pop42
	i32.const	$push50=, 4
	i32.const	$11=, 16
	i32.add 	$11=, $12, $11
	i32.or  	$4=, $11, $pop50
	i32.const	$5=, 0
	i32.const	$2=, 0
.LBB2_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	block
	i32.eq  	$push43=, $2, $5
	br_if   	0, $pop43       # 0: down to label6
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push93=, 12
	i32.or  	$push44=, $12, $pop93
	i32.store	$3=, 0($pop44), $2
	i32.const	$push92=, 8
	i32.or  	$push45=, $12, $pop92
	i32.store	$discard=, 0($pop45):p2align=3, $5
	i32.const	$push91=, 4
	i32.or  	$push46=, $12, $pop91
	i32.store	$discard=, 0($pop46), $3
	i32.const	$push90=, .L.str.2
	i32.store	$discard=, 0($12):p2align=4, $pop90
	i32.const	$push89=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop89, $12
	i32.const	$push88=, 0
	i32.const	$push87=, 0
	i32.load	$push47=, errors($pop87)
	i32.const	$push86=, 1
	i32.add 	$push48=, $pop47, $pop86
	i32.store	$discard=, errors($pop88), $pop48
.LBB2_3:                                # %for.inc.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label6:
	i32.const	$push94=, 10
	i32.eq  	$push49=, $2, $pop94
	br_if   	1, $pop49       # 1: down to label5
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load	$5=, 0($4)
	i32.const	$push96=, 1
	i32.add 	$2=, $2, $pop96
	i32.const	$push95=, 4
	i32.add 	$4=, $4, $pop95
	br      	0               # 0: up to label4
.LBB2_5:                                # %verify.exit
	end_loop                        # label5:
	i32.const	$8=, 64
	i32.add 	$12=, $12, $8
	i32.const	$8=, __stack_pointer
	i32.store	$12=, 0($8), $12
	return
	.endfunc
.Lfunc_end2:
	.size	varargs1, .Lfunc_end2-varargs1

	.section	.text.varargs2,"ax",@progbits
	.type	varargs2,@function
varargs2:                               # @varargs2
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 64
	i32.sub 	$13=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$13=, 0($8), $13
	i32.store	$discard=, 60($13), $3
	i32.load	$3=, 60($13)
	i32.const	$push77=, 8
	i32.const	$10=, 16
	i32.add 	$10=, $13, $10
	i32.or  	$push1=, $10, $pop77
	i32.const	$push2=, 2
	i32.store	$discard=, 0($pop1):p2align=3, $pop2
	i32.const	$push3=, 3
	i32.add 	$push4=, $3, $pop3
	i32.const	$push5=, -4
	i32.and 	$push6=, $pop4, $pop5
	tee_local	$push76=, $3=, $pop6
	i32.const	$push75=, 4
	i32.add 	$push7=, $pop76, $pop75
	i32.store	$discard=, 60($13), $pop7
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($13):p2align=4, $pop0
	i32.load	$5=, 60($13)
	i32.const	$push74=, 12
	i32.const	$11=, 16
	i32.add 	$11=, $13, $11
	i32.or  	$push9=, $11, $pop74
	i32.load	$push8=, 0($3)
	i32.store	$discard=, 0($pop9), $pop8
	i32.const	$push73=, 3
	i32.add 	$push10=, $5, $pop73
	i32.const	$push72=, -4
	i32.and 	$push11=, $pop10, $pop72
	tee_local	$push71=, $3=, $pop11
	i32.const	$push70=, 4
	i32.add 	$push12=, $pop71, $pop70
	i32.store	$discard=, 60($13), $pop12
	i32.load	$push13=, 0($3)
	i32.store	$discard=, 32($13):p2align=4, $pop13
	i32.const	$push14=, 7
	i32.add 	$push15=, $3, $pop14
	i32.const	$push69=, -4
	i32.and 	$push16=, $pop15, $pop69
	tee_local	$push68=, $3=, $pop16
	i32.const	$push67=, 4
	i32.add 	$push17=, $pop68, $pop67
	i32.store	$discard=, 60($13), $pop17
	i32.load	$push18=, 0($3)
	i32.store	$discard=, 36($13), $pop18
	i32.const	$push66=, 7
	i32.add 	$push19=, $3, $pop66
	i32.const	$push65=, -4
	i32.and 	$push20=, $pop19, $pop65
	tee_local	$push64=, $3=, $pop20
	i32.const	$push63=, 4
	i32.add 	$push21=, $pop64, $pop63
	i32.store	$discard=, 60($13), $pop21
	i32.load	$push22=, 0($3)
	i32.store	$discard=, 40($13):p2align=3, $pop22
	i32.const	$push62=, 7
	i32.add 	$push23=, $3, $pop62
	i32.const	$push61=, -4
	i32.and 	$push24=, $pop23, $pop61
	tee_local	$push60=, $3=, $pop24
	i32.const	$push59=, 4
	i32.add 	$push25=, $pop60, $pop59
	i32.store	$discard=, 60($13), $pop25
	i32.load	$push26=, 0($3)
	i32.store	$discard=, 44($13), $pop26
	i32.const	$push58=, 7
	i32.add 	$push27=, $3, $pop58
	i32.const	$push57=, -4
	i32.and 	$push28=, $pop27, $pop57
	tee_local	$push56=, $3=, $pop28
	i32.const	$push55=, 4
	i32.add 	$push29=, $pop56, $pop55
	i32.store	$discard=, 60($13), $pop29
	i32.load	$push30=, 0($3)
	i32.store	$discard=, 48($13):p2align=4, $pop30
	i32.const	$push54=, 7
	i32.add 	$push31=, $3, $pop54
	i32.const	$push53=, -4
	i32.and 	$push32=, $pop31, $pop53
	tee_local	$push52=, $3=, $pop32
	i32.const	$push51=, 4
	i32.add 	$push33=, $pop52, $pop51
	i32.store	$discard=, 60($13), $pop33
	i32.load	$push34=, 0($3)
	i32.store	$discard=, 52($13), $pop34
	i32.const	$push50=, 7
	i32.add 	$push35=, $3, $pop50
	i32.const	$push49=, -4
	i32.and 	$push36=, $pop35, $pop49
	tee_local	$push48=, $3=, $pop36
	i32.const	$push47=, 4
	i32.add 	$push37=, $pop48, $pop47
	i32.store	$discard=, 60($13), $pop37
	i32.load	$push38=, 0($3)
	i32.store	$discard=, 56($13):p2align=3, $pop38
	i32.const	$push46=, 4
	i32.const	$12=, 16
	i32.add 	$12=, $13, $12
	i32.or  	$5=, $12, $pop46
	i32.const	$6=, 0
	i32.const	$3=, 0
.LBB3_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	block
	i32.eq  	$push39=, $3, $6
	br_if   	0, $pop39       # 0: down to label9
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.const	$push85=, 12
	i32.or  	$push40=, $13, $pop85
	i32.store	$4=, 0($pop40), $3
	i32.const	$push84=, 8
	i32.or  	$push41=, $13, $pop84
	i32.store	$discard=, 0($pop41):p2align=3, $6
	i32.const	$push83=, 4
	i32.or  	$push42=, $13, $pop83
	i32.store	$discard=, 0($pop42), $4
	i32.const	$push82=, .L.str.3
	i32.store	$discard=, 0($13):p2align=4, $pop82
	i32.const	$push81=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop81, $13
	i32.const	$push80=, 0
	i32.const	$push79=, 0
	i32.load	$push43=, errors($pop79)
	i32.const	$push78=, 1
	i32.add 	$push44=, $pop43, $pop78
	i32.store	$discard=, errors($pop80), $pop44
.LBB3_3:                                # %for.inc.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_block                       # label9:
	i32.const	$push86=, 10
	i32.eq  	$push45=, $3, $pop86
	br_if   	1, $pop45       # 1: down to label8
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.load	$6=, 0($5)
	i32.const	$push88=, 1
	i32.add 	$3=, $3, $pop88
	i32.const	$push87=, 4
	i32.add 	$5=, $5, $pop87
	br      	0               # 0: up to label7
.LBB3_5:                                # %verify.exit
	end_loop                        # label8:
	i32.const	$9=, 64
	i32.add 	$13=, $13, $9
	i32.const	$9=, __stack_pointer
	i32.store	$13=, 0($9), $13
	return
	.endfunc
.Lfunc_end3:
	.size	varargs2, .Lfunc_end3-varargs2

	.section	.text.varargs3,"ax",@progbits
	.type	varargs3,@function
varargs3:                               # @varargs3
	.param  	i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 64
	i32.sub 	$14=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$14=, 0($10), $14
	i32.store	$discard=, 60($14), $4
	i32.load	$4=, 60($14)
	i32.const	$push67=, 8
	i32.const	$12=, 16
	i32.add 	$12=, $14, $12
	i32.or  	$push1=, $12, $pop67
	i64.const	$push2=, 12884901890
	i64.store	$discard=, 0($pop1), $pop2
	i32.const	$push3=, 3
	i32.add 	$push4=, $4, $pop3
	i32.const	$push5=, -4
	i32.and 	$push6=, $pop4, $pop5
	tee_local	$push66=, $4=, $pop6
	i32.const	$push65=, 4
	i32.add 	$push7=, $pop66, $pop65
	i32.store	$discard=, 60($14), $pop7
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($14):p2align=4, $pop0
	i32.load	$7=, 60($14)
	i32.load	$push8=, 0($4)
	i32.store	$discard=, 32($14):p2align=4, $pop8
	i32.const	$push64=, 3
	i32.add 	$push9=, $7, $pop64
	i32.const	$push63=, -4
	i32.and 	$push10=, $pop9, $pop63
	tee_local	$push62=, $4=, $pop10
	i32.const	$push61=, 4
	i32.add 	$push11=, $pop62, $pop61
	i32.store	$discard=, 60($14), $pop11
	i32.load	$push12=, 0($4)
	i32.store	$discard=, 36($14), $pop12
	i32.const	$push13=, 7
	i32.add 	$push14=, $4, $pop13
	i32.const	$push60=, -4
	i32.and 	$push15=, $pop14, $pop60
	tee_local	$push59=, $4=, $pop15
	i32.const	$push58=, 4
	i32.add 	$push16=, $pop59, $pop58
	i32.store	$discard=, 60($14), $pop16
	i32.load	$push17=, 0($4)
	i32.store	$discard=, 40($14):p2align=3, $pop17
	i32.const	$push57=, 7
	i32.add 	$push18=, $4, $pop57
	i32.const	$push56=, -4
	i32.and 	$push19=, $pop18, $pop56
	tee_local	$push55=, $4=, $pop19
	i32.const	$push54=, 4
	i32.add 	$push20=, $pop55, $pop54
	i32.store	$discard=, 60($14), $pop20
	i32.load	$push21=, 0($4)
	i32.store	$discard=, 44($14), $pop21
	i32.const	$push53=, 7
	i32.add 	$push22=, $4, $pop53
	i32.const	$push52=, -4
	i32.and 	$push23=, $pop22, $pop52
	tee_local	$push51=, $4=, $pop23
	i32.const	$push50=, 4
	i32.add 	$push24=, $pop51, $pop50
	i32.store	$discard=, 60($14), $pop24
	i32.load	$push25=, 0($4)
	i32.store	$discard=, 48($14):p2align=4, $pop25
	i32.const	$push49=, 7
	i32.add 	$push26=, $4, $pop49
	i32.const	$push48=, -4
	i32.and 	$push27=, $pop26, $pop48
	tee_local	$push47=, $4=, $pop27
	i32.const	$push46=, 4
	i32.add 	$push28=, $pop47, $pop46
	i32.store	$discard=, 60($14), $pop28
	i32.load	$push29=, 0($4)
	i32.store	$discard=, 52($14), $pop29
	i32.const	$push45=, 7
	i32.add 	$push30=, $4, $pop45
	i32.const	$push44=, -4
	i32.and 	$push31=, $pop30, $pop44
	tee_local	$push43=, $4=, $pop31
	i32.const	$push42=, 4
	i32.add 	$push32=, $pop43, $pop42
	i32.store	$discard=, 60($14), $pop32
	i32.load	$push33=, 0($4)
	i32.store	$discard=, 56($14):p2align=3, $pop33
	i32.const	$push35=, 12
	i32.or  	$5=, $14, $pop35
	i32.const	$push41=, 4
	i32.const	$13=, 16
	i32.add 	$13=, $14, $13
	i32.or  	$7=, $13, $pop41
	i32.const	$8=, 0
	i32.const	$4=, 0
.LBB4_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	block
	i32.eq  	$push34=, $4, $8
	br_if   	0, $pop34       # 0: down to label12
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB4_1 Depth=1
	i32.store	$6=, 0($5), $4
	i32.const	$push74=, 8
	i32.or  	$push36=, $14, $pop74
	i32.store	$discard=, 0($pop36):p2align=3, $8
	i32.const	$push73=, 4
	i32.or  	$push37=, $14, $pop73
	i32.store	$discard=, 0($pop37), $6
	i32.const	$push72=, .L.str.4
	i32.store	$discard=, 0($14):p2align=4, $pop72
	i32.const	$push71=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop71, $14
	i32.const	$push70=, 0
	i32.const	$push69=, 0
	i32.load	$push38=, errors($pop69)
	i32.const	$push68=, 1
	i32.add 	$push39=, $pop38, $pop68
	i32.store	$discard=, errors($pop70), $pop39
.LBB4_3:                                # %for.inc.i
                                        #   in Loop: Header=BB4_1 Depth=1
	end_block                       # label12:
	i32.const	$push75=, 10
	i32.eq  	$push40=, $4, $pop75
	br_if   	1, $pop40       # 1: down to label11
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB4_1 Depth=1
	i32.load	$8=, 0($7)
	i32.const	$push77=, 1
	i32.add 	$4=, $4, $pop77
	i32.const	$push76=, 4
	i32.add 	$7=, $7, $pop76
	br      	0               # 0: up to label10
.LBB4_5:                                # %verify.exit
	end_loop                        # label11:
	i32.const	$11=, 64
	i32.add 	$14=, $14, $11
	i32.const	$11=, __stack_pointer
	i32.store	$14=, 0($11), $14
	return
	.endfunc
.Lfunc_end4:
	.size	varargs3, .Lfunc_end4-varargs3

	.section	.text.varargs4,"ax",@progbits
	.type	varargs4,@function
varargs4:                               # @varargs4
	.param  	i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 64
	i32.sub 	$16=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$16=, 0($12), $16
	i32.store	$discard=, 60($16), $5
	i32.load	$5=, 60($16)
	i32.const	$push56=, 8
	i32.const	$14=, 16
	i32.add 	$14=, $16, $14
	i32.or  	$push2=, $14, $pop56
	i64.const	$push3=, 12884901890
	i64.store	$discard=, 0($pop2), $pop3
	i32.const	$push5=, 3
	i32.add 	$push6=, $5, $pop5
	i32.const	$push7=, -4
	i32.and 	$push8=, $pop6, $pop7
	tee_local	$push55=, $5=, $pop8
	i32.const	$push1=, 4
	i32.store	$push4=, 32($16):p2align=4, $pop1
	tee_local	$push54=, $10=, $pop4
	i32.add 	$push9=, $pop55, $pop54
	i32.store	$discard=, 60($16), $pop9
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($16):p2align=4, $pop0
	i32.load	$8=, 60($16)
	i32.load	$push10=, 0($5)
	i32.store	$discard=, 36($16), $pop10
	i32.const	$push53=, 3
	i32.add 	$push11=, $8, $pop53
	i32.const	$push52=, -4
	i32.and 	$push12=, $pop11, $pop52
	tee_local	$push51=, $5=, $pop12
	i32.add 	$push13=, $10, $pop51
	i32.store	$discard=, 60($16), $pop13
	i32.load	$push14=, 0($5)
	i32.store	$discard=, 40($16):p2align=3, $pop14
	i32.const	$push15=, 7
	i32.add 	$push16=, $5, $pop15
	i32.const	$push50=, -4
	i32.and 	$push17=, $pop16, $pop50
	tee_local	$push49=, $5=, $pop17
	i32.add 	$push18=, $10, $pop49
	i32.store	$discard=, 60($16), $pop18
	i32.load	$push19=, 0($5)
	i32.store	$discard=, 44($16), $pop19
	i32.const	$push48=, 7
	i32.add 	$push20=, $5, $pop48
	i32.const	$push47=, -4
	i32.and 	$push21=, $pop20, $pop47
	tee_local	$push46=, $5=, $pop21
	i32.add 	$push22=, $10, $pop46
	i32.store	$discard=, 60($16), $pop22
	i32.load	$push23=, 0($5)
	i32.store	$discard=, 48($16):p2align=4, $pop23
	i32.const	$push45=, 7
	i32.add 	$push24=, $5, $pop45
	i32.const	$push44=, -4
	i32.and 	$push25=, $pop24, $pop44
	tee_local	$push43=, $5=, $pop25
	i32.add 	$push26=, $10, $pop43
	i32.store	$discard=, 60($16), $pop26
	i32.load	$push27=, 0($5)
	i32.store	$discard=, 52($16), $pop27
	i32.const	$push42=, 7
	i32.add 	$push28=, $5, $pop42
	i32.const	$push41=, -4
	i32.and 	$push29=, $pop28, $pop41
	tee_local	$push40=, $5=, $pop29
	i32.add 	$push30=, $10, $pop40
	i32.store	$discard=, 60($16), $pop30
	i32.load	$push31=, 0($5)
	i32.store	$discard=, 56($16):p2align=3, $pop31
	i32.const	$push39=, 4
	i32.const	$15=, 16
	i32.add 	$15=, $16, $15
	i32.or  	$8=, $15, $pop39
	i32.const	$push33=, 12
	i32.or  	$6=, $16, $pop33
	i32.const	$9=, 0
	i32.const	$5=, 0
.LBB5_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label13:
	block
	i32.eq  	$push32=, $5, $9
	br_if   	0, $pop32       # 0: down to label15
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB5_1 Depth=1
	i32.store	$7=, 0($6), $5
	i32.const	$push62=, 8
	i32.or  	$push34=, $16, $pop62
	i32.store	$discard=, 0($pop34):p2align=3, $9
	i32.or  	$push35=, $16, $10
	i32.store	$discard=, 0($pop35), $7
	i32.const	$push61=, .L.str.5
	i32.store	$discard=, 0($16):p2align=4, $pop61
	i32.const	$push60=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop60, $16
	i32.const	$push59=, 0
	i32.const	$push58=, 0
	i32.load	$push36=, errors($pop58)
	i32.const	$push57=, 1
	i32.add 	$push37=, $pop36, $pop57
	i32.store	$discard=, errors($pop59), $pop37
.LBB5_3:                                # %for.inc.i
                                        #   in Loop: Header=BB5_1 Depth=1
	end_block                       # label15:
	i32.const	$push63=, 10
	i32.eq  	$push38=, $5, $pop63
	br_if   	1, $pop38       # 1: down to label14
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB5_1 Depth=1
	i32.load	$9=, 0($8)
	i32.const	$push64=, 1
	i32.add 	$5=, $5, $pop64
	i32.add 	$8=, $8, $10
	br      	0               # 0: up to label13
.LBB5_5:                                # %verify.exit
	end_loop                        # label14:
	i32.const	$13=, 64
	i32.add 	$16=, $16, $13
	i32.const	$13=, __stack_pointer
	i32.store	$16=, 0($13), $16
	return
	.endfunc
.Lfunc_end5:
	.size	varargs4, .Lfunc_end5-varargs4

	.section	.text.varargs5,"ax",@progbits
	.type	varargs5,@function
varargs5:                               # @varargs5
	.param  	i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 64
	i32.sub 	$16=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$16=, 0($12), $16
	i32.store	$discard=, 60($16), $6
	i32.load	$6=, 60($16)
	i32.const	$push52=, 8
	i32.const	$14=, 16
	i32.add 	$14=, $16, $14
	i32.or  	$push1=, $14, $pop52
	i64.const	$push2=, 12884901890
	i64.store	$discard=, 0($pop1), $pop2
	i32.const	$push4=, 3
	i32.add 	$push5=, $6, $pop4
	i32.const	$push6=, -4
	i32.and 	$push7=, $pop5, $pop6
	tee_local	$push51=, $6=, $pop7
	i32.const	$push50=, 4
	i32.add 	$push8=, $pop51, $pop50
	i32.store	$discard=, 60($16), $pop8
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($16):p2align=4, $pop0
	i64.const	$push3=, 21474836484
	i64.store	$discard=, 32($16):p2align=4, $pop3
	i32.load	$9=, 60($16)
	i32.load	$push9=, 0($6)
	i32.store	$discard=, 40($16):p2align=3, $pop9
	i32.const	$push49=, 3
	i32.add 	$push10=, $9, $pop49
	i32.const	$push48=, -4
	i32.and 	$push11=, $pop10, $pop48
	tee_local	$push47=, $6=, $pop11
	i32.const	$push46=, 4
	i32.add 	$push12=, $pop47, $pop46
	i32.store	$discard=, 60($16), $pop12
	i32.load	$push13=, 0($6)
	i32.store	$discard=, 44($16), $pop13
	i32.const	$push14=, 7
	i32.add 	$push15=, $6, $pop14
	i32.const	$push45=, -4
	i32.and 	$push16=, $pop15, $pop45
	tee_local	$push44=, $6=, $pop16
	i32.const	$push43=, 4
	i32.add 	$push17=, $pop44, $pop43
	i32.store	$discard=, 60($16), $pop17
	i32.load	$push18=, 0($6)
	i32.store	$discard=, 48($16):p2align=4, $pop18
	i32.const	$push42=, 7
	i32.add 	$push19=, $6, $pop42
	i32.const	$push41=, -4
	i32.and 	$push20=, $pop19, $pop41
	tee_local	$push40=, $6=, $pop20
	i32.const	$push39=, 4
	i32.add 	$push21=, $pop40, $pop39
	i32.store	$discard=, 60($16), $pop21
	i32.load	$push22=, 0($6)
	i32.store	$discard=, 52($16), $pop22
	i32.const	$push38=, 7
	i32.add 	$push23=, $6, $pop38
	i32.const	$push37=, -4
	i32.and 	$push24=, $pop23, $pop37
	tee_local	$push36=, $6=, $pop24
	i32.const	$push35=, 4
	i32.add 	$push25=, $pop36, $pop35
	i32.store	$discard=, 60($16), $pop25
	i32.load	$push26=, 0($6)
	i32.store	$discard=, 56($16):p2align=3, $pop26
	i32.const	$push28=, 12
	i32.or  	$7=, $16, $pop28
	i32.const	$push34=, 4
	i32.const	$15=, 16
	i32.add 	$15=, $16, $15
	i32.or  	$9=, $15, $pop34
	i32.const	$10=, 0
	i32.const	$6=, 0
.LBB6_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label16:
	block
	i32.eq  	$push27=, $6, $10
	br_if   	0, $pop27       # 0: down to label18
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB6_1 Depth=1
	i32.store	$8=, 0($7), $6
	i32.const	$push59=, 8
	i32.or  	$push29=, $16, $pop59
	i32.store	$discard=, 0($pop29):p2align=3, $10
	i32.const	$push58=, 4
	i32.or  	$push30=, $16, $pop58
	i32.store	$discard=, 0($pop30), $8
	i32.const	$push57=, .L.str.6
	i32.store	$discard=, 0($16):p2align=4, $pop57
	i32.const	$push56=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop56, $16
	i32.const	$push55=, 0
	i32.const	$push54=, 0
	i32.load	$push31=, errors($pop54)
	i32.const	$push53=, 1
	i32.add 	$push32=, $pop31, $pop53
	i32.store	$discard=, errors($pop55), $pop32
.LBB6_3:                                # %for.inc.i
                                        #   in Loop: Header=BB6_1 Depth=1
	end_block                       # label18:
	i32.const	$push60=, 10
	i32.eq  	$push33=, $6, $pop60
	br_if   	1, $pop33       # 1: down to label17
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB6_1 Depth=1
	i32.load	$10=, 0($9)
	i32.const	$push62=, 1
	i32.add 	$6=, $6, $pop62
	i32.const	$push61=, 4
	i32.add 	$9=, $9, $pop61
	br      	0               # 0: up to label16
.LBB6_5:                                # %verify.exit
	end_loop                        # label17:
	i32.const	$13=, 64
	i32.add 	$16=, $16, $13
	i32.const	$13=, __stack_pointer
	i32.store	$16=, 0($13), $16
	return
	.endfunc
.Lfunc_end6:
	.size	varargs5, .Lfunc_end6-varargs5

	.section	.text.varargs6,"ax",@progbits
	.type	varargs6,@function
varargs6:                               # @varargs6
	.param  	i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$12=, __stack_pointer
	i32.load	$12=, 0($12)
	i32.const	$13=, 64
	i32.sub 	$17=, $12, $13
	i32.const	$13=, __stack_pointer
	i32.store	$17=, 0($13), $17
	i32.store	$discard=, 60($17), $7
	i32.const	$push45=, 8
	i32.const	$15=, 16
	i32.add 	$15=, $17, $15
	i32.or  	$push1=, $15, $pop45
	i64.const	$push2=, 12884901890
	i64.store	$discard=, 0($pop1), $pop2
	i32.load	$7=, 60($17)
	i32.const	$push4=, 6
	i32.store	$discard=, 40($17):p2align=3, $pop4
	i32.const	$push5=, 3
	i32.add 	$push6=, $7, $pop5
	i32.const	$push7=, -4
	i32.and 	$push8=, $pop6, $pop7
	tee_local	$push44=, $7=, $pop8
	i32.const	$push43=, 4
	i32.add 	$push9=, $pop44, $pop43
	i32.store	$discard=, 60($17), $pop9
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($17):p2align=4, $pop0
	i64.const	$push3=, 21474836484
	i64.store	$discard=, 32($17):p2align=4, $pop3
	i32.load	$10=, 60($17)
	i32.load	$push10=, 0($7)
	i32.store	$discard=, 44($17), $pop10
	i32.const	$push42=, 3
	i32.add 	$push11=, $10, $pop42
	i32.const	$push41=, -4
	i32.and 	$push12=, $pop11, $pop41
	tee_local	$push40=, $7=, $pop12
	i32.const	$push39=, 4
	i32.add 	$push13=, $pop40, $pop39
	i32.store	$discard=, 60($17), $pop13
	i32.load	$push14=, 0($7)
	i32.store	$discard=, 48($17):p2align=4, $pop14
	i32.const	$push15=, 7
	i32.add 	$push16=, $7, $pop15
	i32.const	$push38=, -4
	i32.and 	$push17=, $pop16, $pop38
	tee_local	$push37=, $7=, $pop17
	i32.const	$push36=, 4
	i32.add 	$push18=, $pop37, $pop36
	i32.store	$discard=, 60($17), $pop18
	i32.load	$push19=, 0($7)
	i32.store	$discard=, 52($17), $pop19
	i32.const	$push35=, 7
	i32.add 	$push20=, $7, $pop35
	i32.const	$push34=, -4
	i32.and 	$push21=, $pop20, $pop34
	tee_local	$push33=, $7=, $pop21
	i32.const	$push32=, 4
	i32.add 	$push22=, $pop33, $pop32
	i32.store	$discard=, 60($17), $pop22
	i32.load	$push23=, 0($7)
	i32.store	$discard=, 56($17):p2align=3, $pop23
	i32.const	$push25=, 12
	i32.or  	$8=, $17, $pop25
	i32.const	$push31=, 4
	i32.const	$16=, 16
	i32.add 	$16=, $17, $16
	i32.or  	$10=, $16, $pop31
	i32.const	$11=, 0
	i32.const	$7=, 0
.LBB7_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label19:
	block
	i32.eq  	$push24=, $7, $11
	br_if   	0, $pop24       # 0: down to label21
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB7_1 Depth=1
	i32.store	$9=, 0($8), $7
	i32.const	$push52=, 8
	i32.or  	$push26=, $17, $pop52
	i32.store	$discard=, 0($pop26):p2align=3, $11
	i32.const	$push51=, 4
	i32.or  	$push27=, $17, $pop51
	i32.store	$discard=, 0($pop27), $9
	i32.const	$push50=, .L.str.7
	i32.store	$discard=, 0($17):p2align=4, $pop50
	i32.const	$push49=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop49, $17
	i32.const	$push48=, 0
	i32.const	$push47=, 0
	i32.load	$push28=, errors($pop47)
	i32.const	$push46=, 1
	i32.add 	$push29=, $pop28, $pop46
	i32.store	$discard=, errors($pop48), $pop29
.LBB7_3:                                # %for.inc.i
                                        #   in Loop: Header=BB7_1 Depth=1
	end_block                       # label21:
	i32.const	$push53=, 10
	i32.eq  	$push30=, $7, $pop53
	br_if   	1, $pop30       # 1: down to label20
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB7_1 Depth=1
	i32.load	$11=, 0($10)
	i32.const	$push55=, 1
	i32.add 	$7=, $7, $pop55
	i32.const	$push54=, 4
	i32.add 	$10=, $10, $pop54
	br      	0               # 0: up to label19
.LBB7_5:                                # %verify.exit
	end_loop                        # label20:
	i32.const	$14=, 64
	i32.add 	$17=, $17, $14
	i32.const	$14=, __stack_pointer
	i32.store	$17=, 0($14), $17
	return
	.endfunc
.Lfunc_end7:
	.size	varargs6, .Lfunc_end7-varargs6

	.section	.text.varargs7,"ax",@progbits
	.type	varargs7,@function
varargs7:                               # @varargs7
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$13=, __stack_pointer
	i32.load	$13=, 0($13)
	i32.const	$14=, 64
	i32.sub 	$18=, $13, $14
	i32.const	$14=, __stack_pointer
	i32.store	$18=, 0($14), $18
	i32.store	$discard=, 60($18), $8
	i32.load	$8=, 60($18)
	i32.const	$push37=, 8
	i32.const	$16=, 16
	i32.add 	$16=, $18, $16
	i32.or  	$push1=, $16, $pop37
	i64.const	$push2=, 12884901890
	i64.store	$discard=, 0($pop1), $pop2
	i32.const	$push5=, 3
	i32.add 	$push6=, $8, $pop5
	i32.const	$push7=, -4
	i32.and 	$push8=, $pop6, $pop7
	tee_local	$push36=, $8=, $pop8
	i32.const	$push35=, 4
	i32.add 	$push9=, $pop36, $pop35
	i32.store	$discard=, 60($18), $pop9
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($18):p2align=4, $pop0
	i64.const	$push3=, 21474836484
	i64.store	$discard=, 32($18):p2align=4, $pop3
	i64.const	$push4=, 30064771078
	i64.store	$discard=, 40($18), $pop4
	i32.load	$11=, 60($18)
	i32.load	$push10=, 0($8)
	i32.store	$discard=, 48($18):p2align=4, $pop10
	i32.const	$push34=, 3
	i32.add 	$push11=, $11, $pop34
	i32.const	$push33=, -4
	i32.and 	$push12=, $pop11, $pop33
	tee_local	$push32=, $8=, $pop12
	i32.const	$push31=, 4
	i32.add 	$push13=, $pop32, $pop31
	i32.store	$discard=, 60($18), $pop13
	i32.load	$push14=, 0($8)
	i32.store	$discard=, 52($18), $pop14
	i32.const	$push15=, 7
	i32.add 	$push16=, $8, $pop15
	i32.const	$push30=, -4
	i32.and 	$push17=, $pop16, $pop30
	tee_local	$push29=, $8=, $pop17
	i32.const	$push28=, 4
	i32.add 	$push18=, $pop29, $pop28
	i32.store	$discard=, 60($18), $pop18
	i32.load	$push19=, 0($8)
	i32.store	$discard=, 56($18):p2align=3, $pop19
	i32.const	$push21=, 12
	i32.or  	$9=, $18, $pop21
	i32.const	$push27=, 4
	i32.const	$17=, 16
	i32.add 	$17=, $18, $17
	i32.or  	$11=, $17, $pop27
	i32.const	$12=, 0
	i32.const	$8=, 0
.LBB8_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label22:
	block
	i32.eq  	$push20=, $8, $12
	br_if   	0, $pop20       # 0: down to label24
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB8_1 Depth=1
	i32.store	$10=, 0($9), $8
	i32.const	$push44=, 8
	i32.or  	$push22=, $18, $pop44
	i32.store	$discard=, 0($pop22):p2align=3, $12
	i32.const	$push43=, 4
	i32.or  	$push23=, $18, $pop43
	i32.store	$discard=, 0($pop23), $10
	i32.const	$push42=, .L.str.8
	i32.store	$discard=, 0($18):p2align=4, $pop42
	i32.const	$push41=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop41, $18
	i32.const	$push40=, 0
	i32.const	$push39=, 0
	i32.load	$push24=, errors($pop39)
	i32.const	$push38=, 1
	i32.add 	$push25=, $pop24, $pop38
	i32.store	$discard=, errors($pop40), $pop25
.LBB8_3:                                # %for.inc.i
                                        #   in Loop: Header=BB8_1 Depth=1
	end_block                       # label24:
	i32.const	$push45=, 10
	i32.eq  	$push26=, $8, $pop45
	br_if   	1, $pop26       # 1: down to label23
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB8_1 Depth=1
	i32.load	$12=, 0($11)
	i32.const	$push47=, 1
	i32.add 	$8=, $8, $pop47
	i32.const	$push46=, 4
	i32.add 	$11=, $11, $pop46
	br      	0               # 0: up to label22
.LBB8_5:                                # %verify.exit
	end_loop                        # label23:
	i32.const	$15=, 64
	i32.add 	$18=, $18, $15
	i32.const	$15=, __stack_pointer
	i32.store	$18=, 0($15), $18
	return
	.endfunc
.Lfunc_end8:
	.size	varargs7, .Lfunc_end8-varargs7

	.section	.text.varargs8,"ax",@progbits
	.type	varargs8,@function
varargs8:                               # @varargs8
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$15=, __stack_pointer
	i32.load	$15=, 0($15)
	i32.const	$16=, 64
	i32.sub 	$20=, $15, $16
	i32.const	$16=, __stack_pointer
	i32.store	$20=, 0($16), $20
	i32.store	$discard=, 60($20), $9
	i32.load	$9=, 60($20)
	i32.const	$push1=, 8
	i32.const	$18=, 16
	i32.add 	$18=, $20, $18
	i32.or  	$push2=, $18, $pop1
	i64.const	$push3=, 12884901890
	i64.store	$discard=, 0($pop2), $pop3
	i32.const	$push6=, 3
	i32.add 	$push7=, $9, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push30=, $9=, $pop9
	i32.const	$push29=, 4
	i32.add 	$push10=, $pop30, $pop29
	i32.store	$discard=, 60($20), $pop10
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($20):p2align=4, $pop0
	i64.const	$push4=, 21474836484
	i64.store	$discard=, 32($20):p2align=4, $pop4
	i64.const	$push5=, 30064771078
	i64.store	$discard=, 40($20), $pop5
	i32.const	$push28=, 8
	i32.store	$10=, 48($20):p2align=4, $pop28
	i32.load	$13=, 60($20)
	i32.load	$push11=, 0($9)
	i32.store	$discard=, 52($20), $pop11
	i32.const	$push27=, 3
	i32.add 	$push12=, $13, $pop27
	i32.const	$push26=, -4
	i32.and 	$push13=, $pop12, $pop26
	tee_local	$push25=, $9=, $pop13
	i32.const	$push24=, 4
	i32.add 	$push14=, $pop25, $pop24
	i32.store	$discard=, 60($20), $pop14
	i32.load	$push15=, 0($9)
	i32.store	$discard=, 56($20):p2align=3, $pop15
	i32.const	$push17=, 12
	i32.or  	$11=, $20, $pop17
	i32.const	$push23=, 4
	i32.const	$19=, 16
	i32.add 	$19=, $20, $19
	i32.or  	$13=, $19, $pop23
	i32.const	$14=, 0
	i32.const	$9=, 0
.LBB9_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label25:
	block
	i32.eq  	$push16=, $9, $14
	br_if   	0, $pop16       # 0: down to label27
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB9_1 Depth=1
	i32.store	$12=, 0($11), $9
	i32.or  	$push18=, $20, $10
	i32.store	$discard=, 0($pop18):p2align=3, $14
	i32.const	$push36=, 4
	i32.or  	$push19=, $20, $pop36
	i32.store	$discard=, 0($pop19), $12
	i32.const	$push35=, .L.str.9
	i32.store	$discard=, 0($20):p2align=4, $pop35
	i32.const	$push34=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop34, $20
	i32.const	$push33=, 0
	i32.const	$push32=, 0
	i32.load	$push20=, errors($pop32)
	i32.const	$push31=, 1
	i32.add 	$push21=, $pop20, $pop31
	i32.store	$discard=, errors($pop33), $pop21
.LBB9_3:                                # %for.inc.i
                                        #   in Loop: Header=BB9_1 Depth=1
	end_block                       # label27:
	i32.const	$push37=, 10
	i32.eq  	$push22=, $9, $pop37
	br_if   	1, $pop22       # 1: down to label26
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB9_1 Depth=1
	i32.load	$14=, 0($13)
	i32.const	$push39=, 1
	i32.add 	$9=, $9, $pop39
	i32.const	$push38=, 4
	i32.add 	$13=, $13, $pop38
	br      	0               # 0: up to label25
.LBB9_5:                                # %verify.exit
	end_loop                        # label26:
	i32.const	$17=, 64
	i32.add 	$20=, $20, $17
	i32.const	$17=, __stack_pointer
	i32.store	$20=, 0($17), $20
	return
	.endfunc
.Lfunc_end9:
	.size	varargs8, .Lfunc_end9-varargs8

	.section	.text.varargs9,"ax",@progbits
	.type	varargs9,@function
varargs9:                               # @varargs9
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$15=, __stack_pointer
	i32.load	$15=, 0($15)
	i32.const	$16=, 64
	i32.sub 	$20=, $15, $16
	i32.const	$16=, __stack_pointer
	i32.store	$20=, 0($16), $20
	i32.store	$discard=, 60($20), $10
	i32.load	$10=, 60($20)
	i32.const	$push22=, 8
	i32.const	$18=, 16
	i32.add 	$18=, $20, $18
	i32.or  	$push1=, $18, $pop22
	i64.const	$push2=, 12884901890
	i64.store	$discard=, 0($pop1), $pop2
	i32.const	$push6=, 3
	i32.add 	$push7=, $10, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push21=, $10=, $pop9
	i32.const	$push20=, 4
	i32.add 	$push10=, $pop21, $pop20
	i32.store	$discard=, 60($20), $pop10
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($20):p2align=4, $pop0
	i64.const	$push3=, 21474836484
	i64.store	$discard=, 32($20):p2align=4, $pop3
	i64.const	$push4=, 30064771078
	i64.store	$discard=, 40($20), $pop4
	i64.const	$push5=, 38654705672
	i64.store	$discard=, 48($20):p2align=4, $pop5
	i32.load	$push11=, 0($10)
	i32.store	$discard=, 56($20):p2align=3, $pop11
	i32.const	$push13=, 12
	i32.or  	$11=, $20, $pop13
	i32.const	$push19=, 4
	i32.const	$19=, 16
	i32.add 	$19=, $20, $19
	i32.or  	$13=, $19, $pop19
	i32.const	$14=, 0
	i32.const	$10=, 0
.LBB10_1:                               # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label28:
	block
	i32.eq  	$push12=, $10, $14
	br_if   	0, $pop12       # 0: down to label30
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB10_1 Depth=1
	i32.store	$12=, 0($11), $10
	i32.const	$push29=, 8
	i32.or  	$push14=, $20, $pop29
	i32.store	$discard=, 0($pop14):p2align=3, $14
	i32.const	$push28=, 4
	i32.or  	$push15=, $20, $pop28
	i32.store	$discard=, 0($pop15), $12
	i32.const	$push27=, .L.str.10
	i32.store	$discard=, 0($20):p2align=4, $pop27
	i32.const	$push26=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop26, $20
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	i32.load	$push16=, errors($pop24)
	i32.const	$push23=, 1
	i32.add 	$push17=, $pop16, $pop23
	i32.store	$discard=, errors($pop25), $pop17
.LBB10_3:                               # %for.inc.i
                                        #   in Loop: Header=BB10_1 Depth=1
	end_block                       # label30:
	i32.const	$push30=, 10
	i32.eq  	$push18=, $10, $pop30
	br_if   	1, $pop18       # 1: down to label29
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB10_1 Depth=1
	i32.load	$14=, 0($13)
	i32.const	$push32=, 1
	i32.add 	$10=, $10, $pop32
	i32.const	$push31=, 4
	i32.add 	$13=, $13, $pop31
	br      	0               # 0: up to label28
.LBB10_5:                               # %verify.exit
	end_loop                        # label29:
	i32.const	$17=, 64
	i32.add 	$20=, $20, $17
	i32.const	$17=, __stack_pointer
	i32.store	$20=, 0($17), $20
	return
	.endfunc
.Lfunc_end10:
	.size	varargs9, .Lfunc_end10-varargs9

	.type	errors,@object          # @errors
	.lcomm	errors,4,2
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"varargs0"
	.size	.L.str, 9

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	" %s: n[%d] = %d expected %d\n"
	.size	.L.str.1, 29

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"varargs1"
	.size	.L.str.2, 9

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.asciz	"varargs2"
	.size	.L.str.3, 9

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"varargs3"
	.size	.L.str.4, 9

	.type	.L.str.5,@object        # @.str.5
.L.str.5:
	.asciz	"varargs4"
	.size	.L.str.5, 9

	.type	.L.str.6,@object        # @.str.6
.L.str.6:
	.asciz	"varargs5"
	.size	.L.str.6, 9

	.type	.L.str.7,@object        # @.str.7
.L.str.7:
	.asciz	"varargs6"
	.size	.L.str.7, 9

	.type	.L.str.8,@object        # @.str.8
.L.str.8:
	.asciz	"varargs7"
	.size	.L.str.8, 9

	.type	.L.str.9,@object        # @.str.9
.L.str.9:
	.asciz	"varargs8"
	.size	.L.str.9, 9

	.type	.L.str.10,@object       # @.str.10
.L.str.10:
	.asciz	"varargs9"
	.size	.L.str.10, 9


	.ident	"clang version 3.9.0 "
