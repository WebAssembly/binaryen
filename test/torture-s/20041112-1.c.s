	.text
	.file	"20041112-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$0=, global($pop0)
	i32.const	$push1=, 1
	i32.add 	$push2=, $0, $pop1
	i32.const	$push3=, 2
	i32.select	$1=, $pop2, $pop3, $0
	i32.const	$push15=, 0
	i32.const	$push14=, 1
	i32.const	$push5=, global
	i32.const	$push4=, -1
	i32.eq  	$push6=, $pop5, $pop4
	i32.select	$push7=, $1, $pop14, $pop6
	i32.select	$push8=, $1, $pop7, $0
	i32.store	global($pop15), $pop8
	i32.eqz 	$push10=, $0
	i32.const	$push13=, global
	i32.const	$push12=, -1
	i32.ne  	$push9=, $pop13, $pop12
	i32.and 	$push11=, $pop10, $pop9
                                        # fallthrough-return: $pop11
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
	i32.const	$push1=, 0
	i32.const	$push0=, 2
	i32.store	global($pop1), $pop0
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	global                  # @global
	.type	global,@object
	.section	.bss.global,"aw",@nobits
	.globl	global
	.p2align	2
global:
	.int32	0                       # 0x0
	.size	global, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
