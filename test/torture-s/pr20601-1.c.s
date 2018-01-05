	.text
	.file	"pr20601-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# %bb.0:                                # %entry
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	br      	0               # 0: up to label0
.LBB0_2:
	end_loop
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# %bb.0:                                # %land.rhs.lr.ph.i
	i32.const	$push35=, 0
	i32.const	$push34=, 4
	i32.store	b($pop35), $pop34
	i32.const	$push33=, 0
	i32.const	$push0=, g
	i32.store	c($pop33), $pop0
	i32.const	$0=, g+4
	i32.const	$push32=, 0
	i32.const	$push31=, g+4
	i32.store	e($pop32), $pop31
	i32.const	$1=, 3
	i32.const	$push30=, 0
	i32.const	$push29=, 3
	i32.store	d($pop30), $pop29
	i32.const	$3=, 1
.LBB2_1:                                # %land.rhs.i
                                        # =>This Inner Loop Header: Depth=1
	block   	
	block   	
	block   	
	block   	
	block   	
	loop    	                # label6:
	i32.load	$2=, 0($0)
	i32.load8_u	$push1=, 0($2)
	i32.const	$push36=, 45
	i32.ne  	$push2=, $pop1, $pop36
	br_if   	1, $pop2        # 1: down to label5
# %bb.2:                                # %while.body.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_s	$4=, 1($2)
	block   	
	i32.eqz 	$push63=, $4
	br_if   	0, $pop63       # 0: down to label7
# %bb.3:                                # %land.lhs.true.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push5=, 2($2)
	br_if   	5, $pop5        # 5: down to label2
.LBB2_4:                                # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label7:
	block   	
	block   	
	block   	
	block   	
	i32.const	$push37=, 80
	i32.eq  	$push6=, $4, $pop37
	br_if   	0, $pop6        # 0: down to label11
# %bb.5:                                # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push38=, 117
	i32.eq  	$push7=, $4, $pop38
	br_if   	2, $pop7        # 2: down to label9
# %bb.6:                                # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push39=, 45
	i32.ne  	$push8=, $4, $pop39
	br_if   	1, $pop8        # 1: down to label10
	br      	6               # 6: down to label4
.LBB2_7:                                # %sw.bb21.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label11:
	i32.const	$push40=, 4096
	i32.or  	$3=, $3, $pop40
.LBB2_8:                                # %sw.epilog.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label10:
	copy_local	$4=, $1
	br      	1               # 1: down to label8
.LBB2_9:                                # %sw.bb.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label9:
	i32.load	$push16=, 4($0)
	i32.eqz 	$push64=, $pop16
	br_if   	5, $pop64       # 5: down to label2
# %bb.10:                               # %if.end19.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push45=, 4
	i32.add 	$0=, $0, $pop45
	i32.const	$push44=, 0
	i32.store	t+4100($pop44), $0
	i32.const	$push43=, 0
	i32.store	e($pop43), $0
	i32.const	$push42=, -1
	i32.add 	$4=, $1, $pop42
	i32.const	$push41=, 0
	i32.store	d($pop41), $4
.LBB2_11:                               # %sw.epilog.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label8:
	i32.const	$push50=, 4
	i32.add 	$0=, $0, $pop50
	i32.const	$push49=, 0
	i32.store	e($pop49), $0
	i32.const	$push48=, -1
	i32.add 	$1=, $4, $pop48
	i32.const	$push47=, 0
	i32.store	d($pop47), $1
	i32.const	$push46=, 1
	i32.gt_s	$push17=, $4, $pop46
	br_if   	0, $pop17       # 0: up to label6
	br      	3               # 3: down to label3
.LBB2_12:                               # %while.end.i
	end_loop
	end_block                       # label5:
	i32.const	$push3=, 1
	i32.and 	$push4=, $3, $pop3
	br_if   	1, $pop4        # 1: down to label3
	br      	2               # 2: down to label2
.LBB2_13:                               # %sw.bb22.i
	end_block                       # label4:
	i32.const	$push9=, 4
	i32.add 	$0=, $0, $pop9
	i32.const	$push10=, 0
	i32.store	e($pop10), $0
	i32.const	$push11=, -1
	i32.add 	$1=, $1, $pop11
	i32.const	$push51=, 0
	i32.store	d($pop51), $1
	i32.const	$push14=, 1536
	i32.or  	$push15=, $3, $pop14
	i32.const	$push12=, 1
	i32.eq  	$push13=, $3, $pop12
	i32.select	$3=, $pop15, $3, $pop13
.LBB2_14:                               # %setup2.exit
	end_block                       # label3:
	i32.const	$push53=, 0
	i32.const	$push52=, .L.str.4
	i32.store	t($pop53), $pop52
	block   	
	i32.const	$push18=, 512
	i32.and 	$push19=, $3, $pop18
	i32.eqz 	$push65=, $pop19
	br_if   	0, $pop65       # 0: down to label12
# %bb.15:                               # %if.then6.i
	i32.const	$push58=, 0
	i32.const	$push57=, f
	i32.store	e($pop58), $pop57
	i32.const	$push56=, 0
	i32.const	$push55=, .L.str.4
	i32.store	f($pop56), $pop55
	i32.const	$push54=, 0
	i32.const	$push20=, 1
	i32.add 	$push21=, $1, $pop20
	i32.store	d($pop54), $pop21
	i32.const	$4=, 4
.LBB2_16:                               # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label13:
	i32.add 	$push23=, $0, $4
	i32.const	$push61=, -4
	i32.add 	$push24=, $pop23, $pop61
	i32.load	$2=, 0($pop24)
	i32.const	$push60=, f
	i32.add 	$push22=, $4, $pop60
	i32.store	0($pop22), $2
	i32.const	$push59=, 4
	i32.add 	$4=, $4, $pop59
	br_if   	0, $2           # 0: up to label13
.LBB2_17:                               # %setup1.exit
	end_loop
	end_block                       # label12:
	i32.const	$push26=, 1024
	i32.and 	$push27=, $3, $pop26
	i32.eqz 	$push66=, $pop27
	br_if   	1, $pop66       # 1: down to label1
# %bb.18:                               # %setup1.exit
	i32.const	$push62=, 0
	i32.load	$push25=, a+16($pop62)
	br_if   	1, $pop25       # 1: down to label1
.LBB2_19:                               # %if.then.i
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB2_20:                               # %if.end
	end_block                       # label1:
	i32.const	$push28=, 0
	call    	exit@FUNCTION, $pop28
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"a"
	.size	.L.str, 2

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"-u"
	.size	.L.str.1, 3

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"b"
	.size	.L.str.2, 2

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.asciz	"c"
	.size	.L.str.3, 2

	.hidden	g                       # @g
	.type	g,@object
	.section	.data.g,"aw",@progbits
	.globl	g
	.p2align	4
g:
	.int32	.L.str
	.int32	.L.str.1
	.int32	.L.str.2
	.int32	.L.str.3
	.size	g, 16

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0
	.size	c, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.type	.L.str.4,@object        # @.str.4
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.4:
	.asciz	"/bin/sh"
	.size	.L.str.4, 8

	.hidden	t                       # @t
	.type	t,@object
	.section	.bss.t,"aw",@nobits
	.globl	t
	.p2align	2
t:
	.skip	4104
	.size	t, 4104

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	4
a:
	.skip	20
	.size	a, 20

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0
	.size	e, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	4
f:
	.skip	64
	.size	f, 64


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
