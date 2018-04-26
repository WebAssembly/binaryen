	.text
	.file	"960909-1.c"
	.section	.text.ffs,"ax",@progbits
	.hidden	ffs                     # -- Begin function ffs
	.globl	ffs
	.type	ffs,@function
ffs:                                    # @ffs
	.param  	i32
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	block   	
	i32.eqz 	$push6=, $0
	br_if   	0, $pop6        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$2=, 1
	block   	
	i32.const	$push3=, 1
	i32.and 	$push0=, $0, $pop3
	br_if   	0, $pop0        # 0: down to label1
# %bb.2:                                # %for.inc.preheader
	i32.const	$1=, 1
	i32.const	$2=, 1
.LBB0_3:                                # %for.inc
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push5=, 1
	i32.add 	$2=, $2, $pop5
	i32.const	$push4=, 1
	i32.shl 	$1=, $1, $pop4
	i32.and 	$push1=, $1, $0
	i32.eqz 	$push7=, $pop1
	br_if   	0, $pop7        # 0: up to label2
.LBB0_4:                                # %cleanup
	end_loop
	end_block                       # label1:
	return  	$2
.LBB0_5:
	end_block                       # label0:
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	ffs, .Lfunc_end0-ffs
                                        # -- End function
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.eqz 	$push0=, $0
	br_if   	0, $pop0        # 0: down to label3
# %bb.1:                                # %if.end
	return  	$0
.LBB1_2:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
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
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
