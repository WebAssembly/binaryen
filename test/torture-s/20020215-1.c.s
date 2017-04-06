	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020215-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1)
	i32.store	0($0), $pop0
	i32.load	$push1=, 4($1)
	i32.const	$push2=, 1
	i32.add 	$push11=, $pop1, $pop2
	tee_local	$push10=, $2=, $pop11
	i32.store	4($1), $pop10
	i32.const	$push3=, 8
	i32.add 	$push4=, $0, $pop3
	i32.const	$push9=, 8
	i32.add 	$push5=, $1, $pop9
	i32.load	$push6=, 0($pop5)
	i32.store	0($pop4), $pop6
	i32.const	$push7=, 4
	i32.add 	$push8=, $0, $pop7
	i32.store	0($pop8), $2
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	exit, void, i32
