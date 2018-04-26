	.text
	.file	"20021120-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 10
	i32.store	g1($pop1), $pop0
	i32.const	$push4=, 0
	i32.const	$push2=, 7930
	i32.div_s	$push3=, $pop2, $0
	i32.store	g2($pop4), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, 10
	i32.store	g2($pop1), $pop0
	i32.const	$push4=, 0
	i32.const	$push3=, 10
	i32.store	g1($pop4), $pop3
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	g1                      # @g1
	.type	g1,@object
	.section	.bss.g1,"aw",@nobits
	.globl	g1
	.p2align	2
g1:
	.int32	0                       # 0x0
	.size	g1, 4

	.hidden	g2                      # @g2
	.type	g2,@object
	.section	.bss.g2,"aw",@nobits
	.globl	g2
	.p2align	2
g2:
	.int32	0                       # 0x0
	.size	g2, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
