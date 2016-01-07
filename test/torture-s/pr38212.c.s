	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr38212.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.shl 	$push1=, $1, $pop0
	i32.sub 	$push2=, $0, $pop1
	i32.const	$push3=, 4
	i32.add 	$1=, $pop2, $pop3
	i32.load	$2=, 0($1)
	i32.const	$push4=, 1
	i32.store	$discard=, 0($0), $pop4
	i32.load	$push5=, 0($1)
	i32.add 	$push6=, $pop5, $2
	return  	$pop6
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$6=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$6=, 0($3), $6
	i32.const	$1=, 1
	i32.const	$push0=, 0
	i32.store	$0=, 12($6), $pop0
	i32.const	$5=, 12
	i32.add 	$5=, $6, $5
	block   	.LBB1_2
	i32.call	$push1=, foo, $5, $1
	i32.ne  	$push2=, $pop1, $1
	br_if   	$pop2, .LBB1_2
# BB#1:                                 # %if.end
	i32.const	$4=, 16
	i32.add 	$6=, $6, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	return  	$0
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
