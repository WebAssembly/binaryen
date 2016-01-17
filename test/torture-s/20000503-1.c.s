	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000503-1.c"
	.section	.text.sub,"ax",@progbits
	.hidden	sub
	.globl	sub
	.type	sub,@function
sub:                                    # @sub
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -2
	i32.add 	$0=, $0, $pop0
	i32.const	$1=, 0
	i32.lt_s	$push1=, $0, $1
	i32.select	$push2=, $pop1, $1, $0
	i32.const	$push3=, 2
	i32.shl 	$push4=, $pop2, $pop3
	return  	$pop4
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
