	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57876.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64
# BB#0:                                 # %entry
	i32.const	$push66=, 0
	i32.const	$push63=, 0
	i32.load	$push64=, __stack_pointer($pop63)
	i32.const	$push65=, 16
	i32.sub 	$push72=, $pop64, $pop65
	i32.store	$9=, __stack_pointer($pop66), $pop72
	i32.const	$push2=, 0
	i32.load	$10=, d($pop2)
	i32.const	$push95=, 0
	i32.const	$push94=, 0
	i32.store	$push93=, f($pop95), $pop94
	tee_local	$push92=, $0=, $pop93
	i32.load	$push3=, 0($10)
	i32.store	$1=, j($pop92), $pop3
	i32.const	$push4=, 1
	i32.store	$2=, f($0), $pop4
	i32.load	$push91=, a($0)
	tee_local	$push90=, $11=, $pop91
	i32.mul 	$push5=, $1, $pop90
	i32.const	$push6=, -1
	i32.add 	$push7=, $pop5, $pop6
	i32.store	$drop=, h($0), $pop7
	i32.load	$push8=, 0($10)
	i32.store	$1=, j($0), $pop8
	i32.const	$push9=, 2
	i32.store	$3=, f($0), $pop9
	i32.mul 	$push10=, $11, $1
	i32.const	$push89=, -1
	i32.add 	$push11=, $pop10, $pop89
	i32.store	$drop=, h($0), $pop11
	i32.load	$push12=, 0($10)
	i32.store	$1=, j($0), $pop12
	i32.const	$push13=, 3
	i32.store	$4=, f($0), $pop13
	i32.mul 	$push14=, $11, $1
	i32.const	$push88=, -1
	i32.add 	$push15=, $pop14, $pop88
	i32.store	$drop=, h($0), $pop15
	i32.load	$push16=, 0($10)
	i32.store	$1=, j($0), $pop16
	i32.const	$push17=, 4
	i32.store	$5=, f($0), $pop17
	i32.mul 	$push18=, $11, $1
	i32.const	$push87=, -1
	i32.add 	$push19=, $pop18, $pop87
	i32.store	$drop=, h($0), $pop19
	i32.load	$push20=, 0($10)
	i32.store	$1=, j($0), $pop20
	i32.const	$push21=, 5
	i32.store	$6=, f($0), $pop21
	i32.mul 	$push22=, $11, $1
	i32.const	$push86=, -1
	i32.add 	$push23=, $pop22, $pop86
	i32.store	$drop=, h($0), $pop23
	i32.load	$push24=, 0($10)
	i32.store	$1=, j($0), $pop24
	i32.const	$push25=, 6
	i32.store	$7=, f($0), $pop25
	i32.mul 	$push26=, $11, $1
	i32.const	$push85=, -1
	i32.add 	$push27=, $pop26, $pop85
	i32.store	$drop=, h($0), $pop27
	i32.load	$push28=, 0($10)
	i32.store	$1=, j($0), $pop28
	i32.const	$push29=, 7
	i32.store	$8=, f($0), $pop29
	i32.mul 	$push30=, $11, $1
	i32.const	$push84=, -1
	i32.add 	$push31=, $pop30, $pop84
	i32.store	$drop=, h($0), $pop31
	i32.load	$push32=, 0($10)
	i32.store	$push0=, j($0), $pop32
	i32.mul 	$push33=, $11, $pop0
	i32.const	$push83=, -1
	i32.add 	$push34=, $pop33, $pop83
	i32.store	$drop=, h($0), $pop34
	i64.load32_s	$12=, b($0)
	i32.store	$push82=, f($0), $0
	tee_local	$push81=, $0=, $pop82
	i32.load	$push35=, 0($10)
	i32.store	$1=, j($pop81), $pop35
	i32.store	$drop=, f($0), $2
	i32.mul 	$push36=, $11, $1
	i32.const	$push80=, -1
	i32.add 	$push37=, $pop36, $pop80
	i32.store	$drop=, h($0), $pop37
	i32.load	$push38=, 0($10)
	i32.store	$1=, j($0), $pop38
	i32.store	$drop=, f($0), $3
	i32.mul 	$push39=, $11, $1
	i32.const	$push79=, -1
	i32.add 	$push40=, $pop39, $pop79
	i32.store	$drop=, h($0), $pop40
	i32.load	$push41=, 0($10)
	i32.store	$1=, j($0), $pop41
	i32.store	$drop=, f($0), $4
	i32.mul 	$push42=, $11, $1
	i32.const	$push78=, -1
	i32.add 	$push43=, $pop42, $pop78
	i32.store	$drop=, h($0), $pop43
	i32.load	$push44=, 0($10)
	i32.store	$1=, j($0), $pop44
	i32.store	$drop=, f($0), $5
	i32.mul 	$push45=, $11, $1
	i32.const	$push77=, -1
	i32.add 	$push46=, $pop45, $pop77
	i32.store	$drop=, h($0), $pop46
	i32.load	$push47=, 0($10)
	i32.store	$1=, j($0), $pop47
	i32.store	$drop=, f($0), $6
	i32.mul 	$push48=, $11, $1
	i32.const	$push76=, -1
	i32.add 	$push49=, $pop48, $pop76
	i32.store	$drop=, h($0), $pop49
	i32.load	$push50=, 0($10)
	i32.store	$1=, j($0), $pop50
	i32.store	$drop=, f($0), $7
	i32.mul 	$push51=, $11, $1
	i32.const	$push75=, -1
	i32.add 	$push52=, $pop51, $pop75
	i32.store	$drop=, h($0), $pop52
	i32.load	$push53=, 0($10)
	i32.store	$1=, j($0), $pop53
	i32.store	$drop=, f($0), $8
	i32.mul 	$push54=, $11, $1
	i32.const	$push74=, -1
	i32.add 	$push55=, $pop54, $pop74
	i32.store	$drop=, h($0), $pop55
	i32.load	$push56=, 0($10)
	i32.store	$10=, j($0), $pop56
	i32.const	$push57=, 8
	i32.store	$drop=, f($0), $pop57
	i32.mul 	$push58=, $11, $10
	i32.const	$push73=, -1
	i32.add 	$push59=, $pop58, $pop73
	i32.store	$push1=, h($0), $pop59
	i32.eqz 	$push60=, $pop1
	i64.extend_u/i32	$push61=, $pop60
	i64.lt_s	$push62=, $pop61, $12
	i32.store	$10=, e($0), $pop62
	i32.const	$push70=, 12
	i32.add 	$push71=, $9, $pop70
	i32.store	$drop=, g($0), $pop71
	block
	i32.eqz 	$push96=, $10
	br_if   	0, $pop96       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push69=, 0
	i32.const	$push67=, 16
	i32.add 	$push68=, $9, $pop67
	i32.store	$drop=, __stack_pointer($pop69), $pop68
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
	.section	.bss.e,"aw",@nobits
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
