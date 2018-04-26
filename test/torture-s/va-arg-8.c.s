	.text
	.file	"va-arg-8.c"
	.section	.text.debug,"ax",@progbits
	.hidden	debug                   # -- Begin function debug
	.globl	debug
	.type	debug,@function
debug:                                  # @debug
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push13=, 0
	i32.load	$push12=, __stack_pointer($pop13)
	i32.const	$push14=, 16
	i32.sub 	$11=, $pop12, $pop14
	i32.const	$push15=, 0
	i32.store	__stack_pointer($pop15), $11
	i32.const	$push0=, 4
	i32.add 	$10=, $9, $pop0
	i32.store	12($11), $10
	block   	
	i32.load	$push1=, 0($9)
	i32.const	$push2=, 10
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 7
	i32.add 	$push5=, $10, $pop4
	i32.const	$push6=, -8
	i32.and 	$9=, $pop5, $pop6
	i32.const	$push7=, 8
	i32.add 	$push8=, $9, $pop7
	i32.store	12($11), $pop8
	i64.load	$push9=, 0($9)
	i64.const	$push10=, 20014547621496
	i64.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# %bb.2:                                # %if.end6
	i32.const	$push18=, 0
	i32.const	$push16=, 16
	i32.add 	$push17=, $11, $pop16
	i32.store	__stack_pointer($pop18), $pop17
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	debug, .Lfunc_end0-debug
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
	i64.const	$push0=, 20014547621496
	i64.store	8($0), $pop0
	i32.const	$push1=, 10
	i32.store	0($0), $pop1
	call    	debug@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
