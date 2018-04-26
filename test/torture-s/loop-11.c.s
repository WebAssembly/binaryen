	.text
	.file	"loop-11.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$1=, 198
	i32.const	$0=, a+792
.LBB0_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.store	0($0), $1
	i32.const	$push7=, -4
	i32.add 	$0=, $0, $pop7
	i32.const	$push6=, -1
	i32.add 	$1=, $1, $pop6
	i32.const	$push5=, -1
	i32.ne  	$push0=, $1, $pop5
	br_if   	0, $pop0        # 0: up to label0
# %bb.2:                                # %for.body.preheader
	end_loop
	i32.const	$1=, 0
	i32.const	$0=, a
.LBB0_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.load	$push1=, 0($0)
	i32.ne  	$push2=, $1, $pop1
	br_if   	1, $pop2        # 1: down to label1
# %bb.4:                                # %for.cond
                                        #   in Loop: Header=BB0_3 Depth=1
	i32.const	$push10=, 1
	i32.add 	$1=, $1, $pop10
	i32.const	$push9=, 4
	i32.add 	$0=, $0, $pop9
	i32.const	$push8=, 198
	i32.le_u	$push3=, $1, $pop8
	br_if   	0, $pop3        # 0: up to label2
# %bb.5:                                # %for.end
	end_loop
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_6:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	a,@object               # @a
	.section	.bss.a,"aw",@nobits
	.p2align	4
a:
	.skip	796
	.size	a, 796


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
