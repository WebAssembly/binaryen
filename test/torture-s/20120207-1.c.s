	.text
	.file	"20120207-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push9=, 0
	i32.load	$push8=, __stack_pointer($pop9)
	i32.const	$push10=, 16
	i32.sub 	$1=, $pop8, $pop10
	i32.const	$push0=, 0
	i32.load8_u	$push1=, .L.str+10($pop0)
	i32.store8	10($1), $pop1
	i32.const	$push12=, 0
	i32.load16_u	$push2=, .L.str+8($pop12)
	i32.store16	8($1), $pop2
	i32.const	$push11=, 0
	i64.load	$push3=, .L.str($pop11)
	i64.store	0($1), $pop3
	i32.add 	$push4=, $1, $0
	i32.const	$push5=, -1
	i32.add 	$push6=, $pop4, $pop5
	i32.load8_s	$push7=, 0($pop6)
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 2
	i32.call	$push1=, test@FUNCTION, $pop0
	i32.const	$push2=, 49
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.16,"aMS",@progbits,1
	.p2align	4
.L.str:
	.asciz	"0123456789"
	.size	.L.str, 11


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
