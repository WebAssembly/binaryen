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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$10=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$10=, 0($3), $10
	#APP
	#NO_APP
	i32.const	$push0=, 2
	i32.store	$discard=, 12($10), $pop0
	i32.const	$5=, 12
	i32.add 	$5=, $10, $5
	call    	bar@FUNCTION, $5
	i32.const	$push1=, 3
	i32.store	$discard=, 12($10), $pop1
	i32.const	$6=, 12
	i32.add 	$6=, $10, $6
	call    	bar@FUNCTION, $6
	i32.const	$push2=, 1
	i32.store	$0=, 8($10), $pop2
	i32.const	$push3=, 0
	i32.store	$push5=, 12($10), $pop3
	tee_local	$push4=, $1=, $pop5
	i32.const	$7=, 8
	i32.add 	$7=, $10, $7
	i32.store	$discard=, q($pop4), $7
	i32.const	$8=, 12
	i32.add 	$8=, $10, $8
	call    	bar@FUNCTION, $8
	i32.store	$discard=, 12($10), $0
	i32.store	$0=, 8($10), $1
	i32.const	$9=, 12
	i32.add 	$9=, $10, $9
	call    	bar@FUNCTION, $9
	i32.const	$4=, 16
	i32.add 	$10=, $10, $4
	i32.const	$4=, __stack_pointer
	i32.store	$10=, 0($4), $10
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
