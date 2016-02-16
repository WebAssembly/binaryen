	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960317-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push8=, 0
	i32.const	$push7=, -1
	i32.shl 	$push6=, $pop7, $0
	tee_local	$push5=, $0=, $pop6
	i32.sub 	$push0=, $pop8, $pop5
	i32.and 	$push1=, $1, $pop0
	i32.const	$push12=, 0
	i32.eq  	$push13=, $pop1, $pop12
	br_if   	0, $pop13       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push10=, -1
	i32.xor 	$push2=, $0, $pop10
	i32.and 	$push3=, $1, $pop2
	i32.const	$push9=, 0
	i32.ne  	$push4=, $pop3, $pop9
	return  	$pop4
.LBB0_2:                                # %cleanup
	end_block                       # label0:
	i32.const	$push11=, 0
	return  	$pop11
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
