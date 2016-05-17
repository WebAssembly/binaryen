	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr20601-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	br      	0               # 0: up to label0
.LBB0_2:
	end_loop                        # label1:
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push36=, 0
	i32.const	$push0=, g
	i32.store	$discard=, c($pop36), $pop0
	i32.const	$push35=, 0
	i32.const	$push1=, 4
	i32.store	$0=, b($pop35), $pop1
	i32.const	$2=, g+4
	i32.const	$push34=, 0
	i32.const	$push33=, g+4
	i32.store	$discard=, e($pop34), $pop33
	i32.const	$4=, 3
	i32.const	$push32=, 0
	i32.const	$push31=, 3
	i32.store	$discard=, d($pop32), $pop31
	i32.const	$3=, 1
.LBB2_1:                                # %land.rhs.i
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	block
	block
	block
	loop                            # label7:
	i32.load	$push39=, 0($2)
	tee_local	$push38=, $5=, $pop39
	i32.load8_u	$push2=, 0($pop38)
	i32.const	$push37=, 45
	i32.ne  	$push3=, $pop2, $pop37
	br_if   	1, $pop3        # 1: down to label8
# BB#2:                                 # %while.body.i
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.load8_s	$push41=, 1($5)
	tee_local	$push40=, $1=, $pop41
	i32.eqz 	$push68=, $pop40
	br_if   	0, $pop68       # 0: down to label9
# BB#3:                                 # %land.lhs.true.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push4=, 2($5)
	br_if   	6, $pop4        # 6: down to label3
.LBB2_4:                                # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label9:
	block
	block
	block
	i32.const	$push42=, 80
	i32.eq  	$push5=, $1, $pop42
	br_if   	0, $pop5        # 0: down to label12
# BB#5:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push43=, 117
	i32.eq  	$push6=, $1, $pop43
	br_if   	1, $pop6        # 1: down to label11
# BB#6:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push44=, 45
	i32.ne  	$push7=, $1, $pop44
	br_if   	2, $pop7        # 2: down to label10
	br      	6               # 6: down to label5
.LBB2_7:                                # %sw.bb21.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label12:
	i32.const	$push45=, 4096
	i32.or  	$3=, $3, $pop45
	br      	1               # 1: down to label10
.LBB2_8:                                # %sw.bb.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label11:
	i32.load	$push15=, 4($2)
	i32.eqz 	$push69=, $pop15
	br_if   	6, $pop69       # 6: down to label3
# BB#9:                                 # %if.end19.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.add 	$2=, $2, $0
	i32.const	$push49=, 0
	i32.store	$1=, t+4100($pop49), $2
	i32.const	$push48=, -1
	i32.add 	$4=, $4, $pop48
	i32.const	$push47=, 0
	i32.store	$discard=, d($pop47), $4
	i32.const	$push46=, 0
	i32.store	$discard=, e($pop46), $1
.LBB2_10:                               # %sw.epilog.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label10:
	i32.const	$push55=, 0
	i32.const	$push54=, -1
	i32.add 	$push53=, $4, $pop54
	tee_local	$push52=, $6=, $pop53
	i32.store	$1=, d($pop55), $pop52
	i32.add 	$2=, $2, $0
	i32.const	$push51=, 0
	i32.store	$discard=, e($pop51), $2
	i32.const	$push50=, 1
	i32.gt_s	$5=, $4, $pop50
	copy_local	$4=, $1
	br_if   	0, $5           # 0: up to label7
	br      	2               # 2: down to label6
.LBB2_11:
	end_loop                        # label8:
	copy_local	$6=, $4
.LBB2_12:                               # %while.end.i
	end_block                       # label6:
	i32.const	$push56=, 1
	i32.lt_s	$push17=, $6, $pop56
	br_if   	1, $pop17       # 1: down to label4
# BB#13:                                # %while.end.i
	i32.const	$push57=, 1
	i32.and 	$push16=, $3, $pop57
	br_if   	1, $pop16       # 1: down to label4
	br      	2               # 2: down to label3
.LBB2_14:                               # %sw.bb22.i
	end_block                       # label5:
	i32.const	$push13=, 1536
	i32.or  	$push14=, $3, $pop13
	i32.const	$push11=, 1
	i32.eq  	$push12=, $3, $pop11
	i32.select	$3=, $pop14, $3, $pop12
	i32.const	$push10=, 4
	i32.add 	$2=, $2, $pop10
	i32.const	$push9=, 0
	i32.const	$push8=, -1
	i32.add 	$push60=, $4, $pop8
	tee_local	$push59=, $6=, $pop60
	i32.store	$discard=, d($pop9), $pop59
	i32.const	$push58=, 0
	i32.store	$discard=, e($pop58), $2
.LBB2_15:                               # %setup2.exit
	end_block                       # label4:
	i32.const	$push61=, 0
	i32.const	$push18=, .L.str.4
	i32.store	$4=, t($pop61), $pop18
	block
	i32.const	$push19=, 512
	i32.and 	$push20=, $3, $pop19
	i32.eqz 	$push70=, $pop20
	br_if   	0, $pop70       # 0: down to label13
# BB#16:                                # %if.then6.i
	i32.const	$push64=, 0
	i32.const	$push21=, 1
	i32.add 	$push22=, $6, $pop21
	i32.store	$discard=, d($pop64), $pop22
	i32.const	$push63=, 0
	i32.const	$push23=, f
	i32.store	$discard=, e($pop63), $pop23
	i32.const	$push62=, 0
	i32.store	$discard=, f($pop62), $4
	i32.const	$4=, 4
.LBB2_17:                               # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label14:
	i32.add 	$push24=, $2, $4
	i32.const	$push66=, -4
	i32.add 	$push25=, $pop24, $pop66
	i32.load	$push26=, 0($pop25)
	i32.store	$1=, f($4), $pop26
	i32.const	$push65=, 4
	i32.add 	$4=, $4, $pop65
	br_if   	0, $1           # 0: up to label14
.LBB2_18:                               # %setup1.exit
	end_loop                        # label15:
	end_block                       # label13:
	i32.const	$push28=, 1024
	i32.and 	$push29=, $3, $pop28
	i32.eqz 	$push71=, $pop29
	br_if   	1, $pop71       # 1: down to label2
# BB#19:                                # %setup1.exit
	i32.const	$push67=, 0
	i32.load	$push27=, a+16($pop67)
	br_if   	1, $pop27       # 1: down to label2
.LBB2_20:                               # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB2_21:                               # %if.end
	end_block                       # label2:
	i32.const	$push30=, 0
	call    	exit@FUNCTION, $pop30
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

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


	.ident	"clang version 3.9.0 "
