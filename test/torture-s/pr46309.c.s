	.text
	.file	"pr46309.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# %bb.0:                                # %entry
	i32.load	$0=, 0($0)
	block   	
	block   	
	i32.const	$push0=, -2
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 2
	i32.eq  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# %bb.1:                                # %if.then
	i32.const	$push9=, 1
	i32.ne  	$push10=, $0, $pop9
	br_if   	0, $pop10       # 0: down to label1
# %bb.2:                                # %if.then
	i32.const	$push5=, 0
	i32.load	$push6=, q($pop5)
	i32.load	$push7=, 0($pop6)
	i32.const	$push8=, 263
	i32.and 	$push4=, $pop7, $pop8
	br_if   	1, $pop4        # 1: down to label0
.LBB0_3:                                # %if.end
	end_block                       # label1:
	return
.LBB0_4:                                # %cond.true
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$0=, $pop4, $pop6
	i32.const	$push7=, 0
	i32.store	__stack_pointer($pop7), $0
	#APP
	#NO_APP
	i32.const	$push0=, 2
	i32.store	12($0), $pop0
	i32.const	$push11=, 12
	i32.add 	$push12=, $0, $pop11
	call    	bar@FUNCTION, $pop12
	i32.const	$push1=, 3
	i32.store	12($0), $pop1
	i32.const	$push13=, 12
	i32.add 	$push14=, $0, $pop13
	call    	bar@FUNCTION, $pop14
	i32.const	$push2=, 0
	i32.store	12($0), $pop2
	i32.const	$push3=, 1
	i32.store	8($0), $pop3
	i32.const	$push24=, 0
	i32.const	$push15=, 8
	i32.add 	$push16=, $0, $pop15
	i32.store	q($pop24), $pop16
	i32.const	$push17=, 12
	i32.add 	$push18=, $0, $pop17
	call    	bar@FUNCTION, $pop18
	i32.const	$push23=, 1
	i32.store	12($0), $pop23
	i32.const	$push22=, 0
	i32.store	8($0), $pop22
	i32.const	$push19=, 12
	i32.add 	$push20=, $0, $pop19
	call    	bar@FUNCTION, $pop20
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	i32.const	$push21=, 0
                                        # fallthrough-return: $pop21
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	q                       # @q
	.type	q,@object
	.section	.bss.q,"aw",@nobits
	.globl	q
	.p2align	2
q:
	.int32	0
	.size	q, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
