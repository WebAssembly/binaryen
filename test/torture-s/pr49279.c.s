	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49279.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	return  	$0
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.const	$push1=, 4
	i32.const	$6=, 8
	i32.add 	$6=, $6, $6
	i32.or  	$2=, $6, $pop1
	i32.store	$discard=, 0($2), $0
	i32.const	$push0=, 1
	i32.store	$0=, 8($6), $pop0
	i32.const	$7=, 8
	i32.add 	$7=, $6, $7
	i32.call	$push2=, bar@FUNCTION, $7
	i32.store	$discard=, 4($pop2), $1
	i32.load	$2=, 0($2)
	i32.const	$push3=, 0
	i32.store	$discard=, 0($2), $pop3
	i32.store	$discard=, 0($1), $0
	i32.load	$push4=, 0($2)
	i32.const	$5=, 16
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return  	$pop4
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

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
	i32.const	$4=, 8
	i32.add 	$4=, $5, $4
	block   	.LBB2_2
	i32.call	$push0=, foo@FUNCTION, $3, $4
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB2_2
# BB#1:                                 # %if.end
	i32.const	$push3=, 0
	i32.const	$2=, 16
	i32.add 	$5=, $5, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
	return  	$pop3
.LBB2_2:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
