	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58277-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push2=, 0
	i32.store8	$push0=, u($pop1), $pop2
                                        # fallthrough-return: $pop0
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push100=, 0
	i32.const	$push97=, 0
	i32.load	$push98=, __stack_pointer($pop97)
	i32.const	$push99=, 32
	i32.sub 	$push104=, $pop98, $pop99
	i32.store	$5=, __stack_pointer($pop100), $pop104
	i32.const	$push7=, 0
	i32.const	$push107=, 0
	i32.const	$push6=, 1
	i32.store	$push0=, n($pop107), $pop6
	i32.store	$0=, a($pop7), $pop0
	i32.const	$push106=, 0
	i32.const	$push105=, 0
	i32.store8	$1=, u($pop106), $pop105
	i32.const	$7=, 1
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_4 Depth 2
                                        #       Child Loop BB2_5 Depth 3
	loop                            # label0:
	block
	block
	i32.store	$push109=, g($1), $1
	tee_local	$push108=, $2=, $pop109
	i32.load	$push8=, l($pop108)
	i32.eqz 	$push170=, $pop8
	br_if   	0, $pop170      # 0: down to label3
# BB#2:                                 # %for.end
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load	$push9=, j($2)
	i32.store	$push115=, 0($pop9), $2
	tee_local	$push114=, $4=, $pop115
	i32.store	$push113=, d($pop114), $4
	tee_local	$push112=, $4=, $pop113
	i32.load	$3=, j($pop112)
	i32.load	$push11=, i($4)
	i32.load	$push10=, 0($3)
	i32.store	$drop=, 0($pop11), $pop10
	i32.load	$push12=, i($4)
	i32.store	$push111=, 0($pop12), $4
	tee_local	$push110=, $4=, $pop111
	i32.load	$push13=, i($pop110)
	i32.store	$push1=, 0($pop13), $4
	i32.load	$push14=, i($pop1)
	i32.store	$drop=, 0($pop14), $5
	br      	1               # 1: down to label2
.LBB2_3:                                # %for.cond.preheader.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label3:
	block
	i32.load	$push15=, i($2)
	i32.store	$push121=, 0($pop15), $2
	tee_local	$push120=, $4=, $pop121
	i32.load	$push16=, e($pop120)
	i32.store	$push119=, 0($pop16), $4
	tee_local	$push118=, $4=, $pop119
	i32.store	$push117=, o($pop118), $4
	tee_local	$push116=, $3=, $pop117
	i32.load	$push17=, p($pop116)
	br_if   	0, $pop17       # 0: down to label4
.LBB2_4:                                # %for.cond3.preheader.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_5 Depth 3
	loop                            # label5:
	block
	i32.load	$push127=, i($3)
	tee_local	$push126=, $6=, $pop127
	i32.load	$push125=, 0($pop126)
	tee_local	$push124=, $7=, $pop125
	i32.store	$push123=, 0($pop124), $3
	tee_local	$push122=, $4=, $pop123
	i32.load	$push18=, j($pop122)
	i32.load	$push19=, 0($pop18)
	i32.load	$push20=, 0($pop19)
	br_if   	0, $pop20       # 0: down to label7
.LBB2_5:                                # %if.end110.i
                                        #   Parent Loop BB2_1 Depth=1
                                        #     Parent Loop BB2_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label8:
	i32.load	$push21=, k($4)
	i32.add 	$push22=, $pop21, $0
	i32.store	$drop=, k($4), $pop22
	i32.store	$push2=, 0($7), $4
	i32.load	$push23=, j($pop2)
	i32.load	$push24=, 0($pop23)
	i32.load	$push25=, 0($pop24)
	i32.eqz 	$push171=, $pop25
	br_if   	0, $pop171      # 0: up to label8
.LBB2_6:                                # %for.end.i
                                        #   in Loop: Header=BB2_4 Depth=2
	end_loop                        # label9:
	end_block                       # label7:
	i32.load	$push26=, j($4)
	i32.load	$push27=, 0($pop26)
	i32.store	$drop=, 0($6), $pop27
	i32.load	$push28=, i($4)
	i32.load	$push29=, j($4)
	i32.load	$push30=, 0($pop29)
	i32.store	$drop=, 0($pop28), $pop30
	i32.load	$7=, j($4)
	i32.load	$push32=, i($4)
	i32.load	$push31=, 0($7)
	i32.store	$drop=, 0($pop32), $pop31
	i32.load	$push33=, i($4)
	i32.load	$push34=, j($4)
	i32.load	$push35=, 0($pop34)
	i32.store	$drop=, 0($pop33), $pop35
	i32.load	$push36=, i($4)
	i32.load	$push37=, j($4)
	i32.load	$push38=, 0($pop37)
	i32.store	$drop=, 0($pop36), $pop38
	i32.load	$push39=, i($4)
	i32.load	$push40=, j($4)
	i32.load	$push41=, 0($pop40)
	i32.store	$drop=, 0($pop39), $pop41
	i32.load	$push42=, i($4)
	i32.store	$push131=, 0($pop42), $4
	tee_local	$push130=, $4=, $pop131
	i32.load	$push43=, h($4)
	i32.add 	$push44=, $pop43, $0
	i32.store	$drop=, h($pop130), $pop44
	i32.load	$push45=, e($4)
	i32.store	$push129=, 0($pop45), $4
	tee_local	$push128=, $4=, $pop129
	i32.store	$push3=, o($pop128), $4
	i32.load	$push46=, p($pop3)
	i32.eqz 	$push172=, $pop46
	br_if   	0, $pop172      # 0: up to label5
.LBB2_7:                                # %foo.exit.thread
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label6:
	end_block                       # label4:
	i32.store	$push4=, f($3), $3
	i32.load	$7=, n($pop4)
.LBB2_8:                                # %for.inc7
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label2:
	i32.const	$push134=, -1
	i32.add 	$push133=, $7, $pop134
	tee_local	$push132=, $7=, $pop133
	i32.store	$push5=, n($2), $pop132
	br_if   	0, $pop5        # 0: up to label0
# BB#9:                                 # %for.end8
	end_loop                        # label1:
	block
	i32.const	$push47=, 0
	i32.const	$push139=, 0
	i32.store8	$push138=, u($pop47), $pop139
	tee_local	$push137=, $3=, $pop138
	i32.load	$push136=, b($pop137)
	tee_local	$push135=, $7=, $pop136
	i32.eqz 	$push173=, $pop135
	br_if   	0, $pop173      # 0: down to label10
# BB#10:                                # %for.cond12.preheader.lr.ph
	i32.load	$0=, c($3)
.LBB2_11:                               # %for.cond12.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_12 Depth 2
	loop                            # label11:
	i32.const	$4=, 10
.LBB2_12:                               # %for.body15
                                        #   Parent Loop BB2_11 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label13:
	i32.const	$push150=, 2
	i32.shl 	$push48=, $0, $pop150
	i32.load	$push49=, a($pop48)
	i32.const	$push149=, 2
	i32.shl 	$push50=, $pop49, $pop149
	i32.load	$push51=, a($pop50)
	i32.const	$push148=, 2
	i32.shl 	$push52=, $pop51, $pop148
	i32.load	$push53=, a($pop52)
	i32.const	$push147=, 2
	i32.shl 	$push54=, $pop53, $pop147
	i32.load	$push55=, a($pop54)
	i32.const	$push146=, 2
	i32.shl 	$push56=, $pop55, $pop146
	i32.load	$push57=, a($pop56)
	i32.const	$push145=, 2
	i32.shl 	$push58=, $pop57, $pop145
	i32.load	$push59=, a($pop58)
	i32.const	$push144=, 2
	i32.shl 	$push60=, $pop59, $pop144
	i32.load	$push61=, a($pop60)
	i32.const	$push143=, 2
	i32.shl 	$push62=, $pop61, $pop143
	i32.load	$0=, a($pop62)
	i32.const	$push142=, -1
	i32.add 	$push141=, $4, $pop142
	tee_local	$push140=, $4=, $pop141
	br_if   	0, $pop140      # 0: up to label13
# BB#13:                                # %for.inc27
                                        #   in Loop: Header=BB2_11 Depth=1
	end_loop                        # label14:
	i32.const	$push153=, 1
	i32.add 	$push152=, $7, $pop153
	tee_local	$push151=, $7=, $pop152
	br_if   	0, $pop151      # 0: up to label11
# BB#14:                                # %for.cond9.for.end29_crit_edge
	end_loop                        # label12:
	i32.const	$push63=, 0
	i32.store	$drop=, c($pop63), $0
	i32.const	$push155=, 0
	i32.const	$push154=, 0
	i32.store	$drop=, b($pop155), $pop154
.LBB2_15:                               # %for.end29
	end_block                       # label10:
	call    	baz@FUNCTION
	block
	i32.load8_s	$push64=, u($3)
	i32.const	$push65=, 2
	i32.shl 	$push66=, $pop64, $pop65
	i32.load	$push67=, a($pop66)
	i32.const	$push169=, 2
	i32.shl 	$push68=, $pop67, $pop169
	i32.load	$push69=, a($pop68)
	i32.const	$push168=, 2
	i32.shl 	$push70=, $pop69, $pop168
	i32.load	$push71=, a($pop70)
	i32.const	$push167=, 2
	i32.shl 	$push72=, $pop71, $pop167
	i32.load	$push73=, a($pop72)
	i32.const	$push166=, 2
	i32.shl 	$push74=, $pop73, $pop166
	i32.load	$push75=, a($pop74)
	i32.const	$push165=, 2
	i32.shl 	$push76=, $pop75, $pop165
	i32.load	$push77=, a($pop76)
	i32.const	$push164=, 2
	i32.shl 	$push78=, $pop77, $pop164
	i32.load	$push79=, a($pop78)
	i32.const	$push163=, 2
	i32.shl 	$push80=, $pop79, $pop163
	i32.load	$push81=, a($pop80)
	i32.const	$push162=, 2
	i32.shl 	$push82=, $pop81, $pop162
	i32.load	$push83=, a($pop82)
	i32.const	$push161=, 2
	i32.shl 	$push84=, $pop83, $pop161
	i32.load	$push85=, a($pop84)
	i32.const	$push160=, 2
	i32.shl 	$push86=, $pop85, $pop160
	i32.load	$push87=, a($pop86)
	i32.const	$push159=, 2
	i32.shl 	$push88=, $pop87, $pop159
	i32.load	$push89=, a($pop88)
	i32.const	$push158=, 2
	i32.shl 	$push90=, $pop89, $pop158
	i32.load	$push91=, a($pop90)
	i32.const	$push157=, 2
	i32.shl 	$push92=, $pop91, $pop157
	i32.load	$push93=, a($pop92)
	i32.const	$push156=, 2
	i32.shl 	$push94=, $pop93, $pop156
	i32.load	$push95=, a($pop94)
	i32.eqz 	$push174=, $pop95
	br_if   	0, $pop174      # 0: down to label15
# BB#16:                                # %if.end47
	i32.const	$push103=, 0
	i32.const	$push101=, 32
	i32.add 	$push102=, $5, $pop101
	i32.store	$drop=, __stack_pointer($pop103), $pop102
	i32.const	$push96=, 0
	return  	$pop96
.LBB2_17:                               # %if.then46
	end_block                       # label15:
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
	.lcomm	a,8,2
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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
