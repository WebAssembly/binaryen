	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58419.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 24
	i32.sub 	$push0=, $0, $1
	i32.shl 	$push1=, $pop0, $2
	i32.shr_s	$push2=, $pop1, $2
	return  	$pop2
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, p($0)
	i32.const	$push0=, 1
	i32.store16	$discard=, c($0), $pop0
	i32.store	$push1=, 0($1), $0
	return  	$pop1
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$0=, p($1)
	i32.load16_u	$5=, c($1)
	i32.const	$push0=, 234
	i32.store8	$discard=, b($1), $pop0
	i32.const	$2=, 65535
	i32.const	$6=, 1
	i32.const	$3=, 255
	copy_local	$4=, $6
	block   	.LBB2_2
	i32.load	$push1=, k($1)
	i32.ne  	$push4=, $pop1, $1
	i32.and 	$push2=, $5, $2
	i32.ne  	$push3=, $pop2, $1
	i32.and 	$push5=, $pop4, $pop3
	i32.load	$push6=, i($1)
	i32.lt_s	$push7=, $pop6, $6
	i32.sub 	$push8=, $pop5, $pop7
	i32.and 	$push9=, $pop8, $3
	br_if   	$pop9, .LBB2_2
# BB#1:                                 # %lor.rhs
	i32.const	$4=, 0
	i32.const	$push10=, 1
	i32.store16	$5=, c($4), $pop10
	i32.store	$discard=, 0($0), $4
.LBB2_2:                                # %lor.end
	i32.store	$discard=, g($1), $4
	copy_local	$4=, $6
	block   	.LBB2_4
	i32.load	$push11=, k($1)
	i32.ne  	$push14=, $pop11, $1
	i32.and 	$push12=, $5, $2
	i32.ne  	$push13=, $pop12, $1
	i32.and 	$push15=, $pop14, $pop13
	i32.load	$push16=, i($1)
	i32.lt_s	$push17=, $pop16, $6
	i32.sub 	$push18=, $pop15, $pop17
	i32.and 	$push19=, $pop18, $3
	br_if   	$pop19, .LBB2_4
# BB#3:                                 # %lor.rhs.1
	i32.const	$4=, 0
	i32.const	$push20=, 1
	i32.store16	$5=, c($4), $pop20
	i32.store	$discard=, 0($0), $4
.LBB2_4:                                # %lor.end.1
	i32.store	$discard=, g($1), $4
	copy_local	$4=, $6
	block   	.LBB2_6
	i32.load	$push21=, k($1)
	i32.ne  	$push24=, $pop21, $1
	i32.and 	$push22=, $5, $2
	i32.ne  	$push23=, $pop22, $1
	i32.and 	$push25=, $pop24, $pop23
	i32.load	$push26=, i($1)
	i32.lt_s	$push27=, $pop26, $6
	i32.sub 	$push28=, $pop25, $pop27
	i32.and 	$push29=, $pop28, $3
	br_if   	$pop29, .LBB2_6
# BB#5:                                 # %lor.rhs.2
	i32.const	$4=, 0
	i32.const	$push30=, 1
	i32.store16	$5=, c($4), $pop30
	i32.store	$discard=, 0($0), $4
.LBB2_6:                                # %lor.end.2
	i32.store	$discard=, g($1), $4
	copy_local	$4=, $6
	block   	.LBB2_8
	i32.load	$push31=, k($1)
	i32.ne  	$push34=, $pop31, $1
	i32.and 	$push32=, $5, $2
	i32.ne  	$push33=, $pop32, $1
	i32.and 	$push35=, $pop34, $pop33
	i32.load	$push36=, i($1)
	i32.lt_s	$push37=, $pop36, $6
	i32.sub 	$push38=, $pop35, $pop37
	i32.and 	$push39=, $pop38, $3
	br_if   	$pop39, .LBB2_8
# BB#7:                                 # %lor.rhs.3
	i32.const	$4=, 0
	i32.const	$push40=, 1
	i32.store16	$5=, c($4), $pop40
	i32.store	$discard=, 0($0), $4
.LBB2_8:                                # %lor.end.3
	i32.store	$discard=, g($1), $4
	copy_local	$4=, $6
	block   	.LBB2_10
	i32.load	$push41=, k($1)
	i32.ne  	$push44=, $pop41, $1
	i32.and 	$push42=, $5, $2
	i32.ne  	$push43=, $pop42, $1
	i32.and 	$push45=, $pop44, $pop43
	i32.load	$push46=, i($1)
	i32.lt_s	$push47=, $pop46, $6
	i32.sub 	$push48=, $pop45, $pop47
	i32.and 	$push49=, $pop48, $3
	br_if   	$pop49, .LBB2_10
# BB#9:                                 # %lor.rhs.4
	i32.const	$4=, 0
	i32.const	$push50=, 1
	i32.store16	$5=, c($4), $pop50
	i32.store	$discard=, 0($0), $4
.LBB2_10:                               # %lor.end.4
	i32.store	$discard=, g($1), $4
	copy_local	$4=, $6
	block   	.LBB2_12
	i32.load	$push51=, k($1)
	i32.ne  	$push54=, $pop51, $1
	i32.and 	$push52=, $5, $2
	i32.ne  	$push53=, $pop52, $1
	i32.and 	$push55=, $pop54, $pop53
	i32.load	$push56=, i($1)
	i32.lt_s	$push57=, $pop56, $6
	i32.sub 	$push58=, $pop55, $pop57
	i32.and 	$push59=, $pop58, $3
	br_if   	$pop59, .LBB2_12
# BB#11:                                # %lor.rhs.5
	i32.const	$4=, 0
	i32.const	$push60=, 1
	i32.store16	$5=, c($4), $pop60
	i32.store	$discard=, 0($0), $4
.LBB2_12:                               # %lor.end.5
	i32.store	$discard=, g($1), $4
	copy_local	$4=, $6
	block   	.LBB2_14
	i32.load	$push61=, k($1)
	i32.ne  	$push64=, $pop61, $1
	i32.and 	$push62=, $5, $2
	i32.ne  	$push63=, $pop62, $1
	i32.and 	$push65=, $pop64, $pop63
	i32.load	$push66=, i($1)
	i32.lt_s	$push67=, $pop66, $6
	i32.sub 	$push68=, $pop65, $pop67
	i32.and 	$push69=, $pop68, $3
	br_if   	$pop69, .LBB2_14
# BB#13:                                # %lor.rhs.6
	i32.const	$4=, 0
	i32.const	$push70=, 1
	i32.store16	$5=, c($4), $pop70
	i32.store	$discard=, 0($0), $4
.LBB2_14:                               # %lor.end.6
	i32.store	$discard=, g($1), $4
	i32.load	$push71=, k($1)
	i32.ne  	$push74=, $pop71, $1
	i32.and 	$push72=, $5, $2
	i32.ne  	$push73=, $pop72, $1
	i32.and 	$5=, $pop74, $pop73
	i32.load	$2=, a($1)
	block   	.LBB2_16
	i32.load	$push75=, i($1)
	i32.lt_s	$push76=, $pop75, $6
	i32.sub 	$push77=, $5, $pop76
	i32.and 	$push78=, $pop77, $3
	br_if   	$pop78, .LBB2_16
# BB#15:                                # %lor.rhs.7
	i32.const	$push79=, 1
	i32.store16	$discard=, c($1), $pop79
	i32.store	$6=, 0($0), $1
.LBB2_16:                               # %lor.end.7
	i32.store	$discard=, g($1), $6
	i32.store16	$discard=, h($1), $2
	i32.store8	$discard=, e($1), $5
	i32.const	$push80=, 226
	i32.store8	$discard=, b($1), $pop80
	i32.call	$discard=, getpid
	return  	$1
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.align	1
c:
	.int16	0                       # 0x0
	.size	c, 2

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.align	2
p:
	.int32	0
	.size	p, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
b:
	.int8	0                       # 0x0
	.size	b, 1

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
	.align	1
h:
	.int16	0                       # 0x0
	.size	h, 2

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
e:
	.int8	0                       # 0x0
	.size	e, 1

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.align	2
k:
	.int32	0                       # 0x0
	.size	k, 4

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.align	2
g:
	.int32	0                       # 0x0
	.size	g, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
