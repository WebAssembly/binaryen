	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/eeprof-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.const	$push0=, 0
	i32.load	$push1=, last_fn_entered($pop0)
	i32.const	$push2=, foo
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB0_2
# BB#1:                                 # %if.end
	return
.LBB0_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	nfoo
	.type	nfoo,@function
nfoo:                                   # @nfoo
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, 2
	block   	.LBB1_14
	i32.load	$push1=, entry_calls($0)
	i32.ne  	$push2=, $pop1, $1
	br_if   	$pop2, .LBB1_14
# BB#1:                                 # %entry
	i32.load	$push0=, exit_calls($0)
	i32.ne  	$push3=, $pop0, $1
	br_if   	$pop3, .LBB1_14
# BB#2:                                 # %if.end
	i32.const	$1=, foo
	block   	.LBB1_13
	i32.load	$push4=, last_fn_entered($0)
	i32.ne  	$push5=, $pop4, $1
	br_if   	$pop5, .LBB1_13
# BB#3:                                 # %if.end4
	block   	.LBB1_12
	i32.load	$push6=, last_fn_exited($0)
	i32.const	$push7=, foo2
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, .LBB1_12
# BB#4:                                 # %if.end7
	call    	foo
	i32.const	$2=, 3
	block   	.LBB1_11
	i32.load	$push10=, entry_calls($0)
	i32.ne  	$push11=, $pop10, $2
	br_if   	$pop11, .LBB1_11
# BB#5:                                 # %if.end7
	i32.load	$push9=, exit_calls($0)
	i32.ne  	$push12=, $pop9, $2
	br_if   	$pop12, .LBB1_11
# BB#6:                                 # %if.end12
	block   	.LBB1_10
	i32.load	$push13=, last_fn_entered($0)
	i32.ne  	$push14=, $pop13, $1
	br_if   	$pop14, .LBB1_10
# BB#7:                                 # %if.end15
	block   	.LBB1_9
	i32.load	$push15=, last_fn_exited($0)
	i32.ne  	$push16=, $pop15, $1
	br_if   	$pop16, .LBB1_9
# BB#8:                                 # %if.end18
	return
.LBB1_9:                                  # %if.then17
	call    	abort
	unreachable
.LBB1_10:                                 # %if.then14
	call    	abort
	unreachable
.LBB1_11:                                 # %if.then11
	call    	abort
	unreachable
.LBB1_12:                                 # %if.then6
	call    	abort
	unreachable
.LBB1_13:                                 # %if.then3
	call    	abort
	unreachable
.LBB1_14:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	nfoo, .Lfunc_end1-nfoo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB2_14
	i32.load	$push1=, exit_calls($0)
	i32.load	$push0=, entry_calls($0)
	i32.or  	$push2=, $pop1, $pop0
	br_if   	$pop2, .LBB2_14
# BB#1:                                 # %if.end
	call    	foo2
	i32.const	$1=, 2
	block   	.LBB2_13
	i32.load	$push4=, entry_calls($0)
	i32.ne  	$push5=, $pop4, $1
	br_if   	$pop5, .LBB2_13
# BB#2:                                 # %if.end
	i32.load	$push3=, exit_calls($0)
	i32.ne  	$push6=, $pop3, $1
	br_if   	$pop6, .LBB2_13
# BB#3:                                 # %if.end6
	i32.const	$1=, foo
	block   	.LBB2_12
	i32.load	$push7=, last_fn_entered($0)
	i32.ne  	$push8=, $pop7, $1
	br_if   	$pop8, .LBB2_12
# BB#4:                                 # %if.end9
	block   	.LBB2_11
	i32.load	$push9=, last_fn_exited($0)
	i32.const	$push10=, foo2
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	$pop11, .LBB2_11
# BB#5:                                 # %if.end12
	call    	nfoo
	i32.const	$2=, 3
	block   	.LBB2_10
	i32.load	$push13=, entry_calls($0)
	i32.ne  	$push14=, $pop13, $2
	br_if   	$pop14, .LBB2_10
# BB#6:                                 # %if.end12
	i32.load	$push12=, exit_calls($0)
	i32.ne  	$push15=, $pop12, $2
	br_if   	$pop15, .LBB2_10
# BB#7:                                 # %if.end17
	block   	.LBB2_9
	i32.load	$push16=, last_fn_entered($0)
	i32.ne  	$push17=, $pop16, $1
	br_if   	$pop17, .LBB2_9
# BB#8:                                 # %if.end20
	return  	$0
.LBB2_9:                                  # %if.then19
	call    	abort
	unreachable
.LBB2_10:                                 # %if.then16
	call    	abort
	unreachable
.LBB2_11:                                 # %if.then11
	call    	abort
	unreachable
.LBB2_12:                                 # %if.then8
	call    	abort
	unreachable
.LBB2_13:                                 # %if.then5
	call    	abort
	unreachable
.LBB2_14:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.globl	__cyg_profile_func_enter
	.type	__cyg_profile_func_enter,@function
__cyg_profile_func_enter:               # @__cyg_profile_func_enter
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.load	$push0=, entry_calls($2)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, entry_calls($2), $pop2
	i32.store	$discard=, last_fn_entered($2), $0
	return
.Lfunc_end3:
	.size	__cyg_profile_func_enter, .Lfunc_end3-__cyg_profile_func_enter

	.globl	__cyg_profile_func_exit
	.type	__cyg_profile_func_exit,@function
__cyg_profile_func_exit:                # @__cyg_profile_func_exit
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.load	$push0=, exit_calls($2)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, exit_calls($2), $pop2
	i32.store	$discard=, last_fn_exited($2), $0
	return
.Lfunc_end4:
	.size	__cyg_profile_func_exit, .Lfunc_end4-__cyg_profile_func_exit

	.type	foo2,@function
foo2:                                   # @foo2
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, 1
	block   	.LBB5_12
	i32.load	$push1=, entry_calls($0)
	i32.ne  	$push2=, $pop1, $1
	br_if   	$pop2, .LBB5_12
# BB#1:                                 # %entry
	i32.load	$push0=, exit_calls($0)
	br_if   	$pop0, .LBB5_12
# BB#2:                                 # %if.end
	block   	.LBB5_11
	i32.load	$push3=, last_fn_entered($0)
	i32.const	$push4=, foo2
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, .LBB5_11
# BB#3:                                 # %if.end4
	call    	foo
	block   	.LBB5_10
	i32.load	$push7=, entry_calls($0)
	i32.const	$push8=, 2
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, .LBB5_10
# BB#4:                                 # %if.end4
	i32.load	$push6=, exit_calls($0)
	i32.ne  	$push10=, $pop6, $1
	br_if   	$pop10, .LBB5_10
# BB#5:                                 # %if.end9
	i32.const	$1=, foo
	block   	.LBB5_9
	i32.load	$push11=, last_fn_entered($0)
	i32.ne  	$push12=, $pop11, $1
	br_if   	$pop12, .LBB5_9
# BB#6:                                 # %if.end12
	block   	.LBB5_8
	i32.load	$push13=, last_fn_exited($0)
	i32.ne  	$push14=, $pop13, $1
	br_if   	$pop14, .LBB5_8
# BB#7:                                 # %if.end15
	return
.LBB5_8:                                  # %if.then14
	call    	abort
	unreachable
.LBB5_9:                                  # %if.then11
	call    	abort
	unreachable
.LBB5_10:                                 # %if.then8
	call    	abort
	unreachable
.LBB5_11:                                 # %if.then3
	call    	abort
	unreachable
.LBB5_12:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end5:
	.size	foo2, .Lfunc_end5-foo2

	.type	last_fn_entered,@object # @last_fn_entered
	.bss
	.globl	last_fn_entered
	.align	2
last_fn_entered:
	.int32	0
	.size	last_fn_entered, 4

	.type	entry_calls,@object     # @entry_calls
	.globl	entry_calls
	.align	2
entry_calls:
	.int32	0                       # 0x0
	.size	entry_calls, 4

	.type	exit_calls,@object      # @exit_calls
	.globl	exit_calls
	.align	2
exit_calls:
	.int32	0                       # 0x0
	.size	exit_calls, 4

	.type	last_fn_exited,@object  # @last_fn_exited
	.globl	last_fn_exited
	.align	2
last_fn_exited:
	.int32	0
	.size	last_fn_exited, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
