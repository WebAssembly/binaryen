	.text
	.file	"multi-ix.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push191=, 0
	i32.load	$push190=, __stack_pointer($pop191)
	i32.const	$push192=, 80480
	i32.sub 	$41=, $pop190, $pop192
	i32.const	$push193=, 0
	i32.store	__stack_pointer($pop193), $41
	block   	
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %for.body.lr.ph
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push197=, 320
	i32.add 	$push198=, $41, $pop197
	i32.const	$push816=, 156
	i32.add 	$push2=, $pop198, $pop816
	i32.const	$push199=, 480
	i32.add 	$push200=, $41, $pop199
	i32.store	0($pop2), $pop200
	i32.const	$push201=, 320
	i32.add 	$push202=, $41, $pop201
	i32.const	$push815=, 152
	i32.add 	$push3=, $pop202, $pop815
	i32.const	$push203=, 2480
	i32.add 	$push204=, $41, $pop203
	i32.store	0($pop3), $pop204
	i32.const	$push205=, 320
	i32.add 	$push206=, $41, $pop205
	i32.const	$push814=, 148
	i32.add 	$push4=, $pop206, $pop814
	i32.const	$push207=, 4480
	i32.add 	$push208=, $41, $pop207
	i32.store	0($pop4), $pop208
	i32.const	$push209=, 320
	i32.add 	$push210=, $41, $pop209
	i32.const	$push813=, 144
	i32.add 	$push5=, $pop210, $pop813
	i32.const	$push211=, 6480
	i32.add 	$push212=, $41, $pop211
	i32.store	0($pop5), $pop212
	i32.const	$push213=, 320
	i32.add 	$push214=, $41, $pop213
	i32.const	$push812=, 140
	i32.add 	$push6=, $pop214, $pop812
	i32.const	$push215=, 8480
	i32.add 	$push216=, $41, $pop215
	i32.store	0($pop6), $pop216
	i32.const	$push217=, 320
	i32.add 	$push218=, $41, $pop217
	i32.const	$push811=, 136
	i32.add 	$push7=, $pop218, $pop811
	i32.const	$push219=, 10480
	i32.add 	$push220=, $41, $pop219
	i32.store	0($pop7), $pop220
	i32.const	$push221=, 320
	i32.add 	$push222=, $41, $pop221
	i32.const	$push810=, 132
	i32.add 	$push8=, $pop222, $pop810
	i32.const	$push223=, 12480
	i32.add 	$push224=, $41, $pop223
	i32.store	0($pop8), $pop224
	i32.const	$push225=, 320
	i32.add 	$push226=, $41, $pop225
	i32.const	$push809=, 128
	i32.add 	$push9=, $pop226, $pop809
	i32.const	$push227=, 14480
	i32.add 	$push228=, $41, $pop227
	i32.store	0($pop9), $pop228
	i32.const	$push229=, 320
	i32.add 	$push230=, $41, $pop229
	i32.const	$push808=, 124
	i32.add 	$push10=, $pop230, $pop808
	i32.const	$push231=, 16480
	i32.add 	$push232=, $41, $pop231
	i32.store	0($pop10), $pop232
	i32.const	$push233=, 320
	i32.add 	$push234=, $41, $pop233
	i32.const	$push807=, 120
	i32.add 	$push11=, $pop234, $pop807
	i32.const	$push235=, 18480
	i32.add 	$push236=, $41, $pop235
	i32.store	0($pop11), $pop236
	i32.const	$push237=, 320
	i32.add 	$push238=, $41, $pop237
	i32.const	$push806=, 116
	i32.add 	$push12=, $pop238, $pop806
	i32.const	$push239=, 20480
	i32.add 	$push240=, $41, $pop239
	i32.store	0($pop12), $pop240
	i32.const	$push241=, 320
	i32.add 	$push242=, $41, $pop241
	i32.const	$push805=, 112
	i32.add 	$push13=, $pop242, $pop805
	i32.const	$push243=, 22480
	i32.add 	$push244=, $41, $pop243
	i32.store	0($pop13), $pop244
	i32.const	$push245=, 320
	i32.add 	$push246=, $41, $pop245
	i32.const	$push804=, 108
	i32.add 	$push14=, $pop246, $pop804
	i32.const	$push247=, 24480
	i32.add 	$push248=, $41, $pop247
	i32.store	0($pop14), $pop248
	i32.const	$push249=, 320
	i32.add 	$push250=, $41, $pop249
	i32.const	$push803=, 104
	i32.add 	$push15=, $pop250, $pop803
	i32.const	$push251=, 26480
	i32.add 	$push252=, $41, $pop251
	i32.store	0($pop15), $pop252
	i32.const	$push253=, 320
	i32.add 	$push254=, $41, $pop253
	i32.const	$push802=, 100
	i32.add 	$push16=, $pop254, $pop802
	i32.const	$push255=, 28480
	i32.add 	$push256=, $41, $pop255
	i32.store	0($pop16), $pop256
	i32.const	$push257=, 320
	i32.add 	$push258=, $41, $pop257
	i32.const	$push801=, 96
	i32.add 	$push17=, $pop258, $pop801
	i32.const	$push259=, 30480
	i32.add 	$push260=, $41, $pop259
	i32.store	0($pop17), $pop260
	i32.const	$push261=, 320
	i32.add 	$push262=, $41, $pop261
	i32.const	$push800=, 92
	i32.add 	$push18=, $pop262, $pop800
	i32.const	$push263=, 32480
	i32.add 	$push264=, $41, $pop263
	i32.store	0($pop18), $pop264
	i32.const	$push265=, 320
	i32.add 	$push266=, $41, $pop265
	i32.const	$push799=, 88
	i32.add 	$push19=, $pop266, $pop799
	i32.const	$push267=, 34480
	i32.add 	$push268=, $41, $pop267
	i32.store	0($pop19), $pop268
	i32.const	$push269=, 320
	i32.add 	$push270=, $41, $pop269
	i32.const	$push798=, 84
	i32.add 	$push20=, $pop270, $pop798
	i32.const	$push271=, 36480
	i32.add 	$push272=, $41, $pop271
	i32.store	0($pop20), $pop272
	i32.const	$push273=, 320
	i32.add 	$push274=, $41, $pop273
	i32.const	$push797=, 80
	i32.add 	$push21=, $pop274, $pop797
	i32.const	$push275=, 38480
	i32.add 	$push276=, $41, $pop275
	i32.store	0($pop21), $pop276
	i32.const	$push277=, 320
	i32.add 	$push278=, $41, $pop277
	i32.const	$push796=, 76
	i32.add 	$push22=, $pop278, $pop796
	i32.const	$push279=, 40480
	i32.add 	$push280=, $41, $pop279
	i32.store	0($pop22), $pop280
	i32.const	$push281=, 320
	i32.add 	$push282=, $41, $pop281
	i32.const	$push795=, 72
	i32.add 	$push23=, $pop282, $pop795
	i32.const	$push283=, 42480
	i32.add 	$push284=, $41, $pop283
	i32.store	0($pop23), $pop284
	i32.const	$push285=, 320
	i32.add 	$push286=, $41, $pop285
	i32.const	$push794=, 68
	i32.add 	$push24=, $pop286, $pop794
	i32.const	$push287=, 44480
	i32.add 	$push288=, $41, $pop287
	i32.store	0($pop24), $pop288
	i32.const	$push289=, 320
	i32.add 	$push290=, $41, $pop289
	i32.const	$push793=, 64
	i32.add 	$push25=, $pop290, $pop793
	i32.const	$push291=, 46480
	i32.add 	$push292=, $41, $pop291
	i32.store	0($pop25), $pop292
	i32.const	$push293=, 320
	i32.add 	$push294=, $41, $pop293
	i32.const	$push792=, 60
	i32.add 	$push26=, $pop294, $pop792
	i32.const	$push295=, 48480
	i32.add 	$push296=, $41, $pop295
	i32.store	0($pop26), $pop296
	i32.const	$push297=, 320
	i32.add 	$push298=, $41, $pop297
	i32.const	$push791=, 56
	i32.add 	$push27=, $pop298, $pop791
	i32.const	$push299=, 50480
	i32.add 	$push300=, $41, $pop299
	i32.store	0($pop27), $pop300
	i32.const	$push301=, 320
	i32.add 	$push302=, $41, $pop301
	i32.const	$push790=, 52
	i32.add 	$push28=, $pop302, $pop790
	i32.const	$push303=, 52480
	i32.add 	$push304=, $41, $pop303
	i32.store	0($pop28), $pop304
	i32.const	$push305=, 320
	i32.add 	$push306=, $41, $pop305
	i32.const	$push789=, 48
	i32.add 	$push29=, $pop306, $pop789
	i32.const	$push307=, 54480
	i32.add 	$push308=, $41, $pop307
	i32.store	0($pop29), $pop308
	i32.const	$push309=, 320
	i32.add 	$push310=, $41, $pop309
	i32.const	$push788=, 44
	i32.add 	$push30=, $pop310, $pop788
	i32.const	$push311=, 56480
	i32.add 	$push312=, $41, $pop311
	i32.store	0($pop30), $pop312
	i32.const	$push313=, 320
	i32.add 	$push314=, $41, $pop313
	i32.const	$push787=, 40
	i32.add 	$push31=, $pop314, $pop787
	i32.const	$push315=, 58480
	i32.add 	$push316=, $41, $pop315
	i32.store	0($pop31), $pop316
	i32.const	$push317=, 320
	i32.add 	$push318=, $41, $pop317
	i32.const	$push786=, 36
	i32.add 	$push32=, $pop318, $pop786
	i32.const	$push319=, 60480
	i32.add 	$push320=, $41, $pop319
	i32.store	0($pop32), $pop320
	i32.const	$push321=, 320
	i32.add 	$push322=, $41, $pop321
	i32.const	$push785=, 32
	i32.add 	$push33=, $pop322, $pop785
	i32.const	$push323=, 62480
	i32.add 	$push324=, $41, $pop323
	i32.store	0($pop33), $pop324
	i32.const	$push325=, 320
	i32.add 	$push326=, $41, $pop325
	i32.const	$push784=, 28
	i32.add 	$push34=, $pop326, $pop784
	i32.const	$push327=, 64480
	i32.add 	$push328=, $41, $pop327
	i32.store	0($pop34), $pop328
	i32.const	$push329=, 320
	i32.add 	$push330=, $41, $pop329
	i32.const	$push783=, 24
	i32.add 	$push35=, $pop330, $pop783
	i32.const	$push331=, 66480
	i32.add 	$push332=, $41, $pop331
	i32.store	0($pop35), $pop332
	i32.const	$push333=, 320
	i32.add 	$push334=, $41, $pop333
	i32.const	$push782=, 20
	i32.add 	$push36=, $pop334, $pop782
	i32.const	$push335=, 68480
	i32.add 	$push336=, $41, $pop335
	i32.store	0($pop36), $pop336
	i32.const	$push337=, 320
	i32.add 	$push338=, $41, $pop337
	i32.const	$push781=, 16
	i32.add 	$push37=, $pop338, $pop781
	i32.const	$push339=, 70480
	i32.add 	$push340=, $41, $pop339
	i32.store	0($pop37), $pop340
	i32.const	$push341=, 72480
	i32.add 	$push342=, $41, $pop341
	i32.store	332($41), $pop342
	i32.const	$push343=, 74480
	i32.add 	$push344=, $41, $pop343
	i32.store	328($41), $pop344
	i32.const	$push345=, 76480
	i32.add 	$push346=, $41, $pop345
	i32.store	324($41), $pop346
	i32.const	$push347=, 78480
	i32.add 	$push348=, $41, $pop347
	i32.store	320($41), $pop348
	i32.const	$push780=, 40
	i32.const	$push349=, 320
	i32.add 	$push350=, $41, $pop349
	call    	s@FUNCTION, $pop780, $pop350
	i32.load	$1=, 2480($41)
	i32.load	$2=, 480($41)
	i32.load	$3=, 4480($41)
	i32.load	$4=, 6480($41)
	i32.load	$5=, 8480($41)
	i32.load	$6=, 10480($41)
	i32.load	$7=, 12480($41)
	i32.load	$8=, 14480($41)
	i32.load	$9=, 16480($41)
	i32.load	$10=, 18480($41)
	i32.load	$11=, 20480($41)
	i32.load	$12=, 22480($41)
	i32.load	$13=, 24480($41)
	i32.load	$14=, 26480($41)
	i32.load	$15=, 28480($41)
	i32.load	$16=, 30480($41)
	i32.load	$17=, 32480($41)
	i32.load	$18=, 34480($41)
	i32.load	$19=, 36480($41)
	i32.load	$20=, 40480($41)
	i32.load	$21=, 38480($41)
	i32.load	$22=, 42480($41)
	i32.load	$23=, 44480($41)
	i32.load	$24=, 46480($41)
	i32.load	$25=, 48480($41)
	i32.load	$26=, 50480($41)
	i32.load	$27=, 52480($41)
	i32.load	$28=, 54480($41)
	i32.load	$29=, 56480($41)
	i32.load	$30=, 58480($41)
	i32.load	$31=, 60480($41)
	i32.load	$32=, 62480($41)
	i32.load	$33=, 64480($41)
	i32.load	$34=, 66480($41)
	i32.load	$35=, 68480($41)
	i32.load	$36=, 70480($41)
	i32.load	$37=, 72480($41)
	i32.load	$38=, 74480($41)
	i32.load	$39=, 78480($41)
	i32.load	$40=, 76480($41)
	i32.const	$push351=, 160
	i32.add 	$push352=, $41, $pop351
	i32.const	$push779=, 156
	i32.add 	$push38=, $pop352, $pop779
	i32.const	$push353=, 480
	i32.add 	$push354=, $41, $pop353
	i32.store	0($pop38), $pop354
	i32.const	$push355=, 160
	i32.add 	$push356=, $41, $pop355
	i32.const	$push778=, 152
	i32.add 	$push39=, $pop356, $pop778
	i32.const	$push357=, 2480
	i32.add 	$push358=, $41, $pop357
	i32.store	0($pop39), $pop358
	i32.const	$push359=, 160
	i32.add 	$push360=, $41, $pop359
	i32.const	$push777=, 148
	i32.add 	$push40=, $pop360, $pop777
	i32.const	$push361=, 4480
	i32.add 	$push362=, $41, $pop361
	i32.store	0($pop40), $pop362
	i32.const	$push363=, 160
	i32.add 	$push364=, $41, $pop363
	i32.const	$push776=, 144
	i32.add 	$push41=, $pop364, $pop776
	i32.const	$push365=, 6480
	i32.add 	$push366=, $41, $pop365
	i32.store	0($pop41), $pop366
	i32.const	$push367=, 160
	i32.add 	$push368=, $41, $pop367
	i32.const	$push775=, 140
	i32.add 	$push42=, $pop368, $pop775
	i32.const	$push369=, 8480
	i32.add 	$push370=, $41, $pop369
	i32.store	0($pop42), $pop370
	i32.const	$push371=, 160
	i32.add 	$push372=, $41, $pop371
	i32.const	$push774=, 136
	i32.add 	$push43=, $pop372, $pop774
	i32.const	$push373=, 10480
	i32.add 	$push374=, $41, $pop373
	i32.store	0($pop43), $pop374
	i32.const	$push375=, 160
	i32.add 	$push376=, $41, $pop375
	i32.const	$push773=, 132
	i32.add 	$push44=, $pop376, $pop773
	i32.const	$push377=, 12480
	i32.add 	$push378=, $41, $pop377
	i32.store	0($pop44), $pop378
	i32.const	$push379=, 160
	i32.add 	$push380=, $41, $pop379
	i32.const	$push772=, 128
	i32.add 	$push45=, $pop380, $pop772
	i32.const	$push381=, 14480
	i32.add 	$push382=, $41, $pop381
	i32.store	0($pop45), $pop382
	i32.const	$push383=, 160
	i32.add 	$push384=, $41, $pop383
	i32.const	$push771=, 124
	i32.add 	$push46=, $pop384, $pop771
	i32.const	$push385=, 16480
	i32.add 	$push386=, $41, $pop385
	i32.store	0($pop46), $pop386
	i32.const	$push387=, 160
	i32.add 	$push388=, $41, $pop387
	i32.const	$push770=, 120
	i32.add 	$push47=, $pop388, $pop770
	i32.const	$push389=, 18480
	i32.add 	$push390=, $41, $pop389
	i32.store	0($pop47), $pop390
	i32.const	$push391=, 160
	i32.add 	$push392=, $41, $pop391
	i32.const	$push769=, 116
	i32.add 	$push48=, $pop392, $pop769
	i32.const	$push393=, 20480
	i32.add 	$push394=, $41, $pop393
	i32.store	0($pop48), $pop394
	i32.const	$push395=, 160
	i32.add 	$push396=, $41, $pop395
	i32.const	$push768=, 112
	i32.add 	$push49=, $pop396, $pop768
	i32.const	$push397=, 22480
	i32.add 	$push398=, $41, $pop397
	i32.store	0($pop49), $pop398
	i32.const	$push399=, 160
	i32.add 	$push400=, $41, $pop399
	i32.const	$push767=, 108
	i32.add 	$push50=, $pop400, $pop767
	i32.const	$push401=, 24480
	i32.add 	$push402=, $41, $pop401
	i32.store	0($pop50), $pop402
	i32.const	$push403=, 160
	i32.add 	$push404=, $41, $pop403
	i32.const	$push766=, 104
	i32.add 	$push51=, $pop404, $pop766
	i32.const	$push405=, 26480
	i32.add 	$push406=, $41, $pop405
	i32.store	0($pop51), $pop406
	i32.const	$push407=, 160
	i32.add 	$push408=, $41, $pop407
	i32.const	$push765=, 100
	i32.add 	$push52=, $pop408, $pop765
	i32.const	$push409=, 28480
	i32.add 	$push410=, $41, $pop409
	i32.store	0($pop52), $pop410
	i32.const	$push411=, 160
	i32.add 	$push412=, $41, $pop411
	i32.const	$push764=, 96
	i32.add 	$push53=, $pop412, $pop764
	i32.const	$push413=, 30480
	i32.add 	$push414=, $41, $pop413
	i32.store	0($pop53), $pop414
	i32.const	$push415=, 160
	i32.add 	$push416=, $41, $pop415
	i32.const	$push763=, 92
	i32.add 	$push54=, $pop416, $pop763
	i32.const	$push417=, 32480
	i32.add 	$push418=, $41, $pop417
	i32.store	0($pop54), $pop418
	i32.const	$push419=, 160
	i32.add 	$push420=, $41, $pop419
	i32.const	$push762=, 88
	i32.add 	$push55=, $pop420, $pop762
	i32.const	$push421=, 34480
	i32.add 	$push422=, $41, $pop421
	i32.store	0($pop55), $pop422
	i32.const	$push423=, 160
	i32.add 	$push424=, $41, $pop423
	i32.const	$push761=, 84
	i32.add 	$push56=, $pop424, $pop761
	i32.const	$push425=, 36480
	i32.add 	$push426=, $41, $pop425
	i32.store	0($pop56), $pop426
	i32.const	$push427=, 160
	i32.add 	$push428=, $41, $pop427
	i32.const	$push760=, 80
	i32.add 	$push57=, $pop428, $pop760
	i32.const	$push429=, 38480
	i32.add 	$push430=, $41, $pop429
	i32.store	0($pop57), $pop430
	i32.const	$push431=, 160
	i32.add 	$push432=, $41, $pop431
	i32.const	$push759=, 76
	i32.add 	$push58=, $pop432, $pop759
	i32.const	$push433=, 40480
	i32.add 	$push434=, $41, $pop433
	i32.store	0($pop58), $pop434
	i32.const	$push435=, 160
	i32.add 	$push436=, $41, $pop435
	i32.const	$push758=, 72
	i32.add 	$push59=, $pop436, $pop758
	i32.const	$push437=, 42480
	i32.add 	$push438=, $41, $pop437
	i32.store	0($pop59), $pop438
	i32.const	$push439=, 160
	i32.add 	$push440=, $41, $pop439
	i32.const	$push757=, 68
	i32.add 	$push60=, $pop440, $pop757
	i32.const	$push441=, 44480
	i32.add 	$push442=, $41, $pop441
	i32.store	0($pop60), $pop442
	i32.const	$push443=, 160
	i32.add 	$push444=, $41, $pop443
	i32.const	$push756=, 64
	i32.add 	$push61=, $pop444, $pop756
	i32.const	$push445=, 46480
	i32.add 	$push446=, $41, $pop445
	i32.store	0($pop61), $pop446
	i32.const	$push447=, 160
	i32.add 	$push448=, $41, $pop447
	i32.const	$push755=, 60
	i32.add 	$push62=, $pop448, $pop755
	i32.const	$push449=, 48480
	i32.add 	$push450=, $41, $pop449
	i32.store	0($pop62), $pop450
	i32.const	$push451=, 160
	i32.add 	$push452=, $41, $pop451
	i32.const	$push754=, 56
	i32.add 	$push63=, $pop452, $pop754
	i32.const	$push453=, 50480
	i32.add 	$push454=, $41, $pop453
	i32.store	0($pop63), $pop454
	i32.const	$push455=, 160
	i32.add 	$push456=, $41, $pop455
	i32.const	$push753=, 52
	i32.add 	$push64=, $pop456, $pop753
	i32.const	$push457=, 52480
	i32.add 	$push458=, $41, $pop457
	i32.store	0($pop64), $pop458
	i32.const	$push459=, 160
	i32.add 	$push460=, $41, $pop459
	i32.const	$push752=, 48
	i32.add 	$push65=, $pop460, $pop752
	i32.const	$push461=, 54480
	i32.add 	$push462=, $41, $pop461
	i32.store	0($pop65), $pop462
	i32.const	$push463=, 160
	i32.add 	$push464=, $41, $pop463
	i32.const	$push751=, 44
	i32.add 	$push66=, $pop464, $pop751
	i32.const	$push465=, 56480
	i32.add 	$push466=, $41, $pop465
	i32.store	0($pop66), $pop466
	i32.const	$push467=, 160
	i32.add 	$push468=, $41, $pop467
	i32.const	$push750=, 40
	i32.add 	$push67=, $pop468, $pop750
	i32.const	$push469=, 58480
	i32.add 	$push470=, $41, $pop469
	i32.store	0($pop67), $pop470
	i32.const	$push471=, 160
	i32.add 	$push472=, $41, $pop471
	i32.const	$push749=, 36
	i32.add 	$push68=, $pop472, $pop749
	i32.const	$push473=, 60480
	i32.add 	$push474=, $41, $pop473
	i32.store	0($pop68), $pop474
	i32.const	$push475=, 160
	i32.add 	$push476=, $41, $pop475
	i32.const	$push748=, 32
	i32.add 	$push69=, $pop476, $pop748
	i32.const	$push477=, 62480
	i32.add 	$push478=, $41, $pop477
	i32.store	0($pop69), $pop478
	i32.const	$push479=, 160
	i32.add 	$push480=, $41, $pop479
	i32.const	$push747=, 28
	i32.add 	$push70=, $pop480, $pop747
	i32.const	$push481=, 64480
	i32.add 	$push482=, $41, $pop481
	i32.store	0($pop70), $pop482
	i32.const	$push483=, 160
	i32.add 	$push484=, $41, $pop483
	i32.const	$push746=, 24
	i32.add 	$push71=, $pop484, $pop746
	i32.const	$push485=, 66480
	i32.add 	$push486=, $41, $pop485
	i32.store	0($pop71), $pop486
	i32.const	$push487=, 160
	i32.add 	$push488=, $41, $pop487
	i32.const	$push745=, 20
	i32.add 	$push72=, $pop488, $pop745
	i32.const	$push489=, 68480
	i32.add 	$push490=, $41, $pop489
	i32.store	0($pop72), $pop490
	i32.const	$push491=, 160
	i32.add 	$push492=, $41, $pop491
	i32.const	$push744=, 16
	i32.add 	$push73=, $pop492, $pop744
	i32.const	$push493=, 70480
	i32.add 	$push494=, $41, $pop493
	i32.store	0($pop73), $pop494
	i32.const	$push495=, 72480
	i32.add 	$push496=, $41, $pop495
	i32.store	172($41), $pop496
	i32.const	$push497=, 74480
	i32.add 	$push498=, $41, $pop497
	i32.store	168($41), $pop498
	i32.const	$push499=, 76480
	i32.add 	$push500=, $41, $pop499
	i32.store	164($41), $pop500
	i32.const	$push501=, 78480
	i32.add 	$push502=, $41, $pop501
	i32.store	160($41), $pop502
	i32.const	$push743=, 40
	i32.const	$push503=, 160
	i32.add 	$push504=, $41, $pop503
	call    	z@FUNCTION, $pop743, $pop504
	i32.const	$push505=, 76480
	i32.add 	$push506=, $41, $pop505
	i32.const	$push742=, 2
	i32.shl 	$push74=, $40, $pop742
	i32.add 	$push75=, $pop506, $pop74
	i32.store	0($pop75), $40
	i32.const	$push507=, 78480
	i32.add 	$push508=, $41, $pop507
	i32.const	$push741=, 2
	i32.shl 	$push76=, $39, $pop741
	i32.add 	$push77=, $pop508, $pop76
	i32.store	0($pop77), $39
	i32.const	$push509=, 74480
	i32.add 	$push510=, $41, $pop509
	i32.const	$push740=, 2
	i32.shl 	$push78=, $38, $pop740
	i32.add 	$push79=, $pop510, $pop78
	i32.store	0($pop79), $38
	i32.const	$push511=, 72480
	i32.add 	$push512=, $41, $pop511
	i32.const	$push739=, 2
	i32.shl 	$push80=, $37, $pop739
	i32.add 	$push81=, $pop512, $pop80
	i32.store	0($pop81), $37
	i32.const	$push513=, 70480
	i32.add 	$push514=, $41, $pop513
	i32.const	$push738=, 2
	i32.shl 	$push82=, $36, $pop738
	i32.add 	$push83=, $pop514, $pop82
	i32.store	0($pop83), $36
	i32.const	$push515=, 68480
	i32.add 	$push516=, $41, $pop515
	i32.const	$push737=, 2
	i32.shl 	$push84=, $35, $pop737
	i32.add 	$push85=, $pop516, $pop84
	i32.store	0($pop85), $35
	i32.const	$push517=, 66480
	i32.add 	$push518=, $41, $pop517
	i32.const	$push736=, 2
	i32.shl 	$push86=, $34, $pop736
	i32.add 	$push87=, $pop518, $pop86
	i32.store	0($pop87), $34
	i32.const	$push519=, 64480
	i32.add 	$push520=, $41, $pop519
	i32.const	$push735=, 2
	i32.shl 	$push88=, $33, $pop735
	i32.add 	$push89=, $pop520, $pop88
	i32.store	0($pop89), $33
	i32.const	$push521=, 62480
	i32.add 	$push522=, $41, $pop521
	i32.const	$push734=, 2
	i32.shl 	$push90=, $32, $pop734
	i32.add 	$push91=, $pop522, $pop90
	i32.store	0($pop91), $32
	i32.const	$push523=, 60480
	i32.add 	$push524=, $41, $pop523
	i32.const	$push733=, 2
	i32.shl 	$push92=, $31, $pop733
	i32.add 	$push93=, $pop524, $pop92
	i32.store	0($pop93), $31
	i32.const	$push525=, 58480
	i32.add 	$push526=, $41, $pop525
	i32.const	$push732=, 2
	i32.shl 	$push94=, $30, $pop732
	i32.add 	$push95=, $pop526, $pop94
	i32.store	0($pop95), $30
	i32.const	$push527=, 56480
	i32.add 	$push528=, $41, $pop527
	i32.const	$push731=, 2
	i32.shl 	$push96=, $29, $pop731
	i32.add 	$push97=, $pop528, $pop96
	i32.store	0($pop97), $29
	i32.const	$push529=, 54480
	i32.add 	$push530=, $41, $pop529
	i32.const	$push730=, 2
	i32.shl 	$push98=, $28, $pop730
	i32.add 	$push99=, $pop530, $pop98
	i32.store	0($pop99), $28
	i32.const	$push531=, 52480
	i32.add 	$push532=, $41, $pop531
	i32.const	$push729=, 2
	i32.shl 	$push100=, $27, $pop729
	i32.add 	$push101=, $pop532, $pop100
	i32.store	0($pop101), $27
	i32.const	$push533=, 50480
	i32.add 	$push534=, $41, $pop533
	i32.const	$push728=, 2
	i32.shl 	$push102=, $26, $pop728
	i32.add 	$push103=, $pop534, $pop102
	i32.store	0($pop103), $26
	i32.const	$push535=, 48480
	i32.add 	$push536=, $41, $pop535
	i32.const	$push727=, 2
	i32.shl 	$push104=, $25, $pop727
	i32.add 	$push105=, $pop536, $pop104
	i32.store	0($pop105), $25
	i32.const	$push537=, 46480
	i32.add 	$push538=, $41, $pop537
	i32.const	$push726=, 2
	i32.shl 	$push106=, $24, $pop726
	i32.add 	$push107=, $pop538, $pop106
	i32.store	0($pop107), $24
	i32.const	$push539=, 44480
	i32.add 	$push540=, $41, $pop539
	i32.const	$push725=, 2
	i32.shl 	$push108=, $23, $pop725
	i32.add 	$push109=, $pop540, $pop108
	i32.store	0($pop109), $23
	i32.const	$push541=, 42480
	i32.add 	$push542=, $41, $pop541
	i32.const	$push724=, 2
	i32.shl 	$push110=, $22, $pop724
	i32.add 	$push111=, $pop542, $pop110
	i32.store	0($pop111), $22
	i32.const	$push543=, 38480
	i32.add 	$push544=, $41, $pop543
	i32.const	$push723=, 2
	i32.shl 	$push112=, $21, $pop723
	i32.add 	$push113=, $pop544, $pop112
	i32.store	0($pop113), $21
	i32.const	$push545=, 40480
	i32.add 	$push546=, $41, $pop545
	i32.const	$push722=, 2
	i32.shl 	$push114=, $20, $pop722
	i32.add 	$push115=, $pop546, $pop114
	i32.store	0($pop115), $20
	i32.const	$push547=, 36480
	i32.add 	$push548=, $41, $pop547
	i32.const	$push721=, 2
	i32.shl 	$push116=, $19, $pop721
	i32.add 	$push117=, $pop548, $pop116
	i32.store	0($pop117), $19
	i32.const	$push549=, 34480
	i32.add 	$push550=, $41, $pop549
	i32.const	$push720=, 2
	i32.shl 	$push118=, $18, $pop720
	i32.add 	$push119=, $pop550, $pop118
	i32.store	0($pop119), $18
	i32.const	$push551=, 32480
	i32.add 	$push552=, $41, $pop551
	i32.const	$push719=, 2
	i32.shl 	$push120=, $17, $pop719
	i32.add 	$push121=, $pop552, $pop120
	i32.store	0($pop121), $17
	i32.const	$push553=, 30480
	i32.add 	$push554=, $41, $pop553
	i32.const	$push718=, 2
	i32.shl 	$push122=, $16, $pop718
	i32.add 	$push123=, $pop554, $pop122
	i32.store	0($pop123), $16
	i32.const	$push555=, 28480
	i32.add 	$push556=, $41, $pop555
	i32.const	$push717=, 2
	i32.shl 	$push124=, $15, $pop717
	i32.add 	$push125=, $pop556, $pop124
	i32.store	0($pop125), $15
	i32.const	$push557=, 26480
	i32.add 	$push558=, $41, $pop557
	i32.const	$push716=, 2
	i32.shl 	$push126=, $14, $pop716
	i32.add 	$push127=, $pop558, $pop126
	i32.store	0($pop127), $14
	i32.const	$push559=, 24480
	i32.add 	$push560=, $41, $pop559
	i32.const	$push715=, 2
	i32.shl 	$push128=, $13, $pop715
	i32.add 	$push129=, $pop560, $pop128
	i32.store	0($pop129), $13
	i32.const	$push561=, 22480
	i32.add 	$push562=, $41, $pop561
	i32.const	$push714=, 2
	i32.shl 	$push130=, $12, $pop714
	i32.add 	$push131=, $pop562, $pop130
	i32.store	0($pop131), $12
	i32.const	$push563=, 20480
	i32.add 	$push564=, $41, $pop563
	i32.const	$push713=, 2
	i32.shl 	$push132=, $11, $pop713
	i32.add 	$push133=, $pop564, $pop132
	i32.store	0($pop133), $11
	i32.const	$push565=, 18480
	i32.add 	$push566=, $41, $pop565
	i32.const	$push712=, 2
	i32.shl 	$push134=, $10, $pop712
	i32.add 	$push135=, $pop566, $pop134
	i32.store	0($pop135), $10
	i32.const	$push567=, 16480
	i32.add 	$push568=, $41, $pop567
	i32.const	$push711=, 2
	i32.shl 	$push136=, $9, $pop711
	i32.add 	$push137=, $pop568, $pop136
	i32.store	0($pop137), $9
	i32.const	$push569=, 14480
	i32.add 	$push570=, $41, $pop569
	i32.const	$push710=, 2
	i32.shl 	$push138=, $8, $pop710
	i32.add 	$push139=, $pop570, $pop138
	i32.store	0($pop139), $8
	i32.const	$push571=, 12480
	i32.add 	$push572=, $41, $pop571
	i32.const	$push709=, 2
	i32.shl 	$push140=, $7, $pop709
	i32.add 	$push141=, $pop572, $pop140
	i32.store	0($pop141), $7
	i32.const	$push573=, 10480
	i32.add 	$push574=, $41, $pop573
	i32.const	$push708=, 2
	i32.shl 	$push142=, $6, $pop708
	i32.add 	$push143=, $pop574, $pop142
	i32.store	0($pop143), $6
	i32.const	$push575=, 8480
	i32.add 	$push576=, $41, $pop575
	i32.const	$push707=, 2
	i32.shl 	$push144=, $5, $pop707
	i32.add 	$push145=, $pop576, $pop144
	i32.store	0($pop145), $5
	i32.const	$push577=, 6480
	i32.add 	$push578=, $41, $pop577
	i32.const	$push706=, 2
	i32.shl 	$push146=, $4, $pop706
	i32.add 	$push147=, $pop578, $pop146
	i32.store	0($pop147), $4
	i32.const	$push579=, 4480
	i32.add 	$push580=, $41, $pop579
	i32.const	$push705=, 2
	i32.shl 	$push148=, $3, $pop705
	i32.add 	$push149=, $pop580, $pop148
	i32.store	0($pop149), $3
	i32.const	$push581=, 480
	i32.add 	$push582=, $41, $pop581
	i32.const	$push704=, 2
	i32.shl 	$push150=, $2, $pop704
	i32.add 	$push151=, $pop582, $pop150
	i32.store	0($pop151), $2
	i32.const	$push583=, 2480
	i32.add 	$push584=, $41, $pop583
	i32.const	$push703=, 2
	i32.shl 	$push152=, $1, $pop703
	i32.add 	$push153=, $pop584, $pop152
	i32.store	0($pop153), $1
	i32.const	$push702=, 156
	i32.add 	$push154=, $41, $pop702
	i32.const	$push585=, 480
	i32.add 	$push586=, $41, $pop585
	i32.store	0($pop154), $pop586
	i32.const	$push701=, 152
	i32.add 	$push155=, $41, $pop701
	i32.const	$push587=, 2480
	i32.add 	$push588=, $41, $pop587
	i32.store	0($pop155), $pop588
	i32.const	$push700=, 148
	i32.add 	$push156=, $41, $pop700
	i32.const	$push589=, 4480
	i32.add 	$push590=, $41, $pop589
	i32.store	0($pop156), $pop590
	i32.const	$push699=, 144
	i32.add 	$push157=, $41, $pop699
	i32.const	$push591=, 6480
	i32.add 	$push592=, $41, $pop591
	i32.store	0($pop157), $pop592
	i32.const	$push698=, 140
	i32.add 	$push158=, $41, $pop698
	i32.const	$push593=, 8480
	i32.add 	$push594=, $41, $pop593
	i32.store	0($pop158), $pop594
	i32.const	$push697=, 136
	i32.add 	$push159=, $41, $pop697
	i32.const	$push595=, 10480
	i32.add 	$push596=, $41, $pop595
	i32.store	0($pop159), $pop596
	i32.const	$push696=, 132
	i32.add 	$push160=, $41, $pop696
	i32.const	$push597=, 12480
	i32.add 	$push598=, $41, $pop597
	i32.store	0($pop160), $pop598
	i32.const	$push695=, 128
	i32.add 	$push161=, $41, $pop695
	i32.const	$push599=, 14480
	i32.add 	$push600=, $41, $pop599
	i32.store	0($pop161), $pop600
	i32.const	$push694=, 124
	i32.add 	$push162=, $41, $pop694
	i32.const	$push601=, 16480
	i32.add 	$push602=, $41, $pop601
	i32.store	0($pop162), $pop602
	i32.const	$push693=, 120
	i32.add 	$push163=, $41, $pop693
	i32.const	$push603=, 18480
	i32.add 	$push604=, $41, $pop603
	i32.store	0($pop163), $pop604
	i32.const	$push692=, 116
	i32.add 	$push164=, $41, $pop692
	i32.const	$push605=, 20480
	i32.add 	$push606=, $41, $pop605
	i32.store	0($pop164), $pop606
	i32.const	$push691=, 112
	i32.add 	$push165=, $41, $pop691
	i32.const	$push607=, 22480
	i32.add 	$push608=, $41, $pop607
	i32.store	0($pop165), $pop608
	i32.const	$push690=, 108
	i32.add 	$push166=, $41, $pop690
	i32.const	$push609=, 24480
	i32.add 	$push610=, $41, $pop609
	i32.store	0($pop166), $pop610
	i32.const	$push689=, 104
	i32.add 	$push167=, $41, $pop689
	i32.const	$push611=, 26480
	i32.add 	$push612=, $41, $pop611
	i32.store	0($pop167), $pop612
	i32.const	$push688=, 100
	i32.add 	$push168=, $41, $pop688
	i32.const	$push613=, 28480
	i32.add 	$push614=, $41, $pop613
	i32.store	0($pop168), $pop614
	i32.const	$push687=, 96
	i32.add 	$push169=, $41, $pop687
	i32.const	$push615=, 30480
	i32.add 	$push616=, $41, $pop615
	i32.store	0($pop169), $pop616
	i32.const	$push686=, 92
	i32.add 	$push170=, $41, $pop686
	i32.const	$push617=, 32480
	i32.add 	$push618=, $41, $pop617
	i32.store	0($pop170), $pop618
	i32.const	$push685=, 88
	i32.add 	$push171=, $41, $pop685
	i32.const	$push619=, 34480
	i32.add 	$push620=, $41, $pop619
	i32.store	0($pop171), $pop620
	i32.const	$push684=, 84
	i32.add 	$push172=, $41, $pop684
	i32.const	$push621=, 36480
	i32.add 	$push622=, $41, $pop621
	i32.store	0($pop172), $pop622
	i32.const	$push683=, 80
	i32.add 	$push173=, $41, $pop683
	i32.const	$push623=, 38480
	i32.add 	$push624=, $41, $pop623
	i32.store	0($pop173), $pop624
	i32.const	$push682=, 76
	i32.add 	$push174=, $41, $pop682
	i32.const	$push625=, 40480
	i32.add 	$push626=, $41, $pop625
	i32.store	0($pop174), $pop626
	i32.const	$push681=, 72
	i32.add 	$push175=, $41, $pop681
	i32.const	$push627=, 42480
	i32.add 	$push628=, $41, $pop627
	i32.store	0($pop175), $pop628
	i32.const	$push680=, 68
	i32.add 	$push176=, $41, $pop680
	i32.const	$push629=, 44480
	i32.add 	$push630=, $41, $pop629
	i32.store	0($pop176), $pop630
	i32.const	$push679=, 64
	i32.add 	$push177=, $41, $pop679
	i32.const	$push631=, 46480
	i32.add 	$push632=, $41, $pop631
	i32.store	0($pop177), $pop632
	i32.const	$push678=, 60
	i32.add 	$push178=, $41, $pop678
	i32.const	$push633=, 48480
	i32.add 	$push634=, $41, $pop633
	i32.store	0($pop178), $pop634
	i32.const	$push677=, 56
	i32.add 	$push179=, $41, $pop677
	i32.const	$push635=, 50480
	i32.add 	$push636=, $41, $pop635
	i32.store	0($pop179), $pop636
	i32.const	$push676=, 52
	i32.add 	$push180=, $41, $pop676
	i32.const	$push637=, 52480
	i32.add 	$push638=, $41, $pop637
	i32.store	0($pop180), $pop638
	i32.const	$push675=, 48
	i32.add 	$push181=, $41, $pop675
	i32.const	$push639=, 54480
	i32.add 	$push640=, $41, $pop639
	i32.store	0($pop181), $pop640
	i32.const	$push674=, 44
	i32.add 	$push182=, $41, $pop674
	i32.const	$push641=, 56480
	i32.add 	$push642=, $41, $pop641
	i32.store	0($pop182), $pop642
	i32.const	$push673=, 40
	i32.add 	$push183=, $41, $pop673
	i32.const	$push643=, 58480
	i32.add 	$push644=, $41, $pop643
	i32.store	0($pop183), $pop644
	i32.const	$push672=, 36
	i32.add 	$push184=, $41, $pop672
	i32.const	$push645=, 60480
	i32.add 	$push646=, $41, $pop645
	i32.store	0($pop184), $pop646
	i32.const	$push671=, 32
	i32.add 	$push185=, $41, $pop671
	i32.const	$push647=, 62480
	i32.add 	$push648=, $41, $pop647
	i32.store	0($pop185), $pop648
	i32.const	$push670=, 28
	i32.add 	$push186=, $41, $pop670
	i32.const	$push649=, 64480
	i32.add 	$push650=, $41, $pop649
	i32.store	0($pop186), $pop650
	i32.const	$push669=, 24
	i32.add 	$push187=, $41, $pop669
	i32.const	$push651=, 66480
	i32.add 	$push652=, $41, $pop651
	i32.store	0($pop187), $pop652
	i32.const	$push668=, 20
	i32.add 	$push188=, $41, $pop668
	i32.const	$push653=, 68480
	i32.add 	$push654=, $41, $pop653
	i32.store	0($pop188), $pop654
	i32.const	$push667=, 16
	i32.add 	$push189=, $41, $pop667
	i32.const	$push655=, 70480
	i32.add 	$push656=, $41, $pop655
	i32.store	0($pop189), $pop656
	i32.const	$push657=, 72480
	i32.add 	$push658=, $41, $pop657
	i32.store	12($41), $pop658
	i32.const	$push659=, 74480
	i32.add 	$push660=, $41, $pop659
	i32.store	8($41), $pop660
	i32.const	$push661=, 76480
	i32.add 	$push662=, $41, $pop661
	i32.store	4($41), $pop662
	i32.const	$push663=, 78480
	i32.add 	$push664=, $41, $pop663
	i32.store	0($41), $pop664
	i32.const	$push666=, 40
	call    	c@FUNCTION, $pop666, $41
	i32.const	$push665=, -1
	i32.add 	$0=, $0, $pop665
	br_if   	0, $0           # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop
	end_block                       # label0:
	i32.const	$push196=, 0
	i32.const	$push194=, 80480
	i32.add 	$push195=, $41, $pop194
	i32.store	__stack_pointer($pop196), $pop195
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.s,"ax",@progbits
	.hidden	s                       # -- Begin function s
	.globl	s
	.type	s,@function
s:                                      # @s
	.param  	i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 16
	i32.sub 	$2=, $pop3, $pop5
	i32.store	12($2), $1
	block   	
	i32.eqz 	$push10=, $0
	br_if   	0, $pop10       # 0: down to label2
# %bb.1:                                # %while.body.preheader
	i32.const	$push6=, -1
	i32.add 	$0=, $0, $pop6
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.load	$1=, 12($2)
	i32.const	$push9=, 4
	i32.add 	$push0=, $1, $pop9
	i32.store	12($2), $pop0
	i32.load	$push1=, 0($1)
	i32.store	0($pop1), $0
	i32.const	$push8=, -1
	i32.add 	$0=, $0, $pop8
	i32.const	$push7=, -1
	i32.ne  	$push2=, $0, $pop7
	br_if   	0, $pop2        # 0: up to label3
.LBB1_3:                                # %while.end
	end_loop
	end_block                       # label2:
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	s, .Lfunc_end1-s
                                        # -- End function
	.section	.text.z,"ax",@progbits
	.hidden	z                       # -- Begin function z
	.globl	z
	.type	z,@function
z:                                      # @z
	.param  	i32, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push2=, 0
	i32.load	$push1=, __stack_pointer($pop2)
	i32.const	$push3=, 16
	i32.sub 	$3=, $pop1, $pop3
	i32.const	$push4=, 0
	i32.store	__stack_pointer($pop4), $3
	i32.store	12($3), $1
	block   	
	i32.eqz 	$push12=, $0
	br_if   	0, $pop12       # 0: down to label4
# %bb.1:                                # %while.body.lr.ph
	i32.load	$1=, 12($3)
.LBB2_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	i32.const	$push11=, 4
	i32.add 	$2=, $1, $pop11
	i32.store	12($3), $2
	i32.load	$push0=, 0($1)
	i32.const	$push10=, 0
	i32.const	$push9=, 2000
	i32.call	$drop=, memset@FUNCTION, $pop0, $pop10, $pop9
	i32.const	$push8=, -1
	i32.add 	$0=, $0, $pop8
	copy_local	$1=, $2
	br_if   	0, $0           # 0: up to label5
.LBB2_3:                                # %while.end
	end_loop
	end_block                       # label4:
	i32.const	$push7=, 0
	i32.const	$push5=, 16
	i32.add 	$push6=, $3, $pop5
	i32.store	__stack_pointer($pop7), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	z, .Lfunc_end2-z
                                        # -- End function
	.section	.text.c,"ax",@progbits
	.hidden	c                       # -- Begin function c
	.globl	c
	.type	c,@function
c:                                      # @c
	.param  	i32, i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push8=, 0
	i32.load	$push7=, __stack_pointer($pop8)
	i32.const	$push9=, 16
	i32.sub 	$4=, $pop7, $pop9
	i32.const	$push10=, 0
	i32.store	__stack_pointer($pop10), $4
	i32.store	12($4), $1
	block   	
	block   	
	i32.eqz 	$push20=, $0
	br_if   	0, $pop20       # 0: down to label7
# %bb.1:                                # %while.body.lr.ph
	i32.const	$push15=, -1
	i32.add 	$1=, $0, $pop15
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push14=, -4
	i32.add 	$0=, $pop1, $pop14
	i32.load	$3=, 12($4)
.LBB3_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label8:
	i32.const	$push16=, 4
	i32.add 	$2=, $3, $pop16
	i32.store	12($4), $2
	i32.load	$push2=, 0($3)
	i32.add 	$push3=, $pop2, $0
	i32.load	$push4=, 0($pop3)
	i32.ne  	$push5=, $1, $pop4
	br_if   	2, $pop5        # 2: down to label6
# %bb.3:                                # %while.cond
                                        #   in Loop: Header=BB3_2 Depth=1
	i32.const	$push19=, -4
	i32.add 	$0=, $0, $pop19
	i32.const	$push18=, -1
	i32.add 	$1=, $1, $pop18
	copy_local	$3=, $2
	i32.const	$push17=, -1
	i32.ne  	$push6=, $1, $pop17
	br_if   	0, $pop6        # 0: up to label8
.LBB3_4:                                # %while.end
	end_loop
	end_block                       # label7:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $4, $pop11
	i32.store	__stack_pointer($pop13), $pop12
	return
.LBB3_5:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	c, .Lfunc_end3-c
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
	call    	f@FUNCTION, $pop0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
	.functype	abort, void
