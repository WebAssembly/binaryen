	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031012-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push9=, __stack_pointer
	i32.const	$push6=, __stack_pointer
	i32.load	$push7=, 0($pop6)
	i32.const	$push8=, 15008
	i32.sub 	$push13=, $pop7, $pop8
	i32.store	$push0=, 0($pop9), $pop13
	i32.const	$push2=, 205
	i32.const	$push1=, 13371
	i32.call	$push16=, memset@FUNCTION, $pop0, $pop2, $pop1
	tee_local	$push15=, $3=, $pop16
	i32.const	$push3=, 0
	i32.store8	$2=, 13371($pop15), $pop3
	block
	i32.call	$push4=, strlen@FUNCTION, $3
	i32.const	$push14=, 13371
	i32.ne  	$push5=, $pop4, $pop14
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %foo.exit
	i32.const	$push12=, __stack_pointer
	i32.const	$push10=, 15008
	i32.add 	$push11=, $3, $pop10
	i32.store	$discard=, 0($pop12), $pop11
	return  	$2
.LBB0_2:                                # %if.then.i
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
