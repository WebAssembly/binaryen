	.text
	.file	"20050124-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
	i32.add 	$2=, $0, $pop0
	block   	
	block   	
	i32.eqz 	$push7=, $1
	br_if   	0, $pop7        # 0: down to label1
# %bb.1:                                # %if.then
	i32.const	$push1=, 0
	i32.lt_s	$push2=, $0, $pop1
	br_if   	1, $pop2        # 1: down to label0
# %bb.2:                                # %if.then1
	i32.const	$push6=, 2
	i32.add 	$2=, $0, $pop6
.LBB0_3:                                # %if.end5
	end_block                       # label1:
	return  	$2
.LBB0_4:                                # %if.else
	end_block                       # label0:
	i32.const	$push3=, -1
	i32.eq  	$push4=, $0, $pop3
	i32.select	$push5=, $2, $0, $pop4
                                        # fallthrough-return: $pop5
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
# %bb.0:                                # %if.end28
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
