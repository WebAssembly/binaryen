	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr27073.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	.LBB0_3
	i32.const	$push0=, 65535
	i32.and 	$push1=, $4, $pop0
	i32.const	$push13=, 0
	i32.eq  	$push14=, $pop1, $pop13
	br_if   	$pop14, .LBB0_3
# BB#1:                                 # %while.body.preheader
	i32.const	$push2=, 0
	i32.sub 	$4=, $pop2, $4
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_3
	i32.store	$discard=, 0($0), $5
	i32.const	$push3=, 4
	i32.add 	$push4=, $0, $pop3
	i32.store	$discard=, 0($pop4), $6
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i32.store	$discard=, 0($pop6), $7
	i32.const	$push7=, 12
	i32.add 	$push8=, $0, $pop7
	i32.store	$discard=, 0($pop8), $8
	i32.const	$push9=, 16
	i32.add 	$push10=, $0, $pop9
	i32.store	$discard=, 0($pop10), $9
	i32.const	$push11=, 1
	i32.add 	$4=, $4, $pop11
	i32.const	$push12=, 20
	i32.add 	$0=, $0, $pop12
	br_if   	$4, .LBB0_2
.LBB0_3:                                # %while.end
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 48
	i32.sub 	$11=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$11=, 0($6), $11
	i32.const	$0=, 500
	i32.const	$1=, 400
	i32.const	$2=, 300
	i32.const	$3=, 200
	i32.const	$4=, 100
	i32.const	$push0=, 2
	i32.const	$7=, 0
	i32.add 	$7=, $11, $7
	block   	.LBB1_11
	call    	foo, $7, $4, $4, $4, $pop0, $4, $3, $2, $1, $0
	i32.load	$push1=, 0($11)
	i32.ne  	$push2=, $pop1, $4
	br_if   	$pop2, .LBB1_11
# BB#1:                                 # %for.cond
	i32.const	$push3=, 4
	i32.const	$8=, 0
	i32.add 	$8=, $11, $8
	i32.or  	$push4=, $8, $pop3
	i32.load	$push5=, 0($pop4)
	i32.ne  	$push6=, $pop5, $3
	br_if   	$pop6, .LBB1_11
# BB#2:                                 # %for.cond.1
	i32.const	$push7=, 8
	i32.const	$9=, 0
	i32.add 	$9=, $11, $9
	i32.or  	$push8=, $9, $pop7
	i32.load	$push9=, 0($pop8)
	i32.ne  	$push10=, $pop9, $2
	br_if   	$pop10, .LBB1_11
# BB#3:                                 # %for.cond.2
	i32.const	$push11=, 12
	i32.const	$10=, 0
	i32.add 	$10=, $11, $10
	i32.or  	$push12=, $10, $pop11
	i32.load	$push13=, 0($pop12)
	i32.ne  	$push14=, $pop13, $1
	br_if   	$pop14, .LBB1_11
# BB#4:                                 # %for.cond.3
	i32.load	$push15=, 16($11)
	i32.ne  	$push16=, $pop15, $0
	br_if   	$pop16, .LBB1_11
# BB#5:                                 # %for.cond.4
	i32.load	$push17=, 20($11)
	i32.ne  	$push18=, $pop17, $4
	br_if   	$pop18, .LBB1_11
# BB#6:                                 # %for.cond.5
	i32.load	$push19=, 24($11)
	i32.ne  	$push20=, $pop19, $3
	br_if   	$pop20, .LBB1_11
# BB#7:                                 # %for.cond.6
	i32.load	$push21=, 28($11)
	i32.ne  	$push22=, $pop21, $2
	br_if   	$pop22, .LBB1_11
# BB#8:                                 # %for.cond.7
	i32.load	$push23=, 32($11)
	i32.ne  	$push24=, $pop23, $1
	br_if   	$pop24, .LBB1_11
# BB#9:                                 # %for.cond.8
	i32.load	$push25=, 36($11)
	i32.ne  	$push26=, $pop25, $0
	br_if   	$pop26, .LBB1_11
# BB#10:                                # %for.cond.9
	i32.const	$push27=, 0
	call    	exit, $pop27
	unreachable
.LBB1_11:                               # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
