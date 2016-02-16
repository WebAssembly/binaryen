	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58277-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push2=, 0
	i32.store8	$push1=, u($pop0), $pop2
	return  	$pop1
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
	return
	.endfunc
.Lfunc_end1:
	.size	baz, .Lfunc_end1-baz

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 32
	i32.sub 	$11=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$11=, 0($9), $11
	i32.const	$push2=, 0
	i32.const	$push99=, 0
	i32.const	$push1=, 1
	i32.store	$push3=, a($pop99), $pop1
	i32.store	$0=, n($pop2), $pop3
	i32.const	$push98=, 0
	i32.const	$push97=, 0
	i32.store8	$1=, u($pop98), $pop97
	copy_local	$5=, $0
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_4 Depth 2
                                        #       Child Loop BB2_5 Depth 3
	loop                            # label0:
	block
	block
	i32.store	$push101=, g($1), $1
	tee_local	$push100=, $3=, $pop101
	i32.load	$push4=, l($pop100)
	i32.const	$push156=, 0
	i32.eq  	$push157=, $pop4, $pop156
	br_if   	0, $pop157      # 0: down to label3
# BB#2:                                 # %for.end
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load	$push5=, j($3)
	i32.store	$push123=, 0($pop5), $3
	tee_local	$push122=, $6=, $pop123
	i32.store	$push121=, d($pop122), $6
	tee_local	$push120=, $6=, $pop121
	i32.load	$push8=, i($pop120)
	i32.load	$push6=, j($6)
	i32.load	$push7=, 0($pop6)
	i32.store	$discard=, 0($pop8), $pop7
	i32.load	$push9=, i($6)
	i32.store	$push119=, 0($pop9), $6
	tee_local	$push118=, $6=, $pop119
	i32.load	$push10=, i($pop118)
	i32.store	$push11=, 0($pop10), $6
	i32.load	$push12=, i($pop11)
	i32.store	$discard=, 0($pop12), $11
	br      	1               # 1: down to label2
.LBB2_3:                                # %for.cond.preheader.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label3:
	block
	i32.load	$push13=, i($3)
	i32.store	$push107=, 0($pop13), $3
	tee_local	$push106=, $5=, $pop107
	i32.load	$push14=, e($pop106)
	i32.store	$push105=, 0($pop14), $5
	tee_local	$push104=, $5=, $pop105
	i32.store	$push103=, o($pop104), $5
	tee_local	$push102=, $4=, $pop103
	i32.load	$push15=, p($pop102)
	br_if   	0, $pop15       # 0: down to label4
.LBB2_4:                                # %for.cond3.preheader.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_5 Depth 3
	loop                            # label5:
	block
	i32.load	$push113=, i($4)
	tee_local	$push112=, $7=, $pop113
	i32.load	$push111=, 0($pop112)
	tee_local	$push110=, $6=, $pop111
	i32.store	$push109=, 0($pop110), $4
	tee_local	$push108=, $5=, $pop109
	i32.load	$push16=, j($pop108)
	i32.load	$push17=, 0($pop16)
	i32.load	$push18=, 0($pop17)
	br_if   	0, $pop18       # 0: down to label7
.LBB2_5:                                # %if.end110.i
                                        #   Parent Loop BB2_1 Depth=1
                                        #     Parent Loop BB2_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label8:
	i32.load	$push19=, k($5)
	i32.add 	$push20=, $pop19, $0
	i32.store	$discard=, k($5), $pop20
	i32.store	$push21=, 0($6), $5
	i32.load	$push22=, j($pop21)
	i32.load	$push23=, 0($pop22)
	i32.load	$push24=, 0($pop23)
	i32.const	$push158=, 0
	i32.eq  	$push159=, $pop24, $pop158
	br_if   	0, $pop159      # 0: up to label8
.LBB2_6:                                # %for.end.i
                                        #   in Loop: Header=BB2_4 Depth=2
	end_loop                        # label9:
	end_block                       # label7:
	i32.load	$push25=, j($5)
	i32.load	$push26=, 0($pop25)
	i32.store	$discard=, 0($7), $pop26
	i32.load	$push29=, i($5)
	i32.load	$push27=, j($5)
	i32.load	$push28=, 0($pop27)
	i32.store	$discard=, 0($pop29), $pop28
	i32.load	$push32=, i($5)
	i32.load	$push30=, j($5)
	i32.load	$push31=, 0($pop30)
	i32.store	$discard=, 0($pop32), $pop31
	i32.load	$push35=, i($5)
	i32.load	$push33=, j($5)
	i32.load	$push34=, 0($pop33)
	i32.store	$discard=, 0($pop35), $pop34
	i32.load	$push38=, i($5)
	i32.load	$push36=, j($5)
	i32.load	$push37=, 0($pop36)
	i32.store	$discard=, 0($pop38), $pop37
	i32.load	$push41=, i($5)
	i32.load	$push39=, j($5)
	i32.load	$push40=, 0($pop39)
	i32.store	$discard=, 0($pop41), $pop40
	i32.load	$6=, h($5)
	i32.load	$push43=, i($5)
	i32.store	$push117=, 0($pop43), $5
	tee_local	$push116=, $7=, $pop117
	i32.load	$2=, e($pop116)
	i32.add 	$push42=, $6, $0
	i32.store	$discard=, h($5), $pop42
	i32.store	$push115=, 0($2), $7
	tee_local	$push114=, $5=, $pop115
	i32.store	$push44=, o($pop114), $5
	i32.load	$push45=, p($pop44)
	i32.const	$push160=, 0
	i32.eq  	$push161=, $pop45, $pop160
	br_if   	0, $pop161      # 0: up to label5
.LBB2_7:                                # %foo.exit.thread
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label6:
	end_block                       # label4:
	i32.store	$push46=, f($4), $4
	i32.load	$5=, n($pop46)
.LBB2_8:                                # %for.inc7
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label2:
	i32.const	$push124=, -1
	i32.add 	$push0=, $5, $pop124
	i32.store	$5=, n($3), $pop0
	br_if   	0, $5           # 0: up to label0
# BB#9:                                 # %for.end8
	end_loop                        # label1:
	block
	i32.const	$push47=, 0
	i32.const	$push129=, 0
	i32.store8	$push128=, u($pop47), $pop129
	tee_local	$push127=, $4=, $pop128
	i32.load	$push126=, b($pop127)
	tee_local	$push125=, $6=, $pop126
	i32.const	$push162=, 0
	i32.eq  	$push163=, $pop125, $pop162
	br_if   	0, $pop163      # 0: down to label10
# BB#10:                                # %for.cond12.preheader.lr.ph
	i32.load	$0=, c($4)
.LBB2_11:                               # %for.cond12.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_12 Depth 2
	loop                            # label11:
	i32.const	$5=, 10
.LBB2_12:                               # %for.body15
                                        #   Parent Loop BB2_11 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label13:
	i32.const	$push138=, 2
	i32.shl 	$push48=, $0, $pop138
	i32.load	$push49=, a($pop48)
	i32.const	$push137=, 2
	i32.shl 	$push50=, $pop49, $pop137
	i32.load	$push51=, a($pop50)
	i32.const	$push136=, 2
	i32.shl 	$push52=, $pop51, $pop136
	i32.load	$push53=, a($pop52)
	i32.const	$push135=, 2
	i32.shl 	$push54=, $pop53, $pop135
	i32.load	$push55=, a($pop54)
	i32.const	$push134=, 2
	i32.shl 	$push56=, $pop55, $pop134
	i32.load	$push57=, a($pop56)
	i32.const	$push133=, 2
	i32.shl 	$push58=, $pop57, $pop133
	i32.load	$push59=, a($pop58)
	i32.const	$push132=, 2
	i32.shl 	$push60=, $pop59, $pop132
	i32.load	$push61=, a($pop60)
	i32.const	$push131=, 2
	i32.shl 	$push62=, $pop61, $pop131
	i32.load	$0=, a($pop62)
	i32.const	$push130=, -1
	i32.add 	$5=, $5, $pop130
	br_if   	0, $5           # 0: up to label13
# BB#13:                                # %for.inc27
                                        #   in Loop: Header=BB2_11 Depth=1
	end_loop                        # label14:
	i32.const	$push139=, 1
	i32.add 	$6=, $6, $pop139
	br_if   	0, $6           # 0: up to label11
# BB#14:                                # %for.cond9.for.end29_crit_edge
	end_loop                        # label12:
	i32.const	$push63=, 0
	i32.store	$discard=, c($pop63), $0
	i32.const	$push141=, 0
	i32.const	$push140=, 0
	i32.store	$discard=, b($pop141), $pop140
.LBB2_15:                               # %for.end29
	end_block                       # label10:
	call    	baz@FUNCTION
	block
	i32.load8_s	$push64=, u($4)
	i32.const	$push65=, 2
	i32.shl 	$push66=, $pop64, $pop65
	i32.load	$push67=, a($pop66)
	i32.const	$push155=, 2
	i32.shl 	$push68=, $pop67, $pop155
	i32.load	$push69=, a($pop68)
	i32.const	$push154=, 2
	i32.shl 	$push70=, $pop69, $pop154
	i32.load	$push71=, a($pop70)
	i32.const	$push153=, 2
	i32.shl 	$push72=, $pop71, $pop153
	i32.load	$push73=, a($pop72)
	i32.const	$push152=, 2
	i32.shl 	$push74=, $pop73, $pop152
	i32.load	$push75=, a($pop74)
	i32.const	$push151=, 2
	i32.shl 	$push76=, $pop75, $pop151
	i32.load	$push77=, a($pop76)
	i32.const	$push150=, 2
	i32.shl 	$push78=, $pop77, $pop150
	i32.load	$push79=, a($pop78)
	i32.const	$push149=, 2
	i32.shl 	$push80=, $pop79, $pop149
	i32.load	$push81=, a($pop80)
	i32.const	$push148=, 2
	i32.shl 	$push82=, $pop81, $pop148
	i32.load	$push83=, a($pop82)
	i32.const	$push147=, 2
	i32.shl 	$push84=, $pop83, $pop147
	i32.load	$push85=, a($pop84)
	i32.const	$push146=, 2
	i32.shl 	$push86=, $pop85, $pop146
	i32.load	$push87=, a($pop86)
	i32.const	$push145=, 2
	i32.shl 	$push88=, $pop87, $pop145
	i32.load	$push89=, a($pop88)
	i32.const	$push144=, 2
	i32.shl 	$push90=, $pop89, $pop144
	i32.load	$push91=, a($pop90)
	i32.const	$push143=, 2
	i32.shl 	$push92=, $pop91, $pop143
	i32.load	$push93=, a($pop92)
	i32.const	$push142=, 2
	i32.shl 	$push94=, $pop93, $pop142
	i32.load	$push95=, a($pop94)
	i32.const	$push164=, 0
	i32.eq  	$push165=, $pop95, $pop164
	br_if   	0, $pop165      # 0: down to label15
# BB#16:                                # %if.end47
	i32.const	$push96=, 0
	i32.const	$10=, 32
	i32.add 	$11=, $11, $10
	i32.const	$10=, __stack_pointer
	i32.store	$11=, 0($10), $11
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
