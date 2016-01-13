	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr61306-1.c"
	.section	.text.fake_bswap32,"ax",@progbits
	.hidden	fake_bswap32
	.globl	fake_bswap32
	.type	fake_bswap32,@function
fake_bswap32:                           # @fake_bswap32
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 8
	i32.const	$1=, 24
	i32.shr_s	$push7=, $0, $1
	i32.shl 	$push0=, $0, $1
	i32.or  	$push8=, $pop7, $pop0
	i32.shl 	$push1=, $0, $2
	i32.const	$push2=, 16711680
	i32.and 	$push3=, $pop1, $pop2
	i32.or  	$push9=, $pop8, $pop3
	i32.shr_u	$push4=, $0, $2
	i32.const	$push5=, 65280
	i32.and 	$push6=, $pop4, $pop5
	i32.or  	$push10=, $pop9, $pop6
	return  	$pop10
.Lfunc_end0:
	.size	fake_bswap32, .Lfunc_end0-fake_bswap32

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, -2023406815
	i32.call	$push1=, fake_bswap32@FUNCTION, $pop0
	i32.const	$push2=, -121
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
