	.text
	.file	"20140212-1.c"
	.section	.text.fn1,"ax",@progbits
	.hidden	fn1                     # -- Begin function fn1
	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.local  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.store	c($pop17), $pop16
	i32.const	$push15=, 0
	i32.const	$push14=, 0
	i32.store	e($pop15), $pop14
	i32.const	$push13=, 0
	i32.load	$push2=, a($pop13)
	i32.const	$push12=, 0
	i32.ne  	$push3=, $pop2, $pop12
	i32.const	$push11=, 0
	i32.load	$push0=, b($pop11)
	i32.const	$push10=, 0
	i32.ne  	$push1=, $pop0, $pop10
	i32.and 	$0=, $pop3, $pop1
	i32.const	$push4=, 54
	i32.const	$push9=, 0
	i32.select	$1=, $pop4, $pop9, $0
	i32.const	$push5=, 147
	i32.mul 	$2=, $1, $pop5
	i32.const	$push8=, 0
	i32.load	$4=, f($pop8)
	i32.const	$push7=, 0
	i32.load	$3=, d($pop7)
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	block   	
	i32.eqz 	$push26=, $3
	br_if   	0, $pop26       # 0: down to label2
# %bb.2:                                # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push19=, 0
	i32.const	$push18=, 1
	i32.store	c($pop19), $pop18
	i32.eqz 	$push27=, $4
	br_if   	1, $pop27       # 1: up to label1
	br      	2               # 2: down to label0
.LBB0_3:                                # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push23=, 0
	i32.const	$push22=, 9
	i32.store	h($pop23), $pop22
	i32.const	$push21=, 0
	i32.const	$push20=, 9
	i32.store	i($pop21), $pop20
	i32.eqz 	$push28=, $4
	br_if   	0, $pop28       # 0: up to label1
.LBB0_4:                                # %if.then15
	end_loop
	end_block                       # label0:
	i32.const	$push6=, 0
	i32.store8	j($pop6), $1
	i32.const	$push25=, 0
	i32.store	k($pop25), $0
	i32.const	$push24=, 0
	i32.store8	g($pop24), $2
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	fn1, .Lfunc_end0-fn1
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push19=, 0
	i32.const	$push18=, 0
	i32.store	c($pop19), $pop18
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.store	e($pop17), $pop16
	i32.const	$push15=, 0
	i32.load	$push2=, a($pop15)
	i32.const	$push14=, 0
	i32.ne  	$push3=, $pop2, $pop14
	i32.const	$push13=, 0
	i32.load	$push0=, b($pop13)
	i32.const	$push12=, 0
	i32.ne  	$push1=, $pop0, $pop12
	i32.and 	$0=, $pop3, $pop1
	i32.const	$push4=, 54
	i32.const	$push11=, 0
	i32.select	$1=, $pop4, $pop11, $0
	i32.const	$push10=, 0
	i32.load	$3=, f($pop10)
	i32.const	$push9=, 0
	i32.load	$2=, d($pop9)
	i32.const	$4=, 0
.LBB1_1:                                # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label4:
	block   	
	i32.eqz 	$push30=, $2
	br_if   	0, $pop30       # 0: down to label5
# %bb.2:                                # %if.then.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$4=, 1
	i32.const	$push21=, 0
	i32.const	$push20=, 1
	i32.store	c($pop21), $pop20
	i32.eqz 	$push31=, $3
	br_if   	1, $pop31       # 1: up to label4
	br      	2               # 2: down to label3
.LBB1_3:                                # %if.else.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label5:
	i32.const	$push25=, 0
	i32.const	$push24=, 9
	i32.store	h($pop25), $pop24
	i32.const	$push23=, 0
	i32.const	$push22=, 9
	i32.store	i($pop23), $pop22
	i32.eqz 	$push32=, $3
	br_if   	0, $pop32       # 0: up to label4
.LBB1_4:                                # %fn1.exit
	end_loop
	end_block                       # label3:
	i32.const	$push28=, 0
	i32.store8	j($pop28), $1
	i32.const	$push27=, 0
	i32.store	k($pop27), $0
	i32.const	$push26=, 0
	i32.const	$push5=, 147
	i32.mul 	$push6=, $1, $pop5
	i32.store8	g($pop26), $pop6
	block   	
	i32.const	$push7=, 1
	i32.ne  	$push8=, $4, $pop7
	br_if   	0, $pop8        # 0: down to label6
# %bb.5:                                # %if.end
	i32.const	$push29=, 0
	return  	$pop29
.LBB1_6:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	d                       # @d
	.type	d,@object
	.section	.data.d,"aw",@progbits
	.globl	d
	.p2align	2
d:
	.int32	1                       # 0x1
	.size	d, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.data.f,"aw",@progbits
	.globl	f
	.p2align	2
f:
	.int32	1                       # 0x1
	.size	f, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	2
k:
	.int32	0                       # 0x0
	.size	k, 4

	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
j:
	.int8	0                       # 0x0
	.size	j, 1

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
g:
	.int8	0                       # 0x0
	.size	g, 1

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	h                       # @h
	.type	h,@object
	.section	.bss.h,"aw",@nobits
	.globl	h
	.p2align	2
h:
	.int32	0                       # 0x0
	.size	h, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
