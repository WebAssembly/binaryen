	.text
	.file	"vrp-5.c"
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push5=, 4
	i32.le_u	$push0=, $0, $pop5
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push6=, 4
	i32.le_u	$push1=, $1, $pop6
	br_if   	0, $pop1        # 0: down to label0
# %bb.2:                                # %if.end3
	i32.const	$push2=, 0
	i32.sub 	$push3=, $pop2, $1
	i32.ne  	$push4=, $pop3, $0
	br_if   	0, $pop4        # 0: down to label0
# %bb.3:                                # %if.end6
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
