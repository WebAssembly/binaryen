	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/struct-aliasing-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$2=, 0($1)
	i32.const	$push0=, 0
	i32.store	$discard=, 0($0), $pop0
	i32.load	$push1=, 0($1)
	i32.add 	$push2=, $pop1, $2
	return  	$pop2
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$5=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$5=, 0($1), $5
	i32.const	$3=, 12
	i32.add 	$3=, $5, $3
	i32.const	$4=, 12
	i32.add 	$4=, $5, $4
	block   	.LBB1_2
	i32.call	$push2=, foo, $3, $4
	i32.const	$push0=, 1
	i32.store	$push1=, 12($5), $pop0
	i32.ne  	$push3=, $pop2, $pop1
	br_if   	$pop3, .LBB1_2
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	i32.const	$2=, 16
	i32.add 	$5=, $5, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
	return  	$pop4
.LBB1_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
