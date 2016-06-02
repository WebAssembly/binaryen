	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20100708-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 8
	i32.add 	$push1=, $0, $pop0
	i32.const	$push3=, 0
	i32.const	$push2=, 192
	i32.call	$drop=, memset@FUNCTION, $pop1, $pop3, $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push1=, 0
	i32.load	$push2=, __stack_pointer($pop1)
	i32.const	$push3=, 208
	i32.sub 	$push10=, $pop2, $pop3
	i32.store	$push12=, __stack_pointer($pop4), $pop10
	tee_local	$push11=, $0=, $pop12
	i32.const	$push8=, 8
	i32.add 	$push9=, $pop11, $pop8
	call    	f@FUNCTION, $pop9
	i32.const	$push7=, 0
	i32.const	$push5=, 208
	i32.add 	$push6=, $0, $pop5
	i32.store	$drop=, __stack_pointer($pop7), $pop6
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
