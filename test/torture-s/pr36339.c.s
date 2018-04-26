	.text
	.file	"pr36339.c"
	.section	.text.try_a,"ax",@progbits
	.hidden	try_a                   # -- Begin function try_a
	.globl	try_a
	.type	try_a,@function
try_a:                                  # @try_a
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 16
	i32.sub 	$1=, $pop3, $pop5
	i32.const	$push6=, 0
	i32.store	__stack_pointer($pop6), $1
	i32.const	$push0=, 0
	i32.store	12($1), $pop0
	i32.store	8($1), $0
	i32.const	$push10=, 8
	i32.add 	$push11=, $1, $pop10
	i32.const	$push1=, 1
	i32.or  	$push2=, $pop11, $pop1
	i32.call	$0=, check_a@FUNCTION, $pop2
	i32.const	$push9=, 0
	i32.const	$push7=, 16
	i32.add 	$push8=, $1, $pop7
	i32.store	__stack_pointer($pop9), $pop8
	copy_local	$push12=, $0
                                        # fallthrough-return: $pop12
	.endfunc
.Lfunc_end0:
	.size	try_a, .Lfunc_end0-try_a
                                        # -- End function
	.section	.text.check_a,"ax",@progbits
	.hidden	check_a                 # -- Begin function check_a
	.globl	check_a
	.type	check_a,@function
check_a:                                # @check_a
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	block   	
	i32.const	$push6=, -1
	i32.add 	$push0=, $0, $pop6
	i32.load	$push1=, 0($pop0)
	i32.const	$push2=, 42
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# %bb.1:                                # %land.lhs.true
	i32.load	$push4=, 3($0)
	i32.eqz 	$push8=, $pop4
	br_if   	1, $pop8        # 1: down to label0
.LBB1_2:                                # %cleanup
	end_block                       # label1:
	i32.const	$push7=, -1
	return  	$pop7
.LBB1_3:
	end_block                       # label0:
	i32.const	$push5=, 0
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end1:
	.size	check_a, .Lfunc_end1-check_a
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 42
	i32.call	$push1=, try_a@FUNCTION, $pop0
	i32.const	$push2=, -1
	i32.le_s	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label2
# %bb.1:                                # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB2_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
