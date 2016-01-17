	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57875.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.load	$5=, i($3)
	block
	i32.gt_s	$push0=, $5, $3
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %for.body.lr.ph
	i32.load	$0=, d($3)
	i32.load	$1=, c($3)
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	block
	br_if   	$0, 0           # 0: down to label3
# BB#3:                                 # %if.then
                                        #   in Loop: Header=BB0_2 Depth=1
	block
	block
	i32.const	$push14=, 0
	i32.eq  	$push15=, $1, $pop14
	br_if   	$pop15, 0       # 0: down to label5
# BB#4:                                 # %if.then.if.end_crit_edge
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$2=, f($3)
	br      	1               # 1: down to label4
.LBB0_5:                                # %if.then2
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	i32.const	$push1=, 2
	i32.store	$2=, f($3), $pop1
.LBB0_6:                                # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.load8_u	$push2=, e($3)
	i32.and 	$push3=, $pop2, $2
	i32.store8	$discard=, e($3), $pop3
.LBB0_7:                                # %for.inc
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.const	$push4=, 1
	i32.add 	$2=, $5, $pop4
	i32.lt_s	$4=, $5, $3
	copy_local	$5=, $2
	br_if   	$4, 0           # 0: up to label1
# BB#8:                                 # %for.cond.for.end_crit_edge
	end_loop                        # label2:
	i32.store	$discard=, i($3), $2
.LBB0_9:                                # %for.end
	end_block                       # label0:
	block
	i32.const	$push10=, a
	i32.load8_u	$push5=, e($3)
	i32.const	$push6=, 1
	i32.shl 	$push7=, $pop5, $pop6
	i32.const	$push8=, 4
	i32.and 	$push9=, $pop7, $pop8
	i32.add 	$push11=, $pop10, $pop9
	i32.load	$push12=, 0($pop11)
	i32.store	$push13=, b($3), $pop12
	br_if   	$pop13, 0       # 0: down to label6
# BB#10:                                # %if.end10
	return  	$3
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
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.align	2
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
	.align	2
a:
	.skip	4
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 3.9.0 "
