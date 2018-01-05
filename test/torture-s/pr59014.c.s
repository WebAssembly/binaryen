	.text
	.file	"pr59014.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.load	$0=, a($pop7)
	block   	
	i32.const	$push2=, 1
	i32.and 	$push3=, $0, $pop2
	i32.const	$push6=, 0
	i32.load	$push0=, b($pop6)
	i32.const	$push5=, 0
	i32.gt_s	$push1=, $pop0, $pop5
	i32.or  	$push4=, $pop3, $pop1
	i32.eqz 	$push10=, $pop4
	br_if   	0, $pop10       # 0: down to label0
.LBB0_1:                                # %for.inc
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	br      	0               # 0: up to label1
.LBB0_2:                                # %if.else
	end_loop
	end_block                       # label0:
	i32.const	$push9=, 0
	i32.store	d($pop9), $0
	i32.const	$push8=, 0
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push10=, 0
	i32.load	$0=, a($pop10)
	block   	
	i32.const	$push2=, 1
	i32.and 	$push3=, $0, $pop2
	i32.const	$push9=, 0
	i32.load	$push0=, b($pop9)
	i32.const	$push8=, 0
	i32.gt_s	$push1=, $pop0, $pop8
	i32.or  	$push4=, $pop3, $pop1
	i32.eqz 	$push12=, $pop4
	br_if   	0, $pop12       # 0: down to label2
.LBB1_1:                                # %for.inc.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	br      	0               # 0: up to label3
.LBB1_2:                                # %foo.exit
	end_loop
	end_block                       # label2:
	i32.const	$push11=, 0
	i32.store	d($pop11), $0
	block   	
	i32.const	$push5=, 2
	i32.ne  	$push6=, $0, $pop5
	br_if   	0, $pop6        # 0: down to label4
# %bb.3:                                # %if.end
	i32.const	$push7=, 0
	return  	$pop7
.LBB1_4:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
