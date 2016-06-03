	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57875.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push15=, 0
	i32.load	$push14=, i($pop15)
	tee_local	$push13=, $4=, $pop14
	i32.const	$push12=, 0
	i32.gt_s	$push1=, $pop13, $pop12
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.body.lr.ph
	i32.const	$push17=, 0
	i32.load	$1=, c($pop17)
	i32.const	$push16=, 0
	i32.load	$0=, d($pop16)
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	block
	br_if   	0, $0           # 0: down to label3
# BB#3:                                 # %if.then
                                        #   in Loop: Header=BB0_2 Depth=1
	block
	block
	i32.eqz 	$push29=, $1
	br_if   	0, $pop29       # 0: down to label5
# BB#4:                                 # %if.then.if.end_crit_edge
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push18=, 0
	i32.load	$3=, f($pop18)
	br      	1               # 1: down to label4
.LBB0_5:                                # %if.then2
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	i32.const	$3=, 2
	i32.const	$push20=, 0
	i32.const	$push19=, 2
	i32.store	$drop=, f($pop20), $pop19
.LBB0_6:                                # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.const	$push22=, 0
	i32.const	$push21=, 0
	i32.load8_u	$push2=, e($pop21)
	i32.and 	$push3=, $pop2, $3
	i32.store8	$drop=, e($pop22), $pop3
.LBB0_7:                                # %for.inc
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.const	$push26=, 0
	i32.lt_s	$3=, $4, $pop26
	i32.const	$push25=, 1
	i32.add 	$push24=, $4, $pop25
	tee_local	$push23=, $2=, $pop24
	copy_local	$4=, $pop23
	br_if   	0, $3           # 0: up to label1
# BB#8:                                 # %for.cond.for.end_crit_edge
	end_loop                        # label2:
	i32.const	$push4=, 0
	i32.store	$drop=, i($pop4), $2
.LBB0_9:                                # %for.end
	end_block                       # label0:
	block
	i32.const	$push28=, 0
	i32.const	$push27=, 0
	i32.load8_u	$push5=, e($pop27)
	i32.const	$push6=, 1
	i32.shl 	$push7=, $pop5, $pop6
	i32.const	$push8=, 4
	i32.and 	$push9=, $pop7, $pop8
	i32.load	$push10=, a($pop9)
	i32.store	$push0=, b($pop28), $pop10
	br_if   	0, $pop0        # 0: down to label6
# BB#10:                                # %if.end10
	i32.const	$push11=, 0
	return  	$pop11
.LBB0_11:                               # %if.then9
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
