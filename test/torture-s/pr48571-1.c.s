	.text
	.file	"pr48571-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$1=, c($pop0)
	i32.const	$0=, 4
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push6=, 1
	i32.shl 	$1=, $1, $pop6
	i32.const	$push5=, c
	i32.add 	$push1=, $0, $pop5
	i32.store	0($pop1), $1
	i32.const	$push4=, 4
	i32.add 	$0=, $0, $pop4
	i32.const	$push3=, 2496
	i32.ne  	$push2=, $0, $pop3
	br_if   	0, $pop2        # 0: up to label0
# %bb.2:                                # %for.end
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$0=, -2496
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push7=, c+2496
	i32.add 	$push0=, $0, $pop7
	i32.const	$push6=, 1
	i32.store	0($pop0), $pop6
	i32.const	$push5=, 4
	i32.add 	$0=, $0, $pop5
	br_if   	0, $0           # 0: up to label1
# %bb.2:                                # %for.end
	end_loop
	call    	bar@FUNCTION
	i32.const	$0=, 0
	i32.const	$1=, c
	i32.const	$2=, 1
.LBB1_3:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label3:
	i32.load	$push1=, 0($1)
	i32.ne  	$push2=, $pop1, $2
	br_if   	1, $pop2        # 1: down to label2
# %bb.4:                                # %if.end
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push11=, 4
	i32.add 	$1=, $1, $pop11
	i32.const	$push10=, 1
	i32.shl 	$2=, $2, $pop10
	i32.const	$push9=, 1
	i32.add 	$0=, $0, $pop9
	i32.const	$push8=, 624
	i32.lt_u	$push3=, $0, $pop8
	br_if   	0, $pop3        # 0: up to label3
# %bb.5:                                # %for.end8
	end_loop
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_6:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	4
c:
	.skip	2496
	.size	c, 2496


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
