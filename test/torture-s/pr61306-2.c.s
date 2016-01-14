	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr61306-2.c"
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
	i32.shr_u	$push9=, $0, $1
	i32.shl 	$push0=, $0, $1
	i32.or  	$push10=, $pop9, $pop0
	i32.shr_u	$push6=, $0, $2
	i32.const	$push7=, 65280
	i32.and 	$push8=, $pop6, $pop7
	i32.or  	$push11=, $pop10, $pop8
	i32.const	$push1=, 16
	i32.shl 	$push2=, $0, $pop1
	i32.shr_s	$push3=, $pop2, $2
	i32.const	$push4=, -65536
	i32.and 	$push5=, $pop3, $pop4
	i32.or  	$push12=, $pop11, $pop5
	return  	$pop12
	.endfunc
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
	i32.const	$push0=, -2122153084
	i32.call	$push1=, fake_bswap32@FUNCTION, $pop0
	i32.const	$push2=, -8158591
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
	.section	".note.GNU-stack","",@progbits
