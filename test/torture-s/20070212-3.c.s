	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20070212-3.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.add 	$push1=, $0, $pop0
	i32.select	$push7=, $0, $pop1, $2
	tee_local	$push6=, $2=, $pop7
	i32.load	$4=, 0($pop6)
	i32.const	$push2=, 1
	i32.store	$drop=, 0($0), $pop2
	i32.load	$push3=, 0($2)
	i32.select	$push4=, $pop3, $1, $3
	i32.add 	$push5=, $4, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

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
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 "
