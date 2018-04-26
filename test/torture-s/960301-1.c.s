	.text
	.file	"960301-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load16_u	$1=, foo($pop0)
	i32.const	$push12=, 0
	i32.const	$push1=, 12
	i32.shr_u	$push2=, $1, $pop1
	i32.store	oldfoo($pop12), $pop2
	i32.const	$push11=, 0
	i32.const	$push4=, 4095
	i32.and 	$push5=, $1, $pop4
	i32.const	$push10=, 12
	i32.shl 	$push3=, $0, $pop10
	i32.or  	$push6=, $pop5, $pop3
	i32.store16	foo($pop11), $pop6
	i32.const	$push8=, 1
	i32.const	$push7=, 2
	i32.select	$push9=, $pop8, $pop7, $0
                                        # fallthrough-return: $pop9
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
	.local  	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
	i32.load16_u	$0=, foo($pop0)
	i32.const	$push9=, 0
	i32.const	$push1=, 12
	i32.shr_u	$push2=, $0, $pop1
	i32.store	oldfoo($pop9), $pop2
	i32.const	$push8=, 0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $0, $pop3
	i32.const	$push5=, 4096
	i32.or  	$push6=, $pop4, $pop5
	i32.store16	foo($pop8), $pop6
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	foo                     # @foo
	.type	foo,@object
	.section	.bss.foo,"aw",@nobits
	.globl	foo
	.p2align	2
foo:
	.skip	4
	.size	foo, 4

	.hidden	oldfoo                  # @oldfoo
	.type	oldfoo,@object
	.section	.bss.oldfoo,"aw",@nobits
	.globl	oldfoo
	.p2align	2
oldfoo:
	.int32	0                       # 0x0
	.size	oldfoo, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
