	.text
	.file	"scal-to-vec1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push2=, 0
	i32.load	$2=, one($pop2)
	i32.const	$push3=, 16
	i32.shl 	$3=, $2, $pop3
	i32.const	$push330=, 16
	i32.shr_s	$4=, $3, $pop330
	block   	
	i32.const	$push329=, 2
	i32.add 	$push7=, $4, $pop329
	i32.const	$push4=, 131072
	i32.add 	$push5=, $3, $pop4
	i32.const	$push328=, 16
	i32.shr_s	$push6=, $pop5, $pop328
	i32.ne  	$push8=, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label0
# %bb.1:                                # %entry
	i32.const	$push332=, 3
	i32.const	$push331=, 3
	i32.ne  	$push9=, $pop332, $pop331
	br_if   	0, $pop9        # 0: down to label0
# %bb.2:                                # %entry
	i32.const	$push334=, 4
	i32.const	$push333=, 4
	i32.ne  	$push10=, $pop334, $pop333
	br_if   	0, $pop10       # 0: down to label0
# %bb.3:                                # %entry
	i32.const	$push336=, 5
	i32.const	$push335=, 5
	i32.ne  	$push11=, $pop336, $pop335
	br_if   	0, $pop11       # 0: down to label0
# %bb.4:                                # %entry
	i32.const	$push338=, 6
	i32.const	$push337=, 6
	i32.ne  	$push12=, $pop338, $pop337
	br_if   	0, $pop12       # 0: down to label0
# %bb.5:                                # %entry
	i32.const	$push340=, 7
	i32.const	$push339=, 7
	i32.ne  	$push13=, $pop340, $pop339
	br_if   	0, $pop13       # 0: down to label0
# %bb.6:                                # %entry
	i32.const	$push0=, 8
	i32.const	$push341=, 8
	i32.ne  	$push14=, $pop0, $pop341
	br_if   	0, $pop14       # 0: down to label0
# %bb.7:                                # %entry
	i32.const	$push1=, 9
	i32.const	$push342=, 9
	i32.ne  	$push15=, $pop1, $pop342
	br_if   	0, $pop15       # 0: down to label0
# %bb.8:                                # %for.cond.7
	i32.const	$push345=, 2
	i32.sub 	$push23=, $pop345, $4
	i32.const	$push344=, 2
	i32.sub 	$push24=, $pop344, $2
	i32.const	$push25=, 16
	i32.shl 	$push26=, $pop24, $pop25
	i32.const	$push343=, 16
	i32.shr_s	$push27=, $pop26, $pop343
	i32.ne  	$push28=, $pop23, $pop27
	br_if   	0, $pop28       # 0: down to label0
# %bb.9:                                # %for.cond.7
	i32.const	$push347=, 2
	i32.const	$push346=, 1
	i32.sub 	$push16=, $pop347, $pop346
	i32.const	$push29=, 1
	i32.ne  	$push30=, $pop16, $pop29
	br_if   	0, $pop30       # 0: down to label0
# %bb.10:                               # %for.cond.7
	i32.const	$push349=, 2
	i32.const	$push348=, 2
	i32.sub 	$push17=, $pop349, $pop348
	br_if   	0, $pop17       # 0: down to label0
# %bb.11:                               # %for.cond.7
	i32.const	$push351=, 2
	i32.const	$push350=, 3
	i32.sub 	$push18=, $pop351, $pop350
	i32.const	$push31=, -1
	i32.ne  	$push32=, $pop18, $pop31
	br_if   	0, $pop32       # 0: down to label0
# %bb.12:                               # %for.cond.7
	i32.const	$push353=, 2
	i32.const	$push352=, 4
	i32.sub 	$push19=, $pop353, $pop352
	i32.const	$push33=, -2
	i32.ne  	$push34=, $pop19, $pop33
	br_if   	0, $pop34       # 0: down to label0
# %bb.13:                               # %for.cond.7
	i32.const	$push355=, 2
	i32.const	$push354=, 5
	i32.sub 	$push20=, $pop355, $pop354
	i32.const	$push35=, -3
	i32.ne  	$push36=, $pop20, $pop35
	br_if   	0, $pop36       # 0: down to label0
# %bb.14:                               # %for.cond.7
	i32.const	$push357=, 2
	i32.const	$push356=, 6
	i32.sub 	$push21=, $pop357, $pop356
	i32.const	$push37=, -4
	i32.ne  	$push38=, $pop21, $pop37
	br_if   	0, $pop38       # 0: down to label0
# %bb.15:                               # %for.cond.7
	i32.const	$push359=, 2
	i32.const	$push358=, 7
	i32.sub 	$push22=, $pop359, $pop358
	i32.const	$push39=, -5
	i32.ne  	$push40=, $pop22, $pop39
	br_if   	0, $pop40       # 0: down to label0
# %bb.16:                               # %for.cond17.7
	i32.const	$push48=, 15
	i32.shr_s	$push49=, $3, $pop48
	i32.const	$push50=, 17
	i32.shl 	$push51=, $2, $pop50
	i32.const	$push52=, 16
	i32.shr_s	$push53=, $pop51, $pop52
	i32.ne  	$push54=, $pop49, $pop53
	br_if   	0, $pop54       # 0: down to label0
# %bb.17:                               # %for.cond17.7
	i32.const	$push361=, 1
	i32.const	$push360=, 1
	i32.shl 	$push41=, $pop361, $pop360
	i32.const	$push55=, 2
	i32.ne  	$push56=, $pop41, $pop55
	br_if   	0, $pop56       # 0: down to label0
# %bb.18:                               # %for.cond17.7
	i32.const	$push363=, 2
	i32.const	$push362=, 1
	i32.shl 	$push42=, $pop363, $pop362
	i32.const	$push57=, 4
	i32.ne  	$push58=, $pop42, $pop57
	br_if   	0, $pop58       # 0: down to label0
# %bb.19:                               # %for.cond17.7
	i32.const	$push365=, 3
	i32.const	$push364=, 1
	i32.shl 	$push43=, $pop365, $pop364
	i32.const	$push59=, 6
	i32.ne  	$push60=, $pop43, $pop59
	br_if   	0, $pop60       # 0: down to label0
# %bb.20:                               # %for.cond17.7
	i32.const	$push367=, 4
	i32.const	$push366=, 1
	i32.shl 	$push44=, $pop367, $pop366
	i32.const	$push61=, 8
	i32.ne  	$push62=, $pop44, $pop61
	br_if   	0, $pop62       # 0: down to label0
# %bb.21:                               # %for.cond17.7
	i32.const	$push369=, 5
	i32.const	$push368=, 1
	i32.shl 	$push45=, $pop369, $pop368
	i32.const	$push63=, 10
	i32.ne  	$push64=, $pop45, $pop63
	br_if   	0, $pop64       # 0: down to label0
# %bb.22:                               # %for.cond17.7
	i32.const	$push371=, 6
	i32.const	$push370=, 1
	i32.shl 	$push46=, $pop371, $pop370
	i32.const	$push65=, 12
	i32.ne  	$push66=, $pop46, $pop65
	br_if   	0, $pop66       # 0: down to label0
# %bb.23:                               # %for.cond17.7
	i32.const	$push373=, 7
	i32.const	$push372=, 1
	i32.shl 	$push47=, $pop373, $pop372
	i32.const	$push67=, 14
	i32.ne  	$push68=, $pop47, $pop67
	br_if   	0, $pop68       # 0: down to label0
# %bb.24:                               # %for.cond37.7
	i32.const	$push70=, 2
	i32.const	$push390=, 3
	i32.div_s	$3=, $pop70, $pop390
	i32.const	$push389=, 2
	i32.const	$push388=, 4
	i32.div_s	$7=, $pop389, $pop388
	i32.const	$push387=, 2
	i32.const	$push386=, 5
	i32.div_s	$8=, $pop387, $pop386
	i32.const	$push385=, 2
	i32.const	$push384=, 6
	i32.div_s	$9=, $pop385, $pop384
	i32.const	$push383=, 2
	i32.const	$push382=, 7
	i32.div_s	$10=, $pop383, $pop382
	i32.const	$push381=, 2
	i32.div_s	$11=, $pop381, $4
	i32.const	$push380=, 2
	i32.const	$push379=, 1
	i32.div_u	$12=, $pop380, $pop379
	i32.const	$push378=, 2
	i32.const	$push377=, 2
	i32.div_s	$6=, $pop378, $pop377
	i32.const	$push376=, 2
	i32.const	$push375=, 16
	i32.shl 	$push77=, $2, $pop375
	i32.const	$push374=, 16
	i32.shr_s	$push78=, $pop77, $pop374
	i32.div_s	$5=, $pop376, $pop78
	i32.or  	$push71=, $3, $7
	i32.or  	$push72=, $pop71, $8
	i32.or  	$push73=, $pop72, $9
	i32.or  	$push74=, $pop73, $10
	i32.const	$push75=, 65535
	i32.and 	$push76=, $pop74, $pop75
	br_if   	0, $pop76       # 0: down to label0
# %bb.25:                               # %for.cond37.7
	i32.const	$push392=, 16
	i32.shl 	$push79=, $5, $pop392
	i32.const	$push391=, 16
	i32.shr_s	$push69=, $pop79, $pop391
	i32.ne  	$push80=, $11, $pop69
	br_if   	0, $pop80       # 0: down to label0
# %bb.26:                               # %for.cond37.7
	i32.const	$push81=, 2
	i32.ne  	$push82=, $12, $pop81
	br_if   	0, $pop82       # 0: down to label0
# %bb.27:                               # %for.cond37.7
	i32.const	$push393=, 65535
	i32.and 	$push83=, $6, $pop393
	i32.const	$push84=, 1
	i32.ne  	$push85=, $pop83, $pop84
	br_if   	0, $pop85       # 0: down to label0
# %bb.28:                               # %for.cond57.7
	i32.const	$push398=, 2
	i32.const	$push397=, 1
	i32.mul 	$push93=, $12, $pop397
	i32.sub 	$push94=, $pop398, $pop93
	i32.const	$push396=, 2
	i32.const	$push395=, 2
	i32.mul 	$push95=, $6, $pop395
	i32.sub 	$push96=, $pop396, $pop95
	i32.or  	$push97=, $pop94, $pop96
	i32.const	$push394=, 65535
	i32.and 	$push98=, $pop97, $pop394
	br_if   	0, $pop98       # 0: down to label0
# %bb.29:                               # %for.cond57.7
	i32.const	$push401=, 2
	i32.mul 	$push99=, $11, $4
	i32.sub 	$push86=, $pop401, $pop99
	i32.const	$push400=, 2
	i32.mul 	$push100=, $5, $2
	i32.sub 	$push101=, $pop400, $pop100
	i32.const	$push102=, 16
	i32.shl 	$push103=, $pop101, $pop102
	i32.const	$push399=, 16
	i32.shr_s	$push87=, $pop103, $pop399
	i32.ne  	$push109=, $pop86, $pop87
	br_if   	0, $pop109      # 0: down to label0
# %bb.30:                               # %for.cond57.7
	i32.const	$push405=, 2
	i32.const	$push404=, 3
	i32.mul 	$push104=, $3, $pop404
	i32.sub 	$push88=, $pop405, $pop104
	i32.const	$push403=, 65535
	i32.and 	$push110=, $pop88, $pop403
	i32.const	$push402=, 2
	i32.ne  	$push111=, $pop110, $pop402
	br_if   	0, $pop111      # 0: down to label0
# %bb.31:                               # %for.cond57.7
	i32.const	$push409=, 2
	i32.const	$push408=, 4
	i32.mul 	$push105=, $7, $pop408
	i32.sub 	$push89=, $pop409, $pop105
	i32.const	$push407=, 65535
	i32.and 	$push112=, $pop89, $pop407
	i32.const	$push406=, 2
	i32.ne  	$push113=, $pop112, $pop406
	br_if   	0, $pop113      # 0: down to label0
# %bb.32:                               # %for.cond57.7
	i32.const	$push413=, 2
	i32.const	$push412=, 5
	i32.mul 	$push106=, $8, $pop412
	i32.sub 	$push90=, $pop413, $pop106
	i32.const	$push411=, 65535
	i32.and 	$push114=, $pop90, $pop411
	i32.const	$push410=, 2
	i32.ne  	$push115=, $pop114, $pop410
	br_if   	0, $pop115      # 0: down to label0
# %bb.33:                               # %for.cond57.7
	i32.const	$push417=, 2
	i32.const	$push416=, 6
	i32.mul 	$push107=, $9, $pop416
	i32.sub 	$push91=, $pop417, $pop107
	i32.const	$push415=, 65535
	i32.and 	$push116=, $pop91, $pop415
	i32.const	$push414=, 2
	i32.ne  	$push117=, $pop116, $pop414
	br_if   	0, $pop117      # 0: down to label0
# %bb.34:                               # %for.cond57.7
	i32.const	$push421=, 2
	i32.const	$push420=, 7
	i32.mul 	$push108=, $10, $pop420
	i32.sub 	$push92=, $pop421, $pop108
	i32.const	$push419=, 65535
	i32.and 	$push118=, $pop92, $pop419
	i32.const	$push418=, 2
	i32.ne  	$push119=, $pop118, $pop418
	br_if   	0, $pop119      # 0: down to label0
# %bb.35:                               # %for.cond77.7
	i32.const	$push423=, 2
	i32.xor 	$push127=, $2, $pop423
	i32.const	$push422=, 65535
	i32.and 	$3=, $pop127, $pop422
	i32.ne  	$push128=, $3, $3
	br_if   	0, $pop128      # 0: down to label0
# %bb.36:                               # %for.cond77.7
	i32.const	$push425=, 1
	i32.const	$push424=, 2
	i32.or  	$push120=, $pop425, $pop424
	i32.const	$push129=, 3
	i32.ne  	$push130=, $pop120, $pop129
	br_if   	0, $pop130      # 0: down to label0
# %bb.37:                               # %for.cond77.7
	i32.const	$push427=, 2
	i32.const	$push426=, 2
	i32.xor 	$push121=, $pop427, $pop426
	br_if   	0, $pop121      # 0: down to label0
# %bb.38:                               # %for.cond77.7
	i32.const	$push429=, 3
	i32.const	$push428=, 2
	i32.xor 	$push122=, $pop429, $pop428
	i32.const	$push131=, 1
	i32.ne  	$push132=, $pop122, $pop131
	br_if   	0, $pop132      # 0: down to label0
# %bb.39:                               # %for.cond77.7
	i32.const	$push431=, 4
	i32.const	$push430=, 2
	i32.xor 	$push123=, $pop431, $pop430
	i32.const	$push133=, 6
	i32.ne  	$push134=, $pop123, $pop133
	br_if   	0, $pop134      # 0: down to label0
# %bb.40:                               # %for.cond77.7
	i32.const	$push433=, 5
	i32.const	$push432=, 2
	i32.xor 	$push124=, $pop433, $pop432
	i32.const	$push135=, 7
	i32.ne  	$push136=, $pop124, $pop135
	br_if   	0, $pop136      # 0: down to label0
# %bb.41:                               # %for.cond77.7
	i32.const	$push435=, 6
	i32.const	$push434=, 2
	i32.xor 	$push125=, $pop435, $pop434
	i32.const	$push137=, 4
	i32.ne  	$push138=, $pop125, $pop137
	br_if   	0, $pop138      # 0: down to label0
# %bb.42:                               # %for.cond77.7
	i32.const	$push437=, 7
	i32.const	$push436=, 2
	i32.xor 	$push126=, $pop437, $pop436
	i32.const	$push139=, 5
	i32.ne  	$push140=, $pop126, $pop139
	br_if   	0, $pop140      # 0: down to label0
# %bb.43:                               # %for.cond97.7
	i32.const	$push440=, 4
	i32.const	$push439=, 5
	i32.or  	$push145=, $pop440, $pop439
	i32.const	$push438=, 2
	i32.and 	$push146=, $pop145, $pop438
	br_if   	0, $pop146      # 0: down to label0
# %bb.44:                               # %for.cond97.7
	i32.const	$push441=, 2
	i32.and 	$3=, $2, $pop441
	i32.ne  	$push147=, $3, $3
	br_if   	0, $pop147      # 0: down to label0
# %bb.45:                               # %for.cond97.7
	i32.const	$push148=, 0
	br_if   	0, $pop148      # 0: down to label0
# %bb.46:                               # %for.cond97.7
	i32.const	$push444=, 2
	i32.const	$push443=, 2
	i32.and 	$push141=, $pop444, $pop443
	i32.const	$push442=, 2
	i32.ne  	$push149=, $pop141, $pop442
	br_if   	0, $pop149      # 0: down to label0
# %bb.47:                               # %for.cond97.7
	i32.const	$push447=, 3
	i32.const	$push446=, 2
	i32.and 	$push142=, $pop447, $pop446
	i32.const	$push445=, 2
	i32.ne  	$push150=, $pop142, $pop445
	br_if   	0, $pop150      # 0: down to label0
# %bb.48:                               # %for.cond97.7
	i32.const	$push450=, 6
	i32.const	$push449=, 2
	i32.and 	$push143=, $pop450, $pop449
	i32.const	$push448=, 2
	i32.ne  	$push151=, $pop143, $pop448
	br_if   	0, $pop151      # 0: down to label0
# %bb.49:                               # %for.cond97.7
	i32.const	$push453=, 7
	i32.const	$push452=, 2
	i32.and 	$push144=, $pop453, $pop452
	i32.const	$push451=, 2
	i32.ne  	$push152=, $pop144, $pop451
	br_if   	0, $pop152      # 0: down to label0
# %bb.50:                               # %for.cond117.7
	i32.const	$push454=, 2
	i32.or  	$push160=, $2, $pop454
	i32.const	$push161=, 65535
	i32.and 	$3=, $pop160, $pop161
	i32.ne  	$push162=, $3, $3
	br_if   	0, $pop162      # 0: down to label0
# %bb.51:                               # %for.cond117.7
	i32.const	$push456=, 1
	i32.const	$push455=, 2
	i32.or  	$push153=, $pop456, $pop455
	i32.const	$push163=, 3
	i32.ne  	$push164=, $pop153, $pop163
	br_if   	0, $pop164      # 0: down to label0
# %bb.52:                               # %for.cond117.7
	i32.const	$push458=, 2
	i32.const	$push457=, 2
	i32.or  	$push154=, $pop458, $pop457
	i32.const	$push165=, 2
	i32.ne  	$push166=, $pop154, $pop165
	br_if   	0, $pop166      # 0: down to label0
# %bb.53:                               # %for.cond117.7
	i32.const	$push460=, 3
	i32.const	$push459=, 2
	i32.or  	$push155=, $pop460, $pop459
	i32.const	$push167=, 3
	i32.ne  	$push168=, $pop155, $pop167
	br_if   	0, $pop168      # 0: down to label0
# %bb.54:                               # %for.cond117.7
	i32.const	$push462=, 4
	i32.const	$push461=, 2
	i32.or  	$push156=, $pop462, $pop461
	i32.const	$push169=, 6
	i32.ne  	$push170=, $pop156, $pop169
	br_if   	0, $pop170      # 0: down to label0
# %bb.55:                               # %for.cond117.7
	i32.const	$push464=, 5
	i32.const	$push463=, 2
	i32.or  	$push157=, $pop464, $pop463
	i32.const	$push171=, 7
	i32.ne  	$push172=, $pop157, $pop171
	br_if   	0, $pop172      # 0: down to label0
# %bb.56:                               # %for.cond117.7
	i32.const	$push466=, 6
	i32.const	$push465=, 2
	i32.or  	$push158=, $pop466, $pop465
	i32.const	$push173=, 6
	i32.ne  	$push174=, $pop158, $pop173
	br_if   	0, $pop174      # 0: down to label0
# %bb.57:                               # %for.cond117.7
	i32.const	$push468=, 7
	i32.const	$push467=, 2
	i32.or  	$push159=, $pop468, $pop467
	i32.const	$push175=, 7
	i32.ne  	$push176=, $pop159, $pop175
	br_if   	0, $pop176      # 0: down to label0
# %bb.58:                               # %for.cond137.7
	i32.const	$push472=, 2
	i32.shl 	$push184=, $pop472, $4
	i32.const	$push471=, 2
	i32.const	$push470=, 65535
	i32.and 	$push185=, $2, $pop470
	i32.shl 	$push186=, $pop471, $pop185
	i32.const	$push187=, 16
	i32.shl 	$push188=, $pop186, $pop187
	i32.const	$push469=, 16
	i32.shr_s	$push189=, $pop188, $pop469
	i32.ne  	$push190=, $pop184, $pop189
	br_if   	0, $pop190      # 0: down to label0
# %bb.59:                               # %for.cond137.7
	i32.const	$push475=, 2
	i32.const	$push474=, 1
	i32.shl 	$push177=, $pop475, $pop474
	i32.const	$push473=, 65535
	i32.and 	$push197=, $pop177, $pop473
	i32.const	$push198=, 4
	i32.ne  	$push199=, $pop197, $pop198
	br_if   	0, $pop199      # 0: down to label0
# %bb.60:                               # %for.cond137.7
	i32.const	$push479=, 2
	i32.const	$push478=, 2
	i32.const	$push477=, 65535
	i32.and 	$push191=, $pop478, $pop477
	i32.shl 	$push178=, $pop479, $pop191
	i32.const	$push476=, 65535
	i32.and 	$push200=, $pop178, $pop476
	i32.const	$push201=, 8
	i32.ne  	$push202=, $pop200, $pop201
	br_if   	0, $pop202      # 0: down to label0
# %bb.61:                               # %for.cond137.7
	i32.const	$push483=, 2
	i32.const	$push482=, 3
	i32.const	$push481=, 65535
	i32.and 	$push192=, $pop482, $pop481
	i32.shl 	$push179=, $pop483, $pop192
	i32.const	$push480=, 65535
	i32.and 	$push203=, $pop179, $pop480
	i32.const	$push204=, 16
	i32.ne  	$push205=, $pop203, $pop204
	br_if   	0, $pop205      # 0: down to label0
# %bb.62:                               # %for.cond137.7
	i32.const	$push487=, 2
	i32.const	$push486=, 4
	i32.const	$push485=, 65535
	i32.and 	$push193=, $pop486, $pop485
	i32.shl 	$push180=, $pop487, $pop193
	i32.const	$push484=, 65535
	i32.and 	$push206=, $pop180, $pop484
	i32.const	$push207=, 32
	i32.ne  	$push208=, $pop206, $pop207
	br_if   	0, $pop208      # 0: down to label0
# %bb.63:                               # %for.cond137.7
	i32.const	$push491=, 2
	i32.const	$push490=, 5
	i32.const	$push489=, 65535
	i32.and 	$push194=, $pop490, $pop489
	i32.shl 	$push181=, $pop491, $pop194
	i32.const	$push488=, 65535
	i32.and 	$push209=, $pop181, $pop488
	i32.const	$push210=, 64
	i32.ne  	$push211=, $pop209, $pop210
	br_if   	0, $pop211      # 0: down to label0
# %bb.64:                               # %for.cond137.7
	i32.const	$push495=, 2
	i32.const	$push494=, 6
	i32.const	$push493=, 65535
	i32.and 	$push195=, $pop494, $pop493
	i32.shl 	$push182=, $pop495, $pop195
	i32.const	$push492=, 65535
	i32.and 	$push212=, $pop182, $pop492
	i32.const	$push213=, 128
	i32.ne  	$push214=, $pop212, $pop213
	br_if   	0, $pop214      # 0: down to label0
# %bb.65:                               # %for.cond137.7
	i32.const	$push499=, 2
	i32.const	$push498=, 7
	i32.const	$push497=, 65535
	i32.and 	$push196=, $pop498, $pop497
	i32.shl 	$push183=, $pop499, $pop196
	i32.const	$push496=, 65535
	i32.and 	$push215=, $pop183, $pop496
	i32.const	$push216=, 256
	i32.ne  	$push217=, $pop215, $pop216
	br_if   	0, $pop217      # 0: down to label0
# %bb.66:                               # %for.cond157.7
	i32.const	$push518=, 2
	i32.const	$push517=, 2
	i32.const	$push516=, 65535
	i32.and 	$push221=, $pop517, $pop516
	i32.shr_u	$push222=, $pop518, $pop221
	i32.const	$push515=, 2
	i32.const	$push514=, 3
	i32.const	$push513=, 65535
	i32.and 	$push223=, $pop514, $pop513
	i32.shr_u	$push224=, $pop515, $pop223
	i32.or  	$push225=, $pop222, $pop224
	i32.const	$push512=, 2
	i32.const	$push511=, 4
	i32.const	$push510=, 65535
	i32.and 	$push226=, $pop511, $pop510
	i32.shr_u	$push227=, $pop512, $pop226
	i32.or  	$push228=, $pop225, $pop227
	i32.const	$push509=, 2
	i32.const	$push508=, 5
	i32.const	$push507=, 65535
	i32.and 	$push229=, $pop508, $pop507
	i32.shr_u	$push230=, $pop509, $pop229
	i32.or  	$push231=, $pop228, $pop230
	i32.const	$push506=, 2
	i32.const	$push505=, 6
	i32.const	$push504=, 65535
	i32.and 	$push232=, $pop505, $pop504
	i32.shr_u	$push233=, $pop506, $pop232
	i32.or  	$push234=, $pop231, $pop233
	i32.const	$push503=, 2
	i32.const	$push502=, 7
	i32.const	$push501=, 65535
	i32.and 	$push235=, $pop502, $pop501
	i32.shr_u	$push236=, $pop503, $pop235
	i32.or  	$push237=, $pop234, $pop236
	i32.const	$push500=, 65535
	i32.and 	$push238=, $pop237, $pop500
	br_if   	0, $pop238      # 0: down to label0
# %bb.67:                               # %for.cond157.7
	i32.const	$push522=, 2
	i32.shr_u	$push218=, $pop522, $4
	i32.const	$push521=, 2
	i32.const	$push520=, 65535
	i32.and 	$push239=, $2, $pop520
	i32.shr_u	$push240=, $pop521, $pop239
	i32.const	$push241=, 16
	i32.shl 	$push242=, $pop240, $pop241
	i32.const	$push519=, 16
	i32.shr_s	$push219=, $pop242, $pop519
	i32.ne  	$push243=, $pop218, $pop219
	br_if   	0, $pop243      # 0: down to label0
# %bb.68:                               # %for.cond157.7
	i32.const	$push524=, 2
	i32.const	$push523=, 1
	i32.shr_u	$push220=, $pop524, $pop523
	i32.const	$push244=, 65535
	i32.and 	$push245=, $pop220, $pop244
	i32.const	$push246=, 1
	i32.ne  	$push247=, $pop245, $pop246
	br_if   	0, $pop247      # 0: down to label0
# %bb.69:                               # %for.cond198.7
	i32.const	$push526=, -2
	i32.add 	$push255=, $4, $pop526
	i32.const	$push256=, 16
	i32.shl 	$push257=, $2, $pop256
	i32.const	$push258=, -131072
	i32.add 	$push259=, $pop257, $pop258
	i32.const	$push525=, 16
	i32.shr_s	$push260=, $pop259, $pop525
	i32.ne  	$push261=, $pop255, $pop260
	br_if   	0, $pop261      # 0: down to label0
# %bb.70:                               # %for.cond198.7
	i32.const	$push528=, 1
	i32.const	$push527=, -2
	i32.or  	$push248=, $pop528, $pop527
	i32.const	$push262=, -1
	i32.ne  	$push263=, $pop248, $pop262
	br_if   	0, $pop263      # 0: down to label0
# %bb.71:                               # %for.cond198.7
	i32.const	$push530=, 2
	i32.const	$push529=, -2
	i32.add 	$push249=, $pop530, $pop529
	br_if   	0, $pop249      # 0: down to label0
# %bb.72:                               # %for.cond198.7
	i32.const	$push532=, 3
	i32.const	$push531=, -2
	i32.add 	$push250=, $pop532, $pop531
	i32.const	$push264=, 1
	i32.ne  	$push265=, $pop250, $pop264
	br_if   	0, $pop265      # 0: down to label0
# %bb.73:                               # %for.cond198.7
	i32.const	$push534=, 4
	i32.const	$push533=, -2
	i32.add 	$push251=, $pop534, $pop533
	i32.const	$push266=, 2
	i32.ne  	$push267=, $pop251, $pop266
	br_if   	0, $pop267      # 0: down to label0
# %bb.74:                               # %for.cond198.7
	i32.const	$push536=, 5
	i32.const	$push535=, -2
	i32.add 	$push252=, $pop536, $pop535
	i32.const	$push268=, 3
	i32.ne  	$push269=, $pop252, $pop268
	br_if   	0, $pop269      # 0: down to label0
# %bb.75:                               # %for.cond198.7
	i32.const	$push538=, 6
	i32.const	$push537=, -2
	i32.add 	$push253=, $pop538, $pop537
	i32.const	$push270=, 4
	i32.ne  	$push271=, $pop253, $pop270
	br_if   	0, $pop271      # 0: down to label0
# %bb.76:                               # %for.cond198.7
	i32.const	$push540=, 7
	i32.const	$push539=, -2
	i32.add 	$push254=, $pop540, $pop539
	i32.const	$push272=, 5
	i32.ne  	$push273=, $pop254, $pop272
	br_if   	0, $pop273      # 0: down to label0
# %bb.77:                               # %for.cond240.7
	i32.const	$push274=, 16
	i32.shl 	$push275=, $2, $pop274
	i32.const	$push555=, 16
	i32.shr_s	$3=, $pop275, $pop555
	i32.const	$push276=, 2
	i32.div_s	$7=, $3, $pop276
	i32.const	$push554=, 2
	i32.const	$push553=, 2
	i32.div_s	$8=, $pop554, $pop553
	i32.const	$push552=, 3
	i32.const	$push551=, 2
	i32.div_s	$9=, $pop552, $pop551
	i32.const	$push550=, 4
	i32.const	$push549=, 2
	i32.div_s	$10=, $pop550, $pop549
	i32.const	$push548=, 5
	i32.const	$push547=, 2
	i32.div_s	$11=, $pop548, $pop547
	i32.const	$push546=, 6
	i32.const	$push545=, 2
	i32.div_s	$12=, $pop546, $pop545
	i32.const	$push544=, 7
	i32.const	$push543=, 2
	i32.div_s	$6=, $pop544, $pop543
	i32.const	$push542=, 2
	i32.div_s	$push279=, $3, $pop542
	i32.const	$push277=, 65535
	i32.and 	$push280=, $pop279, $pop277
	i32.const	$push541=, 65535
	i32.and 	$push278=, $7, $pop541
	i32.ne  	$push281=, $pop280, $pop278
	br_if   	0, $pop281      # 0: down to label0
# %bb.78:                               # %for.cond240.7
	i32.const	$push282=, 0
	br_if   	0, $pop282      # 0: down to label0
# %bb.79:                               # %for.cond240.7
	i32.const	$push557=, 65535
	i32.and 	$push283=, $8, $pop557
	i32.const	$push556=, 1
	i32.ne  	$push284=, $pop283, $pop556
	br_if   	0, $pop284      # 0: down to label0
# %bb.80:                               # %for.cond240.7
	i32.const	$push559=, 65535
	i32.and 	$push285=, $9, $pop559
	i32.const	$push558=, 1
	i32.ne  	$push286=, $pop285, $pop558
	br_if   	0, $pop286      # 0: down to label0
# %bb.81:                               # %for.cond240.7
	i32.const	$push561=, 65535
	i32.and 	$push287=, $10, $pop561
	i32.const	$push560=, 2
	i32.ne  	$push288=, $pop287, $pop560
	br_if   	0, $pop288      # 0: down to label0
# %bb.82:                               # %for.cond240.7
	i32.const	$push563=, 65535
	i32.and 	$push289=, $11, $pop563
	i32.const	$push562=, 2
	i32.ne  	$push290=, $pop289, $pop562
	br_if   	0, $pop290      # 0: down to label0
# %bb.83:                               # %for.cond240.7
	i32.const	$push565=, 65535
	i32.and 	$push291=, $12, $pop565
	i32.const	$push564=, 3
	i32.ne  	$push292=, $pop291, $pop564
	br_if   	0, $pop292      # 0: down to label0
# %bb.84:                               # %for.cond240.7
	i32.const	$push567=, 65535
	i32.and 	$push293=, $6, $pop567
	i32.const	$push566=, 3
	i32.ne  	$push294=, $pop293, $pop566
	br_if   	0, $pop294      # 0: down to label0
# %bb.85:                               # %for.cond261.7
	i32.const	$push301=, 2
	i32.rem_s	$push302=, $4, $pop301
	i32.const	$push569=, 1
	i32.shl 	$push303=, $7, $pop569
	i32.sub 	$push304=, $2, $pop303
	i32.const	$push305=, 16
	i32.shl 	$push306=, $pop304, $pop305
	i32.const	$push568=, 16
	i32.shr_s	$push307=, $pop306, $pop568
	i32.ne  	$push308=, $pop302, $pop307
	br_if   	0, $pop308      # 0: down to label0
# %bb.86:                               # %for.cond261.7
	i32.const	$push570=, 1
	i32.eqz 	$push589=, $pop570
	br_if   	0, $pop589      # 0: down to label0
# %bb.87:                               # %for.cond261.7
	i32.const	$push573=, 2
	i32.const	$push572=, 1
	i32.shl 	$push309=, $8, $pop572
	i32.sub 	$push295=, $pop573, $pop309
	i32.const	$push571=, 65535
	i32.and 	$push315=, $pop295, $pop571
	br_if   	0, $pop315      # 0: down to label0
# %bb.88:                               # %for.cond261.7
	i32.const	$push576=, 3
	i32.const	$push575=, 1
	i32.shl 	$push310=, $9, $pop575
	i32.sub 	$push296=, $pop576, $pop310
	i32.const	$push574=, 65535
	i32.and 	$push316=, $pop296, $pop574
	i32.const	$push317=, 1
	i32.ne  	$push318=, $pop316, $pop317
	br_if   	0, $pop318      # 0: down to label0
# %bb.89:                               # %for.cond261.7
	i32.const	$push579=, 4
	i32.const	$push578=, 1
	i32.shl 	$push311=, $10, $pop578
	i32.sub 	$push297=, $pop579, $pop311
	i32.const	$push577=, 65535
	i32.and 	$push319=, $pop297, $pop577
	br_if   	0, $pop319      # 0: down to label0
# %bb.90:                               # %for.cond261.7
	i32.const	$push582=, 5
	i32.const	$push581=, 1
	i32.shl 	$push312=, $11, $pop581
	i32.sub 	$push298=, $pop582, $pop312
	i32.const	$push580=, 65535
	i32.and 	$push320=, $pop298, $pop580
	i32.const	$push321=, 1
	i32.ne  	$push322=, $pop320, $pop321
	br_if   	0, $pop322      # 0: down to label0
# %bb.91:                               # %for.cond261.7
	i32.const	$push585=, 6
	i32.const	$push584=, 1
	i32.shl 	$push313=, $12, $pop584
	i32.sub 	$push299=, $pop585, $pop313
	i32.const	$push583=, 65535
	i32.and 	$push323=, $pop299, $pop583
	br_if   	0, $pop323      # 0: down to label0
# %bb.92:                               # %for.cond261.7
	i32.const	$push588=, 7
	i32.const	$push587=, 1
	i32.shl 	$push314=, $6, $pop587
	i32.sub 	$push300=, $pop588, $pop314
	i32.const	$push586=, 65535
	i32.and 	$push324=, $pop300, $pop586
	i32.const	$push325=, 1
	i32.ne  	$push326=, $pop324, $pop325
	br_if   	0, $pop326      # 0: down to label0
# %bb.93:                               # %for.cond667.1
	i32.const	$push327=, 0
	return  	$pop327
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
