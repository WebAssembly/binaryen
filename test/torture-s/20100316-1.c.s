	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20100316-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load16_u	$push0=, 4($0)
	i32.const	$push1=, 1023
	i32.and 	$push2=, $pop0, $pop1
	return  	$pop2
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.load16_u	$0=, f+4($pop9)
	i32.const	$push8=, 0
	i32.const	$push0=, -1
	i32.store	$discard=, f($pop8), $pop0
	i32.const	$push7=, 0
	i32.const	$push2=, 57344
	i32.and 	$push3=, $0, $pop2
	i32.const	$push4=, 7168
	i32.or  	$push5=, $pop3, $pop4
	i32.store16	$discard=, f+4($pop7), $pop5
	block
	i32.const	$push1=, f
	i32.call	$push6=, foo@FUNCTION, $pop1
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push10=, 0
	return  	$pop10
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.skip	8
	.size	f, 8


	.ident	"clang version 3.9.0 "
