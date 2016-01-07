	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020129-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.load	$4=, 28($1)
	block   	.LBB0_5
	block   	.LBB0_3
	i32.load	$push0=, 28($0)
	i32.const	$push11=, 0
	i32.eq  	$push12=, $pop0, $pop11
	br_if   	$pop12, .LBB0_3
# BB#1:                                 # %if.end
	i32.const	$push13=, 0
	i32.eq  	$push14=, $4, $pop13
	br_if   	$pop14, .LBB0_5
# BB#2:                                 # %if.then6
	call    	abort
	unreachable
.LBB0_3:                                  # %if.then
	i32.const	$2=, 28
	i32.add 	$push1=, $0, $2
	i32.store	$discard=, 0($pop1), $4
	i32.add 	$push2=, $1, $2
	i32.const	$push3=, 0
	i32.store	$discard=, 0($pop2), $pop3
	i32.const	$push15=, 0
	i32.eq  	$push16=, $4, $pop15
	br_if   	$pop16, .LBB0_5
.LBB0_4:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_5
	i32.store	$discard=, 4($4), $0
	i32.load	$4=, 0($4)
	br_if   	$4, .LBB0_4
.LBB0_5:                                  # %if.end7
	i32.load	$2=, 12($1)
	i32.const	$4=, -1
	block   	.LBB0_9
	block   	.LBB0_8
	i32.load	$push4=, 12($0)
	i32.eq  	$push5=, $pop4, $4
	br_if   	$pop5, .LBB0_8
# BB#6:                                 # %if.end22
	i32.eq  	$push6=, $2, $4
	br_if   	$pop6, .LBB0_9
# BB#7:                                 # %if.then26
	call    	abort
	unreachable
.LBB0_8:                                  # %if.end22.thread
	i32.const	$3=, 12
	i32.add 	$push7=, $0, $3
	i32.store	$discard=, 0($pop7), $2
	i32.load	$push8=, 16($1)
	i32.store	$discard=, 16($0), $pop8
	i32.add 	$push9=, $1, $3
	i32.store	$discard=, 0($pop9), $4
	i32.const	$push10=, 0
	i32.store	$discard=, 16($1), $pop10
.LBB0_9:                                  # %if.end27
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$push0=, 6
	i32.store	$discard=, y($1), $pop0
	i32.const	$push1=, 145
	i32.store	$2=, y+12($1), $pop1
	i32.load	$5=, x+28($1)
	i32.load	$0=, y+28($1)
	block   	.LBB1_5
	block   	.LBB1_3
	i32.const	$push2=, 2448
	i32.store	$3=, y+16($1), $pop2
	i32.const	$push3=, -1
	i32.store	$4=, x+12($1), $pop3
	br_if   	$5, .LBB1_3
# BB#1:                                 # %if.then.i
	i32.store	$5=, x+28($1), $0
	i32.store	$discard=, y+28($1), $1
	i32.const	$push6=, 0
	i32.eq  	$push7=, $5, $pop6
	br_if   	$pop7, .LBB1_5
.LBB1_2:                                  # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_3
	i32.const	$push4=, x
	i32.store	$discard=, 4($5), $pop4
	i32.load	$5=, 0($5)
	br_if   	$5, .LBB1_2
	br      	.LBB1_5
.LBB1_3:                                  # %if.end.i
	i32.const	$push8=, 0
	i32.eq  	$push9=, $0, $pop8
	br_if   	$pop9, .LBB1_5
# BB#4:                                 # %if.then6.i
	call    	abort
	unreachable
.LBB1_5:                                  # %foo.exit
	i32.store	$discard=, x+12($1), $2
	i32.store	$discard=, x+16($1), $3
	i32.store	$discard=, y+12($1), $4
	i32.store	$push5=, y+16($1), $1
	call    	exit, $pop5
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	y,@object               # @y
	.bss
	.globl	y
	.align	2
y:
	.zero	32
	.size	y, 32

	.type	x,@object               # @x
	.globl	x
	.align	2
x:
	.zero	32
	.size	x, 32


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
