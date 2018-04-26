	.text
	.file	"20010221-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$2=, 0
	i32.const	$push6=, 0
	i32.load	$0=, n($pop6)
	block   	
	i32.const	$push5=, 1
	i32.lt_s	$push0=, $0, $pop5
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %for.body.preheader
	i32.const	$1=, 45
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.select	$1=, $2, $1, $2
	i32.const	$push7=, 1
	i32.add 	$2=, $2, $pop7
	i32.lt_s	$push1=, $2, $0
	br_if   	0, $pop1        # 0: up to label1
# %bb.3:                                # %for.end
	end_loop
	i32.const	$push2=, 1
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.4:                                # %if.end5
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
.LBB0_5:                                # %if.then4
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	n                       # @n
	.type	n,@object
	.section	.data.n,"aw",@progbits
	.globl	n
	.p2align	2
n:
	.int32	2                       # 0x2
	.size	n, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
