	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57876.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i32
# BB#0:                                 # %for.body4.1
	i32.const	$push80=, __stack_pointer
	i32.const	$push77=, __stack_pointer
	i32.load	$push78=, 0($pop77)
	i32.const	$push79=, 16
	i32.sub 	$push86=, $pop78, $pop79
	i32.store	$9=, 0($pop80), $pop86
	i32.const	$push16=, 0
	i32.load	$10=, d($pop16)
	i32.const	$push105=, 0
	i32.const	$push104=, 0
	i32.store	$8=, f($pop105), $pop104
	i32.load	$push103=, a($8)
	tee_local	$push102=, $12=, $pop103
	i32.load	$push17=, 0($10)
	i32.store	$push0=, j($8), $pop17
	i32.mul 	$push18=, $pop102, $pop0
	i32.const	$push19=, -1
	i32.add 	$push20=, $pop18, $pop19
	i32.store	$discard=, h($8), $pop20
	i32.const	$push21=, 1
	i32.store	$0=, f($8), $pop21
	i32.load	$push22=, 0($10)
	i32.store	$push1=, j($8), $pop22
	i32.mul 	$push23=, $12, $pop1
	i32.const	$push101=, -1
	i32.add 	$push24=, $pop23, $pop101
	i32.store	$discard=, h($8), $pop24
	i32.const	$push25=, 2
	i32.store	$1=, f($8), $pop25
	i32.load	$push26=, 0($10)
	i32.store	$push2=, j($8), $pop26
	i32.mul 	$push27=, $12, $pop2
	i32.const	$push100=, -1
	i32.add 	$push28=, $pop27, $pop100
	i32.store	$discard=, h($8), $pop28
	i32.const	$push29=, 3
	i32.store	$2=, f($8), $pop29
	i32.load	$push30=, 0($10)
	i32.store	$push3=, j($8), $pop30
	i32.mul 	$push31=, $12, $pop3
	i32.const	$push99=, -1
	i32.add 	$push32=, $pop31, $pop99
	i32.store	$discard=, h($8), $pop32
	i32.const	$push33=, 4
	i32.store	$3=, f($8), $pop33
	i32.load	$push34=, 0($10)
	i32.store	$push4=, j($8), $pop34
	i32.mul 	$push35=, $12, $pop4
	i32.const	$push98=, -1
	i32.add 	$push36=, $pop35, $pop98
	i32.store	$discard=, h($8), $pop36
	i32.const	$push37=, 5
	i32.store	$4=, f($8), $pop37
	i32.load	$push38=, 0($10)
	i32.store	$push5=, j($8), $pop38
	i32.mul 	$push39=, $12, $pop5
	i32.const	$push97=, -1
	i32.add 	$push40=, $pop39, $pop97
	i32.store	$discard=, h($8), $pop40
	i32.const	$push41=, 6
	i32.store	$5=, f($8), $pop41
	i32.load	$push42=, 0($10)
	i32.store	$push6=, j($8), $pop42
	i32.mul 	$push43=, $12, $pop6
	i32.const	$push96=, -1
	i32.add 	$push44=, $pop43, $pop96
	i32.store	$discard=, h($8), $pop44
	i32.const	$push45=, 7
	i32.store	$6=, f($8), $pop45
	i32.load	$push46=, 0($10)
	i32.store	$push7=, j($8), $pop46
	i32.mul 	$push47=, $12, $pop7
	i32.const	$push95=, -1
	i32.add 	$push48=, $pop47, $pop95
	i32.store	$discard=, h($8), $pop48
	i32.const	$push49=, 8
	i32.store	$7=, f($8), $pop49
	i32.store	$discard=, f($8), $8
	i32.load	$push50=, 0($10)
	i32.store	$push8=, j($8), $pop50
	i32.mul 	$push51=, $12, $pop8
	i32.const	$push94=, -1
	i32.add 	$push52=, $pop51, $pop94
	i32.store	$discard=, h($8), $pop52
	i32.store	$discard=, f($8), $0
	i32.load	$push53=, 0($10)
	i32.store	$push9=, j($8), $pop53
	i32.mul 	$push54=, $12, $pop9
	i32.const	$push93=, -1
	i32.add 	$push55=, $pop54, $pop93
	i32.store	$discard=, h($8), $pop55
	i32.store	$discard=, f($8), $1
	i32.load	$push56=, 0($10)
	i32.store	$push10=, j($8), $pop56
	i32.mul 	$push57=, $12, $pop10
	i32.const	$push92=, -1
	i32.add 	$push58=, $pop57, $pop92
	i32.store	$discard=, h($8), $pop58
	i32.store	$discard=, f($8), $2
	i32.load	$push59=, 0($10)
	i32.store	$push11=, j($8), $pop59
	i32.mul 	$push60=, $12, $pop11
	i32.const	$push91=, -1
	i32.add 	$push61=, $pop60, $pop91
	i32.store	$discard=, h($8), $pop61
	i32.store	$discard=, f($8), $3
	i32.load	$push62=, 0($10)
	i32.store	$push12=, j($8), $pop62
	i32.mul 	$push63=, $12, $pop12
	i32.const	$push90=, -1
	i32.add 	$push64=, $pop63, $pop90
	i32.store	$discard=, h($8), $pop64
	i32.store	$discard=, f($8), $4
	i32.load	$push65=, 0($10)
	i32.store	$push13=, j($8), $pop65
	i32.mul 	$push66=, $12, $pop13
	i32.const	$push89=, -1
	i32.add 	$push67=, $pop66, $pop89
	i32.store	$discard=, h($8), $pop67
	i32.store	$discard=, f($8), $5
	i32.load	$push68=, 0($10)
	i32.store	$push14=, j($8), $pop68
	i32.mul 	$push69=, $12, $pop14
	i32.const	$push88=, -1
	i32.add 	$push70=, $pop69, $pop88
	i32.store	$discard=, h($8), $pop70
	i32.store	$discard=, f($8), $6
	i32.load	$push71=, 0($10)
	i32.store	$10=, j($8), $pop71
	i32.store	$discard=, f($8), $7
	i64.load32_s	$11=, b($8)
	i32.mul 	$push72=, $12, $10
	i32.const	$push87=, -1
	i32.add 	$push73=, $pop72, $pop87
	i32.store	$push15=, h($8), $pop73
	i32.eqz 	$push74=, $pop15
	i64.extend_u/i32	$push75=, $pop74
	i64.lt_s	$push76=, $pop75, $11
	i32.store	$10=, e($8), $pop76
	i32.const	$push84=, 12
	i32.add 	$push85=, $9, $pop84
	i32.store	$discard=, g($8), $pop85
	block
	i32.const	$push106=, 0
	i32.eq  	$push107=, $10, $pop106
	br_if   	0, $pop107      # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push83=, __stack_pointer
	i32.const	$push81=, 16
	i32.add 	$push82=, $9, $pop81
	i32.store	$discard=, 0($pop83), $pop82
	return  	$8
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
