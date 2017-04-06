	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000313-1.c"
	.section	.text.buggy,"ax",@progbits
	.hidden	buggy
	.globl	buggy
	.type	buggy,@function
buggy:                                  # @buggy
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$1=, 0($0)
	i32.const	$push0=, 0
	i32.store	0($0), $pop0
	i32.const	$push1=, -1
	i32.const	$push3=, 0
	i32.select	$push2=, $pop1, $pop3, $1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	buggy, .Lfunc_end0-buggy

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end3
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
