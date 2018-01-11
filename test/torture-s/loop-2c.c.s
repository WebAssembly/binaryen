	.text
	.file	"loop-2c.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	block   	
	i32.eqz 	$push10=, $0
	br_if   	0, $pop10       # 0: down to label0
# %bb.1:                                # %for.body.lr.ph
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, a-4
	i32.add 	$2=, $pop1, $pop2
	i32.const	$push3=, 3
	i32.mul 	$push4=, $0, $pop3
	i32.add 	$push5=, $1, $pop4
	i32.const	$push6=, -3
	i32.add 	$1=, $pop5, $pop6
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.store	0($2), $1
	i32.const	$push9=, -4
	i32.add 	$2=, $2, $pop9
	i32.const	$push8=, -3
	i32.add 	$1=, $1, $pop8
	i32.const	$push7=, -1
	i32.add 	$0=, $0, $pop7
	br_if   	0, $0           # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop
	end_block                       # label0:
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	block   	
	i32.eqz 	$push9=, $0
	br_if   	0, $pop9        # 0: down to label2
# %bb.1:                                # %for.body.lr.ph.i
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, a-4
	i32.add 	$1=, $pop1, $pop2
	i32.const	$push3=, 3
	i32.mul 	$push4=, $0, $pop3
	i32.const	$push5=, a-3
	i32.add 	$2=, $pop4, $pop5
.LBB1_2:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.store	0($1), $2
	i32.const	$push8=, -4
	i32.add 	$1=, $1, $pop8
	i32.const	$push7=, -3
	i32.add 	$2=, $2, $pop7
	i32.const	$push6=, -1
	i32.add 	$0=, $0, $pop6
	br_if   	0, $0           # 0: up to label3
.LBB1_3:                                # %f.exit
	end_loop
	end_block                       # label2:
	copy_local	$push10=, $0
                                        # fallthrough-return: $pop10
	.endfunc
.Lfunc_end1:
	.size	g, .Lfunc_end1-g
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, a
	i32.store	a($pop1), $pop0
	i32.const	$push4=, 0
	i32.const	$push2=, a+3
	i32.store	a+4($pop4), $pop2
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.skip	8
	.size	a, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
