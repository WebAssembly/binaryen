	.text
	.file	"20140425-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 16
	i32.sub 	$1=, $pop5, $pop7
	i32.const	$push8=, 0
	i32.store	__stack_pointer($pop8), $1
	i32.const	$push12=, 12
	i32.add 	$push13=, $1, $pop12
	call    	set@FUNCTION, $pop13
	i32.load	$0=, 12($1)
	i32.const	$push0=, 2
	i32.shl 	$push1=, $pop0, $0
	i32.store	12($1), $pop1
	block   	
	i32.const	$push2=, 30
	i32.le_u	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push11=, 0
	i32.const	$push9=, 16
	i32.add 	$push10=, $1, $pop9
	i32.store	__stack_pointer($pop11), $pop10
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.set,"ax",@progbits
	.type	set,@function           # -- Begin function set
set:                                    # @set
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 31
	i32.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	set, .Lfunc_end1-set
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
