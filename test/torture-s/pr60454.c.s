	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr60454.c"
	.section	.text.fake_swap32,"ax",@progbits
	.hidden	fake_swap32
	.globl	fake_swap32
	.type	fake_swap32,@function
fake_swap32:                            # @fake_swap32
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 65280
	i32.and 	$push3=, $0, $pop2
	tee_local	$push16=, $1=, $pop3
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
	i32.or  	$push9=, $pop16, $pop1
	i32.const	$push15=, 24
	i32.shr_u	$push8=, $0, $pop15
	i32.or  	$push10=, $pop9, $pop8
	i32.const	$push4=, 8
	i32.shl 	$push5=, $1, $pop4
	i32.or  	$push11=, $pop10, $pop5
	i32.const	$push14=, 8
	i32.shl 	$push6=, $0, $pop14
	i32.const	$push13=, 65280
	i32.and 	$push7=, $pop6, $pop13
	i32.or  	$push12=, $pop11, $pop7
	return  	$pop12
	.endfunc
.Lfunc_end0:
	.size	fake_swap32, .Lfunc_end0-fake_swap32

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 305419896
	i32.call	$push1=, fake_swap32@FUNCTION, $pop0
	i32.const	$push2=, 2018934290
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
