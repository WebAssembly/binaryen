	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57876.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64
# BB#0:                                 # %for.body4.1
	i32.const	$push65=, 0
	i32.const	$push62=, 0
	i32.load	$push63=, __stack_pointer($pop62)
	i32.const	$push64=, 16
	i32.sub 	$push71=, $pop63, $pop64
	i32.store	$10=, __stack_pointer($pop65), $pop71
	i32.const	$push1=, 0
	i32.load	$11=, d($pop1)
	i32.const	$push94=, 0
	i32.const	$push93=, 0
	i32.store	$push92=, f($pop94), $pop93
	tee_local	$push91=, $0=, $pop92
	i32.load	$push2=, 0($11)
	i32.store	$1=, j($pop91), $pop2
	i32.const	$push3=, 1
	i32.store	$2=, f($0), $pop3
	i32.load	$push90=, a($0)
	tee_local	$push89=, $12=, $pop90
	i32.mul 	$push4=, $1, $pop89
	i32.const	$push5=, -1
	i32.add 	$push6=, $pop4, $pop5
	i32.store	$drop=, h($0), $pop6
	i32.load	$push7=, 0($11)
	i32.store	$1=, j($0), $pop7
	i32.const	$push8=, 2
	i32.store	$3=, f($0), $pop8
	i32.mul 	$push9=, $12, $1
	i32.const	$push88=, -1
	i32.add 	$push10=, $pop9, $pop88
	i32.store	$drop=, h($0), $pop10
	i32.load	$push11=, 0($11)
	i32.store	$1=, j($0), $pop11
	i32.const	$push12=, 3
	i32.store	$4=, f($0), $pop12
	i32.mul 	$push13=, $12, $1
	i32.const	$push87=, -1
	i32.add 	$push14=, $pop13, $pop87
	i32.store	$drop=, h($0), $pop14
	i32.load	$push15=, 0($11)
	i32.store	$1=, j($0), $pop15
	i32.const	$push16=, 4
	i32.store	$5=, f($0), $pop16
	i32.mul 	$push17=, $12, $1
	i32.const	$push86=, -1
	i32.add 	$push18=, $pop17, $pop86
	i32.store	$drop=, h($0), $pop18
	i32.load	$push19=, 0($11)
	i32.store	$1=, j($0), $pop19
	i32.const	$push20=, 5
	i32.store	$6=, f($0), $pop20
	i32.mul 	$push21=, $12, $1
	i32.const	$push85=, -1
	i32.add 	$push22=, $pop21, $pop85
	i32.store	$drop=, h($0), $pop22
	i32.load	$push23=, 0($11)
	i32.store	$1=, j($0), $pop23
	i32.const	$push24=, 6
	i32.store	$7=, f($0), $pop24
	i32.mul 	$push25=, $12, $1
	i32.const	$push84=, -1
	i32.add 	$push26=, $pop25, $pop84
	i32.store	$drop=, h($0), $pop26
	i32.load	$push27=, 0($11)
	i32.store	$1=, j($0), $pop27
	i32.const	$push28=, 7
	i32.store	$8=, f($0), $pop28
	i32.mul 	$push29=, $12, $1
	i32.const	$push83=, -1
	i32.add 	$push30=, $pop29, $pop83
	i32.store	$drop=, h($0), $pop30
	i32.load	$push31=, 0($11)
	i32.store	$1=, j($0), $pop31
	i32.const	$push32=, 8
	i32.store	$9=, f($0), $pop32
	i32.mul 	$push33=, $12, $1
	i32.const	$push82=, -1
	i32.add 	$push34=, $pop33, $pop82
	i32.store	$drop=, h($0), $pop34
	i64.load32_s	$13=, b($0)
	i32.store	$push81=, f($0), $0
	tee_local	$push80=, $0=, $pop81
	i32.load	$push35=, 0($11)
	i32.store	$1=, j($pop80), $pop35
	i32.store	$drop=, f($0), $2
	i32.mul 	$push36=, $12, $1
	i32.const	$push79=, -1
	i32.add 	$push37=, $pop36, $pop79
	i32.store	$drop=, h($0), $pop37
	i32.load	$push38=, 0($11)
	i32.store	$1=, j($0), $pop38
	i32.store	$drop=, f($0), $3
	i32.mul 	$push39=, $12, $1
	i32.const	$push78=, -1
	i32.add 	$push40=, $pop39, $pop78
	i32.store	$drop=, h($0), $pop40
	i32.load	$push41=, 0($11)
	i32.store	$1=, j($0), $pop41
	i32.store	$drop=, f($0), $4
	i32.mul 	$push42=, $12, $1
	i32.const	$push77=, -1
	i32.add 	$push43=, $pop42, $pop77
	i32.store	$drop=, h($0), $pop43
	i32.load	$push44=, 0($11)
	i32.store	$1=, j($0), $pop44
	i32.store	$drop=, f($0), $5
	i32.mul 	$push45=, $12, $1
	i32.const	$push76=, -1
	i32.add 	$push46=, $pop45, $pop76
	i32.store	$drop=, h($0), $pop46
	i32.load	$push47=, 0($11)
	i32.store	$1=, j($0), $pop47
	i32.store	$drop=, f($0), $6
	i32.mul 	$push48=, $12, $1
	i32.const	$push75=, -1
	i32.add 	$push49=, $pop48, $pop75
	i32.store	$drop=, h($0), $pop49
	i32.load	$push50=, 0($11)
	i32.store	$1=, j($0), $pop50
	i32.store	$drop=, f($0), $7
	i32.mul 	$push51=, $12, $1
	i32.const	$push74=, -1
	i32.add 	$push52=, $pop51, $pop74
	i32.store	$drop=, h($0), $pop52
	i32.load	$push53=, 0($11)
	i32.store	$1=, j($0), $pop53
	i32.store	$drop=, f($0), $8
	i32.mul 	$push54=, $12, $1
	i32.const	$push73=, -1
	i32.add 	$push55=, $pop54, $pop73
	i32.store	$drop=, h($0), $pop55
	i32.load	$push56=, 0($11)
	i32.store	$11=, j($0), $pop56
	i32.store	$drop=, f($0), $9
	i32.mul 	$push57=, $12, $11
	i32.const	$push72=, -1
	i32.add 	$push58=, $pop57, $pop72
	i32.store	$push0=, h($0), $pop58
	i32.eqz 	$push59=, $pop0
	i64.extend_u/i32	$push60=, $pop59
	i64.lt_s	$push61=, $pop60, $13
	i32.store	$11=, e($0), $pop61
	i32.const	$push69=, 12
	i32.add 	$push70=, $10, $pop69
	i32.store	$drop=, g($0), $pop70
	block
	i32.eqz 	$push95=, $11
	br_if   	0, $pop95       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push68=, 0
	i32.const	$push66=, 16
	i32.add 	$push67=, $10, $pop66
	i32.store	$drop=, __stack_pointer($pop68), $pop67
	return  	$0
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
	.functype	abort, void
