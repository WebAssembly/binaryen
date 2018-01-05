	.text
	.file	"pr55875.c"
	.section	.text.t,"ax",@progbits
	.hidden	t                       # -- Begin function t
	.globl	t
	.type	t,@function
t:                                      # @t
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	block   	
	i32.eqz 	$push3=, $0
	br_if   	0, $pop3        # 0: down to label1
# %bb.1:                                # %if.end
	i32.const	$push0=, 256
	i32.ge_s	$push1=, $0, $pop0
	br_if   	1, $pop1        # 1: down to label0
# %bb.2:                                # %if.end3
	return  	$0
.LBB0_3:                                # %if.then
	end_block                       # label1:
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
.LBB0_4:                                # %if.then2
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	t, .Lfunc_end0-t
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$0=, 5
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	i32             # label2:
	i32.const	$push2=, 255
	i32.and 	$push0=, $0, $pop2
	i32.call	$drop=, t@FUNCTION, $pop0
	i32.const	$push1=, 1
	i32.add 	$0=, $0, $pop1
	br      	0               # 0: up to label2
.LBB1_2:
	end_loop
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	4
a:
	.skip	1004
	.size	a, 1004


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
	.functype	abort, void
