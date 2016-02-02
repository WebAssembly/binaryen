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
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %entry
	i32.ne  	$push1=, $1, $5
	br_if   	$pop1, 0        # 0: down to label0
# BB#2:                                 # %entry
	i32.ne  	$push2=, $2, $6
	br_if   	$pop2, 0        # 0: down to label0
# BB#3:                                 # %entry
	i32.ne  	$push3=, $3, $7
	br_if   	$pop3, 0        # 0: down to label0
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
	i32.const	$push7=, 0
	i32.load16_u	$5=, i+12($pop7):p2align=2
	i32.const	$push259=, 0
	i32.load16_u	$11=, j+12($pop259):p2align=2
	i32.const	$push258=, 0
	i32.const	$push257=, 0
	i32.const	$push256=, 0
	i32.load16_u	$push3=, j+14($pop256)
	tee_local	$push255=, $23=, $pop3
	i32.const	$push254=, 0
	i32.load16_u	$push1=, i+14($pop254)
	tee_local	$push253=, $22=, $pop1
	i32.add 	$push12=, $pop255, $pop253
	i32.store16	$push13=, k+14($pop257), $pop12
	i32.store16	$discard=, res+14($pop258), $pop13
	i32.const	$push252=, 0
	i32.load16_u	$4=, i+10($pop252)
	i32.const	$push251=, 0
	i32.load16_u	$10=, j+10($pop251)
	i32.const	$push250=, 0
	i32.const	$push249=, 0
	i32.add 	$push11=, $11, $5
	i32.store16	$push14=, k+12($pop249):p2align=2, $pop11
	i32.store16	$discard=, res+12($pop250):p2align=2, $pop14
	i32.const	$push248=, 0
	i32.load16_u	$3=, i+8($pop248):p2align=3
	i32.const	$push247=, 0
	i32.load16_u	$9=, j+8($pop247):p2align=3
	i32.const	$push246=, 0
	i32.const	$push245=, 0
	i32.add 	$push10=, $10, $4
	i32.store16	$push15=, k+10($pop245), $pop10
	i32.store16	$discard=, res+10($pop246), $pop15
	i32.const	$push244=, 0
	i32.load16_u	$2=, i+6($pop244)
	i32.const	$push243=, 0
	i32.load16_u	$8=, j+6($pop243)
	i32.const	$push242=, 0
	i32.const	$push241=, 0
	i32.add 	$push9=, $9, $3
	i32.store16	$push16=, k+8($pop241):p2align=3, $pop9
	i32.store16	$discard=, res+8($pop242):p2align=3, $pop16
	i32.const	$push240=, 0
	i32.add 	$push6=, $8, $2
	i32.store16	$12=, k+6($pop240), $pop6
	i32.const	$push239=, 0
	i32.load16_u	$1=, i+2($pop239)
	i32.const	$push238=, 0
	i32.load16_u	$0=, i($pop238):p2align=4
	i32.const	$push237=, 0
	i32.load16_u	$7=, j+2($pop237)
	i32.const	$push236=, 0
	i32.load16_u	$6=, j($pop236):p2align=4
	i32.const	$push235=, 0
	i32.const	$push234=, 0
	i32.load16_u	$push2=, j+4($pop234):p2align=2
	tee_local	$push233=, $21=, $pop2
	i32.const	$push232=, 0
	i32.load16_u	$push0=, i+4($pop232):p2align=2
	tee_local	$push231=, $20=, $pop0
	i32.add 	$push5=, $pop233, $pop231
	i32.store16	$13=, k+4($pop235):p2align=2, $pop5
	i32.const	$push230=, 0
	i32.add 	$push4=, $7, $1
	i32.store16	$14=, k+2($pop230), $pop4
	i32.const	$push229=, 0
	i32.add 	$push8=, $6, $0
	i32.store16	$15=, k($pop229):p2align=4, $pop8
	i32.const	$push228=, 0
	i32.store16	$16=, res+6($pop228), $12
	i32.const	$push227=, 0
	i32.store16	$discard=, res+4($pop227):p2align=2, $13
	i32.const	$push226=, 0
	i32.store16	$12=, res+2($pop226), $14
	block
	i32.const	$push225=, 0
	i32.store16	$push17=, res($pop225):p2align=4, $15
	i32.const	$push224=, 65535
	i32.and 	$push18=, $pop17, $pop224
	i32.const	$push19=, 160
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	$pop20, 0       # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push260=, 65535
	i32.and 	$push21=, $12, $pop260
	i32.const	$push22=, 113
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	$pop23, 0       # 0: down to label1
# BB#2:                                 # %entry
	i32.const	$push261=, 65535
	i32.and 	$push24=, $13, $pop261
	i32.const	$push25=, 170
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	$pop26, 0       # 0: down to label1
# BB#3:                                 # %entry
	i32.const	$push262=, 65535
	i32.and 	$push27=, $16, $pop262
	i32.const	$push28=, 230
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	$pop29, 0       # 0: down to label1
# BB#4:                                 # %verify.exit
	i32.const	$push38=, 0
	i32.mul 	$push37=, $6, $0
	i32.store16	$12=, k($pop38):p2align=4, $pop37
	i32.const	$push278=, 0
	i32.mul 	$push30=, $7, $1
	i32.store16	$13=, k+2($pop278), $pop30
	i32.const	$push277=, 0
	i32.mul 	$push31=, $21, $20
	i32.store16	$14=, k+4($pop277):p2align=2, $pop31
	i32.const	$push276=, 0
	i32.mul 	$push32=, $8, $2
	i32.store16	$15=, k+6($pop276), $pop32
	i32.const	$push275=, 0
	i32.mul 	$push36=, $9, $3
	i32.store16	$16=, k+8($pop275):p2align=3, $pop36
	i32.const	$push274=, 0
	i32.store16	$discard=, res($pop274):p2align=4, $12
	i32.const	$push273=, 0
	i32.store16	$discard=, res+2($pop273), $13
	i32.const	$push272=, 0
	i32.store16	$discard=, res+4($pop272):p2align=2, $14
	i32.const	$push271=, 0
	i32.store16	$discard=, res+6($pop271), $15
	i32.const	$push270=, 0
	i32.store16	$discard=, res+8($pop270):p2align=3, $16
	i32.const	$push269=, 0
	i32.const	$push268=, 0
	i32.mul 	$push35=, $10, $4
	i32.store16	$push39=, k+10($pop268), $pop35
	i32.store16	$discard=, res+10($pop269), $pop39
	i32.const	$push267=, 0
	i32.const	$push266=, 0
	i32.mul 	$push34=, $11, $5
	i32.store16	$push40=, k+12($pop266):p2align=2, $pop34
	i32.store16	$discard=, res+12($pop267):p2align=2, $pop40
	i32.const	$push265=, 0
	i32.const	$push264=, 0
	i32.mul 	$push33=, $23, $22
	i32.store16	$push41=, k+14($pop264), $pop33
	i32.store16	$discard=, res+14($pop265), $pop41
	block
	i32.const	$push263=, 65535
	i32.and 	$push42=, $12, $pop263
	i32.const	$push43=, 1500
	i32.ne  	$push44=, $pop42, $pop43
	br_if   	$pop44, 0       # 0: down to label2
# BB#5:                                 # %verify.exit
	i32.const	$push279=, 65535
	i32.and 	$push45=, $13, $pop279
	i32.const	$push46=, 1300
	i32.ne  	$push47=, $pop45, $pop46
	br_if   	$pop47, 0       # 0: down to label2
# BB#6:                                 # %verify.exit
	i32.const	$push280=, 65535
	i32.and 	$push48=, $14, $pop280
	i32.const	$push49=, 3000
	i32.ne  	$push50=, $pop48, $pop49
	br_if   	$pop50, 0       # 0: down to label2
# BB#7:                                 # %verify.exit
	i32.const	$push281=, 65535
	i32.and 	$push51=, $15, $pop281
	i32.const	$push52=, 6000
	i32.ne  	$push53=, $pop51, $pop52
	br_if   	$pop53, 0       # 0: down to label2
# BB#8:                                 # %verify.exit40
	i32.const	$push54=, 16
	i32.shl 	$push57=, $22, $pop54
	i32.const	$push328=, 16
	i32.shr_s	$push58=, $pop57, $pop328
	i32.const	$push327=, 16
	i32.shl 	$push55=, $23, $pop327
	i32.const	$push326=, 16
	i32.shr_s	$push56=, $pop55, $pop326
	i32.div_s	$12=, $pop58, $pop56
	i32.const	$push325=, 16
	i32.shl 	$push61=, $5, $pop325
	i32.const	$push324=, 16
	i32.shr_s	$push62=, $pop61, $pop324
	i32.const	$push323=, 16
	i32.shl 	$push59=, $11, $pop323
	i32.const	$push322=, 16
	i32.shr_s	$push60=, $pop59, $pop322
	i32.div_s	$13=, $pop62, $pop60
	i32.const	$push321=, 16
	i32.shl 	$push65=, $4, $pop321
	i32.const	$push320=, 16
	i32.shr_s	$push66=, $pop65, $pop320
	i32.const	$push319=, 16
	i32.shl 	$push63=, $10, $pop319
	i32.const	$push318=, 16
	i32.shr_s	$push64=, $pop63, $pop318
	i32.div_s	$14=, $pop66, $pop64
	i32.const	$push317=, 16
	i32.shl 	$push69=, $3, $pop317
	i32.const	$push316=, 16
	i32.shr_s	$push70=, $pop69, $pop316
	i32.const	$push315=, 16
	i32.shl 	$push67=, $9, $pop315
	i32.const	$push314=, 16
	i32.shr_s	$push68=, $pop67, $pop314
	i32.div_s	$15=, $pop70, $pop68
	i32.const	$push313=, 16
	i32.shl 	$push73=, $2, $pop313
	i32.const	$push312=, 16
	i32.shr_s	$push74=, $pop73, $pop312
	i32.const	$push311=, 16
	i32.shl 	$push71=, $8, $pop311
	i32.const	$push310=, 16
	i32.shr_s	$push72=, $pop71, $pop310
	i32.div_s	$16=, $pop74, $pop72
	i32.const	$push309=, 16
	i32.shl 	$push77=, $20, $pop309
	i32.const	$push308=, 16
	i32.shr_s	$push78=, $pop77, $pop308
	i32.const	$push307=, 16
	i32.shl 	$push75=, $21, $pop307
	i32.const	$push306=, 16
	i32.shr_s	$push76=, $pop75, $pop306
	i32.div_s	$18=, $pop78, $pop76
	i32.const	$push305=, 16
	i32.shl 	$push81=, $1, $pop305
	i32.const	$push304=, 16
	i32.shr_s	$push82=, $pop81, $pop304
	i32.const	$push303=, 16
	i32.shl 	$push79=, $7, $pop303
	i32.const	$push302=, 16
	i32.shr_s	$push80=, $pop79, $pop302
	i32.div_s	$17=, $pop82, $pop80
	i32.const	$push88=, 0
	i32.const	$push301=, 16
	i32.shl 	$push85=, $0, $pop301
	i32.const	$push300=, 16
	i32.shr_s	$push86=, $pop85, $pop300
	i32.const	$push299=, 16
	i32.shl 	$push83=, $6, $pop299
	i32.const	$push298=, 16
	i32.shr_s	$push84=, $pop83, $pop298
	i32.div_s	$push87=, $pop86, $pop84
	i32.store16	$19=, k($pop88):p2align=4, $pop87
	i32.const	$push297=, 0
	i32.store16	$discard=, k+2($pop297), $17
	i32.const	$push296=, 0
	i32.store16	$discard=, k+4($pop296):p2align=2, $18
	i32.const	$push295=, 0
	i32.store16	$discard=, k+6($pop295), $16
	i32.const	$push294=, 0
	i32.store16	$discard=, k+8($pop294):p2align=3, $15
	i32.const	$push293=, 0
	i32.store16	$discard=, res($pop293):p2align=4, $19
	i32.const	$push292=, 0
	i32.store16	$discard=, res+2($pop292), $17
	i32.const	$push291=, 0
	i32.store16	$discard=, res+4($pop291):p2align=2, $18
	i32.const	$push290=, 0
	i32.store16	$discard=, res+6($pop290), $16
	i32.const	$push289=, 0
	i32.store16	$discard=, res+8($pop289):p2align=3, $15
	i32.const	$push288=, 0
	i32.const	$push287=, 0
	i32.store16	$push89=, k+10($pop287), $14
	i32.store16	$discard=, res+10($pop288), $pop89
	i32.const	$push286=, 0
	i32.const	$push285=, 0
	i32.store16	$push90=, k+12($pop285):p2align=2, $13
	i32.store16	$discard=, res+12($pop286):p2align=2, $pop90
	i32.const	$push284=, 0
	i32.const	$push283=, 0
	i32.store16	$push91=, k+14($pop283), $12
	i32.store16	$discard=, res+14($pop284), $pop91
	block
	i32.const	$push282=, 65535
	i32.and 	$push92=, $19, $pop282
	i32.const	$push93=, 15
	i32.ne  	$push94=, $pop92, $pop93
	br_if   	$pop94, 0       # 0: down to label3
# BB#9:                                 # %verify.exit40
	i32.const	$push330=, 65535
	i32.and 	$push95=, $17, $pop330
	i32.const	$push329=, 7
	i32.ne  	$push96=, $pop95, $pop329
	br_if   	$pop96, 0       # 0: down to label3
# BB#10:                                # %verify.exit40
	i32.const	$push332=, 65535
	i32.and 	$push97=, $18, $pop332
	i32.const	$push331=, 7
	i32.ne  	$push98=, $pop97, $pop331
	br_if   	$pop98, 0       # 0: down to label3
# BB#11:                                # %verify.exit40
	i32.const	$push333=, 65535
	i32.and 	$push99=, $16, $pop333
	i32.const	$push100=, 6
	i32.ne  	$push101=, $pop99, $pop100
	br_if   	$pop101, 0      # 0: down to label3
# BB#12:                                # %verify.exit49
	i32.const	$push110=, 0
	i32.and 	$push109=, $6, $0
	i32.store16	$12=, k($pop110):p2align=4, $pop109
	i32.const	$push349=, 0
	i32.and 	$push102=, $7, $1
	i32.store16	$13=, k+2($pop349), $pop102
	i32.const	$push348=, 0
	i32.and 	$push103=, $21, $20
	i32.store16	$14=, k+4($pop348):p2align=2, $pop103
	i32.const	$push347=, 0
	i32.and 	$push104=, $8, $2
	i32.store16	$15=, k+6($pop347), $pop104
	i32.const	$push346=, 0
	i32.and 	$push108=, $9, $3
	i32.store16	$16=, k+8($pop346):p2align=3, $pop108
	i32.const	$push345=, 0
	i32.store16	$discard=, res($pop345):p2align=4, $12
	i32.const	$push344=, 0
	i32.store16	$discard=, res+2($pop344), $13
	i32.const	$push343=, 0
	i32.store16	$discard=, res+4($pop343):p2align=2, $14
	i32.const	$push342=, 0
	i32.store16	$discard=, res+6($pop342), $15
	i32.const	$push341=, 0
	i32.store16	$discard=, res+8($pop341):p2align=3, $16
	i32.const	$push340=, 0
	i32.const	$push339=, 0
	i32.and 	$push107=, $10, $4
	i32.store16	$push111=, k+10($pop339), $pop107
	i32.store16	$discard=, res+10($pop340), $pop111
	i32.const	$push338=, 0
	i32.const	$push337=, 0
	i32.and 	$push106=, $11, $5
	i32.store16	$push112=, k+12($pop337):p2align=2, $pop106
	i32.store16	$discard=, res+12($pop338):p2align=2, $pop112
	i32.const	$push336=, 0
	i32.const	$push335=, 0
	i32.and 	$push105=, $23, $22
	i32.store16	$push113=, k+14($pop335), $pop105
	i32.store16	$discard=, res+14($pop336), $pop113
	block
	i32.const	$push334=, 65535
	i32.and 	$push114=, $12, $pop334
	i32.const	$push115=, 2
	i32.ne  	$push116=, $pop114, $pop115
	br_if   	$pop116, 0      # 0: down to label4
# BB#13:                                # %verify.exit49
	i32.const	$push350=, 65535
	i32.and 	$push117=, $13, $pop350
	i32.const	$push118=, 4
	i32.ne  	$push119=, $pop117, $pop118
	br_if   	$pop119, 0      # 0: down to label4
# BB#14:                                # %verify.exit49
	i32.const	$push351=, 65535
	i32.and 	$push120=, $14, $pop351
	i32.const	$push121=, 20
	i32.ne  	$push122=, $pop120, $pop121
	br_if   	$pop122, 0      # 0: down to label4
# BB#15:                                # %verify.exit49
	i32.const	$push352=, 65535
	i32.and 	$push123=, $15, $pop352
	i32.const	$push124=, 8
	i32.ne  	$push125=, $pop123, $pop124
	br_if   	$pop125, 0      # 0: down to label4
# BB#16:                                # %verify.exit58
	i32.const	$push134=, 0
	i32.or  	$push133=, $6, $0
	i32.store16	$12=, k($pop134):p2align=4, $pop133
	i32.const	$push368=, 0
	i32.or  	$push126=, $7, $1
	i32.store16	$13=, k+2($pop368), $pop126
	i32.const	$push367=, 0
	i32.or  	$push127=, $21, $20
	i32.store16	$14=, k+4($pop367):p2align=2, $pop127
	i32.const	$push366=, 0
	i32.or  	$push128=, $8, $2
	i32.store16	$15=, k+6($pop366), $pop128
	i32.const	$push365=, 0
	i32.or  	$push132=, $9, $3
	i32.store16	$16=, k+8($pop365):p2align=3, $pop132
	i32.const	$push364=, 0
	i32.store16	$discard=, res($pop364):p2align=4, $12
	i32.const	$push363=, 0
	i32.store16	$discard=, res+2($pop363), $13
	i32.const	$push362=, 0
	i32.store16	$discard=, res+4($pop362):p2align=2, $14
	i32.const	$push361=, 0
	i32.store16	$discard=, res+6($pop361), $15
	i32.const	$push360=, 0
	i32.store16	$discard=, res+8($pop360):p2align=3, $16
	i32.const	$push359=, 0
	i32.const	$push358=, 0
	i32.or  	$push131=, $10, $4
	i32.store16	$push135=, k+10($pop358), $pop131
	i32.store16	$discard=, res+10($pop359), $pop135
	i32.const	$push357=, 0
	i32.const	$push356=, 0
	i32.or  	$push130=, $11, $5
	i32.store16	$push136=, k+12($pop356):p2align=2, $pop130
	i32.store16	$discard=, res+12($pop357):p2align=2, $pop136
	i32.const	$push355=, 0
	i32.const	$push354=, 0
	i32.or  	$push129=, $23, $22
	i32.store16	$push137=, k+14($pop354), $pop129
	i32.store16	$discard=, res+14($pop355), $pop137
	block
	i32.const	$push353=, 65535
	i32.and 	$push138=, $12, $pop353
	i32.const	$push139=, 158
	i32.ne  	$push140=, $pop138, $pop139
	br_if   	$pop140, 0      # 0: down to label5
# BB#17:                                # %verify.exit58
	i32.const	$push369=, 65535
	i32.and 	$push141=, $13, $pop369
	i32.const	$push142=, 109
	i32.ne  	$push143=, $pop141, $pop142
	br_if   	$pop143, 0      # 0: down to label5
# BB#18:                                # %verify.exit58
	i32.const	$push370=, 65535
	i32.and 	$push144=, $14, $pop370
	i32.const	$push145=, 150
	i32.ne  	$push146=, $pop144, $pop145
	br_if   	$pop146, 0      # 0: down to label5
# BB#19:                                # %verify.exit58
	i32.const	$push371=, 65535
	i32.and 	$push147=, $15, $pop371
	i32.const	$push148=, 222
	i32.ne  	$push149=, $pop147, $pop148
	br_if   	$pop149, 0      # 0: down to label5
# BB#20:                                # %verify.exit67
	i32.const	$push158=, 0
	i32.xor 	$push157=, $0, $6
	i32.store16	$6=, k($pop158):p2align=4, $pop157
	i32.const	$push387=, 0
	i32.xor 	$push150=, $1, $7
	i32.store16	$7=, k+2($pop387), $pop150
	i32.const	$push386=, 0
	i32.xor 	$push151=, $20, $21
	i32.store16	$12=, k+4($pop386):p2align=2, $pop151
	i32.const	$push385=, 0
	i32.xor 	$push152=, $2, $8
	i32.store16	$8=, k+6($pop385), $pop152
	i32.const	$push384=, 0
	i32.xor 	$push156=, $3, $9
	i32.store16	$9=, k+8($pop384):p2align=3, $pop156
	i32.const	$push383=, 0
	i32.store16	$discard=, res($pop383):p2align=4, $6
	i32.const	$push382=, 0
	i32.store16	$discard=, res+2($pop382), $7
	i32.const	$push381=, 0
	i32.store16	$discard=, res+4($pop381):p2align=2, $12
	i32.const	$push380=, 0
	i32.store16	$discard=, res+6($pop380), $8
	i32.const	$push379=, 0
	i32.store16	$discard=, res+8($pop379):p2align=3, $9
	i32.const	$push378=, 0
	i32.const	$push377=, 0
	i32.xor 	$push155=, $4, $10
	i32.store16	$push159=, k+10($pop377), $pop155
	i32.store16	$discard=, res+10($pop378), $pop159
	i32.const	$push376=, 0
	i32.const	$push375=, 0
	i32.xor 	$push154=, $5, $11
	i32.store16	$push160=, k+12($pop375):p2align=2, $pop154
	i32.store16	$discard=, res+12($pop376):p2align=2, $pop160
	i32.const	$push374=, 0
	i32.const	$push373=, 0
	i32.xor 	$push153=, $22, $23
	i32.store16	$push161=, k+14($pop373), $pop153
	i32.store16	$discard=, res+14($pop374), $pop161
	block
	i32.const	$push372=, 65535
	i32.and 	$push162=, $6, $pop372
	i32.const	$push163=, 156
	i32.ne  	$push164=, $pop162, $pop163
	br_if   	$pop164, 0      # 0: down to label6
# BB#21:                                # %verify.exit67
	i32.const	$push388=, 65535
	i32.and 	$push165=, $7, $pop388
	i32.const	$push166=, 105
	i32.ne  	$push167=, $pop165, $pop166
	br_if   	$pop167, 0      # 0: down to label6
# BB#22:                                # %verify.exit67
	i32.const	$push389=, 65535
	i32.and 	$push168=, $12, $pop389
	i32.const	$push169=, 130
	i32.ne  	$push170=, $pop168, $pop169
	br_if   	$pop170, 0      # 0: down to label6
# BB#23:                                # %verify.exit67
	i32.const	$push390=, 65535
	i32.and 	$push171=, $8, $pop390
	i32.const	$push172=, 214
	i32.ne  	$push173=, $pop171, $pop172
	br_if   	$pop173, 0      # 0: down to label6
# BB#24:                                # %verify.exit76
	i32.const	$push177=, 0
	i32.const	$push414=, 0
	i32.sub 	$push182=, $pop414, $0
	i32.store16	$11=, k($pop177):p2align=4, $pop182
	i32.const	$push413=, 0
	i32.const	$push412=, 0
	i32.sub 	$push174=, $pop412, $1
	i32.store16	$10=, k+2($pop413), $pop174
	i32.const	$push411=, 0
	i32.const	$push410=, 0
	i32.sub 	$push175=, $pop410, $20
	i32.store16	$9=, k+4($pop411):p2align=2, $pop175
	i32.const	$push409=, 0
	i32.const	$push408=, 0
	i32.sub 	$push176=, $pop408, $2
	i32.store16	$8=, k+6($pop409), $pop176
	i32.const	$push407=, 0
	i32.const	$push406=, 0
	i32.sub 	$push181=, $pop406, $3
	i32.store16	$7=, k+8($pop407):p2align=3, $pop181
	i32.const	$push405=, 0
	i32.store16	$discard=, res($pop405):p2align=4, $11
	i32.const	$push404=, 0
	i32.store16	$discard=, res+2($pop404), $10
	i32.const	$push403=, 0
	i32.store16	$discard=, res+4($pop403):p2align=2, $9
	i32.const	$push402=, 0
	i32.store16	$discard=, res+6($pop402), $8
	i32.const	$push401=, 0
	i32.store16	$discard=, res+8($pop401):p2align=3, $7
	i32.const	$push400=, 0
	i32.const	$push399=, 0
	i32.const	$push398=, 0
	i32.sub 	$push180=, $pop398, $4
	i32.store16	$push183=, k+10($pop399), $pop180
	i32.store16	$discard=, res+10($pop400), $pop183
	i32.const	$push397=, 0
	i32.const	$push396=, 0
	i32.const	$push395=, 0
	i32.sub 	$push179=, $pop395, $5
	i32.store16	$push184=, k+12($pop396):p2align=2, $pop179
	i32.store16	$discard=, res+12($pop397):p2align=2, $pop184
	i32.const	$push394=, 0
	i32.const	$push393=, 0
	i32.const	$push392=, 0
	i32.sub 	$push178=, $pop392, $22
	i32.store16	$push185=, k+14($pop393), $pop178
	i32.store16	$discard=, res+14($pop394), $pop185
	block
	i32.const	$push391=, 65535
	i32.and 	$push186=, $11, $pop391
	i32.const	$push187=, 65386
	i32.ne  	$push188=, $pop186, $pop187
	br_if   	$pop188, 0      # 0: down to label7
# BB#25:                                # %verify.exit76
	i32.const	$push415=, 65535
	i32.and 	$push189=, $10, $pop415
	i32.const	$push190=, 65436
	i32.ne  	$push191=, $pop189, $pop190
	br_if   	$pop191, 0      # 0: down to label7
# BB#26:                                # %verify.exit76
	i32.const	$push416=, 65535
	i32.and 	$push192=, $9, $pop416
	i32.const	$push193=, 65386
	i32.ne  	$push194=, $pop192, $pop193
	br_if   	$pop194, 0      # 0: down to label7
# BB#27:                                # %verify.exit76
	i32.const	$push417=, 65535
	i32.and 	$push195=, $8, $pop417
	i32.const	$push196=, 65336
	i32.ne  	$push197=, $pop195, $pop196
	br_if   	$pop197, 0      # 0: down to label7
# BB#28:                                # %verify.exit85
	i32.const	$push207=, 0
	i32.const	$push201=, -1
	i32.xor 	$push206=, $0, $pop201
	i32.store16	$0=, k($pop207):p2align=4, $pop206
	i32.const	$push440=, 0
	i32.const	$push439=, -1
	i32.xor 	$push198=, $1, $pop439
	i32.store16	$1=, k+2($pop440), $pop198
	i32.const	$push438=, 0
	i32.const	$push437=, -1
	i32.xor 	$push199=, $20, $pop437
	i32.store16	$11=, k+4($pop438):p2align=2, $pop199
	i32.const	$push436=, 0
	i32.const	$push435=, -1
	i32.xor 	$push200=, $2, $pop435
	i32.store16	$2=, k+6($pop436), $pop200
	i32.const	$push434=, 0
	i32.const	$push433=, -1
	i32.xor 	$push205=, $3, $pop433
	i32.store16	$3=, k+8($pop434):p2align=3, $pop205
	i32.const	$push432=, 0
	i32.store16	$discard=, res($pop432):p2align=4, $0
	i32.const	$push431=, 0
	i32.store16	$discard=, res+2($pop431), $1
	i32.const	$push430=, 0
	i32.store16	$discard=, res+4($pop430):p2align=2, $11
	i32.const	$push429=, 0
	i32.store16	$discard=, res+6($pop429), $2
	i32.const	$push428=, 0
	i32.store16	$discard=, res+8($pop428):p2align=3, $3
	i32.const	$push427=, 0
	i32.const	$push426=, 0
	i32.const	$push425=, -1
	i32.xor 	$push204=, $4, $pop425
	i32.store16	$push208=, k+10($pop426), $pop204
	i32.store16	$discard=, res+10($pop427), $pop208
	i32.const	$push424=, 0
	i32.const	$push423=, 0
	i32.const	$push422=, -1
	i32.xor 	$push203=, $5, $pop422
	i32.store16	$push209=, k+12($pop423):p2align=2, $pop203
	i32.store16	$discard=, res+12($pop424):p2align=2, $pop209
	i32.const	$push421=, 0
	i32.const	$push420=, 0
	i32.const	$push419=, -1
	i32.xor 	$push202=, $22, $pop419
	i32.store16	$push210=, k+14($pop420), $pop202
	i32.store16	$discard=, res+14($pop421), $pop210
	block
	i32.const	$push418=, 65535
	i32.and 	$push211=, $0, $pop418
	i32.const	$push212=, 65385
	i32.ne  	$push213=, $pop211, $pop212
	br_if   	$pop213, 0      # 0: down to label8
# BB#29:                                # %verify.exit85
	i32.const	$push441=, 65535
	i32.and 	$push214=, $1, $pop441
	i32.const	$push215=, 65435
	i32.ne  	$push216=, $pop214, $pop215
	br_if   	$pop216, 0      # 0: down to label8
# BB#30:                                # %verify.exit85
	i32.const	$push442=, 65535
	i32.and 	$push217=, $11, $pop442
	i32.const	$push218=, 65385
	i32.ne  	$push219=, $pop217, $pop218
	br_if   	$pop219, 0      # 0: down to label8
# BB#31:                                # %verify.exit85
	i32.const	$push443=, 65535
	i32.and 	$push220=, $2, $pop443
	i32.const	$push221=, 65335
	i32.ne  	$push222=, $pop220, $pop221
	br_if   	$pop222, 0      # 0: down to label8
# BB#32:                                # %verify.exit94
	i32.const	$push223=, 0
	call    	exit@FUNCTION, $pop223
	unreachable
.LBB1_33:                               # %if.then.i93
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_34:                               # %if.then.i84
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_35:                               # %if.then.i75
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_36:                               # %if.then.i66
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_37:                               # %if.then.i57
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_38:                               # %if.then.i48
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_39:                               # %if.then.i39
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_40:                               # %if.then.i
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
