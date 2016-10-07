	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59014.c"
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
	i32.load	$push2=, b($pop9)
	i32.const	$push8=, 0
	i32.gt_s	$push3=, $pop2, $pop8
	i32.const	$push7=, 0
	i32.load	$push6=, a($pop7)
	tee_local	$push5=, $0=, $pop6
	i32.const	$push0=, 1
	i32.and 	$push1=, $pop5, $pop0
	i32.or  	$push4=, $pop3, $pop1
	i32.eqz 	$push12=, $pop4
	br_if   	0, $pop12       # 0: down to label0
.LBB0_1:                                # %for.inc
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	br      	0               # 0: up to label1
.LBB0_2:                                # %if.else
	end_loop
	end_block                       # label0:
	i32.const	$push11=, 0
	i32.store	d($pop11), $0
	i32.const	$push10=, 0
                                        # fallthrough-return: $pop10
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
	i32.const	$push12=, 0
	i32.load	$push2=, b($pop12)
	i32.const	$push11=, 0
	i32.gt_s	$push3=, $pop2, $pop11
	i32.const	$push10=, 0
	i32.load	$push9=, a($pop10)
	tee_local	$push8=, $0=, $pop9
	i32.const	$push0=, 1
	i32.and 	$push1=, $pop8, $pop0
	i32.or  	$push4=, $pop3, $pop1
	i32.eqz 	$push14=, $pop4
	br_if   	0, $pop14       # 0: down to label2
.LBB1_1:                                # %for.inc.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	br      	0               # 0: up to label3
.LBB1_2:                                # %foo.exit
	end_loop
	end_block                       # label2:
	i32.const	$push13=, 0
	i32.store	d($pop13), $0
	block   	
	i32.const	$push5=, 2
	i32.ne  	$push6=, $0, $pop5
	br_if   	0, $pop6        # 0: down to label4
# BB#3:                                 # %if.end
	i32.const	$push7=, 0
	return  	$pop7
.LBB1_4:                                # %if.then
	end_block                       # label4:
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
