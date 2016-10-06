	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr20601-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	br      	0               # 0: up to label0
.LBB0_2:
	end_loop
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
	i32.const	$push35=, 0
	i32.const	$push34=, 4
	i32.store	b($pop35), $pop34
	i32.const	$push33=, 0
	i32.const	$push0=, g
	i32.store	c($pop33), $pop0
	i32.const	$1=, g+4
	i32.const	$push32=, 0
	i32.const	$push31=, g+4
	i32.store	e($pop32), $pop31
	i32.const	$0=, 3
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
	i32.load	$push38=, 0($1)
	tee_local	$push37=, $2=, $pop38
	i32.load8_u	$push1=, 0($pop37)
	i32.const	$push36=, 45
	i32.ne  	$push2=, $pop1, $pop36
	br_if   	1, $pop2        # 1: down to label5
# BB#2:                                 # %while.body.i
                                        #   in Loop: Header=BB2_1 Depth=1
	block   	
	i32.load8_s	$push40=, 1($2)
	tee_local	$push39=, $4=, $pop40
	i32.eqz 	$push83=, $pop39
	br_if   	0, $pop83       # 0: down to label7
# BB#3:                                 # %land.lhs.true.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push3=, 2($2)
	br_if   	5, $pop3        # 5: down to label2
.LBB2_4:                                # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label7:
	block   	
	block   	
	block   	
	block   	
	i32.const	$push41=, 80
	i32.eq  	$push4=, $4, $pop41
	br_if   	0, $pop4        # 0: down to label11
# BB#5:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push42=, 117
	i32.eq  	$push5=, $4, $pop42
	br_if   	2, $pop5        # 2: down to label9
# BB#6:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push43=, 45
	i32.ne  	$push6=, $4, $pop43
	br_if   	1, $pop6        # 1: down to label10
	br      	6               # 6: down to label4
.LBB2_7:                                # %sw.bb21.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label11:
	i32.const	$push44=, 4096
	i32.or  	$3=, $3, $pop44
.LBB2_8:                                # %sw.epilog.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label10:
	copy_local	$4=, $0
	br      	1               # 1: down to label8
.LBB2_9:                                # %sw.bb.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label9:
	i32.load	$push14=, 4($1)
	i32.eqz 	$push84=, $pop14
	br_if   	5, $pop84       # 5: down to label2
# BB#10:                                # %if.end19.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push53=, 0
	i32.const	$push52=, 4
	i32.add 	$push51=, $1, $pop52
	tee_local	$push50=, $1=, $pop51
	i32.store	t+4100($pop53), $pop50
	i32.const	$push49=, 0
	i32.store	e($pop49), $1
	i32.const	$push48=, 0
	i32.const	$push47=, -1
	i32.add 	$push46=, $0, $pop47
	tee_local	$push45=, $4=, $pop46
	i32.store	d($pop48), $pop45
.LBB2_11:                               # %sw.epilog.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label8:
	i32.const	$push62=, 0
	i32.const	$push61=, 4
	i32.add 	$push60=, $1, $pop61
	tee_local	$push59=, $1=, $pop60
	i32.store	e($pop62), $pop59
	i32.const	$push58=, 0
	i32.const	$push57=, -1
	i32.add 	$push56=, $4, $pop57
	tee_local	$push55=, $0=, $pop56
	i32.store	d($pop58), $pop55
	i32.const	$push54=, 1
	i32.gt_s	$push15=, $4, $pop54
	br_if   	0, $pop15       # 0: up to label6
.LBB2_12:                               # %while.end.i
	end_loop
	end_block                       # label5:
	i32.const	$push63=, 1
	i32.lt_s	$push17=, $0, $pop63
	br_if   	1, $pop17       # 1: down to label3
# BB#13:                                # %while.end.i
	i32.const	$push64=, 1
	i32.and 	$push16=, $3, $pop64
	br_if   	1, $pop16       # 1: down to label3
	br      	2               # 2: down to label2
.LBB2_14:                               # %sw.bb22.i
	end_block                       # label4:
	i32.const	$push8=, 0
	i32.const	$push7=, 4
	i32.add 	$push69=, $1, $pop7
	tee_local	$push68=, $1=, $pop69
	i32.store	e($pop8), $pop68
	i32.const	$push67=, 0
	i32.const	$push9=, -1
	i32.add 	$push66=, $0, $pop9
	tee_local	$push65=, $0=, $pop66
	i32.store	d($pop67), $pop65
	i32.const	$push12=, 1536
	i32.or  	$push13=, $3, $pop12
	i32.const	$push10=, 1
	i32.eq  	$push11=, $3, $pop10
	i32.select	$3=, $pop13, $3, $pop11
.LBB2_15:                               # %setup2.exit
	end_block                       # label3:
	i32.const	$push71=, 0
	i32.const	$push70=, .L.str.4
	i32.store	t($pop71), $pop70
	block   	
	i32.const	$push18=, 512
	i32.and 	$push19=, $3, $pop18
	i32.eqz 	$push85=, $pop19
	br_if   	0, $pop85       # 0: down to label12
# BB#16:                                # %if.then6.i
	i32.const	$push76=, 0
	i32.const	$push75=, f
	i32.store	e($pop76), $pop75
	i32.const	$push74=, 0
	i32.const	$push73=, .L.str.4
	i32.store	f($pop74), $pop73
	i32.const	$push72=, 0
	i32.const	$push20=, 1
	i32.add 	$push21=, $0, $pop20
	i32.store	d($pop72), $pop21
	i32.const	$4=, 4
.LBB2_17:                               # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label13:
	i32.const	$push81=, f
	i32.add 	$push22=, $4, $pop81
	i32.add 	$push23=, $1, $4
	i32.const	$push80=, -4
	i32.add 	$push24=, $pop23, $pop80
	i32.load	$push79=, 0($pop24)
	tee_local	$push78=, $2=, $pop79
	i32.store	0($pop22), $pop78
	i32.const	$push77=, 4
	i32.add 	$4=, $4, $pop77
	br_if   	0, $2           # 0: up to label13
.LBB2_18:                               # %setup1.exit
	end_loop
	end_block                       # label12:
	i32.const	$push26=, 1024
	i32.and 	$push27=, $3, $pop26
	i32.eqz 	$push86=, $pop27
	br_if   	1, $pop86       # 1: down to label1
# BB#19:                                # %setup1.exit
	i32.const	$push82=, 0
	i32.load	$push25=, a+16($pop82)
	br_if   	1, $pop25       # 1: down to label1
.LBB2_20:                               # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB2_21:                               # %if.end
	end_block                       # label1:
	i32.const	$push28=, 0
	call    	exit@FUNCTION, $pop28
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
