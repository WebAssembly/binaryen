	.text
	.file	"postmod-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, f32, f32, f32, f32, f32, f32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 2
	i32.shl 	$2=, $0, $pop0
	i32.const	$push1=, 3
	i32.shl 	$push2=, $0, $pop1
	i32.const	$push140=, 12
	i32.add 	$1=, $pop2, $pop140
	i32.const	$13=, 0
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.add 	$0=, $2, $13
	i32.const	$push277=, array0
	i32.add 	$push3=, $0, $pop277
	f32.load	$push4=, 0($pop3)
	i32.const	$push276=, 0
	f32.load	$push5=, counter0($pop276)
	f32.add 	$3=, $pop4, $pop5
	i32.const	$push275=, 0
	f32.store	counter0($pop275), $3
	i32.const	$push274=, array1
	i32.add 	$push6=, $0, $pop274
	f32.load	$push7=, 0($pop6)
	i32.const	$push273=, 0
	f32.load	$push8=, counter1($pop273)
	f32.add 	$4=, $pop7, $pop8
	i32.const	$push272=, 0
	f32.store	counter1($pop272), $4
	i32.const	$push271=, array2
	i32.add 	$push9=, $0, $pop271
	f32.load	$push10=, 0($pop9)
	i32.const	$push270=, 0
	f32.load	$push11=, counter2($pop270)
	f32.add 	$5=, $pop10, $pop11
	i32.const	$push269=, 0
	f32.store	counter2($pop269), $5
	i32.const	$push268=, array3
	i32.add 	$push12=, $0, $pop268
	f32.load	$push13=, 0($pop12)
	i32.const	$push267=, 0
	f32.load	$push14=, counter3($pop267)
	f32.add 	$6=, $pop13, $pop14
	i32.const	$push266=, 0
	f32.store	counter3($pop266), $6
	i32.const	$push265=, array4
	i32.add 	$push15=, $0, $pop265
	f32.load	$push16=, 0($pop15)
	i32.const	$push264=, 0
	f32.load	$push17=, counter4($pop264)
	f32.add 	$7=, $pop16, $pop17
	i32.const	$push263=, 0
	f32.store	counter4($pop263), $7
	i32.const	$push262=, array5
	i32.add 	$push18=, $0, $pop262
	f32.load	$push19=, 0($pop18)
	i32.const	$push261=, 0
	f32.load	$push20=, counter5($pop261)
	f32.add 	$8=, $pop19, $pop20
	i32.const	$push260=, 0
	f32.store	counter5($pop260), $8
	i32.add 	$0=, $1, $13
	i32.const	$push259=, 0
	i32.const	$push258=, array0
	i32.add 	$push21=, $0, $pop258
	f32.load	$push22=, 0($pop21)
	f32.add 	$push23=, $3, $pop22
	f32.store	counter0($pop259), $pop23
	i32.const	$push257=, 0
	i32.const	$push256=, array1
	i32.add 	$push24=, $0, $pop256
	f32.load	$push25=, 0($pop24)
	f32.add 	$push26=, $4, $pop25
	f32.store	counter1($pop257), $pop26
	i32.const	$push255=, 0
	i32.const	$push254=, array2
	i32.add 	$push27=, $0, $pop254
	f32.load	$push28=, 0($pop27)
	f32.add 	$push29=, $5, $pop28
	f32.store	counter2($pop255), $pop29
	i32.const	$push253=, 0
	i32.const	$push252=, array3
	i32.add 	$push30=, $0, $pop252
	f32.load	$push31=, 0($pop30)
	f32.add 	$push32=, $6, $pop31
	f32.store	counter3($pop253), $pop32
	i32.const	$push251=, 0
	i32.const	$push250=, array4
	i32.add 	$push33=, $0, $pop250
	f32.load	$push34=, 0($pop33)
	f32.add 	$push35=, $7, $pop34
	f32.store	counter4($pop251), $pop35
	i32.const	$push249=, 0
	i32.const	$push248=, array5
	i32.add 	$push36=, $0, $pop248
	f32.load	$push37=, 0($pop36)
	f32.add 	$push38=, $8, $pop37
	f32.store	counter5($pop249), $pop38
	i32.const	$push247=, 0
	i32.load	$0=, vol($pop247)
	i32.const	$push246=, 0
	i32.load	$9=, vol($pop246)
	i32.const	$push245=, 0
	i32.load	$10=, vol($pop245)
	i32.const	$push244=, 0
	i32.load	$11=, vol($pop244)
	i32.const	$push243=, 0
	i32.load	$12=, vol($pop243)
	i32.const	$push242=, 0
	i32.const	$push241=, 0
	i32.load	$push39=, vol($pop241)
	i32.add 	$push40=, $0, $pop39
	i32.store	vol($pop242), $pop40
	i32.const	$push240=, 0
	i32.const	$push239=, 0
	i32.load	$push41=, vol($pop239)
	i32.add 	$push42=, $9, $pop41
	i32.store	vol($pop240), $pop42
	i32.const	$push238=, 0
	i32.const	$push237=, 0
	i32.load	$push43=, vol($pop237)
	i32.add 	$push44=, $10, $pop43
	i32.store	vol($pop238), $pop44
	i32.const	$push236=, 0
	i32.const	$push235=, 0
	i32.load	$push45=, vol($pop235)
	i32.add 	$push46=, $11, $pop45
	i32.store	vol($pop236), $pop46
	i32.const	$push234=, 0
	i32.const	$push233=, 0
	i32.load	$push47=, vol($pop233)
	i32.add 	$push48=, $12, $pop47
	i32.store	vol($pop234), $pop48
	i32.const	$push232=, 0
	i32.const	$push231=, 0
	i32.load	$push49=, vol($pop231)
	i32.add 	$push50=, $0, $pop49
	i32.store	vol($pop232), $pop50
	i32.const	$push230=, 0
	i32.const	$push229=, 0
	i32.load	$push51=, vol($pop229)
	i32.add 	$push52=, $9, $pop51
	i32.store	vol($pop230), $pop52
	i32.const	$push228=, 0
	i32.const	$push227=, 0
	i32.load	$push53=, vol($pop227)
	i32.add 	$push54=, $10, $pop53
	i32.store	vol($pop228), $pop54
	i32.const	$push226=, 0
	i32.const	$push225=, 0
	i32.load	$push55=, vol($pop225)
	i32.add 	$push56=, $11, $pop55
	i32.store	vol($pop226), $pop56
	i32.const	$push224=, 0
	i32.const	$push223=, 0
	i32.load	$push57=, vol($pop223)
	i32.add 	$push58=, $12, $pop57
	i32.store	vol($pop224), $pop58
	i32.const	$push222=, 0
	i32.const	$push221=, 0
	i32.load	$push59=, vol($pop221)
	i32.add 	$push60=, $0, $pop59
	i32.store	vol($pop222), $pop60
	i32.const	$push220=, 0
	i32.const	$push219=, 0
	i32.load	$push61=, vol($pop219)
	i32.add 	$push62=, $9, $pop61
	i32.store	vol($pop220), $pop62
	i32.const	$push218=, 0
	i32.const	$push217=, 0
	i32.load	$push63=, vol($pop217)
	i32.add 	$push64=, $10, $pop63
	i32.store	vol($pop218), $pop64
	i32.const	$push216=, 0
	i32.const	$push215=, 0
	i32.load	$push65=, vol($pop215)
	i32.add 	$push66=, $11, $pop65
	i32.store	vol($pop216), $pop66
	i32.const	$push214=, 0
	i32.const	$push213=, 0
	i32.load	$push67=, vol($pop213)
	i32.add 	$push68=, $12, $pop67
	i32.store	vol($pop214), $pop68
	i32.const	$push212=, 0
	i32.const	$push211=, 0
	i32.load	$push69=, vol($pop211)
	i32.add 	$push70=, $0, $pop69
	i32.store	vol($pop212), $pop70
	i32.const	$push210=, 0
	i32.const	$push209=, 0
	i32.load	$push71=, vol($pop209)
	i32.add 	$push72=, $9, $pop71
	i32.store	vol($pop210), $pop72
	i32.const	$push208=, 0
	i32.const	$push207=, 0
	i32.load	$push73=, vol($pop207)
	i32.add 	$push74=, $10, $pop73
	i32.store	vol($pop208), $pop74
	i32.const	$push206=, 0
	i32.const	$push205=, 0
	i32.load	$push75=, vol($pop205)
	i32.add 	$push76=, $11, $pop75
	i32.store	vol($pop206), $pop76
	i32.const	$push204=, 0
	i32.const	$push203=, 0
	i32.load	$push77=, vol($pop203)
	i32.add 	$push78=, $12, $pop77
	i32.store	vol($pop204), $pop78
	i32.const	$push202=, 0
	i32.const	$push201=, 0
	i32.load	$push79=, vol($pop201)
	i32.add 	$push80=, $0, $pop79
	i32.store	vol($pop202), $pop80
	i32.const	$push200=, 0
	i32.const	$push199=, 0
	i32.load	$push81=, vol($pop199)
	i32.add 	$push82=, $9, $pop81
	i32.store	vol($pop200), $pop82
	i32.const	$push198=, 0
	i32.const	$push197=, 0
	i32.load	$push83=, vol($pop197)
	i32.add 	$push84=, $10, $pop83
	i32.store	vol($pop198), $pop84
	i32.const	$push196=, 0
	i32.const	$push195=, 0
	i32.load	$push85=, vol($pop195)
	i32.add 	$push86=, $11, $pop85
	i32.store	vol($pop196), $pop86
	i32.const	$push194=, 0
	i32.const	$push193=, 0
	i32.load	$push87=, vol($pop193)
	i32.add 	$push88=, $12, $pop87
	i32.store	vol($pop194), $pop88
	i32.const	$push192=, 0
	i32.const	$push191=, 0
	i32.load	$push89=, vol($pop191)
	i32.add 	$push90=, $0, $pop89
	i32.store	vol($pop192), $pop90
	i32.const	$push190=, 0
	i32.const	$push189=, 0
	i32.load	$push91=, vol($pop189)
	i32.add 	$push92=, $9, $pop91
	i32.store	vol($pop190), $pop92
	i32.const	$push188=, 0
	i32.const	$push187=, 0
	i32.load	$push93=, vol($pop187)
	i32.add 	$push94=, $10, $pop93
	i32.store	vol($pop188), $pop94
	i32.const	$push186=, 0
	i32.const	$push185=, 0
	i32.load	$push95=, vol($pop185)
	i32.add 	$push96=, $11, $pop95
	i32.store	vol($pop186), $pop96
	i32.const	$push184=, 0
	i32.const	$push183=, 0
	i32.load	$push97=, vol($pop183)
	i32.add 	$push98=, $12, $pop97
	i32.store	vol($pop184), $pop98
	i32.const	$push182=, 0
	i32.const	$push181=, 0
	i32.load	$push99=, vol($pop181)
	i32.add 	$push100=, $0, $pop99
	i32.store	vol($pop182), $pop100
	i32.const	$push180=, 0
	i32.const	$push179=, 0
	i32.load	$push101=, vol($pop179)
	i32.add 	$push102=, $9, $pop101
	i32.store	vol($pop180), $pop102
	i32.const	$push178=, 0
	i32.const	$push177=, 0
	i32.load	$push103=, vol($pop177)
	i32.add 	$push104=, $10, $pop103
	i32.store	vol($pop178), $pop104
	i32.const	$push176=, 0
	i32.const	$push175=, 0
	i32.load	$push105=, vol($pop175)
	i32.add 	$push106=, $11, $pop105
	i32.store	vol($pop176), $pop106
	i32.const	$push174=, 0
	i32.const	$push173=, 0
	i32.load	$push107=, vol($pop173)
	i32.add 	$push108=, $12, $pop107
	i32.store	vol($pop174), $pop108
	i32.const	$push172=, 0
	i32.const	$push171=, 0
	i32.load	$push109=, vol($pop171)
	i32.add 	$push110=, $0, $pop109
	i32.store	vol($pop172), $pop110
	i32.const	$push170=, 0
	i32.const	$push169=, 0
	i32.load	$push111=, vol($pop169)
	i32.add 	$push112=, $9, $pop111
	i32.store	vol($pop170), $pop112
	i32.const	$push168=, 0
	i32.const	$push167=, 0
	i32.load	$push113=, vol($pop167)
	i32.add 	$push114=, $10, $pop113
	i32.store	vol($pop168), $pop114
	i32.const	$push166=, 0
	i32.const	$push165=, 0
	i32.load	$push115=, vol($pop165)
	i32.add 	$push116=, $11, $pop115
	i32.store	vol($pop166), $pop116
	i32.const	$push164=, 0
	i32.const	$push163=, 0
	i32.load	$push117=, vol($pop163)
	i32.add 	$push118=, $12, $pop117
	i32.store	vol($pop164), $pop118
	i32.const	$push162=, 0
	i32.const	$push161=, 0
	i32.load	$push119=, vol($pop161)
	i32.add 	$push120=, $0, $pop119
	i32.store	vol($pop162), $pop120
	i32.const	$push160=, 0
	i32.const	$push159=, 0
	i32.load	$push121=, vol($pop159)
	i32.add 	$push122=, $9, $pop121
	i32.store	vol($pop160), $pop122
	i32.const	$push158=, 0
	i32.const	$push157=, 0
	i32.load	$push123=, vol($pop157)
	i32.add 	$push124=, $10, $pop123
	i32.store	vol($pop158), $pop124
	i32.const	$push156=, 0
	i32.const	$push155=, 0
	i32.load	$push125=, vol($pop155)
	i32.add 	$push126=, $11, $pop125
	i32.store	vol($pop156), $pop126
	i32.const	$push154=, 0
	i32.const	$push153=, 0
	i32.load	$push127=, vol($pop153)
	i32.add 	$push128=, $12, $pop127
	i32.store	vol($pop154), $pop128
	i32.const	$push152=, 0
	i32.const	$push151=, 0
	i32.load	$push129=, vol($pop151)
	i32.add 	$push130=, $0, $pop129
	i32.store	vol($pop152), $pop130
	i32.const	$push150=, 0
	i32.const	$push149=, 0
	i32.load	$push131=, vol($pop149)
	i32.add 	$push132=, $9, $pop131
	i32.store	vol($pop150), $pop132
	i32.const	$push148=, 0
	i32.const	$push147=, 0
	i32.load	$push133=, vol($pop147)
	i32.add 	$push134=, $10, $pop133
	i32.store	vol($pop148), $pop134
	i32.const	$push146=, 0
	i32.const	$push145=, 0
	i32.load	$push135=, vol($pop145)
	i32.add 	$push136=, $11, $pop135
	i32.store	vol($pop146), $pop136
	i32.const	$push144=, 0
	i32.const	$push143=, 0
	i32.load	$push137=, vol($pop143)
	i32.add 	$push138=, $12, $pop137
	i32.store	vol($pop144), $pop138
	i32.const	$push142=, 12
	i32.add 	$13=, $13, $pop142
	i32.const	$push141=, 0
	i32.load	$push139=, stop($pop141)
	i32.eqz 	$push278=, $pop139
	br_if   	0, $pop278      # 0: up to label0
# %bb.2:                                # %do.end
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
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
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
