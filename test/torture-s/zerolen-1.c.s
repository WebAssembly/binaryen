	.text
	.file	"zerolen-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.then
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store16	entry($pop1):p2align=0, $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.set,"ax",@progbits
	.hidden	set                     # -- Begin function set
	.globl	set
	.type	set,@function
set:                                    # @set
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
	i32.store16	0($0):p2align=0, $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	set, .Lfunc_end1-set
                                        # -- End function
	.hidden	entry                   # @entry
	.type	entry,@object
	.section	.bss.entry,"aw",@nobits
	.globl	entry
entry:
	.skip	4
	.size	entry, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
