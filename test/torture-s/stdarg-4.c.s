	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/stdarg-4.c"
	.section	.text.f1i,"ax",@progbits
	.hidden	f1i
	.globl	f1i
	.type	f1i,@function
f1i:                                    # @f1i
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push14=, 0
	i32.const	$push0=, 7
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, -8
	i32.and 	$push17=, $pop1, $pop2
	tee_local	$push16=, $0=, $pop17
	i32.load	$push3=, 8($pop16)
	f64.load	$push4=, 0($0)
	i32.trunc_s/f64	$push5=, $pop4
	i32.add 	$push6=, $pop3, $pop5
	f64.convert_s/i32	$push7=, $pop6
	i32.const	$push8=, 19
	i32.add 	$push9=, $0, $pop8
	i32.const	$push15=, -8
	i32.and 	$push10=, $pop9, $pop15
	f64.load	$push11=, 0($pop10)
	f64.add 	$push12=, $pop7, $pop11
	i32.trunc_s/f64	$push13=, $pop12
	i32.store	x($pop14), $pop13
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f1i, .Lfunc_end0-f1i

	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.load	$push16=, __stack_pointer($pop15)
	i32.const	$push17=, 16
	i32.sub 	$push18=, $pop16, $pop17
	i32.store	12($pop18), $1
	i32.const	$push14=, 0
	i32.const	$push0=, 7
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -8
	i32.and 	$push21=, $pop1, $pop2
	tee_local	$push20=, $1=, $pop21
	i32.const	$push8=, 19
	i32.add 	$push9=, $pop20, $pop8
	i32.const	$push19=, -8
	i32.and 	$push10=, $pop9, $pop19
	f64.load	$push11=, 0($pop10)
	i32.load	$push3=, 8($1)
	f64.load	$push4=, 0($1)
	i32.trunc_s/f64	$push5=, $pop4
	i32.add 	$push6=, $pop3, $pop5
	f64.convert_s/i32	$push7=, $pop6
	f64.add 	$push12=, $pop11, $pop7
	i32.trunc_s/f64	$push13=, $pop12
	i32.store	x($pop14), $pop13
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	f1, .Lfunc_end1-f1

	.section	.text.f2i,"ax",@progbits
	.hidden	f2i
	.globl	f2i
	.type	f2i,@function
f2i:                                    # @f2i
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.load	$push5=, 4($0)
	i32.load	$push4=, 0($0)
	i32.add 	$push6=, $pop5, $pop4
	f64.convert_s/i32	$push7=, $pop6
	i32.const	$push0=, 15
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, -8
	i32.and 	$push25=, $pop1, $pop2
	tee_local	$push24=, $0=, $pop25
	f64.load	$push3=, 0($pop24)
	f64.add 	$push8=, $pop7, $pop3
	i32.trunc_s/f64	$push9=, $pop8
	i32.store	y($pop10), $pop9
	i32.const	$push23=, 0
	i32.const	$push16=, 27
	i32.add 	$push17=, $0, $pop16
	i32.const	$push22=, -8
	i32.and 	$push18=, $pop17, $pop22
	f64.load	$push19=, 0($pop18)
	i32.load	$push11=, 16($0)
	f64.load	$push12=, 8($0)
	i32.trunc_s/f64	$push13=, $pop12
	i32.add 	$push14=, $pop11, $pop13
	f64.convert_s/i32	$push15=, $pop14
	f64.add 	$push20=, $pop19, $pop15
	i32.trunc_s/f64	$push21=, $pop20
	i32.store	x($pop23), $pop21
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	f2i, .Lfunc_end2-f2i

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push22=, 0
	i32.load	$push23=, __stack_pointer($pop22)
	i32.const	$push24=, 16
	i32.sub 	$push25=, $pop23, $pop24
	i32.store	12($pop25), $1
	i32.const	$push10=, 0
	i32.const	$push4=, 15
	i32.add 	$push5=, $1, $pop4
	i32.const	$push6=, -8
	i32.and 	$push29=, $pop5, $pop6
	tee_local	$push28=, $2=, $pop29
	f64.load	$push7=, 0($pop28)
	i32.load	$push1=, 4($1)
	i32.load	$push0=, 0($1)
	i32.add 	$push2=, $pop1, $pop0
	f64.convert_s/i32	$push3=, $pop2
	f64.add 	$push8=, $pop7, $pop3
	i32.trunc_s/f64	$push9=, $pop8
	i32.store	y($pop10), $pop9
	i32.const	$push27=, 0
	i32.const	$push16=, 27
	i32.add 	$push17=, $2, $pop16
	i32.const	$push26=, -8
	i32.and 	$push18=, $pop17, $pop26
	f64.load	$push19=, 0($pop18)
	i32.load	$push11=, 16($2)
	f64.load	$push12=, 8($2)
	i32.trunc_s/f64	$push13=, $pop12
	i32.add 	$push14=, $pop11, $pop13
	f64.convert_s/i32	$push15=, $pop14
	f64.add 	$push20=, $pop19, $pop15
	i32.trunc_s/f64	$push21=, $pop20
	i32.store	x($pop27), $pop21
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	f2, .Lfunc_end3-f2

	.section	.text.f3h,"ax",@progbits
	.hidden	f3h
	.globl	f3h
	.type	f3h,@function
f3h:                                    # @f3h
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.add 	$push0=, $1, $0
	i32.add 	$push1=, $pop0, $2
	i32.add 	$push2=, $pop1, $3
	i32.add 	$push3=, $pop2, $4
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end4:
	.size	f3h, .Lfunc_end4-f3h

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push35=, 0
	i32.const	$push32=, 0
	i32.load	$push33=, __stack_pointer($pop32)
	i32.const	$push34=, 16
	i32.sub 	$push40=, $pop33, $pop34
	tee_local	$push39=, $2=, $pop40
	i32.store	__stack_pointer($pop35), $pop39
	i32.store	12($2), $1
	block   	
	i32.const	$push0=, 4
	i32.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$1=, 0
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$0, 4, 0, 1, 3, 2, 4 # 4: down to label1
                                        # 0: down to label5
                                        # 1: down to label4
                                        # 3: down to label2
                                        # 2: down to label3
.LBB5_2:                                # %sw.bb2
	end_block                       # label5:
	i32.load	$push42=, 12($2)
	tee_local	$push41=, $0=, $pop42
	i32.const	$push28=, 4
	i32.add 	$push29=, $pop41, $pop28
	i32.store	12($2), $pop29
	i32.load	$push30=, 0($0)
	i32.const	$push31=, 1
	i32.add 	$1=, $pop30, $pop31
	br      	3               # 3: down to label1
.LBB5_3:                                # %sw.bb4
	end_block                       # label4:
	i32.load	$push44=, 12($2)
	tee_local	$push43=, $0=, $pop44
	i32.const	$push21=, 4
	i32.add 	$push22=, $pop43, $pop21
	i32.store	12($2), $pop22
	i32.load	$1=, 0($0)
	i32.const	$push23=, 8
	i32.add 	$push24=, $0, $pop23
	i32.store	12($2), $pop24
	i32.load	$push25=, 4($0)
	i32.add 	$push26=, $1, $pop25
	i32.const	$push27=, 2
	i32.add 	$1=, $pop26, $pop27
	br      	2               # 2: down to label1
.LBB5_4:                                # %sw.bb18
	end_block                       # label3:
	i32.load	$push47=, 12($2)
	tee_local	$push46=, $0=, $pop47
	i32.const	$push2=, 4
	i32.add 	$push3=, $pop46, $pop2
	i32.store	12($2), $pop3
	i32.load	$1=, 0($0)
	i32.const	$push4=, 16
	i32.add 	$push5=, $0, $pop4
	i32.store	12($2), $pop5
	i32.load	$push6=, 4($0)
	i32.add 	$push7=, $1, $pop6
	i32.load	$push8=, 8($0)
	i32.add 	$push9=, $pop7, $pop8
	i32.load	$push10=, 12($0)
	i32.add 	$push11=, $pop9, $pop10
	i32.const	$push45=, 4
	i32.add 	$1=, $pop11, $pop45
	br      	1               # 1: down to label1
.LBB5_5:                                # %sw.bb10
	end_block                       # label2:
	i32.load	$push49=, 12($2)
	tee_local	$push48=, $0=, $pop49
	i32.const	$push12=, 4
	i32.add 	$push13=, $pop48, $pop12
	i32.store	12($2), $pop13
	i32.load	$1=, 0($0)
	i32.const	$push14=, 12
	i32.add 	$push15=, $0, $pop14
	i32.store	12($2), $pop15
	i32.load	$push16=, 4($0)
	i32.add 	$push17=, $1, $pop16
	i32.load	$push18=, 8($0)
	i32.add 	$push19=, $pop17, $pop18
	i32.const	$push20=, 3
	i32.add 	$1=, $pop19, $pop20
.LBB5_6:                                # %sw.epilog
	end_block                       # label1:
	i32.const	$push38=, 0
	i32.const	$push36=, 16
	i32.add 	$push37=, $2, $pop36
	i32.store	__stack_pointer($pop38), $pop37
	return  	$1
.LBB5_7:                                # %sw.default
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	f3, .Lfunc_end5-f3

	.section	.text.f4,"ax",@progbits
	.hidden	f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32
	.local  	i32, f64, i32
# BB#0:                                 # %entry
	i32.const	$push37=, 0
	i32.const	$push34=, 0
	i32.load	$push35=, __stack_pointer($pop34)
	i32.const	$push36=, 16
	i32.sub 	$push42=, $pop35, $pop36
	tee_local	$push41=, $4=, $pop42
	i32.store	__stack_pointer($pop37), $pop41
	i32.store	12($4), $1
	block   	
	block   	
	block   	
	i32.const	$push0=, 5
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label8
# BB#1:                                 # %entry
	i32.const	$push2=, 4
	i32.ne  	$push3=, $0, $pop2
	br_if   	2, $pop3        # 2: down to label6
# BB#2:                                 # %sw.bb
	i32.load	$push14=, 12($4)
	i32.const	$push13=, 7
	i32.add 	$push15=, $pop14, $pop13
	i32.const	$push16=, -8
	i32.and 	$push46=, $pop15, $pop16
	tee_local	$push45=, $1=, $pop46
	i32.const	$push17=, 8
	i32.add 	$push44=, $pop45, $pop17
	tee_local	$push43=, $0=, $pop44
	i32.store	12($4), $pop43
	f64.load	$3=, 0($1)
	br      	1               # 1: down to label7
.LBB6_3:                                # %sw.bb2
	end_block                       # label8:
	i32.const	$push9=, 0
	i32.load	$push5=, 12($4)
	i32.const	$push4=, 7
	i32.add 	$push6=, $pop5, $pop4
	i32.const	$push7=, -8
	i32.and 	$push52=, $pop6, $pop7
	tee_local	$push51=, $1=, $pop52
	f64.load	$push8=, 0($pop51)
	i32.trunc_s/f64	$push50=, $pop8
	tee_local	$push49=, $2=, $pop50
	i32.store	y($pop9), $pop49
	i32.const	$push10=, 16
	i32.add 	$push48=, $1, $pop10
	tee_local	$push47=, $0=, $pop48
	i32.store	12($4), $pop47
	f64.convert_s/i32	$push12=, $2
	f64.load	$push11=, 8($1)
	f64.add 	$3=, $pop12, $pop11
.LBB6_4:                                # %sw.epilog
	end_block                       # label7:
	i32.const	$push19=, 0
	i32.trunc_s/f64	$push18=, $3
	i32.store	y($pop19), $pop18
	i32.const	$push56=, 0
	i32.const	$push20=, 7
	i32.add 	$push21=, $0, $pop20
	i32.const	$push22=, -8
	i32.and 	$push55=, $pop21, $pop22
	tee_local	$push54=, $0=, $pop55
	i32.const	$push28=, 19
	i32.add 	$push29=, $pop54, $pop28
	i32.const	$push53=, -8
	i32.and 	$push30=, $pop29, $pop53
	f64.load	$push31=, 0($pop30)
	i32.load	$push23=, 8($0)
	f64.load	$push24=, 0($0)
	i32.trunc_s/f64	$push25=, $pop24
	i32.add 	$push26=, $pop23, $pop25
	f64.convert_s/i32	$push27=, $pop26
	f64.add 	$push32=, $pop31, $pop27
	i32.trunc_s/f64	$push33=, $pop32
	i32.store	x($pop56), $pop33
	i32.const	$push40=, 0
	i32.const	$push38=, 16
	i32.add 	$push39=, $4, $pop38
	i32.store	__stack_pointer($pop40), $pop39
	return
.LBB6_5:                                # %sw.default
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end6:
	.size	f4, .Lfunc_end6-f4

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push79=, 0
	i32.const	$push76=, 0
	i32.load	$push77=, __stack_pointer($pop76)
	i32.const	$push78=, 224
	i32.sub 	$push106=, $pop77, $pop78
	tee_local	$push105=, $0=, $pop106
	i32.store	__stack_pointer($pop79), $pop105
	i32.const	$push83=, 192
	i32.add 	$push84=, $0, $pop83
	i32.const	$push104=, 16
	i32.add 	$push0=, $pop84, $pop104
	i64.const	$push1=, 4629700416936869888
	i64.store	0($pop0), $pop1
	i32.const	$push2=, 128
	i32.store	200($0), $pop2
	i64.const	$push3=, 4625196817309499392
	i64.store	192($0), $pop3
	i32.const	$push85=, 192
	i32.add 	$push86=, $0, $pop85
	call    	f1@FUNCTION, $0, $pop86
	block   	
	i32.const	$push103=, 0
	i32.load	$push4=, x($pop103)
	i32.const	$push5=, 176
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label9
# BB#1:                                 # %if.end
	i32.const	$push8=, 176
	i32.add 	$push9=, $0, $pop8
	i64.const	$push10=, 4634204016564240384
	i64.store	0($pop9), $pop10
	i32.const	$push11=, 168
	i32.add 	$push12=, $0, $pop11
	i32.const	$push13=, 17
	i32.store	0($pop12), $pop13
	i32.const	$push87=, 144
	i32.add 	$push88=, $0, $pop87
	i32.const	$push108=, 16
	i32.add 	$push14=, $pop88, $pop108
	i64.const	$push15=, 4626041242239631360
	i64.store	0($pop14), $pop15
	i64.const	$push16=, 4625759767262920704
	i64.store	152($0), $pop16
	i64.const	$push17=, 30064771077
	i64.store	144($0), $pop17
	i32.const	$push89=, 144
	i32.add 	$push90=, $0, $pop89
	call    	f2@FUNCTION, $0, $pop90
	i32.const	$push107=, 0
	i32.load	$push18=, x($pop107)
	i32.const	$push19=, 100
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label9
# BB#2:                                 # %if.end
	i32.const	$push109=, 0
	i32.load	$push7=, y($pop109)
	i32.const	$push21=, 30
	i32.ne  	$push22=, $pop7, $pop21
	br_if   	0, $pop22       # 0: down to label9
# BB#3:                                 # %if.end4
	i32.const	$push23=, 0
	i32.const	$push110=, 0
	i32.call	$push24=, f3@FUNCTION, $pop23, $pop110
	br_if   	0, $pop24       # 0: down to label9
# BB#4:                                 # %if.end7
	i32.const	$push25=, 18
	i32.store	128($0), $pop25
	i32.const	$push26=, 1
	i32.const	$push91=, 128
	i32.add 	$push92=, $0, $pop91
	i32.call	$push27=, f3@FUNCTION, $pop26, $pop92
	i32.const	$push28=, 19
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label9
# BB#5:                                 # %if.end11
	i64.const	$push111=, 429496729618
	i64.store	112($0), $pop111
	i32.const	$push30=, 2
	i32.const	$push93=, 112
	i32.add 	$push94=, $0, $pop93
	i32.call	$push31=, f3@FUNCTION, $pop30, $pop94
	i32.const	$push32=, 120
	i32.ne  	$push33=, $pop31, $pop32
	br_if   	0, $pop33       # 0: down to label9
# BB#6:                                 # %if.end15
	i32.const	$push34=, 300
	i32.store	104($0), $pop34
	i64.const	$push112=, 429496729618
	i64.store	96($0), $pop112
	i32.const	$push35=, 3
	i32.const	$push95=, 96
	i32.add 	$push96=, $0, $pop95
	i32.call	$push36=, f3@FUNCTION, $pop35, $pop96
	i32.const	$push37=, 421
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	0, $pop38       # 0: down to label9
# BB#7:                                 # %if.end19
	i64.const	$push39=, 369367187520
	i64.store	88($0), $pop39
	i64.const	$push40=, 304942678034
	i64.store	80($0), $pop40
	i32.const	$push113=, 4
	i32.const	$push97=, 80
	i32.add 	$push98=, $0, $pop97
	i32.call	$push41=, f3@FUNCTION, $pop113, $pop98
	i32.const	$push42=, 243
	i32.ne  	$push43=, $pop41, $pop42
	br_if   	0, $pop43       # 0: down to label9
# BB#8:                                 # %if.end23
	i32.const	$push45=, 72
	i32.add 	$push46=, $0, $pop45
	i64.const	$push47=, 4625759767262920704
	i64.store	0($pop46), $pop47
	i32.const	$push99=, 48
	i32.add 	$push100=, $0, $pop99
	i32.const	$push48=, 16
	i32.add 	$push49=, $pop100, $pop48
	i32.const	$push116=, 16
	i32.store	0($pop49), $pop116
	i64.const	$push50=, 4621256167635550208
	i64.store	56($0), $pop50
	i64.const	$push51=, 4618441417868443648
	i64.store	48($0), $pop51
	i32.const	$push115=, 4
	i32.const	$push101=, 48
	i32.add 	$push102=, $0, $pop101
	call    	f4@FUNCTION, $pop115, $pop102
	i32.const	$push114=, 0
	i32.load	$push52=, x($pop114)
	i32.const	$push53=, 43
	i32.ne  	$push54=, $pop52, $pop53
	br_if   	0, $pop54       # 0: down to label9
# BB#9:                                 # %if.end23
	i32.const	$push117=, 0
	i32.load	$push44=, y($pop117)
	i32.const	$push55=, 6
	i32.ne  	$push56=, $pop44, $pop55
	br_if   	0, $pop56       # 0: down to label9
# BB#10:                                # %if.end28
	i32.const	$push58=, 32
	i32.add 	$push59=, $0, $pop58
	i64.const	$push60=, 4638566878703255552
	i64.store	0($pop59), $pop60
	i32.const	$push61=, 24
	i32.add 	$push62=, $0, $pop61
	i32.const	$push63=, 17
	i32.store	0($pop62), $pop63
	i32.const	$push64=, 16
	i32.add 	$push65=, $0, $pop64
	i64.const	$push66=, 4607182418800017408
	i64.store	0($pop65), $pop66
	i64.const	$push67=, 4626604192193052672
	i64.store	8($0), $pop67
	i64.const	$push68=, 4619567317775286272
	i64.store	0($0), $pop68
	i32.const	$push69=, 5
	call    	f4@FUNCTION, $pop69, $0
	i32.const	$push118=, 0
	i32.load	$push70=, x($pop118)
	i32.const	$push71=, 144
	i32.ne  	$push72=, $pop70, $pop71
	br_if   	0, $pop72       # 0: down to label9
# BB#11:                                # %if.end28
	i32.const	$push119=, 0
	i32.load	$push57=, y($pop119)
	i32.const	$push73=, 28
	i32.ne  	$push74=, $pop57, $pop73
	br_if   	0, $pop74       # 0: down to label9
# BB#12:                                # %if.end33
	i32.const	$push82=, 0
	i32.const	$push80=, 224
	i32.add 	$push81=, $0, $pop80
	i32.store	__stack_pointer($pop82), $pop81
	i32.const	$push75=, 0
	return  	$pop75
.LBB7_13:                               # %if.then32
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end7:
	.size	main, .Lfunc_end7-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	2
x:
	.int32	0                       # 0x0
	.size	x, 4

	.hidden	y                       # @y
	.type	y,@object
	.section	.bss.y,"aw",@nobits
	.globl	y
	.p2align	2
y:
	.int32	0                       # 0x0
	.size	y, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
