	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr46309.c"
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push6=, __stack_pointer
	i32.load	$push7=, 0($pop6)
	i32.const	$push8=, 16
	i32.sub 	$2=, $pop7, $pop8
	i32.const	$push9=, __stack_pointer
	i32.store	$discard=, 0($pop9), $2
	#APP
	#NO_APP
	i32.const	$push0=, 2
	i32.store	$discard=, 12($2), $pop0
	i32.const	$push13=, 12
	i32.add 	$push14=, $2, $pop13
	call    	bar@FUNCTION, $pop14
	i32.const	$push1=, 3
	i32.store	$discard=, 12($2), $pop1
	i32.const	$push15=, 12
	i32.add 	$push16=, $2, $pop15
	call    	bar@FUNCTION, $pop16
	i32.const	$push2=, 1
	i32.store	$0=, 8($2), $pop2
	i32.const	$push3=, 0
	i32.store	$push5=, 12($2), $pop3
	tee_local	$push4=, $1=, $pop5
	i32.const	$push17=, 8
	i32.add 	$push18=, $2, $pop17
	i32.store	$discard=, q($pop4), $pop18
	i32.const	$push19=, 12
	i32.add 	$push20=, $2, $pop19
	call    	bar@FUNCTION, $pop20
	i32.store	$discard=, 12($2), $0
	i32.store	$0=, 8($2), $1
	i32.const	$push21=, 12
	i32.add 	$push22=, $2, $pop21
	call    	bar@FUNCTION, $pop22
	i32.const	$push12=, __stack_pointer
	i32.const	$push10=, 16
	i32.add 	$push11=, $2, $pop10
	i32.store	$discard=, 0($pop12), $pop11
	return  	$0
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


	.ident	"clang version 3.9.0 "
