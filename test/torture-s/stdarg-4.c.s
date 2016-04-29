	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/stdarg-4.c"
	.section	.text.f1i,"ax",@progbits
	.hidden	f1i
	.globl	f1i
	.type	f1i,@function
f1i:                                    # @f1i
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push19=, 0
	i32.const	$push0=, 7
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, -8
	i32.and 	$push18=, $pop1, $pop2
	tee_local	$push17=, $0=, $pop18
	f64.load	$push3=, 0($pop17)
	i32.trunc_s/f64	$push4=, $pop3
	i32.store	$push6=, x($pop19), $pop4
	i32.load	$push7=, 8($0)
	i32.add 	$push8=, $pop6, $pop7
	f64.convert_s/i32	$push13=, $pop8
	i32.const	$push9=, 19
	i32.add 	$push10=, $0, $pop9
	i32.const	$push16=, -8
	i32.and 	$push11=, $pop10, $pop16
	f64.load	$push12=, 0($pop11)
	f64.add 	$push14=, $pop13, $pop12
	i32.trunc_s/f64	$push15=, $pop14
	i32.store	$discard=, x($pop5), $pop15
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, __stack_pointer
	i32.load	$push21=, 0($pop20)
	i32.const	$push22=, 16
	i32.sub 	$3=, $pop21, $pop22
	i32.const	$push6=, 0
	i32.store	$push0=, 12($3), $1
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push19=, $pop2, $pop3
	tee_local	$push18=, $1=, $pop19
	f64.load	$push4=, 0($pop18)
	i32.trunc_s/f64	$push5=, $pop4
	i32.store	$2=, x($pop6), $pop5
	i32.const	$push17=, 0
	i32.const	$push9=, 19
	i32.add 	$push10=, $1, $pop9
	i32.const	$push16=, -8
	i32.and 	$push11=, $pop10, $pop16
	f64.load	$push12=, 0($pop11)
	i32.load	$push7=, 8($1)
	i32.add 	$push8=, $2, $pop7
	f64.convert_s/i32	$push13=, $pop8
	f64.add 	$push14=, $pop12, $pop13
	i32.trunc_s/f64	$push15=, $pop14
	i32.store	$discard=, x($pop17), $pop15
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
	.local  	i32, f64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push29=, __stack_pointer
	i32.load	$push30=, 0($pop29)
	i32.const	$push31=, 16
	i32.sub 	$5=, $pop30, $pop31
	i32.const	$push1=, 0
	i32.store	$push28=, 12($5), $1
	tee_local	$push27=, $4=, $pop28
	i32.load	$push0=, 0($pop27)
	i32.store	$2=, y($pop1), $pop0
	i32.const	$push4=, 15
	i32.add 	$push5=, $4, $pop4
	i32.const	$push6=, -8
	i32.and 	$push26=, $pop5, $pop6
	tee_local	$push25=, $1=, $pop26
	f64.load	$3=, 8($pop25)
	i32.const	$push24=, 0
	f64.load	$push7=, 0($1)
	i32.load	$push2=, 4($4)
	i32.add 	$push3=, $2, $pop2
	f64.convert_s/i32	$push8=, $pop3
	f64.add 	$push9=, $pop7, $pop8
	i32.trunc_s/f64	$push10=, $pop9
	i32.store	$discard=, y($pop24), $pop10
	i32.const	$push23=, 0
	i32.trunc_s/f64	$push11=, $3
	i32.store	$4=, x($pop23), $pop11
	i32.const	$push22=, 0
	i32.const	$push14=, 27
	i32.add 	$push15=, $1, $pop14
	i32.const	$push21=, -8
	i32.and 	$push16=, $pop15, $pop21
	f64.load	$push17=, 0($pop16)
	i32.load	$push12=, 16($1)
	i32.add 	$push13=, $4, $pop12
	f64.convert_s/i32	$push18=, $pop13
	f64.add 	$push19=, $pop17, $pop18
	i32.trunc_s/f64	$push20=, $pop19
	i32.store	$discard=, x($pop22), $pop20
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
	i32.const	$push44=, __stack_pointer
	i32.load	$push45=, 0($pop44)
	i32.const	$push46=, 16
	i32.sub 	$4=, $pop45, $pop46
	i32.const	$push47=, __stack_pointer
	i32.store	$discard=, 0($pop47), $4
	i32.store	$discard=, 12($4), $1
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
	i32.load	$push36=, 12($4)
	tee_local	$push35=, $0=, $pop36
	i32.const	$push31=, 4
	i32.add 	$push32=, $pop35, $pop31
	i32.store	$discard=, 12($4), $pop32
	i32.load	$push33=, 0($0)
	i32.const	$push34=, 1
	i32.add 	$1=, $pop33, $pop34
	br      	3               # 3: down to label1
.LBB5_3:                                # %sw.bb4
	end_block                       # label4:
	i32.load	$push38=, 12($4)
	tee_local	$push37=, $0=, $pop38
	i32.const	$push24=, 4
	i32.add 	$push25=, $pop37, $pop24
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
	i32.load	$push43=, 12($4)
	tee_local	$push42=, $0=, $pop43
	i32.const	$push2=, 4
	i32.add 	$push3=, $pop42, $pop2
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
	i32.const	$push41=, 4
	i32.add 	$1=, $pop13, $pop41
	br      	1               # 1: down to label1
.LBB5_5:                                # %sw.bb10
	end_block                       # label2:
	i32.load	$push40=, 12($4)
	tee_local	$push39=, $0=, $pop40
	i32.const	$push14=, 4
	i32.add 	$push15=, $pop39, $pop14
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
	i32.const	$push50=, __stack_pointer
	i32.const	$push48=, 16
	i32.add 	$push49=, $4, $pop48
	i32.store	$discard=, 0($pop50), $pop49
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
	i32.const	$push46=, __stack_pointer
	i32.load	$push47=, 0($pop46)
	i32.const	$push48=, 16
	i32.sub 	$4=, $pop47, $pop48
	i32.const	$push49=, __stack_pointer
	i32.store	$discard=, 0($pop49), $4
	i32.store	$discard=, 12($4), $1
	block
	block
	block
	i32.const	$push2=, 5
	i32.eq  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label8
# BB#1:                                 # %entry
	i32.const	$push4=, 4
	i32.ne  	$push5=, $0, $pop4
	br_if   	2, $pop5        # 2: down to label6
# BB#2:                                 # %sw.bb
	i32.load	$push17=, 12($4)
	i32.const	$push18=, 7
	i32.add 	$push19=, $pop17, $pop18
	i32.const	$push20=, -8
	i32.and 	$push38=, $pop19, $pop20
	tee_local	$push37=, $0=, $pop38
	f64.load	$3=, 0($pop37)
	i32.const	$push21=, 8
	i32.add 	$push0=, $0, $pop21
	i32.store	$0=, 12($4), $pop0
	br      	1               # 1: down to label7
.LBB6_3:                                # %sw.bb2
	end_block                       # label8:
	i32.load	$push6=, 12($4)
	i32.const	$push7=, 7
	i32.add 	$push8=, $pop6, $pop7
	i32.const	$push9=, -8
	i32.and 	$push40=, $pop8, $pop9
	tee_local	$push39=, $0=, $pop40
	f64.load	$push15=, 8($pop39)
	i32.const	$push12=, 0
	f64.load	$push10=, 0($0)
	i32.trunc_s/f64	$push11=, $pop10
	i32.store	$push13=, y($pop12), $pop11
	f64.convert_s/i32	$push16=, $pop13
	f64.add 	$3=, $pop15, $pop16
	i32.const	$push14=, 16
	i32.add 	$push1=, $0, $pop14
	i32.store	$0=, 12($4), $pop1
.LBB6_4:                                # %sw.epilog
	end_block                       # label7:
	i32.const	$push24=, 7
	i32.add 	$push25=, $0, $pop24
	i32.const	$push26=, -8
	i32.and 	$push45=, $pop25, $pop26
	tee_local	$push44=, $0=, $pop45
	f64.load	$2=, 0($pop44)
	i32.const	$push23=, 0
	i32.trunc_s/f64	$push22=, $3
	i32.store	$discard=, y($pop23), $pop22
	i32.const	$push43=, 0
	i32.trunc_s/f64	$push27=, $2
	i32.store	$1=, x($pop43), $pop27
	i32.const	$push42=, 0
	i32.const	$push30=, 19
	i32.add 	$push31=, $0, $pop30
	i32.const	$push41=, -8
	i32.and 	$push32=, $pop31, $pop41
	f64.load	$push33=, 0($pop32)
	i32.load	$push28=, 8($0)
	i32.add 	$push29=, $1, $pop28
	f64.convert_s/i32	$push34=, $pop29
	f64.add 	$push35=, $pop33, $pop34
	i32.trunc_s/f64	$push36=, $pop35
	i32.store	$discard=, x($pop42), $pop36
	i32.const	$push52=, __stack_pointer
	i32.const	$push50=, 16
	i32.add 	$push51=, $4, $pop50
	i32.store	$discard=, 0($pop52), $pop51
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
	.local  	i32, i64, i32
# BB#0:                                 # %entry
	i32.const	$push90=, __stack_pointer
	i32.load	$push91=, 0($pop90)
	i32.const	$push92=, 224
	i32.sub 	$2=, $pop91, $pop92
	i32.const	$push93=, __stack_pointer
	i32.store	$discard=, 0($pop93), $2
	i32.const	$push97=, 192
	i32.add 	$push98=, $2, $pop97
	i32.const	$push78=, 16
	i32.add 	$push0=, $pop98, $pop78
	i64.const	$push1=, 4629700416936869888
	i64.store	$discard=, 0($pop0), $pop1
	i32.const	$push2=, 128
	i32.store	$discard=, 200($2), $pop2
	i64.const	$push3=, 4625196817309499392
	i64.store	$discard=, 192($2), $pop3
	i32.const	$push99=, 192
	i32.add 	$push100=, $2, $pop99
	call    	f1@FUNCTION, $0, $pop100
	block
	i32.const	$push77=, 0
	i32.load	$push4=, x($pop77)
	i32.const	$push5=, 176
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label9
# BB#1:                                 # %if.end
	i32.const	$push101=, 144
	i32.add 	$push102=, $2, $pop101
	i32.const	$push8=, 32
	i32.add 	$push9=, $pop102, $pop8
	i64.const	$push10=, 4634204016564240384
	i64.store	$discard=, 0($pop9), $pop10
	i32.const	$push103=, 144
	i32.add 	$push104=, $2, $pop103
	i32.const	$push11=, 24
	i32.add 	$push12=, $pop104, $pop11
	i32.const	$push13=, 17
	i32.store	$discard=, 0($pop12), $pop13
	i32.const	$push105=, 144
	i32.add 	$push106=, $2, $pop105
	i32.const	$push80=, 16
	i32.add 	$push14=, $pop106, $pop80
	i64.const	$push15=, 4626041242239631360
	i64.store	$discard=, 0($pop14), $pop15
	i64.const	$push16=, 4625759767262920704
	i64.store	$discard=, 152($2), $pop16
	i64.const	$push17=, 30064771077
	i64.store	$discard=, 144($2), $pop17
	i32.const	$push107=, 144
	i32.add 	$push108=, $2, $pop107
	call    	f2@FUNCTION, $0, $pop108
	i32.const	$push79=, 0
	i32.load	$push18=, x($pop79)
	i32.const	$push19=, 100
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label9
# BB#2:                                 # %if.end
	i32.const	$push81=, 0
	i32.load	$push7=, y($pop81)
	i32.const	$push21=, 30
	i32.ne  	$push22=, $pop7, $pop21
	br_if   	0, $pop22       # 0: down to label9
# BB#3:                                 # %if.end4
	i32.const	$push23=, 0
	i32.const	$push82=, 0
	i32.call	$push24=, f3@FUNCTION, $pop23, $pop82
	br_if   	0, $pop24       # 0: down to label9
# BB#4:                                 # %if.end7
	i32.const	$push25=, 18
	i32.store	$discard=, 128($2), $pop25
	i32.const	$push26=, 1
	i32.const	$push109=, 128
	i32.add 	$push110=, $2, $pop109
	i32.call	$push27=, f3@FUNCTION, $pop26, $pop110
	i32.const	$push28=, 19
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label9
# BB#5:                                 # %if.end11
	i64.const	$push30=, 429496729618
	i64.store	$1=, 112($2), $pop30
	i32.const	$push31=, 2
	i32.const	$push111=, 112
	i32.add 	$push112=, $2, $pop111
	i32.call	$push32=, f3@FUNCTION, $pop31, $pop112
	i32.const	$push33=, 120
	i32.ne  	$push34=, $pop32, $pop33
	br_if   	0, $pop34       # 0: down to label9
# BB#6:                                 # %if.end15
	i32.const	$push35=, 300
	i32.store	$discard=, 104($2), $pop35
	i64.store	$discard=, 96($2), $1
	i32.const	$push36=, 3
	i32.const	$push113=, 96
	i32.add 	$push114=, $2, $pop113
	i32.call	$push37=, f3@FUNCTION, $pop36, $pop114
	i32.const	$push38=, 421
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label9
# BB#7:                                 # %if.end19
	i64.const	$push40=, 369367187520
	i64.store	$discard=, 88($2), $pop40
	i64.const	$push41=, 304942678034
	i64.store	$discard=, 80($2), $pop41
	i32.const	$push83=, 4
	i32.const	$push115=, 80
	i32.add 	$push116=, $2, $pop115
	i32.call	$push42=, f3@FUNCTION, $pop83, $pop116
	i32.const	$push43=, 243
	i32.ne  	$push44=, $pop42, $pop43
	br_if   	0, $pop44       # 0: down to label9
# BB#8:                                 # %if.end23
	i32.const	$push117=, 48
	i32.add 	$push118=, $2, $pop117
	i32.const	$push46=, 24
	i32.add 	$push47=, $pop118, $pop46
	i64.const	$push48=, 4625759767262920704
	i64.store	$discard=, 0($pop47), $pop48
	i32.const	$push119=, 48
	i32.add 	$push120=, $2, $pop119
	i32.const	$push49=, 16
	i32.add 	$push50=, $pop120, $pop49
	i32.const	$push86=, 16
	i32.store	$discard=, 0($pop50), $pop86
	i64.const	$push51=, 4621256167635550208
	i64.store	$discard=, 56($2), $pop51
	i64.const	$push52=, 4618441417868443648
	i64.store	$discard=, 48($2), $pop52
	i32.const	$push85=, 4
	i32.const	$push121=, 48
	i32.add 	$push122=, $2, $pop121
	call    	f4@FUNCTION, $pop85, $pop122
	i32.const	$push84=, 0
	i32.load	$push53=, x($pop84)
	i32.const	$push54=, 43
	i32.ne  	$push55=, $pop53, $pop54
	br_if   	0, $pop55       # 0: down to label9
# BB#9:                                 # %if.end23
	i32.const	$push87=, 0
	i32.load	$push45=, y($pop87)
	i32.const	$push56=, 6
	i32.ne  	$push57=, $pop45, $pop56
	br_if   	0, $pop57       # 0: down to label9
# BB#10:                                # %if.end28
	i32.const	$push59=, 32
	i32.add 	$push60=, $2, $pop59
	i64.const	$push61=, 4638566878703255552
	i64.store	$discard=, 0($pop60), $pop61
	i32.const	$push62=, 24
	i32.add 	$push63=, $2, $pop62
	i32.const	$push64=, 17
	i32.store	$discard=, 0($pop63), $pop64
	i32.const	$push65=, 16
	i32.add 	$push66=, $2, $pop65
	i64.const	$push67=, 4607182418800017408
	i64.store	$discard=, 0($pop66), $pop67
	i64.const	$push68=, 4626604192193052672
	i64.store	$discard=, 8($2), $pop68
	i64.const	$push69=, 4619567317775286272
	i64.store	$discard=, 0($2), $pop69
	i32.const	$push70=, 5
	call    	f4@FUNCTION, $pop70, $2
	i32.const	$push88=, 0
	i32.load	$push71=, x($pop88)
	i32.const	$push72=, 144
	i32.ne  	$push73=, $pop71, $pop72
	br_if   	0, $pop73       # 0: down to label9
# BB#11:                                # %if.end28
	i32.const	$push89=, 0
	i32.load	$push58=, y($pop89)
	i32.const	$push74=, 28
	i32.ne  	$push75=, $pop58, $pop74
	br_if   	0, $pop75       # 0: down to label9
# BB#12:                                # %if.end33
	i32.const	$push76=, 0
	i32.const	$push96=, __stack_pointer
	i32.const	$push94=, 224
	i32.add 	$push95=, $2, $pop94
	i32.store	$discard=, 0($pop96), $pop95
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
