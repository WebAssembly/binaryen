	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/vrp-2.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 1
	block
	i32.const	$push5=, 2
	i32.eq  	$push0=, $0, $pop5
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push1=, 31
	i32.shr_s	$push2=, $0, $pop1
	tee_local	$push7=, $1=, $pop2
	i32.add 	$push3=, $0, $pop7
	i32.xor 	$push4=, $pop3, $1
	i32.const	$push6=, 2
	i32.ne  	$1=, $pop4, $pop6
.LBB0_2:                                # %return
	end_block                       # label0:
	return  	$1
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
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
