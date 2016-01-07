	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr15262.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1084647014
	i32.store	$discard=, 0($0), $pop0
	return
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$5=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	i32.const	$6=, 8
	i32.add 	$6=, $5, $6
	i32.const	$7=, 12
	i32.add 	$7=, $5, $7
	i32.select	$push0=, $1, $6, $7
	i32.const	$push1=, 1084647014
	i32.store	$discard=, 0($pop0), $pop1
	i32.const	$push2=, 1
	i32.store	$push3=, 4($0), $pop2
	i32.const	$5=, 16
	i32.add 	$5=, $5, $5
	i32.const	$5=, __stack_pointer
	i32.store	$5=, 0($5), $5
	return  	$pop3
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
