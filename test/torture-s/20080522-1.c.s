	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20080522-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$push0=, 1
	i32.store	$discard=, i($1), $pop0
	i32.const	$push1=, 2
	i32.store	$discard=, 0($0), $pop1
	i32.load	$push2=, i($1)
	return  	$pop2
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.store	$discard=, 0($0), $pop0
	i32.const	$push1=, 0
	i32.const	$push2=, 1
	i32.store	$discard=, i($pop1), $pop2
	i32.load	$push3=, 0($0)
	return  	$pop3
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$9=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$9=, 0($5), $9
	i32.const	$1=, i
	i32.const	$push0=, 0
	i32.store	$0=, 12($9), $pop0
	i32.call	$2=, foo, $1
	i32.const	$3=, 2
	block   	.LBB2_12
	i32.ne  	$push1=, $2, $3
	br_if   	$pop1, .LBB2_12
# BB#1:                                 # %if.end
	i32.call	$2=, bar, $1
	i32.const	$1=, 1
	block   	.LBB2_11
	i32.ne  	$push2=, $2, $1
	br_if   	$pop2, .LBB2_11
# BB#2:                                 # %if.end4
	i32.const	$7=, 12
	i32.add 	$7=, $9, $7
	block   	.LBB2_10
	i32.call	$push3=, foo, $7
	i32.ne  	$push4=, $pop3, $1
	br_if   	$pop4, .LBB2_10
# BB#3:                                 # %if.end8
	block   	.LBB2_9
	i32.load	$push5=, 12($9)
	i32.ne  	$push6=, $pop5, $3
	br_if   	$pop6, .LBB2_9
# BB#4:                                 # %if.end11
	i32.const	$8=, 12
	i32.add 	$8=, $9, $8
	block   	.LBB2_8
	i32.call	$push7=, bar, $8
	i32.ne  	$push8=, $pop7, $3
	br_if   	$pop8, .LBB2_8
# BB#5:                                 # %if.end15
	block   	.LBB2_7
	i32.load	$push9=, 12($9)
	i32.ne  	$push10=, $pop9, $3
	br_if   	$pop10, .LBB2_7
# BB#6:                                 # %if.end18
	i32.const	$6=, 16
	i32.add 	$9=, $9, $6
	i32.const	$6=, __stack_pointer
	i32.store	$9=, 0($6), $9
	return  	$0
.LBB2_7:                                # %if.then17
	call    	abort
	unreachable
.LBB2_8:                                # %if.then14
	call    	abort
	unreachable
.LBB2_9:                                # %if.then10
	call    	abort
	unreachable
.LBB2_10:                               # %if.then7
	call    	abort
	unreachable
.LBB2_11:                               # %if.then3
	call    	abort
	unreachable
.LBB2_12:                               # %if.then
	call    	abort
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	i,@object               # @i
	.lcomm	i,4,2

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
