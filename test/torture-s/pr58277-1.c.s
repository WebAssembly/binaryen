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
	return  	$pop0
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push95=, __stack_pointer
	i32.const	$push92=, __stack_pointer
	i32.load	$push93=, 0($pop92)
	i32.const	$push94=, 32
	i32.sub 	$push99=, $pop93, $pop94
	i32.store	$4=, 0($pop95), $pop99
	i32.const	$push5=, 0
	i32.const	$push102=, 0
	i32.const	$push4=, 1
	i32.store	$push0=, a($pop102), $pop4
	i32.store	$0=, n($pop5), $pop0
	i32.const	$push101=, 0
	i32.const	$push100=, 0
	i32.store8	$1=, u($pop101), $pop100
	i32.const	$5=, 1
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_4 Depth 2
                                        #       Child Loop BB2_5 Depth 3
	loop                            # label0:
	i32.load	$6=, l($1)
	i32.store	$2=, g($1), $1
	block
	block
	i32.const	$push152=, 0
	i32.eq  	$push153=, $6, $pop152
	br_if   	0, $pop153      # 0: down to label3
# BB#2:                                 # %for.end
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load	$push6=, j($2)
	i32.store	$push108=, 0($pop6), $2
	tee_local	$push107=, $6=, $pop108
	i32.store	$push106=, d($pop107), $6
	tee_local	$push105=, $6=, $pop106
	i32.load	$push9=, i($pop105)
	i32.load	$push7=, j($6)
	i32.load	$push8=, 0($pop7)
	i32.store	$discard=, 0($pop9), $pop8
	i32.load	$push10=, i($6)
	i32.store	$push104=, 0($pop10), $6
	tee_local	$push103=, $6=, $pop104
	i32.load	$push11=, i($pop103)
	i32.store	$push1=, 0($pop11), $6
	i32.load	$push12=, i($pop1)
	i32.store	$discard=, 0($pop12), $4
	br      	1               # 1: down to label2
.LBB2_3:                                # %for.cond.preheader.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label3:
	i32.load	$push13=, i($2)
	i32.store	$push112=, 0($pop13), $2
	tee_local	$push111=, $5=, $pop112
	i32.load	$push14=, e($pop111)
	i32.store	$push110=, 0($pop14), $5
	tee_local	$push109=, $5=, $pop110
	i32.load	$6=, p($pop109)
	i32.store	$3=, o($5), $5
	block
	br_if   	0, $6           # 0: down to label4
.LBB2_4:                                # %for.cond3.preheader.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_5 Depth 3
	loop                            # label5:
	block
	i32.load	$push118=, i($3)
	tee_local	$push117=, $7=, $pop118
	i32.load	$push116=, 0($pop117)
	tee_local	$push115=, $6=, $pop116
	i32.store	$push114=, 0($pop115), $3
	tee_local	$push113=, $5=, $pop114
	i32.load	$push15=, j($pop113)
	i32.load	$push16=, 0($pop15)
	i32.load	$push17=, 0($pop16)
	br_if   	0, $pop17       # 0: down to label7
.LBB2_5:                                # %if.end110.i
                                        #   Parent Loop BB2_1 Depth=1
                                        #     Parent Loop BB2_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label8:
	i32.load	$push18=, k($5)
	i32.add 	$push19=, $pop18, $0
	i32.store	$discard=, k($5), $pop19
	i32.store	$push2=, 0($6), $5
	i32.load	$push20=, j($pop2)
	i32.load	$push21=, 0($pop20)
	i32.load	$push22=, 0($pop21)
	i32.const	$push154=, 0
	i32.eq  	$push155=, $pop22, $pop154
	br_if   	0, $pop155      # 0: up to label8
.LBB2_6:                                # %for.end.i
                                        #   in Loop: Header=BB2_4 Depth=2
	end_loop                        # label9:
	end_block                       # label7:
	i32.load	$push23=, j($5)
	i32.load	$push24=, 0($pop23)
	i32.store	$discard=, 0($7), $pop24
	i32.load	$push27=, i($5)
	i32.load	$push25=, j($5)
	i32.load	$push26=, 0($pop25)
	i32.store	$discard=, 0($pop27), $pop26
	i32.load	$push30=, i($5)
	i32.load	$push28=, j($5)
	i32.load	$push29=, 0($pop28)
	i32.store	$discard=, 0($pop30), $pop29
	i32.load	$push33=, i($5)
	i32.load	$push31=, j($5)
	i32.load	$push32=, 0($pop31)
	i32.store	$discard=, 0($pop33), $pop32
	i32.load	$push36=, i($5)
	i32.load	$push34=, j($5)
	i32.load	$push35=, 0($pop34)
	i32.store	$discard=, 0($pop36), $pop35
	i32.load	$push39=, i($5)
	i32.load	$push37=, j($5)
	i32.load	$push38=, 0($pop37)
	i32.store	$discard=, 0($pop39), $pop38
	i32.load	$6=, h($5)
	i32.load	$push41=, i($5)
	i32.store	$push122=, 0($pop41), $5
	tee_local	$push121=, $5=, $pop122
	i32.load	$7=, e($pop121)
	i32.add 	$push40=, $6, $0
	i32.store	$discard=, h($5), $pop40
	i32.store	$push120=, 0($7), $5
	tee_local	$push119=, $5=, $pop120
	i32.load	$6=, p($pop119)
	i32.store	$discard=, o($5), $5
	i32.const	$push156=, 0
	i32.eq  	$push157=, $6, $pop156
	br_if   	0, $pop157      # 0: up to label5
.LBB2_7:                                # %foo.exit.thread
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label6:
	end_block                       # label4:
	i32.load	$5=, n($3)
	i32.store	$discard=, f($3), $3
.LBB2_8:                                # %for.inc7
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label2:
	i32.const	$push123=, -1
	i32.add 	$5=, $5, $pop123
	i32.store	$push3=, n($2), $5
	br_if   	0, $pop3        # 0: up to label0
# BB#9:                                 # %for.end8
	end_loop                        # label1:
	i32.const	$push42=, 0
	i32.load	$6=, b($pop42)
	i32.const	$push125=, 0
	i32.const	$push124=, 0
	i32.store8	$3=, u($pop125), $pop124
	block
	i32.const	$push158=, 0
	i32.eq  	$push159=, $6, $pop158
	br_if   	0, $pop159      # 0: down to label10
# BB#10:                                # %for.cond12.preheader.lr.ph
	i32.load	$0=, c($3)
.LBB2_11:                               # %for.cond12.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_12 Depth 2
	loop                            # label11:
	i32.const	$5=, 10
.LBB2_12:                               # %for.body15
                                        #   Parent Loop BB2_11 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label13:
	i32.const	$push134=, 2
	i32.shl 	$push43=, $0, $pop134
	i32.load	$push44=, a($pop43)
	i32.const	$push133=, 2
	i32.shl 	$push45=, $pop44, $pop133
	i32.load	$push46=, a($pop45)
	i32.const	$push132=, 2
	i32.shl 	$push47=, $pop46, $pop132
	i32.load	$push48=, a($pop47)
	i32.const	$push131=, 2
	i32.shl 	$push49=, $pop48, $pop131
	i32.load	$push50=, a($pop49)
	i32.const	$push130=, 2
	i32.shl 	$push51=, $pop50, $pop130
	i32.load	$push52=, a($pop51)
	i32.const	$push129=, 2
	i32.shl 	$push53=, $pop52, $pop129
	i32.load	$push54=, a($pop53)
	i32.const	$push128=, 2
	i32.shl 	$push55=, $pop54, $pop128
	i32.load	$push56=, a($pop55)
	i32.const	$push127=, 2
	i32.shl 	$push57=, $pop56, $pop127
	i32.load	$0=, a($pop57)
	i32.const	$push126=, -1
	i32.add 	$5=, $5, $pop126
	br_if   	0, $5           # 0: up to label13
# BB#13:                                # %for.inc27
                                        #   in Loop: Header=BB2_11 Depth=1
	end_loop                        # label14:
	i32.const	$push135=, 1
	i32.add 	$6=, $6, $pop135
	br_if   	0, $6           # 0: up to label11
# BB#14:                                # %for.cond9.for.end29_crit_edge
	end_loop                        # label12:
	i32.const	$push58=, 0
	i32.store	$discard=, c($pop58), $0
	i32.const	$push137=, 0
	i32.const	$push136=, 0
	i32.store	$discard=, b($pop137), $pop136
.LBB2_15:                               # %for.end29
	end_block                       # label10:
	call    	baz@FUNCTION
	block
	i32.load8_s	$push59=, u($3)
	i32.const	$push60=, 2
	i32.shl 	$push61=, $pop59, $pop60
	i32.load	$push62=, a($pop61)
	i32.const	$push151=, 2
	i32.shl 	$push63=, $pop62, $pop151
	i32.load	$push64=, a($pop63)
	i32.const	$push150=, 2
	i32.shl 	$push65=, $pop64, $pop150
	i32.load	$push66=, a($pop65)
	i32.const	$push149=, 2
	i32.shl 	$push67=, $pop66, $pop149
	i32.load	$push68=, a($pop67)
	i32.const	$push148=, 2
	i32.shl 	$push69=, $pop68, $pop148
	i32.load	$push70=, a($pop69)
	i32.const	$push147=, 2
	i32.shl 	$push71=, $pop70, $pop147
	i32.load	$push72=, a($pop71)
	i32.const	$push146=, 2
	i32.shl 	$push73=, $pop72, $pop146
	i32.load	$push74=, a($pop73)
	i32.const	$push145=, 2
	i32.shl 	$push75=, $pop74, $pop145
	i32.load	$push76=, a($pop75)
	i32.const	$push144=, 2
	i32.shl 	$push77=, $pop76, $pop144
	i32.load	$push78=, a($pop77)
	i32.const	$push143=, 2
	i32.shl 	$push79=, $pop78, $pop143
	i32.load	$push80=, a($pop79)
	i32.const	$push142=, 2
	i32.shl 	$push81=, $pop80, $pop142
	i32.load	$push82=, a($pop81)
	i32.const	$push141=, 2
	i32.shl 	$push83=, $pop82, $pop141
	i32.load	$push84=, a($pop83)
	i32.const	$push140=, 2
	i32.shl 	$push85=, $pop84, $pop140
	i32.load	$push86=, a($pop85)
	i32.const	$push139=, 2
	i32.shl 	$push87=, $pop86, $pop139
	i32.load	$push88=, a($pop87)
	i32.const	$push138=, 2
	i32.shl 	$push89=, $pop88, $pop138
	i32.load	$push90=, a($pop89)
	i32.const	$push160=, 0
	i32.eq  	$push161=, $pop90, $pop160
	br_if   	0, $pop161      # 0: down to label15
# BB#16:                                # %if.end47
	i32.const	$push98=, __stack_pointer
	i32.const	$push96=, 32
	i32.add 	$push97=, $4, $pop96
	i32.store	$discard=, 0($pop98), $pop97
	i32.const	$push91=, 0
	return  	$pop91
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
