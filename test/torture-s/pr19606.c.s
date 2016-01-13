	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr19606.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load8_s	$push1=, a($pop0)
	i32.const	$push2=, 1
	i32.shr_u	$push3=, $pop1, $pop2
	return  	$pop3
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load8_s	$push1=, a($pop0)
	i32.const	$push2=, 5
	i32.rem_u	$push3=, $pop1, $pop2
	return  	$pop3
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load8_s	$0=, a($1)
	block
	i32.const	$push0=, 1
	i32.shr_u	$push1=, $0, $pop0
	i32.const	$push2=, 2147483646
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %if.end
	block
	i32.const	$push4=, 5
	i32.rem_u	$push5=, $0, $pop4
	i32.const	$push6=, 2
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, 0        # 0: down to label1
# BB#2:                                 # %if.end7
	call    	exit@FUNCTION, $1
	unreachable
.LBB2_3:                                # %if.then6
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB2_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
a:
	.int8	252                     # 0xfc
	.size	a, 1


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
