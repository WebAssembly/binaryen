	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr34768-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.const	$push3=, 0
	i32.load	$push1=, x($pop3)
	i32.sub 	$push2=, $pop4, $pop1
	i32.store	$drop=, x($pop0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.load	$1=, x($pop3)
	i32.const	$push1=, foo@FUNCTION
	i32.const	$push0=, bar@FUNCTION
	i32.select	$push2=, $pop1, $pop0, $0
	call_indirect	$pop2
	i32.const	$push6=, 0
	i32.load	$push4=, x($pop6)
	i32.add 	$push5=, $1, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end2:
	.size	test, .Lfunc_end2-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push3=, 0
	i32.const	$push1=, 1
	i32.store	$push0=, x($pop3), $pop1
	i32.call	$push2=, test@FUNCTION, $pop0
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB3_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	2
x:
	.int32	0                       # 0x0
	.size	x, 4


	.ident	"clang version 3.9.0 "
	.functype	abort, void
