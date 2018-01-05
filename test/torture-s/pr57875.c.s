	.text
	.file	"pr57875.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push13=, 0
	i32.load	$4=, i($pop13)
	block   	
	i32.const	$push12=, 0
	i32.gt_s	$push0=, $4, $pop12
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %for.body.lr.ph
	i32.const	$push15=, 0
	i32.load	$1=, c($pop15)
	i32.const	$push14=, 0
	i32.load	$0=, d($pop14)
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	block   	
	br_if   	0, $0           # 0: down to label2
# %bb.3:                                # %if.then
                                        #   in Loop: Header=BB0_2 Depth=1
	block   	
	block   	
	i32.eqz 	$push25=, $1
	br_if   	0, $pop25       # 0: down to label4
# %bb.4:                                # %if.then.if.end_crit_edge
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push16=, 0
	i32.load	$2=, f($pop16)
	br      	1               # 1: down to label3
.LBB0_5:                                # %if.then2
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.const	$2=, 2
	i32.const	$push18=, 0
	i32.const	$push17=, 2
	i32.store	f($pop18), $pop17
.LBB0_6:                                # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.const	$push20=, 0
	i32.const	$push19=, 0
	i32.load8_u	$push1=, e($pop19)
	i32.and 	$push2=, $2, $pop1
	i32.store8	e($pop20), $pop2
.LBB0_7:                                # %for.inc
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label2:
	i32.const	$push22=, 1
	i32.add 	$2=, $4, $pop22
	i32.const	$push21=, 0
	i32.lt_s	$3=, $4, $pop21
	copy_local	$4=, $2
	br_if   	0, $3           # 0: up to label1
# %bb.8:                                # %for.cond.for.end_crit_edge
	end_loop
	i32.const	$push3=, 0
	i32.store	i($pop3), $2
.LBB0_9:                                # %for.end
	end_block                       # label0:
	i32.const	$push24=, 0
	i32.load8_u	$push4=, e($pop24)
	i32.const	$push5=, 1
	i32.shl 	$push6=, $pop4, $pop5
	i32.const	$push7=, 4
	i32.and 	$push8=, $pop6, $pop7
	i32.const	$push9=, a
	i32.add 	$push10=, $pop8, $pop9
	i32.load	$4=, 0($pop10)
	i32.const	$push23=, 0
	i32.store	b($pop23), $4
	block   	
	br_if   	0, $4           # 0: down to label5
# %bb.10:                               # %if.end10
	i32.const	$push11=, 0
	return  	$pop11
.LBB0_11:                               # %if.then9
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

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

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
e:
	.skip	1
	.size	e, 1

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.skip	4
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
