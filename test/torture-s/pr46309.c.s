	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr46309.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.load	$push12=, 0($0)
	tee_local	$push11=, $0=, $pop12
	i32.const	$push0=, -2
	i32.and 	$push1=, $pop11, $pop0
	i32.const	$push2=, 2
	i32.eq  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %if.then
	i32.const	$push9=, 1
	i32.ne  	$push10=, $0, $pop9
	br_if   	0, $pop10       # 0: down to label1
# BB#2:                                 # %if.then
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

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push26=, $pop5, $pop6
	tee_local	$push25=, $0=, $pop26
	i32.store	__stack_pointer($pop7), $pop25
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
	i32.const	$push2=, 1
	i32.store	8($0), $pop2
	i32.const	$push3=, 0
	i32.const	$push15=, 8
	i32.add 	$push16=, $0, $pop15
	i32.store	q($pop3), $pop16
	i32.const	$push24=, 0
	i32.store	12($0), $pop24
	i32.const	$push17=, 12
	i32.add 	$push18=, $0, $pop17
	call    	bar@FUNCTION, $pop18
	i32.const	$push23=, 0
	i32.store	8($0), $pop23
	i32.const	$push22=, 1
	i32.store	12($0), $pop22
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

	.hidden	q                       # @q
	.type	q,@object
	.section	.bss.q,"aw",@nobits
	.globl	q
	.p2align	2
q:
	.int32	0
	.size	q, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
