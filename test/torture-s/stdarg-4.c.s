	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/stdarg-4.c"
	.section	.text.f1i,"ax",@progbits
	.hidden	f1i
	.globl	f1i
	.type	f1i,@function
f1i:                                    # @f1i
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push19=, 0
	i32.const	$push1=, 7
	i32.add 	$push2=, $0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push18=, $pop2, $pop3
	tee_local	$push17=, $0=, $pop18
	f64.load	$push4=, 0($pop17)
	i32.trunc_s/f64	$push5=, $pop4
	i32.store	$push0=, x($pop19), $pop5
	i32.load	$push7=, 8($0)
	i32.add 	$push8=, $pop0, $pop7
	f64.convert_s/i32	$push13=, $pop8
	i32.const	$push9=, 19
	i32.add 	$push10=, $0, $pop9
	i32.const	$push16=, -8
	i32.and 	$push11=, $pop10, $pop16
	f64.load	$push12=, 0($pop11)
	f64.add 	$push14=, $pop13, $pop12
	i32.trunc_s/f64	$push15=, $pop14
	i32.store	$discard=, x($pop6), $pop15
	return
	.endfunc
.Lfunc_end0:
	.size	f1i, .Lfunc_end0-f1i

	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
	.local  	f64, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 7
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -8
	i32.and 	$push21=, $pop1, $pop2
	tee_local	$push20=, $3=, $pop21
	f64.load	$2=, 0($pop20)
	i32.const	$push14=, __stack_pointer
	i32.load	$push15=, 0($pop14)
	i32.const	$push16=, 16
	i32.sub 	$push17=, $pop15, $pop16
	i32.store	$discard=, 12($pop17), $1
	i32.const	$push4=, 0
	i32.trunc_s/f64	$push3=, $2
	i32.store	$1=, x($pop4), $pop3
	i32.const	$push19=, 0
	i32.const	$push7=, 19
	i32.add 	$push8=, $3, $pop7
	i32.const	$push18=, -8
	i32.and 	$push9=, $pop8, $pop18
	f64.load	$push10=, 0($pop9)
	i32.load	$push5=, 8($3)
	i32.add 	$push6=, $1, $pop5
	f64.convert_s/i32	$push11=, $pop6
	f64.add 	$push12=, $pop10, $pop11
	i32.trunc_s/f64	$push13=, $pop12
	i32.store	$discard=, x($pop19), $pop13
	return
	.endfunc
.Lfunc_end1:
	.size	f1, .Lfunc_end1-f1

	.section	.text.f2i,"ax",@progbits
	.hidden	f2i
	.globl	f2i
	.type	f2i,@function
f2i:                                    # @f2i
	.param  	i32
	.local  	i32, f64, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, 0($0)
	i32.store	$1=, y($pop1), $pop0
	i32.const	$push4=, 15
	i32.add 	$push5=, $0, $pop4
	i32.const	$push6=, -8
	i32.and 	$push26=, $pop5, $pop6
	tee_local	$push25=, $3=, $pop26
	f64.load	$2=, 8($pop25)
	i32.const	$push24=, 0
	i32.load	$push2=, 4($0)
	i32.add 	$push3=, $1, $pop2
	f64.convert_s/i32	$push8=, $pop3
	f64.load	$push7=, 0($3)
	f64.add 	$push9=, $pop8, $pop7
	i32.trunc_s/f64	$push10=, $pop9
	i32.store	$discard=, y($pop24), $pop10
	i32.const	$push23=, 0
	i32.trunc_s/f64	$push11=, $2
	i32.store	$0=, x($pop23), $pop11
	i32.const	$push22=, 0
	i32.const	$push14=, 27
	i32.add 	$push15=, $3, $pop14
	i32.const	$push21=, -8
	i32.and 	$push16=, $pop15, $pop21
	f64.load	$push17=, 0($pop16)
	i32.load	$push12=, 16($3)
	i32.add 	$push13=, $0, $pop12
	f64.convert_s/i32	$push18=, $pop13
	f64.add 	$push19=, $pop17, $pop18
	i32.trunc_s/f64	$push20=, $pop19
	i32.store	$discard=, x($pop22), $pop20
	return
	.endfunc
.Lfunc_end2:
	.size	f2i, .Lfunc_end2-f2i

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32
	.local  	i32, f64, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push21=, __stack_pointer
	i32.load	$push22=, 0($pop21)
	i32.const	$push23=, 16
	i32.sub 	$push24=, $pop22, $pop23
	i32.store	$push32=, 12($pop24), $1
	tee_local	$push31=, $4=, $pop32
	i32.load	$push0=, 0($pop31)
	i32.store	$2=, y($pop1), $pop0
	i32.const	$push4=, 15
	i32.add 	$push5=, $4, $pop4
	i32.const	$push6=, -8
	i32.and 	$push30=, $pop5, $pop6
	tee_local	$push29=, $1=, $pop30
	f64.load	$3=, 8($pop29)
	i32.const	$push28=, 0
	f64.load	$push7=, 0($1)
	i32.load	$push2=, 4($4)
	i32.add 	$push3=, $2, $pop2
	f64.convert_s/i32	$push8=, $pop3
	f64.add 	$push9=, $pop7, $pop8
	i32.trunc_s/f64	$push10=, $pop9
	i32.store	$discard=, y($pop28), $pop10
	i32.const	$push27=, 0
	i32.trunc_s/f64	$push11=, $3
	i32.store	$4=, x($pop27), $pop11
	i32.const	$push26=, 0
	i32.const	$push14=, 27
	i32.add 	$push15=, $1, $pop14
	i32.const	$push25=, -8
	i32.and 	$push16=, $pop15, $pop25
	f64.load	$push17=, 0($pop16)
	i32.load	$push12=, 16($1)
	i32.add 	$push13=, $4, $pop12
	f64.convert_s/i32	$push18=, $pop13
	f64.add 	$push19=, $pop17, $pop18
	i32.trunc_s/f64	$push20=, $pop19
	i32.store	$discard=, x($pop26), $pop20
	return
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
	return  	$pop3
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push38=, __stack_pointer
	i32.const	$push35=, __stack_pointer
	i32.load	$push36=, 0($pop35)
	i32.const	$push37=, 16
	i32.sub 	$push42=, $pop36, $pop37
	i32.store	$push44=, 0($pop38), $pop42
	tee_local	$push43=, $4=, $pop44
	i32.store	$discard=, 12($pop43), $1
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
	i32.load	$push46=, 12($4)
	tee_local	$push45=, $0=, $pop46
	i32.const	$push31=, 4
	i32.add 	$push32=, $pop45, $pop31
	i32.store	$discard=, 12($4), $pop32
	i32.load	$push33=, 0($0)
	i32.const	$push34=, 1
	i32.add 	$1=, $pop33, $pop34
	br      	3               # 3: down to label1
.LBB5_3:                                # %sw.bb4
	end_block                       # label4:
	i32.load	$push48=, 12($4)
	tee_local	$push47=, $0=, $pop48
	i32.const	$push24=, 4
	i32.add 	$push25=, $pop47, $pop24
	i32.store	$discard=, 12($4), $pop25
	i32.load	$1=, 0($0)
	i32.const	$push26=, 8
	i32.add 	$push27=, $0, $pop26
	i32.store	$discard=, 12($4), $pop27
	i32.load	$push28=, 4($0)
	i32.add 	$push29=, $1, $pop28
	i32.const	$push30=, 2
	i32.add 	$1=, $pop29, $pop30
	br      	2               # 2: down to label1
.LBB5_4:                                # %sw.bb18
	end_block                       # label3:
	i32.load	$push51=, 12($4)
	tee_local	$push50=, $0=, $pop51
	i32.const	$push2=, 4
	i32.add 	$push3=, $pop50, $pop2
	i32.store	$discard=, 12($4), $pop3
	i32.load	$1=, 0($0)
	i32.const	$push4=, 8
	i32.add 	$push5=, $0, $pop4
	i32.store	$discard=, 12($4), $pop5
	i32.load	$2=, 4($0)
	i32.const	$push6=, 12
	i32.add 	$push7=, $0, $pop6
	i32.store	$discard=, 12($4), $pop7
	i32.load	$3=, 8($0)
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	$discard=, 12($4), $pop9
	i32.add 	$push11=, $1, $2
	i32.add 	$push12=, $3, $pop11
	i32.load	$push10=, 12($0)
	i32.add 	$push13=, $pop12, $pop10
	i32.const	$push49=, 4
	i32.add 	$1=, $pop13, $pop49
	br      	1               # 1: down to label1
.LBB5_5:                                # %sw.bb10
	end_block                       # label2:
	i32.load	$push53=, 12($4)
	tee_local	$push52=, $0=, $pop53
	i32.const	$push14=, 4
	i32.add 	$push15=, $pop52, $pop14
	i32.store	$discard=, 12($4), $pop15
	i32.load	$1=, 0($0)
	i32.const	$push16=, 8
	i32.add 	$push17=, $0, $pop16
	i32.store	$discard=, 12($4), $pop17
	i32.load	$2=, 4($0)
	i32.const	$push18=, 12
	i32.add 	$push19=, $0, $pop18
	i32.store	$discard=, 12($4), $pop19
	i32.add 	$push21=, $1, $2
	i32.load	$push20=, 8($0)
	i32.add 	$push22=, $pop21, $pop20
	i32.const	$push23=, 3
	i32.add 	$1=, $pop22, $pop23
.LBB5_6:                                # %sw.epilog
	end_block                       # label1:
	i32.const	$push41=, __stack_pointer
	i32.const	$push39=, 16
	i32.add 	$push40=, $4, $pop39
	i32.store	$discard=, 0($pop41), $pop40
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
	.local  	f64, f64, i32
# BB#0:                                 # %entry
	i32.const	$push36=, __stack_pointer
	i32.const	$push33=, __stack_pointer
	i32.load	$push34=, 0($pop33)
	i32.const	$push35=, 16
	i32.sub 	$push40=, $pop34, $pop35
	i32.store	$push42=, 0($pop36), $pop40
	tee_local	$push41=, $4=, $pop42
	i32.store	$discard=, 12($pop41), $1
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
	i32.load	$push13=, 12($4)
	i32.const	$push14=, 7
	i32.add 	$push15=, $pop13, $pop14
	i32.const	$push16=, -8
	i32.and 	$push46=, $pop15, $pop16
	tee_local	$push45=, $0=, $pop46
	f64.load	$3=, 0($pop45)
	i32.const	$push17=, 8
	i32.add 	$push44=, $0, $pop17
	tee_local	$push43=, $0=, $pop44
	i32.store	$discard=, 12($4), $pop43
	br      	1               # 1: down to label7
.LBB6_3:                                # %sw.bb2
	end_block                       # label8:
	i32.load	$push4=, 12($4)
	i32.const	$push5=, 7
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push7=, -8
	i32.and 	$push52=, $pop6, $pop7
	tee_local	$push51=, $0=, $pop52
	f64.load	$push8=, 0($pop51)
	i32.trunc_s/f64	$push50=, $pop8
	tee_local	$push49=, $1=, $pop50
	f64.convert_s/i32	$push12=, $pop49
	f64.load	$push11=, 8($0)
	f64.add 	$3=, $pop12, $pop11
	i32.const	$push9=, 0
	i32.store	$discard=, y($pop9), $1
	i32.const	$push10=, 16
	i32.add 	$push48=, $0, $pop10
	tee_local	$push47=, $0=, $pop48
	i32.store	$discard=, 12($4), $pop47
.LBB6_4:                                # %sw.epilog
	end_block                       # label7:
	i32.const	$push20=, 7
	i32.add 	$push21=, $0, $pop20
	i32.const	$push22=, -8
	i32.and 	$push57=, $pop21, $pop22
	tee_local	$push56=, $0=, $pop57
	f64.load	$2=, 0($pop56)
	i32.const	$push19=, 0
	i32.trunc_s/f64	$push18=, $3
	i32.store	$discard=, y($pop19), $pop18
	i32.const	$push55=, 0
	i32.trunc_s/f64	$push23=, $2
	i32.store	$1=, x($pop55), $pop23
	i32.const	$push54=, 0
	i32.const	$push26=, 19
	i32.add 	$push27=, $0, $pop26
	i32.const	$push53=, -8
	i32.and 	$push28=, $pop27, $pop53
	f64.load	$push29=, 0($pop28)
	i32.load	$push24=, 8($0)
	i32.add 	$push25=, $1, $pop24
	f64.convert_s/i32	$push30=, $pop25
	f64.add 	$push31=, $pop29, $pop30
	i32.trunc_s/f64	$push32=, $pop31
	i32.store	$discard=, x($pop54), $pop32
	i32.const	$push39=, __stack_pointer
	i32.const	$push37=, 16
	i32.add 	$push38=, $4, $pop37
	i32.store	$discard=, 0($pop39), $pop38
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
	i32.const	$push80=, __stack_pointer
	i32.const	$push77=, __stack_pointer
	i32.load	$push78=, 0($pop77)
	i32.const	$push79=, 224
	i32.sub 	$push104=, $pop78, $pop79
	i32.store	$push108=, 0($pop80), $pop104
	tee_local	$push107=, $1=, $pop108
	i32.const	$push84=, 192
	i32.add 	$push85=, $pop107, $pop84
	i32.const	$push106=, 16
	i32.add 	$push0=, $pop85, $pop106
	i64.const	$push1=, 4629700416936869888
	i64.store	$discard=, 0($pop0), $pop1
	i32.const	$push2=, 128
	i32.store	$discard=, 200($1), $pop2
	i64.const	$push3=, 4625196817309499392
	i64.store	$discard=, 192($1), $pop3
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
	i64.store	$discard=, 0($pop9), $pop10
	i32.const	$push11=, 168
	i32.add 	$push12=, $1, $pop11
	i32.const	$push13=, 17
	i32.store	$discard=, 0($pop12), $pop13
	i32.const	$push88=, 144
	i32.add 	$push89=, $1, $pop88
	i32.const	$push110=, 16
	i32.add 	$push14=, $pop89, $pop110
	i64.const	$push15=, 4626041242239631360
	i64.store	$discard=, 0($pop14), $pop15
	i64.const	$push16=, 4625759767262920704
	i64.store	$discard=, 152($1), $pop16
	i64.const	$push17=, 30064771077
	i64.store	$discard=, 144($1), $pop17
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
	i32.store	$discard=, 128($1), $pop25
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
	i32.store	$discard=, 104($1), $pop35
	i64.store	$discard=, 96($1), $0
	i32.const	$push36=, 3
	i32.const	$push96=, 96
	i32.add 	$push97=, $1, $pop96
	i32.call	$push37=, f3@FUNCTION, $pop36, $pop97
	i32.const	$push38=, 421
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label9
# BB#7:                                 # %if.end19
	i64.const	$push40=, 369367187520
	i64.store	$discard=, 88($1), $pop40
	i64.const	$push41=, 304942678034
	i64.store	$discard=, 80($1), $pop41
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
	i64.store	$discard=, 0($pop47), $pop48
	i32.const	$push100=, 48
	i32.add 	$push101=, $1, $pop100
	i32.const	$push49=, 16
	i32.add 	$push50=, $pop101, $pop49
	i32.const	$push116=, 16
	i32.store	$discard=, 0($pop50), $pop116
	i64.const	$push51=, 4621256167635550208
	i64.store	$discard=, 56($1), $pop51
	i64.const	$push52=, 4618441417868443648
	i64.store	$discard=, 48($1), $pop52
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
	i64.store	$discard=, 0($pop60), $pop61
	i32.const	$push62=, 24
	i32.add 	$push63=, $1, $pop62
	i32.const	$push64=, 17
	i32.store	$discard=, 0($pop63), $pop64
	i32.const	$push65=, 16
	i32.add 	$push66=, $1, $pop65
	i64.const	$push67=, 4607182418800017408
	i64.store	$discard=, 0($pop66), $pop67
	i64.const	$push68=, 4626604192193052672
	i64.store	$discard=, 8($1), $pop68
	i64.const	$push69=, 4619567317775286272
	i64.store	$discard=, 0($1), $pop69
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
	i32.const	$push83=, __stack_pointer
	i32.const	$push81=, 224
	i32.add 	$push82=, $1, $pop81
	i32.store	$discard=, 0($pop83), $pop82
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
