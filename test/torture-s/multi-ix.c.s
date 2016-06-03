	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/multi-ix.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push193=, 0
	i32.const	$push190=, 0
	i32.load	$push191=, __stack_pointer($pop190)
	i32.const	$push192=, 80480
	i32.sub 	$push665=, $pop191, $pop192
	i32.store	$1=, __stack_pointer($pop193), $pop665
	block
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.body.lr.ph
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push197=, 320
	i32.add 	$push198=, $1, $pop197
	i32.const	$push819=, 156
	i32.add 	$push2=, $pop198, $pop819
	i32.const	$push199=, 480
	i32.add 	$push200=, $1, $pop199
	i32.store	$drop=, 0($pop2), $pop200
	i32.const	$push201=, 320
	i32.add 	$push202=, $1, $pop201
	i32.const	$push818=, 152
	i32.add 	$push3=, $pop202, $pop818
	i32.const	$push203=, 2480
	i32.add 	$push204=, $1, $pop203
	i32.store	$drop=, 0($pop3), $pop204
	i32.const	$push205=, 320
	i32.add 	$push206=, $1, $pop205
	i32.const	$push817=, 148
	i32.add 	$push4=, $pop206, $pop817
	i32.const	$push207=, 4480
	i32.add 	$push208=, $1, $pop207
	i32.store	$drop=, 0($pop4), $pop208
	i32.const	$push209=, 320
	i32.add 	$push210=, $1, $pop209
	i32.const	$push816=, 144
	i32.add 	$push5=, $pop210, $pop816
	i32.const	$push211=, 6480
	i32.add 	$push212=, $1, $pop211
	i32.store	$drop=, 0($pop5), $pop212
	i32.const	$push213=, 320
	i32.add 	$push214=, $1, $pop213
	i32.const	$push815=, 140
	i32.add 	$push6=, $pop214, $pop815
	i32.const	$push215=, 8480
	i32.add 	$push216=, $1, $pop215
	i32.store	$drop=, 0($pop6), $pop216
	i32.const	$push217=, 320
	i32.add 	$push218=, $1, $pop217
	i32.const	$push814=, 136
	i32.add 	$push7=, $pop218, $pop814
	i32.const	$push219=, 10480
	i32.add 	$push220=, $1, $pop219
	i32.store	$drop=, 0($pop7), $pop220
	i32.const	$push221=, 320
	i32.add 	$push222=, $1, $pop221
	i32.const	$push813=, 132
	i32.add 	$push8=, $pop222, $pop813
	i32.const	$push223=, 12480
	i32.add 	$push224=, $1, $pop223
	i32.store	$drop=, 0($pop8), $pop224
	i32.const	$push225=, 320
	i32.add 	$push226=, $1, $pop225
	i32.const	$push812=, 128
	i32.add 	$push9=, $pop226, $pop812
	i32.const	$push227=, 14480
	i32.add 	$push228=, $1, $pop227
	i32.store	$drop=, 0($pop9), $pop228
	i32.const	$push229=, 320
	i32.add 	$push230=, $1, $pop229
	i32.const	$push811=, 124
	i32.add 	$push10=, $pop230, $pop811
	i32.const	$push231=, 16480
	i32.add 	$push232=, $1, $pop231
	i32.store	$drop=, 0($pop10), $pop232
	i32.const	$push233=, 320
	i32.add 	$push234=, $1, $pop233
	i32.const	$push810=, 120
	i32.add 	$push11=, $pop234, $pop810
	i32.const	$push235=, 18480
	i32.add 	$push236=, $1, $pop235
	i32.store	$drop=, 0($pop11), $pop236
	i32.const	$push237=, 320
	i32.add 	$push238=, $1, $pop237
	i32.const	$push809=, 116
	i32.add 	$push12=, $pop238, $pop809
	i32.const	$push239=, 20480
	i32.add 	$push240=, $1, $pop239
	i32.store	$drop=, 0($pop12), $pop240
	i32.const	$push241=, 320
	i32.add 	$push242=, $1, $pop241
	i32.const	$push808=, 112
	i32.add 	$push13=, $pop242, $pop808
	i32.const	$push243=, 22480
	i32.add 	$push244=, $1, $pop243
	i32.store	$drop=, 0($pop13), $pop244
	i32.const	$push245=, 320
	i32.add 	$push246=, $1, $pop245
	i32.const	$push807=, 108
	i32.add 	$push14=, $pop246, $pop807
	i32.const	$push247=, 24480
	i32.add 	$push248=, $1, $pop247
	i32.store	$drop=, 0($pop14), $pop248
	i32.const	$push249=, 320
	i32.add 	$push250=, $1, $pop249
	i32.const	$push806=, 104
	i32.add 	$push15=, $pop250, $pop806
	i32.const	$push251=, 26480
	i32.add 	$push252=, $1, $pop251
	i32.store	$drop=, 0($pop15), $pop252
	i32.const	$push253=, 320
	i32.add 	$push254=, $1, $pop253
	i32.const	$push805=, 100
	i32.add 	$push16=, $pop254, $pop805
	i32.const	$push255=, 28480
	i32.add 	$push256=, $1, $pop255
	i32.store	$drop=, 0($pop16), $pop256
	i32.const	$push257=, 320
	i32.add 	$push258=, $1, $pop257
	i32.const	$push804=, 96
	i32.add 	$push17=, $pop258, $pop804
	i32.const	$push259=, 30480
	i32.add 	$push260=, $1, $pop259
	i32.store	$drop=, 0($pop17), $pop260
	i32.const	$push261=, 320
	i32.add 	$push262=, $1, $pop261
	i32.const	$push803=, 92
	i32.add 	$push18=, $pop262, $pop803
	i32.const	$push263=, 32480
	i32.add 	$push264=, $1, $pop263
	i32.store	$drop=, 0($pop18), $pop264
	i32.const	$push265=, 320
	i32.add 	$push266=, $1, $pop265
	i32.const	$push802=, 88
	i32.add 	$push19=, $pop266, $pop802
	i32.const	$push267=, 34480
	i32.add 	$push268=, $1, $pop267
	i32.store	$drop=, 0($pop19), $pop268
	i32.const	$push269=, 320
	i32.add 	$push270=, $1, $pop269
	i32.const	$push801=, 84
	i32.add 	$push20=, $pop270, $pop801
	i32.const	$push271=, 36480
	i32.add 	$push272=, $1, $pop271
	i32.store	$drop=, 0($pop20), $pop272
	i32.const	$push273=, 320
	i32.add 	$push274=, $1, $pop273
	i32.const	$push800=, 80
	i32.add 	$push21=, $pop274, $pop800
	i32.const	$push275=, 38480
	i32.add 	$push276=, $1, $pop275
	i32.store	$drop=, 0($pop21), $pop276
	i32.const	$push277=, 320
	i32.add 	$push278=, $1, $pop277
	i32.const	$push799=, 76
	i32.add 	$push22=, $pop278, $pop799
	i32.const	$push279=, 40480
	i32.add 	$push280=, $1, $pop279
	i32.store	$drop=, 0($pop22), $pop280
	i32.const	$push281=, 320
	i32.add 	$push282=, $1, $pop281
	i32.const	$push798=, 72
	i32.add 	$push23=, $pop282, $pop798
	i32.const	$push283=, 42480
	i32.add 	$push284=, $1, $pop283
	i32.store	$drop=, 0($pop23), $pop284
	i32.const	$push285=, 320
	i32.add 	$push286=, $1, $pop285
	i32.const	$push797=, 68
	i32.add 	$push24=, $pop286, $pop797
	i32.const	$push287=, 44480
	i32.add 	$push288=, $1, $pop287
	i32.store	$drop=, 0($pop24), $pop288
	i32.const	$push289=, 320
	i32.add 	$push290=, $1, $pop289
	i32.const	$push796=, 64
	i32.add 	$push25=, $pop290, $pop796
	i32.const	$push291=, 46480
	i32.add 	$push292=, $1, $pop291
	i32.store	$drop=, 0($pop25), $pop292
	i32.const	$push293=, 320
	i32.add 	$push294=, $1, $pop293
	i32.const	$push795=, 60
	i32.add 	$push26=, $pop294, $pop795
	i32.const	$push295=, 48480
	i32.add 	$push296=, $1, $pop295
	i32.store	$drop=, 0($pop26), $pop296
	i32.const	$push297=, 320
	i32.add 	$push298=, $1, $pop297
	i32.const	$push794=, 56
	i32.add 	$push27=, $pop298, $pop794
	i32.const	$push299=, 50480
	i32.add 	$push300=, $1, $pop299
	i32.store	$drop=, 0($pop27), $pop300
	i32.const	$push301=, 320
	i32.add 	$push302=, $1, $pop301
	i32.const	$push793=, 52
	i32.add 	$push28=, $pop302, $pop793
	i32.const	$push303=, 52480
	i32.add 	$push304=, $1, $pop303
	i32.store	$drop=, 0($pop28), $pop304
	i32.const	$push305=, 320
	i32.add 	$push306=, $1, $pop305
	i32.const	$push792=, 48
	i32.add 	$push29=, $pop306, $pop792
	i32.const	$push307=, 54480
	i32.add 	$push308=, $1, $pop307
	i32.store	$drop=, 0($pop29), $pop308
	i32.const	$push309=, 320
	i32.add 	$push310=, $1, $pop309
	i32.const	$push791=, 44
	i32.add 	$push30=, $pop310, $pop791
	i32.const	$push311=, 56480
	i32.add 	$push312=, $1, $pop311
	i32.store	$drop=, 0($pop30), $pop312
	i32.const	$push313=, 320
	i32.add 	$push314=, $1, $pop313
	i32.const	$push790=, 40
	i32.add 	$push31=, $pop314, $pop790
	i32.const	$push315=, 58480
	i32.add 	$push316=, $1, $pop315
	i32.store	$drop=, 0($pop31), $pop316
	i32.const	$push317=, 320
	i32.add 	$push318=, $1, $pop317
	i32.const	$push789=, 36
	i32.add 	$push32=, $pop318, $pop789
	i32.const	$push319=, 60480
	i32.add 	$push320=, $1, $pop319
	i32.store	$drop=, 0($pop32), $pop320
	i32.const	$push321=, 320
	i32.add 	$push322=, $1, $pop321
	i32.const	$push788=, 32
	i32.add 	$push33=, $pop322, $pop788
	i32.const	$push323=, 62480
	i32.add 	$push324=, $1, $pop323
	i32.store	$drop=, 0($pop33), $pop324
	i32.const	$push325=, 320
	i32.add 	$push326=, $1, $pop325
	i32.const	$push787=, 28
	i32.add 	$push34=, $pop326, $pop787
	i32.const	$push327=, 64480
	i32.add 	$push328=, $1, $pop327
	i32.store	$drop=, 0($pop34), $pop328
	i32.const	$push329=, 320
	i32.add 	$push330=, $1, $pop329
	i32.const	$push786=, 24
	i32.add 	$push35=, $pop330, $pop786
	i32.const	$push331=, 66480
	i32.add 	$push332=, $1, $pop331
	i32.store	$drop=, 0($pop35), $pop332
	i32.const	$push333=, 320
	i32.add 	$push334=, $1, $pop333
	i32.const	$push785=, 20
	i32.add 	$push36=, $pop334, $pop785
	i32.const	$push335=, 68480
	i32.add 	$push336=, $1, $pop335
	i32.store	$drop=, 0($pop36), $pop336
	i32.const	$push337=, 320
	i32.add 	$push338=, $1, $pop337
	i32.const	$push784=, 16
	i32.add 	$push37=, $pop338, $pop784
	i32.const	$push339=, 70480
	i32.add 	$push340=, $1, $pop339
	i32.store	$drop=, 0($pop37), $pop340
	i32.const	$push341=, 72480
	i32.add 	$push342=, $1, $pop341
	i32.store	$drop=, 332($1), $pop342
	i32.const	$push343=, 74480
	i32.add 	$push344=, $1, $pop343
	i32.store	$drop=, 328($1), $pop344
	i32.const	$push345=, 76480
	i32.add 	$push346=, $1, $pop345
	i32.store	$drop=, 324($1), $pop346
	i32.const	$push347=, 78480
	i32.add 	$push348=, $1, $pop347
	i32.store	$drop=, 320($1), $pop348
	i32.const	$push783=, 40
	i32.const	$push349=, 320
	i32.add 	$push350=, $1, $pop349
	call    	s@FUNCTION, $pop783, $pop350
	i32.load	$2=, 480($1)
	i32.load	$3=, 2480($1)
	i32.load	$4=, 4480($1)
	i32.load	$5=, 6480($1)
	i32.load	$6=, 8480($1)
	i32.load	$7=, 10480($1)
	i32.load	$8=, 12480($1)
	i32.load	$9=, 14480($1)
	i32.load	$10=, 16480($1)
	i32.load	$11=, 18480($1)
	i32.load	$12=, 20480($1)
	i32.load	$13=, 22480($1)
	i32.load	$14=, 24480($1)
	i32.load	$15=, 26480($1)
	i32.load	$16=, 28480($1)
	i32.load	$17=, 30480($1)
	i32.load	$18=, 32480($1)
	i32.load	$19=, 34480($1)
	i32.load	$20=, 36480($1)
	i32.load	$21=, 38480($1)
	i32.load	$22=, 40480($1)
	i32.load	$23=, 42480($1)
	i32.load	$24=, 44480($1)
	i32.load	$25=, 46480($1)
	i32.load	$26=, 48480($1)
	i32.load	$27=, 50480($1)
	i32.load	$28=, 52480($1)
	i32.load	$29=, 54480($1)
	i32.load	$30=, 56480($1)
	i32.load	$31=, 58480($1)
	i32.load	$32=, 60480($1)
	i32.load	$33=, 62480($1)
	i32.load	$34=, 64480($1)
	i32.load	$35=, 66480($1)
	i32.load	$36=, 68480($1)
	i32.load	$37=, 70480($1)
	i32.load	$38=, 72480($1)
	i32.load	$39=, 74480($1)
	i32.load	$40=, 78480($1)
	i32.load	$41=, 76480($1)
	i32.const	$push351=, 160
	i32.add 	$push352=, $1, $pop351
	i32.const	$push782=, 156
	i32.add 	$push38=, $pop352, $pop782
	i32.const	$push353=, 480
	i32.add 	$push354=, $1, $pop353
	i32.store	$drop=, 0($pop38), $pop354
	i32.const	$push355=, 160
	i32.add 	$push356=, $1, $pop355
	i32.const	$push781=, 152
	i32.add 	$push39=, $pop356, $pop781
	i32.const	$push357=, 2480
	i32.add 	$push358=, $1, $pop357
	i32.store	$drop=, 0($pop39), $pop358
	i32.const	$push359=, 160
	i32.add 	$push360=, $1, $pop359
	i32.const	$push780=, 148
	i32.add 	$push40=, $pop360, $pop780
	i32.const	$push361=, 4480
	i32.add 	$push362=, $1, $pop361
	i32.store	$drop=, 0($pop40), $pop362
	i32.const	$push363=, 160
	i32.add 	$push364=, $1, $pop363
	i32.const	$push779=, 144
	i32.add 	$push41=, $pop364, $pop779
	i32.const	$push365=, 6480
	i32.add 	$push366=, $1, $pop365
	i32.store	$drop=, 0($pop41), $pop366
	i32.const	$push367=, 160
	i32.add 	$push368=, $1, $pop367
	i32.const	$push778=, 140
	i32.add 	$push42=, $pop368, $pop778
	i32.const	$push369=, 8480
	i32.add 	$push370=, $1, $pop369
	i32.store	$drop=, 0($pop42), $pop370
	i32.const	$push371=, 160
	i32.add 	$push372=, $1, $pop371
	i32.const	$push777=, 136
	i32.add 	$push43=, $pop372, $pop777
	i32.const	$push373=, 10480
	i32.add 	$push374=, $1, $pop373
	i32.store	$drop=, 0($pop43), $pop374
	i32.const	$push375=, 160
	i32.add 	$push376=, $1, $pop375
	i32.const	$push776=, 132
	i32.add 	$push44=, $pop376, $pop776
	i32.const	$push377=, 12480
	i32.add 	$push378=, $1, $pop377
	i32.store	$drop=, 0($pop44), $pop378
	i32.const	$push379=, 160
	i32.add 	$push380=, $1, $pop379
	i32.const	$push775=, 128
	i32.add 	$push45=, $pop380, $pop775
	i32.const	$push381=, 14480
	i32.add 	$push382=, $1, $pop381
	i32.store	$drop=, 0($pop45), $pop382
	i32.const	$push383=, 160
	i32.add 	$push384=, $1, $pop383
	i32.const	$push774=, 124
	i32.add 	$push46=, $pop384, $pop774
	i32.const	$push385=, 16480
	i32.add 	$push386=, $1, $pop385
	i32.store	$drop=, 0($pop46), $pop386
	i32.const	$push387=, 160
	i32.add 	$push388=, $1, $pop387
	i32.const	$push773=, 120
	i32.add 	$push47=, $pop388, $pop773
	i32.const	$push389=, 18480
	i32.add 	$push390=, $1, $pop389
	i32.store	$drop=, 0($pop47), $pop390
	i32.const	$push391=, 160
	i32.add 	$push392=, $1, $pop391
	i32.const	$push772=, 116
	i32.add 	$push48=, $pop392, $pop772
	i32.const	$push393=, 20480
	i32.add 	$push394=, $1, $pop393
	i32.store	$drop=, 0($pop48), $pop394
	i32.const	$push395=, 160
	i32.add 	$push396=, $1, $pop395
	i32.const	$push771=, 112
	i32.add 	$push49=, $pop396, $pop771
	i32.const	$push397=, 22480
	i32.add 	$push398=, $1, $pop397
	i32.store	$drop=, 0($pop49), $pop398
	i32.const	$push399=, 160
	i32.add 	$push400=, $1, $pop399
	i32.const	$push770=, 108
	i32.add 	$push50=, $pop400, $pop770
	i32.const	$push401=, 24480
	i32.add 	$push402=, $1, $pop401
	i32.store	$drop=, 0($pop50), $pop402
	i32.const	$push403=, 160
	i32.add 	$push404=, $1, $pop403
	i32.const	$push769=, 104
	i32.add 	$push51=, $pop404, $pop769
	i32.const	$push405=, 26480
	i32.add 	$push406=, $1, $pop405
	i32.store	$drop=, 0($pop51), $pop406
	i32.const	$push407=, 160
	i32.add 	$push408=, $1, $pop407
	i32.const	$push768=, 100
	i32.add 	$push52=, $pop408, $pop768
	i32.const	$push409=, 28480
	i32.add 	$push410=, $1, $pop409
	i32.store	$drop=, 0($pop52), $pop410
	i32.const	$push411=, 160
	i32.add 	$push412=, $1, $pop411
	i32.const	$push767=, 96
	i32.add 	$push53=, $pop412, $pop767
	i32.const	$push413=, 30480
	i32.add 	$push414=, $1, $pop413
	i32.store	$drop=, 0($pop53), $pop414
	i32.const	$push415=, 160
	i32.add 	$push416=, $1, $pop415
	i32.const	$push766=, 92
	i32.add 	$push54=, $pop416, $pop766
	i32.const	$push417=, 32480
	i32.add 	$push418=, $1, $pop417
	i32.store	$drop=, 0($pop54), $pop418
	i32.const	$push419=, 160
	i32.add 	$push420=, $1, $pop419
	i32.const	$push765=, 88
	i32.add 	$push55=, $pop420, $pop765
	i32.const	$push421=, 34480
	i32.add 	$push422=, $1, $pop421
	i32.store	$drop=, 0($pop55), $pop422
	i32.const	$push423=, 160
	i32.add 	$push424=, $1, $pop423
	i32.const	$push764=, 84
	i32.add 	$push56=, $pop424, $pop764
	i32.const	$push425=, 36480
	i32.add 	$push426=, $1, $pop425
	i32.store	$drop=, 0($pop56), $pop426
	i32.const	$push427=, 160
	i32.add 	$push428=, $1, $pop427
	i32.const	$push763=, 80
	i32.add 	$push57=, $pop428, $pop763
	i32.const	$push429=, 38480
	i32.add 	$push430=, $1, $pop429
	i32.store	$drop=, 0($pop57), $pop430
	i32.const	$push431=, 160
	i32.add 	$push432=, $1, $pop431
	i32.const	$push762=, 76
	i32.add 	$push58=, $pop432, $pop762
	i32.const	$push433=, 40480
	i32.add 	$push434=, $1, $pop433
	i32.store	$drop=, 0($pop58), $pop434
	i32.const	$push435=, 160
	i32.add 	$push436=, $1, $pop435
	i32.const	$push761=, 72
	i32.add 	$push59=, $pop436, $pop761
	i32.const	$push437=, 42480
	i32.add 	$push438=, $1, $pop437
	i32.store	$drop=, 0($pop59), $pop438
	i32.const	$push439=, 160
	i32.add 	$push440=, $1, $pop439
	i32.const	$push760=, 68
	i32.add 	$push60=, $pop440, $pop760
	i32.const	$push441=, 44480
	i32.add 	$push442=, $1, $pop441
	i32.store	$drop=, 0($pop60), $pop442
	i32.const	$push443=, 160
	i32.add 	$push444=, $1, $pop443
	i32.const	$push759=, 64
	i32.add 	$push61=, $pop444, $pop759
	i32.const	$push445=, 46480
	i32.add 	$push446=, $1, $pop445
	i32.store	$drop=, 0($pop61), $pop446
	i32.const	$push447=, 160
	i32.add 	$push448=, $1, $pop447
	i32.const	$push758=, 60
	i32.add 	$push62=, $pop448, $pop758
	i32.const	$push449=, 48480
	i32.add 	$push450=, $1, $pop449
	i32.store	$drop=, 0($pop62), $pop450
	i32.const	$push451=, 160
	i32.add 	$push452=, $1, $pop451
	i32.const	$push757=, 56
	i32.add 	$push63=, $pop452, $pop757
	i32.const	$push453=, 50480
	i32.add 	$push454=, $1, $pop453
	i32.store	$drop=, 0($pop63), $pop454
	i32.const	$push455=, 160
	i32.add 	$push456=, $1, $pop455
	i32.const	$push756=, 52
	i32.add 	$push64=, $pop456, $pop756
	i32.const	$push457=, 52480
	i32.add 	$push458=, $1, $pop457
	i32.store	$drop=, 0($pop64), $pop458
	i32.const	$push459=, 160
	i32.add 	$push460=, $1, $pop459
	i32.const	$push755=, 48
	i32.add 	$push65=, $pop460, $pop755
	i32.const	$push461=, 54480
	i32.add 	$push462=, $1, $pop461
	i32.store	$drop=, 0($pop65), $pop462
	i32.const	$push463=, 160
	i32.add 	$push464=, $1, $pop463
	i32.const	$push754=, 44
	i32.add 	$push66=, $pop464, $pop754
	i32.const	$push465=, 56480
	i32.add 	$push466=, $1, $pop465
	i32.store	$drop=, 0($pop66), $pop466
	i32.const	$push467=, 160
	i32.add 	$push468=, $1, $pop467
	i32.const	$push753=, 40
	i32.add 	$push67=, $pop468, $pop753
	i32.const	$push469=, 58480
	i32.add 	$push470=, $1, $pop469
	i32.store	$drop=, 0($pop67), $pop470
	i32.const	$push471=, 160
	i32.add 	$push472=, $1, $pop471
	i32.const	$push752=, 36
	i32.add 	$push68=, $pop472, $pop752
	i32.const	$push473=, 60480
	i32.add 	$push474=, $1, $pop473
	i32.store	$drop=, 0($pop68), $pop474
	i32.const	$push475=, 160
	i32.add 	$push476=, $1, $pop475
	i32.const	$push751=, 32
	i32.add 	$push69=, $pop476, $pop751
	i32.const	$push477=, 62480
	i32.add 	$push478=, $1, $pop477
	i32.store	$drop=, 0($pop69), $pop478
	i32.const	$push479=, 160
	i32.add 	$push480=, $1, $pop479
	i32.const	$push750=, 28
	i32.add 	$push70=, $pop480, $pop750
	i32.const	$push481=, 64480
	i32.add 	$push482=, $1, $pop481
	i32.store	$drop=, 0($pop70), $pop482
	i32.const	$push483=, 160
	i32.add 	$push484=, $1, $pop483
	i32.const	$push749=, 24
	i32.add 	$push71=, $pop484, $pop749
	i32.const	$push485=, 66480
	i32.add 	$push486=, $1, $pop485
	i32.store	$drop=, 0($pop71), $pop486
	i32.const	$push487=, 160
	i32.add 	$push488=, $1, $pop487
	i32.const	$push748=, 20
	i32.add 	$push72=, $pop488, $pop748
	i32.const	$push489=, 68480
	i32.add 	$push490=, $1, $pop489
	i32.store	$drop=, 0($pop72), $pop490
	i32.const	$push491=, 160
	i32.add 	$push492=, $1, $pop491
	i32.const	$push747=, 16
	i32.add 	$push73=, $pop492, $pop747
	i32.const	$push493=, 70480
	i32.add 	$push494=, $1, $pop493
	i32.store	$drop=, 0($pop73), $pop494
	i32.const	$push495=, 72480
	i32.add 	$push496=, $1, $pop495
	i32.store	$drop=, 172($1), $pop496
	i32.const	$push497=, 74480
	i32.add 	$push498=, $1, $pop497
	i32.store	$drop=, 168($1), $pop498
	i32.const	$push499=, 76480
	i32.add 	$push500=, $1, $pop499
	i32.store	$drop=, 164($1), $pop500
	i32.const	$push501=, 78480
	i32.add 	$push502=, $1, $pop501
	i32.store	$drop=, 160($1), $pop502
	i32.const	$push746=, 40
	i32.const	$push503=, 160
	i32.add 	$push504=, $1, $pop503
	call    	z@FUNCTION, $pop746, $pop504
	i32.const	$push505=, 76480
	i32.add 	$push506=, $1, $pop505
	i32.const	$push745=, 2
	i32.shl 	$push74=, $41, $pop745
	i32.add 	$push75=, $pop506, $pop74
	i32.store	$drop=, 0($pop75), $41
	i32.const	$push507=, 78480
	i32.add 	$push508=, $1, $pop507
	i32.const	$push744=, 2
	i32.shl 	$push76=, $40, $pop744
	i32.add 	$push77=, $pop508, $pop76
	i32.store	$drop=, 0($pop77), $40
	i32.const	$push509=, 74480
	i32.add 	$push510=, $1, $pop509
	i32.const	$push743=, 2
	i32.shl 	$push78=, $39, $pop743
	i32.add 	$push79=, $pop510, $pop78
	i32.store	$drop=, 0($pop79), $39
	i32.const	$push511=, 72480
	i32.add 	$push512=, $1, $pop511
	i32.const	$push742=, 2
	i32.shl 	$push80=, $38, $pop742
	i32.add 	$push81=, $pop512, $pop80
	i32.store	$drop=, 0($pop81), $38
	i32.const	$push513=, 70480
	i32.add 	$push514=, $1, $pop513
	i32.const	$push741=, 2
	i32.shl 	$push82=, $37, $pop741
	i32.add 	$push83=, $pop514, $pop82
	i32.store	$drop=, 0($pop83), $37
	i32.const	$push515=, 68480
	i32.add 	$push516=, $1, $pop515
	i32.const	$push740=, 2
	i32.shl 	$push84=, $36, $pop740
	i32.add 	$push85=, $pop516, $pop84
	i32.store	$drop=, 0($pop85), $36
	i32.const	$push517=, 66480
	i32.add 	$push518=, $1, $pop517
	i32.const	$push739=, 2
	i32.shl 	$push86=, $35, $pop739
	i32.add 	$push87=, $pop518, $pop86
	i32.store	$drop=, 0($pop87), $35
	i32.const	$push519=, 64480
	i32.add 	$push520=, $1, $pop519
	i32.const	$push738=, 2
	i32.shl 	$push88=, $34, $pop738
	i32.add 	$push89=, $pop520, $pop88
	i32.store	$drop=, 0($pop89), $34
	i32.const	$push521=, 62480
	i32.add 	$push522=, $1, $pop521
	i32.const	$push737=, 2
	i32.shl 	$push90=, $33, $pop737
	i32.add 	$push91=, $pop522, $pop90
	i32.store	$drop=, 0($pop91), $33
	i32.const	$push523=, 60480
	i32.add 	$push524=, $1, $pop523
	i32.const	$push736=, 2
	i32.shl 	$push92=, $32, $pop736
	i32.add 	$push93=, $pop524, $pop92
	i32.store	$drop=, 0($pop93), $32
	i32.const	$push525=, 58480
	i32.add 	$push526=, $1, $pop525
	i32.const	$push735=, 2
	i32.shl 	$push94=, $31, $pop735
	i32.add 	$push95=, $pop526, $pop94
	i32.store	$drop=, 0($pop95), $31
	i32.const	$push527=, 56480
	i32.add 	$push528=, $1, $pop527
	i32.const	$push734=, 2
	i32.shl 	$push96=, $30, $pop734
	i32.add 	$push97=, $pop528, $pop96
	i32.store	$drop=, 0($pop97), $30
	i32.const	$push529=, 54480
	i32.add 	$push530=, $1, $pop529
	i32.const	$push733=, 2
	i32.shl 	$push98=, $29, $pop733
	i32.add 	$push99=, $pop530, $pop98
	i32.store	$drop=, 0($pop99), $29
	i32.const	$push531=, 52480
	i32.add 	$push532=, $1, $pop531
	i32.const	$push732=, 2
	i32.shl 	$push100=, $28, $pop732
	i32.add 	$push101=, $pop532, $pop100
	i32.store	$drop=, 0($pop101), $28
	i32.const	$push533=, 50480
	i32.add 	$push534=, $1, $pop533
	i32.const	$push731=, 2
	i32.shl 	$push102=, $27, $pop731
	i32.add 	$push103=, $pop534, $pop102
	i32.store	$drop=, 0($pop103), $27
	i32.const	$push535=, 48480
	i32.add 	$push536=, $1, $pop535
	i32.const	$push730=, 2
	i32.shl 	$push104=, $26, $pop730
	i32.add 	$push105=, $pop536, $pop104
	i32.store	$drop=, 0($pop105), $26
	i32.const	$push537=, 46480
	i32.add 	$push538=, $1, $pop537
	i32.const	$push729=, 2
	i32.shl 	$push106=, $25, $pop729
	i32.add 	$push107=, $pop538, $pop106
	i32.store	$drop=, 0($pop107), $25
	i32.const	$push539=, 44480
	i32.add 	$push540=, $1, $pop539
	i32.const	$push728=, 2
	i32.shl 	$push108=, $24, $pop728
	i32.add 	$push109=, $pop540, $pop108
	i32.store	$drop=, 0($pop109), $24
	i32.const	$push541=, 42480
	i32.add 	$push542=, $1, $pop541
	i32.const	$push727=, 2
	i32.shl 	$push110=, $23, $pop727
	i32.add 	$push111=, $pop542, $pop110
	i32.store	$drop=, 0($pop111), $23
	i32.const	$push543=, 40480
	i32.add 	$push544=, $1, $pop543
	i32.const	$push726=, 2
	i32.shl 	$push112=, $22, $pop726
	i32.add 	$push113=, $pop544, $pop112
	i32.store	$drop=, 0($pop113), $22
	i32.const	$push545=, 38480
	i32.add 	$push546=, $1, $pop545
	i32.const	$push725=, 2
	i32.shl 	$push114=, $21, $pop725
	i32.add 	$push115=, $pop546, $pop114
	i32.store	$drop=, 0($pop115), $21
	i32.const	$push547=, 36480
	i32.add 	$push548=, $1, $pop547
	i32.const	$push724=, 2
	i32.shl 	$push116=, $20, $pop724
	i32.add 	$push117=, $pop548, $pop116
	i32.store	$drop=, 0($pop117), $20
	i32.const	$push549=, 34480
	i32.add 	$push550=, $1, $pop549
	i32.const	$push723=, 2
	i32.shl 	$push118=, $19, $pop723
	i32.add 	$push119=, $pop550, $pop118
	i32.store	$drop=, 0($pop119), $19
	i32.const	$push551=, 32480
	i32.add 	$push552=, $1, $pop551
	i32.const	$push722=, 2
	i32.shl 	$push120=, $18, $pop722
	i32.add 	$push121=, $pop552, $pop120
	i32.store	$drop=, 0($pop121), $18
	i32.const	$push553=, 30480
	i32.add 	$push554=, $1, $pop553
	i32.const	$push721=, 2
	i32.shl 	$push122=, $17, $pop721
	i32.add 	$push123=, $pop554, $pop122
	i32.store	$drop=, 0($pop123), $17
	i32.const	$push555=, 28480
	i32.add 	$push556=, $1, $pop555
	i32.const	$push720=, 2
	i32.shl 	$push124=, $16, $pop720
	i32.add 	$push125=, $pop556, $pop124
	i32.store	$drop=, 0($pop125), $16
	i32.const	$push557=, 26480
	i32.add 	$push558=, $1, $pop557
	i32.const	$push719=, 2
	i32.shl 	$push126=, $15, $pop719
	i32.add 	$push127=, $pop558, $pop126
	i32.store	$drop=, 0($pop127), $15
	i32.const	$push559=, 24480
	i32.add 	$push560=, $1, $pop559
	i32.const	$push718=, 2
	i32.shl 	$push128=, $14, $pop718
	i32.add 	$push129=, $pop560, $pop128
	i32.store	$drop=, 0($pop129), $14
	i32.const	$push561=, 22480
	i32.add 	$push562=, $1, $pop561
	i32.const	$push717=, 2
	i32.shl 	$push130=, $13, $pop717
	i32.add 	$push131=, $pop562, $pop130
	i32.store	$drop=, 0($pop131), $13
	i32.const	$push563=, 20480
	i32.add 	$push564=, $1, $pop563
	i32.const	$push716=, 2
	i32.shl 	$push132=, $12, $pop716
	i32.add 	$push133=, $pop564, $pop132
	i32.store	$drop=, 0($pop133), $12
	i32.const	$push565=, 18480
	i32.add 	$push566=, $1, $pop565
	i32.const	$push715=, 2
	i32.shl 	$push134=, $11, $pop715
	i32.add 	$push135=, $pop566, $pop134
	i32.store	$drop=, 0($pop135), $11
	i32.const	$push567=, 16480
	i32.add 	$push568=, $1, $pop567
	i32.const	$push714=, 2
	i32.shl 	$push136=, $10, $pop714
	i32.add 	$push137=, $pop568, $pop136
	i32.store	$drop=, 0($pop137), $10
	i32.const	$push569=, 14480
	i32.add 	$push570=, $1, $pop569
	i32.const	$push713=, 2
	i32.shl 	$push138=, $9, $pop713
	i32.add 	$push139=, $pop570, $pop138
	i32.store	$drop=, 0($pop139), $9
	i32.const	$push571=, 12480
	i32.add 	$push572=, $1, $pop571
	i32.const	$push712=, 2
	i32.shl 	$push140=, $8, $pop712
	i32.add 	$push141=, $pop572, $pop140
	i32.store	$drop=, 0($pop141), $8
	i32.const	$push573=, 10480
	i32.add 	$push574=, $1, $pop573
	i32.const	$push711=, 2
	i32.shl 	$push142=, $7, $pop711
	i32.add 	$push143=, $pop574, $pop142
	i32.store	$drop=, 0($pop143), $7
	i32.const	$push575=, 8480
	i32.add 	$push576=, $1, $pop575
	i32.const	$push710=, 2
	i32.shl 	$push144=, $6, $pop710
	i32.add 	$push145=, $pop576, $pop144
	i32.store	$drop=, 0($pop145), $6
	i32.const	$push577=, 6480
	i32.add 	$push578=, $1, $pop577
	i32.const	$push709=, 2
	i32.shl 	$push146=, $5, $pop709
	i32.add 	$push147=, $pop578, $pop146
	i32.store	$drop=, 0($pop147), $5
	i32.const	$push579=, 4480
	i32.add 	$push580=, $1, $pop579
	i32.const	$push708=, 2
	i32.shl 	$push148=, $4, $pop708
	i32.add 	$push149=, $pop580, $pop148
	i32.store	$drop=, 0($pop149), $4
	i32.const	$push581=, 2480
	i32.add 	$push582=, $1, $pop581
	i32.const	$push707=, 2
	i32.shl 	$push150=, $3, $pop707
	i32.add 	$push151=, $pop582, $pop150
	i32.store	$drop=, 0($pop151), $3
	i32.const	$push583=, 480
	i32.add 	$push584=, $1, $pop583
	i32.const	$push706=, 2
	i32.shl 	$push152=, $2, $pop706
	i32.add 	$push153=, $pop584, $pop152
	i32.store	$drop=, 0($pop153), $2
	i32.const	$push705=, 156
	i32.add 	$push154=, $1, $pop705
	i32.const	$push585=, 480
	i32.add 	$push586=, $1, $pop585
	i32.store	$drop=, 0($pop154), $pop586
	i32.const	$push704=, 152
	i32.add 	$push155=, $1, $pop704
	i32.const	$push587=, 2480
	i32.add 	$push588=, $1, $pop587
	i32.store	$drop=, 0($pop155), $pop588
	i32.const	$push703=, 148
	i32.add 	$push156=, $1, $pop703
	i32.const	$push589=, 4480
	i32.add 	$push590=, $1, $pop589
	i32.store	$drop=, 0($pop156), $pop590
	i32.const	$push702=, 144
	i32.add 	$push157=, $1, $pop702
	i32.const	$push591=, 6480
	i32.add 	$push592=, $1, $pop591
	i32.store	$drop=, 0($pop157), $pop592
	i32.const	$push701=, 140
	i32.add 	$push158=, $1, $pop701
	i32.const	$push593=, 8480
	i32.add 	$push594=, $1, $pop593
	i32.store	$drop=, 0($pop158), $pop594
	i32.const	$push700=, 136
	i32.add 	$push159=, $1, $pop700
	i32.const	$push595=, 10480
	i32.add 	$push596=, $1, $pop595
	i32.store	$drop=, 0($pop159), $pop596
	i32.const	$push699=, 132
	i32.add 	$push160=, $1, $pop699
	i32.const	$push597=, 12480
	i32.add 	$push598=, $1, $pop597
	i32.store	$drop=, 0($pop160), $pop598
	i32.const	$push698=, 128
	i32.add 	$push161=, $1, $pop698
	i32.const	$push599=, 14480
	i32.add 	$push600=, $1, $pop599
	i32.store	$drop=, 0($pop161), $pop600
	i32.const	$push697=, 124
	i32.add 	$push162=, $1, $pop697
	i32.const	$push601=, 16480
	i32.add 	$push602=, $1, $pop601
	i32.store	$drop=, 0($pop162), $pop602
	i32.const	$push696=, 120
	i32.add 	$push163=, $1, $pop696
	i32.const	$push603=, 18480
	i32.add 	$push604=, $1, $pop603
	i32.store	$drop=, 0($pop163), $pop604
	i32.const	$push695=, 116
	i32.add 	$push164=, $1, $pop695
	i32.const	$push605=, 20480
	i32.add 	$push606=, $1, $pop605
	i32.store	$drop=, 0($pop164), $pop606
	i32.const	$push694=, 112
	i32.add 	$push165=, $1, $pop694
	i32.const	$push607=, 22480
	i32.add 	$push608=, $1, $pop607
	i32.store	$drop=, 0($pop165), $pop608
	i32.const	$push693=, 108
	i32.add 	$push166=, $1, $pop693
	i32.const	$push609=, 24480
	i32.add 	$push610=, $1, $pop609
	i32.store	$drop=, 0($pop166), $pop610
	i32.const	$push692=, 104
	i32.add 	$push167=, $1, $pop692
	i32.const	$push611=, 26480
	i32.add 	$push612=, $1, $pop611
	i32.store	$drop=, 0($pop167), $pop612
	i32.const	$push691=, 100
	i32.add 	$push168=, $1, $pop691
	i32.const	$push613=, 28480
	i32.add 	$push614=, $1, $pop613
	i32.store	$drop=, 0($pop168), $pop614
	i32.const	$push690=, 96
	i32.add 	$push169=, $1, $pop690
	i32.const	$push615=, 30480
	i32.add 	$push616=, $1, $pop615
	i32.store	$drop=, 0($pop169), $pop616
	i32.const	$push689=, 92
	i32.add 	$push170=, $1, $pop689
	i32.const	$push617=, 32480
	i32.add 	$push618=, $1, $pop617
	i32.store	$drop=, 0($pop170), $pop618
	i32.const	$push688=, 88
	i32.add 	$push171=, $1, $pop688
	i32.const	$push619=, 34480
	i32.add 	$push620=, $1, $pop619
	i32.store	$drop=, 0($pop171), $pop620
	i32.const	$push687=, 84
	i32.add 	$push172=, $1, $pop687
	i32.const	$push621=, 36480
	i32.add 	$push622=, $1, $pop621
	i32.store	$drop=, 0($pop172), $pop622
	i32.const	$push686=, 80
	i32.add 	$push173=, $1, $pop686
	i32.const	$push623=, 38480
	i32.add 	$push624=, $1, $pop623
	i32.store	$drop=, 0($pop173), $pop624
	i32.const	$push685=, 76
	i32.add 	$push174=, $1, $pop685
	i32.const	$push625=, 40480
	i32.add 	$push626=, $1, $pop625
	i32.store	$drop=, 0($pop174), $pop626
	i32.const	$push684=, 72
	i32.add 	$push175=, $1, $pop684
	i32.const	$push627=, 42480
	i32.add 	$push628=, $1, $pop627
	i32.store	$drop=, 0($pop175), $pop628
	i32.const	$push683=, 68
	i32.add 	$push176=, $1, $pop683
	i32.const	$push629=, 44480
	i32.add 	$push630=, $1, $pop629
	i32.store	$drop=, 0($pop176), $pop630
	i32.const	$push682=, 64
	i32.add 	$push177=, $1, $pop682
	i32.const	$push631=, 46480
	i32.add 	$push632=, $1, $pop631
	i32.store	$drop=, 0($pop177), $pop632
	i32.const	$push681=, 60
	i32.add 	$push178=, $1, $pop681
	i32.const	$push633=, 48480
	i32.add 	$push634=, $1, $pop633
	i32.store	$drop=, 0($pop178), $pop634
	i32.const	$push680=, 56
	i32.add 	$push179=, $1, $pop680
	i32.const	$push635=, 50480
	i32.add 	$push636=, $1, $pop635
	i32.store	$drop=, 0($pop179), $pop636
	i32.const	$push679=, 52
	i32.add 	$push180=, $1, $pop679
	i32.const	$push637=, 52480
	i32.add 	$push638=, $1, $pop637
	i32.store	$drop=, 0($pop180), $pop638
	i32.const	$push678=, 48
	i32.add 	$push181=, $1, $pop678
	i32.const	$push639=, 54480
	i32.add 	$push640=, $1, $pop639
	i32.store	$drop=, 0($pop181), $pop640
	i32.const	$push677=, 44
	i32.add 	$push182=, $1, $pop677
	i32.const	$push641=, 56480
	i32.add 	$push642=, $1, $pop641
	i32.store	$drop=, 0($pop182), $pop642
	i32.const	$push676=, 40
	i32.add 	$push183=, $1, $pop676
	i32.const	$push643=, 58480
	i32.add 	$push644=, $1, $pop643
	i32.store	$drop=, 0($pop183), $pop644
	i32.const	$push675=, 36
	i32.add 	$push184=, $1, $pop675
	i32.const	$push645=, 60480
	i32.add 	$push646=, $1, $pop645
	i32.store	$drop=, 0($pop184), $pop646
	i32.const	$push674=, 32
	i32.add 	$push185=, $1, $pop674
	i32.const	$push647=, 62480
	i32.add 	$push648=, $1, $pop647
	i32.store	$drop=, 0($pop185), $pop648
	i32.const	$push673=, 28
	i32.add 	$push186=, $1, $pop673
	i32.const	$push649=, 64480
	i32.add 	$push650=, $1, $pop649
	i32.store	$drop=, 0($pop186), $pop650
	i32.const	$push672=, 24
	i32.add 	$push187=, $1, $pop672
	i32.const	$push651=, 66480
	i32.add 	$push652=, $1, $pop651
	i32.store	$drop=, 0($pop187), $pop652
	i32.const	$push671=, 20
	i32.add 	$push188=, $1, $pop671
	i32.const	$push653=, 68480
	i32.add 	$push654=, $1, $pop653
	i32.store	$drop=, 0($pop188), $pop654
	i32.const	$push670=, 16
	i32.add 	$push189=, $1, $pop670
	i32.const	$push655=, 70480
	i32.add 	$push656=, $1, $pop655
	i32.store	$drop=, 0($pop189), $pop656
	i32.const	$push657=, 72480
	i32.add 	$push658=, $1, $pop657
	i32.store	$drop=, 12($1), $pop658
	i32.const	$push659=, 74480
	i32.add 	$push660=, $1, $pop659
	i32.store	$drop=, 8($1), $pop660
	i32.const	$push661=, 76480
	i32.add 	$push662=, $1, $pop661
	i32.store	$drop=, 4($1), $pop662
	i32.const	$push663=, 78480
	i32.add 	$push664=, $1, $pop663
	i32.store	$drop=, 0($1), $pop664
	i32.const	$push669=, 40
	call    	c@FUNCTION, $pop669, $1
	i32.const	$push668=, -1
	i32.add 	$push667=, $0, $pop668
	tee_local	$push666=, $0=, $pop667
	br_if   	0, $pop666      # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push196=, 0
	i32.const	$push194=, 80480
	i32.add 	$push195=, $1, $pop194
	i32.store	$drop=, __stack_pointer($pop196), $pop195
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.s,"ax",@progbits
	.hidden	s
	.globl	s
	.type	s,@function
s:                                      # @s
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push8=, $pop5, $pop6
	tee_local	$push7=, $2=, $pop8
	i32.store	$drop=, 12($pop7), $1
	block
	i32.eqz 	$push17=, $0
	br_if   	0, $pop17       # 0: down to label3
# BB#1:                                 # %while.body.preheader
	i32.const	$push9=, -1
	i32.add 	$0=, $0, $pop9
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.load	$push16=, 12($2)
	tee_local	$push15=, $1=, $pop16
	i32.const	$push14=, 4
	i32.add 	$push1=, $pop15, $pop14
	i32.store	$drop=, 12($2), $pop1
	i32.load	$push2=, 0($1)
	i32.store	$push0=, 0($pop2), $0
	i32.const	$push13=, -1
	i32.add 	$push12=, $pop0, $pop13
	tee_local	$push11=, $0=, $pop12
	i32.const	$push10=, -1
	i32.ne  	$push3=, $pop11, $pop10
	br_if   	0, $pop3        # 0: up to label4
.LBB1_3:                                # %while.end
	end_loop                        # label5:
	end_block                       # label3:
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	s, .Lfunc_end1-s

	.section	.text.z,"ax",@progbits
	.hidden	z
	.globl	z
	.type	z,@function
z:                                      # @z
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push11=, __stack_pointer($pop5), $pop9
	tee_local	$push10=, $3=, $pop11
	i32.store	$drop=, 12($pop10), $1
	block
	i32.eqz 	$push18=, $0
	br_if   	0, $pop18       # 0: down to label6
# BB#1:                                 # %while.body.preheader
	i32.load	$1=, 12($3)
.LBB2_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	i32.const	$push17=, 4
	i32.add 	$push0=, $1, $pop17
	i32.store	$2=, 12($3), $pop0
	i32.load	$push1=, 0($1)
	i32.const	$push16=, 0
	i32.const	$push15=, 2000
	i32.call	$drop=, memset@FUNCTION, $pop1, $pop16, $pop15
	copy_local	$1=, $2
	i32.const	$push14=, -1
	i32.add 	$push13=, $0, $pop14
	tee_local	$push12=, $0=, $pop13
	br_if   	0, $pop12       # 0: up to label7
.LBB2_3:                                # %while.end
	end_loop                        # label8:
	end_block                       # label6:
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $3, $pop6
	i32.store	$drop=, __stack_pointer($pop8), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	z, .Lfunc_end2-z

	.section	.text.c,"ax",@progbits
	.hidden	c
	.globl	c
	.type	c,@function
c:                                      # @c
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push14=, $pop8, $pop9
	i32.store	$push17=, __stack_pointer($pop10), $pop14
	tee_local	$push16=, $2=, $pop17
	i32.store	$drop=, 12($pop16), $1
	i32.const	$push1=, 2
	i32.shl 	$push2=, $0, $pop1
	i32.const	$push15=, -4
	i32.add 	$1=, $pop2, $pop15
.LBB3_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label10:
	i32.eqz 	$push25=, $0
	br_if   	2, $pop25       # 2: down to label9
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.load	$push24=, 12($2)
	tee_local	$push23=, $3=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	$drop=, 12($2), $pop3
	i32.load	$push4=, 0($3)
	i32.add 	$3=, $pop4, $1
	i32.const	$push21=, -4
	i32.add 	$push0=, $1, $pop21
	copy_local	$1=, $pop0
	i32.const	$push20=, -1
	i32.add 	$push19=, $0, $pop20
	tee_local	$push18=, $0=, $pop19
	i32.load	$push5=, 0($3)
	i32.eq  	$push6=, $pop18, $pop5
	br_if   	0, $pop6        # 0: up to label10
# BB#3:                                 # %if.then
	end_loop                        # label11:
	call    	abort@FUNCTION
	unreachable
.LBB3_4:                                # %while.end
	end_block                       # label9:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $2, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	c, .Lfunc_end3-c

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	call    	f@FUNCTION, $pop0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
	.functype	abort, void
