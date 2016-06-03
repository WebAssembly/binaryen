	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930208-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load8_u	$push0=, 3($0)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store8	$drop=, 3($0), $pop2
	i32.load	$push8=, 0($0)
	i32.const	$push9=, 16711680
	i32.and 	$push10=, $pop8, $pop9
	i32.const	$push11=, 131072
	i32.ne  	$push12=, $pop10, $pop11
	i32.load16_u	$push3=, 0($0)
	i32.const	$push4=, 65280
	i32.and 	$push5=, $pop3, $pop4
	i32.const	$push6=, 512
	i32.ne  	$push7=, $pop5, $pop6
	i32.or  	$push13=, $pop12, $pop7
                                        # fallthrough-return: $pop13
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

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


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
