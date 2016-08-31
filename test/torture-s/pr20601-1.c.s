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
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push34=, 0
	i32.const	$push33=, 4
	i32.store	$drop=, b($pop34), $pop33
	i32.const	$push32=, 0
	i32.const	$push0=, g
	i32.store	$drop=, c($pop32), $pop0
	i32.const	$1=, g+4
	i32.const	$push31=, 0
	i32.const	$push30=, g+4
	i32.store	$drop=, e($pop31), $pop30
	i32.const	$0=, 3
	i32.const	$push29=, 0
	i32.const	$push28=, 3
	i32.store	$drop=, d($pop29), $pop28
	i32.const	$3=, 1
.LBB2_1:                                # %land.rhs.i
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	block
	block
	loop                            # label6:
	i32.load	$push37=, 0($1)
	tee_local	$push36=, $2=, $pop37
	i32.load8_u	$push1=, 0($pop36)
	i32.const	$push35=, 45
	i32.ne  	$push2=, $pop1, $pop35
	br_if   	1, $pop2        # 1: down to label7
# BB#2:                                 # %while.body.i
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.load8_s	$push39=, 1($2)
	tee_local	$push38=, $4=, $pop39
	i32.eqz 	$push81=, $pop38
	br_if   	0, $pop81       # 0: down to label8
# BB#3:                                 # %land.lhs.true.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push3=, 2($2)
	br_if   	5, $pop3        # 5: down to label3
.LBB2_4:                                # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label8:
	block
	block
	block
	block
	i32.const	$push40=, 80
	i32.eq  	$push4=, $4, $pop40
	br_if   	0, $pop4        # 0: down to label12
# BB#5:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push41=, 117
	i32.eq  	$push5=, $4, $pop41
	br_if   	2, $pop5        # 2: down to label10
# BB#6:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push42=, 45
	i32.ne  	$push6=, $4, $pop42
	br_if   	1, $pop6        # 1: down to label11
	br      	6               # 6: down to label5
.LBB2_7:                                # %sw.bb21.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label12:
	i32.const	$push43=, 4096
	i32.or  	$3=, $3, $pop43
.LBB2_8:                                # %sw.epilog.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label11:
	copy_local	$4=, $0
	br      	1               # 1: down to label9
.LBB2_9:                                # %sw.bb.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label10:
	i32.load	$push14=, 4($1)
	i32.eqz 	$push82=, $pop14
	br_if   	5, $pop82       # 5: down to label3
# BB#10:                                # %if.end19.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push52=, 0
	i32.const	$push51=, 4
	i32.add 	$push50=, $1, $pop51
	tee_local	$push49=, $1=, $pop50
	i32.store	$drop=, t+4100($pop52), $pop49
	i32.const	$push48=, 0
	i32.store	$drop=, e($pop48), $1
	i32.const	$push47=, 0
	i32.const	$push46=, -1
	i32.add 	$push45=, $0, $pop46
	tee_local	$push44=, $4=, $pop45
	i32.store	$drop=, d($pop47), $pop44
.LBB2_11:                               # %sw.epilog.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label9:
	i32.const	$push61=, 0
	i32.const	$push60=, 4
	i32.add 	$push59=, $1, $pop60
	tee_local	$push58=, $1=, $pop59
	i32.store	$drop=, e($pop61), $pop58
	i32.const	$push57=, 0
	i32.const	$push56=, -1
	i32.add 	$push55=, $4, $pop56
	tee_local	$push54=, $0=, $pop55
	i32.store	$drop=, d($pop57), $pop54
	i32.const	$push53=, 1
	i32.gt_s	$push15=, $4, $pop53
	br_if   	0, $pop15       # 0: up to label6
.LBB2_12:                               # %while.end.i
	end_loop                        # label7:
	i32.const	$push62=, 1
	i32.lt_s	$push17=, $0, $pop62
	br_if   	1, $pop17       # 1: down to label4
# BB#13:                                # %while.end.i
	i32.const	$push63=, 1
	i32.and 	$push16=, $3, $pop63
	br_if   	1, $pop16       # 1: down to label4
	br      	2               # 2: down to label3
.LBB2_14:                               # %sw.bb22.i
	end_block                       # label5:
	i32.const	$push8=, 0
	i32.const	$push7=, 4
	i32.add 	$push68=, $1, $pop7
	tee_local	$push67=, $1=, $pop68
	i32.store	$drop=, e($pop8), $pop67
	i32.const	$push66=, 0
	i32.const	$push9=, -1
	i32.add 	$push65=, $0, $pop9
	tee_local	$push64=, $0=, $pop65
	i32.store	$drop=, d($pop66), $pop64
	i32.const	$push12=, 1536
	i32.or  	$push13=, $3, $pop12
	i32.const	$push10=, 1
	i32.eq  	$push11=, $3, $pop10
	i32.select	$3=, $pop13, $3, $pop11
.LBB2_15:                               # %setup2.exit
	end_block                       # label4:
	i32.const	$4=, 0
	i32.const	$push70=, 0
	i32.const	$push69=, .L.str.4
	i32.store	$drop=, t($pop70), $pop69
	block
	i32.const	$push18=, 512
	i32.and 	$push19=, $3, $pop18
	i32.eqz 	$push83=, $pop19
	br_if   	0, $pop83       # 0: down to label13
# BB#16:                                # %if.then6.i
	i32.const	$push74=, 0
	i32.const	$push20=, f
	i32.store	$drop=, e($pop74), $pop20
	i32.const	$push73=, 0
	i32.const	$push72=, .L.str.4
	i32.store	$drop=, f($pop73), $pop72
	i32.const	$push71=, 0
	i32.const	$push21=, 1
	i32.add 	$push22=, $0, $pop21
	i32.store	$drop=, d($pop71), $pop22
.LBB2_17:                               # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label14:
	i32.const	$push78=, f+4
	i32.add 	$push23=, $4, $pop78
	i32.add 	$push24=, $1, $4
	i32.load	$push77=, 0($pop24)
	tee_local	$push76=, $2=, $pop77
	i32.store	$drop=, 0($pop23), $pop76
	i32.const	$push75=, 4
	i32.add 	$4=, $4, $pop75
	br_if   	0, $2           # 0: up to label14
.LBB2_18:                               # %setup1.exit
	end_loop                        # label15:
	end_block                       # label13:
	i32.const	$push26=, 1024
	i32.and 	$push27=, $3, $pop26
	i32.eqz 	$push84=, $pop27
	br_if   	1, $pop84       # 1: down to label2
# BB#19:                                # %setup1.exit
	i32.const	$push79=, 0
	i32.load	$push25=, a+16($pop79)
	br_if   	1, $pop25       # 1: down to label2
.LBB2_20:                               # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB2_21:                               # %if.end
	end_block                       # label2:
	i32.const	$push80=, 0
	call    	exit@FUNCTION, $pop80
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
