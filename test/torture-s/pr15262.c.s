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
	i32.store	$drop=, 0($0), $pop0
                                        # fallthrough-return
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
	i32.const	$push3=, 0
	i32.load	$3=, __stack_pointer($pop3)
	i32.const	$push0=, 1
	i32.store	$0=, 4($0), $pop0
	i32.const	$push4=, 16
	i32.sub 	$push10=, $3, $pop4
	tee_local	$push9=, $3=, $pop10
	i32.const	$push5=, 8
	i32.add 	$push6=, $pop9, $pop5
	i32.const	$push7=, 12
	i32.add 	$push8=, $3, $pop7
	i32.select	$push1=, $pop6, $pop8, $1
	i32.const	$push2=, 1084647014
	i32.store	$drop=, 0($pop1), $pop2
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
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
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
