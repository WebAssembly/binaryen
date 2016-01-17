	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr34768-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, x($0)
	i32.sub 	$push1=, $0, $pop0
	i32.store	$discard=, x($0), $pop1
	return
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

	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$2=, x($1)
	i32.const	$push1=, foo@FUNCTION
	i32.const	$push0=, bar@FUNCTION
	i32.select	$push2=, $0, $pop1, $pop0
	call_indirect	$pop2
	i32.load	$push3=, x($1)
	i32.add 	$push4=, $pop3, $2
	return  	$pop4
	.endfunc
.Lfunc_end2:
	.size	test, .Lfunc_end2-test

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
	i32.const	$push0=, 1
	i32.store	$push1=, x($0), $pop0
	i32.call	$push2=, test@FUNCTION, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %if.end
	return  	$0
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
	.align	2
x:
	.int32	0                       # 0x0
	.size	x, 4


	.ident	"clang version 3.9.0 "
