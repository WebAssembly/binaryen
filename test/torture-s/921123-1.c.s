	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/921123-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load16_u	$push0=, 0($0)
	i32.const	$push1=, -1
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, 32768
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 15
	i32.shr_u	$push6=, $pop4, $pop5
                                        # fallthrough-return: $pop6
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
