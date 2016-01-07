	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr54985.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	copy_local	$2=, $3
	block   	.LBB0_4
	i32.const	$push1=, 0
	i32.eq  	$push2=, $1, $pop1
	br_if   	$pop2, .LBB0_4
# BB#1:                                 # %while.body.preheader
	i32.load	$6=, 0($0)
	i32.const	$4=, 4
	i32.add 	$0=, $0, $4
.LBB0_2:                                  # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_4
	i32.const	$push0=, -1
	i32.add 	$1=, $1, $pop0
	copy_local	$2=, $3
	i32.const	$push3=, 0
	i32.eq  	$push4=, $1, $pop3
	br_if   	$pop4, .LBB0_4
# BB#3:                                 # %while.cond.while.body_crit_edge
                                        #   in Loop: Header=.LBB0_2 Depth=1
	i32.load	$2=, 0($0)
	i32.add 	$0=, $0, $4
	i32.lt_s	$5=, $2, $6
	copy_local	$6=, $2
	i32.const	$2=, 1
	br_if   	$5, .LBB0_2
.LBB0_4:                                  # %cleanup
	return  	$2
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$4=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$4=, 0($1), $4
	i64.const	$push0=, 4294967298
	i64.store	$discard=, 8($4), $pop0
	i32.const	$push1=, 2
	i32.const	$3=, 8
	i32.add 	$3=, $4, $3
	block   	.LBB1_2
	i32.call	$push2=, foo, $3, $pop1
	br_if   	$pop2, .LBB1_2
# BB#1:                                 # %if.end
	i32.const	$push3=, 0
	i32.const	$2=, 16
	i32.add 	$4=, $4, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	return  	$pop3
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
