	.text
	.file	"loop-2b.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 2147483647
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %for.body.preheader
	i32.const	$push2=, 2147483646
	i32.sub 	$1=, $pop2, $0
	i32.const	$push3=, 2
	i32.shl 	$push4=, $0, $pop3
	i32.const	$push5=, a
	i32.add 	$2=, $pop4, $pop5
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	copy_local	$0=, $1
	i32.const	$push8=, -2
	i32.store	0($2), $pop8
	i32.const	$push7=, 2147483645
	i32.eq  	$push6=, $0, $pop7
	br_if   	1, $pop6        # 1: down to label0
# %bb.3:                                # %for.body
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push10=, -1
	i32.add 	$1=, $0, $pop10
	i32.const	$push9=, 4
	i32.add 	$2=, $2, $pop9
	br_if   	0, $0           # 0: up to label1
.LBB0_4:                                # %for.end
	end_loop
	end_block                       # label0:
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push1=, 0
	i64.const	$push0=, -4294967298
	i64.store	a($pop1):p2align=2, $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
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
