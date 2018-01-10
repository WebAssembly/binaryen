	.text
	.file	"20021118-3.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push2=, -2
	i32.eq  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %entry
	i32.const	$push1=, -100
	i32.sub 	$push0=, $pop1, $0
	i32.const	$push5=, 0
	i32.ge_s	$push4=, $pop0, $pop5
	br_if   	0, $pop4        # 0: down to label0
# %bb.2:                                # %if.end
	i32.const	$push6=, 0
	return  	$pop6
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
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
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
