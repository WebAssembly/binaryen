	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20140212-1.c"
	.section	.text.fn1,"ax",@progbits
	.hidden	fn1
	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push21=, 0
	i32.const	$push20=, 0
	i32.store	c($pop21), $pop20
	i32.const	$push19=, 0
	i32.const	$push18=, 0
	i32.store	e($pop19), $pop18
	i32.const	$push4=, 54
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.load	$push2=, a($pop16)
	i32.const	$push15=, 0
	i32.ne  	$push3=, $pop2, $pop15
	i32.const	$push14=, 0
	i32.load	$push0=, b($pop14)
	i32.const	$push13=, 0
	i32.ne  	$push1=, $pop0, $pop13
	i32.and 	$push12=, $pop3, $pop1
	tee_local	$push11=, $0=, $pop12
	i32.select	$push10=, $pop4, $pop17, $pop11
	tee_local	$push9=, $1=, $pop10
	i32.const	$push5=, 147
	i32.mul 	$2=, $pop9, $pop5
	i32.const	$push8=, 0
	i32.load	$4=, f($pop8)
	i32.const	$push7=, 0
	i32.load	$3=, d($pop7)
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	block   	
	i32.eqz 	$push30=, $3
	br_if   	0, $pop30       # 0: down to label2
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push23=, 0
	i32.const	$push22=, 1
	i32.store	c($pop23), $pop22
	i32.eqz 	$push31=, $4
	br_if   	1, $pop31       # 1: up to label1
	br      	2               # 2: down to label0
.LBB0_3:                                # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push27=, 0
	i32.const	$push26=, 9
	i32.store	h($pop27), $pop26
	i32.const	$push25=, 0
	i32.const	$push24=, 9
	i32.store	i($pop25), $pop24
	i32.eqz 	$push32=, $4
	br_if   	0, $pop32       # 0: up to label1
.LBB0_4:                                # %if.then15
	end_loop
	end_block                       # label0:
	i32.const	$push6=, 0
	i32.store8	j($pop6), $1
	i32.const	$push29=, 0
	i32.store	k($pop29), $0
	i32.const	$push28=, 0
	i32.store8	g($pop28), $2
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	fn1, .Lfunc_end0-fn1

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push21=, 0
	i32.const	$push20=, 0
	i32.store	c($pop21), $pop20
	i32.const	$push19=, 0
	i32.const	$push18=, 0
	i32.store	e($pop19), $pop18
	i32.const	$push4=, 54
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.load	$push2=, a($pop16)
	i32.const	$push15=, 0
	i32.ne  	$push3=, $pop2, $pop15
	i32.const	$push14=, 0
	i32.load	$push0=, b($pop14)
	i32.const	$push13=, 0
	i32.ne  	$push1=, $pop0, $pop13
	i32.and 	$push12=, $pop3, $pop1
	tee_local	$push11=, $0=, $pop12
	i32.select	$1=, $pop4, $pop17, $pop11
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
	i32.eqz 	$push32=, $2
	br_if   	0, $pop32       # 0: down to label5
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$4=, 1
	i32.const	$push23=, 0
	i32.const	$push22=, 1
	i32.store	c($pop23), $pop22
	i32.eqz 	$push33=, $3
	br_if   	1, $pop33       # 1: up to label4
	br      	2               # 2: down to label3
.LBB1_3:                                # %if.else.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label5:
	i32.const	$push27=, 0
	i32.const	$push26=, 9
	i32.store	h($pop27), $pop26
	i32.const	$push25=, 0
	i32.const	$push24=, 9
	i32.store	i($pop25), $pop24
	i32.eqz 	$push34=, $3
	br_if   	0, $pop34       # 0: up to label4
.LBB1_4:                                # %fn1.exit
	end_loop
	end_block                       # label3:
	i32.const	$push30=, 0
	i32.store8	j($pop30), $1
	i32.const	$push29=, 0
	i32.store	k($pop29), $0
	i32.const	$push28=, 0
	i32.const	$push5=, 147
	i32.mul 	$push6=, $1, $pop5
	i32.store8	g($pop28), $pop6
	block   	
	i32.const	$push7=, 1
	i32.ne  	$push8=, $4, $pop7
	br_if   	0, $pop8        # 0: down to label6
# BB#5:                                 # %if.end
	i32.const	$push31=, 0
	return  	$pop31
.LBB1_6:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
