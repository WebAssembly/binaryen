	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001111-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 52783
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load8_u	$push1=, next_buffer($pop5)
	i32.select	$push3=, $pop2, $pop0, $pop1
	i32.add 	$push4=, $pop3, $0
	return  	$pop4
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push2=, 0
	i32.load8_u	$push0=, next_buffer($pop2)
	i32.const	$push5=, 0
	i32.eq  	$push6=, $pop0, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB2_2:                                # %if.end4
	end_block                       # label0:
	i32.const	$push4=, 0
	i32.const	$push1=, 1
	i32.store8	$discard=, next_buffer($pop4), $pop1
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	next_buffer,@object     # @next_buffer
	.lcomm	next_buffer,1,2

	.ident	"clang version 3.9.0 "
