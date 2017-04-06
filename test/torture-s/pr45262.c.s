	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr45262.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 1
	i32.const	$push0=, 0
	i32.sub 	$push2=, $pop0, $0
	i32.const	$push3=, 31
	i32.shr_u	$push4=, $pop2, $pop3
	i32.const	$push7=, 0
	i32.lt_s	$push1=, $0, $pop7
	i32.select	$push6=, $pop5, $pop4, $pop1
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 1
	i32.const	$push0=, 0
	i32.sub 	$push2=, $pop0, $0
	i32.const	$push3=, 31
	i32.shr_u	$push4=, $pop2, $pop3
	i32.const	$push7=, 0
	i32.lt_s	$push1=, $0, $pop7
	i32.select	$push6=, $pop5, $pop4, $pop1
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end20
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
