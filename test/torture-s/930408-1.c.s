	.text
	.file	"930408-1.c"
	.section	.text.p,"ax",@progbits
	.hidden	p                       # -- Begin function p
	.globl	p
	.type	p,@function
p:                                      # @p
	.result 	i32
# %bb.0:                                # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	p, .Lfunc_end0-p
                                        # -- End function
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 0
	i32.load	$push1=, s($pop0)
	i32.eqz 	$push2=, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %sw.epilog
	return  	$0
.LBB1_2:                                # %sw.bb
	end_block                       # label0:
	i32.call	$drop=, p@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	s($pop1), $pop0
	i32.call	$drop=, f@FUNCTION
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	2
s:
	.skip	4
	.size	s, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
