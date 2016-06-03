	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040805-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.call	$push1=, foo@FUNCTION
	i32.const	$push0=, 102
	i32.ne  	$push2=, $pop1, $pop0
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foo,"ax",@progbits
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push6=, 0
	i32.load	$push1=, a($pop6)
	i32.store	$0=, a+4($pop0), $pop1
	i32.const	$push2=, 100
	i32.call	$push3=, bar@FUNCTION, $pop2
	i32.call	$push4=, bar@FUNCTION, $0
	i32.add 	$push5=, $pop3, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.bar,"ax",@progbits
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, a($pop4)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$drop=, a($pop0), $pop3
	copy_local	$push5=, $0
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end2:
	.size	bar, .Lfunc_end2-bar

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.size	a, 8


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
