	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr15262.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1084647014
	i32.store	$discard=, 0($0), $pop0
	return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, __stack_pointer
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push12=, $pop5, $pop6
	tee_local	$push11=, $3=, $pop12
	i32.const	$push7=, 8
	i32.add 	$push8=, $pop11, $pop7
	i32.const	$push9=, 12
	i32.add 	$push10=, $3, $pop9
	i32.select	$push1=, $pop8, $pop10, $1
	i32.const	$push2=, 1084647014
	i32.store	$discard=, 0($pop1), $pop2
	i32.const	$push3=, 1
	i32.store	$push0=, 4($0), $pop3
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
