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
	i32.load	$push0=, 0($0)
	tee_local	$push12=, $0=, $pop0
	i32.const	$push1=, -2
	i32.and 	$push2=, $pop12, $pop1
	i32.const	$push3=, 2
	i32.eq  	$push4=, $pop2, $pop3
	br_if   	$pop4, 0        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push10=, 1
	i32.ne  	$push11=, $0, $pop10
	br_if   	$pop11, 0       # 0: down to label0
# BB#2:                                 # %if.then
	i32.const	$push6=, 0
	i32.load	$push7=, q($pop6)
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 263
	i32.and 	$push5=, $pop8, $pop9
	i32.const	$push13=, 0
	i32.eq  	$push14=, $pop5, $pop13
	br_if   	$pop14, 0       # 0: down to label0
# BB#3:                                 # %cond.true
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %if.end
	end_block                       # label0:
	return
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
	i32.store	$push4=, 12($10), $pop3
	tee_local	$push5=, $1=, $pop4
	i32.const	$7=, 8
	i32.add 	$7=, $10, $7
	i32.store	$discard=, q($pop5), $7
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
