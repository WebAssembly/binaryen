	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010409-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.load8_s	$push0=, 4($1)
	i32.const	$push1=, 25
	i32.mul 	$push2=, $2, $pop1
	i32.add 	$push3=, $pop0, $pop2
	i32.store	$discard=, c($pop4), $pop3
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	br_if   	0, $1           # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.load	$2=, b($pop2)
	i32.const	$push1=, 0
	i32.const	$push0=, 5000
	i32.store	$discard=, c($pop1), $pop0
	block
	br_if   	0, $2           # 0: down to label1
# BB#1:                                 # %if.then.i
	call    	abort@FUNCTION
	unreachable
.LBB2_2:                                # %if.end.i
	end_block                       # label1:
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end2:
	.size	test, .Lfunc_end2-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.store	$push4=, d+4($pop0), $pop5
	tee_local	$push3=, $1=, $pop4
	i32.load	$0=, b($pop3)
	i32.const	$push1=, a
	i32.store	$discard=, d($1), $pop1
	i32.const	$push2=, 5000
	i32.store	$discard=, c($1), $pop2
	block
	br_if   	0, $0           # 0: down to label2
# BB#1:                                 # %if.then.i.i
	call    	abort@FUNCTION
	unreachable
.LBB3_2:                                # %if.end.i.i
	end_block                       # label2:
	call    	exit@FUNCTION, $1
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.p2align	2
b:
	.int32	1                       # 0x1
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.skip	8
	.size	d, 8

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0
	.size	a, 4


	.ident	"clang version 3.9.0 "
