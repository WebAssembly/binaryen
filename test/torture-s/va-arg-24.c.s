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
	i32.const	$push29=, 0
	i32.const	$push26=, 0
	i32.load	$push27=, __stack_pointer($pop26)
	i32.const	$push28=, 288
	i32.sub 	$push72=, $pop27, $pop28
	i32.store	$push84=, __stack_pointer($pop29), $pop72
	tee_local	$push83=, $8=, $pop84
	i32.const	$push30=, 240
	i32.add 	$push31=, $pop83, $pop30
	i32.const	$push0=, 32
	i32.add 	$push1=, $pop31, $pop0
	i64.const	$push2=, 42949672969
	i64.store	$0=, 0($pop1), $pop2
	i32.const	$push32=, 240
	i32.add 	$push33=, $8, $pop32
	i32.const	$push3=, 24
	i32.add 	$push4=, $pop33, $pop3
	i64.const	$push5=, 34359738375
	i64.store	$1=, 0($pop4), $pop5
	i32.const	$push34=, 240
	i32.add 	$push35=, $8, $pop34
	i32.const	$push6=, 16
	i32.add 	$push7=, $pop35, $pop6
	i64.const	$push8=, 25769803781
	i64.store	$2=, 0($pop7), $pop8
	i64.const	$push9=, 17179869187
	i64.store	$3=, 248($8), $pop9
	i64.const	$push10=, 8589934593
	i64.store	$drop=, 240($8), $pop10
	i32.const	$push36=, 240
	i32.add 	$push37=, $8, $pop36
	call    	varargs0@FUNCTION, $8, $pop37
	i32.const	$push38=, 192
	i32.add 	$push39=, $8, $pop38
	i32.const	$push82=, 32
	i32.add 	$push11=, $pop39, $pop82
	i32.const	$push12=, 10
	i32.store	$4=, 0($pop11), $pop12
	i32.const	$push40=, 192
	i32.add 	$push41=, $8, $pop40
	i32.const	$push81=, 24
	i32.add 	$push13=, $pop41, $pop81
	i64.const	$push14=, 38654705672
	i64.store	$5=, 0($pop13), $pop14
	i32.const	$push42=, 192
	i32.add 	$push43=, $8, $pop42
	i32.const	$push80=, 16
	i32.add 	$push15=, $pop43, $pop80
	i64.const	$push16=, 30064771078
	i64.store	$6=, 0($pop15), $pop16
	i64.const	$push17=, 21474836484
	i64.store	$7=, 200($8), $pop17
	i64.const	$push18=, 12884901890
	i64.store	$drop=, 192($8), $pop18
	i32.const	$push44=, 192
	i32.add 	$push45=, $8, $pop44
	call    	varargs1@FUNCTION, $8, $8, $pop45
	i32.const	$push46=, 160
	i32.add 	$push47=, $8, $pop46
	i32.const	$push79=, 24
	i32.add 	$push19=, $pop47, $pop79
	i64.store	$drop=, 0($pop19), $0
	i32.const	$push48=, 160
	i32.add 	$push49=, $8, $pop48
	i32.const	$push78=, 16
	i32.add 	$push20=, $pop49, $pop78
	i64.store	$drop=, 0($pop20), $1
	i64.store	$drop=, 168($8), $2
	i64.store	$drop=, 160($8), $3
	i32.const	$push50=, 160
	i32.add 	$push51=, $8, $pop50
	call    	varargs2@FUNCTION, $8, $8, $8, $pop51
	i32.const	$push52=, 128
	i32.add 	$push53=, $8, $pop52
	i32.const	$push77=, 24
	i32.add 	$push21=, $pop53, $pop77
	i32.store	$drop=, 0($pop21), $4
	i32.const	$push54=, 128
	i32.add 	$push55=, $8, $pop54
	i32.const	$push76=, 16
	i32.add 	$push22=, $pop55, $pop76
	i64.store	$3=, 0($pop22), $5
	i64.store	$5=, 136($8), $6
	i64.store	$drop=, 128($8), $7
	i32.const	$push56=, 128
	i32.add 	$push57=, $8, $pop56
	call    	varargs3@FUNCTION, $8, $8, $8, $8, $pop57
	i32.const	$push58=, 96
	i32.add 	$push59=, $8, $pop58
	i32.const	$push75=, 16
	i32.add 	$push23=, $pop59, $pop75
	i64.store	$drop=, 0($pop23), $0
	i64.store	$drop=, 104($8), $1
	i64.store	$drop=, 96($8), $2
	i32.const	$push60=, 96
	i32.add 	$push61=, $8, $pop60
	call    	varargs4@FUNCTION, $8, $8, $8, $8, $8, $pop61
	i32.const	$push62=, 64
	i32.add 	$push63=, $8, $pop62
	i32.const	$push74=, 16
	i32.add 	$push24=, $pop63, $pop74
	i32.store	$drop=, 0($pop24), $4
	i64.store	$2=, 72($8), $3
	i64.store	$drop=, 64($8), $5
	i32.const	$push64=, 64
	i32.add 	$push65=, $8, $pop64
	call    	varargs5@FUNCTION, $8, $8, $8, $8, $8, $8, $pop65
	i64.store	$drop=, 56($8), $0
	i64.store	$drop=, 48($8), $1
	i32.const	$push66=, 48
	i32.add 	$push67=, $8, $pop66
	call    	varargs6@FUNCTION, $8, $8, $8, $8, $8, $8, $8, $pop67
	i32.store	$drop=, 40($8), $4
	i64.store	$drop=, 32($8), $2
	i32.const	$push68=, 32
	i32.add 	$push69=, $8, $pop68
	call    	varargs7@FUNCTION, $8, $8, $8, $8, $8, $8, $8, $8, $pop69
	i64.store	$drop=, 16($8), $0
	i32.const	$push70=, 16
	i32.add 	$push71=, $8, $pop70
	call    	varargs8@FUNCTION, $8, $8, $8, $8, $8, $8, $8, $8, $8, $pop71
	i32.store	$drop=, 0($8), $4
	call    	varargs9@FUNCTION, $8, $8, $8, $8, $8, $8, $8, $8, $8, $8, $8
	block
	i32.const	$push73=, 0
	i32.load	$push25=, errors($pop73)
	br_if   	0, $pop25       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push85=, 0
	call    	exit@FUNCTION, $pop85
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
	i32.const	$push22=, 0
	i32.const	$push19=, 0
	i32.load	$push20=, __stack_pointer($pop19)
	i32.const	$push21=, 64
	i32.sub 	$push28=, $pop20, $pop21
	i32.store	$push34=, __stack_pointer($pop22), $pop28
	tee_local	$push33=, $4=, $pop34
	i32.store	$drop=, 60($pop33), $1
	i32.const	$push1=, 0
	i32.store	$2=, 16($4), $pop1
	i32.load	$push32=, 60($4)
	tee_local	$push31=, $1=, $pop32
	i32.const	$push30=, 4
	i32.add 	$push2=, $pop31, $pop30
	i32.store	$drop=, 60($4), $pop2
	i32.load	$push3=, 4($1)
	i32.store	$drop=, 24($4), $pop3
	i32.load	$push4=, 0($1)
	i32.store	$drop=, 20($4), $pop4
	i32.load	$push5=, 8($1)
	i32.store	$drop=, 28($4), $pop5
	i32.load	$push6=, 12($1)
	i32.store	$drop=, 32($4), $pop6
	i32.load	$push7=, 16($1)
	i32.store	$drop=, 36($4), $pop7
	i32.load	$push8=, 20($1)
	i32.store	$drop=, 40($4), $pop8
	i32.load	$push9=, 24($1)
	i32.store	$drop=, 44($4), $pop9
	i32.load	$push10=, 28($1)
	i32.store	$drop=, 48($4), $pop10
	i32.load	$push11=, 32($1)
	i32.store	$drop=, 52($4), $pop11
	i32.const	$push12=, 40
	i32.add 	$push13=, $1, $pop12
	i32.store	$drop=, 60($4), $pop13
	i32.load	$push14=, 36($1)
	i32.store	$drop=, 56($4), $pop14
	i32.const	$push26=, 16
	i32.add 	$push27=, $4, $pop26
	i32.const	$push29=, 4
	i32.or  	$5=, $pop27, $pop29
	i32.const	$6=, 0
	i32.const	$1=, 0
.LBB1_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	block
	i32.eq  	$push15=, $1, $6
	br_if   	0, $pop15       # 0: down to label3
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.store	$3=, 12($4), $1
	i32.store	$drop=, 8($4), $6
	i32.store	$drop=, 4($4), $3
	i32.const	$push39=, .L.str
	i32.store	$drop=, 0($4), $pop39
	i32.const	$push38=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop38, $4
	i32.load	$push16=, errors($2)
	i32.const	$push37=, 1
	i32.add 	$push17=, $pop16, $pop37
	i32.store	$drop=, errors($2), $pop17
.LBB1_3:                                # %for.inc.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.const	$push40=, 10
	i32.eq  	$push18=, $1, $pop40
	br_if   	1, $pop18       # 1: down to label2
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push36=, 1
	i32.add 	$1=, $1, $pop36
	i32.load	$6=, 0($5)
	i32.const	$push35=, 4
	i32.add 	$push0=, $5, $pop35
	copy_local	$5=, $pop0
	br      	0               # 0: up to label1
.LBB1_5:                                # %verify.exit
	end_loop                        # label2:
	i32.const	$push25=, 0
	i32.const	$push23=, 64
	i32.add 	$push24=, $4, $pop23
	i32.store	$drop=, __stack_pointer($pop25), $pop24
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	varargs0, .Lfunc_end1-varargs0

	.section	.text.varargs1,"ax",@progbits
	.type	varargs1,@function
varargs1:                               # @varargs1
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push21=, 0
	i32.const	$push18=, 0
	i32.load	$push19=, __stack_pointer($pop18)
	i32.const	$push20=, 64
	i32.sub 	$push27=, $pop19, $pop20
	i32.store	$push33=, __stack_pointer($pop21), $pop27
	tee_local	$push32=, $4=, $pop33
	i32.store	$drop=, 60($pop32), $2
	i64.const	$push1=, 4294967296
	i64.store	$drop=, 16($4), $pop1
	i32.load	$push31=, 60($4)
	tee_local	$push30=, $2=, $pop31
	i32.const	$push29=, 4
	i32.add 	$push2=, $pop30, $pop29
	i32.store	$drop=, 60($4), $pop2
	i32.load	$push3=, 0($2)
	i32.store	$drop=, 24($4), $pop3
	i32.load	$push4=, 4($2)
	i32.store	$drop=, 28($4), $pop4
	i32.load	$push5=, 8($2)
	i32.store	$drop=, 32($4), $pop5
	i32.load	$push6=, 12($2)
	i32.store	$drop=, 36($4), $pop6
	i32.load	$push7=, 16($2)
	i32.store	$drop=, 40($4), $pop7
	i32.load	$push8=, 20($2)
	i32.store	$drop=, 44($4), $pop8
	i32.load	$push9=, 24($2)
	i32.store	$drop=, 48($4), $pop9
	i32.load	$push10=, 28($2)
	i32.store	$drop=, 52($4), $pop10
	i32.const	$push11=, 36
	i32.add 	$push12=, $2, $pop11
	i32.store	$drop=, 60($4), $pop12
	i32.load	$push13=, 32($2)
	i32.store	$drop=, 56($4), $pop13
	i32.const	$push25=, 16
	i32.add 	$push26=, $4, $pop25
	i32.const	$push28=, 4
	i32.or  	$5=, $pop26, $pop28
	i32.const	$6=, 0
	i32.const	$2=, 0
.LBB2_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	block
	i32.eq  	$push14=, $2, $6
	br_if   	0, $pop14       # 0: down to label6
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.store	$3=, 12($4), $2
	i32.store	$drop=, 8($4), $6
	i32.store	$drop=, 4($4), $3
	i32.const	$push40=, .L.str.2
	i32.store	$drop=, 0($4), $pop40
	i32.const	$push39=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop39, $4
	i32.const	$push38=, 0
	i32.const	$push37=, 0
	i32.load	$push15=, errors($pop37)
	i32.const	$push36=, 1
	i32.add 	$push16=, $pop15, $pop36
	i32.store	$drop=, errors($pop38), $pop16
.LBB2_3:                                # %for.inc.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label6:
	i32.const	$push41=, 10
	i32.eq  	$push17=, $2, $pop41
	br_if   	1, $pop17       # 1: down to label5
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push35=, 1
	i32.add 	$2=, $2, $pop35
	i32.load	$6=, 0($5)
	i32.const	$push34=, 4
	i32.add 	$push0=, $5, $pop34
	copy_local	$5=, $pop0
	br      	0               # 0: up to label4
.LBB2_5:                                # %verify.exit
	end_loop                        # label5:
	i32.const	$push24=, 0
	i32.const	$push22=, 64
	i32.add 	$push23=, $4, $pop22
	i32.store	$drop=, __stack_pointer($pop24), $pop23
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	varargs1, .Lfunc_end2-varargs1

	.section	.text.varargs2,"ax",@progbits
	.type	varargs2,@function
varargs2:                               # @varargs2
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push21=, 0
	i32.const	$push18=, 0
	i32.load	$push19=, __stack_pointer($pop18)
	i32.const	$push20=, 64
	i32.sub 	$push27=, $pop19, $pop20
	i32.store	$push33=, __stack_pointer($pop21), $pop27
	tee_local	$push32=, $5=, $pop33
	i32.store	$drop=, 60($pop32), $3
	i64.const	$push1=, 4294967296
	i64.store	$drop=, 16($5), $pop1
	i32.load	$push31=, 60($5)
	tee_local	$push30=, $3=, $pop31
	i32.const	$push29=, 4
	i32.add 	$push2=, $pop30, $pop29
	i32.store	$drop=, 60($5), $pop2
	i32.const	$push3=, 2
	i32.store	$drop=, 24($5), $pop3
	i32.load	$push4=, 0($3)
	i32.store	$drop=, 28($5), $pop4
	i32.load	$push5=, 4($3)
	i32.store	$drop=, 32($5), $pop5
	i32.load	$push6=, 8($3)
	i32.store	$drop=, 36($5), $pop6
	i32.load	$push7=, 12($3)
	i32.store	$drop=, 40($5), $pop7
	i32.load	$push8=, 16($3)
	i32.store	$drop=, 44($5), $pop8
	i32.load	$push9=, 20($3)
	i32.store	$drop=, 48($5), $pop9
	i32.load	$push10=, 24($3)
	i32.store	$drop=, 52($5), $pop10
	i32.const	$push11=, 32
	i32.add 	$push12=, $3, $pop11
	i32.store	$drop=, 60($5), $pop12
	i32.load	$push13=, 28($3)
	i32.store	$drop=, 56($5), $pop13
	i32.const	$push25=, 16
	i32.add 	$push26=, $5, $pop25
	i32.const	$push28=, 4
	i32.or  	$6=, $pop26, $pop28
	i32.const	$7=, 0
	i32.const	$3=, 0
.LBB3_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	block
	i32.eq  	$push14=, $3, $7
	br_if   	0, $pop14       # 0: down to label9
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.store	$4=, 12($5), $3
	i32.store	$drop=, 8($5), $7
	i32.store	$drop=, 4($5), $4
	i32.const	$push40=, .L.str.3
	i32.store	$drop=, 0($5), $pop40
	i32.const	$push39=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop39, $5
	i32.const	$push38=, 0
	i32.const	$push37=, 0
	i32.load	$push15=, errors($pop37)
	i32.const	$push36=, 1
	i32.add 	$push16=, $pop15, $pop36
	i32.store	$drop=, errors($pop38), $pop16
.LBB3_3:                                # %for.inc.i
                                        #   in Loop: Header=BB3_1 Depth=1
	end_block                       # label9:
	i32.const	$push41=, 10
	i32.eq  	$push17=, $3, $pop41
	br_if   	1, $pop17       # 1: down to label8
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.const	$push35=, 1
	i32.add 	$3=, $3, $pop35
	i32.load	$7=, 0($6)
	i32.const	$push34=, 4
	i32.add 	$push0=, $6, $pop34
	copy_local	$6=, $pop0
	br      	0               # 0: up to label7
.LBB3_5:                                # %verify.exit
	end_loop                        # label8:
	i32.const	$push24=, 0
	i32.const	$push22=, 64
	i32.add 	$push23=, $5, $pop22
	i32.store	$drop=, __stack_pointer($pop24), $pop23
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	varargs2, .Lfunc_end3-varargs2

	.section	.text.varargs3,"ax",@progbits
	.type	varargs3,@function
varargs3:                               # @varargs3
	.param  	i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push21=, 0
	i32.const	$push18=, 0
	i32.load	$push19=, __stack_pointer($pop18)
	i32.const	$push20=, 64
	i32.sub 	$push27=, $pop19, $pop20
	i32.store	$push33=, __stack_pointer($pop21), $pop27
	tee_local	$push32=, $6=, $pop33
	i32.store	$drop=, 60($pop32), $4
	i64.const	$push1=, 4294967296
	i64.store	$drop=, 16($6), $pop1
	i32.load	$push31=, 60($6)
	tee_local	$push30=, $4=, $pop31
	i32.const	$push29=, 4
	i32.add 	$push2=, $pop30, $pop29
	i32.store	$drop=, 60($6), $pop2
	i32.const	$push3=, 2
	i32.store	$drop=, 24($6), $pop3
	i32.const	$push4=, 3
	i32.store	$drop=, 28($6), $pop4
	i32.load	$push5=, 0($4)
	i32.store	$drop=, 32($6), $pop5
	i32.load	$push6=, 4($4)
	i32.store	$drop=, 36($6), $pop6
	i32.load	$push7=, 8($4)
	i32.store	$drop=, 40($6), $pop7
	i32.load	$push8=, 12($4)
	i32.store	$drop=, 44($6), $pop8
	i32.load	$push9=, 16($4)
	i32.store	$drop=, 48($6), $pop9
	i32.load	$push10=, 20($4)
	i32.store	$drop=, 52($6), $pop10
	i32.const	$push11=, 28
	i32.add 	$push12=, $4, $pop11
	i32.store	$drop=, 60($6), $pop12
	i32.load	$push13=, 24($4)
	i32.store	$drop=, 56($6), $pop13
	i32.const	$push25=, 16
	i32.add 	$push26=, $6, $pop25
	i32.const	$push28=, 4
	i32.or  	$7=, $pop26, $pop28
	i32.const	$8=, 0
	i32.const	$4=, 0
.LBB4_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	block
	i32.eq  	$push14=, $4, $8
	br_if   	0, $pop14       # 0: down to label12
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB4_1 Depth=1
	i32.store	$5=, 12($6), $4
	i32.store	$drop=, 8($6), $8
	i32.store	$drop=, 4($6), $5
	i32.const	$push40=, .L.str.4
	i32.store	$drop=, 0($6), $pop40
	i32.const	$push39=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop39, $6
	i32.const	$push38=, 0
	i32.const	$push37=, 0
	i32.load	$push15=, errors($pop37)
	i32.const	$push36=, 1
	i32.add 	$push16=, $pop15, $pop36
	i32.store	$drop=, errors($pop38), $pop16
.LBB4_3:                                # %for.inc.i
                                        #   in Loop: Header=BB4_1 Depth=1
	end_block                       # label12:
	i32.const	$push41=, 10
	i32.eq  	$push17=, $4, $pop41
	br_if   	1, $pop17       # 1: down to label11
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB4_1 Depth=1
	i32.const	$push35=, 1
	i32.add 	$4=, $4, $pop35
	i32.load	$8=, 0($7)
	i32.const	$push34=, 4
	i32.add 	$push0=, $7, $pop34
	copy_local	$7=, $pop0
	br      	0               # 0: up to label10
.LBB4_5:                                # %verify.exit
	end_loop                        # label11:
	i32.const	$push24=, 0
	i32.const	$push22=, 64
	i32.add 	$push23=, $6, $pop22
	i32.store	$drop=, __stack_pointer($pop24), $pop23
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	varargs3, .Lfunc_end4-varargs3

	.section	.text.varargs4,"ax",@progbits
	.type	varargs4,@function
varargs4:                               # @varargs4
	.param  	i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.const	$push17=, 0
	i32.load	$push18=, __stack_pointer($pop17)
	i32.const	$push19=, 64
	i32.sub 	$push26=, $pop18, $pop19
	i32.store	$push32=, __stack_pointer($pop20), $pop26
	tee_local	$push31=, $8=, $pop32
	i32.store	$drop=, 60($pop31), $5
	i64.const	$push1=, 4294967296
	i64.store	$drop=, 16($8), $pop1
	i32.const	$push2=, 4
	i32.store	$push30=, 32($8), $pop2
	tee_local	$push29=, $6=, $pop30
	i32.load	$push28=, 60($8)
	tee_local	$push27=, $5=, $pop28
	i32.add 	$push3=, $pop29, $pop27
	i32.store	$drop=, 60($8), $pop3
	i64.const	$push4=, 12884901890
	i64.store	$drop=, 24($8), $pop4
	i32.load	$push5=, 0($5)
	i32.store	$drop=, 36($8), $pop5
	i32.load	$push6=, 4($5)
	i32.store	$drop=, 40($8), $pop6
	i32.load	$push7=, 8($5)
	i32.store	$drop=, 44($8), $pop7
	i32.load	$push8=, 12($5)
	i32.store	$drop=, 48($8), $pop8
	i32.load	$push9=, 16($5)
	i32.store	$drop=, 52($8), $pop9
	i32.const	$push10=, 24
	i32.add 	$push11=, $5, $pop10
	i32.store	$drop=, 60($8), $pop11
	i32.load	$push12=, 20($5)
	i32.store	$drop=, 56($8), $pop12
	i32.const	$push24=, 16
	i32.add 	$push25=, $8, $pop24
	i32.or  	$9=, $6, $pop25
	i32.const	$10=, 0
	i32.const	$5=, 0
.LBB5_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label13:
	block
	i32.eq  	$push13=, $5, $10
	br_if   	0, $pop13       # 0: down to label15
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB5_1 Depth=1
	i32.store	$7=, 12($8), $5
	i32.store	$drop=, 8($8), $10
	i32.store	$drop=, 4($8), $7
	i32.const	$push38=, .L.str.5
	i32.store	$drop=, 0($8), $pop38
	i32.const	$push37=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop37, $8
	i32.const	$push36=, 0
	i32.const	$push35=, 0
	i32.load	$push14=, errors($pop35)
	i32.const	$push34=, 1
	i32.add 	$push15=, $pop14, $pop34
	i32.store	$drop=, errors($pop36), $pop15
.LBB5_3:                                # %for.inc.i
                                        #   in Loop: Header=BB5_1 Depth=1
	end_block                       # label15:
	i32.const	$push39=, 10
	i32.eq  	$push16=, $5, $pop39
	br_if   	1, $pop16       # 1: down to label14
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB5_1 Depth=1
	i32.const	$push33=, 1
	i32.add 	$5=, $5, $pop33
	i32.load	$10=, 0($9)
	i32.add 	$push0=, $9, $6
	copy_local	$9=, $pop0
	br      	0               # 0: up to label13
.LBB5_5:                                # %verify.exit
	end_loop                        # label14:
	i32.const	$push23=, 0
	i32.const	$push21=, 64
	i32.add 	$push22=, $8, $pop21
	i32.store	$drop=, __stack_pointer($pop23), $pop22
                                        # fallthrough-return
	.endfunc
.Lfunc_end5:
	.size	varargs4, .Lfunc_end5-varargs4

	.section	.text.varargs5,"ax",@progbits
	.type	varargs5,@function
varargs5:                               # @varargs5
	.param  	i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, 0
	i32.const	$push16=, 0
	i32.load	$push17=, __stack_pointer($pop16)
	i32.const	$push18=, 64
	i32.sub 	$push25=, $pop17, $pop18
	i32.store	$push31=, __stack_pointer($pop19), $pop25
	tee_local	$push30=, $8=, $pop31
	i32.store	$drop=, 60($pop30), $6
	i64.const	$push1=, 4294967296
	i64.store	$drop=, 16($8), $pop1
	i32.load	$push29=, 60($8)
	tee_local	$push28=, $6=, $pop29
	i32.const	$push27=, 4
	i32.add 	$push2=, $pop28, $pop27
	i32.store	$drop=, 60($8), $pop2
	i64.const	$push3=, 12884901890
	i64.store	$drop=, 24($8), $pop3
	i64.const	$push4=, 21474836484
	i64.store	$drop=, 32($8), $pop4
	i32.load	$push5=, 0($6)
	i32.store	$drop=, 40($8), $pop5
	i32.load	$push6=, 4($6)
	i32.store	$drop=, 44($8), $pop6
	i32.load	$push7=, 8($6)
	i32.store	$drop=, 48($8), $pop7
	i32.load	$push8=, 12($6)
	i32.store	$drop=, 52($8), $pop8
	i32.const	$push9=, 20
	i32.add 	$push10=, $6, $pop9
	i32.store	$drop=, 60($8), $pop10
	i32.load	$push11=, 16($6)
	i32.store	$drop=, 56($8), $pop11
	i32.const	$push23=, 16
	i32.add 	$push24=, $8, $pop23
	i32.const	$push26=, 4
	i32.or  	$9=, $pop24, $pop26
	i32.const	$10=, 0
	i32.const	$6=, 0
.LBB6_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label16:
	block
	i32.eq  	$push12=, $6, $10
	br_if   	0, $pop12       # 0: down to label18
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB6_1 Depth=1
	i32.store	$7=, 12($8), $6
	i32.store	$drop=, 8($8), $10
	i32.store	$drop=, 4($8), $7
	i32.const	$push38=, .L.str.6
	i32.store	$drop=, 0($8), $pop38
	i32.const	$push37=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop37, $8
	i32.const	$push36=, 0
	i32.const	$push35=, 0
	i32.load	$push13=, errors($pop35)
	i32.const	$push34=, 1
	i32.add 	$push14=, $pop13, $pop34
	i32.store	$drop=, errors($pop36), $pop14
.LBB6_3:                                # %for.inc.i
                                        #   in Loop: Header=BB6_1 Depth=1
	end_block                       # label18:
	i32.const	$push39=, 10
	i32.eq  	$push15=, $6, $pop39
	br_if   	1, $pop15       # 1: down to label17
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB6_1 Depth=1
	i32.const	$push33=, 1
	i32.add 	$6=, $6, $pop33
	i32.load	$10=, 0($9)
	i32.const	$push32=, 4
	i32.add 	$push0=, $9, $pop32
	copy_local	$9=, $pop0
	br      	0               # 0: up to label16
.LBB6_5:                                # %verify.exit
	end_loop                        # label17:
	i32.const	$push22=, 0
	i32.const	$push20=, 64
	i32.add 	$push21=, $8, $pop20
	i32.store	$drop=, __stack_pointer($pop22), $pop21
                                        # fallthrough-return
	.endfunc
.Lfunc_end6:
	.size	varargs5, .Lfunc_end6-varargs5

	.section	.text.varargs6,"ax",@progbits
	.type	varargs6,@function
varargs6:                               # @varargs6
	.param  	i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, 0
	i32.const	$push16=, 0
	i32.load	$push17=, __stack_pointer($pop16)
	i32.const	$push18=, 64
	i32.sub 	$push25=, $pop17, $pop18
	i32.store	$push31=, __stack_pointer($pop19), $pop25
	tee_local	$push30=, $9=, $pop31
	i32.store	$drop=, 60($pop30), $7
	i64.const	$push1=, 4294967296
	i64.store	$drop=, 16($9), $pop1
	i32.load	$push29=, 60($9)
	tee_local	$push28=, $7=, $pop29
	i32.const	$push27=, 4
	i32.add 	$push2=, $pop28, $pop27
	i32.store	$drop=, 60($9), $pop2
	i64.const	$push3=, 12884901890
	i64.store	$drop=, 24($9), $pop3
	i64.const	$push4=, 21474836484
	i64.store	$drop=, 32($9), $pop4
	i32.const	$push5=, 6
	i32.store	$drop=, 40($9), $pop5
	i32.load	$push6=, 0($7)
	i32.store	$drop=, 44($9), $pop6
	i32.load	$push7=, 4($7)
	i32.store	$drop=, 48($9), $pop7
	i32.const	$push8=, 16
	i32.add 	$push9=, $7, $pop8
	i32.store	$drop=, 60($9), $pop9
	i32.load	$push10=, 8($7)
	i32.store	$drop=, 52($9), $pop10
	i32.load	$push11=, 12($7)
	i32.store	$drop=, 56($9), $pop11
	i32.const	$push23=, 16
	i32.add 	$push24=, $9, $pop23
	i32.const	$push26=, 4
	i32.or  	$10=, $pop24, $pop26
	i32.const	$11=, 0
	i32.const	$7=, 0
.LBB7_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label19:
	block
	i32.eq  	$push12=, $7, $11
	br_if   	0, $pop12       # 0: down to label21
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB7_1 Depth=1
	i32.store	$8=, 12($9), $7
	i32.store	$drop=, 8($9), $11
	i32.store	$drop=, 4($9), $8
	i32.const	$push38=, .L.str.7
	i32.store	$drop=, 0($9), $pop38
	i32.const	$push37=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop37, $9
	i32.const	$push36=, 0
	i32.const	$push35=, 0
	i32.load	$push13=, errors($pop35)
	i32.const	$push34=, 1
	i32.add 	$push14=, $pop13, $pop34
	i32.store	$drop=, errors($pop36), $pop14
.LBB7_3:                                # %for.inc.i
                                        #   in Loop: Header=BB7_1 Depth=1
	end_block                       # label21:
	i32.const	$push39=, 10
	i32.eq  	$push15=, $7, $pop39
	br_if   	1, $pop15       # 1: down to label20
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB7_1 Depth=1
	i32.const	$push33=, 1
	i32.add 	$7=, $7, $pop33
	i32.load	$11=, 0($10)
	i32.const	$push32=, 4
	i32.add 	$push0=, $10, $pop32
	copy_local	$10=, $pop0
	br      	0               # 0: up to label19
.LBB7_5:                                # %verify.exit
	end_loop                        # label20:
	i32.const	$push22=, 0
	i32.const	$push20=, 64
	i32.add 	$push21=, $9, $pop20
	i32.store	$drop=, __stack_pointer($pop22), $pop21
                                        # fallthrough-return
	.endfunc
.Lfunc_end7:
	.size	varargs6, .Lfunc_end7-varargs6

	.section	.text.varargs7,"ax",@progbits
	.type	varargs7,@function
varargs7:                               # @varargs7
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push18=, 0
	i32.const	$push15=, 0
	i32.load	$push16=, __stack_pointer($pop15)
	i32.const	$push17=, 64
	i32.sub 	$push24=, $pop16, $pop17
	i32.store	$push30=, __stack_pointer($pop18), $pop24
	tee_local	$push29=, $10=, $pop30
	i32.store	$drop=, 60($pop29), $8
	i64.const	$push1=, 4294967296
	i64.store	$drop=, 16($10), $pop1
	i32.load	$push28=, 60($10)
	tee_local	$push27=, $8=, $pop28
	i32.const	$push26=, 4
	i32.add 	$push2=, $pop27, $pop26
	i32.store	$drop=, 60($10), $pop2
	i64.const	$push3=, 12884901890
	i64.store	$drop=, 24($10), $pop3
	i64.const	$push4=, 21474836484
	i64.store	$drop=, 32($10), $pop4
	i64.const	$push5=, 30064771078
	i64.store	$drop=, 40($10), $pop5
	i32.load	$push6=, 0($8)
	i32.store	$drop=, 48($10), $pop6
	i32.const	$push7=, 12
	i32.add 	$push8=, $8, $pop7
	i32.store	$drop=, 60($10), $pop8
	i32.load	$push9=, 4($8)
	i32.store	$drop=, 52($10), $pop9
	i32.load	$push10=, 8($8)
	i32.store	$drop=, 56($10), $pop10
	i32.const	$push22=, 16
	i32.add 	$push23=, $10, $pop22
	i32.const	$push25=, 4
	i32.or  	$11=, $pop23, $pop25
	i32.const	$12=, 0
	i32.const	$8=, 0
.LBB8_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label22:
	block
	i32.eq  	$push11=, $8, $12
	br_if   	0, $pop11       # 0: down to label24
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB8_1 Depth=1
	i32.store	$9=, 12($10), $8
	i32.store	$drop=, 8($10), $12
	i32.store	$drop=, 4($10), $9
	i32.const	$push37=, .L.str.8
	i32.store	$drop=, 0($10), $pop37
	i32.const	$push36=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop36, $10
	i32.const	$push35=, 0
	i32.const	$push34=, 0
	i32.load	$push12=, errors($pop34)
	i32.const	$push33=, 1
	i32.add 	$push13=, $pop12, $pop33
	i32.store	$drop=, errors($pop35), $pop13
.LBB8_3:                                # %for.inc.i
                                        #   in Loop: Header=BB8_1 Depth=1
	end_block                       # label24:
	i32.const	$push38=, 10
	i32.eq  	$push14=, $8, $pop38
	br_if   	1, $pop14       # 1: down to label23
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB8_1 Depth=1
	i32.const	$push32=, 1
	i32.add 	$8=, $8, $pop32
	i32.load	$12=, 0($11)
	i32.const	$push31=, 4
	i32.add 	$push0=, $11, $pop31
	copy_local	$11=, $pop0
	br      	0               # 0: up to label22
.LBB8_5:                                # %verify.exit
	end_loop                        # label23:
	i32.const	$push21=, 0
	i32.const	$push19=, 64
	i32.add 	$push20=, $10, $pop19
	i32.store	$drop=, __stack_pointer($pop21), $pop20
                                        # fallthrough-return
	.endfunc
.Lfunc_end8:
	.size	varargs7, .Lfunc_end8-varargs7

	.section	.text.varargs8,"ax",@progbits
	.type	varargs8,@function
varargs8:                               # @varargs8
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, 0
	i32.const	$push13=, 0
	i32.load	$push14=, __stack_pointer($pop13)
	i32.const	$push15=, 64
	i32.sub 	$push22=, $pop14, $pop15
	i32.store	$push28=, __stack_pointer($pop16), $pop22
	tee_local	$push27=, $11=, $pop28
	i32.store	$drop=, 60($pop27), $9
	i64.const	$push1=, 4294967296
	i64.store	$drop=, 16($11), $pop1
	i64.const	$push2=, 12884901890
	i64.store	$drop=, 24($11), $pop2
	i64.const	$push3=, 21474836484
	i64.store	$drop=, 32($11), $pop3
	i64.const	$push4=, 30064771078
	i64.store	$drop=, 40($11), $pop4
	i32.load	$push26=, 60($11)
	tee_local	$push25=, $9=, $pop26
	i32.const	$push24=, 4
	i32.add 	$push5=, $pop25, $pop24
	i32.store	$drop=, 60($11), $pop5
	i32.const	$push6=, 8
	i32.store	$12=, 48($11), $pop6
	i32.load	$13=, 0($9)
	i32.add 	$push7=, $9, $12
	i32.store	$drop=, 60($11), $pop7
	i32.store	$drop=, 52($11), $13
	i32.load	$push8=, 4($9)
	i32.store	$drop=, 56($11), $pop8
	i32.const	$push20=, 16
	i32.add 	$push21=, $11, $pop20
	i32.const	$push23=, 4
	i32.or  	$12=, $pop21, $pop23
	i32.const	$13=, 0
	i32.const	$9=, 0
.LBB9_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label25:
	block
	i32.eq  	$push9=, $9, $13
	br_if   	0, $pop9        # 0: down to label27
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB9_1 Depth=1
	i32.store	$10=, 12($11), $9
	i32.store	$drop=, 8($11), $13
	i32.store	$drop=, 4($11), $10
	i32.const	$push35=, .L.str.9
	i32.store	$drop=, 0($11), $pop35
	i32.const	$push34=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop34, $11
	i32.const	$push33=, 0
	i32.const	$push32=, 0
	i32.load	$push10=, errors($pop32)
	i32.const	$push31=, 1
	i32.add 	$push11=, $pop10, $pop31
	i32.store	$drop=, errors($pop33), $pop11
.LBB9_3:                                # %for.inc.i
                                        #   in Loop: Header=BB9_1 Depth=1
	end_block                       # label27:
	i32.const	$push36=, 10
	i32.eq  	$push12=, $9, $pop36
	br_if   	1, $pop12       # 1: down to label26
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB9_1 Depth=1
	i32.const	$push30=, 1
	i32.add 	$9=, $9, $pop30
	i32.load	$13=, 0($12)
	i32.const	$push29=, 4
	i32.add 	$push0=, $12, $pop29
	copy_local	$12=, $pop0
	br      	0               # 0: up to label25
.LBB9_5:                                # %verify.exit
	end_loop                        # label26:
	i32.const	$push19=, 0
	i32.const	$push17=, 64
	i32.add 	$push18=, $11, $pop17
	i32.store	$drop=, __stack_pointer($pop19), $pop18
                                        # fallthrough-return
	.endfunc
.Lfunc_end9:
	.size	varargs8, .Lfunc_end9-varargs8

	.section	.text.varargs9,"ax",@progbits
	.type	varargs9,@function
varargs9:                               # @varargs9
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.const	$push12=, 0
	i32.load	$push13=, __stack_pointer($pop12)
	i32.const	$push14=, 64
	i32.sub 	$push21=, $pop13, $pop14
	i32.store	$push27=, __stack_pointer($pop15), $pop21
	tee_local	$push26=, $12=, $pop27
	i32.store	$drop=, 60($pop26), $10
	i64.const	$push1=, 4294967296
	i64.store	$drop=, 16($12), $pop1
	i64.const	$push2=, 12884901890
	i64.store	$drop=, 24($12), $pop2
	i64.const	$push3=, 21474836484
	i64.store	$drop=, 32($12), $pop3
	i64.const	$push4=, 30064771078
	i64.store	$drop=, 40($12), $pop4
	i64.const	$push5=, 38654705672
	i64.store	$drop=, 48($12), $pop5
	i32.load	$push25=, 60($12)
	tee_local	$push24=, $10=, $pop25
	i32.const	$push23=, 4
	i32.add 	$push6=, $pop24, $pop23
	i32.store	$drop=, 60($12), $pop6
	i32.load	$push7=, 0($10)
	i32.store	$drop=, 56($12), $pop7
	i32.const	$push19=, 16
	i32.add 	$push20=, $12, $pop19
	i32.const	$push22=, 4
	i32.or  	$13=, $pop20, $pop22
	i32.const	$14=, 0
	i32.const	$10=, 0
.LBB10_1:                               # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label28:
	block
	i32.eq  	$push8=, $10, $14
	br_if   	0, $pop8        # 0: down to label30
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB10_1 Depth=1
	i32.store	$11=, 12($12), $10
	i32.store	$drop=, 8($12), $14
	i32.store	$drop=, 4($12), $11
	i32.const	$push34=, .L.str.10
	i32.store	$drop=, 0($12), $pop34
	i32.const	$push33=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop33, $12
	i32.const	$push32=, 0
	i32.const	$push31=, 0
	i32.load	$push9=, errors($pop31)
	i32.const	$push30=, 1
	i32.add 	$push10=, $pop9, $pop30
	i32.store	$drop=, errors($pop32), $pop10
.LBB10_3:                               # %for.inc.i
                                        #   in Loop: Header=BB10_1 Depth=1
	end_block                       # label30:
	i32.const	$push35=, 10
	i32.eq  	$push11=, $10, $pop35
	br_if   	1, $pop11       # 1: down to label29
# BB#4:                                 # %for.inc.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB10_1 Depth=1
	i32.const	$push29=, 1
	i32.add 	$10=, $10, $pop29
	i32.load	$14=, 0($13)
	i32.const	$push28=, 4
	i32.add 	$push0=, $13, $pop28
	copy_local	$13=, $pop0
	br      	0               # 0: up to label28
.LBB10_5:                               # %verify.exit
	end_loop                        # label29:
	i32.const	$push18=, 0
	i32.const	$push16=, 64
	i32.add 	$push17=, $12, $pop16
	i32.store	$drop=, __stack_pointer($pop18), $pop17
                                        # fallthrough-return
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
	.functype	abort, void
	.functype	exit, void, i32
	.functype	printf, i32, i32
