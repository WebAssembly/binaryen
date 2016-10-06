	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/postmod-1.c"
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
	loop    	                # label0:
	i32.add 	$push269=, $2, $17
	tee_local	$push268=, $0=, $pop269
	i32.const	$push267=, array5
	i32.add 	$push9=, $pop268, $pop267
	f32.load	$3=, 0($pop9)
	i32.const	$push266=, array4
	i32.add 	$push10=, $0, $pop266
	f32.load	$4=, 0($pop10)
	i32.const	$push265=, array3
	i32.add 	$push11=, $0, $pop265
	f32.load	$5=, 0($pop11)
	i32.const	$push264=, array2
	i32.add 	$push12=, $0, $pop264
	f32.load	$6=, 0($pop12)
	i32.const	$push263=, array1
	i32.add 	$push13=, $0, $pop263
	f32.load	$7=, 0($pop13)
	i32.const	$push262=, 0
	f32.load	$8=, counter5($pop262)
	i32.const	$push261=, 0
	f32.load	$9=, counter4($pop261)
	i32.const	$push260=, 0
	f32.load	$10=, counter3($pop260)
	i32.const	$push259=, 0
	f32.load	$11=, counter2($pop259)
	i32.const	$push258=, 0
	f32.load	$12=, counter1($pop258)
	i32.const	$push257=, 0
	i32.add 	$push256=, $1, $17
	tee_local	$push255=, $13=, $pop256
	i32.const	$push254=, array0+12
	i32.add 	$push6=, $pop255, $pop254
	f32.load	$push7=, 0($pop6)
	i32.const	$push253=, array0
	i32.add 	$push2=, $0, $pop253
	f32.load	$push3=, 0($pop2)
	i32.const	$push252=, 0
	f32.load	$push4=, counter0($pop252)
	f32.add 	$push5=, $pop3, $pop4
	f32.add 	$push8=, $pop7, $pop5
	f32.store	counter0($pop257), $pop8
	i32.const	$push251=, 0
	i32.const	$push250=, array1+12
	i32.add 	$push15=, $13, $pop250
	f32.load	$push16=, 0($pop15)
	f32.add 	$push14=, $7, $12
	f32.add 	$push17=, $pop16, $pop14
	f32.store	counter1($pop251), $pop17
	i32.const	$push249=, 0
	i32.const	$push248=, array2+12
	i32.add 	$push19=, $13, $pop248
	f32.load	$push20=, 0($pop19)
	f32.add 	$push18=, $6, $11
	f32.add 	$push21=, $pop20, $pop18
	f32.store	counter2($pop249), $pop21
	i32.const	$push247=, 0
	i32.const	$push246=, array3+12
	i32.add 	$push23=, $13, $pop246
	f32.load	$push24=, 0($pop23)
	f32.add 	$push22=, $5, $10
	f32.add 	$push25=, $pop24, $pop22
	f32.store	counter3($pop247), $pop25
	i32.const	$push245=, 0
	i32.const	$push244=, array4+12
	i32.add 	$push27=, $13, $pop244
	f32.load	$push28=, 0($pop27)
	f32.add 	$push26=, $4, $9
	f32.add 	$push29=, $pop28, $pop26
	f32.store	counter4($pop245), $pop29
	i32.const	$push243=, 0
	i32.const	$push242=, array5+12
	i32.add 	$push31=, $13, $pop242
	f32.load	$push32=, 0($pop31)
	f32.add 	$push30=, $3, $8
	f32.add 	$push33=, $pop32, $pop30
	f32.store	counter5($pop243), $pop33
	i32.const	$push241=, 0
	i32.load	$0=, vol($pop241)
	i32.const	$push240=, 0
	i32.load	$13=, vol($pop240)
	i32.const	$push239=, 0
	i32.load	$14=, vol($pop239)
	i32.const	$push238=, 0
	i32.load	$15=, vol($pop238)
	i32.const	$push237=, 0
	i32.load	$16=, vol($pop237)
	i32.const	$push236=, 0
	i32.const	$push235=, 0
	i32.load	$push34=, vol($pop235)
	i32.add 	$push35=, $0, $pop34
	i32.store	vol($pop236), $pop35
	i32.const	$push234=, 0
	i32.const	$push233=, 0
	i32.load	$push36=, vol($pop233)
	i32.add 	$push37=, $13, $pop36
	i32.store	vol($pop234), $pop37
	i32.const	$push232=, 0
	i32.const	$push231=, 0
	i32.load	$push38=, vol($pop231)
	i32.add 	$push39=, $14, $pop38
	i32.store	vol($pop232), $pop39
	i32.const	$push230=, 0
	i32.const	$push229=, 0
	i32.load	$push40=, vol($pop229)
	i32.add 	$push41=, $15, $pop40
	i32.store	vol($pop230), $pop41
	i32.const	$push228=, 0
	i32.const	$push227=, 0
	i32.load	$push42=, vol($pop227)
	i32.add 	$push43=, $16, $pop42
	i32.store	vol($pop228), $pop43
	i32.const	$push226=, 0
	i32.const	$push225=, 0
	i32.load	$push44=, vol($pop225)
	i32.add 	$push45=, $0, $pop44
	i32.store	vol($pop226), $pop45
	i32.const	$push224=, 0
	i32.const	$push223=, 0
	i32.load	$push46=, vol($pop223)
	i32.add 	$push47=, $13, $pop46
	i32.store	vol($pop224), $pop47
	i32.const	$push222=, 0
	i32.const	$push221=, 0
	i32.load	$push48=, vol($pop221)
	i32.add 	$push49=, $14, $pop48
	i32.store	vol($pop222), $pop49
	i32.const	$push220=, 0
	i32.const	$push219=, 0
	i32.load	$push50=, vol($pop219)
	i32.add 	$push51=, $15, $pop50
	i32.store	vol($pop220), $pop51
	i32.const	$push218=, 0
	i32.const	$push217=, 0
	i32.load	$push52=, vol($pop217)
	i32.add 	$push53=, $16, $pop52
	i32.store	vol($pop218), $pop53
	i32.const	$push216=, 0
	i32.const	$push215=, 0
	i32.load	$push54=, vol($pop215)
	i32.add 	$push55=, $0, $pop54
	i32.store	vol($pop216), $pop55
	i32.const	$push214=, 0
	i32.const	$push213=, 0
	i32.load	$push56=, vol($pop213)
	i32.add 	$push57=, $13, $pop56
	i32.store	vol($pop214), $pop57
	i32.const	$push212=, 0
	i32.const	$push211=, 0
	i32.load	$push58=, vol($pop211)
	i32.add 	$push59=, $14, $pop58
	i32.store	vol($pop212), $pop59
	i32.const	$push210=, 0
	i32.const	$push209=, 0
	i32.load	$push60=, vol($pop209)
	i32.add 	$push61=, $15, $pop60
	i32.store	vol($pop210), $pop61
	i32.const	$push208=, 0
	i32.const	$push207=, 0
	i32.load	$push62=, vol($pop207)
	i32.add 	$push63=, $16, $pop62
	i32.store	vol($pop208), $pop63
	i32.const	$push206=, 0
	i32.const	$push205=, 0
	i32.load	$push64=, vol($pop205)
	i32.add 	$push65=, $0, $pop64
	i32.store	vol($pop206), $pop65
	i32.const	$push204=, 0
	i32.const	$push203=, 0
	i32.load	$push66=, vol($pop203)
	i32.add 	$push67=, $13, $pop66
	i32.store	vol($pop204), $pop67
	i32.const	$push202=, 0
	i32.const	$push201=, 0
	i32.load	$push68=, vol($pop201)
	i32.add 	$push69=, $14, $pop68
	i32.store	vol($pop202), $pop69
	i32.const	$push200=, 0
	i32.const	$push199=, 0
	i32.load	$push70=, vol($pop199)
	i32.add 	$push71=, $15, $pop70
	i32.store	vol($pop200), $pop71
	i32.const	$push198=, 0
	i32.const	$push197=, 0
	i32.load	$push72=, vol($pop197)
	i32.add 	$push73=, $16, $pop72
	i32.store	vol($pop198), $pop73
	i32.const	$push196=, 0
	i32.const	$push195=, 0
	i32.load	$push74=, vol($pop195)
	i32.add 	$push75=, $0, $pop74
	i32.store	vol($pop196), $pop75
	i32.const	$push194=, 0
	i32.const	$push193=, 0
	i32.load	$push76=, vol($pop193)
	i32.add 	$push77=, $13, $pop76
	i32.store	vol($pop194), $pop77
	i32.const	$push192=, 0
	i32.const	$push191=, 0
	i32.load	$push78=, vol($pop191)
	i32.add 	$push79=, $14, $pop78
	i32.store	vol($pop192), $pop79
	i32.const	$push190=, 0
	i32.const	$push189=, 0
	i32.load	$push80=, vol($pop189)
	i32.add 	$push81=, $15, $pop80
	i32.store	vol($pop190), $pop81
	i32.const	$push188=, 0
	i32.const	$push187=, 0
	i32.load	$push82=, vol($pop187)
	i32.add 	$push83=, $16, $pop82
	i32.store	vol($pop188), $pop83
	i32.const	$push186=, 0
	i32.const	$push185=, 0
	i32.load	$push84=, vol($pop185)
	i32.add 	$push85=, $0, $pop84
	i32.store	vol($pop186), $pop85
	i32.const	$push184=, 0
	i32.const	$push183=, 0
	i32.load	$push86=, vol($pop183)
	i32.add 	$push87=, $13, $pop86
	i32.store	vol($pop184), $pop87
	i32.const	$push182=, 0
	i32.const	$push181=, 0
	i32.load	$push88=, vol($pop181)
	i32.add 	$push89=, $14, $pop88
	i32.store	vol($pop182), $pop89
	i32.const	$push180=, 0
	i32.const	$push179=, 0
	i32.load	$push90=, vol($pop179)
	i32.add 	$push91=, $15, $pop90
	i32.store	vol($pop180), $pop91
	i32.const	$push178=, 0
	i32.const	$push177=, 0
	i32.load	$push92=, vol($pop177)
	i32.add 	$push93=, $16, $pop92
	i32.store	vol($pop178), $pop93
	i32.const	$push176=, 0
	i32.const	$push175=, 0
	i32.load	$push94=, vol($pop175)
	i32.add 	$push95=, $0, $pop94
	i32.store	vol($pop176), $pop95
	i32.const	$push174=, 0
	i32.const	$push173=, 0
	i32.load	$push96=, vol($pop173)
	i32.add 	$push97=, $13, $pop96
	i32.store	vol($pop174), $pop97
	i32.const	$push172=, 0
	i32.const	$push171=, 0
	i32.load	$push98=, vol($pop171)
	i32.add 	$push99=, $14, $pop98
	i32.store	vol($pop172), $pop99
	i32.const	$push170=, 0
	i32.const	$push169=, 0
	i32.load	$push100=, vol($pop169)
	i32.add 	$push101=, $15, $pop100
	i32.store	vol($pop170), $pop101
	i32.const	$push168=, 0
	i32.const	$push167=, 0
	i32.load	$push102=, vol($pop167)
	i32.add 	$push103=, $16, $pop102
	i32.store	vol($pop168), $pop103
	i32.const	$push166=, 0
	i32.const	$push165=, 0
	i32.load	$push104=, vol($pop165)
	i32.add 	$push105=, $0, $pop104
	i32.store	vol($pop166), $pop105
	i32.const	$push164=, 0
	i32.const	$push163=, 0
	i32.load	$push106=, vol($pop163)
	i32.add 	$push107=, $13, $pop106
	i32.store	vol($pop164), $pop107
	i32.const	$push162=, 0
	i32.const	$push161=, 0
	i32.load	$push108=, vol($pop161)
	i32.add 	$push109=, $14, $pop108
	i32.store	vol($pop162), $pop109
	i32.const	$push160=, 0
	i32.const	$push159=, 0
	i32.load	$push110=, vol($pop159)
	i32.add 	$push111=, $15, $pop110
	i32.store	vol($pop160), $pop111
	i32.const	$push158=, 0
	i32.const	$push157=, 0
	i32.load	$push112=, vol($pop157)
	i32.add 	$push113=, $16, $pop112
	i32.store	vol($pop158), $pop113
	i32.const	$push156=, 0
	i32.const	$push155=, 0
	i32.load	$push114=, vol($pop155)
	i32.add 	$push115=, $0, $pop114
	i32.store	vol($pop156), $pop115
	i32.const	$push154=, 0
	i32.const	$push153=, 0
	i32.load	$push116=, vol($pop153)
	i32.add 	$push117=, $13, $pop116
	i32.store	vol($pop154), $pop117
	i32.const	$push152=, 0
	i32.const	$push151=, 0
	i32.load	$push118=, vol($pop151)
	i32.add 	$push119=, $14, $pop118
	i32.store	vol($pop152), $pop119
	i32.const	$push150=, 0
	i32.const	$push149=, 0
	i32.load	$push120=, vol($pop149)
	i32.add 	$push121=, $15, $pop120
	i32.store	vol($pop150), $pop121
	i32.const	$push148=, 0
	i32.const	$push147=, 0
	i32.load	$push122=, vol($pop147)
	i32.add 	$push123=, $16, $pop122
	i32.store	vol($pop148), $pop123
	i32.const	$push146=, 0
	i32.const	$push145=, 0
	i32.load	$push124=, vol($pop145)
	i32.add 	$push125=, $0, $pop124
	i32.store	vol($pop146), $pop125
	i32.const	$push144=, 0
	i32.const	$push143=, 0
	i32.load	$push126=, vol($pop143)
	i32.add 	$push127=, $13, $pop126
	i32.store	vol($pop144), $pop127
	i32.const	$push142=, 0
	i32.const	$push141=, 0
	i32.load	$push128=, vol($pop141)
	i32.add 	$push129=, $14, $pop128
	i32.store	vol($pop142), $pop129
	i32.const	$push140=, 0
	i32.const	$push139=, 0
	i32.load	$push130=, vol($pop139)
	i32.add 	$push131=, $15, $pop130
	i32.store	vol($pop140), $pop131
	i32.const	$push138=, 0
	i32.const	$push137=, 0
	i32.load	$push132=, vol($pop137)
	i32.add 	$push133=, $16, $pop132
	i32.store	vol($pop138), $pop133
	i32.const	$push136=, 12
	i32.add 	$17=, $17, $pop136
	i32.const	$push135=, 0
	i32.load	$push134=, stop($pop135)
	i32.eqz 	$push270=, $pop134
	br_if   	0, $pop270      # 0: up to label0
# BB#2:                                 # %do.end
	end_loop
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
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1073741824
	i32.store	array0+20($pop1), $pop0
	i32.const	$push53=, 0
	i32.const	$push2=, 1065353216
	i32.store	array0+4($pop53), $pop2
	i32.const	$push52=, 0
	i32.const	$push51=, 1065353216
	i32.store	array1+4($pop52), $pop51
	i32.const	$push50=, 0
	i32.const	$push49=, 1073741824
	i32.store	array1+20($pop50), $pop49
	i32.const	$push48=, 0
	i32.const	$push47=, 1065353216
	i32.store	array2+4($pop48), $pop47
	i32.const	$push46=, 0
	i32.const	$push45=, 1073741824
	i32.store	array2+20($pop46), $pop45
	i32.const	$push44=, 0
	i32.const	$push43=, 1065353216
	i32.store	array3+4($pop44), $pop43
	i32.const	$push42=, 0
	i32.const	$push41=, 1073741824
	i32.store	array3+20($pop42), $pop41
	i32.const	$push40=, 0
	i32.const	$push39=, 1065353216
	i32.store	array4+4($pop40), $pop39
	i32.const	$push38=, 0
	i32.const	$push37=, 1073741824
	i32.store	array4+20($pop38), $pop37
	i32.const	$push36=, 0
	i32.const	$push35=, 1065353216
	i32.store	array5+4($pop36), $pop35
	i32.const	$push34=, 0
	i32.const	$push33=, 1073741824
	i32.store	array5+20($pop34), $pop33
	i32.const	$push3=, 1
	call    	foo@FUNCTION, $pop3
	i32.const	$push32=, 0
	f32.load	$push7=, counter0($pop32)
	f32.const	$push5=, 0x1.8p1
	f32.ne  	$push8=, $pop7, $pop5
	i32.const	$push31=, 0
	f32.load	$push4=, counter1($pop31)
	f32.const	$push30=, 0x1.8p1
	f32.ne  	$push6=, $pop4, $pop30
	i32.or  	$push9=, $pop8, $pop6
	i32.const	$push29=, 0
	f32.load	$push10=, counter2($pop29)
	f32.const	$push28=, 0x1.8p1
	f32.ne  	$push11=, $pop10, $pop28
	i32.or  	$push12=, $pop9, $pop11
	i32.const	$push27=, 0
	f32.load	$push13=, counter3($pop27)
	f32.const	$push26=, 0x1.8p1
	f32.ne  	$push14=, $pop13, $pop26
	i32.or  	$push15=, $pop12, $pop14
	i32.const	$push25=, 0
	f32.load	$push16=, counter4($pop25)
	f32.const	$push24=, 0x1.8p1
	f32.ne  	$push17=, $pop16, $pop24
	i32.or  	$push18=, $pop15, $pop17
	i32.const	$push23=, 0
	f32.load	$push19=, counter5($pop23)
	f32.const	$push22=, 0x1.8p1
	f32.ne  	$push20=, $pop19, $pop22
	i32.or  	$push21=, $pop18, $pop20
                                        # fallthrough-return: $pop21
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
