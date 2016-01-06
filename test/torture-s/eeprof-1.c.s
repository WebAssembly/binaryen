	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/eeprof-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	block   	BB0_2
	i32.const	$push0=, 0
	i32.load	$push1=, last_fn_entered($pop0)
	i32.const	$push2=, foo
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, BB0_2
# BB#1:                                 # %if.end
	return
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	foo, func_end0-foo

	.globl	nfoo
	.type	nfoo,@function
nfoo:                                   # @nfoo
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, 2
	block   	BB1_14
	i32.load	$push1=, entry_calls($0)
	i32.ne  	$push2=, $pop1, $1
	br_if   	$pop2, BB1_14
# BB#1:                                 # %entry
	i32.load	$push0=, exit_calls($0)
	i32.ne  	$push3=, $pop0, $1
	br_if   	$pop3, BB1_14
# BB#2:                                 # %if.end
	i32.const	$1=, foo
	block   	BB1_13
	i32.load	$push4=, last_fn_entered($0)
	i32.ne  	$push5=, $pop4, $1
	br_if   	$pop5, BB1_13
# BB#3:                                 # %if.end4
	block   	BB1_12
	i32.load	$push6=, last_fn_exited($0)
	i32.const	$push7=, foo2
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, BB1_12
# BB#4:                                 # %if.end7
	call    	foo
	i32.const	$2=, 3
	block   	BB1_11
	i32.load	$push10=, entry_calls($0)
	i32.ne  	$push11=, $pop10, $2
	br_if   	$pop11, BB1_11
# BB#5:                                 # %if.end7
	i32.load	$push9=, exit_calls($0)
	i32.ne  	$push12=, $pop9, $2
	br_if   	$pop12, BB1_11
# BB#6:                                 # %if.end12
	block   	BB1_10
	i32.load	$push13=, last_fn_entered($0)
	i32.ne  	$push14=, $pop13, $1
	br_if   	$pop14, BB1_10
# BB#7:                                 # %if.end15
	block   	BB1_9
	i32.load	$push15=, last_fn_exited($0)
	i32.ne  	$push16=, $pop15, $1
	br_if   	$pop16, BB1_9
# BB#8:                                 # %if.end18
	return
BB1_9:                                  # %if.then17
	call    	abort
	unreachable
BB1_10:                                 # %if.then14
	call    	abort
	unreachable
BB1_11:                                 # %if.then11
	call    	abort
	unreachable
BB1_12:                                 # %if.then6
	call    	abort
	unreachable
BB1_13:                                 # %if.then3
	call    	abort
	unreachable
BB1_14:                                 # %if.then
	call    	abort
	unreachable
func_end1:
	.size	nfoo, func_end1-nfoo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB2_14
	i32.load	$push1=, exit_calls($0)
	i32.load	$push0=, entry_calls($0)
	i32.or  	$push2=, $pop1, $pop0
	br_if   	$pop2, BB2_14
# BB#1:                                 # %if.end
	call    	foo2
	i32.const	$1=, 2
	block   	BB2_13
	i32.load	$push4=, entry_calls($0)
	i32.ne  	$push5=, $pop4, $1
	br_if   	$pop5, BB2_13
# BB#2:                                 # %if.end
	i32.load	$push3=, exit_calls($0)
	i32.ne  	$push6=, $pop3, $1
	br_if   	$pop6, BB2_13
# BB#3:                                 # %if.end6
	i32.const	$1=, foo
	block   	BB2_12
	i32.load	$push7=, last_fn_entered($0)
	i32.ne  	$push8=, $pop7, $1
	br_if   	$pop8, BB2_12
# BB#4:                                 # %if.end9
	block   	BB2_11
	i32.load	$push9=, last_fn_exited($0)
	i32.const	$push10=, foo2
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	$pop11, BB2_11
# BB#5:                                 # %if.end12
	call    	nfoo
	i32.const	$2=, 3
	block   	BB2_10
	i32.load	$push13=, entry_calls($0)
	i32.ne  	$push14=, $pop13, $2
	br_if   	$pop14, BB2_10
# BB#6:                                 # %if.end12
	i32.load	$push12=, exit_calls($0)
	i32.ne  	$push15=, $pop12, $2
	br_if   	$pop15, BB2_10
# BB#7:                                 # %if.end17
	block   	BB2_9
	i32.load	$push16=, last_fn_entered($0)
	i32.ne  	$push17=, $pop16, $1
	br_if   	$pop17, BB2_9
# BB#8:                                 # %if.end20
	return  	$0
BB2_9:                                  # %if.then19
	call    	abort
	unreachable
BB2_10:                                 # %if.then16
	call    	abort
	unreachable
BB2_11:                                 # %if.then11
	call    	abort
	unreachable
BB2_12:                                 # %if.then8
	call    	abort
	unreachable
BB2_13:                                 # %if.then5
	call    	abort
	unreachable
BB2_14:                                 # %if.then
	call    	abort
	unreachable
func_end2:
	.size	main, func_end2-main

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
func_end3:
	.size	__cyg_profile_func_enter, func_end3-__cyg_profile_func_enter

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
func_end4:
	.size	__cyg_profile_func_exit, func_end4-__cyg_profile_func_exit

	.type	foo2,@function
foo2:                                   # @foo2
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, 1
	block   	BB5_12
	i32.load	$push1=, entry_calls($0)
	i32.ne  	$push2=, $pop1, $1
	br_if   	$pop2, BB5_12
# BB#1:                                 # %entry
	i32.load	$push0=, exit_calls($0)
	br_if   	$pop0, BB5_12
# BB#2:                                 # %if.end
	block   	BB5_11
	i32.load	$push3=, last_fn_entered($0)
	i32.const	$push4=, foo2
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, BB5_11
# BB#3:                                 # %if.end4
	call    	foo
	block   	BB5_10
	i32.load	$push7=, entry_calls($0)
	i32.const	$push8=, 2
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, BB5_10
# BB#4:                                 # %if.end4
	i32.load	$push6=, exit_calls($0)
	i32.ne  	$push10=, $pop6, $1
	br_if   	$pop10, BB5_10
# BB#5:                                 # %if.end9
	i32.const	$1=, foo
	block   	BB5_9
	i32.load	$push11=, last_fn_entered($0)
	i32.ne  	$push12=, $pop11, $1
	br_if   	$pop12, BB5_9
# BB#6:                                 # %if.end12
	block   	BB5_8
	i32.load	$push13=, last_fn_exited($0)
	i32.ne  	$push14=, $pop13, $1
	br_if   	$pop14, BB5_8
# BB#7:                                 # %if.end15
	return
BB5_8:                                  # %if.then14
	call    	abort
	unreachable
BB5_9:                                  # %if.then11
	call    	abort
	unreachable
BB5_10:                                 # %if.then8
	call    	abort
	unreachable
BB5_11:                                 # %if.then3
	call    	abort
	unreachable
BB5_12:                                 # %if.then
	call    	abort
	unreachable
func_end5:
	.size	foo2, func_end5-foo2

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
