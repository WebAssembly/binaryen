	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/usmul.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.mul 	$push0=, $1, $0
	return  	$pop0
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.mul 	$push0=, $1, $0
	return  	$pop0
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 65535
	i32.const	$1=, -2
	i32.call	$2=, foo, $1, $0
	i32.const	$3=, -131070
	block   	.LBB2_16
	i32.ne  	$push0=, $2, $3
	br_if   	$pop0, .LBB2_16
# BB#1:                                 # %if.end
	i32.const	$2=, 2
	i32.call	$4=, foo, $2, $0
	i32.const	$5=, 131070
	block   	.LBB2_15
	i32.ne  	$push1=, $4, $5
	br_if   	$pop1, .LBB2_15
# BB#2:                                 # %if.end4
	i32.const	$4=, 32768
	i32.const	$6=, -32768
	i32.call	$7=, foo, $6, $4
	i32.const	$8=, -1073741824
	block   	.LBB2_14
	i32.ne  	$push2=, $7, $8
	br_if   	$pop2, .LBB2_14
# BB#3:                                 # %if.end8
	i32.const	$7=, 32767
	i32.call	$9=, foo, $7, $4
	i32.const	$10=, 1073709056
	block   	.LBB2_13
	i32.ne  	$push3=, $9, $10
	br_if   	$pop3, .LBB2_13
# BB#4:                                 # %if.end12
	block   	.LBB2_12
	i32.call	$push4=, bar, $0, $1
	i32.ne  	$push5=, $pop4, $3
	br_if   	$pop5, .LBB2_12
# BB#5:                                 # %if.end16
	block   	.LBB2_11
	i32.call	$push6=, bar, $0, $2
	i32.ne  	$push7=, $pop6, $5
	br_if   	$pop7, .LBB2_11
# BB#6:                                 # %if.end20
	block   	.LBB2_10
	i32.call	$push8=, bar, $4, $6
	i32.ne  	$push9=, $pop8, $8
	br_if   	$pop9, .LBB2_10
# BB#7:                                 # %if.end24
	block   	.LBB2_9
	i32.call	$push10=, bar, $4, $7
	i32.ne  	$push11=, $pop10, $10
	br_if   	$pop11, .LBB2_9
# BB#8:                                 # %if.end28
	i32.const	$push12=, 0
	call    	exit, $pop12
	unreachable
.LBB2_9:                                  # %if.then27
	call    	abort
	unreachable
.LBB2_10:                                 # %if.then23
	call    	abort
	unreachable
.LBB2_11:                                 # %if.then19
	call    	abort
	unreachable
.LBB2_12:                                 # %if.then15
	call    	abort
	unreachable
.LBB2_13:                                 # %if.then11
	call    	abort
	unreachable
.LBB2_14:                                 # %if.then7
	call    	abort
	unreachable
.LBB2_15:                                 # %if.then3
	call    	abort
	unreachable
.LBB2_16:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
