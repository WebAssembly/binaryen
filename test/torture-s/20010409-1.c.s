	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010409-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.load8_s	$push2=, 4($1)
	i32.const	$push0=, 25
	i32.mul 	$push1=, $2, $pop0
	i32.add 	$push3=, $pop2, $pop1
	i32.store	c($pop4), $pop3
                                        # fallthrough-return
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
	i32.const	$push1=, .L.str
	i32.const	$push0=, 200
	call    	foo@FUNCTION, $2, $pop1, $pop0
	i32.const	$push2=, 0
	i32.const	$push4=, 65536
	i32.const	$push6=, 0
	i32.load	$push3=, b($pop6)
	i32.select	$push5=, $pop2, $pop4, $pop3
	i32.call	$drop=, bar@FUNCTION, $2, $pop5, $2, $2, $2
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, a
	i32.store	d($pop1), $pop0
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.store	d+4($pop10), $pop9
	i32.const	$push3=, .L.str
	i32.const	$push2=, 200
	call    	foo@FUNCTION, $0, $pop3, $pop2
	i32.const	$push8=, 0
	i32.const	$push5=, 65536
	i32.const	$push7=, 0
	i32.load	$push4=, b($pop7)
	i32.select	$push6=, $pop8, $pop5, $pop4
	i32.call	$drop=, bar@FUNCTION, $0, $pop6, $0, $0, $0
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

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"test"
	.size	.L.str, 5

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0
	.size	a, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
