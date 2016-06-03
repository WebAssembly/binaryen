	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120207-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, .L.str-1
	i32.add 	$push1=, $0, $pop0
	i32.load8_s	$push2=, 0($pop1)
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 2
	i32.call	$push1=, test@FUNCTION, $pop0
	i32.const	$push2=, 255
	i32.and 	$push3=, $pop1, $pop2
	i32.const	$push4=, 49
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	return  	$pop6
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.16,"aMS",@progbits,1
	.p2align	4
.L.str:
	.asciz	"0123456789"
	.size	.L.str, 11


	.ident	"clang version 3.9.0 "
	.functype	abort, void
