	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/postmod-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.shl 	$2=, $0, $pop0
	i32.const	$push1=, 3
	i32.shl 	$1=, $0, $pop1
	i32.const	$17=, 0
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.add 	$push245=, $2, $17
	tee_local	$push244=, $0=, $pop245
	f32.load	$3=, array5($pop244)
	f32.load	$4=, array4($0)
	f32.load	$5=, array3($0)
	f32.load	$6=, array2($0)
	f32.load	$7=, array1($0)
	i32.const	$push243=, 0
	f32.load	$8=, counter5($pop243)
	i32.const	$push242=, 0
	f32.load	$9=, counter4($pop242)
	i32.const	$push241=, 0
	f32.load	$10=, counter3($pop241)
	i32.const	$push240=, 0
	f32.load	$11=, counter2($pop240)
	i32.const	$push239=, 0
	f32.load	$12=, counter1($pop239)
	i32.const	$push238=, 0
	i32.add 	$push237=, $1, $17
	tee_local	$push236=, $13=, $pop237
	f32.load	$push5=, array0+12($pop236)
	f32.load	$push2=, array0($0)
	i32.const	$push235=, 0
	f32.load	$push3=, counter0($pop235)
	f32.add 	$push4=, $pop2, $pop3
	f32.add 	$push6=, $pop5, $pop4
	f32.store	$drop=, counter0($pop238), $pop6
	i32.const	$push234=, 0
	f32.load	$push8=, array1+12($13)
	f32.add 	$push7=, $7, $12
	f32.add 	$push9=, $pop8, $pop7
	f32.store	$drop=, counter1($pop234), $pop9
	i32.const	$push233=, 0
	f32.load	$push11=, array2+12($13)
	f32.add 	$push10=, $6, $11
	f32.add 	$push12=, $pop11, $pop10
	f32.store	$drop=, counter2($pop233), $pop12
	i32.const	$push232=, 0
	f32.load	$push14=, array3+12($13)
	f32.add 	$push13=, $5, $10
	f32.add 	$push15=, $pop14, $pop13
	f32.store	$drop=, counter3($pop232), $pop15
	i32.const	$push231=, 0
	f32.load	$push17=, array4+12($13)
	f32.add 	$push16=, $4, $9
	f32.add 	$push18=, $pop17, $pop16
	f32.store	$drop=, counter4($pop231), $pop18
	i32.const	$push230=, 0
	f32.load	$push20=, array5+12($13)
	f32.add 	$push19=, $3, $8
	f32.add 	$push21=, $pop20, $pop19
	f32.store	$drop=, counter5($pop230), $pop21
	i32.const	$push229=, 0
	i32.load	$0=, vol($pop229)
	i32.const	$push228=, 0
	i32.load	$13=, vol($pop228)
	i32.const	$push227=, 0
	i32.load	$14=, vol($pop227)
	i32.const	$push226=, 0
	i32.load	$15=, vol($pop226)
	i32.const	$push225=, 0
	i32.load	$16=, vol($pop225)
	i32.const	$push224=, 0
	i32.const	$push223=, 0
	i32.load	$push22=, vol($pop223)
	i32.add 	$push23=, $0, $pop22
	i32.store	$drop=, vol($pop224), $pop23
	i32.const	$push222=, 0
	i32.const	$push221=, 0
	i32.load	$push24=, vol($pop221)
	i32.add 	$push25=, $13, $pop24
	i32.store	$drop=, vol($pop222), $pop25
	i32.const	$push220=, 0
	i32.const	$push219=, 0
	i32.load	$push26=, vol($pop219)
	i32.add 	$push27=, $14, $pop26
	i32.store	$drop=, vol($pop220), $pop27
	i32.const	$push218=, 0
	i32.const	$push217=, 0
	i32.load	$push28=, vol($pop217)
	i32.add 	$push29=, $15, $pop28
	i32.store	$drop=, vol($pop218), $pop29
	i32.const	$push216=, 0
	i32.const	$push215=, 0
	i32.load	$push30=, vol($pop215)
	i32.add 	$push31=, $16, $pop30
	i32.store	$drop=, vol($pop216), $pop31
	i32.const	$push214=, 0
	i32.const	$push213=, 0
	i32.load	$push32=, vol($pop213)
	i32.add 	$push33=, $0, $pop32
	i32.store	$drop=, vol($pop214), $pop33
	i32.const	$push212=, 0
	i32.const	$push211=, 0
	i32.load	$push34=, vol($pop211)
	i32.add 	$push35=, $13, $pop34
	i32.store	$drop=, vol($pop212), $pop35
	i32.const	$push210=, 0
	i32.const	$push209=, 0
	i32.load	$push36=, vol($pop209)
	i32.add 	$push37=, $14, $pop36
	i32.store	$drop=, vol($pop210), $pop37
	i32.const	$push208=, 0
	i32.const	$push207=, 0
	i32.load	$push38=, vol($pop207)
	i32.add 	$push39=, $15, $pop38
	i32.store	$drop=, vol($pop208), $pop39
	i32.const	$push206=, 0
	i32.const	$push205=, 0
	i32.load	$push40=, vol($pop205)
	i32.add 	$push41=, $16, $pop40
	i32.store	$drop=, vol($pop206), $pop41
	i32.const	$push204=, 0
	i32.const	$push203=, 0
	i32.load	$push42=, vol($pop203)
	i32.add 	$push43=, $0, $pop42
	i32.store	$drop=, vol($pop204), $pop43
	i32.const	$push202=, 0
	i32.const	$push201=, 0
	i32.load	$push44=, vol($pop201)
	i32.add 	$push45=, $13, $pop44
	i32.store	$drop=, vol($pop202), $pop45
	i32.const	$push200=, 0
	i32.const	$push199=, 0
	i32.load	$push46=, vol($pop199)
	i32.add 	$push47=, $14, $pop46
	i32.store	$drop=, vol($pop200), $pop47
	i32.const	$push198=, 0
	i32.const	$push197=, 0
	i32.load	$push48=, vol($pop197)
	i32.add 	$push49=, $15, $pop48
	i32.store	$drop=, vol($pop198), $pop49
	i32.const	$push196=, 0
	i32.const	$push195=, 0
	i32.load	$push50=, vol($pop195)
	i32.add 	$push51=, $16, $pop50
	i32.store	$drop=, vol($pop196), $pop51
	i32.const	$push194=, 0
	i32.const	$push193=, 0
	i32.load	$push52=, vol($pop193)
	i32.add 	$push53=, $0, $pop52
	i32.store	$drop=, vol($pop194), $pop53
	i32.const	$push192=, 0
	i32.const	$push191=, 0
	i32.load	$push54=, vol($pop191)
	i32.add 	$push55=, $13, $pop54
	i32.store	$drop=, vol($pop192), $pop55
	i32.const	$push190=, 0
	i32.const	$push189=, 0
	i32.load	$push56=, vol($pop189)
	i32.add 	$push57=, $14, $pop56
	i32.store	$drop=, vol($pop190), $pop57
	i32.const	$push188=, 0
	i32.const	$push187=, 0
	i32.load	$push58=, vol($pop187)
	i32.add 	$push59=, $15, $pop58
	i32.store	$drop=, vol($pop188), $pop59
	i32.const	$push186=, 0
	i32.const	$push185=, 0
	i32.load	$push60=, vol($pop185)
	i32.add 	$push61=, $16, $pop60
	i32.store	$drop=, vol($pop186), $pop61
	i32.const	$push184=, 0
	i32.const	$push183=, 0
	i32.load	$push62=, vol($pop183)
	i32.add 	$push63=, $0, $pop62
	i32.store	$drop=, vol($pop184), $pop63
	i32.const	$push182=, 0
	i32.const	$push181=, 0
	i32.load	$push64=, vol($pop181)
	i32.add 	$push65=, $13, $pop64
	i32.store	$drop=, vol($pop182), $pop65
	i32.const	$push180=, 0
	i32.const	$push179=, 0
	i32.load	$push66=, vol($pop179)
	i32.add 	$push67=, $14, $pop66
	i32.store	$drop=, vol($pop180), $pop67
	i32.const	$push178=, 0
	i32.const	$push177=, 0
	i32.load	$push68=, vol($pop177)
	i32.add 	$push69=, $15, $pop68
	i32.store	$drop=, vol($pop178), $pop69
	i32.const	$push176=, 0
	i32.const	$push175=, 0
	i32.load	$push70=, vol($pop175)
	i32.add 	$push71=, $16, $pop70
	i32.store	$drop=, vol($pop176), $pop71
	i32.const	$push174=, 0
	i32.const	$push173=, 0
	i32.load	$push72=, vol($pop173)
	i32.add 	$push73=, $0, $pop72
	i32.store	$drop=, vol($pop174), $pop73
	i32.const	$push172=, 0
	i32.const	$push171=, 0
	i32.load	$push74=, vol($pop171)
	i32.add 	$push75=, $13, $pop74
	i32.store	$drop=, vol($pop172), $pop75
	i32.const	$push170=, 0
	i32.const	$push169=, 0
	i32.load	$push76=, vol($pop169)
	i32.add 	$push77=, $14, $pop76
	i32.store	$drop=, vol($pop170), $pop77
	i32.const	$push168=, 0
	i32.const	$push167=, 0
	i32.load	$push78=, vol($pop167)
	i32.add 	$push79=, $15, $pop78
	i32.store	$drop=, vol($pop168), $pop79
	i32.const	$push166=, 0
	i32.const	$push165=, 0
	i32.load	$push80=, vol($pop165)
	i32.add 	$push81=, $16, $pop80
	i32.store	$drop=, vol($pop166), $pop81
	i32.const	$push164=, 0
	i32.const	$push163=, 0
	i32.load	$push82=, vol($pop163)
	i32.add 	$push83=, $0, $pop82
	i32.store	$drop=, vol($pop164), $pop83
	i32.const	$push162=, 0
	i32.const	$push161=, 0
	i32.load	$push84=, vol($pop161)
	i32.add 	$push85=, $13, $pop84
	i32.store	$drop=, vol($pop162), $pop85
	i32.const	$push160=, 0
	i32.const	$push159=, 0
	i32.load	$push86=, vol($pop159)
	i32.add 	$push87=, $14, $pop86
	i32.store	$drop=, vol($pop160), $pop87
	i32.const	$push158=, 0
	i32.const	$push157=, 0
	i32.load	$push88=, vol($pop157)
	i32.add 	$push89=, $15, $pop88
	i32.store	$drop=, vol($pop158), $pop89
	i32.const	$push156=, 0
	i32.const	$push155=, 0
	i32.load	$push90=, vol($pop155)
	i32.add 	$push91=, $16, $pop90
	i32.store	$drop=, vol($pop156), $pop91
	i32.const	$push154=, 0
	i32.const	$push153=, 0
	i32.load	$push92=, vol($pop153)
	i32.add 	$push93=, $0, $pop92
	i32.store	$drop=, vol($pop154), $pop93
	i32.const	$push152=, 0
	i32.const	$push151=, 0
	i32.load	$push94=, vol($pop151)
	i32.add 	$push95=, $13, $pop94
	i32.store	$drop=, vol($pop152), $pop95
	i32.const	$push150=, 0
	i32.const	$push149=, 0
	i32.load	$push96=, vol($pop149)
	i32.add 	$push97=, $14, $pop96
	i32.store	$drop=, vol($pop150), $pop97
	i32.const	$push148=, 0
	i32.const	$push147=, 0
	i32.load	$push98=, vol($pop147)
	i32.add 	$push99=, $15, $pop98
	i32.store	$drop=, vol($pop148), $pop99
	i32.const	$push146=, 0
	i32.const	$push145=, 0
	i32.load	$push100=, vol($pop145)
	i32.add 	$push101=, $16, $pop100
	i32.store	$drop=, vol($pop146), $pop101
	i32.const	$push144=, 0
	i32.const	$push143=, 0
	i32.load	$push102=, vol($pop143)
	i32.add 	$push103=, $0, $pop102
	i32.store	$drop=, vol($pop144), $pop103
	i32.const	$push142=, 0
	i32.const	$push141=, 0
	i32.load	$push104=, vol($pop141)
	i32.add 	$push105=, $13, $pop104
	i32.store	$drop=, vol($pop142), $pop105
	i32.const	$push140=, 0
	i32.const	$push139=, 0
	i32.load	$push106=, vol($pop139)
	i32.add 	$push107=, $14, $pop106
	i32.store	$drop=, vol($pop140), $pop107
	i32.const	$push138=, 0
	i32.const	$push137=, 0
	i32.load	$push108=, vol($pop137)
	i32.add 	$push109=, $15, $pop108
	i32.store	$drop=, vol($pop138), $pop109
	i32.const	$push136=, 0
	i32.const	$push135=, 0
	i32.load	$push110=, vol($pop135)
	i32.add 	$push111=, $16, $pop110
	i32.store	$drop=, vol($pop136), $pop111
	i32.const	$push134=, 0
	i32.const	$push133=, 0
	i32.load	$push112=, vol($pop133)
	i32.add 	$push113=, $0, $pop112
	i32.store	$drop=, vol($pop134), $pop113
	i32.const	$push132=, 0
	i32.const	$push131=, 0
	i32.load	$push114=, vol($pop131)
	i32.add 	$push115=, $13, $pop114
	i32.store	$drop=, vol($pop132), $pop115
	i32.const	$push130=, 0
	i32.const	$push129=, 0
	i32.load	$push116=, vol($pop129)
	i32.add 	$push117=, $14, $pop116
	i32.store	$drop=, vol($pop130), $pop117
	i32.const	$push128=, 0
	i32.const	$push127=, 0
	i32.load	$push118=, vol($pop127)
	i32.add 	$push119=, $15, $pop118
	i32.store	$drop=, vol($pop128), $pop119
	i32.const	$push126=, 0
	i32.const	$push125=, 0
	i32.load	$push120=, vol($pop125)
	i32.add 	$push121=, $16, $pop120
	i32.store	$drop=, vol($pop126), $pop121
	i32.const	$push124=, 12
	i32.add 	$17=, $17, $pop124
	i32.const	$push123=, 0
	i32.load	$push122=, stop($pop123)
	i32.eqz 	$push246=, $pop122
	br_if   	0, $pop246      # 0: up to label0
# BB#2:                                 # %do.end
	end_loop                        # label1:
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


	.ident	"clang version 4.0.0 "
