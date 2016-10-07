	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr60454.c"
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
	i32.and 	$push16=, $0, $pop2
	tee_local	$push15=, $1=, $pop16
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
	i32.or  	$push3=, $pop15, $pop1
	i32.const	$push14=, 24
	i32.shr_u	$push4=, $0, $pop14
	i32.or  	$push5=, $pop3, $pop4
	i32.const	$push6=, 8
	i32.shl 	$push7=, $1, $pop6
	i32.or  	$push8=, $pop5, $pop7
	i32.const	$push13=, 8
	i32.shl 	$push9=, $0, $pop13
	i32.const	$push12=, 65280
	i32.and 	$push10=, $pop9, $pop12
	i32.or  	$push11=, $pop8, $pop10
                                        # fallthrough-return: $pop11
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
