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
	i32.const	$push89=, __stack_pointer
	i32.const	$push86=, __stack_pointer
	i32.load	$push87=, 0($pop86)
	i32.const	$push88=, 32
	i32.sub 	$push93=, $pop87, $pop88
	i32.store	$4=, 0($pop89), $pop93
	i32.const	$push5=, 0
	i32.const	$push96=, 0
	i32.const	$push4=, 1
	i32.store	$push0=, a($pop96), $pop4
	i32.store	$0=, n($pop5), $pop0
	i32.const	$push95=, 0
	i32.const	$push94=, 0
	i32.store8	$1=, u($pop95), $pop94
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
	i32.eqz 	$push146=, $6
	br_if   	0, $pop146      # 0: down to label3
# BB#2:                                 # %for.end
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load	$push6=, j($2)
	i32.store	$push102=, 0($pop6), $2
	tee_local	$push101=, $6=, $pop102
	i32.store	$push100=, d($pop101), $6
	tee_local	$push99=, $6=, $pop100
	i32.load	$3=, j($pop99)
	i32.load	$push8=, i($6)
	i32.load	$push7=, 0($3)
	i32.store	$drop=, 0($pop8), $pop7
	i32.load	$push9=, i($6)
	i32.store	$push98=, 0($pop9), $6
	tee_local	$push97=, $6=, $pop98
	i32.load	$push10=, i($pop97)
	i32.store	$push1=, 0($pop10), $6
	i32.load	$push11=, i($pop1)
	i32.store	$drop=, 0($pop11), $4
	br      	1               # 1: down to label2
.LBB2_3:                                # %for.cond.preheader.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label3:
	i32.load	$push12=, i($2)
	i32.store	$push106=, 0($pop12), $2
	tee_local	$push105=, $5=, $pop106
	i32.load	$push13=, e($pop105)
	i32.store	$push104=, 0($pop13), $5
	tee_local	$push103=, $5=, $pop104
	i32.load	$6=, p($pop103)
	i32.store	$3=, o($5), $5
	block
	br_if   	0, $6           # 0: down to label4
.LBB2_4:                                # %for.cond3.preheader.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_5 Depth 3
	loop                            # label5:
	block
	i32.load	$push112=, i($3)
	tee_local	$push111=, $7=, $pop112
	i32.load	$push110=, 0($pop111)
	tee_local	$push109=, $6=, $pop110
	i32.store	$push108=, 0($pop109), $3
	tee_local	$push107=, $5=, $pop108
	i32.load	$push14=, j($pop107)
	i32.load	$push15=, 0($pop14)
	i32.load	$push16=, 0($pop15)
	br_if   	0, $pop16       # 0: down to label7
.LBB2_5:                                # %if.end110.i
                                        #   Parent Loop BB2_1 Depth=1
                                        #     Parent Loop BB2_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label8:
	i32.load	$push17=, k($5)
	i32.add 	$push18=, $pop17, $0
	i32.store	$drop=, k($5), $pop18
	i32.store	$push2=, 0($6), $5
	i32.load	$push19=, j($pop2)
	i32.load	$push20=, 0($pop19)
	i32.load	$push21=, 0($pop20)
	i32.eqz 	$push147=, $pop21
	br_if   	0, $pop147      # 0: up to label8
.LBB2_6:                                # %for.end.i
                                        #   in Loop: Header=BB2_4 Depth=2
	end_loop                        # label9:
	end_block                       # label7:
	i32.load	$push22=, j($5)
	i32.load	$push23=, 0($pop22)
	i32.store	$drop=, 0($7), $pop23
	i32.load	$6=, j($5)
	i32.load	$push25=, i($5)
	i32.load	$push24=, 0($6)
	i32.store	$drop=, 0($pop25), $pop24
	i32.load	$6=, j($5)
	i32.load	$push27=, i($5)
	i32.load	$push26=, 0($6)
	i32.store	$drop=, 0($pop27), $pop26
	i32.load	$6=, j($5)
	i32.load	$push29=, i($5)
	i32.load	$push28=, 0($6)
	i32.store	$drop=, 0($pop29), $pop28
	i32.load	$6=, j($5)
	i32.load	$push31=, i($5)
	i32.load	$push30=, 0($6)
	i32.store	$drop=, 0($pop31), $pop30
	i32.load	$6=, j($5)
	i32.load	$push33=, i($5)
	i32.load	$push32=, 0($6)
	i32.store	$drop=, 0($pop33), $pop32
	i32.load	$6=, h($5)
	i32.load	$push35=, i($5)
	i32.store	$push116=, 0($pop35), $5
	tee_local	$push115=, $5=, $pop116
	i32.load	$7=, e($pop115)
	i32.add 	$push34=, $6, $0
	i32.store	$drop=, h($5), $pop34
	i32.store	$push114=, 0($7), $5
	tee_local	$push113=, $5=, $pop114
	i32.load	$6=, p($pop113)
	i32.store	$drop=, o($5), $5
	i32.eqz 	$push148=, $6
	br_if   	0, $pop148      # 0: up to label5
.LBB2_7:                                # %foo.exit.thread
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label6:
	end_block                       # label4:
	i32.load	$5=, n($3)
	i32.store	$drop=, f($3), $3
.LBB2_8:                                # %for.inc7
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label2:
	i32.const	$push117=, -1
	i32.add 	$5=, $5, $pop117
	i32.store	$push3=, n($2), $5
	br_if   	0, $pop3        # 0: up to label0
# BB#9:                                 # %for.end8
	end_loop                        # label1:
	i32.const	$push36=, 0
	i32.load	$6=, b($pop36)
	i32.const	$push119=, 0
	i32.const	$push118=, 0
	i32.store8	$3=, u($pop119), $pop118
	block
	i32.eqz 	$push149=, $6
	br_if   	0, $pop149      # 0: down to label10
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
	i32.const	$push128=, 2
	i32.shl 	$push37=, $0, $pop128
	i32.load	$push38=, a($pop37)
	i32.const	$push127=, 2
	i32.shl 	$push39=, $pop38, $pop127
	i32.load	$push40=, a($pop39)
	i32.const	$push126=, 2
	i32.shl 	$push41=, $pop40, $pop126
	i32.load	$push42=, a($pop41)
	i32.const	$push125=, 2
	i32.shl 	$push43=, $pop42, $pop125
	i32.load	$push44=, a($pop43)
	i32.const	$push124=, 2
	i32.shl 	$push45=, $pop44, $pop124
	i32.load	$push46=, a($pop45)
	i32.const	$push123=, 2
	i32.shl 	$push47=, $pop46, $pop123
	i32.load	$push48=, a($pop47)
	i32.const	$push122=, 2
	i32.shl 	$push49=, $pop48, $pop122
	i32.load	$push50=, a($pop49)
	i32.const	$push121=, 2
	i32.shl 	$push51=, $pop50, $pop121
	i32.load	$0=, a($pop51)
	i32.const	$push120=, -1
	i32.add 	$5=, $5, $pop120
	br_if   	0, $5           # 0: up to label13
# BB#13:                                # %for.inc27
                                        #   in Loop: Header=BB2_11 Depth=1
	end_loop                        # label14:
	i32.const	$push129=, 1
	i32.add 	$6=, $6, $pop129
	br_if   	0, $6           # 0: up to label11
# BB#14:                                # %for.cond9.for.end29_crit_edge
	end_loop                        # label12:
	i32.const	$push52=, 0
	i32.store	$drop=, c($pop52), $0
	i32.const	$push131=, 0
	i32.const	$push130=, 0
	i32.store	$drop=, b($pop131), $pop130
.LBB2_15:                               # %for.end29
	end_block                       # label10:
	call    	baz@FUNCTION
	block
	i32.load8_s	$push53=, u($3)
	i32.const	$push54=, 2
	i32.shl 	$push55=, $pop53, $pop54
	i32.load	$push56=, a($pop55)
	i32.const	$push145=, 2
	i32.shl 	$push57=, $pop56, $pop145
	i32.load	$push58=, a($pop57)
	i32.const	$push144=, 2
	i32.shl 	$push59=, $pop58, $pop144
	i32.load	$push60=, a($pop59)
	i32.const	$push143=, 2
	i32.shl 	$push61=, $pop60, $pop143
	i32.load	$push62=, a($pop61)
	i32.const	$push142=, 2
	i32.shl 	$push63=, $pop62, $pop142
	i32.load	$push64=, a($pop63)
	i32.const	$push141=, 2
	i32.shl 	$push65=, $pop64, $pop141
	i32.load	$push66=, a($pop65)
	i32.const	$push140=, 2
	i32.shl 	$push67=, $pop66, $pop140
	i32.load	$push68=, a($pop67)
	i32.const	$push139=, 2
	i32.shl 	$push69=, $pop68, $pop139
	i32.load	$push70=, a($pop69)
	i32.const	$push138=, 2
	i32.shl 	$push71=, $pop70, $pop138
	i32.load	$push72=, a($pop71)
	i32.const	$push137=, 2
	i32.shl 	$push73=, $pop72, $pop137
	i32.load	$push74=, a($pop73)
	i32.const	$push136=, 2
	i32.shl 	$push75=, $pop74, $pop136
	i32.load	$push76=, a($pop75)
	i32.const	$push135=, 2
	i32.shl 	$push77=, $pop76, $pop135
	i32.load	$push78=, a($pop77)
	i32.const	$push134=, 2
	i32.shl 	$push79=, $pop78, $pop134
	i32.load	$push80=, a($pop79)
	i32.const	$push133=, 2
	i32.shl 	$push81=, $pop80, $pop133
	i32.load	$push82=, a($pop81)
	i32.const	$push132=, 2
	i32.shl 	$push83=, $pop82, $pop132
	i32.load	$push84=, a($pop83)
	i32.eqz 	$push150=, $pop84
	br_if   	0, $pop150      # 0: down to label15
# BB#16:                                # %if.end47
	i32.const	$push92=, __stack_pointer
	i32.const	$push90=, 32
	i32.add 	$push91=, $4, $pop90
	i32.store	$drop=, 0($pop92), $pop91
	i32.const	$push85=, 0
	return  	$pop85
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
