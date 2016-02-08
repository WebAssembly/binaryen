	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-24.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64, i64, i64, i32, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$49=, __stack_pointer
	i32.load	$49=, 0($49)
	i32.const	$50=, 48
	i32.sub 	$51=, $49, $50
	i32.const	$50=, __stack_pointer
	i32.store	$51=, 0($50), $51
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 40
	i32.sub 	$51=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$51=, 0($10), $51
	i64.const	$push0=, 8589934593
	i64.store	$discard=, 0($51):p2align=2, $pop0
	i32.const	$push1=, 32
	i32.add 	$0=, $51, $pop1
	i64.const	$push2=, 42949672969
	i64.store	$1=, 0($0):p2align=2, $pop2
	i32.const	$push3=, 24
	i32.add 	$0=, $51, $pop3
	i64.const	$push4=, 34359738375
	i64.store	$2=, 0($0):p2align=2, $pop4
	i32.const	$push5=, 16
	i32.add 	$0=, $51, $pop5
	i64.const	$push6=, 25769803781
	i64.store	$3=, 0($0):p2align=2, $pop6
	i32.const	$push7=, 8
	i32.add 	$0=, $51, $pop7
	i64.const	$push8=, 17179869187
	i64.store	$4=, 0($0):p2align=2, $pop8
	call    	varargs0@FUNCTION, $0
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 40
	i32.add 	$51=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$51=, 0($12), $51
	i32.const	$13=, __stack_pointer
	i32.load	$13=, 0($13)
	i32.const	$14=, 36
	i32.sub 	$51=, $13, $14
	i32.const	$14=, __stack_pointer
	i32.store	$51=, 0($14), $51
	i64.const	$push9=, 12884901890
	i64.store	$discard=, 0($51):p2align=2, $pop9
	i32.const	$push31=, 32
	i32.add 	$0=, $51, $pop31
	i32.const	$push10=, 10
	i32.store	$0=, 0($0), $pop10
	i32.const	$push30=, 24
	i32.add 	$5=, $51, $pop30
	i64.const	$push11=, 38654705672
	i64.store	$6=, 0($5):p2align=2, $pop11
	i32.const	$push29=, 16
	i32.add 	$5=, $51, $pop29
	i64.const	$push12=, 30064771078
	i64.store	$7=, 0($5):p2align=2, $pop12
	i32.const	$push28=, 8
	i32.add 	$5=, $51, $pop28
	i64.const	$push13=, 21474836484
	i64.store	$8=, 0($5):p2align=2, $pop13
	call    	varargs1@FUNCTION, $0, $0
	i32.const	$15=, __stack_pointer
	i32.load	$15=, 0($15)
	i32.const	$16=, 36
	i32.add 	$51=, $15, $16
	i32.const	$16=, __stack_pointer
	i32.store	$51=, 0($16), $51
	i32.const	$17=, __stack_pointer
	i32.load	$17=, 0($17)
	i32.const	$18=, 32
	i32.sub 	$51=, $17, $18
	i32.const	$18=, __stack_pointer
	i32.store	$51=, 0($18), $51
	i64.store	$discard=, 0($51):p2align=2, $4
	i32.const	$push27=, 24
	i32.add 	$5=, $51, $pop27
	i64.store	$discard=, 0($5):p2align=2, $1
	i32.const	$push26=, 16
	i32.add 	$5=, $51, $pop26
	i64.store	$discard=, 0($5):p2align=2, $2
	i32.const	$push25=, 8
	i32.add 	$5=, $51, $pop25
	i64.store	$discard=, 0($5):p2align=2, $3
	call    	varargs2@FUNCTION, $0, $0, $0
	i32.const	$19=, __stack_pointer
	i32.load	$19=, 0($19)
	i32.const	$20=, 32
	i32.add 	$51=, $19, $20
	i32.const	$20=, __stack_pointer
	i32.store	$51=, 0($20), $51
	i32.const	$21=, __stack_pointer
	i32.load	$21=, 0($21)
	i32.const	$22=, 28
	i32.sub 	$51=, $21, $22
	i32.const	$22=, __stack_pointer
	i32.store	$51=, 0($22), $51
	i64.store	$discard=, 0($51):p2align=2, $8
	i32.const	$push24=, 24
	i32.add 	$5=, $51, $pop24
	i32.store	$discard=, 0($5), $0
	i32.const	$push23=, 16
	i32.add 	$5=, $51, $pop23
	i64.store	$4=, 0($5):p2align=2, $6
	i32.const	$push22=, 8
	i32.add 	$5=, $51, $pop22
	i64.store	$6=, 0($5):p2align=2, $7
	call    	varargs3@FUNCTION, $0, $0, $0, $0
	i32.const	$23=, __stack_pointer
	i32.load	$23=, 0($23)
	i32.const	$24=, 28
	i32.add 	$51=, $23, $24
	i32.const	$24=, __stack_pointer
	i32.store	$51=, 0($24), $51
	i32.const	$25=, __stack_pointer
	i32.load	$25=, 0($25)
	i32.const	$26=, 24
	i32.sub 	$51=, $25, $26
	i32.const	$26=, __stack_pointer
	i32.store	$51=, 0($26), $51
	i64.store	$discard=, 0($51):p2align=2, $3
	i32.const	$push21=, 16
	i32.add 	$5=, $51, $pop21
	i64.store	$discard=, 0($5):p2align=2, $1
	i32.const	$push20=, 8
	i32.add 	$5=, $51, $pop20
	i64.store	$discard=, 0($5):p2align=2, $2
	call    	varargs4@FUNCTION, $0, $0, $0, $0, $0
	i32.const	$27=, __stack_pointer
	i32.load	$27=, 0($27)
	i32.const	$28=, 24
	i32.add 	$51=, $27, $28
	i32.const	$28=, __stack_pointer
	i32.store	$51=, 0($28), $51
	i32.const	$29=, __stack_pointer
	i32.load	$29=, 0($29)
	i32.const	$30=, 20
	i32.sub 	$51=, $29, $30
	i32.const	$30=, __stack_pointer
	i32.store	$51=, 0($30), $51
	i64.store	$discard=, 0($51):p2align=2, $6
	i32.const	$push19=, 16
	i32.add 	$5=, $51, $pop19
	i32.store	$discard=, 0($5), $0
	i32.const	$push18=, 8
	i32.add 	$5=, $51, $pop18
	i64.store	$3=, 0($5):p2align=2, $4
	call    	varargs5@FUNCTION, $0, $0, $0, $0, $0, $0
	i32.const	$31=, __stack_pointer
	i32.load	$31=, 0($31)
	i32.const	$32=, 20
	i32.add 	$51=, $31, $32
	i32.const	$32=, __stack_pointer
	i32.store	$51=, 0($32), $51
	i32.const	$33=, __stack_pointer
	i32.load	$33=, 0($33)
	i32.const	$34=, 16
	i32.sub 	$51=, $33, $34
	i32.const	$34=, __stack_pointer
	i32.store	$51=, 0($34), $51
	i64.store	$discard=, 0($51):p2align=2, $2
	i32.const	$push17=, 8
	i32.add 	$5=, $51, $pop17
	i64.store	$discard=, 0($5):p2align=2, $1
	call    	varargs6@FUNCTION, $0, $0, $0, $0, $0, $0, $0
	i32.const	$35=, __stack_pointer
	i32.load	$35=, 0($35)
	i32.const	$36=, 16
	i32.add 	$51=, $35, $36
	i32.const	$36=, __stack_pointer
	i32.store	$51=, 0($36), $51
	i32.const	$37=, __stack_pointer
	i32.load	$37=, 0($37)
	i32.const	$38=, 12
	i32.sub 	$51=, $37, $38
	i32.const	$38=, __stack_pointer
	i32.store	$51=, 0($38), $51
	i64.store	$discard=, 0($51):p2align=2, $3
	i32.const	$push16=, 8
	i32.add 	$5=, $51, $pop16
	i32.store	$discard=, 0($5), $0
	call    	varargs7@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0
	i32.const	$39=, __stack_pointer
	i32.load	$39=, 0($39)
	i32.const	$40=, 12
	i32.add 	$51=, $39, $40
	i32.const	$40=, __stack_pointer
	i32.store	$51=, 0($40), $51
	i32.const	$41=, __stack_pointer
	i32.load	$41=, 0($41)
	i32.const	$42=, 8
	i32.sub 	$51=, $41, $42
	i32.const	$42=, __stack_pointer
	i32.store	$51=, 0($42), $51
	i64.store	$discard=, 0($51):p2align=2, $1
	call    	varargs8@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0
	i32.const	$43=, __stack_pointer
	i32.load	$43=, 0($43)
	i32.const	$44=, 8
	i32.add 	$51=, $43, $44
	i32.const	$44=, __stack_pointer
	i32.store	$51=, 0($44), $51
	i32.const	$45=, __stack_pointer
	i32.load	$45=, 0($45)
	i32.const	$46=, 4
	i32.sub 	$51=, $45, $46
	i32.const	$46=, __stack_pointer
	i32.store	$51=, 0($46), $51
	i32.store	$discard=, 0($51), $0
	call    	varargs9@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0
	i32.const	$47=, __stack_pointer
	i32.load	$47=, 0($47)
	i32.const	$48=, 4
	i32.add 	$51=, $47, $48
	i32.const	$48=, __stack_pointer
	i32.store	$51=, 0($48), $51
	block
	i32.const	$push15=, 0
	i32.load	$push14=, errors($pop15)
	br_if   	0, $pop14       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push32=, 0
	call    	exit@FUNCTION, $pop32
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
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 64
	i32.sub 	$17=, $11, $12
	copy_local	$18=, $17
	i32.const	$12=, __stack_pointer
	i32.store	$17=, 0($12), $17
	i32.store	$discard=, 60($17), $18
	i32.load	$push1=, 60($17)
	i32.const	$push2=, 3
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -4
	i32.and 	$push5=, $pop3, $pop4
	tee_local	$push92=, $5=, $pop5
	i32.const	$push91=, 4
	i32.add 	$push6=, $pop92, $pop91
	i32.store	$discard=, 60($17), $pop6
	i32.const	$push0=, 0
	i32.store	$1=, 16($17):p2align=4, $pop0
	i32.const	$push90=, 4
	i32.const	$14=, 16
	i32.add 	$14=, $17, $14
	i32.or  	$push51=, $14, $pop90
	tee_local	$push89=, $6=, $pop51
	i32.load	$push7=, 0($5)
	i32.store	$discard=, 0($pop89), $pop7
	i32.const	$push8=, 7
	i32.add 	$push9=, $5, $pop8
	i32.const	$push88=, -4
	i32.and 	$push10=, $pop9, $pop88
	tee_local	$push87=, $5=, $pop10
	i32.const	$push86=, 4
	i32.add 	$push11=, $pop87, $pop86
	i32.store	$discard=, 60($17), $pop11
	i32.const	$push85=, 8
	i32.const	$15=, 16
	i32.add 	$15=, $17, $15
	i32.or  	$push13=, $15, $pop85
	i32.load	$push12=, 0($5)
	i32.store	$discard=, 0($pop13):p2align=3, $pop12
	i32.const	$push84=, 7
	i32.add 	$push14=, $5, $pop84
	i32.const	$push83=, -4
	i32.and 	$push15=, $pop14, $pop83
	tee_local	$push82=, $5=, $pop15
	i32.const	$push81=, 4
	i32.add 	$push16=, $pop82, $pop81
	i32.store	$discard=, 60($17), $pop16
	i32.const	$push80=, 12
	i32.const	$16=, 16
	i32.add 	$16=, $17, $16
	i32.or  	$push18=, $16, $pop80
	i32.load	$push17=, 0($5)
	i32.store	$discard=, 0($pop18), $pop17
	i32.const	$push79=, 7
	i32.add 	$push19=, $5, $pop79
	i32.const	$push78=, -4
	i32.and 	$push20=, $pop19, $pop78
	tee_local	$push77=, $5=, $pop20
	i32.const	$push76=, 4
	i32.add 	$push21=, $pop77, $pop76
	i32.store	$discard=, 60($17), $pop21
	i32.load	$push22=, 0($5)
	i32.store	$discard=, 32($17):p2align=4, $pop22
	i32.const	$push75=, 7
	i32.add 	$push23=, $5, $pop75
	i32.const	$push74=, -4
	i32.and 	$push24=, $pop23, $pop74
	tee_local	$push73=, $5=, $pop24
	i32.const	$push72=, 4
	i32.add 	$push25=, $pop73, $pop72
	i32.store	$discard=, 60($17), $pop25
	i32.load	$push26=, 0($5)
	i32.store	$discard=, 36($17), $pop26
	i32.const	$push71=, 7
	i32.add 	$push27=, $5, $pop71
	i32.const	$push70=, -4
	i32.and 	$push28=, $pop27, $pop70
	tee_local	$push69=, $5=, $pop28
	i32.const	$push68=, 4
	i32.add 	$push29=, $pop69, $pop68
	i32.store	$discard=, 60($17), $pop29
	i32.load	$push30=, 0($5)
	i32.store	$discard=, 40($17):p2align=3, $pop30
	i32.const	$push67=, 7
	i32.add 	$push31=, $5, $pop67
	i32.const	$push66=, -4
	i32.and 	$push32=, $pop31, $pop66
	tee_local	$push65=, $5=, $pop32
	i32.const	$push64=, 4
	i32.add 	$push33=, $pop65, $pop64
	i32.store	$discard=, 60($17), $pop33
	i32.load	$push34=, 0($5)
	i32.store	$discard=, 44($17), $pop34
	i32.const	$push63=, 7
	i32.add 	$push35=, $5, $pop63
	i32.const	$push62=, -4
	i32.and 	$push36=, $pop35, $pop62
	tee_local	$push61=, $5=, $pop36
	i32.const	$push60=, 4
	i32.add 	$push37=, $pop61, $pop60
	i32.store	$discard=, 60($17), $pop37
	i32.load	$push38=, 0($5)
	i32.store	$discard=, 48($17):p2align=4, $pop38
	i32.const	$push59=, 7
	i32.add 	$push39=, $5, $pop59
	i32.const	$push58=, -4
	i32.and 	$push40=, $pop39, $pop58
	tee_local	$push57=, $5=, $pop40
	i32.const	$push56=, 4
	i32.add 	$push41=, $pop57, $pop56
	i32.store	$discard=, 60($17), $pop41
	i32.load	$push42=, 0($5)
	i32.store	$discard=, 52($17), $pop42
	i32.const	$push55=, 7
	i32.add 	$push43=, $5, $pop55
	i32.const	$push54=, -4
	i32.and 	$push44=, $pop43, $pop54
	tee_local	$push53=, $5=, $pop44
	i32.const	$push52=, 4
	i32.add 	$push45=, $pop53, $pop52
	i32.store	$discard=, 60($17), $pop45
	i32.load	$push46=, 0($5)
	i32.store	$discard=, 56($17):p2align=3, $pop46
	copy_local	$4=, $1
	copy_local	$5=, $1
.LBB1_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	block
	i32.eq  	$push47=, $5, $4
	br_if   	0, $pop47       # 0: down to label3
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 16
	i32.sub 	$17=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$17=, 0($8), $17
	i32.const	$push98=, .L.str
	i32.store	$discard=, 0($17), $pop98
	i32.const	$push97=, 12
	i32.add 	$2=, $17, $pop97
	i32.store	$2=, 0($2), $5
	i32.const	$push96=, 8
	i32.add 	$3=, $17, $pop96
	i32.store	$discard=, 0($3), $4
	i32.const	$push95=, 4
	i32.add 	$4=, $17, $pop95
	i32.store	$discard=, 0($4), $2
	i32.const	$push94=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop94
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 16
	i32.add 	$17=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$17=, 0($10), $17
	i32.load	$push48=, errors($1)
	i32.const	$push93=, 1
	i32.add 	$push49=, $pop48, $pop93
	i32.store	$discard=, errors($1), $pop49
.LBB1_3:                                # %for.inc.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.const	$push99=, 10
	i32.eq  	$push50=, $5, $pop99
	br_if   	1, $pop50       # 1: down to label2
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$4=, 0($6)
	i32.const	$push101=, 1
	i32.add 	$5=, $5, $pop101
	i32.const	$push100=, 4
	i32.add 	$6=, $6, $pop100
	br      	0               # 0: up to label1
.LBB1_5:                                # %verify.exit
	end_loop                        # label2:
	i32.const	$13=, 64
	i32.add 	$17=, $18, $13
	i32.const	$13=, __stack_pointer
	i32.store	$17=, 0($13), $17
	return
	.endfunc
.Lfunc_end1:
	.size	varargs0, .Lfunc_end1-varargs0

	.section	.text.varargs1,"ax",@progbits
	.type	varargs1,@function
varargs1:                               # @varargs1
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 64
	i32.sub 	$17=, $11, $12
	copy_local	$18=, $17
	i32.const	$12=, __stack_pointer
	i32.store	$17=, 0($12), $17
	i32.store	$discard=, 60($17), $18
	i32.load	$push1=, 60($17)
	i32.const	$push2=, 3
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -4
	i32.and 	$push5=, $pop3, $pop4
	tee_local	$push82=, $6=, $pop5
	i32.const	$push81=, 4
	i32.add 	$push6=, $pop82, $pop81
	i32.store	$discard=, 60($17), $pop6
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($17):p2align=4, $pop0
	i32.const	$push80=, 8
	i32.const	$14=, 16
	i32.add 	$14=, $17, $14
	i32.or  	$push8=, $14, $pop80
	i32.load	$push7=, 0($6)
	i32.store	$discard=, 0($pop8):p2align=3, $pop7
	i32.const	$push9=, 7
	i32.add 	$push10=, $6, $pop9
	i32.const	$push79=, -4
	i32.and 	$push11=, $pop10, $pop79
	tee_local	$push78=, $6=, $pop11
	i32.const	$push77=, 4
	i32.add 	$push12=, $pop78, $pop77
	i32.store	$discard=, 60($17), $pop12
	i32.const	$push76=, 12
	i32.const	$15=, 16
	i32.add 	$15=, $17, $15
	i32.or  	$push14=, $15, $pop76
	i32.load	$push13=, 0($6)
	i32.store	$discard=, 0($pop14), $pop13
	i32.const	$push75=, 7
	i32.add 	$push15=, $6, $pop75
	i32.const	$push74=, -4
	i32.and 	$push16=, $pop15, $pop74
	tee_local	$push73=, $6=, $pop16
	i32.const	$push72=, 4
	i32.add 	$push17=, $pop73, $pop72
	i32.store	$discard=, 60($17), $pop17
	i32.load	$push18=, 0($6)
	i32.store	$discard=, 32($17):p2align=4, $pop18
	i32.const	$push71=, 7
	i32.add 	$push19=, $6, $pop71
	i32.const	$push70=, -4
	i32.and 	$push20=, $pop19, $pop70
	tee_local	$push69=, $6=, $pop20
	i32.const	$push68=, 4
	i32.add 	$push21=, $pop69, $pop68
	i32.store	$discard=, 60($17), $pop21
	i32.load	$push22=, 0($6)
	i32.store	$discard=, 36($17), $pop22
	i32.const	$push67=, 7
	i32.add 	$push23=, $6, $pop67
	i32.const	$push66=, -4
	i32.and 	$push24=, $pop23, $pop66
	tee_local	$push65=, $6=, $pop24
	i32.const	$push64=, 4
	i32.add 	$push25=, $pop65, $pop64
	i32.store	$discard=, 60($17), $pop25
	i32.load	$push26=, 0($6)
	i32.store	$discard=, 40($17):p2align=3, $pop26
	i32.const	$push63=, 7
	i32.add 	$push27=, $6, $pop63
	i32.const	$push62=, -4
	i32.and 	$push28=, $pop27, $pop62
	tee_local	$push61=, $6=, $pop28
	i32.const	$push60=, 4
	i32.add 	$push29=, $pop61, $pop60
	i32.store	$discard=, 60($17), $pop29
	i32.load	$push30=, 0($6)
	i32.store	$discard=, 44($17), $pop30
	i32.const	$push59=, 7
	i32.add 	$push31=, $6, $pop59
	i32.const	$push58=, -4
	i32.and 	$push32=, $pop31, $pop58
	tee_local	$push57=, $6=, $pop32
	i32.const	$push56=, 4
	i32.add 	$push33=, $pop57, $pop56
	i32.store	$discard=, 60($17), $pop33
	i32.load	$push34=, 0($6)
	i32.store	$discard=, 48($17):p2align=4, $pop34
	i32.const	$push55=, 7
	i32.add 	$push35=, $6, $pop55
	i32.const	$push54=, -4
	i32.and 	$push36=, $pop35, $pop54
	tee_local	$push53=, $6=, $pop36
	i32.const	$push52=, 4
	i32.add 	$push37=, $pop53, $pop52
	i32.store	$discard=, 60($17), $pop37
	i32.load	$push38=, 0($6)
	i32.store	$discard=, 52($17), $pop38
	i32.const	$push51=, 7
	i32.add 	$push39=, $6, $pop51
	i32.const	$push50=, -4
	i32.and 	$push40=, $pop39, $pop50
	tee_local	$push49=, $6=, $pop40
	i32.const	$push48=, 4
	i32.add 	$push41=, $pop49, $pop48
	i32.store	$discard=, 60($17), $pop41
	i32.load	$push42=, 0($6)
	i32.store	$discard=, 56($17):p2align=3, $pop42
	i32.const	$push47=, 4
	i32.const	$16=, 16
	i32.add 	$16=, $17, $16
	i32.or  	$4=, $16, $pop47
	i32.const	$5=, 0
	i32.const	$6=, 0
.LBB2_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	block
	i32.eq  	$push43=, $6, $5
	br_if   	0, $pop43       # 0: down to label6
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 16
	i32.sub 	$17=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$17=, 0($8), $17
	i32.const	$push90=, .L.str.2
	i32.store	$discard=, 0($17), $pop90
	i32.const	$push89=, 12
	i32.add 	$2=, $17, $pop89
	i32.store	$2=, 0($2), $6
	i32.const	$push88=, 8
	i32.add 	$3=, $17, $pop88
	i32.store	$discard=, 0($3), $5
	i32.const	$push87=, 4
	i32.add 	$5=, $17, $pop87
	i32.store	$discard=, 0($5), $2
	i32.const	$push86=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop86
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 16
	i32.add 	$17=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$17=, 0($10), $17
	i32.const	$push85=, 0
	i32.const	$push84=, 0
	i32.load	$push44=, errors($pop84)
	i32.const	$push83=, 1
	i32.add 	$push45=, $pop44, $pop83
	i32.store	$discard=, errors($pop85), $pop45
.LBB2_3:                                # %for.inc.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label6:
	i32.const	$push91=, 10
	i32.eq  	$push46=, $6, $pop91
	br_if   	1, $pop46       # 1: down to label5
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load	$5=, 0($4)
	i32.const	$push93=, 1
	i32.add 	$6=, $6, $pop93
	i32.const	$push92=, 4
	i32.add 	$4=, $4, $pop92
	br      	0               # 0: up to label4
.LBB2_5:                                # %verify.exit
	end_loop                        # label5:
	i32.const	$13=, 64
	i32.add 	$17=, $18, $13
	i32.const	$13=, __stack_pointer
	i32.store	$17=, 0($13), $17
	return
	.endfunc
.Lfunc_end2:
	.size	varargs1, .Lfunc_end2-varargs1

	.section	.text.varargs2,"ax",@progbits
	.type	varargs2,@function
varargs2:                               # @varargs2
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$12=, __stack_pointer
	i32.load	$12=, 0($12)
	i32.const	$13=, 64
	i32.sub 	$18=, $12, $13
	copy_local	$19=, $18
	i32.const	$13=, __stack_pointer
	i32.store	$18=, 0($13), $18
	i32.store	$discard=, 60($18), $19
	i32.load	$7=, 60($18)
	i32.const	$push74=, 8
	i32.const	$15=, 16
	i32.add 	$15=, $18, $15
	i32.or  	$push1=, $15, $pop74
	i32.const	$push2=, 2
	i32.store	$discard=, 0($pop1):p2align=3, $pop2
	i32.const	$push3=, 3
	i32.add 	$push4=, $7, $pop3
	i32.const	$push5=, -4
	i32.and 	$push6=, $pop4, $pop5
	tee_local	$push73=, $7=, $pop6
	i32.const	$push72=, 4
	i32.add 	$push7=, $pop73, $pop72
	i32.store	$discard=, 60($18), $pop7
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($18):p2align=4, $pop0
	i32.load	$5=, 60($18)
	i32.const	$push71=, 12
	i32.const	$16=, 16
	i32.add 	$16=, $18, $16
	i32.or  	$push9=, $16, $pop71
	i32.load	$push8=, 0($7)
	i32.store	$discard=, 0($pop9), $pop8
	i32.const	$push70=, 3
	i32.add 	$push10=, $5, $pop70
	i32.const	$push69=, -4
	i32.and 	$push11=, $pop10, $pop69
	tee_local	$push68=, $7=, $pop11
	i32.const	$push67=, 4
	i32.add 	$push12=, $pop68, $pop67
	i32.store	$discard=, 60($18), $pop12
	i32.load	$push13=, 0($7)
	i32.store	$discard=, 32($18):p2align=4, $pop13
	i32.const	$push14=, 7
	i32.add 	$push15=, $7, $pop14
	i32.const	$push66=, -4
	i32.and 	$push16=, $pop15, $pop66
	tee_local	$push65=, $7=, $pop16
	i32.const	$push64=, 4
	i32.add 	$push17=, $pop65, $pop64
	i32.store	$discard=, 60($18), $pop17
	i32.load	$push18=, 0($7)
	i32.store	$discard=, 36($18), $pop18
	i32.const	$push63=, 7
	i32.add 	$push19=, $7, $pop63
	i32.const	$push62=, -4
	i32.and 	$push20=, $pop19, $pop62
	tee_local	$push61=, $7=, $pop20
	i32.const	$push60=, 4
	i32.add 	$push21=, $pop61, $pop60
	i32.store	$discard=, 60($18), $pop21
	i32.load	$push22=, 0($7)
	i32.store	$discard=, 40($18):p2align=3, $pop22
	i32.const	$push59=, 7
	i32.add 	$push23=, $7, $pop59
	i32.const	$push58=, -4
	i32.and 	$push24=, $pop23, $pop58
	tee_local	$push57=, $7=, $pop24
	i32.const	$push56=, 4
	i32.add 	$push25=, $pop57, $pop56
	i32.store	$discard=, 60($18), $pop25
	i32.load	$push26=, 0($7)
	i32.store	$discard=, 44($18), $pop26
	i32.const	$push55=, 7
	i32.add 	$push27=, $7, $pop55
	i32.const	$push54=, -4
	i32.and 	$push28=, $pop27, $pop54
	tee_local	$push53=, $7=, $pop28
	i32.const	$push52=, 4
	i32.add 	$push29=, $pop53, $pop52
	i32.store	$discard=, 60($18), $pop29
	i32.load	$push30=, 0($7)
	i32.store	$discard=, 48($18):p2align=4, $pop30
	i32.const	$push51=, 7
	i32.add 	$push31=, $7, $pop51
	i32.const	$push50=, -4
	i32.and 	$push32=, $pop31, $pop50
	tee_local	$push49=, $7=, $pop32
	i32.const	$push48=, 4
	i32.add 	$push33=, $pop49, $pop48
	i32.store	$discard=, 60($18), $pop33
	i32.load	$push34=, 0($7)
	i32.store	$discard=, 52($18), $pop34
	i32.const	$push47=, 7
	i32.add 	$push35=, $7, $pop47
	i32.const	$push46=, -4
	i32.and 	$push36=, $pop35, $pop46
	tee_local	$push45=, $7=, $pop36
	i32.const	$push44=, 4
	i32.add 	$push37=, $pop45, $pop44
	i32.store	$discard=, 60($18), $pop37
	i32.load	$push38=, 0($7)
	i32.store	$discard=, 56($18):p2align=3, $pop38
	i32.const	$push43=, 4
	i32.const	$17=, 16
	i32.add 	$17=, $18, $17
	i32.or  	$5=, $17, $pop43
	i32.const	$6=, 0
	i32.const	$7=, 0
.LBB3_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	block
	i32.eq  	$push39=, $7, $6
	br_if   	0, $pop39       # 0: down to label9
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 16
	i32.sub 	$18=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$18=, 0($9), $18
	i32.const	$push82=, .L.str.3
	i32.store	$discard=, 0($18), $pop82
	i32.const	$push81=, 12
	i32.add 	$3=, $18, $pop81
	i32.store	$3=, 0($3), $7
	i32.const	$push80=, 8
	i32.add 	$4=, $18, $pop80
	i32.store	$discard=, 0($4), $6
	i32.const	$push79=, 4
	i32.add 	$6=, $18, $pop79
	i32.store	$discard=, 0($6), $3
	i32.const	$push78=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop78
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 16
	i32.add 	$18=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$18=, 0($11), $18
	i32.const	$push77=, 0
	i32.const	$push76=, 0
	i32.load	$push40=, errors($pop76)
	i32.const	$push75=, 1
	i32.add 	$push41=, $pop40, $pop75
	i32.store	$discard=, errors($pop77), $pop41
.LBB3_3:                                # %for.inc.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_block                       # label9:
	i32.const	$push83=, 10
	i32.eq  	$push42=, $7, $pop83
	br_if   	1, $pop42       # 1: down to label8
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.load	$6=, 0($5)
	i32.const	$push85=, 1
	i32.add 	$7=, $7, $pop85
	i32.const	$push84=, 4
	i32.add 	$5=, $5, $pop84
	br      	0               # 0: up to label7
.LBB3_5:                                # %verify.exit
	end_loop                        # label8:
	i32.const	$14=, 64
	i32.add 	$18=, $19, $14
	i32.const	$14=, __stack_pointer
	i32.store	$18=, 0($14), $18
	return
	.endfunc
.Lfunc_end3:
	.size	varargs2, .Lfunc_end3-varargs2

	.section	.text.varargs3,"ax",@progbits
	.type	varargs3,@function
varargs3:                               # @varargs3
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$13=, __stack_pointer
	i32.load	$13=, 0($13)
	i32.const	$14=, 64
	i32.sub 	$18=, $13, $14
	copy_local	$19=, $18
	i32.const	$14=, __stack_pointer
	i32.store	$18=, 0($14), $18
	i32.store	$discard=, 60($18), $19
	i32.load	$8=, 60($18)
	i32.const	$push64=, 8
	i32.const	$16=, 16
	i32.add 	$16=, $18, $16
	i32.or  	$push1=, $16, $pop64
	i64.const	$push2=, 12884901890
	i64.store	$discard=, 0($pop1), $pop2
	i32.const	$push3=, 3
	i32.add 	$push4=, $8, $pop3
	i32.const	$push5=, -4
	i32.and 	$push6=, $pop4, $pop5
	tee_local	$push63=, $8=, $pop6
	i32.const	$push62=, 4
	i32.add 	$push7=, $pop63, $pop62
	i32.store	$discard=, 60($18), $pop7
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($18):p2align=4, $pop0
	i32.load	$6=, 60($18)
	i32.load	$push8=, 0($8)
	i32.store	$discard=, 32($18):p2align=4, $pop8
	i32.const	$push61=, 3
	i32.add 	$push9=, $6, $pop61
	i32.const	$push60=, -4
	i32.and 	$push10=, $pop9, $pop60
	tee_local	$push59=, $8=, $pop10
	i32.const	$push58=, 4
	i32.add 	$push11=, $pop59, $pop58
	i32.store	$discard=, 60($18), $pop11
	i32.load	$push12=, 0($8)
	i32.store	$discard=, 36($18), $pop12
	i32.const	$push13=, 7
	i32.add 	$push14=, $8, $pop13
	i32.const	$push57=, -4
	i32.and 	$push15=, $pop14, $pop57
	tee_local	$push56=, $8=, $pop15
	i32.const	$push55=, 4
	i32.add 	$push16=, $pop56, $pop55
	i32.store	$discard=, 60($18), $pop16
	i32.load	$push17=, 0($8)
	i32.store	$discard=, 40($18):p2align=3, $pop17
	i32.const	$push54=, 7
	i32.add 	$push18=, $8, $pop54
	i32.const	$push53=, -4
	i32.and 	$push19=, $pop18, $pop53
	tee_local	$push52=, $8=, $pop19
	i32.const	$push51=, 4
	i32.add 	$push20=, $pop52, $pop51
	i32.store	$discard=, 60($18), $pop20
	i32.load	$push21=, 0($8)
	i32.store	$discard=, 44($18), $pop21
	i32.const	$push50=, 7
	i32.add 	$push22=, $8, $pop50
	i32.const	$push49=, -4
	i32.and 	$push23=, $pop22, $pop49
	tee_local	$push48=, $8=, $pop23
	i32.const	$push47=, 4
	i32.add 	$push24=, $pop48, $pop47
	i32.store	$discard=, 60($18), $pop24
	i32.load	$push25=, 0($8)
	i32.store	$discard=, 48($18):p2align=4, $pop25
	i32.const	$push46=, 7
	i32.add 	$push26=, $8, $pop46
	i32.const	$push45=, -4
	i32.and 	$push27=, $pop26, $pop45
	tee_local	$push44=, $8=, $pop27
	i32.const	$push43=, 4
	i32.add 	$push28=, $pop44, $pop43
	i32.store	$discard=, 60($18), $pop28
	i32.load	$push29=, 0($8)
	i32.store	$discard=, 52($18), $pop29
	i32.const	$push42=, 7
	i32.add 	$push30=, $8, $pop42
	i32.const	$push41=, -4
	i32.and 	$push31=, $pop30, $pop41
	tee_local	$push40=, $8=, $pop31
	i32.const	$push39=, 4
	i32.add 	$push32=, $pop40, $pop39
	i32.store	$discard=, 60($18), $pop32
	i32.load	$push33=, 0($8)
	i32.store	$discard=, 56($18):p2align=3, $pop33
	i32.const	$push38=, 4
	i32.const	$17=, 16
	i32.add 	$17=, $18, $17
	i32.or  	$6=, $17, $pop38
	i32.const	$7=, 0
	i32.const	$8=, 0
.LBB4_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	block
	i32.eq  	$push34=, $8, $7
	br_if   	0, $pop34       # 0: down to label12
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB4_1 Depth=1
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 16
	i32.sub 	$18=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$18=, 0($10), $18
	i32.const	$push72=, .L.str.4
	i32.store	$discard=, 0($18), $pop72
	i32.const	$push71=, 12
	i32.add 	$4=, $18, $pop71
	i32.store	$4=, 0($4), $8
	i32.const	$push70=, 8
	i32.add 	$5=, $18, $pop70
	i32.store	$discard=, 0($5), $7
	i32.const	$push69=, 4
	i32.add 	$7=, $18, $pop69
	i32.store	$discard=, 0($7), $4
	i32.const	$push68=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop68
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 16
	i32.add 	$18=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$18=, 0($12), $18
	i32.const	$push67=, 0
	i32.const	$push66=, 0
	i32.load	$push35=, errors($pop66)
	i32.const	$push65=, 1
	i32.add 	$push36=, $pop35, $pop65
	i32.store	$discard=, errors($pop67), $pop36
.LBB4_3:                                # %for.inc.i
                                        #   in Loop: Header=BB4_1 Depth=1
	end_block                       # label12:
	i32.const	$push73=, 10
	i32.eq  	$push37=, $8, $pop73
	br_if   	1, $pop37       # 1: down to label11
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB4_1 Depth=1
	i32.load	$7=, 0($6)
	i32.const	$push75=, 1
	i32.add 	$8=, $8, $pop75
	i32.const	$push74=, 4
	i32.add 	$6=, $6, $pop74
	br      	0               # 0: up to label10
.LBB4_5:                                # %verify.exit
	end_loop                        # label11:
	i32.const	$15=, 64
	i32.add 	$18=, $19, $15
	i32.const	$15=, __stack_pointer
	i32.store	$18=, 0($15), $18
	return
	.endfunc
.Lfunc_end4:
	.size	varargs3, .Lfunc_end4-varargs3

	.section	.text.varargs4,"ax",@progbits
	.type	varargs4,@function
varargs4:                               # @varargs4
	.param  	i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$15=, __stack_pointer
	i32.load	$15=, 0($15)
	i32.const	$16=, 64
	i32.sub 	$20=, $15, $16
	copy_local	$21=, $20
	i32.const	$16=, __stack_pointer
	i32.store	$20=, 0($16), $20
	i32.store	$discard=, 60($20), $21
	i32.load	$9=, 60($20)
	i32.const	$push53=, 8
	i32.const	$18=, 16
	i32.add 	$18=, $20, $18
	i32.or  	$push2=, $18, $pop53
	i64.const	$push3=, 12884901890
	i64.store	$discard=, 0($pop2), $pop3
	i32.const	$push5=, 3
	i32.add 	$push6=, $9, $pop5
	i32.const	$push7=, -4
	i32.and 	$push8=, $pop6, $pop7
	tee_local	$push52=, $9=, $pop8
	i32.const	$push1=, 4
	i32.store	$push4=, 32($20):p2align=4, $pop1
	tee_local	$push51=, $10=, $pop4
	i32.add 	$push9=, $pop52, $pop51
	i32.store	$discard=, 60($20), $pop9
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($20):p2align=4, $pop0
	i32.load	$7=, 60($20)
	i32.load	$push10=, 0($9)
	i32.store	$discard=, 36($20), $pop10
	i32.const	$push50=, 3
	i32.add 	$push11=, $7, $pop50
	i32.const	$push49=, -4
	i32.and 	$push12=, $pop11, $pop49
	tee_local	$push48=, $9=, $pop12
	i32.add 	$push13=, $10, $pop48
	i32.store	$discard=, 60($20), $pop13
	i32.load	$push14=, 0($9)
	i32.store	$discard=, 40($20):p2align=3, $pop14
	i32.const	$push15=, 7
	i32.add 	$push16=, $9, $pop15
	i32.const	$push47=, -4
	i32.and 	$push17=, $pop16, $pop47
	tee_local	$push46=, $9=, $pop17
	i32.add 	$push18=, $10, $pop46
	i32.store	$discard=, 60($20), $pop18
	i32.load	$push19=, 0($9)
	i32.store	$discard=, 44($20), $pop19
	i32.const	$push45=, 7
	i32.add 	$push20=, $9, $pop45
	i32.const	$push44=, -4
	i32.and 	$push21=, $pop20, $pop44
	tee_local	$push43=, $9=, $pop21
	i32.add 	$push22=, $10, $pop43
	i32.store	$discard=, 60($20), $pop22
	i32.load	$push23=, 0($9)
	i32.store	$discard=, 48($20):p2align=4, $pop23
	i32.const	$push42=, 7
	i32.add 	$push24=, $9, $pop42
	i32.const	$push41=, -4
	i32.and 	$push25=, $pop24, $pop41
	tee_local	$push40=, $9=, $pop25
	i32.add 	$push26=, $10, $pop40
	i32.store	$discard=, 60($20), $pop26
	i32.load	$push27=, 0($9)
	i32.store	$discard=, 52($20), $pop27
	i32.const	$push39=, 7
	i32.add 	$push28=, $9, $pop39
	i32.const	$push38=, -4
	i32.and 	$push29=, $pop28, $pop38
	tee_local	$push37=, $9=, $pop29
	i32.add 	$push30=, $10, $pop37
	i32.store	$discard=, 60($20), $pop30
	i32.load	$push31=, 0($9)
	i32.store	$discard=, 56($20):p2align=3, $pop31
	i32.const	$push36=, 4
	i32.const	$19=, 16
	i32.add 	$19=, $20, $19
	i32.or  	$7=, $19, $pop36
	i32.const	$8=, 0
	i32.const	$9=, 0
.LBB5_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label13:
	block
	i32.eq  	$push32=, $9, $8
	br_if   	0, $pop32       # 0: down to label15
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB5_1 Depth=1
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 16
	i32.sub 	$20=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$20=, 0($12), $20
	i32.const	$push60=, .L.str.5
	i32.store	$discard=, 0($20), $pop60
	i32.const	$push59=, 12
	i32.add 	$5=, $20, $pop59
	i32.store	$5=, 0($5), $9
	i32.const	$push58=, 8
	i32.add 	$6=, $20, $pop58
	i32.store	$discard=, 0($6), $8
	i32.add 	$8=, $20, $10
	i32.store	$discard=, 0($8), $5
	i32.const	$push57=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop57
	i32.const	$13=, __stack_pointer
	i32.load	$13=, 0($13)
	i32.const	$14=, 16
	i32.add 	$20=, $13, $14
	i32.const	$14=, __stack_pointer
	i32.store	$20=, 0($14), $20
	i32.const	$push56=, 0
	i32.const	$push55=, 0
	i32.load	$push33=, errors($pop55)
	i32.const	$push54=, 1
	i32.add 	$push34=, $pop33, $pop54
	i32.store	$discard=, errors($pop56), $pop34
.LBB5_3:                                # %for.inc.i
                                        #   in Loop: Header=BB5_1 Depth=1
	end_block                       # label15:
	i32.const	$push61=, 10
	i32.eq  	$push35=, $9, $pop61
	br_if   	1, $pop35       # 1: down to label14
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB5_1 Depth=1
	i32.load	$8=, 0($7)
	i32.const	$push62=, 1
	i32.add 	$9=, $9, $pop62
	i32.add 	$7=, $7, $10
	br      	0               # 0: up to label13
.LBB5_5:                                # %verify.exit
	end_loop                        # label14:
	i32.const	$17=, 64
	i32.add 	$20=, $21, $17
	i32.const	$17=, __stack_pointer
	i32.store	$20=, 0($17), $20
	return
	.endfunc
.Lfunc_end5:
	.size	varargs4, .Lfunc_end5-varargs4

	.section	.text.varargs5,"ax",@progbits
	.type	varargs5,@function
varargs5:                               # @varargs5
	.param  	i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$15=, __stack_pointer
	i32.load	$15=, 0($15)
	i32.const	$16=, 64
	i32.sub 	$20=, $15, $16
	copy_local	$21=, $20
	i32.const	$16=, __stack_pointer
	i32.store	$20=, 0($16), $20
	i32.store	$discard=, 60($20), $21
	i32.load	$10=, 60($20)
	i32.const	$push49=, 8
	i32.const	$18=, 16
	i32.add 	$18=, $20, $18
	i32.or  	$push1=, $18, $pop49
	i64.const	$push2=, 12884901890
	i64.store	$discard=, 0($pop1), $pop2
	i32.const	$push4=, 3
	i32.add 	$push5=, $10, $pop4
	i32.const	$push6=, -4
	i32.and 	$push7=, $pop5, $pop6
	tee_local	$push48=, $10=, $pop7
	i32.const	$push47=, 4
	i32.add 	$push8=, $pop48, $pop47
	i32.store	$discard=, 60($20), $pop8
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($20):p2align=4, $pop0
	i64.const	$push3=, 21474836484
	i64.store	$discard=, 32($20):p2align=4, $pop3
	i32.load	$8=, 60($20)
	i32.load	$push9=, 0($10)
	i32.store	$discard=, 40($20):p2align=3, $pop9
	i32.const	$push46=, 3
	i32.add 	$push10=, $8, $pop46
	i32.const	$push45=, -4
	i32.and 	$push11=, $pop10, $pop45
	tee_local	$push44=, $10=, $pop11
	i32.const	$push43=, 4
	i32.add 	$push12=, $pop44, $pop43
	i32.store	$discard=, 60($20), $pop12
	i32.load	$push13=, 0($10)
	i32.store	$discard=, 44($20), $pop13
	i32.const	$push14=, 7
	i32.add 	$push15=, $10, $pop14
	i32.const	$push42=, -4
	i32.and 	$push16=, $pop15, $pop42
	tee_local	$push41=, $10=, $pop16
	i32.const	$push40=, 4
	i32.add 	$push17=, $pop41, $pop40
	i32.store	$discard=, 60($20), $pop17
	i32.load	$push18=, 0($10)
	i32.store	$discard=, 48($20):p2align=4, $pop18
	i32.const	$push39=, 7
	i32.add 	$push19=, $10, $pop39
	i32.const	$push38=, -4
	i32.and 	$push20=, $pop19, $pop38
	tee_local	$push37=, $10=, $pop20
	i32.const	$push36=, 4
	i32.add 	$push21=, $pop37, $pop36
	i32.store	$discard=, 60($20), $pop21
	i32.load	$push22=, 0($10)
	i32.store	$discard=, 52($20), $pop22
	i32.const	$push35=, 7
	i32.add 	$push23=, $10, $pop35
	i32.const	$push34=, -4
	i32.and 	$push24=, $pop23, $pop34
	tee_local	$push33=, $10=, $pop24
	i32.const	$push32=, 4
	i32.add 	$push25=, $pop33, $pop32
	i32.store	$discard=, 60($20), $pop25
	i32.load	$push26=, 0($10)
	i32.store	$discard=, 56($20):p2align=3, $pop26
	i32.const	$push31=, 4
	i32.const	$19=, 16
	i32.add 	$19=, $20, $19
	i32.or  	$8=, $19, $pop31
	i32.const	$9=, 0
	i32.const	$10=, 0
.LBB6_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label16:
	block
	i32.eq  	$push27=, $10, $9
	br_if   	0, $pop27       # 0: down to label18
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB6_1 Depth=1
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 16
	i32.sub 	$20=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$20=, 0($12), $20
	i32.const	$push57=, .L.str.6
	i32.store	$discard=, 0($20), $pop57
	i32.const	$push56=, 12
	i32.add 	$6=, $20, $pop56
	i32.store	$6=, 0($6), $10
	i32.const	$push55=, 8
	i32.add 	$7=, $20, $pop55
	i32.store	$discard=, 0($7), $9
	i32.const	$push54=, 4
	i32.add 	$9=, $20, $pop54
	i32.store	$discard=, 0($9), $6
	i32.const	$push53=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop53
	i32.const	$13=, __stack_pointer
	i32.load	$13=, 0($13)
	i32.const	$14=, 16
	i32.add 	$20=, $13, $14
	i32.const	$14=, __stack_pointer
	i32.store	$20=, 0($14), $20
	i32.const	$push52=, 0
	i32.const	$push51=, 0
	i32.load	$push28=, errors($pop51)
	i32.const	$push50=, 1
	i32.add 	$push29=, $pop28, $pop50
	i32.store	$discard=, errors($pop52), $pop29
.LBB6_3:                                # %for.inc.i
                                        #   in Loop: Header=BB6_1 Depth=1
	end_block                       # label18:
	i32.const	$push58=, 10
	i32.eq  	$push30=, $10, $pop58
	br_if   	1, $pop30       # 1: down to label17
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB6_1 Depth=1
	i32.load	$9=, 0($8)
	i32.const	$push60=, 1
	i32.add 	$10=, $10, $pop60
	i32.const	$push59=, 4
	i32.add 	$8=, $8, $pop59
	br      	0               # 0: up to label16
.LBB6_5:                                # %verify.exit
	end_loop                        # label17:
	i32.const	$17=, 64
	i32.add 	$20=, $21, $17
	i32.const	$17=, __stack_pointer
	i32.store	$20=, 0($17), $20
	return
	.endfunc
.Lfunc_end6:
	.size	varargs5, .Lfunc_end6-varargs5

	.section	.text.varargs6,"ax",@progbits
	.type	varargs6,@function
varargs6:                               # @varargs6
	.param  	i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$16=, __stack_pointer
	i32.load	$16=, 0($16)
	i32.const	$17=, 64
	i32.sub 	$21=, $16, $17
	copy_local	$22=, $21
	i32.const	$17=, __stack_pointer
	i32.store	$21=, 0($17), $21
	i32.const	$push42=, 8
	i32.const	$19=, 16
	i32.add 	$19=, $21, $19
	i32.or  	$push1=, $19, $pop42
	i64.const	$push2=, 12884901890
	i64.store	$discard=, 0($pop1), $pop2
	i32.store	$discard=, 60($21), $22
	i32.load	$11=, 60($21)
	i32.const	$push4=, 6
	i32.store	$discard=, 40($21):p2align=3, $pop4
	i32.const	$push5=, 3
	i32.add 	$push6=, $11, $pop5
	i32.const	$push7=, -4
	i32.and 	$push8=, $pop6, $pop7
	tee_local	$push41=, $11=, $pop8
	i32.const	$push40=, 4
	i32.add 	$push9=, $pop41, $pop40
	i32.store	$discard=, 60($21), $pop9
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($21):p2align=4, $pop0
	i64.const	$push3=, 21474836484
	i64.store	$discard=, 32($21):p2align=4, $pop3
	i32.load	$9=, 60($21)
	i32.load	$push10=, 0($11)
	i32.store	$discard=, 44($21), $pop10
	i32.const	$push39=, 3
	i32.add 	$push11=, $9, $pop39
	i32.const	$push38=, -4
	i32.and 	$push12=, $pop11, $pop38
	tee_local	$push37=, $11=, $pop12
	i32.const	$push36=, 4
	i32.add 	$push13=, $pop37, $pop36
	i32.store	$discard=, 60($21), $pop13
	i32.load	$push14=, 0($11)
	i32.store	$discard=, 48($21):p2align=4, $pop14
	i32.const	$push15=, 7
	i32.add 	$push16=, $11, $pop15
	i32.const	$push35=, -4
	i32.and 	$push17=, $pop16, $pop35
	tee_local	$push34=, $11=, $pop17
	i32.const	$push33=, 4
	i32.add 	$push18=, $pop34, $pop33
	i32.store	$discard=, 60($21), $pop18
	i32.load	$push19=, 0($11)
	i32.store	$discard=, 52($21), $pop19
	i32.const	$push32=, 7
	i32.add 	$push20=, $11, $pop32
	i32.const	$push31=, -4
	i32.and 	$push21=, $pop20, $pop31
	tee_local	$push30=, $11=, $pop21
	i32.const	$push29=, 4
	i32.add 	$push22=, $pop30, $pop29
	i32.store	$discard=, 60($21), $pop22
	i32.load	$push23=, 0($11)
	i32.store	$discard=, 56($21):p2align=3, $pop23
	i32.const	$push28=, 4
	i32.const	$20=, 16
	i32.add 	$20=, $21, $20
	i32.or  	$9=, $20, $pop28
	i32.const	$10=, 0
	i32.const	$11=, 0
.LBB7_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label19:
	block
	i32.eq  	$push24=, $11, $10
	br_if   	0, $pop24       # 0: down to label21
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB7_1 Depth=1
	i32.const	$12=, __stack_pointer
	i32.load	$12=, 0($12)
	i32.const	$13=, 16
	i32.sub 	$21=, $12, $13
	i32.const	$13=, __stack_pointer
	i32.store	$21=, 0($13), $21
	i32.const	$push50=, .L.str.7
	i32.store	$discard=, 0($21), $pop50
	i32.const	$push49=, 12
	i32.add 	$7=, $21, $pop49
	i32.store	$7=, 0($7), $11
	i32.const	$push48=, 8
	i32.add 	$8=, $21, $pop48
	i32.store	$discard=, 0($8), $10
	i32.const	$push47=, 4
	i32.add 	$10=, $21, $pop47
	i32.store	$discard=, 0($10), $7
	i32.const	$push46=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop46
	i32.const	$14=, __stack_pointer
	i32.load	$14=, 0($14)
	i32.const	$15=, 16
	i32.add 	$21=, $14, $15
	i32.const	$15=, __stack_pointer
	i32.store	$21=, 0($15), $21
	i32.const	$push45=, 0
	i32.const	$push44=, 0
	i32.load	$push25=, errors($pop44)
	i32.const	$push43=, 1
	i32.add 	$push26=, $pop25, $pop43
	i32.store	$discard=, errors($pop45), $pop26
.LBB7_3:                                # %for.inc.i
                                        #   in Loop: Header=BB7_1 Depth=1
	end_block                       # label21:
	i32.const	$push51=, 10
	i32.eq  	$push27=, $11, $pop51
	br_if   	1, $pop27       # 1: down to label20
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB7_1 Depth=1
	i32.load	$10=, 0($9)
	i32.const	$push53=, 1
	i32.add 	$11=, $11, $pop53
	i32.const	$push52=, 4
	i32.add 	$9=, $9, $pop52
	br      	0               # 0: up to label19
.LBB7_5:                                # %verify.exit
	end_loop                        # label20:
	i32.const	$18=, 64
	i32.add 	$21=, $22, $18
	i32.const	$18=, __stack_pointer
	i32.store	$21=, 0($18), $21
	return
	.endfunc
.Lfunc_end7:
	.size	varargs6, .Lfunc_end7-varargs6

	.section	.text.varargs7,"ax",@progbits
	.type	varargs7,@function
varargs7:                               # @varargs7
	.param  	i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$17=, __stack_pointer
	i32.load	$17=, 0($17)
	i32.const	$18=, 64
	i32.sub 	$22=, $17, $18
	copy_local	$23=, $22
	i32.const	$18=, __stack_pointer
	i32.store	$22=, 0($18), $22
	i32.store	$discard=, 60($22), $23
	i32.load	$12=, 60($22)
	i32.const	$push34=, 8
	i32.const	$20=, 16
	i32.add 	$20=, $22, $20
	i32.or  	$push1=, $20, $pop34
	i64.const	$push2=, 12884901890
	i64.store	$discard=, 0($pop1), $pop2
	i32.const	$push5=, 3
	i32.add 	$push6=, $12, $pop5
	i32.const	$push7=, -4
	i32.and 	$push8=, $pop6, $pop7
	tee_local	$push33=, $12=, $pop8
	i32.const	$push32=, 4
	i32.add 	$push9=, $pop33, $pop32
	i32.store	$discard=, 60($22), $pop9
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($22):p2align=4, $pop0
	i64.const	$push3=, 21474836484
	i64.store	$discard=, 32($22):p2align=4, $pop3
	i64.const	$push4=, 30064771078
	i64.store	$discard=, 40($22), $pop4
	i32.load	$10=, 60($22)
	i32.load	$push10=, 0($12)
	i32.store	$discard=, 48($22):p2align=4, $pop10
	i32.const	$push31=, 3
	i32.add 	$push11=, $10, $pop31
	i32.const	$push30=, -4
	i32.and 	$push12=, $pop11, $pop30
	tee_local	$push29=, $12=, $pop12
	i32.const	$push28=, 4
	i32.add 	$push13=, $pop29, $pop28
	i32.store	$discard=, 60($22), $pop13
	i32.load	$push14=, 0($12)
	i32.store	$discard=, 52($22), $pop14
	i32.const	$push15=, 7
	i32.add 	$push16=, $12, $pop15
	i32.const	$push27=, -4
	i32.and 	$push17=, $pop16, $pop27
	tee_local	$push26=, $12=, $pop17
	i32.const	$push25=, 4
	i32.add 	$push18=, $pop26, $pop25
	i32.store	$discard=, 60($22), $pop18
	i32.load	$push19=, 0($12)
	i32.store	$discard=, 56($22):p2align=3, $pop19
	i32.const	$push24=, 4
	i32.const	$21=, 16
	i32.add 	$21=, $22, $21
	i32.or  	$10=, $21, $pop24
	i32.const	$11=, 0
	i32.const	$12=, 0
.LBB8_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label22:
	block
	i32.eq  	$push20=, $12, $11
	br_if   	0, $pop20       # 0: down to label24
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB8_1 Depth=1
	i32.const	$13=, __stack_pointer
	i32.load	$13=, 0($13)
	i32.const	$14=, 16
	i32.sub 	$22=, $13, $14
	i32.const	$14=, __stack_pointer
	i32.store	$22=, 0($14), $22
	i32.const	$push42=, .L.str.8
	i32.store	$discard=, 0($22), $pop42
	i32.const	$push41=, 12
	i32.add 	$8=, $22, $pop41
	i32.store	$8=, 0($8), $12
	i32.const	$push40=, 8
	i32.add 	$9=, $22, $pop40
	i32.store	$discard=, 0($9), $11
	i32.const	$push39=, 4
	i32.add 	$11=, $22, $pop39
	i32.store	$discard=, 0($11), $8
	i32.const	$push38=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop38
	i32.const	$15=, __stack_pointer
	i32.load	$15=, 0($15)
	i32.const	$16=, 16
	i32.add 	$22=, $15, $16
	i32.const	$16=, __stack_pointer
	i32.store	$22=, 0($16), $22
	i32.const	$push37=, 0
	i32.const	$push36=, 0
	i32.load	$push21=, errors($pop36)
	i32.const	$push35=, 1
	i32.add 	$push22=, $pop21, $pop35
	i32.store	$discard=, errors($pop37), $pop22
.LBB8_3:                                # %for.inc.i
                                        #   in Loop: Header=BB8_1 Depth=1
	end_block                       # label24:
	i32.const	$push43=, 10
	i32.eq  	$push23=, $12, $pop43
	br_if   	1, $pop23       # 1: down to label23
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB8_1 Depth=1
	i32.load	$11=, 0($10)
	i32.const	$push45=, 1
	i32.add 	$12=, $12, $pop45
	i32.const	$push44=, 4
	i32.add 	$10=, $10, $pop44
	br      	0               # 0: up to label22
.LBB8_5:                                # %verify.exit
	end_loop                        # label23:
	i32.const	$19=, 64
	i32.add 	$22=, $23, $19
	i32.const	$19=, __stack_pointer
	i32.store	$22=, 0($19), $22
	return
	.endfunc
.Lfunc_end8:
	.size	varargs7, .Lfunc_end8-varargs7

	.section	.text.varargs8,"ax",@progbits
	.type	varargs8,@function
varargs8:                               # @varargs8
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$19=, __stack_pointer
	i32.load	$19=, 0($19)
	i32.const	$20=, 64
	i32.sub 	$24=, $19, $20
	copy_local	$25=, $24
	i32.const	$20=, __stack_pointer
	i32.store	$24=, 0($20), $24
	i32.store	$discard=, 60($24), $25
	i32.load	$14=, 60($24)
	i32.const	$push1=, 8
	i32.const	$22=, 16
	i32.add 	$22=, $24, $22
	i32.or  	$push2=, $22, $pop1
	i64.const	$push3=, 12884901890
	i64.store	$discard=, 0($pop2), $pop3
	i32.const	$push6=, 3
	i32.add 	$push7=, $14, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push27=, $14=, $pop9
	i32.const	$push26=, 4
	i32.add 	$push10=, $pop27, $pop26
	i32.store	$discard=, 60($24), $pop10
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($24):p2align=4, $pop0
	i64.const	$push4=, 21474836484
	i64.store	$discard=, 32($24):p2align=4, $pop4
	i64.const	$push5=, 30064771078
	i64.store	$discard=, 40($24), $pop5
	i32.const	$push25=, 8
	i32.store	$9=, 48($24):p2align=4, $pop25
	i32.load	$12=, 60($24)
	i32.load	$push11=, 0($14)
	i32.store	$discard=, 52($24), $pop11
	i32.const	$push24=, 3
	i32.add 	$push12=, $12, $pop24
	i32.const	$push23=, -4
	i32.and 	$push13=, $pop12, $pop23
	tee_local	$push22=, $14=, $pop13
	i32.const	$push21=, 4
	i32.add 	$push14=, $pop22, $pop21
	i32.store	$discard=, 60($24), $pop14
	i32.load	$push15=, 0($14)
	i32.store	$discard=, 56($24):p2align=3, $pop15
	i32.const	$push20=, 4
	i32.const	$23=, 16
	i32.add 	$23=, $24, $23
	i32.or  	$12=, $23, $pop20
	i32.const	$13=, 0
	i32.const	$14=, 0
.LBB9_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label25:
	block
	i32.eq  	$push16=, $14, $13
	br_if   	0, $pop16       # 0: down to label27
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB9_1 Depth=1
	i32.const	$15=, __stack_pointer
	i32.load	$15=, 0($15)
	i32.const	$16=, 16
	i32.sub 	$24=, $15, $16
	i32.const	$16=, __stack_pointer
	i32.store	$24=, 0($16), $24
	i32.const	$push34=, .L.str.9
	i32.store	$discard=, 0($24), $pop34
	i32.const	$push33=, 12
	i32.add 	$10=, $24, $pop33
	i32.store	$10=, 0($10), $14
	i32.add 	$11=, $24, $9
	i32.store	$discard=, 0($11), $13
	i32.const	$push32=, 4
	i32.add 	$13=, $24, $pop32
	i32.store	$discard=, 0($13), $10
	i32.const	$push31=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop31
	i32.const	$17=, __stack_pointer
	i32.load	$17=, 0($17)
	i32.const	$18=, 16
	i32.add 	$24=, $17, $18
	i32.const	$18=, __stack_pointer
	i32.store	$24=, 0($18), $24
	i32.const	$push30=, 0
	i32.const	$push29=, 0
	i32.load	$push17=, errors($pop29)
	i32.const	$push28=, 1
	i32.add 	$push18=, $pop17, $pop28
	i32.store	$discard=, errors($pop30), $pop18
.LBB9_3:                                # %for.inc.i
                                        #   in Loop: Header=BB9_1 Depth=1
	end_block                       # label27:
	i32.const	$push35=, 10
	i32.eq  	$push19=, $14, $pop35
	br_if   	1, $pop19       # 1: down to label26
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB9_1 Depth=1
	i32.load	$13=, 0($12)
	i32.const	$push37=, 1
	i32.add 	$14=, $14, $pop37
	i32.const	$push36=, 4
	i32.add 	$12=, $12, $pop36
	br      	0               # 0: up to label25
.LBB9_5:                                # %verify.exit
	end_loop                        # label26:
	i32.const	$21=, 64
	i32.add 	$24=, $25, $21
	i32.const	$21=, __stack_pointer
	i32.store	$24=, 0($21), $24
	return
	.endfunc
.Lfunc_end9:
	.size	varargs8, .Lfunc_end9-varargs8

	.section	.text.varargs9,"ax",@progbits
	.type	varargs9,@function
varargs9:                               # @varargs9
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$19=, __stack_pointer
	i32.load	$19=, 0($19)
	i32.const	$20=, 64
	i32.sub 	$24=, $19, $20
	copy_local	$25=, $24
	i32.const	$20=, __stack_pointer
	i32.store	$24=, 0($20), $24
	i32.store	$discard=, 60($24), $25
	i32.load	$14=, 60($24)
	i32.const	$push19=, 8
	i32.const	$22=, 16
	i32.add 	$22=, $24, $22
	i32.or  	$push1=, $22, $pop19
	i64.const	$push2=, 12884901890
	i64.store	$discard=, 0($pop1), $pop2
	i32.const	$push6=, 3
	i32.add 	$push7=, $14, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push18=, $14=, $pop9
	i32.const	$push17=, 4
	i32.add 	$push10=, $pop18, $pop17
	i32.store	$discard=, 60($24), $pop10
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($24):p2align=4, $pop0
	i64.const	$push3=, 21474836484
	i64.store	$discard=, 32($24):p2align=4, $pop3
	i64.const	$push4=, 30064771078
	i64.store	$discard=, 40($24), $pop4
	i64.const	$push5=, 38654705672
	i64.store	$discard=, 48($24):p2align=4, $pop5
	i32.load	$push11=, 0($14)
	i32.store	$discard=, 56($24):p2align=3, $pop11
	i32.const	$push16=, 4
	i32.const	$23=, 16
	i32.add 	$23=, $24, $23
	i32.or  	$12=, $23, $pop16
	i32.const	$13=, 0
	i32.const	$14=, 0
.LBB10_1:                               # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label28:
	block
	i32.eq  	$push12=, $14, $13
	br_if   	0, $pop12       # 0: down to label30
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB10_1 Depth=1
	i32.const	$15=, __stack_pointer
	i32.load	$15=, 0($15)
	i32.const	$16=, 16
	i32.sub 	$24=, $15, $16
	i32.const	$16=, __stack_pointer
	i32.store	$24=, 0($16), $24
	i32.const	$push27=, .L.str.10
	i32.store	$discard=, 0($24), $pop27
	i32.const	$push26=, 12
	i32.add 	$10=, $24, $pop26
	i32.store	$10=, 0($10), $14
	i32.const	$push25=, 8
	i32.add 	$11=, $24, $pop25
	i32.store	$discard=, 0($11), $13
	i32.const	$push24=, 4
	i32.add 	$13=, $24, $pop24
	i32.store	$discard=, 0($13), $10
	i32.const	$push23=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop23
	i32.const	$17=, __stack_pointer
	i32.load	$17=, 0($17)
	i32.const	$18=, 16
	i32.add 	$24=, $17, $18
	i32.const	$18=, __stack_pointer
	i32.store	$24=, 0($18), $24
	i32.const	$push22=, 0
	i32.const	$push21=, 0
	i32.load	$push13=, errors($pop21)
	i32.const	$push20=, 1
	i32.add 	$push14=, $pop13, $pop20
	i32.store	$discard=, errors($pop22), $pop14
.LBB10_3:                               # %for.inc.i
                                        #   in Loop: Header=BB10_1 Depth=1
	end_block                       # label30:
	i32.const	$push28=, 10
	i32.eq  	$push15=, $14, $pop28
	br_if   	1, $pop15       # 1: down to label29
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB10_1 Depth=1
	i32.load	$13=, 0($12)
	i32.const	$push30=, 1
	i32.add 	$14=, $14, $pop30
	i32.const	$push29=, 4
	i32.add 	$12=, $12, $pop29
	br      	0               # 0: up to label28
.LBB10_5:                               # %verify.exit
	end_loop                        # label29:
	i32.const	$21=, 64
	i32.add 	$24=, $25, $21
	i32.const	$21=, __stack_pointer
	i32.store	$24=, 0($21), $24
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
