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
	i32.load	$push1=, a($1)
	tee_local	$push93=, $12=, $pop1
	i32.load	$push2=, 0($0)
	i32.store	$push3=, j($1), $pop2
	i32.mul 	$push4=, $pop93, $pop3
	i32.const	$push5=, -1
	i32.add 	$push6=, $pop4, $pop5
	i32.store	$discard=, h($1), $pop6
	i32.const	$push7=, 1
	i32.store	$2=, f($1), $pop7
	i32.load	$push8=, 0($0)
	i32.store	$push9=, j($1), $pop8
	i32.mul 	$push10=, $12, $pop9
	i32.const	$push92=, -1
	i32.add 	$push11=, $pop10, $pop92
	i32.store	$discard=, h($1), $pop11
	i32.const	$push12=, 2
	i32.store	$3=, f($1), $pop12
	i32.load	$push13=, 0($0)
	i32.store	$push14=, j($1), $pop13
	i32.mul 	$push15=, $12, $pop14
	i32.const	$push91=, -1
	i32.add 	$push16=, $pop15, $pop91
	i32.store	$discard=, h($1), $pop16
	i32.const	$push17=, 3
	i32.store	$4=, f($1), $pop17
	i32.load	$push18=, 0($0)
	i32.store	$push19=, j($1), $pop18
	i32.mul 	$push20=, $12, $pop19
	i32.const	$push90=, -1
	i32.add 	$push21=, $pop20, $pop90
	i32.store	$discard=, h($1), $pop21
	i32.const	$push22=, 4
	i32.store	$5=, f($1), $pop22
	i32.load	$push23=, 0($0)
	i32.store	$push24=, j($1), $pop23
	i32.mul 	$push25=, $12, $pop24
	i32.const	$push89=, -1
	i32.add 	$push26=, $pop25, $pop89
	i32.store	$discard=, h($1), $pop26
	i32.const	$push27=, 5
	i32.store	$6=, f($1), $pop27
	i32.load	$push28=, 0($0)
	i32.store	$push29=, j($1), $pop28
	i32.mul 	$push30=, $12, $pop29
	i32.const	$push88=, -1
	i32.add 	$push31=, $pop30, $pop88
	i32.store	$discard=, h($1), $pop31
	i32.const	$push32=, 6
	i32.store	$7=, f($1), $pop32
	i32.load	$push33=, 0($0)
	i32.store	$push34=, j($1), $pop33
	i32.mul 	$push35=, $12, $pop34
	i32.const	$push87=, -1
	i32.add 	$push36=, $pop35, $pop87
	i32.store	$discard=, h($1), $pop36
	i32.const	$push37=, 7
	i32.store	$8=, f($1), $pop37
	i32.load	$push38=, 0($0)
	i32.store	$push39=, j($1), $pop38
	i32.mul 	$push40=, $12, $pop39
	i32.const	$push86=, -1
	i32.add 	$push41=, $pop40, $pop86
	i32.store	$discard=, h($1), $pop41
	i32.const	$push42=, 8
	i32.store	$9=, f($1), $pop42
	i32.store	$11=, f($1), $1
	i32.load	$push43=, 0($0)
	i32.store	$push44=, j($11), $pop43
	i32.mul 	$push45=, $12, $pop44
	i32.const	$push85=, -1
	i32.add 	$push46=, $pop45, $pop85
	i32.store	$discard=, h($11), $pop46
	i32.store	$discard=, f($11), $2
	i32.load	$push47=, 0($0)
	i32.store	$push48=, j($11), $pop47
	i32.mul 	$push49=, $12, $pop48
	i32.const	$push84=, -1
	i32.add 	$push50=, $pop49, $pop84
	i32.store	$discard=, h($11), $pop50
	i32.store	$discard=, f($11), $3
	i32.load	$push51=, 0($0)
	i32.store	$push52=, j($11), $pop51
	i32.mul 	$push53=, $12, $pop52
	i32.const	$push83=, -1
	i32.add 	$push54=, $pop53, $pop83
	i32.store	$discard=, h($11), $pop54
	i32.store	$discard=, f($11), $4
	i32.load	$push55=, 0($0)
	i32.store	$push56=, j($11), $pop55
	i32.mul 	$push57=, $12, $pop56
	i32.const	$push82=, -1
	i32.add 	$push58=, $pop57, $pop82
	i32.store	$discard=, h($11), $pop58
	i32.store	$discard=, f($11), $5
	i32.load	$push59=, 0($0)
	i32.store	$push60=, j($11), $pop59
	i32.mul 	$push61=, $12, $pop60
	i32.const	$push81=, -1
	i32.add 	$push62=, $pop61, $pop81
	i32.store	$discard=, h($11), $pop62
	i32.store	$discard=, f($11), $6
	i32.load	$push63=, 0($0)
	i32.store	$push64=, j($11), $pop63
	i32.mul 	$push65=, $12, $pop64
	i32.const	$push80=, -1
	i32.add 	$push66=, $pop65, $pop80
	i32.store	$discard=, h($11), $pop66
	i32.store	$discard=, f($11), $7
	i32.load	$push67=, 0($0)
	i32.store	$push68=, j($11), $pop67
	i32.mul 	$push69=, $12, $pop68
	i32.const	$push79=, -1
	i32.add 	$push70=, $pop69, $pop79
	i32.store	$discard=, h($11), $pop70
	i32.store	$discard=, f($11), $8
	i64.load32_s	$10=, b($1)
	i32.load	$push71=, 0($0)
	i32.store	$1=, j($11), $pop71
	i32.store	$discard=, f($11), $9
	i32.mul 	$push72=, $12, $1
	i32.const	$push78=, -1
	i32.add 	$push73=, $pop72, $pop78
	i32.store	$push74=, h($11), $pop73
	i32.eq  	$push75=, $11, $pop74
	i64.extend_u/i32	$push76=, $pop75
	i64.lt_s	$push77=, $pop76, $10
	i32.store	$1=, e($11), $pop77
	i32.const	$16=, 12
	i32.add 	$16=, $17, $16
	i32.store	$discard=, g($11), $16
	block
	i32.const	$push96=, 0
	i32.eq  	$push97=, $1, $pop96
	br_if   	$pop97, 0       # 0: down to label0
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
