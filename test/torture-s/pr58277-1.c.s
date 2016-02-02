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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 32
	i32.sub 	$10=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$10=, 0($8), $10
	i32.const	$push4=, 0
	i32.const	$push114=, 0
	i32.const	$push3=, 1
	i32.store	$push5=, a($pop114), $pop3
	i32.store	$0=, n($pop4), $pop5
	i32.const	$push113=, 0
	i32.const	$push112=, 0
	i32.store8	$1=, u($pop113), $pop112
	copy_local	$4=, $0
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_4 Depth 2
                                        #       Child Loop BB2_5 Depth 3
	loop                            # label0:
	block
	block
	i32.store	$push6=, g($1), $1
	tee_local	$push115=, $2=, $pop6
	i32.load	$push7=, l($pop115)
	i32.const	$push157=, 0
	i32.eq  	$push158=, $pop7, $pop157
	br_if   	$pop158, 0      # 0: down to label3
# BB#2:                                 # %for.end
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load	$push8=, j($2)
	i32.store	$push9=, 0($pop8), $2
	tee_local	$push126=, $5=, $pop9
	i32.store	$push10=, d($pop126), $5
	tee_local	$push125=, $5=, $pop10
	i32.load	$push13=, i($pop125)
	i32.load	$push11=, j($5)
	i32.load	$push12=, 0($pop11)
	i32.store	$discard=, 0($pop13), $pop12
	i32.load	$push14=, i($5)
	i32.store	$push15=, 0($pop14), $5
	tee_local	$push124=, $5=, $pop15
	i32.load	$push16=, i($pop124)
	i32.store	$push17=, 0($pop16), $5
	i32.load	$push18=, i($pop17)
	i32.store	$discard=, 0($pop18), $10
	br      	1               # 1: down to label2
.LBB2_3:                                # %for.cond.preheader.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label3:
	block
	i32.load	$push19=, i($2)
	i32.store	$push20=, 0($pop19), $2
	tee_local	$push118=, $4=, $pop20
	i32.load	$push21=, e($pop118)
	i32.store	$push22=, 0($pop21), $4
	tee_local	$push117=, $4=, $pop22
	i32.store	$push23=, o($pop117), $4
	tee_local	$push116=, $3=, $pop23
	i32.load	$push24=, p($pop116)
	br_if   	$pop24, 0       # 0: down to label4
.LBB2_4:                                # %for.cond3.preheader.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_5 Depth 3
	loop                            # label5:
	block
	i32.load	$push0=, i($3)
	tee_local	$push121=, $6=, $pop0
	i32.load	$push1=, 0($pop121)
	tee_local	$push120=, $5=, $pop1
	i32.store	$push25=, 0($pop120), $3
	tee_local	$push119=, $4=, $pop25
	i32.load	$push26=, j($pop119)
	i32.load	$push27=, 0($pop26)
	i32.load	$push28=, 0($pop27)
	br_if   	$pop28, 0       # 0: down to label7
.LBB2_5:                                # %if.end110.i
                                        #   Parent Loop BB2_1 Depth=1
                                        #     Parent Loop BB2_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label8:
	i32.load	$push29=, k($4)
	i32.add 	$push30=, $pop29, $0
	i32.store	$discard=, k($4), $pop30
	i32.store	$push31=, 0($5), $4
	i32.load	$push32=, j($pop31)
	i32.load	$push33=, 0($pop32)
	i32.load	$push34=, 0($pop33)
	i32.const	$push159=, 0
	i32.eq  	$push160=, $pop34, $pop159
	br_if   	$pop160, 0      # 0: up to label8
.LBB2_6:                                # %for.end.i
                                        #   in Loop: Header=BB2_4 Depth=2
	end_loop                        # label9:
	end_block                       # label7:
	i32.load	$push35=, j($4)
	i32.load	$push36=, 0($pop35)
	i32.store	$discard=, 0($6), $pop36
	i32.load	$push39=, i($4)
	i32.load	$push37=, j($4)
	i32.load	$push38=, 0($pop37)
	i32.store	$discard=, 0($pop39), $pop38
	i32.load	$push42=, i($4)
	i32.load	$push40=, j($4)
	i32.load	$push41=, 0($pop40)
	i32.store	$discard=, 0($pop42), $pop41
	i32.load	$push45=, i($4)
	i32.load	$push43=, j($4)
	i32.load	$push44=, 0($pop43)
	i32.store	$discard=, 0($pop45), $pop44
	i32.load	$push48=, i($4)
	i32.load	$push46=, j($4)
	i32.load	$push47=, 0($pop46)
	i32.store	$discard=, 0($pop48), $pop47
	i32.load	$push51=, i($4)
	i32.load	$push49=, j($4)
	i32.load	$push50=, 0($pop49)
	i32.store	$discard=, 0($pop51), $pop50
	i32.load	$5=, i($4)
	i32.load	$push52=, h($4)
	i32.add 	$push53=, $pop52, $0
	i32.store	$discard=, h($4), $pop53
	i32.store	$push54=, 0($5), $4
	tee_local	$push123=, $4=, $pop54
	i32.load	$push55=, e($pop123)
	i32.store	$push56=, 0($pop55), $4
	tee_local	$push122=, $4=, $pop56
	i32.store	$push57=, o($pop122), $4
	i32.load	$push58=, p($pop57)
	i32.const	$push161=, 0
	i32.eq  	$push162=, $pop58, $pop161
	br_if   	$pop162, 0      # 0: up to label5
.LBB2_7:                                # %foo.exit.thread
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label6:
	end_block                       # label4:
	i32.store	$push59=, f($3), $3
	i32.load	$4=, n($pop59)
.LBB2_8:                                # %for.inc7
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label2:
	i32.const	$push127=, -1
	i32.add 	$push2=, $4, $pop127
	i32.store	$4=, n($2), $pop2
	br_if   	$4, 0           # 0: up to label0
# BB#9:                                 # %for.end8
	end_loop                        # label1:
	block
	i32.const	$push60=, 0
	i32.const	$push130=, 0
	i32.store8	$push61=, u($pop60), $pop130
	tee_local	$push129=, $3=, $pop61
	i32.load	$push111=, b($pop129)
	tee_local	$push128=, $5=, $pop111
	i32.const	$push163=, 0
	i32.eq  	$push164=, $pop128, $pop163
	br_if   	$pop164, 0      # 0: down to label10
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
	i32.const	$push139=, 2
	i32.shl 	$push62=, $0, $pop139
	i32.load	$push63=, a($pop62)
	i32.const	$push138=, 2
	i32.shl 	$push64=, $pop63, $pop138
	i32.load	$push65=, a($pop64)
	i32.const	$push137=, 2
	i32.shl 	$push66=, $pop65, $pop137
	i32.load	$push67=, a($pop66)
	i32.const	$push136=, 2
	i32.shl 	$push68=, $pop67, $pop136
	i32.load	$push69=, a($pop68)
	i32.const	$push135=, 2
	i32.shl 	$push70=, $pop69, $pop135
	i32.load	$push71=, a($pop70)
	i32.const	$push134=, 2
	i32.shl 	$push72=, $pop71, $pop134
	i32.load	$push73=, a($pop72)
	i32.const	$push133=, 2
	i32.shl 	$push74=, $pop73, $pop133
	i32.load	$push75=, a($pop74)
	i32.const	$push132=, 2
	i32.shl 	$push76=, $pop75, $pop132
	i32.load	$0=, a($pop76)
	i32.const	$push131=, -1
	i32.add 	$4=, $4, $pop131
	br_if   	$4, 0           # 0: up to label13
# BB#13:                                # %for.inc27
                                        #   in Loop: Header=BB2_11 Depth=1
	end_loop                        # label14:
	i32.const	$push140=, 1
	i32.add 	$5=, $5, $pop140
	br_if   	$5, 0           # 0: up to label11
# BB#14:                                # %for.cond9.for.end29_crit_edge
	end_loop                        # label12:
	i32.const	$push77=, 0
	i32.store	$discard=, c($pop77), $0
	i32.const	$push142=, 0
	i32.const	$push141=, 0
	i32.store	$discard=, b($pop142), $pop141
.LBB2_15:                               # %for.end29
	end_block                       # label10:
	call    	baz@FUNCTION
	block
	i32.load8_s	$push78=, u($3)
	i32.const	$push79=, 2
	i32.shl 	$push80=, $pop78, $pop79
	i32.load	$push81=, a($pop80)
	i32.const	$push156=, 2
	i32.shl 	$push82=, $pop81, $pop156
	i32.load	$push83=, a($pop82)
	i32.const	$push155=, 2
	i32.shl 	$push84=, $pop83, $pop155
	i32.load	$push85=, a($pop84)
	i32.const	$push154=, 2
	i32.shl 	$push86=, $pop85, $pop154
	i32.load	$push87=, a($pop86)
	i32.const	$push153=, 2
	i32.shl 	$push88=, $pop87, $pop153
	i32.load	$push89=, a($pop88)
	i32.const	$push152=, 2
	i32.shl 	$push90=, $pop89, $pop152
	i32.load	$push91=, a($pop90)
	i32.const	$push151=, 2
	i32.shl 	$push92=, $pop91, $pop151
	i32.load	$push93=, a($pop92)
	i32.const	$push150=, 2
	i32.shl 	$push94=, $pop93, $pop150
	i32.load	$push95=, a($pop94)
	i32.const	$push149=, 2
	i32.shl 	$push96=, $pop95, $pop149
	i32.load	$push97=, a($pop96)
	i32.const	$push148=, 2
	i32.shl 	$push98=, $pop97, $pop148
	i32.load	$push99=, a($pop98)
	i32.const	$push147=, 2
	i32.shl 	$push100=, $pop99, $pop147
	i32.load	$push101=, a($pop100)
	i32.const	$push146=, 2
	i32.shl 	$push102=, $pop101, $pop146
	i32.load	$push103=, a($pop102)
	i32.const	$push145=, 2
	i32.shl 	$push104=, $pop103, $pop145
	i32.load	$push105=, a($pop104)
	i32.const	$push144=, 2
	i32.shl 	$push106=, $pop105, $pop144
	i32.load	$push107=, a($pop106)
	i32.const	$push143=, 2
	i32.shl 	$push108=, $pop107, $pop143
	i32.load	$push109=, a($pop108)
	i32.const	$push165=, 0
	i32.eq  	$push166=, $pop109, $pop165
	br_if   	$pop166, 0      # 0: down to label15
# BB#16:                                # %if.end47
	i32.const	$push110=, 0
	i32.const	$9=, 32
	i32.add 	$10=, $10, $9
	i32.const	$9=, __stack_pointer
	i32.store	$10=, 0($9), $10
	return  	$pop110
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
