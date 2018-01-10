	.text
	.file	"20070212-3.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 4
	i32.add 	$push1=, $0, $pop0
	i32.select	$2=, $0, $pop1, $2
	i32.load	$4=, 0($2)
	i32.const	$push2=, 1
	i32.store	0($0), $pop2
	block   	
	i32.eqz 	$push4=, $3
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %if.then3
	i32.load	$1=, 0($2)
.LBB0_2:                                # %if.end5
	end_block                       # label0:
	i32.add 	$push3=, $1, $4
                                        # fallthrough-return: $pop3
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
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
