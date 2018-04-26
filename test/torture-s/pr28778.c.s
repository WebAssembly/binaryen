	.text
	.file	"pr28778.c"
	.section	.text.find,"ax",@progbits
	.hidden	find                    # -- Begin function find
	.globl	find
	.type	find,@function
find:                                   # @find
	.param  	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 128
	i32.sub 	$1=, $pop4, $pop6
	i32.const	$push7=, 0
	i32.store	__stack_pointer($pop7), $1
	block   	
	br_if   	0, $0           # 0: down to label0
# %bb.1:                                # %if.else
	i32.const	$push0=, 42
	i32.store	12($1), $pop0
	copy_local	$0=, $1
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block   	
	i32.load	$push1=, 12($0)
	i32.const	$push2=, 42
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# %bb.3:                                # %aglChoosePixelFormat.exit
	i32.const	$push10=, 0
	i32.const	$push8=, 128
	i32.add 	$push9=, $1, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	return
.LBB0_4:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	find, .Lfunc_end0-find
                                        # -- End function
	.section	.text.aglChoosePixelFormat,"ax",@progbits
	.hidden	aglChoosePixelFormat    # -- Begin function aglChoosePixelFormat
	.globl	aglChoosePixelFormat
	.type	aglChoosePixelFormat,@function
aglChoosePixelFormat:                   # @aglChoosePixelFormat
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.load	$push0=, 12($0)
	i32.const	$push1=, 42
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label2
# %bb.1:                                # %if.end
	return
.LBB1_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	aglChoosePixelFormat, .Lfunc_end1-aglChoosePixelFormat
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %find.exit
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
