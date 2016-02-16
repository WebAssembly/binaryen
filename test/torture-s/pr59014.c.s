	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59014.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push9=, 0
	i32.load	$push0=, b($pop9)
	i32.const	$push8=, 0
	i32.gt_s	$push1=, $pop0, $pop8
	i32.const	$push7=, 0
	i32.load	$push6=, a($pop7)
	tee_local	$push5=, $0=, $pop6
	i32.const	$push2=, 1
	i32.and 	$push3=, $pop5, $pop2
	i32.or  	$push4=, $pop1, $pop3
	i32.const	$push12=, 0
	i32.eq  	$push13=, $pop4, $pop12
	br_if   	0, $pop13       # 0: down to label0
.LBB0_1:                                # %for.inc
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	br      	0               # 0: up to label1
.LBB0_2:                                # %if.else
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push11=, 0
	i32.store	$discard=, d($pop11), $0
	i32.const	$push10=, 0
	return  	$pop10
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push13=, 0
	i32.load	$push0=, b($pop13)
	i32.const	$push12=, 0
	i32.gt_s	$push1=, $pop0, $pop12
	i32.const	$push11=, 0
	i32.load	$push10=, a($pop11)
	tee_local	$push9=, $0=, $pop10
	i32.const	$push2=, 1
	i32.and 	$push3=, $pop9, $pop2
	i32.or  	$push4=, $pop1, $pop3
	i32.const	$push15=, 0
	i32.eq  	$push16=, $pop4, $pop15
	br_if   	0, $pop16       # 0: down to label3
.LBB1_1:                                # %for.inc.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	br      	0               # 0: up to label4
.LBB1_2:                                # %foo.exit
	end_loop                        # label5:
	end_block                       # label3:
	block
	i32.const	$push14=, 0
	i32.store	$push5=, d($pop14), $0
	i32.const	$push6=, 2
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label6
# BB#3:                                 # %if.end
	i32.const	$push8=, 0
	return  	$pop8
.LBB1_4:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	2                       # 0x2
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

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


	.ident	"clang version 3.9.0 "
