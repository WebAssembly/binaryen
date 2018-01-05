	.text
	.file	"pr57876.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i64, i32
# %bb.0:                                # %entry
	i32.const	$push44=, 0
	i32.load	$push43=, __stack_pointer($pop44)
	i32.const	$push45=, 16
	i32.sub 	$4=, $pop43, $pop45
	i32.const	$push46=, 0
	i32.store	__stack_pointer($pop46), $4
	i32.const	$push128=, 0
	i32.load	$0=, d($pop128)
	i32.const	$push127=, 0
	i32.const	$push126=, 0
	i32.store	f($pop127), $pop126
	i32.load	$1=, 0($0)
	i32.const	$push125=, 0
	i32.store	j($pop125), $1
	i32.const	$push124=, 0
	i32.const	$push0=, 1
	i32.store	f($pop124), $pop0
	i32.const	$push123=, 0
	i32.load	$2=, a($pop123)
	i32.const	$push122=, 0
	i32.mul 	$push1=, $2, $1
	i32.const	$push2=, -1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	h($pop122), $pop3
	i32.load	$1=, 0($0)
	i32.const	$push121=, 0
	i32.store	j($pop121), $1
	i32.const	$push120=, 0
	i32.const	$push4=, 2
	i32.store	f($pop120), $pop4
	i32.const	$push119=, 0
	i32.mul 	$push5=, $2, $1
	i32.const	$push118=, -1
	i32.add 	$push6=, $pop5, $pop118
	i32.store	h($pop119), $pop6
	i32.load	$1=, 0($0)
	i32.const	$push117=, 0
	i32.store	j($pop117), $1
	i32.const	$push116=, 0
	i32.const	$push7=, 3
	i32.store	f($pop116), $pop7
	i32.const	$push115=, 0
	i32.mul 	$push8=, $2, $1
	i32.const	$push114=, -1
	i32.add 	$push9=, $pop8, $pop114
	i32.store	h($pop115), $pop9
	i32.load	$1=, 0($0)
	i32.const	$push113=, 0
	i32.store	j($pop113), $1
	i32.const	$push112=, 0
	i32.const	$push10=, 4
	i32.store	f($pop112), $pop10
	i32.const	$push111=, 0
	i32.mul 	$push11=, $2, $1
	i32.const	$push110=, -1
	i32.add 	$push12=, $pop11, $pop110
	i32.store	h($pop111), $pop12
	i32.load	$1=, 0($0)
	i32.const	$push109=, 0
	i32.store	j($pop109), $1
	i32.const	$push108=, 0
	i32.const	$push13=, 5
	i32.store	f($pop108), $pop13
	i32.const	$push107=, 0
	i32.mul 	$push14=, $2, $1
	i32.const	$push106=, -1
	i32.add 	$push15=, $pop14, $pop106
	i32.store	h($pop107), $pop15
	i32.load	$1=, 0($0)
	i32.const	$push105=, 0
	i32.store	j($pop105), $1
	i32.const	$push104=, 0
	i32.const	$push16=, 6
	i32.store	f($pop104), $pop16
	i32.const	$push103=, 0
	i32.mul 	$push17=, $2, $1
	i32.const	$push102=, -1
	i32.add 	$push18=, $pop17, $pop102
	i32.store	h($pop103), $pop18
	i32.load	$1=, 0($0)
	i32.const	$push101=, 0
	i32.store	j($pop101), $1
	i32.const	$push100=, 0
	i32.const	$push19=, 7
	i32.store	f($pop100), $pop19
	i32.const	$push99=, 0
	i32.mul 	$push20=, $2, $1
	i32.const	$push98=, -1
	i32.add 	$push21=, $pop20, $pop98
	i32.store	h($pop99), $pop21
	i32.load	$1=, 0($0)
	i32.const	$push97=, 0
	i32.store	j($pop97), $1
	i32.const	$push96=, 0
	i32.mul 	$push22=, $2, $1
	i32.const	$push95=, -1
	i32.add 	$push23=, $pop22, $pop95
	i32.store	h($pop96), $pop23
	i32.const	$push94=, 0
	i64.load32_s	$3=, b($pop94)
	i32.const	$push93=, 0
	i32.const	$push92=, 0
	i32.store	f($pop93), $pop92
	i32.load	$1=, 0($0)
	i32.const	$push91=, 0
	i32.store	j($pop91), $1
	i32.const	$push90=, 0
	i32.const	$push89=, 1
	i32.store	f($pop90), $pop89
	i32.const	$push88=, 0
	i32.mul 	$push24=, $2, $1
	i32.const	$push87=, -1
	i32.add 	$push25=, $pop24, $pop87
	i32.store	h($pop88), $pop25
	i32.load	$1=, 0($0)
	i32.const	$push86=, 0
	i32.store	j($pop86), $1
	i32.const	$push85=, 0
	i32.const	$push84=, 2
	i32.store	f($pop85), $pop84
	i32.const	$push83=, 0
	i32.mul 	$push26=, $2, $1
	i32.const	$push82=, -1
	i32.add 	$push27=, $pop26, $pop82
	i32.store	h($pop83), $pop27
	i32.load	$1=, 0($0)
	i32.const	$push81=, 0
	i32.store	j($pop81), $1
	i32.const	$push80=, 0
	i32.const	$push79=, 3
	i32.store	f($pop80), $pop79
	i32.const	$push78=, 0
	i32.mul 	$push28=, $2, $1
	i32.const	$push77=, -1
	i32.add 	$push29=, $pop28, $pop77
	i32.store	h($pop78), $pop29
	i32.load	$1=, 0($0)
	i32.const	$push76=, 0
	i32.store	j($pop76), $1
	i32.const	$push75=, 0
	i32.const	$push74=, 4
	i32.store	f($pop75), $pop74
	i32.const	$push73=, 0
	i32.mul 	$push30=, $2, $1
	i32.const	$push72=, -1
	i32.add 	$push31=, $pop30, $pop72
	i32.store	h($pop73), $pop31
	i32.load	$1=, 0($0)
	i32.const	$push71=, 0
	i32.store	j($pop71), $1
	i32.const	$push70=, 0
	i32.const	$push69=, 5
	i32.store	f($pop70), $pop69
	i32.const	$push68=, 0
	i32.mul 	$push32=, $2, $1
	i32.const	$push67=, -1
	i32.add 	$push33=, $pop32, $pop67
	i32.store	h($pop68), $pop33
	i32.load	$1=, 0($0)
	i32.const	$push66=, 0
	i32.store	j($pop66), $1
	i32.const	$push65=, 0
	i32.const	$push64=, 6
	i32.store	f($pop65), $pop64
	i32.const	$push63=, 0
	i32.mul 	$push34=, $2, $1
	i32.const	$push62=, -1
	i32.add 	$push35=, $pop34, $pop62
	i32.store	h($pop63), $pop35
	i32.load	$1=, 0($0)
	i32.const	$push61=, 0
	i32.store	j($pop61), $1
	i32.const	$push60=, 0
	i32.const	$push59=, 7
	i32.store	f($pop60), $pop59
	i32.const	$push58=, 0
	i32.mul 	$push36=, $2, $1
	i32.const	$push57=, -1
	i32.add 	$push37=, $pop36, $pop57
	i32.store	h($pop58), $pop37
	i32.load	$0=, 0($0)
	i32.const	$push56=, 0
	i32.store	j($pop56), $0
	i32.const	$push55=, 0
	i32.const	$push38=, 8
	i32.store	f($pop55), $pop38
	i32.mul 	$push39=, $2, $0
	i32.const	$push54=, -1
	i32.add 	$0=, $pop39, $pop54
	i32.const	$push53=, 0
	i32.store	h($pop53), $0
	i32.const	$push52=, 0
	i32.const	$push50=, 12
	i32.add 	$push51=, $4, $pop50
	i32.store	g($pop52), $pop51
	block   	
	i32.eqz 	$push40=, $0
	i64.extend_u/i32	$push41=, $pop40
	i64.ge_s	$push42=, $pop41, $3
	br_if   	0, $pop42       # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push49=, 0
	i32.const	$push47=, 16
	i32.add 	$push48=, $4, $pop47
	i32.store	__stack_pointer($pop49), $pop48
	i32.const	$push129=, 0
	return  	$pop129
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
