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
	i32.const	$push4=, 0
	i32.const	$push113=, 0
	i32.const	$push3=, 1
	i32.store	$push5=, a($pop113), $pop3
	i32.store	$0=, n($pop4), $pop5
	i32.const	$push112=, 0
	i32.const	$push111=, 0
	i32.store8	$1=, u($pop112), $pop111
	copy_local	$5=, $0
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_4 Depth 2
                                        #       Child Loop BB2_5 Depth 3
	loop                            # label0:
	block
	block
	i32.store	$push6=, g($1), $1
	tee_local	$push114=, $3=, $pop6
	i32.load	$push7=, l($pop114)
	i32.const	$push156=, 0
	i32.eq  	$push157=, $pop7, $pop156
	br_if   	0, $pop157      # 0: down to label3
# BB#2:                                 # %for.end
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load	$push8=, j($3)
	i32.store	$push9=, 0($pop8), $3
	tee_local	$push125=, $6=, $pop9
	i32.store	$push10=, d($pop125), $6
	tee_local	$push124=, $6=, $pop10
	i32.load	$push13=, i($pop124)
	i32.load	$push11=, j($6)
	i32.load	$push12=, 0($pop11)
	i32.store	$discard=, 0($pop13), $pop12
	i32.load	$push14=, i($6)
	i32.store	$push15=, 0($pop14), $6
	tee_local	$push123=, $6=, $pop15
	i32.load	$push16=, i($pop123)
	i32.store	$push17=, 0($pop16), $6
	i32.load	$push18=, i($pop17)
	i32.store	$discard=, 0($pop18), $11
	br      	1               # 1: down to label2
.LBB2_3:                                # %for.cond.preheader.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label3:
	block
	i32.load	$push19=, i($3)
	i32.store	$push20=, 0($pop19), $3
	tee_local	$push117=, $5=, $pop20
	i32.load	$push21=, e($pop117)
	i32.store	$push22=, 0($pop21), $5
	tee_local	$push116=, $5=, $pop22
	i32.store	$push23=, o($pop116), $5
	tee_local	$push115=, $4=, $pop23
	i32.load	$push24=, p($pop115)
	br_if   	0, $pop24       # 0: down to label4
.LBB2_4:                                # %for.cond3.preheader.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_5 Depth 3
	loop                            # label5:
	block
	i32.load	$push0=, i($4)
	tee_local	$push120=, $7=, $pop0
	i32.load	$push1=, 0($pop120)
	tee_local	$push119=, $6=, $pop1
	i32.store	$push25=, 0($pop119), $4
	tee_local	$push118=, $5=, $pop25
	i32.load	$push26=, j($pop118)
	i32.load	$push27=, 0($pop26)
	i32.load	$push28=, 0($pop27)
	br_if   	0, $pop28       # 0: down to label7
.LBB2_5:                                # %if.end110.i
                                        #   Parent Loop BB2_1 Depth=1
                                        #     Parent Loop BB2_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label8:
	i32.load	$push29=, k($5)
	i32.add 	$push30=, $pop29, $0
	i32.store	$discard=, k($5), $pop30
	i32.store	$push31=, 0($6), $5
	i32.load	$push32=, j($pop31)
	i32.load	$push33=, 0($pop32)
	i32.load	$push34=, 0($pop33)
	i32.const	$push158=, 0
	i32.eq  	$push159=, $pop34, $pop158
	br_if   	0, $pop159      # 0: up to label8
.LBB2_6:                                # %for.end.i
                                        #   in Loop: Header=BB2_4 Depth=2
	end_loop                        # label9:
	end_block                       # label7:
	i32.load	$push35=, j($5)
	i32.load	$push36=, 0($pop35)
	i32.store	$discard=, 0($7), $pop36
	i32.load	$push39=, i($5)
	i32.load	$push37=, j($5)
	i32.load	$push38=, 0($pop37)
	i32.store	$discard=, 0($pop39), $pop38
	i32.load	$push42=, i($5)
	i32.load	$push40=, j($5)
	i32.load	$push41=, 0($pop40)
	i32.store	$discard=, 0($pop42), $pop41
	i32.load	$push45=, i($5)
	i32.load	$push43=, j($5)
	i32.load	$push44=, 0($pop43)
	i32.store	$discard=, 0($pop45), $pop44
	i32.load	$push48=, i($5)
	i32.load	$push46=, j($5)
	i32.load	$push47=, 0($pop46)
	i32.store	$discard=, 0($pop48), $pop47
	i32.load	$push51=, i($5)
	i32.load	$push49=, j($5)
	i32.load	$push50=, 0($pop49)
	i32.store	$discard=, 0($pop51), $pop50
	i32.load	$6=, h($5)
	i32.load	$push53=, i($5)
	i32.store	$push54=, 0($pop53), $5
	tee_local	$push122=, $7=, $pop54
	i32.load	$2=, e($pop122)
	i32.add 	$push52=, $6, $0
	i32.store	$discard=, h($5), $pop52
	i32.store	$push55=, 0($2), $7
	tee_local	$push121=, $5=, $pop55
	i32.store	$push56=, o($pop121), $5
	i32.load	$push57=, p($pop56)
	i32.const	$push160=, 0
	i32.eq  	$push161=, $pop57, $pop160
	br_if   	0, $pop161      # 0: up to label5
.LBB2_7:                                # %foo.exit.thread
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label6:
	end_block                       # label4:
	i32.store	$push58=, f($4), $4
	i32.load	$5=, n($pop58)
.LBB2_8:                                # %for.inc7
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label2:
	i32.const	$push126=, -1
	i32.add 	$push2=, $5, $pop126
	i32.store	$5=, n($3), $pop2
	br_if   	0, $5           # 0: up to label0
# BB#9:                                 # %for.end8
	end_loop                        # label1:
	block
	i32.const	$push59=, 0
	i32.const	$push129=, 0
	i32.store8	$push60=, u($pop59), $pop129
	tee_local	$push128=, $4=, $pop60
	i32.load	$push110=, b($pop128)
	tee_local	$push127=, $6=, $pop110
	i32.const	$push162=, 0
	i32.eq  	$push163=, $pop127, $pop162
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
	i32.shl 	$push61=, $0, $pop138
	i32.load	$push62=, a($pop61)
	i32.const	$push137=, 2
	i32.shl 	$push63=, $pop62, $pop137
	i32.load	$push64=, a($pop63)
	i32.const	$push136=, 2
	i32.shl 	$push65=, $pop64, $pop136
	i32.load	$push66=, a($pop65)
	i32.const	$push135=, 2
	i32.shl 	$push67=, $pop66, $pop135
	i32.load	$push68=, a($pop67)
	i32.const	$push134=, 2
	i32.shl 	$push69=, $pop68, $pop134
	i32.load	$push70=, a($pop69)
	i32.const	$push133=, 2
	i32.shl 	$push71=, $pop70, $pop133
	i32.load	$push72=, a($pop71)
	i32.const	$push132=, 2
	i32.shl 	$push73=, $pop72, $pop132
	i32.load	$push74=, a($pop73)
	i32.const	$push131=, 2
	i32.shl 	$push75=, $pop74, $pop131
	i32.load	$0=, a($pop75)
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
	i32.const	$push76=, 0
	i32.store	$discard=, c($pop76), $0
	i32.const	$push141=, 0
	i32.const	$push140=, 0
	i32.store	$discard=, b($pop141), $pop140
.LBB2_15:                               # %for.end29
	end_block                       # label10:
	call    	baz@FUNCTION
	block
	i32.load8_s	$push77=, u($4)
	i32.const	$push78=, 2
	i32.shl 	$push79=, $pop77, $pop78
	i32.load	$push80=, a($pop79)
	i32.const	$push155=, 2
	i32.shl 	$push81=, $pop80, $pop155
	i32.load	$push82=, a($pop81)
	i32.const	$push154=, 2
	i32.shl 	$push83=, $pop82, $pop154
	i32.load	$push84=, a($pop83)
	i32.const	$push153=, 2
	i32.shl 	$push85=, $pop84, $pop153
	i32.load	$push86=, a($pop85)
	i32.const	$push152=, 2
	i32.shl 	$push87=, $pop86, $pop152
	i32.load	$push88=, a($pop87)
	i32.const	$push151=, 2
	i32.shl 	$push89=, $pop88, $pop151
	i32.load	$push90=, a($pop89)
	i32.const	$push150=, 2
	i32.shl 	$push91=, $pop90, $pop150
	i32.load	$push92=, a($pop91)
	i32.const	$push149=, 2
	i32.shl 	$push93=, $pop92, $pop149
	i32.load	$push94=, a($pop93)
	i32.const	$push148=, 2
	i32.shl 	$push95=, $pop94, $pop148
	i32.load	$push96=, a($pop95)
	i32.const	$push147=, 2
	i32.shl 	$push97=, $pop96, $pop147
	i32.load	$push98=, a($pop97)
	i32.const	$push146=, 2
	i32.shl 	$push99=, $pop98, $pop146
	i32.load	$push100=, a($pop99)
	i32.const	$push145=, 2
	i32.shl 	$push101=, $pop100, $pop145
	i32.load	$push102=, a($pop101)
	i32.const	$push144=, 2
	i32.shl 	$push103=, $pop102, $pop144
	i32.load	$push104=, a($pop103)
	i32.const	$push143=, 2
	i32.shl 	$push105=, $pop104, $pop143
	i32.load	$push106=, a($pop105)
	i32.const	$push142=, 2
	i32.shl 	$push107=, $pop106, $pop142
	i32.load	$push108=, a($pop107)
	i32.const	$push164=, 0
	i32.eq  	$push165=, $pop108, $pop164
	br_if   	0, $pop165      # 0: down to label15
# BB#16:                                # %if.end47
	i32.const	$push109=, 0
	i32.const	$10=, 32
	i32.add 	$11=, $11, $10
	i32.const	$10=, __stack_pointer
	i32.store	$11=, 0($10), $11
	return  	$pop109
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
