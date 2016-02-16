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
	i32.const	$push3=, 0
	i32.const	$push257=, 0
	i32.load16_u	$push256=, j+14($pop257)
	tee_local	$push255=, $23=, $pop256
	i32.const	$push254=, 0
	i32.load16_u	$push253=, i+14($pop254)
	tee_local	$push252=, $22=, $pop253
	i32.add 	$push8=, $pop255, $pop252
	i32.store16	$4=, k+14($pop3), $pop8
	i32.const	$push251=, 0
	i32.load16_u	$5=, i+12($pop251):p2align=2
	i32.const	$push250=, 0
	i32.load16_u	$11=, j+12($pop250):p2align=2
	i32.const	$push249=, 0
	i32.store16	$discard=, res+14($pop249), $4
	i32.const	$push248=, 0
	i32.load16_u	$4=, i+10($pop248)
	i32.const	$push247=, 0
	i32.load16_u	$10=, j+10($pop247)
	i32.const	$push246=, 0
	i32.const	$push245=, 0
	i32.add 	$push7=, $11, $5
	i32.store16	$push9=, k+12($pop245):p2align=2, $pop7
	i32.store16	$discard=, res+12($pop246):p2align=2, $pop9
	i32.const	$push244=, 0
	i32.add 	$push6=, $10, $4
	i32.store16	$2=, k+10($pop244), $pop6
	i32.const	$push243=, 0
	i32.load16_u	$3=, i+8($pop243):p2align=3
	i32.const	$push242=, 0
	i32.load16_u	$9=, j+8($pop242):p2align=3
	i32.const	$push241=, 0
	i32.store16	$discard=, res+10($pop241), $2
	i32.const	$push240=, 0
	i32.load16_u	$2=, i+6($pop240)
	i32.const	$push239=, 0
	i32.load16_u	$8=, j+6($pop239)
	i32.const	$push238=, 0
	i32.const	$push237=, 0
	i32.add 	$push5=, $9, $3
	i32.store16	$push10=, k+8($pop237):p2align=3, $pop5
	i32.store16	$discard=, res+8($pop238):p2align=3, $pop10
	i32.const	$push236=, 0
	i32.add 	$push2=, $8, $2
	i32.store16	$12=, k+6($pop236), $pop2
	i32.const	$push235=, 0
	i32.load16_u	$1=, i+2($pop235)
	i32.const	$push234=, 0
	i32.load16_u	$0=, i($pop234):p2align=4
	i32.const	$push233=, 0
	i32.load16_u	$7=, j+2($pop233)
	i32.const	$push232=, 0
	i32.load16_u	$6=, j($pop232):p2align=4
	i32.const	$push231=, 0
	i32.const	$push230=, 0
	i32.load16_u	$push229=, j+4($pop230):p2align=2
	tee_local	$push228=, $21=, $pop229
	i32.const	$push227=, 0
	i32.load16_u	$push226=, i+4($pop227):p2align=2
	tee_local	$push225=, $20=, $pop226
	i32.add 	$push1=, $pop228, $pop225
	i32.store16	$13=, k+4($pop231):p2align=2, $pop1
	i32.const	$push224=, 0
	i32.add 	$push0=, $7, $1
	i32.store16	$14=, k+2($pop224), $pop0
	i32.const	$push223=, 0
	i32.add 	$push4=, $6, $0
	i32.store16	$15=, k($pop223):p2align=4, $pop4
	i32.const	$push222=, 0
	i32.store16	$16=, res+6($pop222), $12
	i32.const	$push221=, 0
	i32.store16	$discard=, res+4($pop221):p2align=2, $13
	i32.const	$push220=, 0
	i32.store16	$12=, res+2($pop220), $14
	block
	block
	block
	block
	block
	block
	block
	block
	i32.const	$push219=, 0
	i32.store16	$push11=, res($pop219):p2align=4, $15
	i32.const	$push218=, 65535
	i32.and 	$push12=, $pop11, $pop218
	i32.const	$push13=, 160
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label8
# BB#1:                                 # %entry
	i32.const	$push258=, 65535
	i32.and 	$push15=, $12, $pop258
	i32.const	$push16=, 113
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label8
# BB#2:                                 # %entry
	i32.const	$push259=, 65535
	i32.and 	$push18=, $13, $pop259
	i32.const	$push19=, 170
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label8
# BB#3:                                 # %entry
	i32.const	$push260=, 65535
	i32.and 	$push21=, $16, $pop260
	i32.const	$push22=, 230
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label8
# BB#4:                                 # %verify.exit
	i32.const	$push32=, 0
	i32.mul 	$push31=, $6, $0
	i32.store16	$12=, k($pop32):p2align=4, $pop31
	i32.const	$push276=, 0
	i32.mul 	$push24=, $7, $1
	i32.store16	$13=, k+2($pop276), $pop24
	i32.const	$push275=, 0
	i32.mul 	$push25=, $21, $20
	i32.store16	$14=, k+4($pop275):p2align=2, $pop25
	i32.const	$push274=, 0
	i32.mul 	$push26=, $8, $2
	i32.store16	$15=, k+6($pop274), $pop26
	i32.const	$push273=, 0
	i32.mul 	$push30=, $9, $3
	i32.store16	$16=, k+8($pop273):p2align=3, $pop30
	i32.const	$push272=, 0
	i32.store16	$discard=, res($pop272):p2align=4, $12
	i32.const	$push271=, 0
	i32.store16	$discard=, res+2($pop271), $13
	i32.const	$push270=, 0
	i32.store16	$discard=, res+4($pop270):p2align=2, $14
	i32.const	$push269=, 0
	i32.store16	$discard=, res+6($pop269), $15
	i32.const	$push268=, 0
	i32.store16	$discard=, res+8($pop268):p2align=3, $16
	i32.const	$push267=, 0
	i32.const	$push266=, 0
	i32.mul 	$push29=, $10, $4
	i32.store16	$push33=, k+10($pop266), $pop29
	i32.store16	$discard=, res+10($pop267), $pop33
	i32.const	$push265=, 0
	i32.const	$push264=, 0
	i32.mul 	$push28=, $11, $5
	i32.store16	$push34=, k+12($pop264):p2align=2, $pop28
	i32.store16	$discard=, res+12($pop265):p2align=2, $pop34
	i32.const	$push263=, 0
	i32.const	$push262=, 0
	i32.mul 	$push27=, $23, $22
	i32.store16	$push35=, k+14($pop262), $pop27
	i32.store16	$discard=, res+14($pop263), $pop35
	i32.const	$push261=, 65535
	i32.and 	$push36=, $12, $pop261
	i32.const	$push37=, 1500
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	1, $pop38       # 1: down to label7
# BB#5:                                 # %verify.exit
	i32.const	$push277=, 65535
	i32.and 	$push39=, $13, $pop277
	i32.const	$push40=, 1300
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	1, $pop41       # 1: down to label7
# BB#6:                                 # %verify.exit
	i32.const	$push278=, 65535
	i32.and 	$push42=, $14, $pop278
	i32.const	$push43=, 3000
	i32.ne  	$push44=, $pop42, $pop43
	br_if   	1, $pop44       # 1: down to label7
# BB#7:                                 # %verify.exit
	i32.const	$push279=, 65535
	i32.and 	$push45=, $15, $pop279
	i32.const	$push46=, 6000
	i32.ne  	$push47=, $pop45, $pop46
	br_if   	1, $pop47       # 1: down to label7
# BB#8:                                 # %verify.exit40
	i32.const	$push48=, 16
	i32.shl 	$push51=, $22, $pop48
	i32.const	$push326=, 16
	i32.shr_s	$push52=, $pop51, $pop326
	i32.const	$push325=, 16
	i32.shl 	$push49=, $23, $pop325
	i32.const	$push324=, 16
	i32.shr_s	$push50=, $pop49, $pop324
	i32.div_s	$12=, $pop52, $pop50
	i32.const	$push323=, 16
	i32.shl 	$push55=, $5, $pop323
	i32.const	$push322=, 16
	i32.shr_s	$push56=, $pop55, $pop322
	i32.const	$push321=, 16
	i32.shl 	$push53=, $11, $pop321
	i32.const	$push320=, 16
	i32.shr_s	$push54=, $pop53, $pop320
	i32.div_s	$13=, $pop56, $pop54
	i32.const	$push319=, 16
	i32.shl 	$push59=, $4, $pop319
	i32.const	$push318=, 16
	i32.shr_s	$push60=, $pop59, $pop318
	i32.const	$push317=, 16
	i32.shl 	$push57=, $10, $pop317
	i32.const	$push316=, 16
	i32.shr_s	$push58=, $pop57, $pop316
	i32.div_s	$14=, $pop60, $pop58
	i32.const	$push315=, 16
	i32.shl 	$push63=, $3, $pop315
	i32.const	$push314=, 16
	i32.shr_s	$push64=, $pop63, $pop314
	i32.const	$push313=, 16
	i32.shl 	$push61=, $9, $pop313
	i32.const	$push312=, 16
	i32.shr_s	$push62=, $pop61, $pop312
	i32.div_s	$15=, $pop64, $pop62
	i32.const	$push311=, 16
	i32.shl 	$push67=, $2, $pop311
	i32.const	$push310=, 16
	i32.shr_s	$push68=, $pop67, $pop310
	i32.const	$push309=, 16
	i32.shl 	$push65=, $8, $pop309
	i32.const	$push308=, 16
	i32.shr_s	$push66=, $pop65, $pop308
	i32.div_s	$16=, $pop68, $pop66
	i32.const	$push307=, 16
	i32.shl 	$push71=, $20, $pop307
	i32.const	$push306=, 16
	i32.shr_s	$push72=, $pop71, $pop306
	i32.const	$push305=, 16
	i32.shl 	$push69=, $21, $pop305
	i32.const	$push304=, 16
	i32.shr_s	$push70=, $pop69, $pop304
	i32.div_s	$18=, $pop72, $pop70
	i32.const	$push303=, 16
	i32.shl 	$push75=, $1, $pop303
	i32.const	$push302=, 16
	i32.shr_s	$push76=, $pop75, $pop302
	i32.const	$push301=, 16
	i32.shl 	$push73=, $7, $pop301
	i32.const	$push300=, 16
	i32.shr_s	$push74=, $pop73, $pop300
	i32.div_s	$17=, $pop76, $pop74
	i32.const	$push82=, 0
	i32.const	$push299=, 16
	i32.shl 	$push79=, $0, $pop299
	i32.const	$push298=, 16
	i32.shr_s	$push80=, $pop79, $pop298
	i32.const	$push297=, 16
	i32.shl 	$push77=, $6, $pop297
	i32.const	$push296=, 16
	i32.shr_s	$push78=, $pop77, $pop296
	i32.div_s	$push81=, $pop80, $pop78
	i32.store16	$19=, k($pop82):p2align=4, $pop81
	i32.const	$push295=, 0
	i32.store16	$discard=, k+2($pop295), $17
	i32.const	$push294=, 0
	i32.store16	$discard=, k+4($pop294):p2align=2, $18
	i32.const	$push293=, 0
	i32.store16	$discard=, k+6($pop293), $16
	i32.const	$push292=, 0
	i32.store16	$discard=, k+8($pop292):p2align=3, $15
	i32.const	$push291=, 0
	i32.store16	$discard=, res($pop291):p2align=4, $19
	i32.const	$push290=, 0
	i32.store16	$discard=, res+2($pop290), $17
	i32.const	$push289=, 0
	i32.store16	$discard=, res+4($pop289):p2align=2, $18
	i32.const	$push288=, 0
	i32.store16	$discard=, res+6($pop288), $16
	i32.const	$push287=, 0
	i32.store16	$discard=, res+8($pop287):p2align=3, $15
	i32.const	$push286=, 0
	i32.const	$push285=, 0
	i32.store16	$push83=, k+10($pop285), $14
	i32.store16	$discard=, res+10($pop286), $pop83
	i32.const	$push284=, 0
	i32.const	$push283=, 0
	i32.store16	$push84=, k+12($pop283):p2align=2, $13
	i32.store16	$discard=, res+12($pop284):p2align=2, $pop84
	i32.const	$push282=, 0
	i32.const	$push281=, 0
	i32.store16	$push85=, k+14($pop281), $12
	i32.store16	$discard=, res+14($pop282), $pop85
	i32.const	$push280=, 65535
	i32.and 	$push86=, $19, $pop280
	i32.const	$push87=, 15
	i32.ne  	$push88=, $pop86, $pop87
	br_if   	2, $pop88       # 2: down to label6
# BB#9:                                 # %verify.exit40
	i32.const	$push328=, 65535
	i32.and 	$push89=, $17, $pop328
	i32.const	$push327=, 7
	i32.ne  	$push90=, $pop89, $pop327
	br_if   	2, $pop90       # 2: down to label6
# BB#10:                                # %verify.exit40
	i32.const	$push330=, 65535
	i32.and 	$push91=, $18, $pop330
	i32.const	$push329=, 7
	i32.ne  	$push92=, $pop91, $pop329
	br_if   	2, $pop92       # 2: down to label6
# BB#11:                                # %verify.exit40
	i32.const	$push331=, 65535
	i32.and 	$push93=, $16, $pop331
	i32.const	$push94=, 6
	i32.ne  	$push95=, $pop93, $pop94
	br_if   	2, $pop95       # 2: down to label6
# BB#12:                                # %verify.exit49
	i32.const	$push104=, 0
	i32.and 	$push103=, $6, $0
	i32.store16	$12=, k($pop104):p2align=4, $pop103
	i32.const	$push347=, 0
	i32.and 	$push96=, $7, $1
	i32.store16	$13=, k+2($pop347), $pop96
	i32.const	$push346=, 0
	i32.and 	$push97=, $21, $20
	i32.store16	$14=, k+4($pop346):p2align=2, $pop97
	i32.const	$push345=, 0
	i32.and 	$push98=, $8, $2
	i32.store16	$15=, k+6($pop345), $pop98
	i32.const	$push344=, 0
	i32.and 	$push102=, $9, $3
	i32.store16	$16=, k+8($pop344):p2align=3, $pop102
	i32.const	$push343=, 0
	i32.store16	$discard=, res($pop343):p2align=4, $12
	i32.const	$push342=, 0
	i32.store16	$discard=, res+2($pop342), $13
	i32.const	$push341=, 0
	i32.store16	$discard=, res+4($pop341):p2align=2, $14
	i32.const	$push340=, 0
	i32.store16	$discard=, res+6($pop340), $15
	i32.const	$push339=, 0
	i32.store16	$discard=, res+8($pop339):p2align=3, $16
	i32.const	$push338=, 0
	i32.const	$push337=, 0
	i32.and 	$push101=, $10, $4
	i32.store16	$push105=, k+10($pop337), $pop101
	i32.store16	$discard=, res+10($pop338), $pop105
	i32.const	$push336=, 0
	i32.const	$push335=, 0
	i32.and 	$push100=, $11, $5
	i32.store16	$push106=, k+12($pop335):p2align=2, $pop100
	i32.store16	$discard=, res+12($pop336):p2align=2, $pop106
	i32.const	$push334=, 0
	i32.const	$push333=, 0
	i32.and 	$push99=, $23, $22
	i32.store16	$push107=, k+14($pop333), $pop99
	i32.store16	$discard=, res+14($pop334), $pop107
	i32.const	$push332=, 65535
	i32.and 	$push108=, $12, $pop332
	i32.const	$push109=, 2
	i32.ne  	$push110=, $pop108, $pop109
	br_if   	3, $pop110      # 3: down to label5
# BB#13:                                # %verify.exit49
	i32.const	$push348=, 65535
	i32.and 	$push111=, $13, $pop348
	i32.const	$push112=, 4
	i32.ne  	$push113=, $pop111, $pop112
	br_if   	3, $pop113      # 3: down to label5
# BB#14:                                # %verify.exit49
	i32.const	$push349=, 65535
	i32.and 	$push114=, $14, $pop349
	i32.const	$push115=, 20
	i32.ne  	$push116=, $pop114, $pop115
	br_if   	3, $pop116      # 3: down to label5
# BB#15:                                # %verify.exit49
	i32.const	$push350=, 65535
	i32.and 	$push117=, $15, $pop350
	i32.const	$push118=, 8
	i32.ne  	$push119=, $pop117, $pop118
	br_if   	3, $pop119      # 3: down to label5
# BB#16:                                # %verify.exit58
	i32.const	$push128=, 0
	i32.or  	$push127=, $6, $0
	i32.store16	$12=, k($pop128):p2align=4, $pop127
	i32.const	$push366=, 0
	i32.or  	$push120=, $7, $1
	i32.store16	$13=, k+2($pop366), $pop120
	i32.const	$push365=, 0
	i32.or  	$push121=, $21, $20
	i32.store16	$14=, k+4($pop365):p2align=2, $pop121
	i32.const	$push364=, 0
	i32.or  	$push122=, $8, $2
	i32.store16	$15=, k+6($pop364), $pop122
	i32.const	$push363=, 0
	i32.or  	$push126=, $9, $3
	i32.store16	$16=, k+8($pop363):p2align=3, $pop126
	i32.const	$push362=, 0
	i32.store16	$discard=, res($pop362):p2align=4, $12
	i32.const	$push361=, 0
	i32.store16	$discard=, res+2($pop361), $13
	i32.const	$push360=, 0
	i32.store16	$discard=, res+4($pop360):p2align=2, $14
	i32.const	$push359=, 0
	i32.store16	$discard=, res+6($pop359), $15
	i32.const	$push358=, 0
	i32.store16	$discard=, res+8($pop358):p2align=3, $16
	i32.const	$push357=, 0
	i32.const	$push356=, 0
	i32.or  	$push125=, $10, $4
	i32.store16	$push129=, k+10($pop356), $pop125
	i32.store16	$discard=, res+10($pop357), $pop129
	i32.const	$push355=, 0
	i32.const	$push354=, 0
	i32.or  	$push124=, $11, $5
	i32.store16	$push130=, k+12($pop354):p2align=2, $pop124
	i32.store16	$discard=, res+12($pop355):p2align=2, $pop130
	i32.const	$push353=, 0
	i32.const	$push352=, 0
	i32.or  	$push123=, $23, $22
	i32.store16	$push131=, k+14($pop352), $pop123
	i32.store16	$discard=, res+14($pop353), $pop131
	i32.const	$push351=, 65535
	i32.and 	$push132=, $12, $pop351
	i32.const	$push133=, 158
	i32.ne  	$push134=, $pop132, $pop133
	br_if   	4, $pop134      # 4: down to label4
# BB#17:                                # %verify.exit58
	i32.const	$push367=, 65535
	i32.and 	$push135=, $13, $pop367
	i32.const	$push136=, 109
	i32.ne  	$push137=, $pop135, $pop136
	br_if   	4, $pop137      # 4: down to label4
# BB#18:                                # %verify.exit58
	i32.const	$push368=, 65535
	i32.and 	$push138=, $14, $pop368
	i32.const	$push139=, 150
	i32.ne  	$push140=, $pop138, $pop139
	br_if   	4, $pop140      # 4: down to label4
# BB#19:                                # %verify.exit58
	i32.const	$push369=, 65535
	i32.and 	$push141=, $15, $pop369
	i32.const	$push142=, 222
	i32.ne  	$push143=, $pop141, $pop142
	br_if   	4, $pop143      # 4: down to label4
# BB#20:                                # %verify.exit67
	i32.const	$push152=, 0
	i32.xor 	$push151=, $0, $6
	i32.store16	$6=, k($pop152):p2align=4, $pop151
	i32.const	$push385=, 0
	i32.xor 	$push144=, $1, $7
	i32.store16	$7=, k+2($pop385), $pop144
	i32.const	$push384=, 0
	i32.xor 	$push145=, $20, $21
	i32.store16	$12=, k+4($pop384):p2align=2, $pop145
	i32.const	$push383=, 0
	i32.xor 	$push146=, $2, $8
	i32.store16	$8=, k+6($pop383), $pop146
	i32.const	$push382=, 0
	i32.xor 	$push150=, $3, $9
	i32.store16	$9=, k+8($pop382):p2align=3, $pop150
	i32.const	$push381=, 0
	i32.store16	$discard=, res($pop381):p2align=4, $6
	i32.const	$push380=, 0
	i32.store16	$discard=, res+2($pop380), $7
	i32.const	$push379=, 0
	i32.store16	$discard=, res+4($pop379):p2align=2, $12
	i32.const	$push378=, 0
	i32.store16	$discard=, res+6($pop378), $8
	i32.const	$push377=, 0
	i32.store16	$discard=, res+8($pop377):p2align=3, $9
	i32.const	$push376=, 0
	i32.const	$push375=, 0
	i32.xor 	$push149=, $4, $10
	i32.store16	$push153=, k+10($pop375), $pop149
	i32.store16	$discard=, res+10($pop376), $pop153
	i32.const	$push374=, 0
	i32.const	$push373=, 0
	i32.xor 	$push148=, $5, $11
	i32.store16	$push154=, k+12($pop373):p2align=2, $pop148
	i32.store16	$discard=, res+12($pop374):p2align=2, $pop154
	i32.const	$push372=, 0
	i32.const	$push371=, 0
	i32.xor 	$push147=, $22, $23
	i32.store16	$push155=, k+14($pop371), $pop147
	i32.store16	$discard=, res+14($pop372), $pop155
	i32.const	$push370=, 65535
	i32.and 	$push156=, $6, $pop370
	i32.const	$push157=, 156
	i32.ne  	$push158=, $pop156, $pop157
	br_if   	5, $pop158      # 5: down to label3
# BB#21:                                # %verify.exit67
	i32.const	$push386=, 65535
	i32.and 	$push159=, $7, $pop386
	i32.const	$push160=, 105
	i32.ne  	$push161=, $pop159, $pop160
	br_if   	5, $pop161      # 5: down to label3
# BB#22:                                # %verify.exit67
	i32.const	$push387=, 65535
	i32.and 	$push162=, $12, $pop387
	i32.const	$push163=, 130
	i32.ne  	$push164=, $pop162, $pop163
	br_if   	5, $pop164      # 5: down to label3
# BB#23:                                # %verify.exit67
	i32.const	$push388=, 65535
	i32.and 	$push165=, $8, $pop388
	i32.const	$push166=, 214
	i32.ne  	$push167=, $pop165, $pop166
	br_if   	5, $pop167      # 5: down to label3
# BB#24:                                # %verify.exit76
	i32.const	$push171=, 0
	i32.const	$push412=, 0
	i32.sub 	$push176=, $pop412, $0
	i32.store16	$11=, k($pop171):p2align=4, $pop176
	i32.const	$push411=, 0
	i32.const	$push410=, 0
	i32.sub 	$push168=, $pop410, $1
	i32.store16	$10=, k+2($pop411), $pop168
	i32.const	$push409=, 0
	i32.const	$push408=, 0
	i32.sub 	$push169=, $pop408, $20
	i32.store16	$9=, k+4($pop409):p2align=2, $pop169
	i32.const	$push407=, 0
	i32.const	$push406=, 0
	i32.sub 	$push170=, $pop406, $2
	i32.store16	$8=, k+6($pop407), $pop170
	i32.const	$push405=, 0
	i32.const	$push404=, 0
	i32.sub 	$push175=, $pop404, $3
	i32.store16	$7=, k+8($pop405):p2align=3, $pop175
	i32.const	$push403=, 0
	i32.store16	$discard=, res($pop403):p2align=4, $11
	i32.const	$push402=, 0
	i32.store16	$discard=, res+2($pop402), $10
	i32.const	$push401=, 0
	i32.store16	$discard=, res+4($pop401):p2align=2, $9
	i32.const	$push400=, 0
	i32.store16	$discard=, res+6($pop400), $8
	i32.const	$push399=, 0
	i32.store16	$discard=, res+8($pop399):p2align=3, $7
	i32.const	$push398=, 0
	i32.const	$push397=, 0
	i32.const	$push396=, 0
	i32.sub 	$push174=, $pop396, $4
	i32.store16	$push177=, k+10($pop397), $pop174
	i32.store16	$discard=, res+10($pop398), $pop177
	i32.const	$push395=, 0
	i32.const	$push394=, 0
	i32.const	$push393=, 0
	i32.sub 	$push173=, $pop393, $5
	i32.store16	$push178=, k+12($pop394):p2align=2, $pop173
	i32.store16	$discard=, res+12($pop395):p2align=2, $pop178
	i32.const	$push392=, 0
	i32.const	$push391=, 0
	i32.const	$push390=, 0
	i32.sub 	$push172=, $pop390, $22
	i32.store16	$push179=, k+14($pop391), $pop172
	i32.store16	$discard=, res+14($pop392), $pop179
	i32.const	$push389=, 65535
	i32.and 	$push180=, $11, $pop389
	i32.const	$push181=, 65386
	i32.ne  	$push182=, $pop180, $pop181
	br_if   	6, $pop182      # 6: down to label2
# BB#25:                                # %verify.exit76
	i32.const	$push413=, 65535
	i32.and 	$push183=, $10, $pop413
	i32.const	$push184=, 65436
	i32.ne  	$push185=, $pop183, $pop184
	br_if   	6, $pop185      # 6: down to label2
# BB#26:                                # %verify.exit76
	i32.const	$push414=, 65535
	i32.and 	$push186=, $9, $pop414
	i32.const	$push187=, 65386
	i32.ne  	$push188=, $pop186, $pop187
	br_if   	6, $pop188      # 6: down to label2
# BB#27:                                # %verify.exit76
	i32.const	$push415=, 65535
	i32.and 	$push189=, $8, $pop415
	i32.const	$push190=, 65336
	i32.ne  	$push191=, $pop189, $pop190
	br_if   	6, $pop191      # 6: down to label2
# BB#28:                                # %verify.exit85
	i32.const	$push201=, 0
	i32.const	$push195=, -1
	i32.xor 	$push200=, $0, $pop195
	i32.store16	$0=, k($pop201):p2align=4, $pop200
	i32.const	$push438=, 0
	i32.const	$push437=, -1
	i32.xor 	$push192=, $1, $pop437
	i32.store16	$1=, k+2($pop438), $pop192
	i32.const	$push436=, 0
	i32.const	$push435=, -1
	i32.xor 	$push193=, $20, $pop435
	i32.store16	$11=, k+4($pop436):p2align=2, $pop193
	i32.const	$push434=, 0
	i32.const	$push433=, -1
	i32.xor 	$push194=, $2, $pop433
	i32.store16	$2=, k+6($pop434), $pop194
	i32.const	$push432=, 0
	i32.const	$push431=, -1
	i32.xor 	$push199=, $3, $pop431
	i32.store16	$3=, k+8($pop432):p2align=3, $pop199
	i32.const	$push430=, 0
	i32.store16	$discard=, res($pop430):p2align=4, $0
	i32.const	$push429=, 0
	i32.store16	$discard=, res+2($pop429), $1
	i32.const	$push428=, 0
	i32.store16	$discard=, res+4($pop428):p2align=2, $11
	i32.const	$push427=, 0
	i32.store16	$discard=, res+6($pop427), $2
	i32.const	$push426=, 0
	i32.store16	$discard=, res+8($pop426):p2align=3, $3
	i32.const	$push425=, 0
	i32.const	$push424=, 0
	i32.const	$push423=, -1
	i32.xor 	$push198=, $4, $pop423
	i32.store16	$push202=, k+10($pop424), $pop198
	i32.store16	$discard=, res+10($pop425), $pop202
	i32.const	$push422=, 0
	i32.const	$push421=, 0
	i32.const	$push420=, -1
	i32.xor 	$push197=, $5, $pop420
	i32.store16	$push203=, k+12($pop421):p2align=2, $pop197
	i32.store16	$discard=, res+12($pop422):p2align=2, $pop203
	i32.const	$push419=, 0
	i32.const	$push418=, 0
	i32.const	$push417=, -1
	i32.xor 	$push196=, $22, $pop417
	i32.store16	$push204=, k+14($pop418), $pop196
	i32.store16	$discard=, res+14($pop419), $pop204
	i32.const	$push416=, 65535
	i32.and 	$push205=, $0, $pop416
	i32.const	$push206=, 65385
	i32.ne  	$push207=, $pop205, $pop206
	br_if   	7, $pop207      # 7: down to label1
# BB#29:                                # %verify.exit85
	i32.const	$push439=, 65535
	i32.and 	$push208=, $1, $pop439
	i32.const	$push209=, 65435
	i32.ne  	$push210=, $pop208, $pop209
	br_if   	7, $pop210      # 7: down to label1
# BB#30:                                # %verify.exit85
	i32.const	$push440=, 65535
	i32.and 	$push211=, $11, $pop440
	i32.const	$push212=, 65385
	i32.ne  	$push213=, $pop211, $pop212
	br_if   	7, $pop213      # 7: down to label1
# BB#31:                                # %verify.exit85
	i32.const	$push441=, 65535
	i32.and 	$push214=, $2, $pop441
	i32.const	$push215=, 65335
	i32.ne  	$push216=, $pop214, $pop215
	br_if   	7, $pop216      # 7: down to label1
# BB#32:                                # %verify.exit94
	i32.const	$push217=, 0
	call    	exit@FUNCTION, $pop217
	unreachable
.LBB1_33:                               # %if.then.i
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_34:                               # %if.then.i39
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_35:                               # %if.then.i48
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_36:                               # %if.then.i57
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_37:                               # %if.then.i66
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_38:                               # %if.then.i75
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_39:                               # %if.then.i84
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_40:                               # %if.then.i93
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


	.ident	"clang version 3.9.0 "
