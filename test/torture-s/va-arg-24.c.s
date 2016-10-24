	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-24.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push29=, 0
	i32.const	$push26=, 0
	i32.load	$push27=, __stack_pointer($pop26)
	i32.const	$push28=, 288
	i32.sub 	$push103=, $pop27, $pop28
	tee_local	$push102=, $0=, $pop103
	i32.store	__stack_pointer($pop29), $pop102
	i32.const	$push30=, 240
	i32.add 	$push31=, $0, $pop30
	i32.const	$push0=, 32
	i32.add 	$push1=, $pop31, $pop0
	i64.const	$push2=, 42949672969
	i64.store	0($pop1), $pop2
	i32.const	$push32=, 240
	i32.add 	$push33=, $0, $pop32
	i32.const	$push3=, 24
	i32.add 	$push4=, $pop33, $pop3
	i64.const	$push5=, 34359738375
	i64.store	0($pop4), $pop5
	i32.const	$push34=, 240
	i32.add 	$push35=, $0, $pop34
	i32.const	$push6=, 16
	i32.add 	$push7=, $pop35, $pop6
	i64.const	$push8=, 25769803781
	i64.store	0($pop7), $pop8
	i64.const	$push9=, 17179869187
	i64.store	248($0), $pop9
	i64.const	$push10=, 8589934593
	i64.store	240($0), $pop10
	i32.const	$push36=, 240
	i32.add 	$push37=, $0, $pop36
	call    	varargs0@FUNCTION, $0, $pop37
	i32.const	$push38=, 192
	i32.add 	$push39=, $0, $pop38
	i32.const	$push101=, 32
	i32.add 	$push11=, $pop39, $pop101
	i32.const	$push12=, 10
	i32.store	0($pop11), $pop12
	i32.const	$push40=, 192
	i32.add 	$push41=, $0, $pop40
	i32.const	$push100=, 24
	i32.add 	$push13=, $pop41, $pop100
	i64.const	$push14=, 38654705672
	i64.store	0($pop13), $pop14
	i32.const	$push42=, 192
	i32.add 	$push43=, $0, $pop42
	i32.const	$push99=, 16
	i32.add 	$push15=, $pop43, $pop99
	i64.const	$push16=, 30064771078
	i64.store	0($pop15), $pop16
	i64.const	$push17=, 21474836484
	i64.store	200($0), $pop17
	i64.const	$push18=, 12884901890
	i64.store	192($0), $pop18
	i32.const	$push44=, 192
	i32.add 	$push45=, $0, $pop44
	call    	varargs1@FUNCTION, $0, $0, $pop45
	i32.const	$push46=, 160
	i32.add 	$push47=, $0, $pop46
	i32.const	$push98=, 24
	i32.add 	$push19=, $pop47, $pop98
	i64.const	$push97=, 42949672969
	i64.store	0($pop19), $pop97
	i32.const	$push48=, 160
	i32.add 	$push49=, $0, $pop48
	i32.const	$push96=, 16
	i32.add 	$push20=, $pop49, $pop96
	i64.const	$push95=, 34359738375
	i64.store	0($pop20), $pop95
	i64.const	$push94=, 25769803781
	i64.store	168($0), $pop94
	i64.const	$push93=, 17179869187
	i64.store	160($0), $pop93
	i32.const	$push50=, 160
	i32.add 	$push51=, $0, $pop50
	call    	varargs2@FUNCTION, $0, $0, $0, $pop51
	i32.const	$push52=, 128
	i32.add 	$push53=, $0, $pop52
	i32.const	$push92=, 24
	i32.add 	$push21=, $pop53, $pop92
	i32.const	$push91=, 10
	i32.store	0($pop21), $pop91
	i32.const	$push54=, 128
	i32.add 	$push55=, $0, $pop54
	i32.const	$push90=, 16
	i32.add 	$push22=, $pop55, $pop90
	i64.const	$push89=, 38654705672
	i64.store	0($pop22), $pop89
	i64.const	$push88=, 30064771078
	i64.store	136($0), $pop88
	i64.const	$push87=, 21474836484
	i64.store	128($0), $pop87
	i32.const	$push56=, 128
	i32.add 	$push57=, $0, $pop56
	call    	varargs3@FUNCTION, $0, $0, $0, $0, $pop57
	i32.const	$push58=, 96
	i32.add 	$push59=, $0, $pop58
	i32.const	$push86=, 16
	i32.add 	$push23=, $pop59, $pop86
	i64.const	$push85=, 42949672969
	i64.store	0($pop23), $pop85
	i64.const	$push84=, 34359738375
	i64.store	104($0), $pop84
	i64.const	$push83=, 25769803781
	i64.store	96($0), $pop83
	i32.const	$push60=, 96
	i32.add 	$push61=, $0, $pop60
	call    	varargs4@FUNCTION, $0, $0, $0, $0, $0, $pop61
	i32.const	$push62=, 64
	i32.add 	$push63=, $0, $pop62
	i32.const	$push82=, 16
	i32.add 	$push24=, $pop63, $pop82
	i32.const	$push81=, 10
	i32.store	0($pop24), $pop81
	i64.const	$push80=, 38654705672
	i64.store	72($0), $pop80
	i64.const	$push79=, 30064771078
	i64.store	64($0), $pop79
	i32.const	$push64=, 64
	i32.add 	$push65=, $0, $pop64
	call    	varargs5@FUNCTION, $0, $0, $0, $0, $0, $0, $pop65
	i64.const	$push78=, 42949672969
	i64.store	56($0), $pop78
	i64.const	$push77=, 34359738375
	i64.store	48($0), $pop77
	i32.const	$push66=, 48
	i32.add 	$push67=, $0, $pop66
	call    	varargs6@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $pop67
	i32.const	$push76=, 10
	i32.store	40($0), $pop76
	i64.const	$push75=, 38654705672
	i64.store	32($0), $pop75
	i32.const	$push68=, 32
	i32.add 	$push69=, $0, $pop68
	call    	varargs7@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $pop69
	i64.const	$push74=, 42949672969
	i64.store	16($0), $pop74
	i32.const	$push70=, 16
	i32.add 	$push71=, $0, $pop70
	call    	varargs8@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $pop71
	i32.const	$push73=, 10
	i32.store	0($0), $pop73
	call    	varargs9@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0
	block   	
	i32.const	$push72=, 0
	i32.load	$push25=, errors($pop72)
	br_if   	0, $pop25       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push104=, 0
	call    	exit@FUNCTION, $pop104
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push22=, 0
	i32.const	$push19=, 0
	i32.load	$push20=, __stack_pointer($pop19)
	i32.const	$push21=, 64
	i32.sub 	$push36=, $pop20, $pop21
	tee_local	$push35=, $4=, $pop36
	i32.store	__stack_pointer($pop22), $pop35
	i32.store	60($4), $1
	i32.const	$push34=, 0
	i32.store	16($4), $pop34
	i32.load	$push33=, 60($4)
	tee_local	$push32=, $1=, $pop33
	i32.const	$push31=, 4
	i32.add 	$push1=, $pop32, $pop31
	i32.store	60($4), $pop1
	i32.load	$push2=, 4($1)
	i32.store	24($4), $pop2
	i32.load	$push3=, 0($1)
	i32.store	20($4), $pop3
	i32.load	$push4=, 8($1)
	i32.store	28($4), $pop4
	i32.load	$push5=, 12($1)
	i32.store	32($4), $pop5
	i32.load	$push6=, 16($1)
	i32.store	36($4), $pop6
	i32.load	$push7=, 20($1)
	i32.store	40($4), $pop7
	i32.load	$push8=, 24($1)
	i32.store	44($4), $pop8
	i32.load	$push9=, 28($1)
	i32.store	48($4), $pop9
	i32.load	$push10=, 32($1)
	i32.store	52($4), $pop10
	i32.const	$push11=, 40
	i32.add 	$push12=, $1, $pop11
	i32.store	60($4), $pop12
	i32.load	$push13=, 36($1)
	i32.store	56($4), $pop13
	i32.const	$push26=, 16
	i32.add 	$push27=, $4, $pop26
	i32.const	$push30=, 4
	i32.or  	$2=, $pop27, $pop30
	i32.const	$3=, 0
	i32.const	$1=, 0
	block   	
	block   	
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i32.ne  	$push14=, $pop29, $pop28
	br_if   	0, $pop14       # 0: down to label2
# BB#1:
	i32.const	$5=, 1
	br      	1               # 1: down to label1
.LBB1_2:
	end_block                       # label2:
	i32.const	$5=, 0
.LBB1_3:                                # =>This Inner Loop Header: Depth=1
	end_block                       # label1:
	loop    	                # label3:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$5, 1, 2, 0, 3, 3 # 1: down to label8
                                        # 2: down to label7
                                        # 0: down to label9
                                        # 3: down to label6
.LBB1_4:                                # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label9:
	i32.load	$3=, 0($2)
	i32.const	$push40=, 4
	i32.add 	$push0=, $2, $pop40
	copy_local	$2=, $pop0
	i32.const	$push39=, 1
	i32.add 	$push38=, $1, $pop39
	tee_local	$push37=, $1=, $pop38
	i32.eq  	$push15=, $3, $pop37
	br_if   	3, $pop15       # 3: down to label5
# BB#5:                                 #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 0
	br      	5               # 5: up to label3
.LBB1_6:                                # %if.then.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label8:
	i32.store	12($4), $1
	i32.store	8($4), $3
	i32.store	4($4), $1
	i32.const	$push45=, .L.str
	i32.store	0($4), $pop45
	i32.const	$push44=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop44, $4
	i32.const	$push43=, 0
	i32.const	$push42=, 0
	i32.load	$push16=, errors($pop42)
	i32.const	$push41=, 1
	i32.add 	$push17=, $pop16, $pop41
	i32.store	errors($pop43), $pop17
# BB#7:                                 #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 1
	br      	4               # 4: up to label3
.LBB1_8:                                # %for.inc.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label7:
	i32.const	$push46=, 10
	i32.ne  	$push18=, $1, $pop46
	br_if   	2, $pop18       # 2: down to label4
# BB#9:                                 #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 3
	br      	3               # 3: up to label3
.LBB1_10:                               # %verify.exit
	end_block                       # label6:
	i32.const	$push25=, 0
	i32.const	$push23=, 64
	i32.add 	$push24=, $4, $pop23
	i32.store	__stack_pointer($pop25), $pop24
	return
.LBB1_11:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label5:
	i32.const	$5=, 1
	br      	1               # 1: up to label3
.LBB1_12:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label4:
	i32.const	$5=, 2
	br      	0               # 0: up to label3
.LBB1_13:
	end_loop
	.endfunc
.Lfunc_end1:
	.size	varargs0, .Lfunc_end1-varargs0

	.section	.text.varargs1,"ax",@progbits
	.type	varargs1,@function
varargs1:                               # @varargs1
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push22=, 0
	i32.const	$push19=, 0
	i32.load	$push20=, __stack_pointer($pop19)
	i32.const	$push21=, 64
	i32.sub 	$push35=, $pop20, $pop21
	tee_local	$push34=, $5=, $pop35
	i32.store	__stack_pointer($pop22), $pop34
	i32.store	60($5), $2
	i64.const	$push1=, 4294967296
	i64.store	16($5), $pop1
	i32.load	$push33=, 60($5)
	tee_local	$push32=, $2=, $pop33
	i32.const	$push31=, 4
	i32.add 	$push2=, $pop32, $pop31
	i32.store	60($5), $pop2
	i32.load	$push3=, 0($2)
	i32.store	24($5), $pop3
	i32.load	$push4=, 4($2)
	i32.store	28($5), $pop4
	i32.load	$push5=, 8($2)
	i32.store	32($5), $pop5
	i32.load	$push6=, 12($2)
	i32.store	36($5), $pop6
	i32.load	$push7=, 16($2)
	i32.store	40($5), $pop7
	i32.load	$push8=, 20($2)
	i32.store	44($5), $pop8
	i32.load	$push9=, 24($2)
	i32.store	48($5), $pop9
	i32.load	$push10=, 28($2)
	i32.store	52($5), $pop10
	i32.const	$push11=, 36
	i32.add 	$push12=, $2, $pop11
	i32.store	60($5), $pop12
	i32.load	$push13=, 32($2)
	i32.store	56($5), $pop13
	i32.const	$push26=, 16
	i32.add 	$push27=, $5, $pop26
	i32.const	$push30=, 4
	i32.or  	$3=, $pop27, $pop30
	i32.const	$4=, 0
	i32.const	$2=, 0
	block   	
	block   	
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i32.ne  	$push14=, $pop29, $pop28
	br_if   	0, $pop14       # 0: down to label11
# BB#1:
	i32.const	$6=, 1
	br      	1               # 1: down to label10
.LBB2_2:
	end_block                       # label11:
	i32.const	$6=, 0
.LBB2_3:                                # =>This Inner Loop Header: Depth=1
	end_block                       # label10:
	loop    	                # label12:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$6, 1, 2, 0, 3, 3 # 1: down to label17
                                        # 2: down to label16
                                        # 0: down to label18
                                        # 3: down to label15
.LBB2_4:                                # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB2_3 Depth=1
	end_block                       # label18:
	i32.load	$4=, 0($3)
	i32.const	$push39=, 4
	i32.add 	$push0=, $3, $pop39
	copy_local	$3=, $pop0
	i32.const	$push38=, 1
	i32.add 	$push37=, $2, $pop38
	tee_local	$push36=, $2=, $pop37
	i32.eq  	$push15=, $4, $pop36
	br_if   	3, $pop15       # 3: down to label14
# BB#5:                                 #   in Loop: Header=BB2_3 Depth=1
	i32.const	$6=, 0
	br      	5               # 5: up to label12
.LBB2_6:                                # %if.then.i
                                        #   in Loop: Header=BB2_3 Depth=1
	end_block                       # label17:
	i32.store	12($5), $2
	i32.store	8($5), $4
	i32.store	4($5), $2
	i32.const	$push44=, .L.str.2
	i32.store	0($5), $pop44
	i32.const	$push43=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop43, $5
	i32.const	$push42=, 0
	i32.const	$push41=, 0
	i32.load	$push16=, errors($pop41)
	i32.const	$push40=, 1
	i32.add 	$push17=, $pop16, $pop40
	i32.store	errors($pop42), $pop17
# BB#7:                                 #   in Loop: Header=BB2_3 Depth=1
	i32.const	$6=, 1
	br      	4               # 4: up to label12
.LBB2_8:                                # %for.inc.i
                                        #   in Loop: Header=BB2_3 Depth=1
	end_block                       # label16:
	i32.const	$push45=, 10
	i32.ne  	$push18=, $2, $pop45
	br_if   	2, $pop18       # 2: down to label13
# BB#9:                                 #   in Loop: Header=BB2_3 Depth=1
	i32.const	$6=, 3
	br      	3               # 3: up to label12
.LBB2_10:                               # %verify.exit
	end_block                       # label15:
	i32.const	$push25=, 0
	i32.const	$push23=, 64
	i32.add 	$push24=, $5, $pop23
	i32.store	__stack_pointer($pop25), $pop24
	return
.LBB2_11:                               #   in Loop: Header=BB2_3 Depth=1
	end_block                       # label14:
	i32.const	$6=, 1
	br      	1               # 1: up to label12
.LBB2_12:                               #   in Loop: Header=BB2_3 Depth=1
	end_block                       # label13:
	i32.const	$6=, 2
	br      	0               # 0: up to label12
.LBB2_13:
	end_loop
	.endfunc
.Lfunc_end2:
	.size	varargs1, .Lfunc_end2-varargs1

	.section	.text.varargs2,"ax",@progbits
	.type	varargs2,@function
varargs2:                               # @varargs2
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push22=, 0
	i32.const	$push19=, 0
	i32.load	$push20=, __stack_pointer($pop19)
	i32.const	$push21=, 64
	i32.sub 	$push35=, $pop20, $pop21
	tee_local	$push34=, $6=, $pop35
	i32.store	__stack_pointer($pop22), $pop34
	i32.store	60($6), $3
	i64.const	$push1=, 4294967296
	i64.store	16($6), $pop1
	i32.load	$push33=, 60($6)
	tee_local	$push32=, $3=, $pop33
	i32.const	$push31=, 4
	i32.add 	$push2=, $pop32, $pop31
	i32.store	60($6), $pop2
	i32.const	$push3=, 2
	i32.store	24($6), $pop3
	i32.load	$push4=, 0($3)
	i32.store	28($6), $pop4
	i32.load	$push5=, 4($3)
	i32.store	32($6), $pop5
	i32.load	$push6=, 8($3)
	i32.store	36($6), $pop6
	i32.load	$push7=, 12($3)
	i32.store	40($6), $pop7
	i32.load	$push8=, 16($3)
	i32.store	44($6), $pop8
	i32.load	$push9=, 20($3)
	i32.store	48($6), $pop9
	i32.load	$push10=, 24($3)
	i32.store	52($6), $pop10
	i32.const	$push11=, 32
	i32.add 	$push12=, $3, $pop11
	i32.store	60($6), $pop12
	i32.load	$push13=, 28($3)
	i32.store	56($6), $pop13
	i32.const	$push26=, 16
	i32.add 	$push27=, $6, $pop26
	i32.const	$push30=, 4
	i32.or  	$4=, $pop27, $pop30
	i32.const	$5=, 0
	i32.const	$3=, 0
	block   	
	block   	
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i32.ne  	$push14=, $pop29, $pop28
	br_if   	0, $pop14       # 0: down to label20
# BB#1:
	i32.const	$7=, 1
	br      	1               # 1: down to label19
.LBB3_2:
	end_block                       # label20:
	i32.const	$7=, 0
.LBB3_3:                                # =>This Inner Loop Header: Depth=1
	end_block                       # label19:
	loop    	                # label21:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$7, 1, 2, 0, 3, 3 # 1: down to label26
                                        # 2: down to label25
                                        # 0: down to label27
                                        # 3: down to label24
.LBB3_4:                                # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label27:
	i32.load	$5=, 0($4)
	i32.const	$push39=, 4
	i32.add 	$push0=, $4, $pop39
	copy_local	$4=, $pop0
	i32.const	$push38=, 1
	i32.add 	$push37=, $3, $pop38
	tee_local	$push36=, $3=, $pop37
	i32.eq  	$push15=, $5, $pop36
	br_if   	3, $pop15       # 3: down to label23
# BB#5:                                 #   in Loop: Header=BB3_3 Depth=1
	i32.const	$7=, 0
	br      	5               # 5: up to label21
.LBB3_6:                                # %if.then.i
                                        #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label26:
	i32.store	12($6), $3
	i32.store	8($6), $5
	i32.store	4($6), $3
	i32.const	$push44=, .L.str.3
	i32.store	0($6), $pop44
	i32.const	$push43=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop43, $6
	i32.const	$push42=, 0
	i32.const	$push41=, 0
	i32.load	$push16=, errors($pop41)
	i32.const	$push40=, 1
	i32.add 	$push17=, $pop16, $pop40
	i32.store	errors($pop42), $pop17
# BB#7:                                 #   in Loop: Header=BB3_3 Depth=1
	i32.const	$7=, 1
	br      	4               # 4: up to label21
.LBB3_8:                                # %for.inc.i
                                        #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label25:
	i32.const	$push45=, 10
	i32.ne  	$push18=, $3, $pop45
	br_if   	2, $pop18       # 2: down to label22
# BB#9:                                 #   in Loop: Header=BB3_3 Depth=1
	i32.const	$7=, 3
	br      	3               # 3: up to label21
.LBB3_10:                               # %verify.exit
	end_block                       # label24:
	i32.const	$push25=, 0
	i32.const	$push23=, 64
	i32.add 	$push24=, $6, $pop23
	i32.store	__stack_pointer($pop25), $pop24
	return
.LBB3_11:                               #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label23:
	i32.const	$7=, 1
	br      	1               # 1: up to label21
.LBB3_12:                               #   in Loop: Header=BB3_3 Depth=1
	end_block                       # label22:
	i32.const	$7=, 2
	br      	0               # 0: up to label21
.LBB3_13:
	end_loop
	.endfunc
.Lfunc_end3:
	.size	varargs2, .Lfunc_end3-varargs2

	.section	.text.varargs3,"ax",@progbits
	.type	varargs3,@function
varargs3:                               # @varargs3
	.param  	i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push22=, 0
	i32.const	$push19=, 0
	i32.load	$push20=, __stack_pointer($pop19)
	i32.const	$push21=, 64
	i32.sub 	$push35=, $pop20, $pop21
	tee_local	$push34=, $7=, $pop35
	i32.store	__stack_pointer($pop22), $pop34
	i32.store	60($7), $4
	i64.const	$push1=, 4294967296
	i64.store	16($7), $pop1
	i32.load	$push33=, 60($7)
	tee_local	$push32=, $4=, $pop33
	i32.const	$push31=, 4
	i32.add 	$push2=, $pop32, $pop31
	i32.store	60($7), $pop2
	i32.const	$push3=, 2
	i32.store	24($7), $pop3
	i32.const	$push4=, 3
	i32.store	28($7), $pop4
	i32.load	$push5=, 0($4)
	i32.store	32($7), $pop5
	i32.load	$push6=, 4($4)
	i32.store	36($7), $pop6
	i32.load	$push7=, 8($4)
	i32.store	40($7), $pop7
	i32.load	$push8=, 12($4)
	i32.store	44($7), $pop8
	i32.load	$push9=, 16($4)
	i32.store	48($7), $pop9
	i32.load	$push10=, 20($4)
	i32.store	52($7), $pop10
	i32.const	$push11=, 28
	i32.add 	$push12=, $4, $pop11
	i32.store	60($7), $pop12
	i32.load	$push13=, 24($4)
	i32.store	56($7), $pop13
	i32.const	$push26=, 16
	i32.add 	$push27=, $7, $pop26
	i32.const	$push30=, 4
	i32.or  	$5=, $pop27, $pop30
	i32.const	$6=, 0
	i32.const	$4=, 0
	block   	
	block   	
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i32.ne  	$push14=, $pop29, $pop28
	br_if   	0, $pop14       # 0: down to label29
# BB#1:
	i32.const	$8=, 1
	br      	1               # 1: down to label28
.LBB4_2:
	end_block                       # label29:
	i32.const	$8=, 0
.LBB4_3:                                # =>This Inner Loop Header: Depth=1
	end_block                       # label28:
	loop    	                # label30:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$8, 1, 2, 0, 3, 3 # 1: down to label35
                                        # 2: down to label34
                                        # 0: down to label36
                                        # 3: down to label33
.LBB4_4:                                # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB4_3 Depth=1
	end_block                       # label36:
	i32.load	$6=, 0($5)
	i32.const	$push39=, 4
	i32.add 	$push0=, $5, $pop39
	copy_local	$5=, $pop0
	i32.const	$push38=, 1
	i32.add 	$push37=, $4, $pop38
	tee_local	$push36=, $4=, $pop37
	i32.eq  	$push15=, $6, $pop36
	br_if   	3, $pop15       # 3: down to label32
# BB#5:                                 #   in Loop: Header=BB4_3 Depth=1
	i32.const	$8=, 0
	br      	5               # 5: up to label30
.LBB4_6:                                # %if.then.i
                                        #   in Loop: Header=BB4_3 Depth=1
	end_block                       # label35:
	i32.store	12($7), $4
	i32.store	8($7), $6
	i32.store	4($7), $4
	i32.const	$push44=, .L.str.4
	i32.store	0($7), $pop44
	i32.const	$push43=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop43, $7
	i32.const	$push42=, 0
	i32.const	$push41=, 0
	i32.load	$push16=, errors($pop41)
	i32.const	$push40=, 1
	i32.add 	$push17=, $pop16, $pop40
	i32.store	errors($pop42), $pop17
# BB#7:                                 #   in Loop: Header=BB4_3 Depth=1
	i32.const	$8=, 1
	br      	4               # 4: up to label30
.LBB4_8:                                # %for.inc.i
                                        #   in Loop: Header=BB4_3 Depth=1
	end_block                       # label34:
	i32.const	$push45=, 10
	i32.ne  	$push18=, $4, $pop45
	br_if   	2, $pop18       # 2: down to label31
# BB#9:                                 #   in Loop: Header=BB4_3 Depth=1
	i32.const	$8=, 3
	br      	3               # 3: up to label30
.LBB4_10:                               # %verify.exit
	end_block                       # label33:
	i32.const	$push25=, 0
	i32.const	$push23=, 64
	i32.add 	$push24=, $7, $pop23
	i32.store	__stack_pointer($pop25), $pop24
	return
.LBB4_11:                               #   in Loop: Header=BB4_3 Depth=1
	end_block                       # label32:
	i32.const	$8=, 1
	br      	1               # 1: up to label30
.LBB4_12:                               #   in Loop: Header=BB4_3 Depth=1
	end_block                       # label31:
	i32.const	$8=, 2
	br      	0               # 0: up to label30
.LBB4_13:
	end_loop
	.endfunc
.Lfunc_end4:
	.size	varargs3, .Lfunc_end4-varargs3

	.section	.text.varargs4,"ax",@progbits
	.type	varargs4,@function
varargs4:                               # @varargs4
	.param  	i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.const	$push17=, 0
	i32.load	$push18=, __stack_pointer($pop17)
	i32.const	$push19=, 64
	i32.sub 	$push34=, $pop18, $pop19
	tee_local	$push33=, $8=, $pop34
	i32.store	__stack_pointer($pop20), $pop33
	i32.store	60($8), $5
	i64.const	$push1=, 4294967296
	i64.store	16($8), $pop1
	i32.const	$push32=, 4
	i32.store	32($8), $pop32
	i32.load	$push31=, 60($8)
	tee_local	$push30=, $5=, $pop31
	i32.const	$push29=, 4
	i32.add 	$push2=, $pop30, $pop29
	i32.store	60($8), $pop2
	i64.const	$push3=, 12884901890
	i64.store	24($8), $pop3
	i32.load	$push4=, 0($5)
	i32.store	36($8), $pop4
	i32.load	$push5=, 4($5)
	i32.store	40($8), $pop5
	i32.load	$push6=, 8($5)
	i32.store	44($8), $pop6
	i32.load	$push7=, 12($5)
	i32.store	48($8), $pop7
	i32.load	$push8=, 16($5)
	i32.store	52($8), $pop8
	i32.const	$push9=, 24
	i32.add 	$push10=, $5, $pop9
	i32.store	60($8), $pop10
	i32.load	$push11=, 20($5)
	i32.store	56($8), $pop11
	i32.const	$push24=, 16
	i32.add 	$push25=, $8, $pop24
	i32.const	$push28=, 4
	i32.or  	$6=, $pop25, $pop28
	i32.const	$7=, 0
	i32.const	$5=, 0
	block   	
	block   	
	i32.const	$push27=, 0
	i32.const	$push26=, 0
	i32.ne  	$push12=, $pop27, $pop26
	br_if   	0, $pop12       # 0: down to label38
# BB#1:
	i32.const	$9=, 1
	br      	1               # 1: down to label37
.LBB5_2:
	end_block                       # label38:
	i32.const	$9=, 0
.LBB5_3:                                # =>This Inner Loop Header: Depth=1
	end_block                       # label37:
	loop    	                # label39:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$9, 1, 2, 0, 3, 3 # 1: down to label44
                                        # 2: down to label43
                                        # 0: down to label45
                                        # 3: down to label42
.LBB5_4:                                # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB5_3 Depth=1
	end_block                       # label45:
	i32.load	$7=, 0($6)
	i32.const	$push38=, 4
	i32.add 	$push0=, $6, $pop38
	copy_local	$6=, $pop0
	i32.const	$push37=, 1
	i32.add 	$push36=, $5, $pop37
	tee_local	$push35=, $5=, $pop36
	i32.eq  	$push13=, $7, $pop35
	br_if   	3, $pop13       # 3: down to label41
# BB#5:                                 #   in Loop: Header=BB5_3 Depth=1
	i32.const	$9=, 0
	br      	5               # 5: up to label39
.LBB5_6:                                # %if.then.i
                                        #   in Loop: Header=BB5_3 Depth=1
	end_block                       # label44:
	i32.store	12($8), $5
	i32.store	8($8), $7
	i32.store	4($8), $5
	i32.const	$push43=, .L.str.5
	i32.store	0($8), $pop43
	i32.const	$push42=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop42, $8
	i32.const	$push41=, 0
	i32.const	$push40=, 0
	i32.load	$push14=, errors($pop40)
	i32.const	$push39=, 1
	i32.add 	$push15=, $pop14, $pop39
	i32.store	errors($pop41), $pop15
# BB#7:                                 #   in Loop: Header=BB5_3 Depth=1
	i32.const	$9=, 1
	br      	4               # 4: up to label39
.LBB5_8:                                # %for.inc.i
                                        #   in Loop: Header=BB5_3 Depth=1
	end_block                       # label43:
	i32.const	$push44=, 10
	i32.ne  	$push16=, $5, $pop44
	br_if   	2, $pop16       # 2: down to label40
# BB#9:                                 #   in Loop: Header=BB5_3 Depth=1
	i32.const	$9=, 3
	br      	3               # 3: up to label39
.LBB5_10:                               # %verify.exit
	end_block                       # label42:
	i32.const	$push23=, 0
	i32.const	$push21=, 64
	i32.add 	$push22=, $8, $pop21
	i32.store	__stack_pointer($pop23), $pop22
	return
.LBB5_11:                               #   in Loop: Header=BB5_3 Depth=1
	end_block                       # label41:
	i32.const	$9=, 1
	br      	1               # 1: up to label39
.LBB5_12:                               #   in Loop: Header=BB5_3 Depth=1
	end_block                       # label40:
	i32.const	$9=, 2
	br      	0               # 0: up to label39
.LBB5_13:
	end_loop
	.endfunc
.Lfunc_end5:
	.size	varargs4, .Lfunc_end5-varargs4

	.section	.text.varargs5,"ax",@progbits
	.type	varargs5,@function
varargs5:                               # @varargs5
	.param  	i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.const	$push17=, 0
	i32.load	$push18=, __stack_pointer($pop17)
	i32.const	$push19=, 64
	i32.sub 	$push33=, $pop18, $pop19
	tee_local	$push32=, $9=, $pop33
	i32.store	__stack_pointer($pop20), $pop32
	i32.store	60($9), $6
	i64.const	$push1=, 4294967296
	i64.store	16($9), $pop1
	i32.load	$push31=, 60($9)
	tee_local	$push30=, $6=, $pop31
	i32.const	$push29=, 4
	i32.add 	$push2=, $pop30, $pop29
	i32.store	60($9), $pop2
	i64.const	$push3=, 12884901890
	i64.store	24($9), $pop3
	i64.const	$push4=, 21474836484
	i64.store	32($9), $pop4
	i32.load	$push5=, 0($6)
	i32.store	40($9), $pop5
	i32.load	$push6=, 4($6)
	i32.store	44($9), $pop6
	i32.load	$push7=, 8($6)
	i32.store	48($9), $pop7
	i32.load	$push8=, 12($6)
	i32.store	52($9), $pop8
	i32.const	$push9=, 20
	i32.add 	$push10=, $6, $pop9
	i32.store	60($9), $pop10
	i32.load	$push11=, 16($6)
	i32.store	56($9), $pop11
	i32.const	$push24=, 16
	i32.add 	$push25=, $9, $pop24
	i32.const	$push28=, 4
	i32.or  	$7=, $pop25, $pop28
	i32.const	$8=, 0
	i32.const	$6=, 0
	block   	
	block   	
	i32.const	$push27=, 0
	i32.const	$push26=, 0
	i32.ne  	$push12=, $pop27, $pop26
	br_if   	0, $pop12       # 0: down to label47
# BB#1:
	i32.const	$10=, 1
	br      	1               # 1: down to label46
.LBB6_2:
	end_block                       # label47:
	i32.const	$10=, 0
.LBB6_3:                                # =>This Inner Loop Header: Depth=1
	end_block                       # label46:
	loop    	                # label48:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$10, 1, 2, 0, 3, 3 # 1: down to label53
                                        # 2: down to label52
                                        # 0: down to label54
                                        # 3: down to label51
.LBB6_4:                                # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB6_3 Depth=1
	end_block                       # label54:
	i32.load	$8=, 0($7)
	i32.const	$push37=, 4
	i32.add 	$push0=, $7, $pop37
	copy_local	$7=, $pop0
	i32.const	$push36=, 1
	i32.add 	$push35=, $6, $pop36
	tee_local	$push34=, $6=, $pop35
	i32.eq  	$push13=, $8, $pop34
	br_if   	3, $pop13       # 3: down to label50
# BB#5:                                 #   in Loop: Header=BB6_3 Depth=1
	i32.const	$10=, 0
	br      	5               # 5: up to label48
.LBB6_6:                                # %if.then.i
                                        #   in Loop: Header=BB6_3 Depth=1
	end_block                       # label53:
	i32.store	12($9), $6
	i32.store	8($9), $8
	i32.store	4($9), $6
	i32.const	$push42=, .L.str.6
	i32.store	0($9), $pop42
	i32.const	$push41=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop41, $9
	i32.const	$push40=, 0
	i32.const	$push39=, 0
	i32.load	$push14=, errors($pop39)
	i32.const	$push38=, 1
	i32.add 	$push15=, $pop14, $pop38
	i32.store	errors($pop40), $pop15
# BB#7:                                 #   in Loop: Header=BB6_3 Depth=1
	i32.const	$10=, 1
	br      	4               # 4: up to label48
.LBB6_8:                                # %for.inc.i
                                        #   in Loop: Header=BB6_3 Depth=1
	end_block                       # label52:
	i32.const	$push43=, 10
	i32.ne  	$push16=, $6, $pop43
	br_if   	2, $pop16       # 2: down to label49
# BB#9:                                 #   in Loop: Header=BB6_3 Depth=1
	i32.const	$10=, 3
	br      	3               # 3: up to label48
.LBB6_10:                               # %verify.exit
	end_block                       # label51:
	i32.const	$push23=, 0
	i32.const	$push21=, 64
	i32.add 	$push22=, $9, $pop21
	i32.store	__stack_pointer($pop23), $pop22
	return
.LBB6_11:                               #   in Loop: Header=BB6_3 Depth=1
	end_block                       # label50:
	i32.const	$10=, 1
	br      	1               # 1: up to label48
.LBB6_12:                               #   in Loop: Header=BB6_3 Depth=1
	end_block                       # label49:
	i32.const	$10=, 2
	br      	0               # 0: up to label48
.LBB6_13:
	end_loop
	.endfunc
.Lfunc_end6:
	.size	varargs5, .Lfunc_end6-varargs5

	.section	.text.varargs6,"ax",@progbits
	.type	varargs6,@function
varargs6:                               # @varargs6
	.param  	i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.const	$push17=, 0
	i32.load	$push18=, __stack_pointer($pop17)
	i32.const	$push19=, 64
	i32.sub 	$push33=, $pop18, $pop19
	tee_local	$push32=, $10=, $pop33
	i32.store	__stack_pointer($pop20), $pop32
	i32.store	60($10), $7
	i64.const	$push1=, 4294967296
	i64.store	16($10), $pop1
	i32.load	$push31=, 60($10)
	tee_local	$push30=, $7=, $pop31
	i32.const	$push29=, 4
	i32.add 	$push2=, $pop30, $pop29
	i32.store	60($10), $pop2
	i64.const	$push3=, 12884901890
	i64.store	24($10), $pop3
	i64.const	$push4=, 21474836484
	i64.store	32($10), $pop4
	i32.const	$push5=, 6
	i32.store	40($10), $pop5
	i32.load	$push6=, 0($7)
	i32.store	44($10), $pop6
	i32.load	$push7=, 4($7)
	i32.store	48($10), $pop7
	i32.const	$push8=, 16
	i32.add 	$push9=, $7, $pop8
	i32.store	60($10), $pop9
	i32.load	$push10=, 8($7)
	i32.store	52($10), $pop10
	i32.load	$push11=, 12($7)
	i32.store	56($10), $pop11
	i32.const	$push24=, 16
	i32.add 	$push25=, $10, $pop24
	i32.const	$push28=, 4
	i32.or  	$8=, $pop25, $pop28
	i32.const	$9=, 0
	i32.const	$7=, 0
	block   	
	block   	
	i32.const	$push27=, 0
	i32.const	$push26=, 0
	i32.ne  	$push12=, $pop27, $pop26
	br_if   	0, $pop12       # 0: down to label56
# BB#1:
	i32.const	$11=, 1
	br      	1               # 1: down to label55
.LBB7_2:
	end_block                       # label56:
	i32.const	$11=, 0
.LBB7_3:                                # =>This Inner Loop Header: Depth=1
	end_block                       # label55:
	loop    	                # label57:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$11, 1, 2, 0, 3, 3 # 1: down to label62
                                        # 2: down to label61
                                        # 0: down to label63
                                        # 3: down to label60
.LBB7_4:                                # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB7_3 Depth=1
	end_block                       # label63:
	i32.load	$9=, 0($8)
	i32.const	$push37=, 4
	i32.add 	$push0=, $8, $pop37
	copy_local	$8=, $pop0
	i32.const	$push36=, 1
	i32.add 	$push35=, $7, $pop36
	tee_local	$push34=, $7=, $pop35
	i32.eq  	$push13=, $9, $pop34
	br_if   	3, $pop13       # 3: down to label59
# BB#5:                                 #   in Loop: Header=BB7_3 Depth=1
	i32.const	$11=, 0
	br      	5               # 5: up to label57
.LBB7_6:                                # %if.then.i
                                        #   in Loop: Header=BB7_3 Depth=1
	end_block                       # label62:
	i32.store	12($10), $7
	i32.store	8($10), $9
	i32.store	4($10), $7
	i32.const	$push42=, .L.str.7
	i32.store	0($10), $pop42
	i32.const	$push41=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop41, $10
	i32.const	$push40=, 0
	i32.const	$push39=, 0
	i32.load	$push14=, errors($pop39)
	i32.const	$push38=, 1
	i32.add 	$push15=, $pop14, $pop38
	i32.store	errors($pop40), $pop15
# BB#7:                                 #   in Loop: Header=BB7_3 Depth=1
	i32.const	$11=, 1
	br      	4               # 4: up to label57
.LBB7_8:                                # %for.inc.i
                                        #   in Loop: Header=BB7_3 Depth=1
	end_block                       # label61:
	i32.const	$push43=, 10
	i32.ne  	$push16=, $7, $pop43
	br_if   	2, $pop16       # 2: down to label58
# BB#9:                                 #   in Loop: Header=BB7_3 Depth=1
	i32.const	$11=, 3
	br      	3               # 3: up to label57
.LBB7_10:                               # %verify.exit
	end_block                       # label60:
	i32.const	$push23=, 0
	i32.const	$push21=, 64
	i32.add 	$push22=, $10, $pop21
	i32.store	__stack_pointer($pop23), $pop22
	return
.LBB7_11:                               #   in Loop: Header=BB7_3 Depth=1
	end_block                       # label59:
	i32.const	$11=, 1
	br      	1               # 1: up to label57
.LBB7_12:                               #   in Loop: Header=BB7_3 Depth=1
	end_block                       # label58:
	i32.const	$11=, 2
	br      	0               # 0: up to label57
.LBB7_13:
	end_loop
	.endfunc
.Lfunc_end7:
	.size	varargs6, .Lfunc_end7-varargs6

	.section	.text.varargs7,"ax",@progbits
	.type	varargs7,@function
varargs7:                               # @varargs7
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, 0
	i32.const	$push16=, 0
	i32.load	$push17=, __stack_pointer($pop16)
	i32.const	$push18=, 64
	i32.sub 	$push32=, $pop17, $pop18
	tee_local	$push31=, $11=, $pop32
	i32.store	__stack_pointer($pop19), $pop31
	i32.store	60($11), $8
	i64.const	$push1=, 4294967296
	i64.store	16($11), $pop1
	i32.load	$push30=, 60($11)
	tee_local	$push29=, $8=, $pop30
	i32.const	$push28=, 4
	i32.add 	$push2=, $pop29, $pop28
	i32.store	60($11), $pop2
	i64.const	$push3=, 12884901890
	i64.store	24($11), $pop3
	i64.const	$push4=, 21474836484
	i64.store	32($11), $pop4
	i64.const	$push5=, 30064771078
	i64.store	40($11), $pop5
	i32.load	$push6=, 0($8)
	i32.store	48($11), $pop6
	i32.const	$push7=, 12
	i32.add 	$push8=, $8, $pop7
	i32.store	60($11), $pop8
	i32.load	$push9=, 4($8)
	i32.store	52($11), $pop9
	i32.load	$push10=, 8($8)
	i32.store	56($11), $pop10
	i32.const	$push23=, 16
	i32.add 	$push24=, $11, $pop23
	i32.const	$push27=, 4
	i32.or  	$9=, $pop24, $pop27
	i32.const	$10=, 0
	i32.const	$8=, 0
	block   	
	block   	
	i32.const	$push26=, 0
	i32.const	$push25=, 0
	i32.ne  	$push11=, $pop26, $pop25
	br_if   	0, $pop11       # 0: down to label65
# BB#1:
	i32.const	$12=, 1
	br      	1               # 1: down to label64
.LBB8_2:
	end_block                       # label65:
	i32.const	$12=, 0
.LBB8_3:                                # =>This Inner Loop Header: Depth=1
	end_block                       # label64:
	loop    	                # label66:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$12, 1, 2, 0, 3, 3 # 1: down to label71
                                        # 2: down to label70
                                        # 0: down to label72
                                        # 3: down to label69
.LBB8_4:                                # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB8_3 Depth=1
	end_block                       # label72:
	i32.load	$10=, 0($9)
	i32.const	$push36=, 4
	i32.add 	$push0=, $9, $pop36
	copy_local	$9=, $pop0
	i32.const	$push35=, 1
	i32.add 	$push34=, $8, $pop35
	tee_local	$push33=, $8=, $pop34
	i32.eq  	$push12=, $10, $pop33
	br_if   	3, $pop12       # 3: down to label68
# BB#5:                                 #   in Loop: Header=BB8_3 Depth=1
	i32.const	$12=, 0
	br      	5               # 5: up to label66
.LBB8_6:                                # %if.then.i
                                        #   in Loop: Header=BB8_3 Depth=1
	end_block                       # label71:
	i32.store	12($11), $8
	i32.store	8($11), $10
	i32.store	4($11), $8
	i32.const	$push41=, .L.str.8
	i32.store	0($11), $pop41
	i32.const	$push40=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop40, $11
	i32.const	$push39=, 0
	i32.const	$push38=, 0
	i32.load	$push13=, errors($pop38)
	i32.const	$push37=, 1
	i32.add 	$push14=, $pop13, $pop37
	i32.store	errors($pop39), $pop14
# BB#7:                                 #   in Loop: Header=BB8_3 Depth=1
	i32.const	$12=, 1
	br      	4               # 4: up to label66
.LBB8_8:                                # %for.inc.i
                                        #   in Loop: Header=BB8_3 Depth=1
	end_block                       # label70:
	i32.const	$push42=, 10
	i32.ne  	$push15=, $8, $pop42
	br_if   	2, $pop15       # 2: down to label67
# BB#9:                                 #   in Loop: Header=BB8_3 Depth=1
	i32.const	$12=, 3
	br      	3               # 3: up to label66
.LBB8_10:                               # %verify.exit
	end_block                       # label69:
	i32.const	$push22=, 0
	i32.const	$push20=, 64
	i32.add 	$push21=, $11, $pop20
	i32.store	__stack_pointer($pop22), $pop21
	return
.LBB8_11:                               #   in Loop: Header=BB8_3 Depth=1
	end_block                       # label68:
	i32.const	$12=, 1
	br      	1               # 1: up to label66
.LBB8_12:                               #   in Loop: Header=BB8_3 Depth=1
	end_block                       # label67:
	i32.const	$12=, 2
	br      	0               # 0: up to label66
.LBB8_13:
	end_loop
	.endfunc
.Lfunc_end8:
	.size	varargs7, .Lfunc_end8-varargs7

	.section	.text.varargs8,"ax",@progbits
	.type	varargs8,@function
varargs8:                               # @varargs8
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push17=, 0
	i32.const	$push14=, 0
	i32.load	$push15=, __stack_pointer($pop14)
	i32.const	$push16=, 64
	i32.sub 	$push31=, $pop15, $pop16
	tee_local	$push30=, $12=, $pop31
	i32.store	__stack_pointer($pop17), $pop30
	i32.store	60($12), $9
	i64.const	$push1=, 4294967296
	i64.store	16($12), $pop1
	i64.const	$push2=, 12884901890
	i64.store	24($12), $pop2
	i64.const	$push3=, 21474836484
	i64.store	32($12), $pop3
	i64.const	$push4=, 30064771078
	i64.store	40($12), $pop4
	i32.load	$push29=, 60($12)
	tee_local	$push28=, $9=, $pop29
	i32.const	$push27=, 4
	i32.add 	$push5=, $pop28, $pop27
	i32.store	60($12), $pop5
	i32.const	$push6=, 8
	i32.store	48($12), $pop6
	i32.load	$10=, 0($9)
	i32.const	$push26=, 8
	i32.add 	$push7=, $9, $pop26
	i32.store	60($12), $pop7
	i32.store	52($12), $10
	i32.load	$push8=, 4($9)
	i32.store	56($12), $pop8
	i32.const	$push21=, 16
	i32.add 	$push22=, $12, $pop21
	i32.const	$push25=, 4
	i32.or  	$10=, $pop22, $pop25
	i32.const	$11=, 0
	i32.const	$9=, 0
	block   	
	block   	
	i32.const	$push24=, 0
	i32.const	$push23=, 0
	i32.ne  	$push9=, $pop24, $pop23
	br_if   	0, $pop9        # 0: down to label74
# BB#1:
	i32.const	$13=, 1
	br      	1               # 1: down to label73
.LBB9_2:
	end_block                       # label74:
	i32.const	$13=, 0
.LBB9_3:                                # =>This Inner Loop Header: Depth=1
	end_block                       # label73:
	loop    	                # label75:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$13, 1, 2, 0, 3, 3 # 1: down to label80
                                        # 2: down to label79
                                        # 0: down to label81
                                        # 3: down to label78
.LBB9_4:                                # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB9_3 Depth=1
	end_block                       # label81:
	i32.load	$11=, 0($10)
	i32.const	$push35=, 4
	i32.add 	$push0=, $10, $pop35
	copy_local	$10=, $pop0
	i32.const	$push34=, 1
	i32.add 	$push33=, $9, $pop34
	tee_local	$push32=, $9=, $pop33
	i32.eq  	$push10=, $11, $pop32
	br_if   	3, $pop10       # 3: down to label77
# BB#5:                                 #   in Loop: Header=BB9_3 Depth=1
	i32.const	$13=, 0
	br      	5               # 5: up to label75
.LBB9_6:                                # %if.then.i
                                        #   in Loop: Header=BB9_3 Depth=1
	end_block                       # label80:
	i32.store	12($12), $9
	i32.store	8($12), $11
	i32.store	4($12), $9
	i32.const	$push40=, .L.str.9
	i32.store	0($12), $pop40
	i32.const	$push39=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop39, $12
	i32.const	$push38=, 0
	i32.const	$push37=, 0
	i32.load	$push11=, errors($pop37)
	i32.const	$push36=, 1
	i32.add 	$push12=, $pop11, $pop36
	i32.store	errors($pop38), $pop12
# BB#7:                                 #   in Loop: Header=BB9_3 Depth=1
	i32.const	$13=, 1
	br      	4               # 4: up to label75
.LBB9_8:                                # %for.inc.i
                                        #   in Loop: Header=BB9_3 Depth=1
	end_block                       # label79:
	i32.const	$push41=, 10
	i32.ne  	$push13=, $9, $pop41
	br_if   	2, $pop13       # 2: down to label76
# BB#9:                                 #   in Loop: Header=BB9_3 Depth=1
	i32.const	$13=, 3
	br      	3               # 3: up to label75
.LBB9_10:                               # %verify.exit
	end_block                       # label78:
	i32.const	$push20=, 0
	i32.const	$push18=, 64
	i32.add 	$push19=, $12, $pop18
	i32.store	__stack_pointer($pop20), $pop19
	return
.LBB9_11:                               #   in Loop: Header=BB9_3 Depth=1
	end_block                       # label77:
	i32.const	$13=, 1
	br      	1               # 1: up to label75
.LBB9_12:                               #   in Loop: Header=BB9_3 Depth=1
	end_block                       # label76:
	i32.const	$13=, 2
	br      	0               # 0: up to label75
.LBB9_13:
	end_loop
	.endfunc
.Lfunc_end9:
	.size	varargs8, .Lfunc_end9-varargs8

	.section	.text.varargs9,"ax",@progbits
	.type	varargs9,@function
varargs9:                               # @varargs9
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, 0
	i32.const	$push13=, 0
	i32.load	$push14=, __stack_pointer($pop13)
	i32.const	$push15=, 64
	i32.sub 	$push29=, $pop14, $pop15
	tee_local	$push28=, $13=, $pop29
	i32.store	__stack_pointer($pop16), $pop28
	i32.store	60($13), $10
	i64.const	$push1=, 4294967296
	i64.store	16($13), $pop1
	i64.const	$push2=, 12884901890
	i64.store	24($13), $pop2
	i64.const	$push3=, 21474836484
	i64.store	32($13), $pop3
	i64.const	$push4=, 30064771078
	i64.store	40($13), $pop4
	i64.const	$push5=, 38654705672
	i64.store	48($13), $pop5
	i32.load	$push27=, 60($13)
	tee_local	$push26=, $10=, $pop27
	i32.const	$push25=, 4
	i32.add 	$push6=, $pop26, $pop25
	i32.store	60($13), $pop6
	i32.load	$push7=, 0($10)
	i32.store	56($13), $pop7
	i32.const	$push20=, 16
	i32.add 	$push21=, $13, $pop20
	i32.const	$push24=, 4
	i32.or  	$11=, $pop21, $pop24
	i32.const	$12=, 0
	i32.const	$10=, 0
	block   	
	block   	
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.ne  	$push8=, $pop23, $pop22
	br_if   	0, $pop8        # 0: down to label83
# BB#1:
	i32.const	$14=, 1
	br      	1               # 1: down to label82
.LBB10_2:
	end_block                       # label83:
	i32.const	$14=, 0
.LBB10_3:                               # =>This Inner Loop Header: Depth=1
	end_block                       # label82:
	loop    	                # label84:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$14, 1, 2, 0, 3, 3 # 1: down to label89
                                        # 2: down to label88
                                        # 0: down to label90
                                        # 3: down to label87
.LBB10_4:                               # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB10_3 Depth=1
	end_block                       # label90:
	i32.load	$12=, 0($11)
	i32.const	$push33=, 4
	i32.add 	$push0=, $11, $pop33
	copy_local	$11=, $pop0
	i32.const	$push32=, 1
	i32.add 	$push31=, $10, $pop32
	tee_local	$push30=, $10=, $pop31
	i32.eq  	$push9=, $12, $pop30
	br_if   	3, $pop9        # 3: down to label86
# BB#5:                                 #   in Loop: Header=BB10_3 Depth=1
	i32.const	$14=, 0
	br      	5               # 5: up to label84
.LBB10_6:                               # %if.then.i
                                        #   in Loop: Header=BB10_3 Depth=1
	end_block                       # label89:
	i32.store	12($13), $10
	i32.store	8($13), $12
	i32.store	4($13), $10
	i32.const	$push38=, .L.str.10
	i32.store	0($13), $pop38
	i32.const	$push37=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop37, $13
	i32.const	$push36=, 0
	i32.const	$push35=, 0
	i32.load	$push10=, errors($pop35)
	i32.const	$push34=, 1
	i32.add 	$push11=, $pop10, $pop34
	i32.store	errors($pop36), $pop11
# BB#7:                                 #   in Loop: Header=BB10_3 Depth=1
	i32.const	$14=, 1
	br      	4               # 4: up to label84
.LBB10_8:                               # %for.inc.i
                                        #   in Loop: Header=BB10_3 Depth=1
	end_block                       # label88:
	i32.const	$push39=, 10
	i32.ne  	$push12=, $10, $pop39
	br_if   	2, $pop12       # 2: down to label85
# BB#9:                                 #   in Loop: Header=BB10_3 Depth=1
	i32.const	$14=, 3
	br      	3               # 3: up to label84
.LBB10_10:                              # %verify.exit
	end_block                       # label87:
	i32.const	$push19=, 0
	i32.const	$push17=, 64
	i32.add 	$push18=, $13, $pop17
	i32.store	__stack_pointer($pop19), $pop18
	return
.LBB10_11:                              #   in Loop: Header=BB10_3 Depth=1
	end_block                       # label86:
	i32.const	$14=, 1
	br      	1               # 1: up to label84
.LBB10_12:                              #   in Loop: Header=BB10_3 Depth=1
	end_block                       # label85:
	i32.const	$14=, 2
	br      	0               # 0: up to label84
.LBB10_13:
	end_loop
	.endfunc
.Lfunc_end10:
	.size	varargs9, .Lfunc_end10-varargs9

	.type	errors,@object          # @errors
	.section	.bss.errors,"aw",@nobits
	.p2align	2
errors:
	.int32	0                       # 0x0
	.size	errors, 4

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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
	.functype	printf, i32, i32
