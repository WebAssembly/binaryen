	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001013-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.const	$push0=, 255
	i32.and 	$push1=, $1, $pop0
	i32.ne  	$push2=, $pop1, $1
	br_if   	$pop2, .LBB0_2
# BB#1:                                 # %lor.lhs.false
	i32.load	$push7=, 0($0)
	i32.const	$push5=, 0
	i32.load	$push4=, 4($0)
	i32.sub 	$push6=, $pop5, $pop4
	i32.le_s	$push8=, $pop7, $pop6
	return  	$pop8
.LBB0_2:                                # %return
	i32.const	$push3=, 1
	return  	$pop3
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
	i32.const	$0=, 0
	block   	.LBB1_2
	i32.load	$push2=, z($0)
	i32.load	$push0=, z+4($0)
	i32.sub 	$push1=, $0, $pop0
	i32.le_s	$push3=, $pop2, $pop1
	br_if   	$pop3, .LBB1_2
# BB#1:                                 # %if.end
	call    	exit@FUNCTION, $0
	unreachable
.LBB1_2:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	z                       # @z
	.type	z,@object
	.section	.data.z,"aw",@progbits
	.globl	z
	.align	2
z:
	.int32	4294963268              # 0xfffff044
	.int32	4096                    # 0x1000
	.size	z, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
