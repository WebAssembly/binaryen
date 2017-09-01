	.text
	.file	"scal-to-vec1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push2=, 0
	i32.load	$push317=, one($pop2)
	tee_local	$push316=, $2=, $pop317
	i32.const	$push3=, 16
	i32.shl 	$push315=, $pop316, $pop3
	tee_local	$push314=, $3=, $pop315
	i32.const	$push313=, 16
	i32.shr_s	$push312=, $pop314, $pop313
	tee_local	$push311=, $4=, $pop312
	i32.const	$push310=, 2
	i32.add 	$push7=, $pop311, $pop310
	i32.const	$push4=, 131072
	i32.add 	$push5=, $3, $pop4
	i32.const	$push309=, 16
	i32.shr_s	$push6=, $pop5, $pop309
	i32.ne  	$push8=, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push319=, 3
	i32.const	$push318=, 3
	i32.ne  	$push9=, $pop319, $pop318
	br_if   	0, $pop9        # 0: down to label0
# BB#2:                                 # %entry
	i32.const	$push321=, 4
	i32.const	$push320=, 4
	i32.ne  	$push10=, $pop321, $pop320
	br_if   	0, $pop10       # 0: down to label0
# BB#3:                                 # %entry
	i32.const	$push323=, 5
	i32.const	$push322=, 5
	i32.ne  	$push11=, $pop323, $pop322
	br_if   	0, $pop11       # 0: down to label0
# BB#4:                                 # %entry
	i32.const	$push325=, 6
	i32.const	$push324=, 6
	i32.ne  	$push12=, $pop325, $pop324
	br_if   	0, $pop12       # 0: down to label0
# BB#5:                                 # %entry
	i32.const	$push327=, 7
	i32.const	$push326=, 7
	i32.ne  	$push13=, $pop327, $pop326
	br_if   	0, $pop13       # 0: down to label0
# BB#6:                                 # %entry
	i32.const	$push0=, 8
	i32.const	$push328=, 8
	i32.ne  	$push14=, $pop0, $pop328
	br_if   	0, $pop14       # 0: down to label0
# BB#7:                                 # %entry
	i32.const	$push1=, 9
	i32.const	$push329=, 9
	i32.ne  	$push15=, $pop1, $pop329
	br_if   	0, $pop15       # 0: down to label0
# BB#8:                                 # %for.cond.7
	i32.const	$push332=, 2
	i32.sub 	$push23=, $pop332, $4
	i32.const	$push331=, 2
	i32.sub 	$push24=, $pop331, $2
	i32.const	$push25=, 16
	i32.shl 	$push26=, $pop24, $pop25
	i32.const	$push330=, 16
	i32.shr_s	$push27=, $pop26, $pop330
	i32.ne  	$push28=, $pop23, $pop27
	br_if   	0, $pop28       # 0: down to label0
# BB#9:                                 # %for.cond.7
	i32.const	$push334=, 2
	i32.const	$push333=, 1
	i32.sub 	$push16=, $pop334, $pop333
	i32.const	$push29=, 1
	i32.ne  	$push30=, $pop16, $pop29
	br_if   	0, $pop30       # 0: down to label0
# BB#10:                                # %for.cond.7
	i32.const	$push336=, 2
	i32.const	$push335=, 2
	i32.sub 	$push17=, $pop336, $pop335
	br_if   	0, $pop17       # 0: down to label0
# BB#11:                                # %for.cond.7
	i32.const	$push338=, 2
	i32.const	$push337=, 3
	i32.sub 	$push18=, $pop338, $pop337
	i32.const	$push31=, -1
	i32.ne  	$push32=, $pop18, $pop31
	br_if   	0, $pop32       # 0: down to label0
# BB#12:                                # %for.cond.7
	i32.const	$push340=, 2
	i32.const	$push339=, 4
	i32.sub 	$push19=, $pop340, $pop339
	i32.const	$push33=, -2
	i32.ne  	$push34=, $pop19, $pop33
	br_if   	0, $pop34       # 0: down to label0
# BB#13:                                # %for.cond.7
	i32.const	$push342=, 2
	i32.const	$push341=, 5
	i32.sub 	$push20=, $pop342, $pop341
	i32.const	$push35=, -3
	i32.ne  	$push36=, $pop20, $pop35
	br_if   	0, $pop36       # 0: down to label0
# BB#14:                                # %for.cond.7
	i32.const	$push344=, 2
	i32.const	$push343=, 6
	i32.sub 	$push21=, $pop344, $pop343
	i32.const	$push37=, -4
	i32.ne  	$push38=, $pop21, $pop37
	br_if   	0, $pop38       # 0: down to label0
# BB#15:                                # %for.cond.7
	i32.const	$push346=, 2
	i32.const	$push345=, 7
	i32.sub 	$push22=, $pop346, $pop345
	i32.const	$push39=, -5
	i32.ne  	$push40=, $pop22, $pop39
	br_if   	0, $pop40       # 0: down to label0
# BB#16:                                # %for.cond17.7
	i32.const	$push48=, 15
	i32.shr_s	$push49=, $3, $pop48
	i32.const	$push50=, 17
	i32.shl 	$push51=, $2, $pop50
	i32.const	$push52=, 16
	i32.shr_s	$push53=, $pop51, $pop52
	i32.ne  	$push54=, $pop49, $pop53
	br_if   	0, $pop54       # 0: down to label0
# BB#17:                                # %for.cond17.7
	i32.const	$push348=, 1
	i32.const	$push347=, 1
	i32.shl 	$push41=, $pop348, $pop347
	i32.const	$push55=, 2
	i32.ne  	$push56=, $pop41, $pop55
	br_if   	0, $pop56       # 0: down to label0
# BB#18:                                # %for.cond17.7
	i32.const	$push350=, 2
	i32.const	$push349=, 1
	i32.shl 	$push42=, $pop350, $pop349
	i32.const	$push57=, 4
	i32.ne  	$push58=, $pop42, $pop57
	br_if   	0, $pop58       # 0: down to label0
# BB#19:                                # %for.cond17.7
	i32.const	$push352=, 3
	i32.const	$push351=, 1
	i32.shl 	$push43=, $pop352, $pop351
	i32.const	$push59=, 6
	i32.ne  	$push60=, $pop43, $pop59
	br_if   	0, $pop60       # 0: down to label0
# BB#20:                                # %for.cond17.7
	i32.const	$push354=, 4
	i32.const	$push353=, 1
	i32.shl 	$push44=, $pop354, $pop353
	i32.const	$push61=, 8
	i32.ne  	$push62=, $pop44, $pop61
	br_if   	0, $pop62       # 0: down to label0
# BB#21:                                # %for.cond17.7
	i32.const	$push356=, 5
	i32.const	$push355=, 1
	i32.shl 	$push45=, $pop356, $pop355
	i32.const	$push63=, 10
	i32.ne  	$push64=, $pop45, $pop63
	br_if   	0, $pop64       # 0: down to label0
# BB#22:                                # %for.cond17.7
	i32.const	$push358=, 6
	i32.const	$push357=, 1
	i32.shl 	$push46=, $pop358, $pop357
	i32.const	$push65=, 12
	i32.ne  	$push66=, $pop46, $pop65
	br_if   	0, $pop66       # 0: down to label0
# BB#23:                                # %for.cond17.7
	i32.const	$push360=, 7
	i32.const	$push359=, 1
	i32.shl 	$push47=, $pop360, $pop359
	i32.const	$push67=, 14
	i32.ne  	$push68=, $pop47, $pop67
	br_if   	0, $pop68       # 0: down to label0
# BB#24:                                # %for.cond37.7
	i32.const	$push70=, 2
	i32.div_s	$3=, $pop70, $4
	i32.const	$push377=, 2
	i32.const	$push376=, 1
	i32.div_u	$5=, $pop377, $pop376
	i32.const	$push375=, 2
	i32.const	$push374=, 2
	i32.div_s	$6=, $pop375, $pop374
	i32.const	$push373=, 2
	i32.const	$push372=, 16
	i32.shl 	$push82=, $2, $pop372
	i32.const	$push371=, 16
	i32.shr_s	$push83=, $pop82, $pop371
	i32.div_s	$7=, $pop373, $pop83
	i32.const	$push370=, 2
	i32.const	$push369=, 3
	i32.div_s	$push71=, $pop370, $pop369
	i32.const	$push368=, 2
	i32.const	$push367=, 4
	i32.div_s	$push72=, $pop368, $pop367
	i32.or  	$push73=, $pop71, $pop72
	i32.const	$push366=, 2
	i32.const	$push365=, 5
	i32.div_s	$push74=, $pop366, $pop365
	i32.or  	$push75=, $pop73, $pop74
	i32.const	$push364=, 2
	i32.const	$push363=, 6
	i32.div_s	$push76=, $pop364, $pop363
	i32.or  	$push77=, $pop75, $pop76
	i32.const	$push362=, 2
	i32.const	$push361=, 7
	i32.div_s	$push78=, $pop362, $pop361
	i32.or  	$push79=, $pop77, $pop78
	i32.const	$push80=, 65535
	i32.and 	$push81=, $pop79, $pop80
	br_if   	0, $pop81       # 0: down to label0
# BB#25:                                # %for.cond37.7
	i32.const	$push379=, 16
	i32.shl 	$push84=, $7, $pop379
	i32.const	$push378=, 16
	i32.shr_s	$push69=, $pop84, $pop378
	i32.ne  	$push85=, $3, $pop69
	br_if   	0, $pop85       # 0: down to label0
# BB#26:                                # %for.cond37.7
	i32.const	$push86=, 2
	i32.ne  	$push87=, $5, $pop86
	br_if   	0, $pop87       # 0: down to label0
# BB#27:                                # %for.cond37.7
	i32.const	$push380=, 65535
	i32.and 	$push88=, $6, $pop380
	i32.const	$push89=, 1
	i32.ne  	$push90=, $pop88, $pop89
	br_if   	0, $pop90       # 0: down to label0
# BB#28:                                # %for.cond57.7
	i32.const	$push92=, 2
	i32.rem_s	$3=, $pop92, $4
	i32.const	$push398=, 2
	i32.const	$push397=, 3
	i32.rem_s	$5=, $pop398, $pop397
	i32.const	$push396=, 2
	i32.const	$push395=, 4
	i32.rem_s	$6=, $pop396, $pop395
	i32.const	$push394=, 2
	i32.const	$push393=, 16
	i32.shl 	$push97=, $2, $pop393
	i32.const	$push392=, 16
	i32.shr_s	$push98=, $pop97, $pop392
	i32.rem_s	$7=, $pop394, $pop98
	i32.const	$push391=, 2
	i32.const	$push390=, 5
	i32.rem_s	$8=, $pop391, $pop390
	i32.const	$push389=, 2
	i32.const	$push388=, 6
	i32.rem_s	$9=, $pop389, $pop388
	i32.const	$push387=, 2
	i32.const	$push386=, 7
	i32.rem_s	$10=, $pop387, $pop386
	i32.const	$push385=, 2
	i32.const	$push384=, 1
	i32.rem_u	$push93=, $pop385, $pop384
	i32.const	$push383=, 2
	i32.const	$push382=, 2
	i32.rem_s	$push94=, $pop383, $pop382
	i32.or  	$push95=, $pop93, $pop94
	i32.const	$push381=, 65535
	i32.and 	$push96=, $pop95, $pop381
	br_if   	0, $pop96       # 0: down to label0
# BB#29:                                # %for.cond57.7
	i32.const	$push400=, 16
	i32.shl 	$push99=, $7, $pop400
	i32.const	$push399=, 16
	i32.shr_s	$push91=, $pop99, $pop399
	i32.ne  	$push100=, $3, $pop91
	br_if   	0, $pop100      # 0: down to label0
# BB#30:                                # %for.cond57.7
	i32.const	$push402=, 65535
	i32.and 	$push101=, $5, $pop402
	i32.const	$push401=, 2
	i32.ne  	$push102=, $pop101, $pop401
	br_if   	0, $pop102      # 0: down to label0
# BB#31:                                # %for.cond57.7
	i32.const	$push404=, 65535
	i32.and 	$push103=, $6, $pop404
	i32.const	$push403=, 2
	i32.ne  	$push104=, $pop103, $pop403
	br_if   	0, $pop104      # 0: down to label0
# BB#32:                                # %for.cond57.7
	i32.const	$push406=, 65535
	i32.and 	$push105=, $8, $pop406
	i32.const	$push405=, 2
	i32.ne  	$push106=, $pop105, $pop405
	br_if   	0, $pop106      # 0: down to label0
# BB#33:                                # %for.cond57.7
	i32.const	$push408=, 65535
	i32.and 	$push107=, $9, $pop408
	i32.const	$push407=, 2
	i32.ne  	$push108=, $pop107, $pop407
	br_if   	0, $pop108      # 0: down to label0
# BB#34:                                # %for.cond57.7
	i32.const	$push410=, 65535
	i32.and 	$push109=, $10, $pop410
	i32.const	$push409=, 2
	i32.ne  	$push110=, $pop109, $pop409
	br_if   	0, $pop110      # 0: down to label0
# BB#35:                                # %for.cond77.7
	i32.const	$push414=, 2
	i32.xor 	$push118=, $2, $pop414
	i32.const	$push413=, 65535
	i32.and 	$push412=, $pop118, $pop413
	tee_local	$push411=, $3=, $pop412
	i32.ne  	$push119=, $pop411, $3
	br_if   	0, $pop119      # 0: down to label0
# BB#36:                                # %for.cond77.7
	i32.const	$push416=, 1
	i32.const	$push415=, 2
	i32.or  	$push111=, $pop416, $pop415
	i32.const	$push120=, 3
	i32.ne  	$push121=, $pop111, $pop120
	br_if   	0, $pop121      # 0: down to label0
# BB#37:                                # %for.cond77.7
	i32.const	$push418=, 2
	i32.const	$push417=, 2
	i32.xor 	$push112=, $pop418, $pop417
	br_if   	0, $pop112      # 0: down to label0
# BB#38:                                # %for.cond77.7
	i32.const	$push420=, 3
	i32.const	$push419=, 2
	i32.xor 	$push113=, $pop420, $pop419
	i32.const	$push122=, 1
	i32.ne  	$push123=, $pop113, $pop122
	br_if   	0, $pop123      # 0: down to label0
# BB#39:                                # %for.cond77.7
	i32.const	$push422=, 4
	i32.const	$push421=, 2
	i32.xor 	$push114=, $pop422, $pop421
	i32.const	$push124=, 6
	i32.ne  	$push125=, $pop114, $pop124
	br_if   	0, $pop125      # 0: down to label0
# BB#40:                                # %for.cond77.7
	i32.const	$push424=, 5
	i32.const	$push423=, 2
	i32.xor 	$push115=, $pop424, $pop423
	i32.const	$push126=, 7
	i32.ne  	$push127=, $pop115, $pop126
	br_if   	0, $pop127      # 0: down to label0
# BB#41:                                # %for.cond77.7
	i32.const	$push426=, 6
	i32.const	$push425=, 2
	i32.xor 	$push116=, $pop426, $pop425
	i32.const	$push128=, 4
	i32.ne  	$push129=, $pop116, $pop128
	br_if   	0, $pop129      # 0: down to label0
# BB#42:                                # %for.cond77.7
	i32.const	$push428=, 7
	i32.const	$push427=, 2
	i32.xor 	$push117=, $pop428, $pop427
	i32.const	$push130=, 5
	i32.ne  	$push131=, $pop117, $pop130
	br_if   	0, $pop131      # 0: down to label0
# BB#43:                                # %for.cond97.7
	i32.const	$push431=, 4
	i32.const	$push430=, 5
	i32.or  	$push136=, $pop431, $pop430
	i32.const	$push429=, 2
	i32.and 	$push137=, $pop136, $pop429
	br_if   	0, $pop137      # 0: down to label0
# BB#44:                                # %for.cond97.7
	i32.const	$push434=, 2
	i32.and 	$push433=, $2, $pop434
	tee_local	$push432=, $3=, $pop433
	i32.ne  	$push138=, $pop432, $3
	br_if   	0, $pop138      # 0: down to label0
# BB#45:                                # %for.cond97.7
	i32.const	$push139=, 0
	br_if   	0, $pop139      # 0: down to label0
# BB#46:                                # %for.cond97.7
	i32.const	$push437=, 2
	i32.const	$push436=, 2
	i32.and 	$push132=, $pop437, $pop436
	i32.const	$push435=, 2
	i32.ne  	$push140=, $pop132, $pop435
	br_if   	0, $pop140      # 0: down to label0
# BB#47:                                # %for.cond97.7
	i32.const	$push440=, 3
	i32.const	$push439=, 2
	i32.and 	$push133=, $pop440, $pop439
	i32.const	$push438=, 2
	i32.ne  	$push141=, $pop133, $pop438
	br_if   	0, $pop141      # 0: down to label0
# BB#48:                                # %for.cond97.7
	i32.const	$push443=, 6
	i32.const	$push442=, 2
	i32.and 	$push134=, $pop443, $pop442
	i32.const	$push441=, 2
	i32.ne  	$push142=, $pop134, $pop441
	br_if   	0, $pop142      # 0: down to label0
# BB#49:                                # %for.cond97.7
	i32.const	$push446=, 7
	i32.const	$push445=, 2
	i32.and 	$push135=, $pop446, $pop445
	i32.const	$push444=, 2
	i32.ne  	$push143=, $pop135, $pop444
	br_if   	0, $pop143      # 0: down to label0
# BB#50:                                # %for.cond117.7
	i32.const	$push449=, 2
	i32.or  	$push151=, $2, $pop449
	i32.const	$push152=, 65535
	i32.and 	$push448=, $pop151, $pop152
	tee_local	$push447=, $3=, $pop448
	i32.ne  	$push153=, $pop447, $3
	br_if   	0, $pop153      # 0: down to label0
# BB#51:                                # %for.cond117.7
	i32.const	$push451=, 1
	i32.const	$push450=, 2
	i32.or  	$push144=, $pop451, $pop450
	i32.const	$push154=, 3
	i32.ne  	$push155=, $pop144, $pop154
	br_if   	0, $pop155      # 0: down to label0
# BB#52:                                # %for.cond117.7
	i32.const	$push453=, 2
	i32.const	$push452=, 2
	i32.or  	$push145=, $pop453, $pop452
	i32.const	$push156=, 2
	i32.ne  	$push157=, $pop145, $pop156
	br_if   	0, $pop157      # 0: down to label0
# BB#53:                                # %for.cond117.7
	i32.const	$push455=, 3
	i32.const	$push454=, 2
	i32.or  	$push146=, $pop455, $pop454
	i32.const	$push158=, 3
	i32.ne  	$push159=, $pop146, $pop158
	br_if   	0, $pop159      # 0: down to label0
# BB#54:                                # %for.cond117.7
	i32.const	$push457=, 4
	i32.const	$push456=, 2
	i32.or  	$push147=, $pop457, $pop456
	i32.const	$push160=, 6
	i32.ne  	$push161=, $pop147, $pop160
	br_if   	0, $pop161      # 0: down to label0
# BB#55:                                # %for.cond117.7
	i32.const	$push459=, 5
	i32.const	$push458=, 2
	i32.or  	$push148=, $pop459, $pop458
	i32.const	$push162=, 7
	i32.ne  	$push163=, $pop148, $pop162
	br_if   	0, $pop163      # 0: down to label0
# BB#56:                                # %for.cond117.7
	i32.const	$push461=, 6
	i32.const	$push460=, 2
	i32.or  	$push149=, $pop461, $pop460
	i32.const	$push164=, 6
	i32.ne  	$push165=, $pop149, $pop164
	br_if   	0, $pop165      # 0: down to label0
# BB#57:                                # %for.cond117.7
	i32.const	$push463=, 7
	i32.const	$push462=, 2
	i32.or  	$push150=, $pop463, $pop462
	i32.const	$push166=, 7
	i32.ne  	$push167=, $pop150, $pop166
	br_if   	0, $pop167      # 0: down to label0
# BB#58:                                # %for.cond137.7
	i32.const	$push467=, 2
	i32.shl 	$push175=, $pop467, $4
	i32.const	$push466=, 2
	i32.const	$push465=, 65535
	i32.and 	$push176=, $2, $pop465
	i32.shl 	$push177=, $pop466, $pop176
	i32.const	$push178=, 16
	i32.shl 	$push179=, $pop177, $pop178
	i32.const	$push464=, 16
	i32.shr_s	$push180=, $pop179, $pop464
	i32.ne  	$push181=, $pop175, $pop180
	br_if   	0, $pop181      # 0: down to label0
# BB#59:                                # %for.cond137.7
	i32.const	$push470=, 2
	i32.const	$push469=, 1
	i32.shl 	$push168=, $pop470, $pop469
	i32.const	$push468=, 65535
	i32.and 	$push188=, $pop168, $pop468
	i32.const	$push189=, 4
	i32.ne  	$push190=, $pop188, $pop189
	br_if   	0, $pop190      # 0: down to label0
# BB#60:                                # %for.cond137.7
	i32.const	$push474=, 2
	i32.const	$push473=, 2
	i32.const	$push472=, 65535
	i32.and 	$push182=, $pop473, $pop472
	i32.shl 	$push169=, $pop474, $pop182
	i32.const	$push471=, 65535
	i32.and 	$push191=, $pop169, $pop471
	i32.const	$push192=, 8
	i32.ne  	$push193=, $pop191, $pop192
	br_if   	0, $pop193      # 0: down to label0
# BB#61:                                # %for.cond137.7
	i32.const	$push478=, 2
	i32.const	$push477=, 3
	i32.const	$push476=, 65535
	i32.and 	$push183=, $pop477, $pop476
	i32.shl 	$push170=, $pop478, $pop183
	i32.const	$push475=, 65535
	i32.and 	$push194=, $pop170, $pop475
	i32.const	$push195=, 16
	i32.ne  	$push196=, $pop194, $pop195
	br_if   	0, $pop196      # 0: down to label0
# BB#62:                                # %for.cond137.7
	i32.const	$push482=, 2
	i32.const	$push481=, 4
	i32.const	$push480=, 65535
	i32.and 	$push184=, $pop481, $pop480
	i32.shl 	$push171=, $pop482, $pop184
	i32.const	$push479=, 65535
	i32.and 	$push197=, $pop171, $pop479
	i32.const	$push198=, 32
	i32.ne  	$push199=, $pop197, $pop198
	br_if   	0, $pop199      # 0: down to label0
# BB#63:                                # %for.cond137.7
	i32.const	$push486=, 2
	i32.const	$push485=, 5
	i32.const	$push484=, 65535
	i32.and 	$push185=, $pop485, $pop484
	i32.shl 	$push172=, $pop486, $pop185
	i32.const	$push483=, 65535
	i32.and 	$push200=, $pop172, $pop483
	i32.const	$push201=, 64
	i32.ne  	$push202=, $pop200, $pop201
	br_if   	0, $pop202      # 0: down to label0
# BB#64:                                # %for.cond137.7
	i32.const	$push490=, 2
	i32.const	$push489=, 6
	i32.const	$push488=, 65535
	i32.and 	$push186=, $pop489, $pop488
	i32.shl 	$push173=, $pop490, $pop186
	i32.const	$push487=, 65535
	i32.and 	$push203=, $pop173, $pop487
	i32.const	$push204=, 128
	i32.ne  	$push205=, $pop203, $pop204
	br_if   	0, $pop205      # 0: down to label0
# BB#65:                                # %for.cond137.7
	i32.const	$push494=, 2
	i32.const	$push493=, 7
	i32.const	$push492=, 65535
	i32.and 	$push187=, $pop493, $pop492
	i32.shl 	$push174=, $pop494, $pop187
	i32.const	$push491=, 65535
	i32.and 	$push206=, $pop174, $pop491
	i32.const	$push207=, 256
	i32.ne  	$push208=, $pop206, $pop207
	br_if   	0, $pop208      # 0: down to label0
# BB#66:                                # %for.cond157.7
	i32.const	$push513=, 2
	i32.const	$push512=, 2
	i32.const	$push511=, 65535
	i32.and 	$push212=, $pop512, $pop511
	i32.shr_u	$push213=, $pop513, $pop212
	i32.const	$push510=, 2
	i32.const	$push509=, 3
	i32.const	$push508=, 65535
	i32.and 	$push214=, $pop509, $pop508
	i32.shr_u	$push215=, $pop510, $pop214
	i32.or  	$push216=, $pop213, $pop215
	i32.const	$push507=, 2
	i32.const	$push506=, 4
	i32.const	$push505=, 65535
	i32.and 	$push217=, $pop506, $pop505
	i32.shr_u	$push218=, $pop507, $pop217
	i32.or  	$push219=, $pop216, $pop218
	i32.const	$push504=, 2
	i32.const	$push503=, 5
	i32.const	$push502=, 65535
	i32.and 	$push220=, $pop503, $pop502
	i32.shr_u	$push221=, $pop504, $pop220
	i32.or  	$push222=, $pop219, $pop221
	i32.const	$push501=, 2
	i32.const	$push500=, 6
	i32.const	$push499=, 65535
	i32.and 	$push223=, $pop500, $pop499
	i32.shr_u	$push224=, $pop501, $pop223
	i32.or  	$push225=, $pop222, $pop224
	i32.const	$push498=, 2
	i32.const	$push497=, 7
	i32.const	$push496=, 65535
	i32.and 	$push226=, $pop497, $pop496
	i32.shr_u	$push227=, $pop498, $pop226
	i32.or  	$push228=, $pop225, $pop227
	i32.const	$push495=, 65535
	i32.and 	$push229=, $pop228, $pop495
	br_if   	0, $pop229      # 0: down to label0
# BB#67:                                # %for.cond157.7
	i32.const	$push517=, 2
	i32.shr_u	$push209=, $pop517, $4
	i32.const	$push516=, 2
	i32.const	$push515=, 65535
	i32.and 	$push230=, $2, $pop515
	i32.shr_u	$push231=, $pop516, $pop230
	i32.const	$push232=, 16
	i32.shl 	$push233=, $pop231, $pop232
	i32.const	$push514=, 16
	i32.shr_s	$push210=, $pop233, $pop514
	i32.ne  	$push234=, $pop209, $pop210
	br_if   	0, $pop234      # 0: down to label0
# BB#68:                                # %for.cond157.7
	i32.const	$push519=, 2
	i32.const	$push518=, 1
	i32.shr_u	$push211=, $pop519, $pop518
	i32.const	$push235=, 65535
	i32.and 	$push236=, $pop211, $pop235
	i32.const	$push237=, 1
	i32.ne  	$push238=, $pop236, $pop237
	br_if   	0, $pop238      # 0: down to label0
# BB#69:                                # %for.cond198.7
	i32.const	$push521=, -2
	i32.add 	$push246=, $4, $pop521
	i32.const	$push247=, 16
	i32.shl 	$push248=, $2, $pop247
	i32.const	$push249=, -131072
	i32.add 	$push250=, $pop248, $pop249
	i32.const	$push520=, 16
	i32.shr_s	$push251=, $pop250, $pop520
	i32.ne  	$push252=, $pop246, $pop251
	br_if   	0, $pop252      # 0: down to label0
# BB#70:                                # %for.cond198.7
	i32.const	$push523=, 1
	i32.const	$push522=, -2
	i32.or  	$push239=, $pop523, $pop522
	i32.const	$push253=, -1
	i32.ne  	$push254=, $pop239, $pop253
	br_if   	0, $pop254      # 0: down to label0
# BB#71:                                # %for.cond198.7
	i32.const	$push525=, 2
	i32.const	$push524=, -2
	i32.add 	$push240=, $pop525, $pop524
	br_if   	0, $pop240      # 0: down to label0
# BB#72:                                # %for.cond198.7
	i32.const	$push527=, 3
	i32.const	$push526=, -2
	i32.add 	$push241=, $pop527, $pop526
	i32.const	$push255=, 1
	i32.ne  	$push256=, $pop241, $pop255
	br_if   	0, $pop256      # 0: down to label0
# BB#73:                                # %for.cond198.7
	i32.const	$push529=, 4
	i32.const	$push528=, -2
	i32.add 	$push242=, $pop529, $pop528
	i32.const	$push257=, 2
	i32.ne  	$push258=, $pop242, $pop257
	br_if   	0, $pop258      # 0: down to label0
# BB#74:                                # %for.cond198.7
	i32.const	$push531=, 5
	i32.const	$push530=, -2
	i32.add 	$push243=, $pop531, $pop530
	i32.const	$push259=, 3
	i32.ne  	$push260=, $pop243, $pop259
	br_if   	0, $pop260      # 0: down to label0
# BB#75:                                # %for.cond198.7
	i32.const	$push533=, 6
	i32.const	$push532=, -2
	i32.add 	$push244=, $pop533, $pop532
	i32.const	$push261=, 4
	i32.ne  	$push262=, $pop244, $pop261
	br_if   	0, $pop262      # 0: down to label0
# BB#76:                                # %for.cond198.7
	i32.const	$push535=, 7
	i32.const	$push534=, -2
	i32.add 	$push245=, $pop535, $pop534
	i32.const	$push263=, 5
	i32.ne  	$push264=, $pop245, $pop263
	br_if   	0, $pop264      # 0: down to label0
# BB#77:                                # %for.cond240.7
	i32.const	$push552=, 2
	i32.const	$push267=, 2
	i32.div_s	$3=, $pop552, $pop267
	i32.const	$push551=, 3
	i32.const	$push550=, 2
	i32.div_s	$5=, $pop551, $pop550
	i32.const	$push549=, 4
	i32.const	$push548=, 2
	i32.div_s	$6=, $pop549, $pop548
	i32.const	$push547=, 5
	i32.const	$push546=, 2
	i32.div_s	$7=, $pop547, $pop546
	i32.const	$push545=, 6
	i32.const	$push544=, 2
	i32.div_s	$8=, $pop545, $pop544
	i32.const	$push543=, 7
	i32.const	$push542=, 2
	i32.div_s	$9=, $pop543, $pop542
	i32.const	$push265=, 16
	i32.shl 	$push266=, $2, $pop265
	i32.const	$push541=, 16
	i32.shr_s	$push540=, $pop266, $pop541
	tee_local	$push539=, $10=, $pop540
	i32.const	$push538=, 2
	i32.div_s	$push271=, $pop539, $pop538
	i32.const	$push269=, 65535
	i32.and 	$push272=, $pop271, $pop269
	i32.const	$push537=, 2
	i32.div_s	$push268=, $10, $pop537
	i32.const	$push536=, 65535
	i32.and 	$push270=, $pop268, $pop536
	i32.ne  	$push273=, $pop272, $pop270
	br_if   	0, $pop273      # 0: down to label0
# BB#78:                                # %for.cond240.7
	i32.const	$push274=, 0
	br_if   	0, $pop274      # 0: down to label0
# BB#79:                                # %for.cond240.7
	i32.const	$push554=, 65535
	i32.and 	$push275=, $3, $pop554
	i32.const	$push553=, 1
	i32.ne  	$push276=, $pop275, $pop553
	br_if   	0, $pop276      # 0: down to label0
# BB#80:                                # %for.cond240.7
	i32.const	$push556=, 65535
	i32.and 	$push277=, $5, $pop556
	i32.const	$push555=, 1
	i32.ne  	$push278=, $pop277, $pop555
	br_if   	0, $pop278      # 0: down to label0
# BB#81:                                # %for.cond240.7
	i32.const	$push558=, 65535
	i32.and 	$push279=, $6, $pop558
	i32.const	$push557=, 2
	i32.ne  	$push280=, $pop279, $pop557
	br_if   	0, $pop280      # 0: down to label0
# BB#82:                                # %for.cond240.7
	i32.const	$push560=, 65535
	i32.and 	$push281=, $7, $pop560
	i32.const	$push559=, 2
	i32.ne  	$push282=, $pop281, $pop559
	br_if   	0, $pop282      # 0: down to label0
# BB#83:                                # %for.cond240.7
	i32.const	$push562=, 65535
	i32.and 	$push283=, $8, $pop562
	i32.const	$push561=, 3
	i32.ne  	$push284=, $pop283, $pop561
	br_if   	0, $pop284      # 0: down to label0
# BB#84:                                # %for.cond240.7
	i32.const	$push564=, 65535
	i32.and 	$push285=, $9, $pop564
	i32.const	$push563=, 3
	i32.ne  	$push286=, $pop285, $pop563
	br_if   	0, $pop286      # 0: down to label0
# BB#85:                                # %for.cond261.7
	i32.const	$push580=, 2
	i32.const	$push287=, 2
	i32.rem_s	$3=, $pop580, $pop287
	i32.const	$push579=, 3
	i32.const	$push578=, 2
	i32.rem_s	$5=, $pop579, $pop578
	i32.const	$push577=, 4
	i32.const	$push576=, 2
	i32.rem_s	$6=, $pop577, $pop576
	i32.const	$push575=, 5
	i32.const	$push574=, 2
	i32.rem_s	$7=, $pop575, $pop574
	i32.const	$push573=, 6
	i32.const	$push572=, 2
	i32.rem_s	$8=, $pop573, $pop572
	i32.const	$push571=, 7
	i32.const	$push570=, 2
	i32.rem_s	$9=, $pop571, $pop570
	i32.const	$push569=, 2
	i32.rem_s	$push288=, $4, $pop569
	i32.const	$push289=, 16
	i32.shl 	$push290=, $2, $pop289
	i32.const	$push568=, 16
	i32.shr_s	$push291=, $pop290, $pop568
	i32.const	$push567=, 2
	i32.rem_s	$push292=, $pop291, $pop567
	i32.const	$push566=, 16
	i32.shl 	$push293=, $pop292, $pop566
	i32.const	$push565=, 16
	i32.shr_s	$push294=, $pop293, $pop565
	i32.ne  	$push295=, $pop288, $pop294
	br_if   	0, $pop295      # 0: down to label0
# BB#86:                                # %for.cond261.7
	i32.const	$push581=, 1
	i32.eqz 	$push588=, $pop581
	br_if   	0, $pop588      # 0: down to label0
# BB#87:                                # %for.cond261.7
	i32.const	$push582=, 65535
	i32.and 	$push296=, $3, $pop582
	br_if   	0, $pop296      # 0: down to label0
# BB#88:                                # %for.cond261.7
	i32.const	$push583=, 65535
	i32.and 	$push297=, $5, $pop583
	i32.const	$push298=, 1
	i32.ne  	$push299=, $pop297, $pop298
	br_if   	0, $pop299      # 0: down to label0
# BB#89:                                # %for.cond261.7
	i32.const	$push584=, 65535
	i32.and 	$push300=, $6, $pop584
	br_if   	0, $pop300      # 0: down to label0
# BB#90:                                # %for.cond261.7
	i32.const	$push585=, 65535
	i32.and 	$push301=, $7, $pop585
	i32.const	$push302=, 1
	i32.ne  	$push303=, $pop301, $pop302
	br_if   	0, $pop303      # 0: down to label0
# BB#91:                                # %for.cond261.7
	i32.const	$push586=, 65535
	i32.and 	$push304=, $8, $pop586
	br_if   	0, $pop304      # 0: down to label0
# BB#92:                                # %for.cond261.7
	i32.const	$push587=, 65535
	i32.and 	$push305=, $9, $pop587
	i32.const	$push306=, 1
	i32.ne  	$push307=, $pop305, $pop306
	br_if   	0, $pop307      # 0: down to label0
# BB#93:                                # %for.cond667.1
	i32.const	$push308=, 0
	return  	$pop308
.LBB0_94:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	one                     # @one
	.type	one,@object
	.section	.data.one,"aw",@progbits
	.globl	one
	.p2align	2
one:
	.int32	1                       # 0x1
	.size	one, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
