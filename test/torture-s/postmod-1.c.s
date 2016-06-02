	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/postmod-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, i32, i32, i32, i32, i32, f32, f32, f32, f32, f32, f32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.shl 	$2=, $0, $pop0
	i32.const	$push1=, 3
	i32.shl 	$1=, $0, $pop1
	i32.const	$push115=, 0
	f32.load	$20=, counter5($pop115)
	i32.const	$push114=, 0
	f32.load	$21=, counter4($pop114)
	i32.const	$push113=, 0
	f32.load	$22=, counter3($pop113)
	i32.const	$push112=, 0
	f32.load	$23=, counter2($pop112)
	i32.const	$push111=, 0
	f32.load	$24=, counter1($pop111)
	i32.const	$push110=, 0
	f32.load	$25=, counter0($pop110)
	i32.const	$19=, 0
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.add 	$push226=, $1, $19
	tee_local	$push225=, $0=, $pop226
	f32.load	$3=, array0+12($pop225)
	i32.add 	$push224=, $2, $19
	tee_local	$push223=, $15=, $pop224
	f32.load	$4=, array0($pop223)
	f32.load	$5=, array1+12($0)
	f32.load	$6=, array1($15)
	f32.load	$7=, array2+12($0)
	f32.load	$8=, array2($15)
	f32.load	$9=, array3+12($0)
	f32.load	$10=, array3($15)
	f32.load	$11=, array4+12($0)
	f32.load	$12=, array4($15)
	f32.load	$13=, array5+12($0)
	f32.load	$14=, array5($15)
	i32.const	$push222=, 0
	i32.load	$0=, vol($pop222)
	i32.const	$push221=, 0
	i32.load	$15=, vol($pop221)
	i32.const	$push220=, 0
	i32.load	$16=, vol($pop220)
	i32.const	$push219=, 0
	i32.load	$17=, vol($pop219)
	i32.const	$push218=, 0
	i32.load	$18=, vol($pop218)
	i32.const	$push217=, 0
	i32.const	$push216=, 0
	i32.load	$push2=, vol($pop216)
	i32.add 	$push3=, $0, $pop2
	i32.store	$drop=, vol($pop217), $pop3
	i32.const	$push215=, 0
	i32.const	$push214=, 0
	i32.load	$push4=, vol($pop214)
	i32.add 	$push5=, $15, $pop4
	i32.store	$drop=, vol($pop215), $pop5
	i32.const	$push213=, 0
	i32.const	$push212=, 0
	i32.load	$push6=, vol($pop212)
	i32.add 	$push7=, $16, $pop6
	i32.store	$drop=, vol($pop213), $pop7
	i32.const	$push211=, 0
	i32.const	$push210=, 0
	i32.load	$push8=, vol($pop210)
	i32.add 	$push9=, $17, $pop8
	i32.store	$drop=, vol($pop211), $pop9
	i32.const	$push209=, 0
	i32.const	$push208=, 0
	i32.load	$push10=, vol($pop208)
	i32.add 	$push11=, $18, $pop10
	i32.store	$drop=, vol($pop209), $pop11
	i32.const	$push207=, 0
	i32.const	$push206=, 0
	i32.load	$push12=, vol($pop206)
	i32.add 	$push13=, $0, $pop12
	i32.store	$drop=, vol($pop207), $pop13
	i32.const	$push205=, 0
	i32.const	$push204=, 0
	i32.load	$push14=, vol($pop204)
	i32.add 	$push15=, $15, $pop14
	i32.store	$drop=, vol($pop205), $pop15
	i32.const	$push203=, 0
	i32.const	$push202=, 0
	i32.load	$push16=, vol($pop202)
	i32.add 	$push17=, $16, $pop16
	i32.store	$drop=, vol($pop203), $pop17
	i32.const	$push201=, 0
	i32.const	$push200=, 0
	i32.load	$push18=, vol($pop200)
	i32.add 	$push19=, $17, $pop18
	i32.store	$drop=, vol($pop201), $pop19
	i32.const	$push199=, 0
	i32.const	$push198=, 0
	i32.load	$push20=, vol($pop198)
	i32.add 	$push21=, $18, $pop20
	i32.store	$drop=, vol($pop199), $pop21
	i32.const	$push197=, 0
	i32.const	$push196=, 0
	i32.load	$push22=, vol($pop196)
	i32.add 	$push23=, $0, $pop22
	i32.store	$drop=, vol($pop197), $pop23
	i32.const	$push195=, 0
	i32.const	$push194=, 0
	i32.load	$push24=, vol($pop194)
	i32.add 	$push25=, $15, $pop24
	i32.store	$drop=, vol($pop195), $pop25
	i32.const	$push193=, 0
	i32.const	$push192=, 0
	i32.load	$push26=, vol($pop192)
	i32.add 	$push27=, $16, $pop26
	i32.store	$drop=, vol($pop193), $pop27
	i32.const	$push191=, 0
	i32.const	$push190=, 0
	i32.load	$push28=, vol($pop190)
	i32.add 	$push29=, $17, $pop28
	i32.store	$drop=, vol($pop191), $pop29
	i32.const	$push189=, 0
	i32.const	$push188=, 0
	i32.load	$push30=, vol($pop188)
	i32.add 	$push31=, $18, $pop30
	i32.store	$drop=, vol($pop189), $pop31
	i32.const	$push187=, 0
	i32.const	$push186=, 0
	i32.load	$push32=, vol($pop186)
	i32.add 	$push33=, $0, $pop32
	i32.store	$drop=, vol($pop187), $pop33
	i32.const	$push185=, 0
	i32.const	$push184=, 0
	i32.load	$push34=, vol($pop184)
	i32.add 	$push35=, $15, $pop34
	i32.store	$drop=, vol($pop185), $pop35
	i32.const	$push183=, 0
	i32.const	$push182=, 0
	i32.load	$push36=, vol($pop182)
	i32.add 	$push37=, $16, $pop36
	i32.store	$drop=, vol($pop183), $pop37
	i32.const	$push181=, 0
	i32.const	$push180=, 0
	i32.load	$push38=, vol($pop180)
	i32.add 	$push39=, $17, $pop38
	i32.store	$drop=, vol($pop181), $pop39
	i32.const	$push179=, 0
	i32.const	$push178=, 0
	i32.load	$push40=, vol($pop178)
	i32.add 	$push41=, $18, $pop40
	i32.store	$drop=, vol($pop179), $pop41
	i32.const	$push177=, 0
	i32.const	$push176=, 0
	i32.load	$push42=, vol($pop176)
	i32.add 	$push43=, $0, $pop42
	i32.store	$drop=, vol($pop177), $pop43
	i32.const	$push175=, 0
	i32.const	$push174=, 0
	i32.load	$push44=, vol($pop174)
	i32.add 	$push45=, $15, $pop44
	i32.store	$drop=, vol($pop175), $pop45
	i32.const	$push173=, 0
	i32.const	$push172=, 0
	i32.load	$push46=, vol($pop172)
	i32.add 	$push47=, $16, $pop46
	i32.store	$drop=, vol($pop173), $pop47
	i32.const	$push171=, 0
	i32.const	$push170=, 0
	i32.load	$push48=, vol($pop170)
	i32.add 	$push49=, $17, $pop48
	i32.store	$drop=, vol($pop171), $pop49
	i32.const	$push169=, 0
	i32.const	$push168=, 0
	i32.load	$push50=, vol($pop168)
	i32.add 	$push51=, $18, $pop50
	i32.store	$drop=, vol($pop169), $pop51
	i32.const	$push167=, 0
	i32.const	$push166=, 0
	i32.load	$push52=, vol($pop166)
	i32.add 	$push53=, $0, $pop52
	i32.store	$drop=, vol($pop167), $pop53
	i32.const	$push165=, 0
	i32.const	$push164=, 0
	i32.load	$push54=, vol($pop164)
	i32.add 	$push55=, $15, $pop54
	i32.store	$drop=, vol($pop165), $pop55
	i32.const	$push163=, 0
	i32.const	$push162=, 0
	i32.load	$push56=, vol($pop162)
	i32.add 	$push57=, $16, $pop56
	i32.store	$drop=, vol($pop163), $pop57
	i32.const	$push161=, 0
	i32.const	$push160=, 0
	i32.load	$push58=, vol($pop160)
	i32.add 	$push59=, $17, $pop58
	i32.store	$drop=, vol($pop161), $pop59
	i32.const	$push159=, 0
	i32.const	$push158=, 0
	i32.load	$push60=, vol($pop158)
	i32.add 	$push61=, $18, $pop60
	i32.store	$drop=, vol($pop159), $pop61
	i32.const	$push157=, 0
	i32.const	$push156=, 0
	i32.load	$push62=, vol($pop156)
	i32.add 	$push63=, $0, $pop62
	i32.store	$drop=, vol($pop157), $pop63
	i32.const	$push155=, 0
	i32.const	$push154=, 0
	i32.load	$push64=, vol($pop154)
	i32.add 	$push65=, $15, $pop64
	i32.store	$drop=, vol($pop155), $pop65
	i32.const	$push153=, 0
	i32.const	$push152=, 0
	i32.load	$push66=, vol($pop152)
	i32.add 	$push67=, $16, $pop66
	i32.store	$drop=, vol($pop153), $pop67
	i32.const	$push151=, 0
	i32.const	$push150=, 0
	i32.load	$push68=, vol($pop150)
	i32.add 	$push69=, $17, $pop68
	i32.store	$drop=, vol($pop151), $pop69
	i32.const	$push149=, 0
	i32.const	$push148=, 0
	i32.load	$push70=, vol($pop148)
	i32.add 	$push71=, $18, $pop70
	i32.store	$drop=, vol($pop149), $pop71
	i32.const	$push147=, 0
	i32.const	$push146=, 0
	i32.load	$push72=, vol($pop146)
	i32.add 	$push73=, $0, $pop72
	i32.store	$drop=, vol($pop147), $pop73
	i32.const	$push145=, 0
	i32.const	$push144=, 0
	i32.load	$push74=, vol($pop144)
	i32.add 	$push75=, $15, $pop74
	i32.store	$drop=, vol($pop145), $pop75
	i32.const	$push143=, 0
	i32.const	$push142=, 0
	i32.load	$push76=, vol($pop142)
	i32.add 	$push77=, $16, $pop76
	i32.store	$drop=, vol($pop143), $pop77
	i32.const	$push141=, 0
	i32.const	$push140=, 0
	i32.load	$push78=, vol($pop140)
	i32.add 	$push79=, $17, $pop78
	i32.store	$drop=, vol($pop141), $pop79
	i32.const	$push139=, 0
	i32.const	$push138=, 0
	i32.load	$push80=, vol($pop138)
	i32.add 	$push81=, $18, $pop80
	i32.store	$drop=, vol($pop139), $pop81
	i32.const	$push137=, 0
	i32.const	$push136=, 0
	i32.load	$push82=, vol($pop136)
	i32.add 	$push83=, $0, $pop82
	i32.store	$drop=, vol($pop137), $pop83
	i32.const	$push135=, 0
	i32.const	$push134=, 0
	i32.load	$push84=, vol($pop134)
	i32.add 	$push85=, $15, $pop84
	i32.store	$drop=, vol($pop135), $pop85
	i32.const	$push133=, 0
	i32.const	$push132=, 0
	i32.load	$push86=, vol($pop132)
	i32.add 	$push87=, $16, $pop86
	i32.store	$drop=, vol($pop133), $pop87
	i32.const	$push131=, 0
	i32.const	$push130=, 0
	i32.load	$push88=, vol($pop130)
	i32.add 	$push89=, $17, $pop88
	i32.store	$drop=, vol($pop131), $pop89
	i32.const	$push129=, 0
	i32.const	$push128=, 0
	i32.load	$push90=, vol($pop128)
	i32.add 	$push91=, $18, $pop90
	i32.store	$drop=, vol($pop129), $pop91
	i32.const	$push127=, 0
	i32.const	$push126=, 0
	i32.load	$push92=, vol($pop126)
	i32.add 	$push93=, $0, $pop92
	i32.store	$drop=, vol($pop127), $pop93
	i32.const	$push125=, 0
	i32.const	$push124=, 0
	i32.load	$push94=, vol($pop124)
	i32.add 	$push95=, $15, $pop94
	i32.store	$drop=, vol($pop125), $pop95
	i32.const	$push123=, 0
	i32.const	$push122=, 0
	i32.load	$push96=, vol($pop122)
	i32.add 	$push97=, $16, $pop96
	i32.store	$drop=, vol($pop123), $pop97
	i32.const	$push121=, 0
	i32.const	$push120=, 0
	i32.load	$push98=, vol($pop120)
	i32.add 	$push99=, $17, $pop98
	i32.store	$drop=, vol($pop121), $pop99
	i32.const	$push119=, 0
	i32.const	$push118=, 0
	i32.load	$push100=, vol($pop118)
	i32.add 	$push101=, $18, $pop100
	i32.store	$drop=, vol($pop119), $pop101
	f32.add 	$push102=, $14, $20
	f32.add 	$20=, $13, $pop102
	f32.add 	$push103=, $12, $21
	f32.add 	$21=, $11, $pop103
	f32.add 	$push104=, $10, $22
	f32.add 	$22=, $9, $pop104
	f32.add 	$push105=, $8, $23
	f32.add 	$23=, $7, $pop105
	f32.add 	$push106=, $6, $24
	f32.add 	$24=, $5, $pop106
	f32.add 	$push107=, $4, $25
	f32.add 	$25=, $3, $pop107
	i32.const	$push117=, 12
	i32.add 	$19=, $19, $pop117
	i32.const	$push116=, 0
	i32.load	$push108=, stop($pop116)
	i32.eqz 	$push232=, $pop108
	br_if   	0, $pop232      # 0: up to label0
# BB#2:                                 # %do.end
	end_loop                        # label1:
	i32.const	$push109=, 0
	f32.store	$drop=, counter1($pop109), $24
	i32.const	$push231=, 0
	f32.store	$drop=, counter0($pop231), $25
	i32.const	$push230=, 0
	f32.store	$drop=, counter2($pop230), $23
	i32.const	$push229=, 0
	f32.store	$drop=, counter3($pop229), $22
	i32.const	$push228=, 0
	f32.store	$drop=, counter4($pop228), $21
	i32.const	$push227=, 0
	f32.store	$drop=, counter5($pop227), $20
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push1=, 1073741824
	i32.store	$0=, array0+20($pop2), $pop1
	i32.const	$push44=, 0
	i32.const	$push43=, 0
	i32.const	$push3=, 1065353216
	i32.store	$push0=, array0+4($pop43), $pop3
	i32.store	$1=, array1+4($pop44), $pop0
	i32.const	$push42=, 0
	i32.store	$drop=, array1+20($pop42), $0
	i32.const	$push41=, 0
	i32.store	$drop=, array2+4($pop41), $1
	i32.const	$push40=, 0
	i32.store	$drop=, array2+20($pop40), $0
	i32.const	$push39=, 0
	i32.store	$drop=, array3+4($pop39), $1
	i32.const	$push38=, 0
	i32.store	$drop=, array3+20($pop38), $0
	i32.const	$push37=, 0
	i32.store	$drop=, array4+4($pop37), $1
	i32.const	$push36=, 0
	i32.store	$drop=, array4+20($pop36), $0
	i32.const	$push35=, 0
	i32.store	$drop=, array5+4($pop35), $1
	i32.const	$push34=, 0
	i32.store	$drop=, array5+20($pop34), $0
	i32.const	$push4=, 1
	call    	foo@FUNCTION, $pop4
	i32.const	$push33=, 0
	f32.load	$push8=, counter0($pop33)
	f32.const	$push6=, 0x1.8p1
	f32.ne  	$push9=, $pop8, $pop6
	i32.const	$push32=, 0
	f32.load	$push5=, counter1($pop32)
	f32.const	$push31=, 0x1.8p1
	f32.ne  	$push7=, $pop5, $pop31
	i32.or  	$push10=, $pop9, $pop7
	i32.const	$push30=, 0
	f32.load	$push11=, counter2($pop30)
	f32.const	$push29=, 0x1.8p1
	f32.ne  	$push12=, $pop11, $pop29
	i32.or  	$push13=, $pop10, $pop12
	i32.const	$push28=, 0
	f32.load	$push14=, counter3($pop28)
	f32.const	$push27=, 0x1.8p1
	f32.ne  	$push15=, $pop14, $pop27
	i32.or  	$push16=, $pop13, $pop15
	i32.const	$push26=, 0
	f32.load	$push17=, counter4($pop26)
	f32.const	$push25=, 0x1.8p1
	f32.ne  	$push18=, $pop17, $pop25
	i32.or  	$push19=, $pop16, $pop18
	i32.const	$push24=, 0
	f32.load	$push20=, counter5($pop24)
	f32.const	$push23=, 0x1.8p1
	f32.ne  	$push21=, $pop20, $pop23
	i32.or  	$push22=, $pop19, $pop21
                                        # fallthrough-return: $pop22
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	counter0                # @counter0
	.type	counter0,@object
	.section	.bss.counter0,"aw",@nobits
	.globl	counter0
	.p2align	2
counter0:
	.int32	0                       # float 0
	.size	counter0, 4

	.hidden	counter1                # @counter1
	.type	counter1,@object
	.section	.bss.counter1,"aw",@nobits
	.globl	counter1
	.p2align	2
counter1:
	.int32	0                       # float 0
	.size	counter1, 4

	.hidden	counter2                # @counter2
	.type	counter2,@object
	.section	.bss.counter2,"aw",@nobits
	.globl	counter2
	.p2align	2
counter2:
	.int32	0                       # float 0
	.size	counter2, 4

	.hidden	counter3                # @counter3
	.type	counter3,@object
	.section	.bss.counter3,"aw",@nobits
	.globl	counter3
	.p2align	2
counter3:
	.int32	0                       # float 0
	.size	counter3, 4

	.hidden	counter4                # @counter4
	.type	counter4,@object
	.section	.bss.counter4,"aw",@nobits
	.globl	counter4
	.p2align	2
counter4:
	.int32	0                       # float 0
	.size	counter4, 4

	.hidden	counter5                # @counter5
	.type	counter5,@object
	.section	.bss.counter5,"aw",@nobits
	.globl	counter5
	.p2align	2
counter5:
	.int32	0                       # float 0
	.size	counter5, 4

	.hidden	stop                    # @stop
	.type	stop,@object
	.section	.data.stop,"aw",@progbits
	.globl	stop
	.p2align	2
stop:
	.int32	1                       # 0x1
	.size	stop, 4

	.hidden	array0                  # @array0
	.type	array0,@object
	.section	.bss.array0,"aw",@nobits
	.globl	array0
	.p2align	4
array0:
	.skip	64
	.size	array0, 64

	.hidden	array1                  # @array1
	.type	array1,@object
	.section	.bss.array1,"aw",@nobits
	.globl	array1
	.p2align	4
array1:
	.skip	64
	.size	array1, 64

	.hidden	array2                  # @array2
	.type	array2,@object
	.section	.bss.array2,"aw",@nobits
	.globl	array2
	.p2align	4
array2:
	.skip	64
	.size	array2, 64

	.hidden	array3                  # @array3
	.type	array3,@object
	.section	.bss.array3,"aw",@nobits
	.globl	array3
	.p2align	4
array3:
	.skip	64
	.size	array3, 64

	.hidden	array4                  # @array4
	.type	array4,@object
	.section	.bss.array4,"aw",@nobits
	.globl	array4
	.p2align	4
array4:
	.skip	64
	.size	array4, 64

	.hidden	array5                  # @array5
	.type	array5,@object
	.section	.bss.array5,"aw",@nobits
	.globl	array5
	.p2align	4
array5:
	.skip	64
	.size	array5, 64

	.hidden	vol                     # @vol
	.type	vol,@object
	.section	.bss.vol,"aw",@nobits
	.globl	vol
	.p2align	2
vol:
	.int32	0                       # 0x0
	.size	vol, 4


	.ident	"clang version 3.9.0 "
