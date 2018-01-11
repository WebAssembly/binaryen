	.text
	.file	"20040820-1.c"
	.section	.text.check,"ax",@progbits
	.hidden	check                   # -- Begin function check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check
                                        # -- End function
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push1=, 2
	i32.const	$push0=, 0
	i32.select	$push2=, $pop1, $pop0, $1
	i32.const	$push7=, 0
	i32.ne  	$push3=, $0, $pop7
	i32.or  	$push4=, $pop2, $pop3
	i32.const	$push5=, 1
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label1
# %bb.1:                                # %check.exit
	return
.LBB1_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	test, .Lfunc_end1-test
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
