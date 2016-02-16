	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57876.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %for.body4.1
	i32.const	$13=, __stack_pointer
	i32.load	$13=, 0($13)
	i32.const	$14=, 16
	i32.sub 	$17=, $13, $14
	i32.const	$14=, __stack_pointer
	i32.store	$17=, 0($14), $17
	i32.const	$push0=, 0
	i32.load	$0=, d($pop0)
	i32.const	$push95=, 0
	i32.const	$push94=, 0
	i32.store	$1=, f($pop95), $pop94
	i32.load	$push93=, a($1)
	tee_local	$push92=, $12=, $pop93
	i32.load	$push1=, 0($0)
	i32.store	$push2=, j($1), $pop1
	i32.mul 	$push3=, $pop92, $pop2
	i32.const	$push4=, -1
	i32.add 	$push5=, $pop3, $pop4
	i32.store	$discard=, h($1), $pop5
	i32.const	$push6=, 1
	i32.store	$2=, f($1), $pop6
	i32.load	$push7=, 0($0)
	i32.store	$push8=, j($1), $pop7
	i32.mul 	$push9=, $12, $pop8
	i32.const	$push91=, -1
	i32.add 	$push10=, $pop9, $pop91
	i32.store	$discard=, h($1), $pop10
	i32.const	$push11=, 2
	i32.store	$3=, f($1), $pop11
	i32.load	$push12=, 0($0)
	i32.store	$push13=, j($1), $pop12
	i32.mul 	$push14=, $12, $pop13
	i32.const	$push90=, -1
	i32.add 	$push15=, $pop14, $pop90
	i32.store	$discard=, h($1), $pop15
	i32.const	$push16=, 3
	i32.store	$4=, f($1), $pop16
	i32.load	$push17=, 0($0)
	i32.store	$push18=, j($1), $pop17
	i32.mul 	$push19=, $12, $pop18
	i32.const	$push89=, -1
	i32.add 	$push20=, $pop19, $pop89
	i32.store	$discard=, h($1), $pop20
	i32.const	$push21=, 4
	i32.store	$5=, f($1), $pop21
	i32.load	$push22=, 0($0)
	i32.store	$push23=, j($1), $pop22
	i32.mul 	$push24=, $12, $pop23
	i32.const	$push88=, -1
	i32.add 	$push25=, $pop24, $pop88
	i32.store	$discard=, h($1), $pop25
	i32.const	$push26=, 5
	i32.store	$6=, f($1), $pop26
	i32.load	$push27=, 0($0)
	i32.store	$push28=, j($1), $pop27
	i32.mul 	$push29=, $12, $pop28
	i32.const	$push87=, -1
	i32.add 	$push30=, $pop29, $pop87
	i32.store	$discard=, h($1), $pop30
	i32.const	$push31=, 6
	i32.store	$7=, f($1), $pop31
	i32.load	$push32=, 0($0)
	i32.store	$push33=, j($1), $pop32
	i32.mul 	$push34=, $12, $pop33
	i32.const	$push86=, -1
	i32.add 	$push35=, $pop34, $pop86
	i32.store	$discard=, h($1), $pop35
	i32.const	$push36=, 7
	i32.store	$8=, f($1), $pop36
	i32.load	$push37=, 0($0)
	i32.store	$push38=, j($1), $pop37
	i32.mul 	$push39=, $12, $pop38
	i32.const	$push85=, -1
	i32.add 	$push40=, $pop39, $pop85
	i32.store	$discard=, h($1), $pop40
	i32.const	$push41=, 8
	i32.store	$9=, f($1), $pop41
	i32.store	$11=, f($1), $1
	i32.load	$push42=, 0($0)
	i32.store	$push43=, j($11), $pop42
	i32.mul 	$push44=, $12, $pop43
	i32.const	$push84=, -1
	i32.add 	$push45=, $pop44, $pop84
	i32.store	$discard=, h($11), $pop45
	i32.store	$discard=, f($11), $2
	i32.load	$push46=, 0($0)
	i32.store	$push47=, j($11), $pop46
	i32.mul 	$push48=, $12, $pop47
	i32.const	$push83=, -1
	i32.add 	$push49=, $pop48, $pop83
	i32.store	$discard=, h($11), $pop49
	i32.store	$discard=, f($11), $3
	i32.load	$push50=, 0($0)
	i32.store	$push51=, j($11), $pop50
	i32.mul 	$push52=, $12, $pop51
	i32.const	$push82=, -1
	i32.add 	$push53=, $pop52, $pop82
	i32.store	$discard=, h($11), $pop53
	i32.store	$discard=, f($11), $4
	i32.load	$push54=, 0($0)
	i32.store	$push55=, j($11), $pop54
	i32.mul 	$push56=, $12, $pop55
	i32.const	$push81=, -1
	i32.add 	$push57=, $pop56, $pop81
	i32.store	$discard=, h($11), $pop57
	i32.store	$discard=, f($11), $5
	i32.load	$push58=, 0($0)
	i32.store	$push59=, j($11), $pop58
	i32.mul 	$push60=, $12, $pop59
	i32.const	$push80=, -1
	i32.add 	$push61=, $pop60, $pop80
	i32.store	$discard=, h($11), $pop61
	i32.store	$discard=, f($11), $6
	i32.load	$push62=, 0($0)
	i32.store	$push63=, j($11), $pop62
	i32.mul 	$push64=, $12, $pop63
	i32.const	$push79=, -1
	i32.add 	$push65=, $pop64, $pop79
	i32.store	$discard=, h($11), $pop65
	i32.store	$discard=, f($11), $7
	i32.load	$push66=, 0($0)
	i32.store	$push67=, j($11), $pop66
	i32.mul 	$push68=, $12, $pop67
	i32.const	$push78=, -1
	i32.add 	$push69=, $pop68, $pop78
	i32.store	$discard=, h($11), $pop69
	i32.store	$discard=, f($11), $8
	i64.load32_s	$10=, b($1)
	i32.load	$push70=, 0($0)
	i32.store	$1=, j($11), $pop70
	i32.store	$discard=, f($11), $9
	i32.mul 	$push71=, $12, $1
	i32.const	$push77=, -1
	i32.add 	$push72=, $pop71, $pop77
	i32.store	$push73=, h($11), $pop72
	i32.eq  	$push74=, $11, $pop73
	i64.extend_u/i32	$push75=, $pop74
	i64.lt_s	$push76=, $pop75, $10
	i32.store	$1=, e($11), $pop76
	i32.const	$16=, 12
	i32.add 	$16=, $17, $16
	i32.store	$discard=, g($11), $16
	block
	i32.const	$push96=, 0
	i32.eq  	$push97=, $1, $pop96
	br_if   	0, $pop97       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$15=, 16
	i32.add 	$17=, $17, $15
	i32.const	$15=, __stack_pointer
	i32.store	$17=, 0($15), $17
	return  	$11
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.p2align	2
b:
	.int32	1                       # 0x1
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.data.d,"aw",@progbits
	.globl	d
	.p2align	2
d:
	.int32	c
	.size	d, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.int32	0                       # 0x0
	.size	f, 4

	.type	e,@object               # @e
	.lcomm	e,4,2
	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
	.p2align	2
j:
	.int32	0                       # 0x0
	.size	j, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
	.p2align	2
h:
	.int32	0                       # 0x0
	.size	h, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.p2align	2
g:
	.int32	0
	.size	g, 4


	.ident	"clang version 3.9.0 "
