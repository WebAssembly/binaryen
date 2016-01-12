	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr51466.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$4=, 0
	i32.add 	$4=, $4, $4
	i32.add 	$push2=, $4, $pop1
	i32.const	$push3=, 6
	i32.store	$push4=, 0($pop2), $pop3
	i32.const	$3=, 16
	i32.add 	$4=, $4, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	return  	$pop4
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$4=, 0
	i32.add 	$4=, $4, $4
	i32.add 	$0=, $4, $pop1
	i32.const	$push2=, 6
	i32.store	$discard=, 0($0), $pop2
	i32.const	$push3=, 8
	i32.store	$discard=, 0($0), $pop3
	i32.load	$push4=, 0($0)
	i32.const	$3=, 16
	i32.add 	$4=, $4, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	return  	$pop4
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.baz,"ax",@progbits
	.hidden	baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$4=, 0
	i32.add 	$4=, $4, $4
	i32.add 	$0=, $4, $pop1
	i32.const	$push2=, 6
	i32.store	$discard=, 0($0), $pop2
	i32.const	$push3=, 8
	i32.store	$discard=, 0($4), $pop3
	i32.load	$push4=, 0($0)
	i32.const	$3=, 16
	i32.add 	$4=, $4, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	return  	$pop4
.Lfunc_end2:
	.size	baz, .Lfunc_end2-baz

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 3
	i32.call	$discard=, foo@FUNCTION, $pop0
	i32.const	$push1=, 2
	i32.call	$1=, bar@FUNCTION, $pop1
	i32.const	$0=, 8
	block   	.LBB3_4
	i32.ne  	$push2=, $1, $0
	br_if   	$pop2, .LBB3_4
# BB#1:                                 # %lor.lhs.false3
	i32.const	$1=, 0
	i32.call	$push3=, baz@FUNCTION, $1
	i32.ne  	$push4=, $pop3, $0
	br_if   	$pop4, .LBB3_4
# BB#2:                                 # %lor.lhs.false6
	i32.const	$push5=, 1
	i32.call	$push6=, baz@FUNCTION, $pop5
	i32.const	$push7=, 6
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, .LBB3_4
# BB#3:                                 # %if.end
	return  	$1
.LBB3_4:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
