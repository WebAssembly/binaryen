	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr38236.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$6=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	i32.const	$7=, 12
	i32.add 	$7=, $6, $7
	i32.const	$8=, 8
	i32.add 	$8=, $6, $8
	i32.select	$push1=, $3, $7, $8
	i32.const	$push2=, 1
	i32.store	$discard=, 0($pop1), $pop2
	i32.const	$9=, 12
	i32.add 	$9=, $6, $9
	i32.select	$push0=, $2, $9, $0
	i32.load	$push3=, 0($pop0)
	i32.const	$6=, 16
	i32.add 	$6=, $6, $6
	i32.const	$6=, __stack_pointer
	i32.store	$6=, 0($6), $6
	return  	$pop3
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 1
	i32.const	$1=, 0
	block   	.LBB1_2
	i32.call	$push0=, foo@FUNCTION, $1, $0, $0, $0
	i32.ne  	$push1=, $pop0, $0
	br_if   	$pop1, .LBB1_2
# BB#1:                                 # %if.end
	return  	$1
.LBB1_2:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
