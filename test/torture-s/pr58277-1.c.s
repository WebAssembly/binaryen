	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58277-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push2=, 0
	i32.store8	u($pop0), $pop2
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.baz,"ax",@progbits
	.hidden	baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
# BB#0:                                 # %entry
	#APP
	#NO_APP
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	baz, .Lfunc_end1-baz

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push117=, 0
	i32.const	$push114=, 0
	i32.load	$push115=, __stack_pointer($pop114)
	i32.const	$push116=, 32
	i32.sub 	$push128=, $pop115, $pop116
	tee_local	$push127=, $3=, $pop128
	i32.store	__stack_pointer($pop117), $pop127
	i32.const	$push126=, 0
	i32.const	$push125=, 1
	i32.store	n($pop126), $pop125
	i32.const	$push124=, 0
	i32.const	$push123=, 1
	i32.store	a($pop124), $pop123
	i32.const	$push122=, 0
	i32.const	$push121=, 0
	i32.store8	u($pop122), $pop121
	i32.const	$0=, 1
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_4 Depth 2
                                        #       Child Loop BB2_6 Depth 3
	loop    	                # label0:
	i32.const	$push131=, 0
	i32.const	$push130=, 0
	i32.store	g($pop131), $pop130
	block   	
	block   	
	i32.const	$push129=, 0
	i32.load	$push0=, l($pop129)
	i32.eqz 	$push254=, $pop0
	br_if   	0, $pop254      # 0: down to label2
# BB#2:                                 # %for.end
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push144=, 0
	i32.load	$push1=, j($pop144)
	i32.const	$push143=, 0
	i32.store	0($pop1), $pop143
	i32.const	$push142=, 0
	i32.load	$push2=, i($pop142)
	i32.const	$push141=, 0
	i32.load	$push3=, j($pop141)
	i32.load	$push4=, 0($pop3)
	i32.store	0($pop2), $pop4
	i32.const	$push140=, 0
	i32.const	$push139=, 0
	i32.store	d($pop140), $pop139
	i32.const	$push138=, 0
	i32.const	$push137=, 1
	i32.store8	u($pop138), $pop137
	i32.const	$push136=, 0
	i32.load	$push5=, i($pop136)
	i32.const	$push135=, 0
	i32.store	0($pop5), $pop135
	i32.const	$push134=, 0
	i32.load	$push6=, i($pop134)
	i32.const	$push133=, 0
	i32.store	0($pop6), $pop133
	i32.const	$push132=, 0
	i32.load	$push7=, i($pop132)
	i32.store	0($pop7), $3
	br      	1               # 1: down to label1
.LBB2_3:                                # %for.cond.preheader.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label2:
	i32.const	$push151=, 0
	i32.load	$push8=, i($pop151)
	i32.const	$push150=, 0
	i32.store	0($pop8), $pop150
	i32.const	$push149=, 0
	i32.load	$push9=, e($pop149)
	i32.const	$push148=, 0
	i32.store	0($pop9), $pop148
	i32.const	$push147=, 0
	i32.const	$push146=, 0
	i32.store	o($pop147), $pop146
	block   	
	i32.const	$push145=, 0
	i32.load	$push10=, p($pop145)
	br_if   	0, $pop10       # 0: down to label3
.LBB2_4:                                # %for.cond3.preheader.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_6 Depth 3
	loop    	                # label4:
	i32.const	$push156=, 0
	i32.load	$push155=, i($pop156)
	tee_local	$push154=, $2=, $pop155
	i32.load	$push11=, 0($pop154)
	i32.const	$push153=, 0
	i32.store	0($pop11), $pop153
	block   	
	i32.const	$push152=, 0
	i32.load	$push12=, j($pop152)
	i32.load	$push13=, 0($pop12)
	i32.load	$push14=, 0($pop13)
	br_if   	0, $pop14       # 0: down to label5
# BB#5:                                 # %if.end110.lr.ph.i
                                        #   in Loop: Header=BB2_4 Depth=2
	i32.const	$push159=, 0
	i32.load	$push158=, i($pop159)
	tee_local	$push157=, $2=, $pop158
	i32.load	$0=, 0($pop157)
.LBB2_6:                                # %if.end110.i
                                        #   Parent Loop BB2_1 Depth=1
                                        #     Parent Loop BB2_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label6:
	i32.const	$push166=, 0
	i32.const	$push165=, 0
	i32.load	$push15=, k($pop165)
	i32.const	$push164=, 1
	i32.add 	$push16=, $pop15, $pop164
	i32.store	k($pop166), $pop16
	i32.const	$push163=, 0
	i32.store	0($0), $pop163
	i32.const	$push162=, 0
	i32.const	$push161=, 0
	i32.store8	u($pop162), $pop161
	i32.const	$push160=, 0
	i32.load	$push17=, j($pop160)
	i32.load	$push18=, 0($pop17)
	i32.load	$push19=, 0($pop18)
	i32.eqz 	$push255=, $pop19
	br_if   	0, $pop255      # 0: up to label6
.LBB2_7:                                # %for.end.i
                                        #   in Loop: Header=BB2_4 Depth=2
	end_loop
	end_block                       # label5:
	i32.const	$push187=, 0
	i32.load	$push20=, j($pop187)
	i32.load	$push21=, 0($pop20)
	i32.store	0($2), $pop21
	i32.const	$push186=, 0
	i32.load	$push22=, i($pop186)
	i32.const	$push185=, 0
	i32.load	$push23=, j($pop185)
	i32.load	$push24=, 0($pop23)
	i32.store	0($pop22), $pop24
	i32.const	$push184=, 0
	i32.load	$0=, j($pop184)
	i32.const	$push183=, 0
	i32.load	$push26=, i($pop183)
	i32.load	$push25=, 0($0)
	i32.store	0($pop26), $pop25
	i32.const	$push182=, 0
	i32.load	$push27=, i($pop182)
	i32.const	$push181=, 0
	i32.load	$push28=, j($pop181)
	i32.load	$push29=, 0($pop28)
	i32.store	0($pop27), $pop29
	i32.const	$push180=, 0
	i32.load	$push30=, i($pop180)
	i32.const	$push179=, 0
	i32.load	$push31=, j($pop179)
	i32.load	$push32=, 0($pop31)
	i32.store	0($pop30), $pop32
	i32.const	$push178=, 0
	i32.load	$push33=, i($pop178)
	i32.const	$push177=, 0
	i32.load	$push34=, j($pop177)
	i32.load	$push35=, 0($pop34)
	i32.store	0($pop33), $pop35
	i32.const	$push176=, 0
	i32.load	$push36=, i($pop176)
	i32.const	$push175=, 0
	i32.store	0($pop36), $pop175
	i32.const	$push174=, 0
	i32.const	$push173=, 0
	i32.load	$push37=, h($pop173)
	i32.const	$push172=, 1
	i32.add 	$push38=, $pop37, $pop172
	i32.store	h($pop174), $pop38
	i32.const	$push171=, 0
	i32.load	$push39=, e($pop171)
	i32.const	$push170=, 0
	i32.store	0($pop39), $pop170
	i32.const	$push169=, 0
	i32.const	$push168=, 0
	i32.store	o($pop169), $pop168
	i32.const	$push167=, 0
	i32.load	$push40=, p($pop167)
	i32.eqz 	$push256=, $pop40
	br_if   	0, $pop256      # 0: up to label4
.LBB2_8:                                # %foo.exit.thread
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	end_block                       # label3:
	i32.const	$push190=, 0
	i32.const	$push189=, 0
	i32.store	f($pop190), $pop189
	i32.const	$push188=, 0
	i32.load	$0=, n($pop188)
.LBB2_9:                                # %for.inc7
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label1:
	i32.const	$push196=, 0
	i32.const	$push195=, -1
	i32.add 	$push194=, $0, $pop195
	tee_local	$push193=, $0=, $pop194
	i32.store	n($pop196), $pop193
	i32.const	$push192=, 0
	i32.const	$push191=, 0
	i32.store8	u($pop192), $pop191
	br_if   	0, $0           # 0: up to label0
# BB#10:                                # %for.end8
	end_loop
	block   	
	i32.const	$push199=, 0
	i32.load	$push198=, b($pop199)
	tee_local	$push197=, $1=, $pop198
	i32.eqz 	$push257=, $pop197
	br_if   	0, $pop257      # 0: down to label7
# BB#11:                                # %for.cond12.preheader.lr.ph
	i32.const	$push200=, 0
	i32.load	$2=, c($pop200)
.LBB2_12:                               # %for.cond12.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_13 Depth 2
	loop    	                # label8:
	i32.const	$0=, 10
.LBB2_13:                               # %for.body15
                                        #   Parent Loop BB2_12 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label9:
	i32.const	$push219=, 2
	i32.shl 	$push41=, $2, $pop219
	i32.const	$push218=, a
	i32.add 	$push42=, $pop41, $pop218
	i32.load	$push43=, 0($pop42)
	i32.const	$push217=, 2
	i32.shl 	$push44=, $pop43, $pop217
	i32.const	$push216=, a
	i32.add 	$push45=, $pop44, $pop216
	i32.load	$push46=, 0($pop45)
	i32.const	$push215=, 2
	i32.shl 	$push47=, $pop46, $pop215
	i32.const	$push214=, a
	i32.add 	$push48=, $pop47, $pop214
	i32.load	$push49=, 0($pop48)
	i32.const	$push213=, 2
	i32.shl 	$push50=, $pop49, $pop213
	i32.const	$push212=, a
	i32.add 	$push51=, $pop50, $pop212
	i32.load	$push52=, 0($pop51)
	i32.const	$push211=, 2
	i32.shl 	$push53=, $pop52, $pop211
	i32.const	$push210=, a
	i32.add 	$push54=, $pop53, $pop210
	i32.load	$push55=, 0($pop54)
	i32.const	$push209=, 2
	i32.shl 	$push56=, $pop55, $pop209
	i32.const	$push208=, a
	i32.add 	$push57=, $pop56, $pop208
	i32.load	$push58=, 0($pop57)
	i32.const	$push207=, 2
	i32.shl 	$push59=, $pop58, $pop207
	i32.const	$push206=, a
	i32.add 	$push60=, $pop59, $pop206
	i32.load	$push61=, 0($pop60)
	i32.const	$push205=, 2
	i32.shl 	$push62=, $pop61, $pop205
	i32.const	$push204=, a
	i32.add 	$push63=, $pop62, $pop204
	i32.load	$2=, 0($pop63)
	i32.const	$push203=, -1
	i32.add 	$push202=, $0, $pop203
	tee_local	$push201=, $0=, $pop202
	br_if   	0, $pop201      # 0: up to label9
# BB#14:                                # %for.inc27
                                        #   in Loop: Header=BB2_12 Depth=1
	end_loop
	i32.const	$push222=, 1
	i32.add 	$push221=, $1, $pop222
	tee_local	$push220=, $1=, $pop221
	br_if   	0, $pop220      # 0: up to label8
# BB#15:                                # %for.cond9.for.end29_crit_edge
	end_loop
	i32.const	$push64=, 0
	i32.store	c($pop64), $2
	i32.const	$push224=, 0
	i32.const	$push223=, 0
	i32.store	b($pop224), $pop223
.LBB2_16:                               # %for.end29
	end_block                       # label7:
	call    	baz@FUNCTION
	block   	
	i32.const	$push253=, 0
	i32.load8_s	$push65=, u($pop253)
	i32.const	$push66=, 2
	i32.shl 	$push67=, $pop65, $pop66
	i32.const	$push68=, a
	i32.add 	$push69=, $pop67, $pop68
	i32.load	$push70=, 0($pop69)
	i32.const	$push252=, 2
	i32.shl 	$push71=, $pop70, $pop252
	i32.const	$push251=, a
	i32.add 	$push72=, $pop71, $pop251
	i32.load	$push73=, 0($pop72)
	i32.const	$push250=, 2
	i32.shl 	$push74=, $pop73, $pop250
	i32.const	$push249=, a
	i32.add 	$push75=, $pop74, $pop249
	i32.load	$push76=, 0($pop75)
	i32.const	$push248=, 2
	i32.shl 	$push77=, $pop76, $pop248
	i32.const	$push247=, a
	i32.add 	$push78=, $pop77, $pop247
	i32.load	$push79=, 0($pop78)
	i32.const	$push246=, 2
	i32.shl 	$push80=, $pop79, $pop246
	i32.const	$push245=, a
	i32.add 	$push81=, $pop80, $pop245
	i32.load	$push82=, 0($pop81)
	i32.const	$push244=, 2
	i32.shl 	$push83=, $pop82, $pop244
	i32.const	$push243=, a
	i32.add 	$push84=, $pop83, $pop243
	i32.load	$push85=, 0($pop84)
	i32.const	$push242=, 2
	i32.shl 	$push86=, $pop85, $pop242
	i32.const	$push241=, a
	i32.add 	$push87=, $pop86, $pop241
	i32.load	$push88=, 0($pop87)
	i32.const	$push240=, 2
	i32.shl 	$push89=, $pop88, $pop240
	i32.const	$push239=, a
	i32.add 	$push90=, $pop89, $pop239
	i32.load	$push91=, 0($pop90)
	i32.const	$push238=, 2
	i32.shl 	$push92=, $pop91, $pop238
	i32.const	$push237=, a
	i32.add 	$push93=, $pop92, $pop237
	i32.load	$push94=, 0($pop93)
	i32.const	$push236=, 2
	i32.shl 	$push95=, $pop94, $pop236
	i32.const	$push235=, a
	i32.add 	$push96=, $pop95, $pop235
	i32.load	$push97=, 0($pop96)
	i32.const	$push234=, 2
	i32.shl 	$push98=, $pop97, $pop234
	i32.const	$push233=, a
	i32.add 	$push99=, $pop98, $pop233
	i32.load	$push100=, 0($pop99)
	i32.const	$push232=, 2
	i32.shl 	$push101=, $pop100, $pop232
	i32.const	$push231=, a
	i32.add 	$push102=, $pop101, $pop231
	i32.load	$push103=, 0($pop102)
	i32.const	$push230=, 2
	i32.shl 	$push104=, $pop103, $pop230
	i32.const	$push229=, a
	i32.add 	$push105=, $pop104, $pop229
	i32.load	$push106=, 0($pop105)
	i32.const	$push228=, 2
	i32.shl 	$push107=, $pop106, $pop228
	i32.const	$push227=, a
	i32.add 	$push108=, $pop107, $pop227
	i32.load	$push109=, 0($pop108)
	i32.const	$push226=, 2
	i32.shl 	$push110=, $pop109, $pop226
	i32.const	$push225=, a
	i32.add 	$push111=, $pop110, $pop225
	i32.load	$push112=, 0($pop111)
	i32.eqz 	$push258=, $pop112
	br_if   	0, $pop258      # 0: down to label10
# BB#17:                                # %if.end47
	i32.const	$push120=, 0
	i32.const	$push118=, 32
	i32.add 	$push119=, $3, $pop118
	i32.store	__stack_pointer($pop120), $pop119
	i32.const	$push113=, 0
	return  	$pop113
.LBB2_18:                               # %if.then46
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0
	.size	e, 4

	.hidden	i                       # @i
	.type	i,@object
	.section	.data.i,"aw",@progbits
	.globl	i
	.p2align	2
i:
	.int32	e
	.size	i, 4

	.hidden	l                       # @l
	.type	l,@object
	.section	.data.l,"aw",@progbits
	.globl	l
	.p2align	2
l:
	.int32	1                       # 0x1
	.size	l, 4

	.hidden	u                       # @u
	.type	u,@object
	.section	.bss.u,"aw",@nobits
	.globl	u
u:
	.int8	0                       # 0x0
	.size	u, 1

	.hidden	m                       # @m
	.type	m,@object
	.section	.rodata.m,"a",@progbits
	.globl	m
	.p2align	2
m:
	.int32	0                       # 0x0
	.size	m, 4

	.type	a,@object               # @a
	.section	.bss.a,"aw",@nobits
	.p2align	2
a:
	.skip	8
	.size	a, 8

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	n                       # @n
	.type	n,@object
	.section	.bss.n,"aw",@nobits
	.globl	n
	.p2align	2
n:
	.int32	0                       # 0x0
	.size	n, 4

	.type	j,@object               # @j
	.section	.data.j,"aw",@progbits
	.p2align	2
j:
	.int32	e
	.size	j, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.int32	0                       # 0x0
	.size	f, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.p2align	2
g:
	.int32	0                       # 0x0
	.size	g, 4

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
	.p2align	2
h:
	.int32	0                       # 0x0
	.size	h, 4

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	2
k:
	.int32	0                       # 0x0
	.size	k, 4

	.hidden	o                       # @o
	.type	o,@object
	.section	.bss.o,"aw",@nobits
	.globl	o
	.p2align	2
o:
	.int32	0                       # 0x0
	.size	o, 4

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0                       # 0x0
	.size	p, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
