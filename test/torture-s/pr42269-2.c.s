	.text
	.file	"pr42269-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load16_u	$push1=, s($pop0)
	i64.call	$push2=, foo@FUNCTION, $pop1
	i64.const	$push3=, -1
	i64.ne  	$push4=, $pop2, $pop3
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.type	foo,@function           # -- Begin function foo
foo:                                    # @foo
	.param  	i32
	.result 	i64
# %bb.0:                                # %entry
	i64.extend_u/i32	$push0=, $0
	i64.const	$push1=, 48
	i64.shl 	$push2=, $pop0, $pop1
	i64.const	$push4=, 48
	i64.shr_s	$push3=, $pop2, $pop4
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.hidden	s                       # @s
	.type	s,@object
	.section	.data.s,"aw",@progbits
	.globl	s
	.p2align	1
s:
	.int16	65535                   # 0xffff
	.size	s, 2


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
