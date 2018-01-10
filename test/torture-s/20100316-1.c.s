	.text
	.file	"20100316-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.load16_u	$push0=, 4($0)
	i32.const	$push1=, 1023
	i32.and 	$push2=, $pop0, $pop1
                                        # fallthrough-return: $pop2
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
# %bb.0:                                # %entry
	i32.const	$push10=, 0
	i32.const	$push0=, -1
	i32.store	f($pop10), $pop0
	i32.const	$push9=, 0
	i32.const	$push8=, 0
	i32.load16_u	$push1=, f+4($pop8)
	i32.const	$push2=, 57344
	i32.and 	$push3=, $pop1, $pop2
	i32.const	$push4=, 7168
	i32.or  	$push5=, $pop3, $pop4
	i32.store16	f+4($pop9), $pop5
	block   	
	i32.const	$push6=, f
	i32.call	$push7=, foo@FUNCTION, $pop6
	br_if   	0, $pop7        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push11=, 0
	return  	$pop11
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.skip	8
	.size	f, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
