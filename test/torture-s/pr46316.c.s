	.text
	.file	"pr46316.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i64
	.result 	i64
	.local  	i64
# %bb.0:                                # %entry
	i64.const	$push0=, -1
	i64.xor 	$1=, $0, $pop0
	i64.const	$push1=, 3
	i64.const	$push10=, 3
	i64.gt_s	$push2=, $1, $pop10
	i64.select	$push3=, $1, $pop1, $pop2
	i64.add 	$push4=, $pop3, $0
	i64.const	$push5=, 2
	i64.add 	$push6=, $pop4, $pop5
	i64.const	$push7=, -2
	i64.and 	$push8=, $pop6, $pop7
	i64.sub 	$push9=, $0, $pop8
                                        # fallthrough-return: $pop9
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
	block   	
	i64.const	$push0=, 0
	i64.call	$push1=, foo@FUNCTION, $pop0
	i64.const	$push2=, -4
	i64.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
