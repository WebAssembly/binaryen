	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/simd-2.c"
	.section	.text.verify,"ax",@progbits
	.hidden	verify
	.globl	verify
	.type	verify,@function
verify:                                 # @verify
	.param  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.ne  	$push0=, $0, $4
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %entry
	i32.ne  	$push1=, $1, $5
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %entry
	i32.ne  	$push2=, $2, $6
	br_if   	0, $pop2        # 0: down to label0
# BB#3:                                 # %entry
	i32.ne  	$push3=, $3, $7
	br_if   	0, $pop3        # 0: down to label0
# BB#4:                                 # %if.end
	return
.LBB0_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	verify, .Lfunc_end0-verify

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push216=, 0
	i32.load16_u	$push215=, j+14($pop216)
	tee_local	$push214=, $15=, $pop215
	i32.const	$push213=, 0
	i32.load16_u	$push212=, i+14($pop213)
	tee_local	$push211=, $7=, $pop212
	i32.add 	$push210=, $pop214, $pop211
	tee_local	$push209=, $19=, $pop210
	i32.store16	k+14($pop0), $pop209
	i32.const	$push208=, 0
	i32.const	$push207=, 0
	i32.load16_u	$push206=, j+12($pop207)
	tee_local	$push205=, $14=, $pop206
	i32.const	$push204=, 0
	i32.load16_u	$push203=, i+12($pop204)
	tee_local	$push202=, $6=, $pop203
	i32.add 	$push201=, $pop205, $pop202
	tee_local	$push200=, $20=, $pop201
	i32.store16	k+12($pop208), $pop200
	i32.const	$push199=, 0
	i32.const	$push198=, 0
	i32.load16_u	$push197=, j+10($pop198)
	tee_local	$push196=, $13=, $pop197
	i32.const	$push195=, 0
	i32.load16_u	$push194=, i+10($pop195)
	tee_local	$push193=, $5=, $pop194
	i32.add 	$push192=, $pop196, $pop193
	tee_local	$push191=, $21=, $pop192
	i32.store16	k+10($pop199), $pop191
	i32.const	$push190=, 0
	i32.const	$push189=, 0
	i32.load16_u	$push188=, j+8($pop189)
	tee_local	$push187=, $12=, $pop188
	i32.const	$push186=, 0
	i32.load16_u	$push185=, i+8($pop186)
	tee_local	$push184=, $4=, $pop185
	i32.add 	$push183=, $pop187, $pop184
	tee_local	$push182=, $22=, $pop183
	i32.store16	k+8($pop190), $pop182
	i32.const	$push181=, 0
	i32.const	$push180=, 0
	i32.load16_u	$push179=, j+6($pop180)
	tee_local	$push178=, $11=, $pop179
	i32.const	$push177=, 0
	i32.load16_u	$push176=, i+6($pop177)
	tee_local	$push175=, $3=, $pop176
	i32.add 	$push174=, $pop178, $pop175
	tee_local	$push173=, $18=, $pop174
	i32.store16	k+6($pop181), $pop173
	i32.const	$push172=, 0
	i32.const	$push171=, 0
	i32.load16_u	$push170=, j+4($pop171)
	tee_local	$push169=, $10=, $pop170
	i32.const	$push168=, 0
	i32.load16_u	$push167=, i+4($pop168)
	tee_local	$push166=, $2=, $pop167
	i32.add 	$push165=, $pop169, $pop166
	tee_local	$push164=, $17=, $pop165
	i32.store16	k+4($pop172), $pop164
	i32.const	$push163=, 0
	i32.const	$push162=, 0
	i32.load16_u	$push161=, j+2($pop162)
	tee_local	$push160=, $9=, $pop161
	i32.const	$push159=, 0
	i32.load16_u	$push158=, i+2($pop159)
	tee_local	$push157=, $1=, $pop158
	i32.add 	$push156=, $pop160, $pop157
	tee_local	$push155=, $16=, $pop156
	i32.store16	k+2($pop163), $pop155
	i32.const	$push154=, 0
	i32.const	$push153=, 0
	i32.load16_u	$push152=, j($pop153)
	tee_local	$push151=, $8=, $pop152
	i32.const	$push150=, 0
	i32.load16_u	$push149=, i($pop150)
	tee_local	$push148=, $0=, $pop149
	i32.add 	$push147=, $pop151, $pop148
	tee_local	$push146=, $23=, $pop147
	i32.store16	k($pop154), $pop146
	i32.const	$push145=, 0
	i32.store16	res+14($pop145), $19
	i32.const	$push144=, 0
	i32.store16	res+12($pop144), $20
	i32.const	$push143=, 0
	i32.store16	res+10($pop143), $21
	i32.const	$push142=, 0
	i32.store16	res+8($pop142), $22
	i32.const	$push141=, 0
	i32.store16	res+6($pop141), $18
	i32.const	$push140=, 0
	i32.store16	res+4($pop140), $17
	i32.const	$push139=, 0
	i32.store16	res+2($pop139), $16
	i32.const	$push138=, 0
	i32.store16	res($pop138), $23
	block   	
	i32.const	$push137=, 65535
	i32.and 	$push1=, $23, $pop137
	i32.const	$push2=, 160
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push217=, 65535
	i32.and 	$push4=, $16, $pop217
	i32.const	$push5=, 113
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label1
# BB#2:                                 # %entry
	i32.const	$push218=, 65535
	i32.and 	$push7=, $17, $pop218
	i32.const	$push8=, 170
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label1
# BB#3:                                 # %entry
	i32.const	$push219=, 65535
	i32.and 	$push10=, $18, $pop219
	i32.const	$push11=, 230
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label1
# BB#4:                                 # %verify.exit
	i32.const	$push13=, 0
	i32.mul 	$push251=, $8, $0
	tee_local	$push250=, $23=, $pop251
	i32.store16	res($pop13), $pop250
	i32.const	$push249=, 0
	i32.store16	k($pop249), $23
	i32.const	$push248=, 0
	i32.mul 	$push247=, $9, $1
	tee_local	$push246=, $16=, $pop247
	i32.store16	res+2($pop248), $pop246
	i32.const	$push245=, 0
	i32.store16	k+2($pop245), $16
	i32.const	$push244=, 0
	i32.mul 	$push243=, $10, $2
	tee_local	$push242=, $17=, $pop243
	i32.store16	res+4($pop244), $pop242
	i32.const	$push241=, 0
	i32.store16	k+4($pop241), $17
	i32.const	$push240=, 0
	i32.mul 	$push239=, $11, $3
	tee_local	$push238=, $18=, $pop239
	i32.store16	res+6($pop240), $pop238
	i32.const	$push237=, 0
	i32.store16	k+6($pop237), $18
	i32.const	$push236=, 0
	i32.mul 	$push235=, $12, $4
	tee_local	$push234=, $19=, $pop235
	i32.store16	res+8($pop236), $pop234
	i32.const	$push233=, 0
	i32.store16	k+8($pop233), $19
	i32.const	$push232=, 0
	i32.mul 	$push231=, $13, $5
	tee_local	$push230=, $19=, $pop231
	i32.store16	res+10($pop232), $pop230
	i32.const	$push229=, 0
	i32.store16	k+10($pop229), $19
	i32.const	$push228=, 0
	i32.mul 	$push227=, $14, $6
	tee_local	$push226=, $19=, $pop227
	i32.store16	res+12($pop228), $pop226
	i32.const	$push225=, 0
	i32.store16	k+12($pop225), $19
	i32.const	$push224=, 0
	i32.mul 	$push223=, $15, $7
	tee_local	$push222=, $19=, $pop223
	i32.store16	res+14($pop224), $pop222
	i32.const	$push221=, 0
	i32.store16	k+14($pop221), $19
	i32.const	$push220=, 65535
	i32.and 	$push14=, $23, $pop220
	i32.const	$push15=, 1500
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label1
# BB#5:                                 # %verify.exit
	i32.const	$push252=, 65535
	i32.and 	$push17=, $16, $pop252
	i32.const	$push18=, 1300
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label1
# BB#6:                                 # %verify.exit
	i32.const	$push253=, 65535
	i32.and 	$push20=, $17, $pop253
	i32.const	$push21=, 3000
	i32.ne  	$push22=, $pop20, $pop21
	br_if   	0, $pop22       # 0: down to label1
# BB#7:                                 # %verify.exit
	i32.const	$push254=, 65535
	i32.and 	$push23=, $18, $pop254
	i32.const	$push24=, 6000
	i32.ne  	$push25=, $pop23, $pop24
	br_if   	0, $pop25       # 0: down to label1
# BB#8:                                 # %verify.exit40
	i32.const	$push31=, 0
	i32.const	$push26=, 16
	i32.shl 	$push29=, $0, $pop26
	i32.const	$push317=, 16
	i32.shr_s	$push30=, $pop29, $pop317
	i32.const	$push316=, 16
	i32.shl 	$push27=, $8, $pop316
	i32.const	$push315=, 16
	i32.shr_s	$push28=, $pop27, $pop315
	i32.div_s	$push314=, $pop30, $pop28
	tee_local	$push313=, $23=, $pop314
	i32.store16	res($pop31), $pop313
	i32.const	$push312=, 0
	i32.store16	k($pop312), $23
	i32.const	$push311=, 0
	i32.const	$push310=, 16
	i32.shl 	$push34=, $1, $pop310
	i32.const	$push309=, 16
	i32.shr_s	$push35=, $pop34, $pop309
	i32.const	$push308=, 16
	i32.shl 	$push32=, $9, $pop308
	i32.const	$push307=, 16
	i32.shr_s	$push33=, $pop32, $pop307
	i32.div_s	$push306=, $pop35, $pop33
	tee_local	$push305=, $16=, $pop306
	i32.store16	res+2($pop311), $pop305
	i32.const	$push304=, 0
	i32.store16	k+2($pop304), $16
	i32.const	$push303=, 0
	i32.const	$push302=, 16
	i32.shl 	$push38=, $2, $pop302
	i32.const	$push301=, 16
	i32.shr_s	$push39=, $pop38, $pop301
	i32.const	$push300=, 16
	i32.shl 	$push36=, $10, $pop300
	i32.const	$push299=, 16
	i32.shr_s	$push37=, $pop36, $pop299
	i32.div_s	$push298=, $pop39, $pop37
	tee_local	$push297=, $17=, $pop298
	i32.store16	res+4($pop303), $pop297
	i32.const	$push296=, 0
	i32.store16	k+4($pop296), $17
	i32.const	$push295=, 0
	i32.const	$push294=, 16
	i32.shl 	$push42=, $3, $pop294
	i32.const	$push293=, 16
	i32.shr_s	$push43=, $pop42, $pop293
	i32.const	$push292=, 16
	i32.shl 	$push40=, $11, $pop292
	i32.const	$push291=, 16
	i32.shr_s	$push41=, $pop40, $pop291
	i32.div_s	$push290=, $pop43, $pop41
	tee_local	$push289=, $18=, $pop290
	i32.store16	res+6($pop295), $pop289
	i32.const	$push288=, 0
	i32.store16	k+6($pop288), $18
	i32.const	$push287=, 0
	i32.const	$push286=, 16
	i32.shl 	$push46=, $4, $pop286
	i32.const	$push285=, 16
	i32.shr_s	$push47=, $pop46, $pop285
	i32.const	$push284=, 16
	i32.shl 	$push44=, $12, $pop284
	i32.const	$push283=, 16
	i32.shr_s	$push45=, $pop44, $pop283
	i32.div_s	$push282=, $pop47, $pop45
	tee_local	$push281=, $19=, $pop282
	i32.store16	res+8($pop287), $pop281
	i32.const	$push280=, 0
	i32.store16	k+8($pop280), $19
	i32.const	$push279=, 0
	i32.const	$push278=, 16
	i32.shl 	$push50=, $5, $pop278
	i32.const	$push277=, 16
	i32.shr_s	$push51=, $pop50, $pop277
	i32.const	$push276=, 16
	i32.shl 	$push48=, $13, $pop276
	i32.const	$push275=, 16
	i32.shr_s	$push49=, $pop48, $pop275
	i32.div_s	$push274=, $pop51, $pop49
	tee_local	$push273=, $19=, $pop274
	i32.store16	res+10($pop279), $pop273
	i32.const	$push272=, 0
	i32.store16	k+10($pop272), $19
	i32.const	$push271=, 0
	i32.const	$push270=, 16
	i32.shl 	$push54=, $6, $pop270
	i32.const	$push269=, 16
	i32.shr_s	$push55=, $pop54, $pop269
	i32.const	$push268=, 16
	i32.shl 	$push52=, $14, $pop268
	i32.const	$push267=, 16
	i32.shr_s	$push53=, $pop52, $pop267
	i32.div_s	$push266=, $pop55, $pop53
	tee_local	$push265=, $19=, $pop266
	i32.store16	res+12($pop271), $pop265
	i32.const	$push264=, 0
	i32.store16	k+12($pop264), $19
	i32.const	$push263=, 0
	i32.const	$push262=, 16
	i32.shl 	$push58=, $7, $pop262
	i32.const	$push261=, 16
	i32.shr_s	$push59=, $pop58, $pop261
	i32.const	$push260=, 16
	i32.shl 	$push56=, $15, $pop260
	i32.const	$push259=, 16
	i32.shr_s	$push57=, $pop56, $pop259
	i32.div_s	$push258=, $pop59, $pop57
	tee_local	$push257=, $19=, $pop258
	i32.store16	res+14($pop263), $pop257
	i32.const	$push256=, 0
	i32.store16	k+14($pop256), $19
	i32.const	$push255=, 65535
	i32.and 	$push60=, $23, $pop255
	i32.const	$push61=, 15
	i32.ne  	$push62=, $pop60, $pop61
	br_if   	0, $pop62       # 0: down to label1
# BB#9:                                 # %verify.exit40
	i32.const	$push319=, 65535
	i32.and 	$push63=, $16, $pop319
	i32.const	$push318=, 7
	i32.ne  	$push64=, $pop63, $pop318
	br_if   	0, $pop64       # 0: down to label1
# BB#10:                                # %verify.exit40
	i32.const	$push321=, 65535
	i32.and 	$push65=, $17, $pop321
	i32.const	$push320=, 7
	i32.ne  	$push66=, $pop65, $pop320
	br_if   	0, $pop66       # 0: down to label1
# BB#11:                                # %verify.exit40
	i32.const	$push322=, 65535
	i32.and 	$push67=, $18, $pop322
	i32.const	$push68=, 6
	i32.ne  	$push69=, $pop67, $pop68
	br_if   	0, $pop69       # 0: down to label1
# BB#12:                                # %verify.exit49
	i32.const	$push70=, 0
	i32.and 	$push354=, $8, $0
	tee_local	$push353=, $23=, $pop354
	i32.store16	res($pop70), $pop353
	i32.const	$push352=, 0
	i32.store16	k($pop352), $23
	i32.const	$push351=, 0
	i32.and 	$push350=, $9, $1
	tee_local	$push349=, $16=, $pop350
	i32.store16	res+2($pop351), $pop349
	i32.const	$push348=, 0
	i32.store16	k+2($pop348), $16
	i32.const	$push347=, 0
	i32.and 	$push346=, $10, $2
	tee_local	$push345=, $17=, $pop346
	i32.store16	res+4($pop347), $pop345
	i32.const	$push344=, 0
	i32.store16	k+4($pop344), $17
	i32.const	$push343=, 0
	i32.and 	$push342=, $11, $3
	tee_local	$push341=, $18=, $pop342
	i32.store16	res+6($pop343), $pop341
	i32.const	$push340=, 0
	i32.store16	k+6($pop340), $18
	i32.const	$push339=, 0
	i32.and 	$push338=, $12, $4
	tee_local	$push337=, $19=, $pop338
	i32.store16	res+8($pop339), $pop337
	i32.const	$push336=, 0
	i32.store16	k+8($pop336), $19
	i32.const	$push335=, 0
	i32.and 	$push334=, $13, $5
	tee_local	$push333=, $19=, $pop334
	i32.store16	res+10($pop335), $pop333
	i32.const	$push332=, 0
	i32.store16	k+10($pop332), $19
	i32.const	$push331=, 0
	i32.and 	$push330=, $14, $6
	tee_local	$push329=, $19=, $pop330
	i32.store16	res+12($pop331), $pop329
	i32.const	$push328=, 0
	i32.store16	k+12($pop328), $19
	i32.const	$push327=, 0
	i32.and 	$push326=, $15, $7
	tee_local	$push325=, $19=, $pop326
	i32.store16	res+14($pop327), $pop325
	i32.const	$push324=, 0
	i32.store16	k+14($pop324), $19
	i32.const	$push323=, 65535
	i32.and 	$push71=, $23, $pop323
	i32.const	$push72=, 2
	i32.ne  	$push73=, $pop71, $pop72
	br_if   	0, $pop73       # 0: down to label1
# BB#13:                                # %verify.exit49
	i32.const	$push355=, 65535
	i32.and 	$push74=, $16, $pop355
	i32.const	$push75=, 4
	i32.ne  	$push76=, $pop74, $pop75
	br_if   	0, $pop76       # 0: down to label1
# BB#14:                                # %verify.exit49
	i32.const	$push356=, 65535
	i32.and 	$push77=, $17, $pop356
	i32.const	$push78=, 20
	i32.ne  	$push79=, $pop77, $pop78
	br_if   	0, $pop79       # 0: down to label1
# BB#15:                                # %verify.exit49
	i32.const	$push357=, 65535
	i32.and 	$push80=, $18, $pop357
	i32.const	$push81=, 8
	i32.ne  	$push82=, $pop80, $pop81
	br_if   	0, $pop82       # 0: down to label1
# BB#16:                                # %verify.exit58
	i32.const	$push83=, 0
	i32.or  	$push389=, $8, $0
	tee_local	$push388=, $23=, $pop389
	i32.store16	res($pop83), $pop388
	i32.const	$push387=, 0
	i32.store16	k($pop387), $23
	i32.const	$push386=, 0
	i32.or  	$push385=, $9, $1
	tee_local	$push384=, $16=, $pop385
	i32.store16	res+2($pop386), $pop384
	i32.const	$push383=, 0
	i32.store16	k+2($pop383), $16
	i32.const	$push382=, 0
	i32.or  	$push381=, $10, $2
	tee_local	$push380=, $17=, $pop381
	i32.store16	res+4($pop382), $pop380
	i32.const	$push379=, 0
	i32.store16	k+4($pop379), $17
	i32.const	$push378=, 0
	i32.or  	$push377=, $11, $3
	tee_local	$push376=, $18=, $pop377
	i32.store16	res+6($pop378), $pop376
	i32.const	$push375=, 0
	i32.store16	k+6($pop375), $18
	i32.const	$push374=, 0
	i32.or  	$push373=, $12, $4
	tee_local	$push372=, $19=, $pop373
	i32.store16	res+8($pop374), $pop372
	i32.const	$push371=, 0
	i32.store16	k+8($pop371), $19
	i32.const	$push370=, 0
	i32.or  	$push369=, $13, $5
	tee_local	$push368=, $19=, $pop369
	i32.store16	res+10($pop370), $pop368
	i32.const	$push367=, 0
	i32.store16	k+10($pop367), $19
	i32.const	$push366=, 0
	i32.or  	$push365=, $14, $6
	tee_local	$push364=, $19=, $pop365
	i32.store16	res+12($pop366), $pop364
	i32.const	$push363=, 0
	i32.store16	k+12($pop363), $19
	i32.const	$push362=, 0
	i32.or  	$push361=, $15, $7
	tee_local	$push360=, $19=, $pop361
	i32.store16	res+14($pop362), $pop360
	i32.const	$push359=, 0
	i32.store16	k+14($pop359), $19
	i32.const	$push358=, 65535
	i32.and 	$push84=, $23, $pop358
	i32.const	$push85=, 158
	i32.ne  	$push86=, $pop84, $pop85
	br_if   	0, $pop86       # 0: down to label1
# BB#17:                                # %verify.exit58
	i32.const	$push390=, 65535
	i32.and 	$push87=, $16, $pop390
	i32.const	$push88=, 109
	i32.ne  	$push89=, $pop87, $pop88
	br_if   	0, $pop89       # 0: down to label1
# BB#18:                                # %verify.exit58
	i32.const	$push391=, 65535
	i32.and 	$push90=, $17, $pop391
	i32.const	$push91=, 150
	i32.ne  	$push92=, $pop90, $pop91
	br_if   	0, $pop92       # 0: down to label1
# BB#19:                                # %verify.exit58
	i32.const	$push392=, 65535
	i32.and 	$push93=, $18, $pop392
	i32.const	$push94=, 222
	i32.ne  	$push95=, $pop93, $pop94
	br_if   	0, $pop95       # 0: down to label1
# BB#20:                                # %verify.exit67
	i32.const	$push96=, 0
	i32.xor 	$push424=, $0, $8
	tee_local	$push423=, $23=, $pop424
	i32.store16	res($pop96), $pop423
	i32.const	$push422=, 0
	i32.store16	k($pop422), $23
	i32.const	$push421=, 0
	i32.xor 	$push420=, $1, $9
	tee_local	$push419=, $16=, $pop420
	i32.store16	res+2($pop421), $pop419
	i32.const	$push418=, 0
	i32.store16	k+2($pop418), $16
	i32.const	$push417=, 0
	i32.xor 	$push416=, $2, $10
	tee_local	$push415=, $17=, $pop416
	i32.store16	res+4($pop417), $pop415
	i32.const	$push414=, 0
	i32.store16	k+4($pop414), $17
	i32.const	$push413=, 0
	i32.xor 	$push412=, $3, $11
	tee_local	$push411=, $18=, $pop412
	i32.store16	res+6($pop413), $pop411
	i32.const	$push410=, 0
	i32.store16	k+6($pop410), $18
	i32.const	$push409=, 0
	i32.xor 	$push408=, $4, $12
	tee_local	$push407=, $19=, $pop408
	i32.store16	res+8($pop409), $pop407
	i32.const	$push406=, 0
	i32.store16	k+8($pop406), $19
	i32.const	$push405=, 0
	i32.xor 	$push404=, $5, $13
	tee_local	$push403=, $19=, $pop404
	i32.store16	res+10($pop405), $pop403
	i32.const	$push402=, 0
	i32.store16	k+10($pop402), $19
	i32.const	$push401=, 0
	i32.xor 	$push400=, $6, $14
	tee_local	$push399=, $19=, $pop400
	i32.store16	res+12($pop401), $pop399
	i32.const	$push398=, 0
	i32.store16	k+12($pop398), $19
	i32.const	$push397=, 0
	i32.xor 	$push396=, $7, $15
	tee_local	$push395=, $19=, $pop396
	i32.store16	res+14($pop397), $pop395
	i32.const	$push394=, 0
	i32.store16	k+14($pop394), $19
	i32.const	$push393=, 65535
	i32.and 	$push97=, $23, $pop393
	i32.const	$push98=, 156
	i32.ne  	$push99=, $pop97, $pop98
	br_if   	0, $pop99       # 0: down to label1
# BB#21:                                # %verify.exit67
	i32.const	$push425=, 65535
	i32.and 	$push100=, $16, $pop425
	i32.const	$push101=, 105
	i32.ne  	$push102=, $pop100, $pop101
	br_if   	0, $pop102      # 0: down to label1
# BB#22:                                # %verify.exit67
	i32.const	$push426=, 65535
	i32.and 	$push103=, $17, $pop426
	i32.const	$push104=, 130
	i32.ne  	$push105=, $pop103, $pop104
	br_if   	0, $pop105      # 0: down to label1
# BB#23:                                # %verify.exit67
	i32.const	$push427=, 65535
	i32.and 	$push106=, $18, $pop427
	i32.const	$push107=, 214
	i32.ne  	$push108=, $pop106, $pop107
	br_if   	0, $pop108      # 0: down to label1
# BB#24:                                # %verify.exit76
	i32.const	$push109=, 0
	i32.const	$push467=, 0
	i32.sub 	$push466=, $pop467, $0
	tee_local	$push465=, $23=, $pop466
	i32.store16	res($pop109), $pop465
	i32.const	$push464=, 0
	i32.store16	k($pop464), $23
	i32.const	$push463=, 0
	i32.const	$push462=, 0
	i32.sub 	$push461=, $pop462, $1
	tee_local	$push460=, $16=, $pop461
	i32.store16	res+2($pop463), $pop460
	i32.const	$push459=, 0
	i32.store16	k+2($pop459), $16
	i32.const	$push458=, 0
	i32.const	$push457=, 0
	i32.sub 	$push456=, $pop457, $2
	tee_local	$push455=, $17=, $pop456
	i32.store16	res+4($pop458), $pop455
	i32.const	$push454=, 0
	i32.store16	k+4($pop454), $17
	i32.const	$push453=, 0
	i32.const	$push452=, 0
	i32.sub 	$push451=, $pop452, $3
	tee_local	$push450=, $18=, $pop451
	i32.store16	res+6($pop453), $pop450
	i32.const	$push449=, 0
	i32.store16	k+6($pop449), $18
	i32.const	$push448=, 0
	i32.const	$push447=, 0
	i32.sub 	$push446=, $pop447, $4
	tee_local	$push445=, $19=, $pop446
	i32.store16	res+8($pop448), $pop445
	i32.const	$push444=, 0
	i32.store16	k+8($pop444), $19
	i32.const	$push443=, 0
	i32.const	$push442=, 0
	i32.sub 	$push441=, $pop442, $5
	tee_local	$push440=, $19=, $pop441
	i32.store16	res+10($pop443), $pop440
	i32.const	$push439=, 0
	i32.store16	k+10($pop439), $19
	i32.const	$push438=, 0
	i32.const	$push437=, 0
	i32.sub 	$push436=, $pop437, $6
	tee_local	$push435=, $19=, $pop436
	i32.store16	res+12($pop438), $pop435
	i32.const	$push434=, 0
	i32.store16	k+12($pop434), $19
	i32.const	$push433=, 0
	i32.const	$push432=, 0
	i32.sub 	$push431=, $pop432, $7
	tee_local	$push430=, $19=, $pop431
	i32.store16	res+14($pop433), $pop430
	i32.const	$push429=, 0
	i32.store16	k+14($pop429), $19
	i32.const	$push428=, 65535
	i32.and 	$push110=, $23, $pop428
	i32.const	$push111=, 65386
	i32.ne  	$push112=, $pop110, $pop111
	br_if   	0, $pop112      # 0: down to label1
# BB#25:                                # %verify.exit76
	i32.const	$push468=, 65535
	i32.and 	$push113=, $16, $pop468
	i32.const	$push114=, 65436
	i32.ne  	$push115=, $pop113, $pop114
	br_if   	0, $pop115      # 0: down to label1
# BB#26:                                # %verify.exit76
	i32.const	$push469=, 65535
	i32.and 	$push116=, $17, $pop469
	i32.const	$push117=, 65386
	i32.ne  	$push118=, $pop116, $pop117
	br_if   	0, $pop118      # 0: down to label1
# BB#27:                                # %verify.exit76
	i32.const	$push470=, 65535
	i32.and 	$push119=, $18, $pop470
	i32.const	$push120=, 65336
	i32.ne  	$push121=, $pop119, $pop120
	br_if   	0, $pop121      # 0: down to label1
# BB#28:                                # %verify.exit85
	i32.const	$push123=, 0
	i32.const	$push122=, -1
	i32.xor 	$push509=, $0, $pop122
	tee_local	$push508=, $23=, $pop509
	i32.store16	res($pop123), $pop508
	i32.const	$push507=, 0
	i32.store16	k($pop507), $23
	i32.const	$push506=, 0
	i32.const	$push505=, -1
	i32.xor 	$push504=, $1, $pop505
	tee_local	$push503=, $16=, $pop504
	i32.store16	res+2($pop506), $pop503
	i32.const	$push502=, 0
	i32.store16	k+2($pop502), $16
	i32.const	$push501=, 0
	i32.const	$push500=, -1
	i32.xor 	$push499=, $2, $pop500
	tee_local	$push498=, $17=, $pop499
	i32.store16	res+4($pop501), $pop498
	i32.const	$push497=, 0
	i32.store16	k+4($pop497), $17
	i32.const	$push496=, 0
	i32.const	$push495=, -1
	i32.xor 	$push494=, $3, $pop495
	tee_local	$push493=, $18=, $pop494
	i32.store16	res+6($pop496), $pop493
	i32.const	$push492=, 0
	i32.store16	k+6($pop492), $18
	i32.const	$push491=, 0
	i32.const	$push490=, -1
	i32.xor 	$push489=, $4, $pop490
	tee_local	$push488=, $19=, $pop489
	i32.store16	res+8($pop491), $pop488
	i32.const	$push487=, 0
	i32.store16	k+8($pop487), $19
	i32.const	$push486=, 0
	i32.const	$push485=, -1
	i32.xor 	$push484=, $5, $pop485
	tee_local	$push483=, $19=, $pop484
	i32.store16	res+10($pop486), $pop483
	i32.const	$push482=, 0
	i32.store16	k+10($pop482), $19
	i32.const	$push481=, 0
	i32.const	$push480=, -1
	i32.xor 	$push479=, $6, $pop480
	tee_local	$push478=, $19=, $pop479
	i32.store16	res+12($pop481), $pop478
	i32.const	$push477=, 0
	i32.store16	k+12($pop477), $19
	i32.const	$push476=, 0
	i32.const	$push475=, -1
	i32.xor 	$push474=, $7, $pop475
	tee_local	$push473=, $19=, $pop474
	i32.store16	res+14($pop476), $pop473
	i32.const	$push472=, 0
	i32.store16	k+14($pop472), $19
	i32.const	$push471=, 65535
	i32.and 	$push124=, $23, $pop471
	i32.const	$push125=, 65385
	i32.ne  	$push126=, $pop124, $pop125
	br_if   	0, $pop126      # 0: down to label1
# BB#29:                                # %verify.exit85
	i32.const	$push510=, 65535
	i32.and 	$push127=, $16, $pop510
	i32.const	$push128=, 65435
	i32.ne  	$push129=, $pop127, $pop128
	br_if   	0, $pop129      # 0: down to label1
# BB#30:                                # %verify.exit85
	i32.const	$push511=, 65535
	i32.and 	$push130=, $17, $pop511
	i32.const	$push131=, 65385
	i32.ne  	$push132=, $pop130, $pop131
	br_if   	0, $pop132      # 0: down to label1
# BB#31:                                # %verify.exit85
	i32.const	$push512=, 65535
	i32.and 	$push133=, $18, $pop512
	i32.const	$push134=, 65335
	i32.ne  	$push135=, $pop133, $pop134
	br_if   	0, $pop135      # 0: down to label1
# BB#32:                                # %verify.exit94
	i32.const	$push136=, 0
	call    	exit@FUNCTION, $pop136
	unreachable
.LBB1_33:                               # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.data.i,"aw",@progbits
	.globl	i
	.p2align	4
i:
	.int16	150                     # 0x96
	.int16	100                     # 0x64
	.int16	150                     # 0x96
	.int16	200                     # 0xc8
	.int16	0                       # 0x0
	.int16	0                       # 0x0
	.int16	0                       # 0x0
	.int16	0                       # 0x0
	.size	i, 16

	.hidden	j                       # @j
	.type	j,@object
	.section	.data.j,"aw",@progbits
	.globl	j
	.p2align	4
j:
	.int16	10                      # 0xa
	.int16	13                      # 0xd
	.int16	20                      # 0x14
	.int16	30                      # 0x1e
	.int16	1                       # 0x1
	.int16	1                       # 0x1
	.int16	1                       # 0x1
	.int16	1                       # 0x1
	.size	j, 16

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	4
k:
	.skip	16
	.size	k, 16

	.hidden	res                     # @res
	.type	res,@object
	.section	.bss.res,"aw",@nobits
	.globl	res
	.p2align	4
res:
	.skip	16
	.size	res, 16


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
	.functype	exit, void, i32
