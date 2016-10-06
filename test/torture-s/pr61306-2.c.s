	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr61306-2.c"
	.section	.text.fake_bswap32,"ax",@progbits
	.hidden	fake_bswap32
	.globl	fake_bswap32
	.type	fake_bswap32,@function
fake_bswap32:                           # @fake_bswap32
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 24
	i32.shr_u	$push2=, $0, $pop0
	i32.const	$push16=, 24
	i32.shl 	$push1=, $0, $pop16
	i32.or  	$push3=, $pop2, $pop1
	i32.const	$push4=, 8
	i32.shr_u	$push5=, $0, $pop4
	i32.const	$push6=, 65280
	i32.and 	$push7=, $pop5, $pop6
	i32.or  	$push8=, $pop3, $pop7
	i32.const	$push9=, 16
	i32.shl 	$push10=, $0, $pop9
	i32.const	$push15=, 8
	i32.shr_s	$push11=, $pop10, $pop15
	i32.const	$push12=, -65536
	i32.and 	$push13=, $pop11, $pop12
	i32.or  	$push14=, $pop8, $pop13
                                        # fallthrough-return: $pop14
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
	br_if   	0, $pop3        # 0: down to label0
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
