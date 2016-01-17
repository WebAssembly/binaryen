	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021204-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block
	i32.load	$push0=, z($2)
	i32.const	$push1=, 1
	i32.ge_s	$push2=, $pop0, $pop1
	br_if   	$pop2, 0        # 0: down to label1
# BB#1:                                 # %foo.exit
	call    	exit@FUNCTION, $2
	unreachable
.LBB1_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	z                       # @z
	.type	z,@object
	.section	.bss.z,"aw",@nobits
	.globl	z
	.align	2
z:
	.int32	0                       # 0x0
	.size	z, 4


	.ident	"clang version 3.9.0 "
