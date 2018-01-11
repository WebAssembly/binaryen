	.text
	.file	"pr38212.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 2
	i32.shl 	$push1=, $1, $pop0
	i32.sub 	$push2=, $0, $pop1
	i32.const	$push3=, 4
	i32.add 	$1=, $pop2, $pop3
	i32.load	$2=, 0($1)
	i32.const	$push4=, 1
	i32.store	0($0), $pop4
	i32.load	$push5=, 0($1)
	i32.add 	$push6=, $2, $pop5
                                        # fallthrough-return: $pop6
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
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 16
	i32.sub 	$0=, $pop3, $pop5
	i32.const	$push6=, 0
	i32.store	__stack_pointer($pop6), $0
	i32.const	$push13=, 0
	i32.store	12($0), $pop13
	block   	
	i32.const	$push10=, 12
	i32.add 	$push11=, $0, $pop10
	i32.const	$push0=, 1
	i32.call	$push1=, foo@FUNCTION, $pop11, $pop0
	i32.const	$push12=, 1
	i32.ne  	$push2=, $pop1, $pop12
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push9=, 0
	i32.const	$push7=, 16
	i32.add 	$push8=, $0, $pop7
	i32.store	__stack_pointer($pop9), $pop8
	i32.const	$push14=, 0
	return  	$pop14
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
