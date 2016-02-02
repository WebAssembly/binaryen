	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000503-1.c"
	.section	.text.sub,"ax",@progbits
	.hidden	sub
	.globl	sub
	.type	sub,@function
sub:                                    # @sub
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -2
	i32.add 	$push1=, $0, $pop0
	tee_local	$push8=, $0=, $pop1
	i32.const	$push2=, 0
	i32.lt_s	$push3=, $pop8, $pop2
	i32.const	$push7=, 0
	i32.select	$push4=, $pop3, $pop7, $0
	i32.const	$push5=, 2
	i32.shl 	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end0:
	.size	sub, .Lfunc_end0-sub

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
