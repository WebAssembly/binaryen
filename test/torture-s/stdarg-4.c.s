	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/stdarg-4.c"
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
	i32.store	$drop=, x($pop14), $pop13
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
	i32.const	$push16=, 0
	i32.load	$push17=, __stack_pointer($pop16)
	i32.const	$push18=, 16
	i32.sub 	$push19=, $pop17, $pop18
	i32.store	$push0=, 12($pop19), $1
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push22=, $pop2, $pop3
	tee_local	$push21=, $1=, $pop22
	i32.const	$push9=, 19
	i32.add 	$push10=, $pop21, $pop9
	i32.const	$push20=, -8
	i32.and 	$push11=, $pop10, $pop20
	f64.load	$push12=, 0($pop11)
	i32.load	$push4=, 8($1)
	f64.load	$push5=, 0($1)
	i32.trunc_s/f64	$push6=, $pop5
	i32.add 	$push7=, $pop4, $pop6
	f64.convert_s/i32	$push8=, $pop7
	f64.add 	$push13=, $pop12, $pop8
	i32.trunc_s/f64	$push14=, $pop13
	i32.store	$drop=, x($pop15), $pop14
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
	i32.store	$drop=, y($pop10), $pop9
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
	i32.store	$drop=, x($pop23), $pop21
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
	i32.const	$push10=, 0
	i32.const	$push22=, 0
	i32.load	$push23=, __stack_pointer($pop22)
	i32.const	$push24=, 16
	i32.sub 	$push25=, $pop23, $pop24
	i32.store	$push31=, 12($pop25), $1
	tee_local	$push30=, $2=, $pop31
	i32.const	$push4=, 15
	i32.add 	$push5=, $pop30, $pop4
	i32.const	$push6=, -8
	i32.and 	$push29=, $pop5, $pop6
	tee_local	$push28=, $1=, $pop29
	f64.load	$push7=, 0($pop28)
	i32.load	$push1=, 4($2)
	i32.load	$push0=, 0($2)
	i32.add 	$push2=, $pop1, $pop0
	f64.convert_s/i32	$push3=, $pop2
	f64.add 	$push8=, $pop7, $pop3
	i32.trunc_s/f64	$push9=, $pop8
	i32.store	$drop=, y($pop10), $pop9
	i32.const	$push27=, 0
	i32.const	$push16=, 27
	i32.add 	$push17=, $1, $pop16
	i32.const	$push26=, -8
	i32.and 	$push18=, $pop17, $pop26
	f64.load	$push19=, 0($pop18)
	i32.load	$push11=, 16($1)
	f64.load	$push12=, 8($1)
	i32.trunc_s/f64	$push13=, $pop12
	i32.add 	$push14=, $pop11, $pop13
	f64.convert_s/i32	$push15=, $pop14
	f64.add 	$push20=, $pop19, $pop15
	i32.trunc_s/f64	$push21=, $pop20
	i32.store	$drop=, x($pop27), $pop21
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
	i32.sub 	$push39=, $pop33, $pop34
	i32.store	$push41=, __stack_pointer($pop35), $pop39
	tee_local	$push40=, $2=, $pop41
	i32.store	$drop=, 12($pop40), $1
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
	i32.load	$push43=, 12($2)
	tee_local	$push42=, $0=, $pop43
	i32.const	$push28=, 4
	i32.add 	$push29=, $pop42, $pop28
	i32.store	$drop=, 12($2), $pop29
	i32.load	$push30=, 0($0)
	i32.const	$push31=, 1
	i32.add 	$1=, $pop30, $pop31
	br      	3               # 3: down to label1
.LBB5_3:                                # %sw.bb4
	end_block                       # label4:
	i32.load	$push45=, 12($2)
	tee_local	$push44=, $0=, $pop45
	i32.const	$push21=, 4
	i32.add 	$push22=, $pop44, $pop21
	i32.store	$drop=, 12($2), $pop22
	i32.load	$1=, 0($0)
	i32.const	$push23=, 8
	i32.add 	$push24=, $0, $pop23
	i32.store	$drop=, 12($2), $pop24
	i32.load	$push25=, 4($0)
	i32.add 	$push26=, $1, $pop25
	i32.const	$push27=, 2
	i32.add 	$1=, $pop26, $pop27
	br      	2               # 2: down to label1
.LBB5_4:                                # %sw.bb18
	end_block                       # label3:
	i32.load	$push48=, 12($2)
	tee_local	$push47=, $0=, $pop48
	i32.const	$push2=, 4
	i32.add 	$push3=, $pop47, $pop2
	i32.store	$drop=, 12($2), $pop3
	i32.load	$1=, 0($0)
	i32.const	$push4=, 16
	i32.add 	$push5=, $0, $pop4
	i32.store	$drop=, 12($2), $pop5
	i32.load	$push6=, 4($0)
	i32.add 	$push7=, $1, $pop6
	i32.load	$push8=, 8($0)
	i32.add 	$push9=, $pop7, $pop8
	i32.load	$push10=, 12($0)
	i32.add 	$push11=, $pop9, $pop10
	i32.const	$push46=, 4
	i32.add 	$1=, $pop11, $pop46
	br      	1               # 1: down to label1
.LBB5_5:                                # %sw.bb10
	end_block                       # label2:
	i32.load	$push50=, 12($2)
	tee_local	$push49=, $0=, $pop50
	i32.const	$push12=, 4
	i32.add 	$push13=, $pop49, $pop12
	i32.store	$drop=, 12($2), $pop13
	i32.load	$1=, 0($0)
	i32.const	$push14=, 12
	i32.add 	$push15=, $0, $pop14
	i32.store	$drop=, 12($2), $pop15
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
	i32.store	$drop=, __stack_pointer($pop38), $pop37
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
	.local  	i32, i32, f64
# BB#0:                                 # %entry
	i32.const	$push38=, 0
	i32.const	$push35=, 0
	i32.load	$push36=, __stack_pointer($pop35)
	i32.const	$push37=, 16
	i32.sub 	$push42=, $pop36, $pop37
	i32.store	$push44=, __stack_pointer($pop38), $pop42
	tee_local	$push43=, $3=, $pop44
	i32.store	$drop=, 12($pop43), $1
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
	i32.load	$push15=, 12($3)
	i32.const	$push14=, 7
	i32.add 	$push16=, $pop15, $pop14
	i32.const	$push17=, -8
	i32.and 	$push48=, $pop16, $pop17
	tee_local	$push47=, $1=, $pop48
	i32.const	$push18=, 8
	i32.add 	$push46=, $pop47, $pop18
	tee_local	$push45=, $0=, $pop46
	i32.store	$drop=, 12($3), $pop45
	f64.load	$4=, 0($1)
	br      	1               # 1: down to label7
.LBB6_3:                                # %sw.bb2
	end_block                       # label8:
	i32.const	$push10=, 0
	i32.load	$push5=, 12($3)
	i32.const	$push4=, 7
	i32.add 	$push6=, $pop5, $pop4
	i32.const	$push7=, -8
	i32.and 	$push52=, $pop6, $pop7
	tee_local	$push51=, $1=, $pop52
	f64.load	$push8=, 0($pop51)
	i32.trunc_s/f64	$push9=, $pop8
	i32.store	$2=, y($pop10), $pop9
	i32.const	$push11=, 16
	i32.add 	$push50=, $1, $pop11
	tee_local	$push49=, $0=, $pop50
	i32.store	$drop=, 12($3), $pop49
	f64.convert_s/i32	$push13=, $2
	f64.load	$push12=, 8($1)
	f64.add 	$4=, $pop13, $pop12
.LBB6_4:                                # %sw.epilog
	end_block                       # label7:
	i32.const	$push20=, 0
	i32.trunc_s/f64	$push19=, $4
	i32.store	$drop=, y($pop20), $pop19
	i32.const	$push56=, 0
	i32.const	$push21=, 7
	i32.add 	$push22=, $0, $pop21
	i32.const	$push23=, -8
	i32.and 	$push55=, $pop22, $pop23
	tee_local	$push54=, $0=, $pop55
	i32.const	$push29=, 19
	i32.add 	$push30=, $pop54, $pop29
	i32.const	$push53=, -8
	i32.and 	$push31=, $pop30, $pop53
	f64.load	$push32=, 0($pop31)
	i32.load	$push24=, 8($0)
	f64.load	$push25=, 0($0)
	i32.trunc_s/f64	$push26=, $pop25
	i32.add 	$push27=, $pop24, $pop26
	f64.convert_s/i32	$push28=, $pop27
	f64.add 	$push33=, $pop32, $pop28
	i32.trunc_s/f64	$push34=, $pop33
	i32.store	$drop=, x($pop56), $pop34
	i32.const	$push41=, 0
	i32.const	$push39=, 16
	i32.add 	$push40=, $3, $pop39
	i32.store	$drop=, __stack_pointer($pop41), $pop40
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
	.local  	i64, i32
# BB#0:                                 # %entry
	i32.const	$push80=, 0
	i32.const	$push77=, 0
	i32.load	$push78=, __stack_pointer($pop77)
	i32.const	$push79=, 224
	i32.sub 	$push104=, $pop78, $pop79
	i32.store	$push108=, __stack_pointer($pop80), $pop104
	tee_local	$push107=, $1=, $pop108
	i32.const	$push84=, 192
	i32.add 	$push85=, $pop107, $pop84
	i32.const	$push106=, 16
	i32.add 	$push0=, $pop85, $pop106
	i64.const	$push1=, 4629700416936869888
	i64.store	$drop=, 0($pop0), $pop1
	i32.const	$push2=, 128
	i32.store	$drop=, 200($1), $pop2
	i64.const	$push3=, 4625196817309499392
	i64.store	$drop=, 192($1), $pop3
	i32.const	$push86=, 192
	i32.add 	$push87=, $1, $pop86
	call    	f1@FUNCTION, $1, $pop87
	block
	i32.const	$push105=, 0
	i32.load	$push4=, x($pop105)
	i32.const	$push5=, 176
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label9
# BB#1:                                 # %if.end
	i32.const	$push8=, 176
	i32.add 	$push9=, $1, $pop8
	i64.const	$push10=, 4634204016564240384
	i64.store	$drop=, 0($pop9), $pop10
	i32.const	$push11=, 168
	i32.add 	$push12=, $1, $pop11
	i32.const	$push13=, 17
	i32.store	$drop=, 0($pop12), $pop13
	i32.const	$push88=, 144
	i32.add 	$push89=, $1, $pop88
	i32.const	$push110=, 16
	i32.add 	$push14=, $pop89, $pop110
	i64.const	$push15=, 4626041242239631360
	i64.store	$drop=, 0($pop14), $pop15
	i64.const	$push16=, 4625759767262920704
	i64.store	$drop=, 152($1), $pop16
	i64.const	$push17=, 30064771077
	i64.store	$drop=, 144($1), $pop17
	i32.const	$push90=, 144
	i32.add 	$push91=, $1, $pop90
	call    	f2@FUNCTION, $1, $pop91
	i32.const	$push109=, 0
	i32.load	$push18=, x($pop109)
	i32.const	$push19=, 100
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label9
# BB#2:                                 # %if.end
	i32.const	$push111=, 0
	i32.load	$push7=, y($pop111)
	i32.const	$push21=, 30
	i32.ne  	$push22=, $pop7, $pop21
	br_if   	0, $pop22       # 0: down to label9
# BB#3:                                 # %if.end4
	i32.const	$push23=, 0
	i32.const	$push112=, 0
	i32.call	$push24=, f3@FUNCTION, $pop23, $pop112
	br_if   	0, $pop24       # 0: down to label9
# BB#4:                                 # %if.end7
	i32.const	$push25=, 18
	i32.store	$drop=, 128($1), $pop25
	i32.const	$push26=, 1
	i32.const	$push92=, 128
	i32.add 	$push93=, $1, $pop92
	i32.call	$push27=, f3@FUNCTION, $pop26, $pop93
	i32.const	$push28=, 19
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label9
# BB#5:                                 # %if.end11
	i64.const	$push30=, 429496729618
	i64.store	$0=, 112($1), $pop30
	i32.const	$push31=, 2
	i32.const	$push94=, 112
	i32.add 	$push95=, $1, $pop94
	i32.call	$push32=, f3@FUNCTION, $pop31, $pop95
	i32.const	$push33=, 120
	i32.ne  	$push34=, $pop32, $pop33
	br_if   	0, $pop34       # 0: down to label9
# BB#6:                                 # %if.end15
	i32.const	$push35=, 300
	i32.store	$drop=, 104($1), $pop35
	i64.store	$drop=, 96($1), $0
	i32.const	$push36=, 3
	i32.const	$push96=, 96
	i32.add 	$push97=, $1, $pop96
	i32.call	$push37=, f3@FUNCTION, $pop36, $pop97
	i32.const	$push38=, 421
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label9
# BB#7:                                 # %if.end19
	i64.const	$push40=, 369367187520
	i64.store	$drop=, 88($1), $pop40
	i64.const	$push41=, 304942678034
	i64.store	$drop=, 80($1), $pop41
	i32.const	$push113=, 4
	i32.const	$push98=, 80
	i32.add 	$push99=, $1, $pop98
	i32.call	$push42=, f3@FUNCTION, $pop113, $pop99
	i32.const	$push43=, 243
	i32.ne  	$push44=, $pop42, $pop43
	br_if   	0, $pop44       # 0: down to label9
# BB#8:                                 # %if.end23
	i32.const	$push46=, 72
	i32.add 	$push47=, $1, $pop46
	i64.const	$push48=, 4625759767262920704
	i64.store	$drop=, 0($pop47), $pop48
	i32.const	$push100=, 48
	i32.add 	$push101=, $1, $pop100
	i32.const	$push49=, 16
	i32.add 	$push50=, $pop101, $pop49
	i32.const	$push116=, 16
	i32.store	$drop=, 0($pop50), $pop116
	i64.const	$push51=, 4621256167635550208
	i64.store	$drop=, 56($1), $pop51
	i64.const	$push52=, 4618441417868443648
	i64.store	$drop=, 48($1), $pop52
	i32.const	$push115=, 4
	i32.const	$push102=, 48
	i32.add 	$push103=, $1, $pop102
	call    	f4@FUNCTION, $pop115, $pop103
	i32.const	$push114=, 0
	i32.load	$push53=, x($pop114)
	i32.const	$push54=, 43
	i32.ne  	$push55=, $pop53, $pop54
	br_if   	0, $pop55       # 0: down to label9
# BB#9:                                 # %if.end23
	i32.const	$push117=, 0
	i32.load	$push45=, y($pop117)
	i32.const	$push56=, 6
	i32.ne  	$push57=, $pop45, $pop56
	br_if   	0, $pop57       # 0: down to label9
# BB#10:                                # %if.end28
	i32.const	$push59=, 32
	i32.add 	$push60=, $1, $pop59
	i64.const	$push61=, 4638566878703255552
	i64.store	$drop=, 0($pop60), $pop61
	i32.const	$push62=, 24
	i32.add 	$push63=, $1, $pop62
	i32.const	$push64=, 17
	i32.store	$drop=, 0($pop63), $pop64
	i32.const	$push65=, 16
	i32.add 	$push66=, $1, $pop65
	i64.const	$push67=, 4607182418800017408
	i64.store	$drop=, 0($pop66), $pop67
	i64.const	$push68=, 4626604192193052672
	i64.store	$drop=, 8($1), $pop68
	i64.const	$push69=, 4619567317775286272
	i64.store	$drop=, 0($1), $pop69
	i32.const	$push70=, 5
	call    	f4@FUNCTION, $pop70, $1
	i32.const	$push118=, 0
	i32.load	$push71=, x($pop118)
	i32.const	$push72=, 144
	i32.ne  	$push73=, $pop71, $pop72
	br_if   	0, $pop73       # 0: down to label9
# BB#11:                                # %if.end28
	i32.const	$push119=, 0
	i32.load	$push58=, y($pop119)
	i32.const	$push74=, 28
	i32.ne  	$push75=, $pop58, $pop74
	br_if   	0, $pop75       # 0: down to label9
# BB#12:                                # %if.end33
	i32.const	$push83=, 0
	i32.const	$push81=, 224
	i32.add 	$push82=, $1, $pop81
	i32.store	$drop=, __stack_pointer($pop83), $pop82
	i32.const	$push76=, 0
	return  	$pop76
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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
