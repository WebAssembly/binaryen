	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr23047.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 31
	i32.shr_s	$push1=, $0, $pop0
	tee_local	$push6=, $1=, $pop1
	i32.add 	$push2=, $0, $pop6
	i32.xor 	$push3=, $pop2, $1
	i32.const	$push4=, -1
	i32.gt_s	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.then
	return
.LBB0_2:                                # %if.end
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -2147483648
	call    	f@FUNCTION, $pop0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
