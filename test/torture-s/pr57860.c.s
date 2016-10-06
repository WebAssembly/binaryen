	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57860.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.load	$4=, f($pop12)
	i32.const	$push11=, 0
	i32.load	$3=, h($pop11)
	i32.const	$push10=, 0
	i32.load	$2=, b($pop10)
	i64.extend_s/i32	$1=, $0
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	i32.const	$push15=, 0
	i32.load	$push0=, c($pop15)
	i32.eqz 	$push27=, $pop0
	br_if   	0, $pop27       # 0: down to label2
# BB#2:                                 # %for.inc.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.store	c($pop17), $pop16
.LBB0_3:                                # %for.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i64.load32_s	$push3=, 0($2)
	i32.const	$push26=, 0
	i64.load32_s	$push1=, a($pop26)
	i64.const	$push25=, 8589934591
	i64.xor 	$push2=, $pop1, $pop25
	i64.and 	$push4=, $pop3, $pop2
	i64.gt_s	$push24=, $1, $pop4
	tee_local	$push23=, $0=, $pop24
	i32.store	0($3), $pop23
	i32.store	0($4), $0
	i32.const	$push22=, 0
	i32.load	$push21=, g($pop22)
	tee_local	$push20=, $0=, $pop21
	i32.const	$push19=, 2
	i32.shl 	$push5=, $pop20, $pop19
	i32.const	$push18=, k
	i32.add 	$push6=, $pop5, $pop18
	i32.load	$push7=, 0($pop6)
	br_if   	1, $pop7        # 1: down to label1
# BB#4:                                 # %for.inc6
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push14=, 0
	i32.const	$push13=, 1
	i32.add 	$push9=, $0, $pop13
	i32.store	g($pop14), $pop9
	br      	0               # 0: up to label0
.LBB0_5:                                # %if.then
	end_loop                        # label1:
	i32.const	$push8=, 0
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push14=, 0
	i32.load	$2=, f($pop14)
	i32.const	$push13=, 0
	i32.load	$1=, h($pop13)
	i32.const	$push12=, 0
	i32.load	$0=, b($pop12)
.LBB1_1:                                # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	block
	i32.const	$push17=, 0
	i32.load	$push0=, c($pop17)
	i32.eqz 	$push32=, $pop0
	br_if   	0, $pop32       # 0: down to label5
# BB#2:                                 # %for.inc.preheader.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push19=, 0
	i32.const	$push18=, 0
	i32.store	c($pop19), $pop18
.LBB1_3:                                # %for.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label5:
	i64.load32_s	$push3=, 0($0)
	i32.const	$push29=, 0
	i64.load32_s	$push1=, a($pop29)
	i64.const	$push28=, 8589934591
	i64.xor 	$push2=, $pop1, $pop28
	i64.and 	$push4=, $pop3, $pop2
	i64.const	$push27=, 1
	i64.lt_s	$push26=, $pop4, $pop27
	tee_local	$push25=, $3=, $pop26
	i32.store	0($1), $pop25
	i32.store	0($2), $3
	i32.const	$push24=, 0
	i32.load	$push23=, g($pop24)
	tee_local	$push22=, $3=, $pop23
	i32.const	$push21=, 2
	i32.shl 	$push5=, $pop22, $pop21
	i32.const	$push20=, k
	i32.add 	$push6=, $pop5, $pop20
	i32.load	$push7=, 0($pop6)
	br_if   	1, $pop7        # 1: down to label4
# BB#4:                                 # %for.inc6.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push16=, 0
	i32.const	$push15=, 1
	i32.add 	$push11=, $3, $pop15
	i32.store	g($pop16), $pop11
	br      	0               # 0: up to label3
.LBB1_5:                                # %foo.exit
	end_loop                        # label4:
	block
	i32.const	$push30=, 0
	i32.load	$push8=, d($pop30)
	i32.const	$push9=, 1
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label6
# BB#6:                                 # %if.end
	i32.const	$push31=, 0
	return  	$pop31
.LBB1_7:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

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
	.section	.data.b,"aw",@progbits
	.globl	b
	.p2align	2
b:
	.int32	a
	.size	b, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.data.f,"aw",@progbits
	.globl	f
	.p2align	2
f:
	.int32	e
	.size	f, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	h                       # @h
	.type	h,@object
	.section	.data.h,"aw",@progbits
	.globl	h
	.p2align	2
h:
	.int32	d
	.size	h, 4

	.hidden	k                       # @k
	.type	k,@object
	.section	.data.k,"aw",@progbits
	.globl	k
	.p2align	2
k:
	.int32	1                       # 0x1
	.size	k, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.p2align	2
g:
	.int32	0                       # 0x0
	.size	g, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283501)"
	.functype	abort, void
