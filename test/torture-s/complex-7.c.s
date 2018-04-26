	.text
	.file	"complex-7.c"
	.section	.text.check_float,"ax",@progbits
	.hidden	check_float             # -- Begin function check_float
	.globl	check_float
	.type	check_float,@function
check_float:                            # @check_float
	.param  	i32, i32, i32, i32, i32, i32
	.local  	f32, f32, f32, f32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	f32.load	$8=, f1($pop0)
	f32.load	$9=, 0($1)
	f32.load	$6=, 4($1)
	i32.const	$push15=, 0
	f32.load	$7=, f1+4($pop15)
	block   	
	f32.ne  	$push1=, $9, $8
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %entry
	f32.ne  	$push2=, $6, $7
	br_if   	0, $pop2        # 0: down to label0
# %bb.2:                                # %lor.lhs.false
	i32.const	$push3=, 0
	f32.load	$8=, f2($pop3)
	f32.load	$9=, 0($2)
	f32.load	$6=, 4($2)
	i32.const	$push16=, 0
	f32.load	$7=, f2+4($pop16)
	f32.ne  	$push4=, $9, $8
	br_if   	0, $pop4        # 0: down to label0
# %bb.3:                                # %lor.lhs.false
	f32.ne  	$push5=, $6, $7
	br_if   	0, $pop5        # 0: down to label0
# %bb.4:                                # %lor.lhs.false4
	i32.const	$push6=, 0
	f32.load	$8=, f3($pop6)
	f32.load	$9=, 0($3)
	f32.load	$6=, 4($3)
	i32.const	$push17=, 0
	f32.load	$7=, f3+4($pop17)
	f32.ne  	$push7=, $9, $8
	br_if   	0, $pop7        # 0: down to label0
# %bb.5:                                # %lor.lhs.false4
	f32.ne  	$push8=, $6, $7
	br_if   	0, $pop8        # 0: down to label0
# %bb.6:                                # %lor.lhs.false8
	i32.const	$push9=, 0
	f32.load	$8=, f4($pop9)
	f32.load	$9=, 0($4)
	f32.load	$6=, 4($4)
	i32.const	$push18=, 0
	f32.load	$7=, f4+4($pop18)
	f32.ne  	$push10=, $9, $8
	br_if   	0, $pop10       # 0: down to label0
# %bb.7:                                # %lor.lhs.false8
	f32.ne  	$push11=, $6, $7
	br_if   	0, $pop11       # 0: down to label0
# %bb.8:                                # %lor.lhs.false12
	i32.const	$push12=, 0
	f32.load	$8=, f5($pop12)
	f32.load	$9=, 0($5)
	f32.load	$6=, 4($5)
	i32.const	$push19=, 0
	f32.load	$7=, f5+4($pop19)
	f32.ne  	$push13=, $9, $8
	br_if   	0, $pop13       # 0: down to label0
# %bb.9:                                # %lor.lhs.false12
	f32.ne  	$push14=, $6, $7
	br_if   	0, $pop14       # 0: down to label0
# %bb.10:                               # %if.end
	return
.LBB0_11:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	check_float, .Lfunc_end0-check_float
                                        # -- End function
	.section	.text.check_double,"ax",@progbits
	.hidden	check_double            # -- Begin function check_double
	.globl	check_double
	.type	check_double,@function
check_double:                           # @check_double
	.param  	i32, i32, i32, i32, i32, i32
	.local  	f64, f64, f64, f64
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	f64.load	$8=, d1($pop0)
	f64.load	$9=, 0($1)
	f64.load	$6=, 8($1)
	i32.const	$push15=, 0
	f64.load	$7=, d1+8($pop15)
	block   	
	f64.ne  	$push1=, $9, $8
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %entry
	f64.ne  	$push2=, $6, $7
	br_if   	0, $pop2        # 0: down to label1
# %bb.2:                                # %lor.lhs.false
	i32.const	$push3=, 0
	f64.load	$8=, d2($pop3)
	f64.load	$9=, 0($2)
	f64.load	$6=, 8($2)
	i32.const	$push16=, 0
	f64.load	$7=, d2+8($pop16)
	f64.ne  	$push4=, $9, $8
	br_if   	0, $pop4        # 0: down to label1
# %bb.3:                                # %lor.lhs.false
	f64.ne  	$push5=, $6, $7
	br_if   	0, $pop5        # 0: down to label1
# %bb.4:                                # %lor.lhs.false4
	i32.const	$push6=, 0
	f64.load	$8=, d3($pop6)
	f64.load	$9=, 0($3)
	f64.load	$6=, 8($3)
	i32.const	$push17=, 0
	f64.load	$7=, d3+8($pop17)
	f64.ne  	$push7=, $9, $8
	br_if   	0, $pop7        # 0: down to label1
# %bb.5:                                # %lor.lhs.false4
	f64.ne  	$push8=, $6, $7
	br_if   	0, $pop8        # 0: down to label1
# %bb.6:                                # %lor.lhs.false8
	i32.const	$push9=, 0
	f64.load	$8=, d4($pop9)
	f64.load	$9=, 0($4)
	f64.load	$6=, 8($4)
	i32.const	$push18=, 0
	f64.load	$7=, d4+8($pop18)
	f64.ne  	$push10=, $9, $8
	br_if   	0, $pop10       # 0: down to label1
# %bb.7:                                # %lor.lhs.false8
	f64.ne  	$push11=, $6, $7
	br_if   	0, $pop11       # 0: down to label1
# %bb.8:                                # %lor.lhs.false12
	i32.const	$push12=, 0
	f64.load	$8=, d5($pop12)
	f64.load	$9=, 0($5)
	f64.load	$6=, 8($5)
	i32.const	$push19=, 0
	f64.load	$7=, d5+8($pop19)
	f64.ne  	$push13=, $9, $8
	br_if   	0, $pop13       # 0: down to label1
# %bb.9:                                # %lor.lhs.false12
	f64.ne  	$push14=, $6, $7
	br_if   	0, $pop14       # 0: down to label1
# %bb.10:                               # %if.end
	return
.LBB1_11:                               # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	check_double, .Lfunc_end1-check_double
                                        # -- End function
	.section	.text.check_long_double,"ax",@progbits
	.hidden	check_long_double       # -- Begin function check_long_double
	.globl	check_long_double
	.type	check_long_double,@function
check_long_double:                      # @check_long_double
	.param  	i32, i32, i32, i32, i32, i32
	.local  	i64, i64, i64, i64, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 8
	i32.add 	$push1=, $1, $pop0
	i64.load	$7=, 0($pop1)
	i32.const	$push2=, 0
	i64.load	$8=, ld1+8($pop2)
	i32.const	$push37=, 0
	i64.load	$9=, ld1($pop37)
	i64.load	$push3=, 0($1)
	i32.call	$10=, __netf2@FUNCTION, $pop3, $7, $9, $8
	i32.const	$push4=, 24
	i32.add 	$push5=, $1, $pop4
	i64.load	$7=, 0($pop5)
	i64.load	$8=, 16($1)
	i32.const	$push36=, 0
	i64.load	$9=, ld1+24($pop36)
	i32.const	$push35=, 0
	i64.load	$6=, ld1+16($pop35)
	block   	
	br_if   	0, $10          # 0: down to label2
# %bb.1:                                # %entry
	i32.call	$push6=, __netf2@FUNCTION, $8, $7, $6, $9
	br_if   	0, $pop6        # 0: down to label2
# %bb.2:                                # %lor.lhs.false
	i32.const	$push7=, 8
	i32.add 	$push8=, $2, $pop7
	i64.load	$7=, 0($pop8)
	i32.const	$push9=, 0
	i64.load	$8=, ld2+8($pop9)
	i32.const	$push40=, 0
	i64.load	$9=, ld2($pop40)
	i64.load	$push10=, 0($2)
	i32.call	$1=, __netf2@FUNCTION, $pop10, $7, $9, $8
	i32.const	$push11=, 24
	i32.add 	$push12=, $2, $pop11
	i64.load	$7=, 0($pop12)
	i64.load	$8=, 16($2)
	i32.const	$push39=, 0
	i64.load	$9=, ld2+24($pop39)
	i32.const	$push38=, 0
	i64.load	$6=, ld2+16($pop38)
	br_if   	0, $1           # 0: down to label2
# %bb.3:                                # %lor.lhs.false
	i32.call	$push13=, __netf2@FUNCTION, $8, $7, $6, $9
	br_if   	0, $pop13       # 0: down to label2
# %bb.4:                                # %lor.lhs.false4
	i32.const	$push14=, 8
	i32.add 	$push15=, $3, $pop14
	i64.load	$7=, 0($pop15)
	i32.const	$push16=, 0
	i64.load	$8=, ld3+8($pop16)
	i32.const	$push43=, 0
	i64.load	$9=, ld3($pop43)
	i64.load	$push17=, 0($3)
	i32.call	$2=, __netf2@FUNCTION, $pop17, $7, $9, $8
	i32.const	$push18=, 24
	i32.add 	$push19=, $3, $pop18
	i64.load	$7=, 0($pop19)
	i64.load	$8=, 16($3)
	i32.const	$push42=, 0
	i64.load	$9=, ld3+24($pop42)
	i32.const	$push41=, 0
	i64.load	$6=, ld3+16($pop41)
	br_if   	0, $2           # 0: down to label2
# %bb.5:                                # %lor.lhs.false4
	i32.call	$push20=, __netf2@FUNCTION, $8, $7, $6, $9
	br_if   	0, $pop20       # 0: down to label2
# %bb.6:                                # %lor.lhs.false8
	i32.const	$push21=, 8
	i32.add 	$push22=, $4, $pop21
	i64.load	$7=, 0($pop22)
	i32.const	$push23=, 0
	i64.load	$8=, ld4+8($pop23)
	i32.const	$push46=, 0
	i64.load	$9=, ld4($pop46)
	i64.load	$push24=, 0($4)
	i32.call	$2=, __netf2@FUNCTION, $pop24, $7, $9, $8
	i32.const	$push25=, 24
	i32.add 	$push26=, $4, $pop25
	i64.load	$7=, 0($pop26)
	i64.load	$8=, 16($4)
	i32.const	$push45=, 0
	i64.load	$9=, ld4+24($pop45)
	i32.const	$push44=, 0
	i64.load	$6=, ld4+16($pop44)
	br_if   	0, $2           # 0: down to label2
# %bb.7:                                # %lor.lhs.false8
	i32.call	$push27=, __netf2@FUNCTION, $8, $7, $6, $9
	br_if   	0, $pop27       # 0: down to label2
# %bb.8:                                # %lor.lhs.false12
	i32.const	$push28=, 8
	i32.add 	$push29=, $5, $pop28
	i64.load	$7=, 0($pop29)
	i32.const	$push30=, 0
	i64.load	$8=, ld5+8($pop30)
	i32.const	$push49=, 0
	i64.load	$9=, ld5($pop49)
	i64.load	$push31=, 0($5)
	i32.call	$2=, __netf2@FUNCTION, $pop31, $7, $9, $8
	i32.const	$push32=, 24
	i32.add 	$push33=, $5, $pop32
	i64.load	$7=, 0($pop33)
	i64.load	$8=, 16($5)
	i32.const	$push48=, 0
	i64.load	$9=, ld5+24($pop48)
	i32.const	$push47=, 0
	i64.load	$6=, ld5+16($pop47)
	br_if   	0, $2           # 0: down to label2
# %bb.9:                                # %lor.lhs.false12
	i32.call	$push34=, __eqtf2@FUNCTION, $8, $7, $6, $9
	br_if   	0, $pop34       # 0: down to label2
# %bb.10:                               # %if.end
	return
.LBB2_11:                               # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	check_long_double, .Lfunc_end2-check_long_double
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f32, f64, f64, f64, f64, f64, f64, f64, f64, f64, i64, i64, i32, i64, i64, i64, i32, i64, i64, i64, i32, i64, i64, i64, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push73=, 0
	i32.load	$push72=, __stack_pointer($pop73)
	i32.const	$push74=, 576
	i32.sub 	$26=, $pop72, $pop74
	i32.const	$push75=, 0
	i32.store	__stack_pointer($pop75), $26
	i32.const	$push0=, 0
	f32.load	$push1=, f1($pop0)
	f32.store	568($26), $pop1
	i32.const	$push196=, 0
	f32.load	$push2=, f1+4($pop196)
	f32.store	572($26), $pop2
	i32.const	$push195=, 0
	f32.load	$push3=, f2($pop195)
	f32.store	560($26), $pop3
	i32.const	$push194=, 0
	f32.load	$push4=, f2+4($pop194)
	f32.store	564($26), $pop4
	i32.const	$push193=, 0
	f32.load	$push5=, f3($pop193)
	f32.store	552($26), $pop5
	i32.const	$push192=, 0
	f32.load	$push6=, f3+4($pop192)
	f32.store	556($26), $pop6
	i32.const	$push191=, 0
	f32.load	$push7=, f4($pop191)
	f32.store	544($26), $pop7
	i32.const	$push190=, 0
	f32.load	$push8=, f4+4($pop190)
	f32.store	548($26), $pop8
	i32.const	$push189=, 0
	f32.load	$push9=, f5($pop189)
	f32.store	536($26), $pop9
	i32.const	$push188=, 0
	f32.load	$0=, f5+4($pop188)
	i64.load	$push10=, 568($26)
	i64.store	280($26), $pop10
	f32.store	540($26), $0
	i64.load	$push11=, 560($26)
	i64.store	272($26), $pop11
	i64.load	$push12=, 552($26)
	i64.store	264($26), $pop12
	i64.load	$push13=, 544($26)
	i64.store	256($26), $pop13
	i64.load	$push14=, 536($26)
	i64.store	248($26), $pop14
	i32.const	$push76=, 280
	i32.add 	$push77=, $26, $pop76
	i32.const	$push78=, 272
	i32.add 	$push79=, $26, $pop78
	i32.const	$push80=, 264
	i32.add 	$push81=, $26, $pop80
	i32.const	$push82=, 256
	i32.add 	$push83=, $26, $pop82
	i32.const	$push84=, 248
	i32.add 	$push85=, $26, $pop84
	call    	check_float@FUNCTION, $26, $pop77, $pop79, $pop81, $pop83, $pop85
	i32.const	$push187=, 0
	f64.load	$1=, d1($pop187)
	i32.const	$push186=, 0
	f64.load	$push15=, d1+8($pop186)
	f64.store	528($26), $pop15
	i32.const	$push185=, 0
	f64.load	$2=, d2($pop185)
	i32.const	$push184=, 0
	f64.load	$3=, d2+8($pop184)
	i32.const	$push183=, 0
	f64.load	$4=, d3($pop183)
	i32.const	$push182=, 0
	f64.load	$5=, d3+8($pop182)
	i32.const	$push181=, 0
	f64.load	$6=, d4($pop181)
	i32.const	$push180=, 0
	f64.load	$7=, d4+8($pop180)
	i32.const	$push179=, 0
	f64.load	$8=, d5($pop179)
	i32.const	$push178=, 0
	f64.load	$9=, d5+8($pop178)
	i32.const	$push86=, 232
	i32.add 	$push87=, $26, $pop86
	i32.const	$push16=, 8
	i32.add 	$push17=, $pop87, $pop16
	i64.load	$push18=, 528($26)
	i64.store	0($pop17), $pop18
	f64.store	512($26), $3
	i32.const	$push88=, 216
	i32.add 	$push89=, $26, $pop88
	i32.const	$push177=, 8
	i32.add 	$push19=, $pop89, $pop177
	i64.load	$push20=, 512($26)
	i64.store	0($pop19), $pop20
	f64.store	520($26), $1
	f64.store	504($26), $2
	f64.store	488($26), $4
	f64.store	496($26), $5
	f64.store	472($26), $6
	f64.store	480($26), $7
	f64.store	456($26), $8
	f64.store	464($26), $9
	i64.load	$push21=, 520($26)
	i64.store	232($26), $pop21
	i64.load	$push22=, 504($26)
	i64.store	216($26), $pop22
	i32.const	$push90=, 200
	i32.add 	$push91=, $26, $pop90
	i32.const	$push176=, 8
	i32.add 	$push23=, $pop91, $pop176
	i64.load	$push24=, 496($26)
	i64.store	0($pop23), $pop24
	i64.load	$push25=, 488($26)
	i64.store	200($26), $pop25
	i32.const	$push92=, 184
	i32.add 	$push93=, $26, $pop92
	i32.const	$push175=, 8
	i32.add 	$push26=, $pop93, $pop175
	i64.load	$push27=, 480($26)
	i64.store	0($pop26), $pop27
	i64.load	$push28=, 472($26)
	i64.store	184($26), $pop28
	i32.const	$push94=, 168
	i32.add 	$push95=, $26, $pop94
	i32.const	$push174=, 8
	i32.add 	$push29=, $pop95, $pop174
	i64.load	$push30=, 464($26)
	i64.store	0($pop29), $pop30
	i64.load	$push31=, 456($26)
	i64.store	168($26), $pop31
	i32.const	$push96=, 232
	i32.add 	$push97=, $26, $pop96
	i32.const	$push98=, 216
	i32.add 	$push99=, $26, $pop98
	i32.const	$push100=, 200
	i32.add 	$push101=, $26, $pop100
	i32.const	$push102=, 184
	i32.add 	$push103=, $26, $pop102
	i32.const	$push104=, 168
	i32.add 	$push105=, $26, $pop104
	call    	check_double@FUNCTION, $26, $pop97, $pop99, $pop101, $pop103, $pop105
	i32.const	$push173=, 0
	i64.load	$10=, ld1($pop173)
	i32.const	$push172=, 0
	i64.load	$11=, ld1+8($pop172)
	i32.const	$push106=, 416
	i32.add 	$push107=, $26, $pop106
	i32.const	$push32=, 24
	i32.add 	$12=, $pop107, $pop32
	i32.const	$push171=, 0
	i64.load	$push33=, ld1+24($pop171)
	i64.store	0($12), $pop33
	i32.const	$push170=, 0
	i64.load	$13=, ld1+16($pop170)
	i32.const	$push169=, 0
	i64.load	$14=, ld2($pop169)
	i32.const	$push168=, 0
	i64.load	$15=, ld2+8($pop168)
	i32.const	$push108=, 384
	i32.add 	$push109=, $26, $pop108
	i32.const	$push167=, 24
	i32.add 	$16=, $pop109, $pop167
	i32.const	$push166=, 0
	i64.load	$push34=, ld2+24($pop166)
	i64.store	0($16), $pop34
	i32.const	$push165=, 0
	i64.load	$17=, ld2+16($pop165)
	i32.const	$push164=, 0
	i64.load	$18=, ld3($pop164)
	i32.const	$push163=, 0
	i64.load	$19=, ld3+8($pop163)
	i32.const	$push110=, 352
	i32.add 	$push111=, $26, $pop110
	i32.const	$push162=, 24
	i32.add 	$20=, $pop111, $pop162
	i32.const	$push161=, 0
	i64.load	$push35=, ld3+24($pop161)
	i64.store	0($20), $pop35
	i32.const	$push160=, 0
	i64.load	$21=, ld3+16($pop160)
	i32.const	$push159=, 0
	i64.load	$22=, ld4($pop159)
	i32.const	$push158=, 0
	i64.load	$23=, ld4+8($pop158)
	i32.const	$push112=, 320
	i32.add 	$push113=, $26, $pop112
	i32.const	$push157=, 24
	i32.add 	$24=, $pop113, $pop157
	i32.const	$push156=, 0
	i64.load	$push36=, ld4+24($pop156)
	i64.store	0($24), $pop36
	i64.store	424($26), $11
	i64.store	416($26), $10
	i64.store	432($26), $13
	i64.store	392($26), $15
	i64.store	384($26), $14
	i64.store	400($26), $17
	i64.store	360($26), $19
	i64.store	352($26), $18
	i64.store	368($26), $21
	i64.store	328($26), $23
	i64.store	320($26), $22
	i32.const	$push155=, 0
	i64.load	$push37=, ld4+16($pop155)
	i64.store	336($26), $pop37
	i32.const	$push154=, 0
	i64.load	$push38=, ld5+8($pop154)
	i64.store	296($26), $pop38
	i32.const	$push153=, 0
	i64.load	$push39=, ld5($pop153)
	i64.store	288($26), $pop39
	i32.const	$push152=, 0
	i64.load	$10=, ld5+16($pop152)
	i32.const	$push114=, 288
	i32.add 	$push115=, $26, $pop114
	i32.const	$push151=, 24
	i32.add 	$25=, $pop115, $pop151
	i32.const	$push150=, 0
	i64.load	$push40=, ld5+24($pop150)
	i64.store	0($25), $pop40
	i32.const	$push116=, 128
	i32.add 	$push117=, $26, $pop116
	i32.const	$push149=, 24
	i32.add 	$push41=, $pop117, $pop149
	i64.load	$push42=, 0($12)
	i64.store	0($pop41), $pop42
	i32.const	$push118=, 128
	i32.add 	$push119=, $26, $pop118
	i32.const	$push43=, 16
	i32.add 	$push44=, $pop119, $pop43
	i64.load	$push45=, 432($26)
	i64.store	0($pop44), $pop45
	i64.store	304($26), $10
	i64.load	$push46=, 424($26)
	i64.store	136($26), $pop46
	i64.load	$push47=, 416($26)
	i64.store	128($26), $pop47
	i32.const	$push120=, 96
	i32.add 	$push121=, $26, $pop120
	i32.const	$push148=, 24
	i32.add 	$push48=, $pop121, $pop148
	i64.load	$push49=, 0($16)
	i64.store	0($pop48), $pop49
	i32.const	$push122=, 96
	i32.add 	$push123=, $26, $pop122
	i32.const	$push147=, 16
	i32.add 	$push50=, $pop123, $pop147
	i64.load	$push51=, 400($26)
	i64.store	0($pop50), $pop51
	i64.load	$push52=, 392($26)
	i64.store	104($26), $pop52
	i64.load	$push53=, 384($26)
	i64.store	96($26), $pop53
	i32.const	$push124=, 64
	i32.add 	$push125=, $26, $pop124
	i32.const	$push146=, 24
	i32.add 	$push54=, $pop125, $pop146
	i64.load	$push55=, 0($20)
	i64.store	0($pop54), $pop55
	i32.const	$push126=, 64
	i32.add 	$push127=, $26, $pop126
	i32.const	$push145=, 16
	i32.add 	$push56=, $pop127, $pop145
	i64.load	$push57=, 368($26)
	i64.store	0($pop56), $pop57
	i64.load	$push58=, 360($26)
	i64.store	72($26), $pop58
	i64.load	$push59=, 352($26)
	i64.store	64($26), $pop59
	i32.const	$push128=, 32
	i32.add 	$push129=, $26, $pop128
	i32.const	$push144=, 24
	i32.add 	$push60=, $pop129, $pop144
	i64.load	$push61=, 0($24)
	i64.store	0($pop60), $pop61
	i32.const	$push130=, 32
	i32.add 	$push131=, $26, $pop130
	i32.const	$push143=, 16
	i32.add 	$push62=, $pop131, $pop143
	i64.load	$push63=, 336($26)
	i64.store	0($pop62), $pop63
	i64.load	$push64=, 328($26)
	i64.store	40($26), $pop64
	i64.load	$push65=, 320($26)
	i64.store	32($26), $pop65
	i32.const	$push142=, 24
	i32.add 	$push66=, $26, $pop142
	i64.load	$push67=, 0($25)
	i64.store	0($pop66), $pop67
	i32.const	$push141=, 16
	i32.add 	$push68=, $26, $pop141
	i64.load	$push69=, 304($26)
	i64.store	0($pop68), $pop69
	i64.load	$push70=, 296($26)
	i64.store	8($26), $pop70
	i64.load	$push71=, 288($26)
	i64.store	0($26), $pop71
	i32.const	$push132=, 128
	i32.add 	$push133=, $26, $pop132
	i32.const	$push134=, 96
	i32.add 	$push135=, $26, $pop134
	i32.const	$push136=, 64
	i32.add 	$push137=, $26, $pop136
	i32.const	$push138=, 32
	i32.add 	$push139=, $26, $pop138
	call    	check_long_double@FUNCTION, $26, $pop133, $pop135, $pop137, $pop139, $26
	i32.const	$push140=, 0
	call    	exit@FUNCTION, $pop140
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function
	.hidden	f1                      # @f1
	.type	f1,@object
	.section	.data.f1,"aw",@progbits
	.globl	f1
	.p2align	2
f1:
	.int32	1066192077              # float 1.10000002
	.int32	1074580685              # float 2.20000005
	.size	f1, 8

	.hidden	f2                      # @f2
	.type	f2,@object
	.section	.data.f2,"aw",@progbits
	.globl	f2
	.p2align	2
f2:
	.int32	1079194419              # float 3.29999995
	.int32	1082969293              # float 4.4000001
	.size	f2, 8

	.hidden	f3                      # @f3
	.type	f3,@object
	.section	.data.f3,"aw",@progbits
	.globl	f3
	.p2align	2
f3:
	.int32	1085276160              # float 5.5
	.int32	1087583027              # float 6.5999999
	.size	f3, 8

	.hidden	f4                      # @f4
	.type	f4,@object
	.section	.data.f4,"aw",@progbits
	.globl	f4
	.p2align	2
f4:
	.int32	1089889894              # float 7.6999998
	.int32	1091357901              # float 8.80000019
	.size	f4, 8

	.hidden	f5                      # @f5
	.type	f5,@object
	.section	.data.f5,"aw",@progbits
	.globl	f5
	.p2align	2
f5:
	.int32	1092511334              # float 9.89999961
	.int32	1092721050              # float 10.1000004
	.size	f5, 8

	.hidden	d1                      # @d1
	.type	d1,@object
	.section	.data.d1,"aw",@progbits
	.globl	d1
	.p2align	3
d1:
	.int64	4607632778762754458     # double 1.1000000000000001
	.int64	4612136378390124954     # double 2.2000000000000002
	.size	d1, 16

	.hidden	d2                      # @d2
	.type	d2,@object
	.section	.data.d2,"aw",@progbits
	.globl	d2
	.p2align	3
d2:
	.int64	4614613358185178726     # double 3.2999999999999998
	.int64	4616639978017495450     # double 4.4000000000000004
	.size	d2, 16

	.hidden	d3                      # @d3
	.type	d3,@object
	.section	.data.d3,"aw",@progbits
	.globl	d3
	.p2align	3
d3:
	.int64	4617878467915022336     # double 5.5
	.int64	4619116957812549222     # double 6.5999999999999996
	.size	d3, 16

	.hidden	d4                      # @d4
	.type	d4,@object
	.section	.data.d4,"aw",@progbits
	.globl	d4
	.p2align	3
d4:
	.int64	4620355447710076109     # double 7.7000000000000001
	.int64	4621143577644865946     # double 8.8000000000000007
	.size	d4, 16

	.hidden	d5                      # @d5
	.type	d5,@object
	.section	.data.d5,"aw",@progbits
	.globl	d5
	.p2align	3
d5:
	.int64	4621762822593629389     # double 9.9000000000000003
	.int64	4621875412584313651     # double 10.1
	.size	d5, 16

	.hidden	ld1                     # @ld1
	.type	ld1,@object
	.section	.data.ld1,"aw",@progbits
	.globl	ld1
	.p2align	4
ld1:
	.int64	-7378697629483820646    # fp128 1.10000000000000000000000000000000008
	.int64	4611432690948348313
	.int64	-7378697629483820646    # fp128 2.20000000000000000000000000000000015
	.int64	4611714165925058969
	.size	ld1, 32

	.hidden	ld2                     # @ld2
	.type	ld2,@object
	.section	.data.ld2,"aw",@progbits
	.globl	ld2
	.p2align	4
ld2:
	.int64	7378697629483820646     # fp128 3.29999999999999999999999999999999985
	.int64	4611868977162249830
	.int64	-7378697629483820646    # fp128 4.40000000000000000000000000000000031
	.int64	4611995640901769625
	.size	ld2, 32

	.hidden	ld3                     # @ld3
	.type	ld3,@object
	.section	.data.ld3,"aw",@progbits
	.globl	ld3
	.p2align	4
ld3:
	.int64	0                       # fp128 5.5
	.int64	4612073046520365056
	.int64	7378697629483820646     # fp128 6.59999999999999999999999999999999969
	.int64	4612150452138960486
	.size	ld3, 32

	.hidden	ld4                     # @ld4
	.type	ld4,@object
	.section	.data.ld4,"aw",@progbits
	.globl	ld4
	.p2align	4
ld4:
	.int64	-3689348814741910323    # fp128 7.70000000000000000000000000000000015
	.int64	4612227857757555916
	.int64	-7378697629483820646    # fp128 8.80000000000000000000000000000000062
	.int64	4612277115878480281
	.size	ld4, 32

	.hidden	ld5                     # @ld5
	.type	ld5,@object
	.section	.data.ld5,"aw",@progbits
	.globl	ld5
	.p2align	4
ld5:
	.int64	-3689348814741910323    # fp128 9.9000000000000000000000000000000003
	.int64	4612315818687777996
	.int64	3689348814741910323     # fp128 10.0999999999999999999999999999999997
	.int64	4612322855562195763
	.size	ld5, 32


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
