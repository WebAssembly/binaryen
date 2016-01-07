	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr46909-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 6
	i32.const	$2=, 1
	i32.const	$push3=, 4
	i32.or  	$push4=, $0, $pop3
	i32.eq  	$push5=, $pop4, $1
	i32.const	$push0=, 2
	i32.or  	$push1=, $0, $pop0
	i32.ne  	$push2=, $pop1, $1
	i32.const	$push6=, -1
	i32.select	$push7=, $pop2, $2, $pop6
	i32.select	$push8=, $pop5, $2, $pop7
	return  	$pop8
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, -14
.LBB1_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	.LBB1_4
	loop    	.LBB1_3
	i32.const	$push0=, 4
	i32.add 	$push1=, $3, $pop0
	i32.call	$0=, foo, $pop1
	i32.const	$1=, 0
	i32.const	$2=, 1
	i32.eq  	$push2=, $3, $1
	i32.shl 	$push3=, $pop2, $2
	i32.sub 	$push4=, $2, $pop3
	i32.ne  	$push5=, $0, $pop4
	br_if   	$pop5, .LBB1_4
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=.LBB1_1 Depth=1
	i32.const	$push6=, 5
	i32.add 	$0=, $3, $pop6
	i32.add 	$3=, $3, $2
	i32.const	$push7=, 9
	i32.le_s	$push8=, $0, $pop7
	br_if   	$pop8, .LBB1_1
.LBB1_3:                                  # %for.end
	return  	$1
.LBB1_4:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
