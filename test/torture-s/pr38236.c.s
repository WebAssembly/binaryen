	.text
	.file	"pr38236.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$4=, $pop4, $pop6
	i32.const	$push7=, 12
	i32.add 	$push8=, $4, $pop7
	i32.const	$push9=, 8
	i32.add 	$push10=, $4, $pop9
	i32.select	$push0=, $pop8, $pop10, $3
	i32.const	$push1=, 1
	i32.store	0($pop0), $pop1
	i32.const	$push11=, 12
	i32.add 	$push12=, $4, $pop11
	i32.select	$push2=, $pop12, $0, $2
	i32.load	$push3=, 0($pop2)
                                        # fallthrough-return: $pop3
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
	.local  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push5=, 0
	i32.const	$push0=, 1
	i32.const	$push4=, 1
	i32.call	$push1=, foo@FUNCTION, $pop5, $0, $pop0, $pop4
	i32.const	$push3=, 1
	i32.ne  	$push2=, $pop1, $pop3
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push6=, 0
	return  	$pop6
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
