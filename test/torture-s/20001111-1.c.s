	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001111-1.c"
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
	i32.load8_u	$push0=, next_buffer($1)
	i32.const	$push1=, 52783
	i32.select	$push2=, $pop0, $pop1, $1
	i32.add 	$push3=, $pop2, $0
	return  	$pop3
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
# BB#0:                                 # %entry
	return
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.load8_u	$push0=, next_buffer($0)
	i32.const	$push2=, 0
	i32.eq  	$push3=, $pop0, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB2_2:                                # %if.end4
	end_block                       # label0:
	i32.const	$push1=, 1
	i32.store8	$discard=, next_buffer($0), $pop1
	call    	exit@FUNCTION, $0
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	next_buffer,@object     # @next_buffer
	.lcomm	next_buffer,1

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
