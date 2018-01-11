	.text
	.file	"20010925-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
	i32.const	$push6=, 0
	i32.load16_u	$push1=, src+8($pop6)
	i32.store16	dst+8($pop0), $pop1
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i64.load	$push2=, src($pop4)
	i64.store	dst($pop5), $pop2
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.eqz 	$push2=, $2
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.call	$drop=, memcpy@FUNCTION, $0, $1, $2
	i32.const	$push0=, 0
	return  	$pop0
.LBB1_2:
	end_block                       # label0:
	i32.const	$push1=, 1
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.hidden	dst                     # @dst
	.type	dst,@object
	.section	.bss.dst,"aw",@nobits
	.globl	dst
	.p2align	4
dst:
	.skip	40
	.size	dst, 40

	.hidden	src                     # @src
	.type	src,@object
	.section	.bss.src,"aw",@nobits
	.globl	src
	.p2align	4
src:
	.skip	40
	.size	src, 40


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
