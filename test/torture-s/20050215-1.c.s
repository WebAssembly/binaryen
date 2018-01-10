	.text
	.file	"20050215-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	block   	
	block   	
	i32.const	$push13=, v
	i32.const	$push0=, 4
	i32.and 	$push1=, $pop13, $pop0
	i32.eqz 	$push17=, $pop1
	br_if   	0, $pop17       # 0: down to label2
# %bb.1:                                # %if.then
	i32.const	$push14=, v
	i32.const	$push10=, 7
	i32.and 	$push11=, $pop14, $pop10
	i32.eqz 	$push18=, $pop11
	br_if   	1, $pop18       # 1: down to label1
	br      	2               # 2: down to label0
.LBB0_2:                                # %lor.lhs.false
	end_block                       # label2:
	i32.const	$push16=, v
	i32.const	$push6=, 1
	i32.and 	$push7=, $pop16, $pop6
	i32.eqz 	$push8=, $pop7
	i32.const	$push15=, v
	i32.const	$push2=, 7
	i32.and 	$push3=, $pop15, $pop2
	i32.const	$push4=, 0
	i32.ne  	$push5=, $pop3, $pop4
	i32.or  	$push9=, $pop8, $pop5
	br_if   	1, $pop9        # 1: down to label0
.LBB0_3:                                # %if.then2
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %if.end3
	end_block                       # label0:
	i32.const	$push12=, 0
                                        # fallthrough-return: $pop12
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	v                       # @v
	.type	v,@object
	.section	.bss.v,"aw",@nobits
	.globl	v
v:
	.skip	8
	.size	v, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
