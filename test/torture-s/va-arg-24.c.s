	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-24.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i64, i32, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push37=, __stack_pointer
	i32.load	$push38=, 0($pop37)
	i32.const	$push39=, 288
	i32.sub 	$8=, $pop38, $pop39
	i32.const	$push40=, __stack_pointer
	i32.store	$discard=, 0($pop40), $8
	i32.const	$push41=, 240
	i32.add 	$push42=, $8, $pop41
	i32.const	$push0=, 32
	i32.add 	$push1=, $pop42, $pop0
	i64.const	$push2=, 42949672969
	i64.store	$0=, 0($pop1):p2align=4, $pop2
	i32.const	$push43=, 240
	i32.add 	$push44=, $8, $pop43
	i32.const	$push3=, 24
	i32.add 	$push4=, $pop44, $pop3
	i64.const	$push5=, 34359738375
	i64.store	$1=, 0($pop4), $pop5
	i32.const	$push45=, 240
	i32.add 	$push46=, $8, $pop45
	i32.const	$push6=, 16
	i32.add 	$push7=, $pop46, $pop6
	i64.const	$push8=, 25769803781
	i64.store	$2=, 0($pop7):p2align=4, $pop8
	i64.const	$push9=, 17179869187
	i64.store	$3=, 248($8), $pop9
	i64.const	$push10=, 8589934593
	i64.store	$discard=, 240($8):p2align=4, $pop10
	i32.const	$push47=, 240
	i32.add 	$push48=, $8, $pop47
	call    	varargs0@FUNCTION, $4, $pop48
	i32.const	$push49=, 192
	i32.add 	$push50=, $8, $pop49
	i32.const	$push35=, 32
	i32.add 	$push11=, $pop50, $pop35
	i32.const	$push12=, 10
	i32.store	$4=, 0($pop11):p2align=4, $pop12
	i32.const	$push51=, 192
	i32.add 	$push52=, $8, $pop51
	i32.const	$push34=, 24
	i32.add 	$push13=, $pop52, $pop34
	i64.const	$push14=, 38654705672
	i64.store	$5=, 0($pop13), $pop14
	i32.const	$push53=, 192
	i32.add 	$push54=, $8, $pop53
	i32.const	$push33=, 16
	i32.add 	$push15=, $pop54, $pop33
	i64.const	$push16=, 30064771078
	i64.store	$6=, 0($pop15):p2align=4, $pop16
	i64.const	$push17=, 21474836484
	i64.store	$7=, 200($8), $pop17
	i64.const	$push18=, 12884901890
	i64.store	$discard=, 192($8):p2align=4, $pop18
	i32.const	$push55=, 192
	i32.add 	$push56=, $8, $pop55
	call    	varargs1@FUNCTION, $4, $4, $pop56
	i32.const	$push57=, 160
	i32.add 	$push58=, $8, $pop57
	i32.const	$push32=, 24
	i32.add 	$push19=, $pop58, $pop32
	i64.store	$discard=, 0($pop19), $0
	i32.const	$push59=, 160
	i32.add 	$push60=, $8, $pop59
	i32.const	$push31=, 16
	i32.add 	$push20=, $pop60, $pop31
	i64.store	$discard=, 0($pop20):p2align=4, $1
	i64.store	$discard=, 168($8), $2
	i64.store	$discard=, 160($8):p2align=4, $3
	i32.const	$push61=, 160
	i32.add 	$push62=, $8, $pop61
	call    	varargs2@FUNCTION, $4, $4, $4, $pop62
	i32.const	$push63=, 128
	i32.add 	$push64=, $8, $pop63
	i32.const	$push30=, 24
	i32.add 	$push21=, $pop64, $pop30
	i32.store	$discard=, 0($pop21):p2align=3, $4
	i32.const	$push65=, 128
	i32.add 	$push66=, $8, $pop65
	i32.const	$push29=, 16
	i32.add 	$push22=, $pop66, $pop29
	i64.store	$3=, 0($pop22):p2align=4, $5
	i64.store	$5=, 136($8), $6
	i64.store	$discard=, 128($8):p2align=4, $7
	i32.const	$push67=, 128
	i32.add 	$push68=, $8, $pop67
	call    	varargs3@FUNCTION, $4, $4, $4, $4, $pop68
	i32.const	$push69=, 96
	i32.add 	$push70=, $8, $pop69
	i32.const	$push28=, 16
	i32.add 	$push23=, $pop70, $pop28
	i64.store	$discard=, 0($pop23):p2align=4, $0
	i64.store	$discard=, 104($8), $1
	i64.store	$discard=, 96($8):p2align=4, $2
	i32.const	$push71=, 96
	i32.add 	$push72=, $8, $pop71
	call    	varargs4@FUNCTION, $4, $4, $4, $4, $4, $pop72
	i32.const	$push73=, 64
	i32.add 	$push74=, $8, $pop73
	i32.const	$push27=, 16
	i32.add 	$push24=, $pop74, $pop27
	i32.store	$discard=, 0($pop24):p2align=4, $4
	i64.store	$2=, 72($8), $3
	i64.store	$discard=, 64($8):p2align=4, $5
	i32.const	$push75=, 64
	i32.add 	$push76=, $8, $pop75
	call    	varargs5@FUNCTION, $4, $4, $4, $4, $4, $4, $pop76
	i64.store	$discard=, 56($8), $0
	i64.store	$discard=, 48($8):p2align=4, $1
	i32.const	$push77=, 48
	i32.add 	$push78=, $8, $pop77
	call    	varargs6@FUNCTION, $4, $4, $4, $4, $4, $4, $4, $pop78
	i32.store	$discard=, 40($8):p2align=3, $4
	i64.store	$discard=, 32($8):p2align=4, $2
	i32.const	$push79=, 32
	i32.add 	$push80=, $8, $pop79
	call    	varargs7@FUNCTION, $4, $4, $4, $4, $4, $4, $4, $4, $pop80
	i64.store	$discard=, 16($8):p2align=4, $0
	i32.const	$push81=, 16
	i32.add 	$push82=, $8, $pop81
	call    	varargs8@FUNCTION, $4, $4, $4, $4, $4, $4, $4, $4, $4, $pop82
	i32.store	$discard=, 0($8):p2align=4, $4
	call    	varargs9@FUNCTION, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $8
	block
	i32.const	$push26=, 0
	i32.load	$push25=, errors($pop26)
	br_if   	0, $pop25       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push36=, 0
	call    	exit@FUNCTION, $pop36
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push34=, __stack_pointer
	i32.load	$push35=, 0($pop34)
	i32.const	$push36=, 64
	i32.sub 	$6=, $pop35, $pop36
	i32.const	$push37=, __stack_pointer
	i32.store	$discard=, 0($pop37), $6
	i32.store	$discard=, 60($6), $1
	i32.load	$push27=, 60($6)
	tee_local	$push26=, $1=, $pop27
	i32.const	$push25=, 4
	i32.add 	$push1=, $pop26, $pop25
	i32.store	$discard=, 60($6), $pop1
	i32.load	$4=, 0($1)
	i32.const	$push2=, 8
	i32.add 	$push3=, $1, $pop2
	i32.store	$discard=, 60($6), $pop3
	i32.load	$5=, 4($1)
	i32.store	$discard=, 20($6), $4
	i32.store	$discard=, 24($6):p2align=3, $5
	i32.const	$push4=, 12
	i32.add 	$push5=, $1, $pop4
	i32.store	$discard=, 60($6), $pop5
	i32.load	$4=, 8($1)
	i32.const	$push6=, 16
	i32.add 	$push7=, $1, $pop6
	i32.store	$discard=, 60($6), $pop7
	i32.load	$5=, 12($1)
	i32.const	$push8=, 20
	i32.add 	$push9=, $1, $pop8
	i32.store	$discard=, 60($6), $pop9
	i32.load	$2=, 16($1)
	i32.const	$push10=, 24
	i32.add 	$push11=, $1, $pop10
	i32.store	$discard=, 60($6), $pop11
	i32.load	$3=, 20($1)
	i32.store	$discard=, 28($6), $4
	i32.store	$discard=, 32($6):p2align=4, $5
	i32.store	$discard=, 36($6), $2
	i32.store	$discard=, 40($6):p2align=3, $3
	i32.const	$push12=, 28
	i32.add 	$push13=, $1, $pop12
	i32.store	$discard=, 60($6), $pop13
	i32.load	$4=, 24($1)
	i32.const	$push14=, 32
	i32.add 	$push15=, $1, $pop14
	i32.store	$discard=, 60($6), $pop15
	i32.load	$5=, 28($1)
	i32.const	$push16=, 36
	i32.add 	$push17=, $1, $pop16
	i32.store	$discard=, 60($6), $pop17
	i32.load	$2=, 32($1)
	i32.const	$push18=, 40
	i32.add 	$push19=, $1, $pop18
	i32.store	$discard=, 60($6), $pop19
	i32.load	$1=, 36($1)
	i32.store	$discard=, 44($6), $4
	i32.store	$discard=, 48($6):p2align=4, $5
	i32.store	$discard=, 52($6), $2
	i32.store	$discard=, 56($6):p2align=3, $1
	i32.const	$push0=, 0
	i32.store	$2=, 16($6):p2align=4, $pop0
	i32.const	$push41=, 16
	i32.add 	$push42=, $6, $pop41
	i32.const	$push24=, 4
	i32.or  	$4=, $pop42, $pop24
	copy_local	$5=, $2
	copy_local	$1=, $2
.LBB1_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	block
	i32.eq  	$push20=, $1, $5
	br_if   	0, $pop20       # 0: down to label3
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.store	$3=, 12($6), $1
	i32.store	$discard=, 8($6):p2align=3, $5
	i32.store	$discard=, 4($6), $3
	i32.const	$push30=, .L.str
	i32.store	$discard=, 0($6):p2align=4, $pop30
	i32.const	$push29=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop29, $6
	i32.load	$push21=, errors($2)
	i32.const	$push28=, 1
	i32.add 	$push22=, $pop21, $pop28
	i32.store	$discard=, errors($2), $pop22
.LBB1_3:                                # %for.inc.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.const	$push31=, 10
	i32.eq  	$push23=, $1, $pop31
	br_if   	1, $pop23       # 1: down to label2
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$5=, 0($4)
	i32.const	$push33=, 1
	i32.add 	$1=, $1, $pop33
	i32.const	$push32=, 4
	i32.add 	$4=, $4, $pop32
	br      	0               # 0: up to label1
.LBB1_5:                                # %verify.exit
	end_loop                        # label2:
	i32.const	$push40=, __stack_pointer
	i32.const	$push38=, 64
	i32.add 	$push39=, $6, $pop38
	i32.store	$discard=, 0($pop40), $pop39
	return
	.endfunc
.Lfunc_end1:
	.size	varargs0, .Lfunc_end1-varargs0

	.section	.text.varargs1,"ax",@progbits
	.type	varargs1,@function
varargs1:                               # @varargs1
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push35=, __stack_pointer
	i32.load	$push36=, 0($pop35)
	i32.const	$push37=, 64
	i32.sub 	$7=, $pop36, $pop37
	i32.const	$push38=, __stack_pointer
	i32.store	$discard=, 0($pop38), $7
	i32.store	$push26=, 60($7), $2
	tee_local	$push25=, $2=, $pop26
	i32.const	$push24=, 4
	i32.add 	$push1=, $pop25, $pop24
	i32.store	$discard=, 60($7), $pop1
	i32.load	$push2=, 0($2)
	i32.store	$discard=, 24($7):p2align=3, $pop2
	i32.const	$push3=, 8
	i32.add 	$push4=, $2, $pop3
	i32.store	$discard=, 60($7), $pop4
	i32.load	$5=, 4($2)
	i32.const	$push5=, 12
	i32.add 	$push6=, $2, $pop5
	i32.store	$discard=, 60($7), $pop6
	i32.load	$6=, 8($2)
	i32.const	$push7=, 16
	i32.add 	$push8=, $2, $pop7
	i32.store	$discard=, 60($7), $pop8
	i32.load	$4=, 12($2)
	i32.const	$push9=, 20
	i32.add 	$push10=, $2, $pop9
	i32.store	$discard=, 60($7), $pop10
	i32.load	$3=, 16($2)
	i32.store	$discard=, 28($7), $5
	i32.store	$discard=, 32($7):p2align=4, $6
	i32.store	$discard=, 36($7), $4
	i32.store	$discard=, 40($7):p2align=3, $3
	i32.const	$push11=, 24
	i32.add 	$push12=, $2, $pop11
	i32.store	$discard=, 60($7), $pop12
	i32.load	$5=, 20($2)
	i32.const	$push13=, 28
	i32.add 	$push14=, $2, $pop13
	i32.store	$discard=, 60($7), $pop14
	i32.load	$6=, 24($2)
	i32.const	$push15=, 32
	i32.add 	$push16=, $2, $pop15
	i32.store	$discard=, 60($7), $pop16
	i32.load	$4=, 28($2)
	i32.const	$push17=, 36
	i32.add 	$push18=, $2, $pop17
	i32.store	$discard=, 60($7), $pop18
	i32.load	$2=, 32($2)
	i32.store	$discard=, 44($7), $5
	i32.store	$discard=, 48($7):p2align=4, $6
	i32.store	$discard=, 52($7), $4
	i32.store	$discard=, 56($7):p2align=3, $2
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($7):p2align=4, $pop0
	i32.const	$push42=, 16
	i32.add 	$push43=, $7, $pop42
	i32.const	$push23=, 4
	i32.or  	$5=, $pop43, $pop23
	i32.const	$6=, 0
	i32.const	$2=, 0
.LBB2_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	block
	i32.eq  	$push19=, $2, $6
	br_if   	0, $pop19       # 0: down to label6
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.store	$4=, 12($7), $2
	i32.store	$discard=, 8($7):p2align=3, $6
	i32.store	$discard=, 4($7), $4
	i32.const	$push31=, .L.str.2
	i32.store	$discard=, 0($7):p2align=4, $pop31
	i32.const	$push30=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop30, $7
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i32.load	$push20=, errors($pop28)
	i32.const	$push27=, 1
	i32.add 	$push21=, $pop20, $pop27
	i32.store	$discard=, errors($pop29), $pop21
.LBB2_3:                                # %for.inc.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label6:
	i32.const	$push32=, 10
	i32.eq  	$push22=, $2, $pop32
	br_if   	1, $pop22       # 1: down to label5
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load	$6=, 0($5)
	i32.const	$push34=, 1
	i32.add 	$2=, $2, $pop34
	i32.const	$push33=, 4
	i32.add 	$5=, $5, $pop33
	br      	0               # 0: up to label4
.LBB2_5:                                # %verify.exit
	end_loop                        # label5:
	i32.const	$push41=, __stack_pointer
	i32.const	$push39=, 64
	i32.add 	$push40=, $7, $pop39
	i32.store	$discard=, 0($pop41), $pop40
	return
	.endfunc
.Lfunc_end2:
	.size	varargs1, .Lfunc_end2-varargs1

	.section	.text.varargs2,"ax",@progbits
	.type	varargs2,@function
varargs2:                               # @varargs2
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push33=, __stack_pointer
	i32.load	$push34=, 0($pop33)
	i32.const	$push35=, 64
	i32.sub 	$8=, $pop34, $pop35
	i32.const	$push36=, __stack_pointer
	i32.store	$discard=, 0($pop36), $8
	i32.const	$push1=, 2
	i32.store	$discard=, 24($8):p2align=3, $pop1
	i32.store	$push24=, 60($8), $3
	tee_local	$push23=, $3=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push2=, $pop23, $pop22
	i32.store	$discard=, 60($8), $pop2
	i32.load	$6=, 0($3)
	i32.const	$push3=, 8
	i32.add 	$push4=, $3, $pop3
	i32.store	$discard=, 60($8), $pop4
	i32.load	$7=, 4($3)
	i32.const	$push5=, 12
	i32.add 	$push6=, $3, $pop5
	i32.store	$discard=, 60($8), $pop6
	i32.load	$5=, 8($3)
	i32.const	$push7=, 16
	i32.add 	$push8=, $3, $pop7
	i32.store	$discard=, 60($8), $pop8
	i32.load	$4=, 12($3)
	i32.store	$discard=, 28($8), $6
	i32.store	$discard=, 32($8):p2align=4, $7
	i32.store	$discard=, 36($8), $5
	i32.store	$discard=, 40($8):p2align=3, $4
	i32.const	$push9=, 20
	i32.add 	$push10=, $3, $pop9
	i32.store	$discard=, 60($8), $pop10
	i32.load	$6=, 16($3)
	i32.const	$push11=, 24
	i32.add 	$push12=, $3, $pop11
	i32.store	$discard=, 60($8), $pop12
	i32.load	$7=, 20($3)
	i32.const	$push13=, 28
	i32.add 	$push14=, $3, $pop13
	i32.store	$discard=, 60($8), $pop14
	i32.load	$5=, 24($3)
	i32.const	$push15=, 32
	i32.add 	$push16=, $3, $pop15
	i32.store	$discard=, 60($8), $pop16
	i32.load	$3=, 28($3)
	i32.store	$discard=, 44($8), $6
	i32.store	$discard=, 48($8):p2align=4, $7
	i32.store	$discard=, 52($8), $5
	i32.store	$discard=, 56($8):p2align=3, $3
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($8):p2align=4, $pop0
	i32.const	$push40=, 16
	i32.add 	$push41=, $8, $pop40
	i32.const	$push21=, 4
	i32.or  	$6=, $pop41, $pop21
	i32.const	$7=, 0
	i32.const	$3=, 0
.LBB3_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	block
	i32.eq  	$push17=, $3, $7
	br_if   	0, $pop17       # 0: down to label9
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.store	$5=, 12($8), $3
	i32.store	$discard=, 8($8):p2align=3, $7
	i32.store	$discard=, 4($8), $5
	i32.const	$push29=, .L.str.3
	i32.store	$discard=, 0($8):p2align=4, $pop29
	i32.const	$push28=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop28, $8
	i32.const	$push27=, 0
	i32.const	$push26=, 0
	i32.load	$push18=, errors($pop26)
	i32.const	$push25=, 1
	i32.add 	$push19=, $pop18, $pop25
	i32.store	$discard=, errors($pop27), $pop19
.LBB3_3:                                # %for.inc.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_block                       # label9:
	i32.const	$push30=, 10
	i32.eq  	$push20=, $3, $pop30
	br_if   	1, $pop20       # 1: down to label8
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.load	$7=, 0($6)
	i32.const	$push32=, 1
	i32.add 	$3=, $3, $pop32
	i32.const	$push31=, 4
	i32.add 	$6=, $6, $pop31
	br      	0               # 0: up to label7
.LBB3_5:                                # %verify.exit
	end_loop                        # label8:
	i32.const	$push39=, __stack_pointer
	i32.const	$push37=, 64
	i32.add 	$push38=, $8, $pop37
	i32.store	$discard=, 0($pop39), $pop38
	return
	.endfunc
.Lfunc_end3:
	.size	varargs2, .Lfunc_end3-varargs2

	.section	.text.varargs3,"ax",@progbits
	.type	varargs3,@function
varargs3:                               # @varargs3
	.param  	i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push32=, __stack_pointer
	i32.load	$push33=, 0($pop32)
	i32.const	$push34=, 64
	i32.sub 	$8=, $pop33, $pop34
	i32.const	$push35=, __stack_pointer
	i32.store	$discard=, 0($pop35), $8
	i32.const	$push1=, 2
	i32.store	$discard=, 24($8):p2align=3, $pop1
	i32.store	$push23=, 60($8), $4
	tee_local	$push22=, $4=, $pop23
	i32.const	$push21=, 4
	i32.add 	$push3=, $pop22, $pop21
	i32.store	$discard=, 60($8), $pop3
	i32.load	$6=, 0($4)
	i32.const	$push4=, 8
	i32.add 	$push5=, $4, $pop4
	i32.store	$discard=, 60($8), $pop5
	i32.load	$7=, 4($4)
	i32.const	$push6=, 12
	i32.add 	$push7=, $4, $pop6
	i32.store	$discard=, 60($8), $pop7
	i32.load	$5=, 8($4)
	i32.const	$push2=, 3
	i32.store	$discard=, 28($8), $pop2
	i32.store	$discard=, 32($8):p2align=4, $6
	i32.store	$discard=, 36($8), $7
	i32.store	$discard=, 40($8):p2align=3, $5
	i32.const	$push8=, 16
	i32.add 	$push9=, $4, $pop8
	i32.store	$discard=, 60($8), $pop9
	i32.load	$6=, 12($4)
	i32.const	$push10=, 20
	i32.add 	$push11=, $4, $pop10
	i32.store	$discard=, 60($8), $pop11
	i32.load	$7=, 16($4)
	i32.const	$push12=, 24
	i32.add 	$push13=, $4, $pop12
	i32.store	$discard=, 60($8), $pop13
	i32.load	$5=, 20($4)
	i32.const	$push14=, 28
	i32.add 	$push15=, $4, $pop14
	i32.store	$discard=, 60($8), $pop15
	i32.load	$4=, 24($4)
	i32.store	$discard=, 44($8), $6
	i32.store	$discard=, 48($8):p2align=4, $7
	i32.store	$discard=, 52($8), $5
	i32.store	$discard=, 56($8):p2align=3, $4
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($8):p2align=4, $pop0
	i32.const	$push39=, 16
	i32.add 	$push40=, $8, $pop39
	i32.const	$push20=, 4
	i32.or  	$6=, $pop40, $pop20
	i32.const	$7=, 0
	i32.const	$4=, 0
.LBB4_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	block
	i32.eq  	$push16=, $4, $7
	br_if   	0, $pop16       # 0: down to label12
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB4_1 Depth=1
	i32.store	$5=, 12($8), $4
	i32.store	$discard=, 8($8):p2align=3, $7
	i32.store	$discard=, 4($8), $5
	i32.const	$push28=, .L.str.4
	i32.store	$discard=, 0($8):p2align=4, $pop28
	i32.const	$push27=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop27, $8
	i32.const	$push26=, 0
	i32.const	$push25=, 0
	i32.load	$push17=, errors($pop25)
	i32.const	$push24=, 1
	i32.add 	$push18=, $pop17, $pop24
	i32.store	$discard=, errors($pop26), $pop18
.LBB4_3:                                # %for.inc.i
                                        #   in Loop: Header=BB4_1 Depth=1
	end_block                       # label12:
	i32.const	$push29=, 10
	i32.eq  	$push19=, $4, $pop29
	br_if   	1, $pop19       # 1: down to label11
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB4_1 Depth=1
	i32.load	$7=, 0($6)
	i32.const	$push31=, 1
	i32.add 	$4=, $4, $pop31
	i32.const	$push30=, 4
	i32.add 	$6=, $6, $pop30
	br      	0               # 0: up to label10
.LBB4_5:                                # %verify.exit
	end_loop                        # label11:
	i32.const	$push38=, __stack_pointer
	i32.const	$push36=, 64
	i32.add 	$push37=, $8, $pop36
	i32.store	$discard=, 0($pop38), $pop37
	return
	.endfunc
.Lfunc_end4:
	.size	varargs3, .Lfunc_end4-varargs3

	.section	.text.varargs4,"ax",@progbits
	.type	varargs4,@function
varargs4:                               # @varargs4
	.param  	i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push30=, __stack_pointer
	i32.load	$push31=, 0($pop30)
	i32.const	$push32=, 64
	i32.sub 	$10=, $pop31, $pop32
	i32.const	$push33=, __stack_pointer
	i32.store	$discard=, 0($pop33), $10
	i32.store	$push22=, 60($10), $5
	tee_local	$push21=, $5=, $pop22
	i32.const	$push1=, 4
	i32.store	$push20=, 32($10):p2align=4, $pop1
	tee_local	$push19=, $9=, $pop20
	i32.add 	$push3=, $pop21, $pop19
	i32.store	$discard=, 60($10), $pop3
	i32.load	$7=, 0($5)
	i32.const	$push4=, 8
	i32.add 	$push5=, $5, $pop4
	i32.store	$discard=, 60($10), $pop5
	i32.load	$8=, 4($5)
	i32.store	$discard=, 36($10), $7
	i32.store	$discard=, 40($10):p2align=3, $8
	i32.const	$push6=, 12
	i32.add 	$push7=, $5, $pop6
	i32.store	$discard=, 60($10), $pop7
	i32.load	$7=, 8($5)
	i32.const	$push8=, 16
	i32.add 	$push9=, $5, $pop8
	i32.store	$discard=, 60($10), $pop9
	i32.load	$8=, 12($5)
	i32.const	$push10=, 20
	i32.add 	$push11=, $5, $pop10
	i32.store	$discard=, 60($10), $pop11
	i32.load	$6=, 16($5)
	i32.const	$push12=, 24
	i32.add 	$push13=, $5, $pop12
	i32.store	$discard=, 60($10), $pop13
	i32.load	$5=, 20($5)
	i32.store	$discard=, 44($10), $7
	i32.store	$discard=, 48($10):p2align=4, $8
	i32.store	$discard=, 52($10), $6
	i32.store	$discard=, 56($10):p2align=3, $5
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($10):p2align=4, $pop0
	i64.const	$push2=, 12884901890
	i64.store	$discard=, 24($10), $pop2
	i32.const	$push37=, 16
	i32.add 	$push38=, $10, $pop37
	i32.const	$push18=, 4
	i32.or  	$7=, $pop38, $pop18
	i32.const	$8=, 0
	i32.const	$5=, 0
.LBB5_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label13:
	block
	i32.eq  	$push14=, $5, $8
	br_if   	0, $pop14       # 0: down to label15
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB5_1 Depth=1
	i32.store	$6=, 12($10), $5
	i32.store	$discard=, 8($10):p2align=3, $8
	i32.store	$discard=, 4($10), $6
	i32.const	$push27=, .L.str.5
	i32.store	$discard=, 0($10):p2align=4, $pop27
	i32.const	$push26=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop26, $10
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	i32.load	$push15=, errors($pop24)
	i32.const	$push23=, 1
	i32.add 	$push16=, $pop15, $pop23
	i32.store	$discard=, errors($pop25), $pop16
.LBB5_3:                                # %for.inc.i
                                        #   in Loop: Header=BB5_1 Depth=1
	end_block                       # label15:
	i32.const	$push28=, 10
	i32.eq  	$push17=, $5, $pop28
	br_if   	1, $pop17       # 1: down to label14
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB5_1 Depth=1
	i32.load	$8=, 0($7)
	i32.const	$push29=, 1
	i32.add 	$5=, $5, $pop29
	i32.add 	$7=, $7, $9
	br      	0               # 0: up to label13
.LBB5_5:                                # %verify.exit
	end_loop                        # label14:
	i32.const	$push36=, __stack_pointer
	i32.const	$push34=, 64
	i32.add 	$push35=, $10, $pop34
	i32.store	$discard=, 0($pop36), $pop35
	return
	.endfunc
.Lfunc_end5:
	.size	varargs4, .Lfunc_end5-varargs4

	.section	.text.varargs5,"ax",@progbits
	.type	varargs5,@function
varargs5:                               # @varargs5
	.param  	i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push29=, __stack_pointer
	i32.load	$push30=, 0($pop29)
	i32.const	$push31=, 64
	i32.sub 	$10=, $pop30, $pop31
	i32.const	$push32=, __stack_pointer
	i32.store	$discard=, 0($pop32), $10
	i32.store	$push20=, 60($10), $6
	tee_local	$push19=, $6=, $pop20
	i32.const	$push18=, 4
	i32.add 	$push3=, $pop19, $pop18
	i32.store	$discard=, 60($10), $pop3
	i32.load	$push4=, 0($6)
	i32.store	$discard=, 40($10):p2align=3, $pop4
	i32.const	$push5=, 8
	i32.add 	$push6=, $6, $pop5
	i32.store	$discard=, 60($10), $pop6
	i32.load	$8=, 4($6)
	i32.const	$push7=, 12
	i32.add 	$push8=, $6, $pop7
	i32.store	$discard=, 60($10), $pop8
	i32.load	$9=, 8($6)
	i32.const	$push9=, 16
	i32.add 	$push10=, $6, $pop9
	i32.store	$discard=, 60($10), $pop10
	i32.load	$7=, 12($6)
	i32.const	$push11=, 20
	i32.add 	$push12=, $6, $pop11
	i32.store	$discard=, 60($10), $pop12
	i32.load	$6=, 16($6)
	i32.store	$discard=, 44($10), $8
	i32.store	$discard=, 48($10):p2align=4, $9
	i32.store	$discard=, 52($10), $7
	i32.store	$discard=, 56($10):p2align=3, $6
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($10):p2align=4, $pop0
	i64.const	$push1=, 12884901890
	i64.store	$discard=, 24($10), $pop1
	i64.const	$push2=, 21474836484
	i64.store	$discard=, 32($10):p2align=4, $pop2
	i32.const	$push36=, 16
	i32.add 	$push37=, $10, $pop36
	i32.const	$push17=, 4
	i32.or  	$8=, $pop37, $pop17
	i32.const	$9=, 0
	i32.const	$6=, 0
.LBB6_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label16:
	block
	i32.eq  	$push13=, $6, $9
	br_if   	0, $pop13       # 0: down to label18
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB6_1 Depth=1
	i32.store	$7=, 12($10), $6
	i32.store	$discard=, 8($10):p2align=3, $9
	i32.store	$discard=, 4($10), $7
	i32.const	$push25=, .L.str.6
	i32.store	$discard=, 0($10):p2align=4, $pop25
	i32.const	$push24=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop24, $10
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.load	$push14=, errors($pop22)
	i32.const	$push21=, 1
	i32.add 	$push15=, $pop14, $pop21
	i32.store	$discard=, errors($pop23), $pop15
.LBB6_3:                                # %for.inc.i
                                        #   in Loop: Header=BB6_1 Depth=1
	end_block                       # label18:
	i32.const	$push26=, 10
	i32.eq  	$push16=, $6, $pop26
	br_if   	1, $pop16       # 1: down to label17
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB6_1 Depth=1
	i32.load	$9=, 0($8)
	i32.const	$push28=, 1
	i32.add 	$6=, $6, $pop28
	i32.const	$push27=, 4
	i32.add 	$8=, $8, $pop27
	br      	0               # 0: up to label16
.LBB6_5:                                # %verify.exit
	end_loop                        # label17:
	i32.const	$push35=, __stack_pointer
	i32.const	$push33=, 64
	i32.add 	$push34=, $10, $pop33
	i32.store	$discard=, 0($pop35), $pop34
	return
	.endfunc
.Lfunc_end6:
	.size	varargs5, .Lfunc_end6-varargs5

	.section	.text.varargs6,"ax",@progbits
	.type	varargs6,@function
varargs6:                               # @varargs6
	.param  	i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push25=, __stack_pointer
	i32.load	$push26=, 0($pop25)
	i32.const	$push27=, 64
	i32.sub 	$11=, $pop26, $pop27
	i32.const	$push28=, __stack_pointer
	i32.store	$discard=, 0($pop28), $11
	i32.store	$discard=, 60($11), $7
	i32.load	$7=, 60($11)
	i32.const	$push3=, 6
	i32.store	$discard=, 40($11):p2align=3, $pop3
	i32.const	$push16=, 4
	i32.add 	$push4=, $7, $pop16
	i32.store	$discard=, 60($11), $pop4
	i32.load	$9=, 0($7)
	i32.const	$push5=, 8
	i32.add 	$push6=, $7, $pop5
	i32.store	$discard=, 60($11), $pop6
	i32.load	$10=, 4($7)
	i32.const	$push7=, 12
	i32.add 	$push8=, $7, $pop7
	i32.store	$discard=, 60($11), $pop8
	i32.load	$8=, 8($7)
	i32.const	$push9=, 16
	i32.add 	$push10=, $7, $pop9
	i32.store	$discard=, 60($11), $pop10
	i32.load	$7=, 12($7)
	i32.store	$discard=, 44($11), $9
	i32.store	$discard=, 48($11):p2align=4, $10
	i32.store	$discard=, 52($11), $8
	i32.store	$discard=, 56($11):p2align=3, $7
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($11):p2align=4, $pop0
	i64.const	$push1=, 12884901890
	i64.store	$discard=, 24($11), $pop1
	i64.const	$push2=, 21474836484
	i64.store	$discard=, 32($11):p2align=4, $pop2
	i32.const	$push32=, 16
	i32.add 	$push33=, $11, $pop32
	i32.const	$push15=, 4
	i32.or  	$9=, $pop33, $pop15
	i32.const	$10=, 0
	i32.const	$7=, 0
.LBB7_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label19:
	block
	i32.eq  	$push11=, $7, $10
	br_if   	0, $pop11       # 0: down to label21
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB7_1 Depth=1
	i32.store	$8=, 12($11), $7
	i32.store	$discard=, 8($11):p2align=3, $10
	i32.store	$discard=, 4($11), $8
	i32.const	$push21=, .L.str.7
	i32.store	$discard=, 0($11):p2align=4, $pop21
	i32.const	$push20=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop20, $11
	i32.const	$push19=, 0
	i32.const	$push18=, 0
	i32.load	$push12=, errors($pop18)
	i32.const	$push17=, 1
	i32.add 	$push13=, $pop12, $pop17
	i32.store	$discard=, errors($pop19), $pop13
.LBB7_3:                                # %for.inc.i
                                        #   in Loop: Header=BB7_1 Depth=1
	end_block                       # label21:
	i32.const	$push22=, 10
	i32.eq  	$push14=, $7, $pop22
	br_if   	1, $pop14       # 1: down to label20
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB7_1 Depth=1
	i32.load	$10=, 0($9)
	i32.const	$push24=, 1
	i32.add 	$7=, $7, $pop24
	i32.const	$push23=, 4
	i32.add 	$9=, $9, $pop23
	br      	0               # 0: up to label19
.LBB7_5:                                # %verify.exit
	end_loop                        # label20:
	i32.const	$push31=, __stack_pointer
	i32.const	$push29=, 64
	i32.add 	$push30=, $11, $pop29
	i32.store	$discard=, 0($pop31), $pop30
	return
	.endfunc
.Lfunc_end7:
	.size	varargs6, .Lfunc_end7-varargs6

	.section	.text.varargs7,"ax",@progbits
	.type	varargs7,@function
varargs7:                               # @varargs7
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push25=, __stack_pointer
	i32.load	$push26=, 0($pop25)
	i32.const	$push27=, 64
	i32.sub 	$12=, $pop26, $pop27
	i32.const	$push28=, __stack_pointer
	i32.store	$discard=, 0($pop28), $12
	i32.store	$discard=, 60($12), $8
	i32.load	$push16=, 60($12)
	tee_local	$push15=, $8=, $pop16
	i32.const	$push14=, 4
	i32.add 	$push4=, $pop15, $pop14
	i32.store	$discard=, 60($12), $pop4
	i32.load	$10=, 0($8)
	i32.const	$push5=, 8
	i32.add 	$push6=, $8, $pop5
	i32.store	$discard=, 60($12), $pop6
	i32.load	$11=, 4($8)
	i32.const	$push7=, 12
	i32.add 	$push8=, $8, $pop7
	i32.store	$discard=, 60($12), $pop8
	i32.load	$8=, 8($8)
	i32.store	$discard=, 48($12):p2align=4, $10
	i32.store	$discard=, 52($12), $11
	i32.store	$discard=, 56($12):p2align=3, $8
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($12):p2align=4, $pop0
	i64.const	$push1=, 12884901890
	i64.store	$discard=, 24($12), $pop1
	i64.const	$push2=, 21474836484
	i64.store	$discard=, 32($12):p2align=4, $pop2
	i64.const	$push3=, 30064771078
	i64.store	$discard=, 40($12), $pop3
	i32.const	$push32=, 16
	i32.add 	$push33=, $12, $pop32
	i32.const	$push13=, 4
	i32.or  	$10=, $pop33, $pop13
	i32.const	$11=, 0
	i32.const	$8=, 0
.LBB8_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label22:
	block
	i32.eq  	$push9=, $8, $11
	br_if   	0, $pop9        # 0: down to label24
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB8_1 Depth=1
	i32.store	$9=, 12($12), $8
	i32.store	$discard=, 8($12):p2align=3, $11
	i32.store	$discard=, 4($12), $9
	i32.const	$push21=, .L.str.8
	i32.store	$discard=, 0($12):p2align=4, $pop21
	i32.const	$push20=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop20, $12
	i32.const	$push19=, 0
	i32.const	$push18=, 0
	i32.load	$push10=, errors($pop18)
	i32.const	$push17=, 1
	i32.add 	$push11=, $pop10, $pop17
	i32.store	$discard=, errors($pop19), $pop11
.LBB8_3:                                # %for.inc.i
                                        #   in Loop: Header=BB8_1 Depth=1
	end_block                       # label24:
	i32.const	$push22=, 10
	i32.eq  	$push12=, $8, $pop22
	br_if   	1, $pop12       # 1: down to label23
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB8_1 Depth=1
	i32.load	$11=, 0($10)
	i32.const	$push24=, 1
	i32.add 	$8=, $8, $pop24
	i32.const	$push23=, 4
	i32.add 	$10=, $10, $pop23
	br      	0               # 0: up to label22
.LBB8_5:                                # %verify.exit
	end_loop                        # label23:
	i32.const	$push31=, __stack_pointer
	i32.const	$push29=, 64
	i32.add 	$push30=, $12, $pop29
	i32.store	$discard=, 0($pop31), $pop30
	return
	.endfunc
.Lfunc_end8:
	.size	varargs7, .Lfunc_end8-varargs7

	.section	.text.varargs8,"ax",@progbits
	.type	varargs8,@function
varargs8:                               # @varargs8
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push23=, __stack_pointer
	i32.load	$push24=, 0($pop23)
	i32.const	$push25=, 64
	i32.sub 	$13=, $pop24, $pop25
	i32.const	$push26=, __stack_pointer
	i32.store	$discard=, 0($pop26), $13
	i32.store	$discard=, 60($13), $9
	i32.load	$push14=, 60($13)
	tee_local	$push13=, $9=, $pop14
	i32.const	$push12=, 4
	i32.add 	$push5=, $pop13, $pop12
	i32.store	$discard=, 60($13), $pop5
	i32.const	$push4=, 8
	i32.store	$11=, 48($13):p2align=4, $pop4
	i32.load	$12=, 0($9)
	i32.add 	$push6=, $9, $11
	i32.store	$discard=, 60($13), $pop6
	i32.load	$9=, 4($9)
	i32.store	$discard=, 52($13), $12
	i32.store	$discard=, 56($13):p2align=3, $9
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($13):p2align=4, $pop0
	i64.const	$push1=, 12884901890
	i64.store	$discard=, 24($13), $pop1
	i64.const	$push2=, 21474836484
	i64.store	$discard=, 32($13):p2align=4, $pop2
	i64.const	$push3=, 30064771078
	i64.store	$discard=, 40($13), $pop3
	i32.const	$push30=, 16
	i32.add 	$push31=, $13, $pop30
	i32.const	$push11=, 4
	i32.or  	$11=, $pop31, $pop11
	i32.const	$12=, 0
	i32.const	$9=, 0
.LBB9_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label25:
	block
	i32.eq  	$push7=, $9, $12
	br_if   	0, $pop7        # 0: down to label27
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB9_1 Depth=1
	i32.store	$10=, 12($13), $9
	i32.store	$discard=, 8($13):p2align=3, $12
	i32.store	$discard=, 4($13), $10
	i32.const	$push19=, .L.str.9
	i32.store	$discard=, 0($13):p2align=4, $pop19
	i32.const	$push18=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop18, $13
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.load	$push8=, errors($pop16)
	i32.const	$push15=, 1
	i32.add 	$push9=, $pop8, $pop15
	i32.store	$discard=, errors($pop17), $pop9
.LBB9_3:                                # %for.inc.i
                                        #   in Loop: Header=BB9_1 Depth=1
	end_block                       # label27:
	i32.const	$push20=, 10
	i32.eq  	$push10=, $9, $pop20
	br_if   	1, $pop10       # 1: down to label26
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB9_1 Depth=1
	i32.load	$12=, 0($11)
	i32.const	$push22=, 1
	i32.add 	$9=, $9, $pop22
	i32.const	$push21=, 4
	i32.add 	$11=, $11, $pop21
	br      	0               # 0: up to label25
.LBB9_5:                                # %verify.exit
	end_loop                        # label26:
	i32.const	$push29=, __stack_pointer
	i32.const	$push27=, 64
	i32.add 	$push28=, $13, $pop27
	i32.store	$discard=, 0($pop29), $pop28
	return
	.endfunc
.Lfunc_end9:
	.size	varargs8, .Lfunc_end9-varargs8

	.section	.text.varargs9,"ax",@progbits
	.type	varargs9,@function
varargs9:                               # @varargs9
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push23=, __stack_pointer
	i32.load	$push24=, 0($pop23)
	i32.const	$push25=, 64
	i32.sub 	$14=, $pop24, $pop25
	i32.const	$push26=, __stack_pointer
	i32.store	$discard=, 0($pop26), $14
	i32.store	$discard=, 60($14), $10
	i32.load	$push14=, 60($14)
	tee_local	$push13=, $10=, $pop14
	i32.const	$push12=, 4
	i32.add 	$push5=, $pop13, $pop12
	i32.store	$discard=, 60($14), $pop5
	i32.load	$push6=, 0($10)
	i32.store	$discard=, 56($14):p2align=3, $pop6
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 16($14):p2align=4, $pop0
	i64.const	$push1=, 12884901890
	i64.store	$discard=, 24($14), $pop1
	i64.const	$push2=, 21474836484
	i64.store	$discard=, 32($14):p2align=4, $pop2
	i64.const	$push3=, 30064771078
	i64.store	$discard=, 40($14), $pop3
	i64.const	$push4=, 38654705672
	i64.store	$discard=, 48($14):p2align=4, $pop4
	i32.const	$push30=, 16
	i32.add 	$push31=, $14, $pop30
	i32.const	$push11=, 4
	i32.or  	$12=, $pop31, $pop11
	i32.const	$13=, 0
	i32.const	$10=, 0
.LBB10_1:                               # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label28:
	block
	i32.eq  	$push7=, $10, $13
	br_if   	0, $pop7        # 0: down to label30
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB10_1 Depth=1
	i32.store	$11=, 12($14), $10
	i32.store	$discard=, 8($14):p2align=3, $13
	i32.store	$discard=, 4($14), $11
	i32.const	$push19=, .L.str.10
	i32.store	$discard=, 0($14):p2align=4, $pop19
	i32.const	$push18=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop18, $14
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.load	$push8=, errors($pop16)
	i32.const	$push15=, 1
	i32.add 	$push9=, $pop8, $pop15
	i32.store	$discard=, errors($pop17), $pop9
.LBB10_3:                               # %for.inc.i
                                        #   in Loop: Header=BB10_1 Depth=1
	end_block                       # label30:
	i32.const	$push20=, 10
	i32.eq  	$push10=, $10, $pop20
	br_if   	1, $pop10       # 1: down to label29
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB10_1 Depth=1
	i32.load	$13=, 0($12)
	i32.const	$push22=, 1
	i32.add 	$10=, $10, $pop22
	i32.const	$push21=, 4
	i32.add 	$12=, $12, $pop21
	br      	0               # 0: up to label28
.LBB10_5:                               # %verify.exit
	end_loop                        # label29:
	i32.const	$push29=, __stack_pointer
	i32.const	$push27=, 64
	i32.add 	$push28=, $14, $pop27
	i32.store	$discard=, 0($pop29), $pop28
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
