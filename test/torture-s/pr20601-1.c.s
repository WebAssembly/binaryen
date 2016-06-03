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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push38=, 0
	i32.const	$push1=, 4
	i32.store	$0=, b($pop38), $pop1
	i32.const	$push37=, 0
	i32.const	$push2=, g
	i32.store	$drop=, c($pop37), $pop2
	i32.const	$3=, g+4
	i32.const	$push36=, 0
	i32.const	$push35=, g+4
	i32.store	$drop=, e($pop36), $pop35
	i32.const	$2=, 3
	i32.const	$push34=, 0
	i32.const	$push33=, 3
	i32.store	$drop=, d($pop34), $pop33
	i32.const	$4=, 1
.LBB2_1:                                # %land.rhs.i
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	block
	block
	loop                            # label6:
	i32.load	$push41=, 0($3)
	tee_local	$push40=, $1=, $pop41
	i32.load8_u	$push3=, 0($pop40)
	i32.const	$push39=, 45
	i32.ne  	$push4=, $pop3, $pop39
	br_if   	1, $pop4        # 1: down to label7
# BB#2:                                 # %while.body.i
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.load8_s	$push43=, 1($1)
	tee_local	$push42=, $5=, $pop43
	i32.eqz 	$push78=, $pop42
	br_if   	0, $pop78       # 0: down to label8
# BB#3:                                 # %land.lhs.true.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push5=, 2($1)
	br_if   	5, $pop5        # 5: down to label3
.LBB2_4:                                # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label8:
	block
	block
	block
	block
	i32.const	$push44=, 80
	i32.eq  	$push6=, $5, $pop44
	br_if   	0, $pop6        # 0: down to label12
# BB#5:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push45=, 117
	i32.eq  	$push7=, $5, $pop45
	br_if   	2, $pop7        # 2: down to label10
# BB#6:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push46=, 45
	i32.ne  	$push8=, $5, $pop46
	br_if   	1, $pop8        # 1: down to label11
	br      	6               # 6: down to label5
.LBB2_7:                                # %sw.bb21.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label12:
	i32.const	$push47=, 4096
	i32.or  	$4=, $4, $pop47
.LBB2_8:                                # %sw.epilog.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label11:
	copy_local	$5=, $2
	br      	1               # 1: down to label9
.LBB2_9:                                # %sw.bb.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label10:
	i32.load	$push16=, 4($3)
	i32.eqz 	$push79=, $pop16
	br_if   	5, $pop79       # 5: down to label3
# BB#10:                                # %if.end19.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push55=, 0
	i32.const	$push54=, 0
	i32.add 	$push53=, $3, $0
	tee_local	$push52=, $3=, $pop53
	i32.store	$push0=, t+4100($pop54), $pop52
	i32.store	$drop=, e($pop55), $pop0
	i32.const	$push51=, 0
	i32.const	$push50=, -1
	i32.add 	$push49=, $2, $pop50
	tee_local	$push48=, $5=, $pop49
	i32.store	$drop=, d($pop51), $pop48
.LBB2_11:                               # %sw.epilog.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label9:
	i32.const	$push63=, 0
	i32.add 	$push62=, $3, $0
	tee_local	$push61=, $3=, $pop62
	i32.store	$drop=, e($pop63), $pop61
	i32.const	$push60=, 0
	i32.const	$push59=, -1
	i32.add 	$push58=, $5, $pop59
	tee_local	$push57=, $2=, $pop58
	i32.store	$drop=, d($pop60), $pop57
	i32.const	$push56=, 1
	i32.gt_s	$push17=, $5, $pop56
	br_if   	0, $pop17       # 0: up to label6
.LBB2_12:                               # %while.end.i
	end_loop                        # label7:
	i32.const	$push64=, 1
	i32.lt_s	$push19=, $2, $pop64
	br_if   	1, $pop19       # 1: down to label4
# BB#13:                                # %while.end.i
	i32.const	$push65=, 1
	i32.and 	$push18=, $4, $pop65
	br_if   	1, $pop18       # 1: down to label4
	br      	2               # 2: down to label3
.LBB2_14:                               # %sw.bb22.i
	end_block                       # label5:
	i32.const	$push10=, 0
	i32.const	$push9=, 4
	i32.add 	$push70=, $3, $pop9
	tee_local	$push69=, $3=, $pop70
	i32.store	$drop=, e($pop10), $pop69
	i32.const	$push68=, 0
	i32.const	$push11=, -1
	i32.add 	$push67=, $2, $pop11
	tee_local	$push66=, $2=, $pop67
	i32.store	$drop=, d($pop68), $pop66
	i32.const	$push14=, 1536
	i32.or  	$push15=, $4, $pop14
	i32.const	$push12=, 1
	i32.eq  	$push13=, $4, $pop12
	i32.select	$4=, $pop15, $4, $pop13
.LBB2_15:                               # %setup2.exit
	end_block                       # label4:
	i32.const	$push71=, 0
	i32.const	$push20=, .L.str.4
	i32.store	$5=, t($pop71), $pop20
	block
	i32.const	$push21=, 512
	i32.and 	$push22=, $4, $pop21
	i32.eqz 	$push80=, $pop22
	br_if   	0, $pop80       # 0: down to label13
# BB#16:                                # %if.then6.i
	i32.const	$push74=, 0
	i32.const	$push23=, f
	i32.store	$drop=, e($pop74), $pop23
	i32.const	$push73=, 0
	i32.store	$drop=, f($pop73), $5
	i32.const	$push72=, 0
	i32.const	$push24=, 1
	i32.add 	$push25=, $2, $pop24
	i32.store	$drop=, d($pop72), $pop25
	i32.const	$5=, 4
.LBB2_17:                               # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label14:
	i32.add 	$push26=, $3, $5
	i32.const	$push76=, -4
	i32.add 	$push27=, $pop26, $pop76
	i32.load	$push28=, 0($pop27)
	i32.store	$1=, f($5), $pop28
	i32.const	$push75=, 4
	i32.add 	$5=, $5, $pop75
	br_if   	0, $1           # 0: up to label14
.LBB2_18:                               # %setup1.exit
	end_loop                        # label15:
	end_block                       # label13:
	i32.const	$push30=, 1024
	i32.and 	$push31=, $4, $pop30
	i32.eqz 	$push81=, $pop31
	br_if   	1, $pop81       # 1: down to label2
# BB#19:                                # %setup1.exit
	i32.const	$push77=, 0
	i32.load	$push29=, a+16($pop77)
	br_if   	1, $pop29       # 1: down to label2
.LBB2_20:                               # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB2_21:                               # %if.end
	end_block                       # label2:
	i32.const	$push32=, 0
	call    	exit@FUNCTION, $pop32
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
	.functype	abort, void
	.functype	exit, void, i32
